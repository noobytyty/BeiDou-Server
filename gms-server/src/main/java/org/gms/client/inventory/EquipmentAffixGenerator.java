package org.gms.client.inventory;

import org.gms.constants.inventory.ItemConstants;
import org.gms.server.life.Element;
import org.gms.server.ItemInformationProvider;
import org.gms.util.Randomizer;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public final class EquipmentAffixGenerator {
    private static final String MAIN_AFFIX_GROUP = "MAIN";
    private static final String SECONDARY_AFFIX_GROUP = "SECONDARY";
    private static volatile EquipmentAffixConfig config;

    private EquipmentAffixGenerator() {
    }

    private static String elementalAffixCode(Element element) {
        return switch (element) {
            case FIRE -> "FIRE_DAMAGE";
            case ICE -> "ICE_DAMAGE";
            case LIGHTING -> "LIGHTNING_DAMAGE";
            case HOLY -> "HOLY_DAMAGE";
            default -> "";
        };
    }

    public static Equip generate(Equip equip) {
        return generate(equip, EquipmentDropSource.NORMAL);
    }

    public static Equip generate(Equip equip, EquipmentDropSource source) {
        if (equip.getRarity() != 0 || !equip.getAffixes().isEmpty()) {
            return equip;
        }

        String equipType = resolveEquipType(equip.getItemId());
        if (equipType == null) {
            return equip;
        }

        EquipmentAffixConfig loadedConfig = getConfig();
        EquipmentAffixConfig.Rarity rarity = chooseRarity(loadedConfig.rarities(), source);
        equip.setRarity(rarity.rarity());
        if (rarity.affixCount() == 0) {
            return equip;
        }

        equip.setAffixes(generateAffixes(equip, rarity, List.of()));
        return equip;
    }

    public static Equip reroll(Equip equip, boolean preserveLocked) {
        EquipmentAffixConfig.Rarity rarity = getConfig().rarities().stream()
                .filter(item -> item.rarity() == equip.getRarity())
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("Unknown equipment rarity: " + equip.getRarity()));
        List<EquipmentAffix> locked = preserveLocked
                ? equip.getAffixes().stream().filter(EquipmentAffix::isLocked).toList()
                : List.of();
        equip.setAffixes(generateAffixes(equip, rarity, locked));
        return equip;
    }

    private static List<EquipmentAffix> generateAffixes(
            Equip equip,
            EquipmentAffixConfig.Rarity rarity,
            List<EquipmentAffix> preserved
    ) {
        String equipType = resolveEquipType(equip.getItemId());
        if (equipType == null || rarity.affixCount() == 0) {
            return List.of();
        }

        EquipmentAffixConfig loadedConfig = getConfig();
        Map<String, EquipmentAffixConfig.Definition> definitions = new HashMap<>();
        for (EquipmentAffixConfig.Definition definition : loadedConfig.definitions()) {
            definitions.put(definition.affixCode(), definition);
        }
        int reqLevel = ItemInformationProvider.getInstance().getEquipLevelReq(equip.getItemId());
        int meanAffixTier = meanTierForLevel(reqLevel);
        int tierRadius = tierRadiusForLevel(reqLevel);
        int minAffixTier = Math.max(1, meanAffixTier - tierRadius);
        int maxAffixTier = Math.min(12, meanAffixTier + tierRadius);
        List<EquipmentAffixConfig.PoolEntry> candidates = levelCandidates(loadedConfig, equipType, reqLevel);
        candidates = candidates.stream()
                .filter(entry -> isAffixCompatibleWithJob(entry.affixCode(),
                        ItemInformationProvider.getInstance().getEquipStats(equip.getItemId()).getOrDefault("reqJob", 0)))
                .filter(entry -> isElementalAffixCompatible(entry.affixCode(), equip.getItemId()))
                .toList();
        candidates = candidates.stream()
                .filter(entry -> loadedConfig.ranges().stream()
                        .anyMatch(range -> range.affixCode().equals(entry.affixCode())
                                && range.affixTier() >= minAffixTier
                                && range.affixTier() <= maxAffixTier))
                .filter(entry -> definitions.containsKey(entry.affixCode()))
                .toList();
        List<EquipmentAffix> affixes = new ArrayList<>(preserved);
        Set<String> selectedMainCodes = selectedCodes(preserved, candidates, MAIN_AFFIX_GROUP);
        Set<String> selectedSecondaryCodes = selectedCodes(preserved, candidates, SECONDARY_AFFIX_GROUP);
        int nextSlot = preserved.stream()
                .mapToInt(EquipmentAffix::getSlotIndex)
                .max()
                .orElse(-1) + 1;

        nextSlot = appendAffixes(
                affixes, nextSlot,
                Math.max(0, rarity.mainAffixCount() + (isOverall(equip) ? 1 : 0) - selectedMainCodes.size()),
                MAIN_AFFIX_GROUP,
                candidates, selectedMainCodes, loadedConfig.ranges(), meanAffixTier,
                tierRadius, minAffixTier, maxAffixTier, reqLevel, definitions, equip.getItemId());
        appendAffixes(
                affixes, nextSlot,
                Math.max(0, rarity.secondaryAffixCount() - selectedSecondaryCodes.size()),
                SECONDARY_AFFIX_GROUP,
                candidates, selectedSecondaryCodes, loadedConfig.ranges(), meanAffixTier,
                tierRadius, minAffixTier, maxAffixTier, reqLevel, definitions, equip.getItemId());
        return affixes;
    }

    private static boolean isOverall(Equip equip) {
        return equip.getItemId() / 10000 == 105;
    }

    private static boolean isAffixCompatibleWithJob(String affixCode, int reqJob) {
        if (reqJob == 0) {
            return true;
        }
        return switch (reqJob) {
            case 2 -> !containsAny(affixCode, "INT", "MATK", "LUK", "DEX");
            case 4 -> !containsAny(affixCode, "STR", "WATK", "LUK", "DEX");
            case 8 -> !containsAny(affixCode, "STR", "INT", "MATK", "LUK");
            case 16 -> !containsAny(affixCode, "STR", "INT", "MATK", "DEX");
            case 32 -> !containsAny(affixCode, "INT", "MATK", "LUK");
            default -> true;
        };
    }

    private static boolean containsAny(String affixCode, String... fragments) {
        for (String fragment : fragments) {
            if (affixCode.contains(fragment)) {
                return true;
            }
        }
        return false;
    }

    private static boolean isElementalAffixCompatible(String affixCode, int itemId) {
        if (!isElementalAffix(affixCode)) {
            return true;
        }
        if (!ElementalWeaponRegistry.isWandOrStaff(itemId)) {
            return false;
        }
        Element weaponElement = ElementalWeaponRegistry.elementOf(itemId);
        if (weaponElement == null) {
            return true;
        }
        return elementalAffixCode(weaponElement).equals(affixCode);
    }

    private static boolean isElementalAffix(String affixCode) {
        return switch (affixCode) {
            case "FIRE_DAMAGE", "ICE_DAMAGE", "LIGHTNING_DAMAGE", "HOLY_DAMAGE" -> true;
            default -> false;
        };
    }

    private static int appendAffixes(
            List<EquipmentAffix> affixes,
            int nextSlot,
            int affixCount,
            String affixGroup,
            List<EquipmentAffixConfig.PoolEntry> candidates,
            Set<String> selectedCodes,
            List<EquipmentAffixConfig.Range> ranges,
            int meanAffixTier,
            int tierRadius,
            int minAffixTier,
            int maxAffixTier,
            int reqLevel,
            Map<String, EquipmentAffixConfig.Definition> definitions,
            int itemId
    ) {
        List<EquipmentAffixConfig.PoolEntry> groupCandidates = candidates.stream()
                .filter(entry -> affixGroup.equals(entry.affixGroup()))
                .toList();
        for (int slot = 0; slot < affixCount && !groupCandidates.isEmpty(); slot++) {
            EquipmentAffixConfig.PoolEntry selected = choosePoolEntry(
                    groupCandidates, selectedCodes, ranges, minAffixTier, maxAffixTier, definitions, itemId);
            if (selected == null) {
                break;
            }
            EquipmentAffixConfig.Range range = chooseRange(
                    ranges, selected.affixCode(), meanAffixTier, tierRadius, minAffixTier, maxAffixTier);
            int value = Randomizer.nextInt(range.maxValue() - range.minValue() + 1) + range.minValue();
            value = applyLowLevelTierDiscount(value, reqLevel, meanAffixTier, range.affixTier());
            affixes.add(EquipmentAffix.builder()
                    .slotIndex(nextSlot++)
                    .affixCode(selected.affixCode())
                    .affixTier(range.affixTier())
                    .value(value)
                    .rollSeed(Randomizer.nextInt(Integer.MAX_VALUE))
                    .build());
            selectedCodes.add(selected.affixCode());
        }
        return nextSlot;
    }

    private static int applyLowLevelTierDiscount(
            int value,
            int reqLevel,
            int meanAffixTier,
            int affixTier
    ) {
        if (reqLevel >= 80 || affixTier <= meanAffixTier) {
            return value;
        }
        double multiplier = Math.pow(0.85, affixTier - meanAffixTier);
        return Math.max(1, (int) Math.round(value * multiplier));
    }

    private static Set<String> selectedCodes(
            List<EquipmentAffix> preserved,
            List<EquipmentAffixConfig.PoolEntry> candidates,
            String affixGroup
    ) {
        Set<String> selectedCodes = new HashSet<>();
        preserved.stream()
                .filter(affix -> belongsToGroup(affix.getAffixCode(), candidates, affixGroup))
                .map(EquipmentAffix::getAffixCode)
                .forEach(selectedCodes::add);
        return selectedCodes;
    }

    private static boolean belongsToGroup(
            String affixCode,
            List<EquipmentAffixConfig.PoolEntry> candidates,
            String affixGroup
    ) {
        if (candidates.stream().anyMatch(candidate -> candidate.affixCode().equals(affixCode)
                && affixGroup.equals(candidate.affixGroup()))) {
            return true;
        }
        return MAIN_AFFIX_GROUP.equals(affixGroup) && !isSecondaryAffix(affixCode);
    }

    private static boolean isSecondaryAffix(String affixCode) {
        return switch (affixCode) {
            case "ACC", "AVOID", "SPEED", "JUMP", "BOSS_DAMAGE", "IGNORE_DEFENSE",
                    "DROP_RATE", "EXP_RATE", "MESO_RATE", "BOSS_DAMAGE_REDUCTION",
                    "ACC_AVOID", "SPEED_JUMP" -> true;
            default -> false;
        };
    }

    private static int meanTierForLevel(int reqLevel) {
        return Math.min(12, Math.max(1, reqLevel / 10 + 1));
    }

    private static int tierRadiusForLevel(int reqLevel) {
        if (reqLevel >= 120) {
            return 5;
        }
        if (reqLevel >= 80) {
            return 4;
        }
        return 3;
    }

    private static List<EquipmentAffixConfig.PoolEntry> levelCandidates(
            EquipmentAffixConfig loadedConfig,
            String equipType,
            int reqLevel
    ) {
        List<EquipmentAffixConfig.LevelPoolEntry> levelEntries = loadedConfig.levelPoolEntries().stream()
                .filter(entry -> entry.equipType().equals(equipType))
                .filter(entry -> reqLevel >= entry.minReqLevel() && reqLevel <= entry.maxReqLevel())
                .toList();
        if (!levelEntries.isEmpty()) {
            return levelEntries.stream()
                    .map(entry -> new EquipmentAffixConfig.PoolEntry(
                            entry.equipType(), entry.affixCode(), entry.affixGroup(), entry.weight()))
                    .toList();
        }
        return loadedConfig.poolEntries().stream()
                .filter(entry -> entry.equipType().equals(equipType))
                .toList();
    }

    public static void reload() {
        config = null;
    }

    public static String getAffixNameKey(String affixCode, int affixTier) {
        return getConfig().names().stream()
                .filter(name -> name.affixCode().equals(affixCode) && name.affixTier() == affixTier)
                .map(EquipmentAffixConfig.Name::nameKey)
                .findFirst()
                .orElse(null);
    }

    private static EquipmentAffixConfig getConfig() {
        EquipmentAffixConfig loaded = config;
        if (loaded != null) {
            return loaded;
        }
        synchronized (EquipmentAffixGenerator.class) {
            if (config == null) {
                try {
                    config = EquipmentAffixConfigLoader.load();
                } catch (SQLException e) {
                    throw new IllegalStateException("Unable to load equipment affix configuration.", e);
                }
            }
            return config;
        }
    }

    private static EquipmentAffixConfig.Rarity chooseRarity(
            List<EquipmentAffixConfig.Rarity> rarities,
            EquipmentDropSource source
    ) {
        int totalWeight = rarities.stream().mapToInt(rarity -> getDropWeight(rarity, source)).sum();
        if (totalWeight <= 0) {
            throw new IllegalStateException("Equipment rarity configuration has no positive drop weight.");
        }
        int roll = Randomizer.nextInt(totalWeight);
        for (EquipmentAffixConfig.Rarity rarity : rarities) {
            roll -= getDropWeight(rarity, source);
            if (roll < 0) {
                return rarity;
            }
        }
        throw new IllegalStateException("Equipment rarity selection failed.");
    }

    private static int getDropWeight(EquipmentAffixConfig.Rarity rarity, EquipmentDropSource source) {
        return switch (source) {
            case NORMAL -> rarity.dropWeight();
            case BOSS -> rarity.bossDropWeight();
            case DUNGEON -> rarity.dungeonDropWeight();
            case GACHAPON -> rarity.gachaponDropWeight();
        };
    }

    private static EquipmentAffixConfig.PoolEntry choosePoolEntry(
            List<EquipmentAffixConfig.PoolEntry> candidates,
            Set<String> selectedCodes,
            List<EquipmentAffixConfig.Range> ranges,
            int minAffixTier,
            int maxAffixTier,
            Map<String, EquipmentAffixConfig.Definition> definitions,
            int itemId
    ) {
        List<EquipmentAffixConfig.PoolEntry> available = candidates.stream()
                .filter(entry -> !selectedCodes.contains(entry.affixCode())
                        || ranges.stream().anyMatch(range -> range.affixCode().equals(entry.affixCode())
                        && range.affixTier() >= minAffixTier
                        && range.affixTier() <= maxAffixTier && range.allowDuplicate())
                        || definitions.get(entry.affixCode()).maxPerItem() > 1)
                .filter(entry -> !isElementalAffix(entry.affixCode())
                        || selectedCodes.stream().noneMatch(EquipmentAffixGenerator::isElementalAffix))
                .toList();
        if (available.isEmpty()) {
            return null;
        }

        int totalWeight = available.stream()
                .mapToInt(entry -> effectiveWeight(entry, itemId))
                .sum();
        if (totalWeight <= 0) {
            throw new IllegalStateException("Equipment affix pool has no positive weight.");
        }
        int roll = Randomizer.nextInt(totalWeight);
        for (EquipmentAffixConfig.PoolEntry entry : available) {
            roll -= effectiveWeight(entry, itemId);
            if (roll < 0) {
                return entry;
            }
        }
        throw new IllegalStateException("Equipment affix selection failed.");
    }

    private static int effectiveWeight(EquipmentAffixConfig.PoolEntry entry, int itemId) {
        if (!isElementalAffix(entry.affixCode())) {
            return entry.weight();
        }
        return ElementalWeaponRegistry.elementOf(itemId) == null
                ? Math.max(1, entry.weight())
                : Math.max(1, entry.weight() + 12);
    }

    private static EquipmentAffixConfig.Range chooseRange(
            List<EquipmentAffixConfig.Range> ranges,
            String affixCode,
            int meanAffixTier,
            int tierRadius,
            int minAffixTier,
            int maxAffixTier
    ) {
        List<EquipmentAffixConfig.Range> available = ranges.stream()
                .filter(range -> range.affixCode().equals(affixCode))
                .filter(range -> range.affixTier() >= minAffixTier)
                .filter(range -> range.affixTier() <= maxAffixTier)
                .toList();
        int totalWeight = available.stream()
                .mapToInt(range -> range.weight() * tierDistanceWeight(
                        Math.abs(range.affixTier() - meanAffixTier), tierRadius))
                .sum();
        if (available.isEmpty() || totalWeight <= 0) {
            throw new IllegalStateException("Equipment affix has no valid tier range: " + affixCode);
        }
        int roll = Randomizer.nextInt(totalWeight);
        for (EquipmentAffixConfig.Range range : available) {
            roll -= range.weight() * tierDistanceWeight(
                    Math.abs(range.affixTier() - meanAffixTier), tierRadius);
            if (roll < 0) {
                return range;
            }
        }
        throw new IllegalStateException("Equipment affix tier selection failed: " + affixCode);
    }

    private static int tierDistanceWeight(int distance, int tierRadius) {
        if (tierRadius >= 5) {
            return switch (distance) {
                case 0 -> 100;
                case 1 -> 90;
                case 2 -> 50;
                case 3 -> 20;
                case 4 -> 8;
                default -> 2;
            };
        }
        if (tierRadius == 4) {
            return switch (distance) {
                case 0 -> 100;
                case 1 -> 90;
                case 2 -> 50;
                case 3 -> 15;
                default -> 5;
            };
        }
        return switch (distance) {
            case 0 -> 100;
            case 1 -> 90;
            case 2 -> 50;
            default -> 5;
        };
    }

    private static String resolveEquipType(int itemId) {
        if (ItemConstants.isWeapon(itemId)) {
            return "WEAPON";
        }
        int category = itemId / 10000;
        return switch (category) {
            case 100 -> "HAT";
            case 104 -> "TOP";
            case 105 -> "OVERALL";
            case 106 -> "BOTTOM";
            case 107 -> "SHOES";
            case 108 -> "GLOVE";
            case 110 -> "CAPE";
            case 111 -> "RING";
            case 112 -> "PENDANT";
            case 101, 102 -> "ACCESSORY";
            case 103 -> "EARRING";
            default -> null;
        };
    }
}

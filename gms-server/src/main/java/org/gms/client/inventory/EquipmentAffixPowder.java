package org.gms.client.inventory;

import java.util.LinkedHashMap;
import java.util.Map;

public final class EquipmentAffixPowder {
    private EquipmentAffixPowder() {
    }

    public static int powderIdFor(String affixCode) {
        if (containsAny(affixCode, "BOSS", "IGNORE_DEFENSE", "DROP_RATE", "EXP_RATE", "MESO_RATE")) {
            return 4007006;
        }
        if (containsAny(affixCode, "FIRE_DAMAGE", "ICE_DAMAGE", "LIGHTNING_DAMAGE", "HOLY_DAMAGE")) {
            return 4007007;
        }
        if (containsAny(affixCode, "WATK", "MATK")) {
            return 4007001;
        }
        if (containsAny(affixCode, "HP", "MP")) {
            return 4007002;
        }
        if (containsAny(affixCode, "WDEF", "MDEF")) {
            return 4007003;
        }
        if (containsAny(affixCode, "ACC", "AVOID")) {
            return 4007004;
        }
        if (containsAny(affixCode, "SPEED", "JUMP")) {
            return 4007005;
        }
        return 4007000;
    }

    public static int quantityFor(String affixCode, int rarity, int tier) {
        int base = containsAny(affixCode, "BOSS", "IGNORE_DEFENSE", "DROP_RATE", "EXP_RATE", "MESO_RATE",
                "FIRE_DAMAGE", "ICE_DAMAGE", "LIGHTNING_DAMAGE", "HOLY_DAMAGE") ? 3 : 1;
        if (containsAny(affixCode, "WATK", "MATK", "HP", "MP")) {
            base = 2;
        }
        return base + rarity / 2 + (tier + 2) / 3;
    }

    public static Map<Integer, Integer> gainsFor(Equip equip) {
        Map<Integer, Integer> gains = new LinkedHashMap<>();
        for (EquipmentAffix affix : equip.getAffixes()) {
            gains.merge(powderIdFor(affix.getAffixCode()),
                    quantityFor(affix.getAffixCode(), equip.getRarity(), affix.getAffixTier()),
                    Integer::sum);
        }
        return gains;
    }

    public static Map<Integer, Integer> rerollCostFor(Equip equip) {
        Map<Integer, Integer> cost = new LinkedHashMap<>();
        for (EquipmentAffix affix : equip.getAffixes()) {
            if (!affix.isLocked()) {
                cost.merge(powderIdFor(affix.getAffixCode()),
                        quantityFor(affix.getAffixCode(), equip.getRarity(), affix.getAffixTier()),
                        Integer::sum);
            }
        }
        return cost;
    }

    private static boolean containsAny(String value, String... fragments) {
        for (String fragment : fragments) {
            if (value.contains(fragment)) {
                return true;
            }
        }
        return false;
    }
}

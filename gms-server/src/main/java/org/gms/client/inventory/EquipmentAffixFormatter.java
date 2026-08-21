package org.gms.client.inventory;

import org.gms.server.ItemInformationProvider;
import org.gms.util.I18nUtil;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public final class EquipmentAffixFormatter {
    private EquipmentAffixFormatter() {
    }

    public static String format(Equip equip) {
        String itemName = ItemInformationProvider.getInstance().getName(equip.getItemId());
        String rarity = I18nUtil.getMessage("EquipmentAffixFormatter.rarity." + equip.getRarity());
        List<String> lines = equip.getAffixes().stream()
                .map(EquipmentAffixFormatter::formatAffix)
                .collect(Collectors.toList());

        StringBuilder result = new StringBuilder();
        result.append(I18nUtil.getMessage("EquipmentAffixFormatter.title", itemName));
        result.append('\n').append(I18nUtil.getMessage("EquipmentAffixFormatter.rarity", rarity));
        if (lines.isEmpty()) {
            result.append('\n').append(I18nUtil.getMessage("EquipmentAffixFormatter.empty"));
        } else {
            lines.forEach(line -> result.append('\n').append(line));
        }
        return result.toString();
    }

    private static String formatAffix(EquipmentAffix affix) {
        String label = I18nUtil.getMessage("EquipmentAffixFormatter.affix." + affix.getAffixCode());
        String nameKey = EquipmentAffixGenerator.getAffixNameKey(affix.getAffixCode(), affix.getAffixTier());
        String configuredPrefix = nameKey == null ? null : I18nUtil.getMessage(nameKey);
        String prefix = configuredPrefix == null || configuredPrefix.equals(nameKey)
                ? I18nUtil.getMessage("EquipmentAffixFormatter.prefix." + affix.getAffixTier())
                : configuredPrefix;
        String unit = isRateAffix(affix.getAffixCode()) ? "%" : "";
        String contribution = formatContributions(affix);
        return I18nUtil.getMessage(
                "EquipmentAffixFormatter.line",
                prefix,
                label,
                affix.getValue(),
                unit,
                affix.getAffixTier(),
                contribution
        );
    }

    private static String formatContributions(EquipmentAffix affix) {
        List<String> codes = switch (affix.getAffixCode()) {
            case "STR_DEX" -> List.of("STR", "DEX");
            case "INT_LUK" -> List.of("INT", "LUK");
            case "WATK_MATK" -> List.of("WATK", "MATK");
            case "STR_WATK" -> List.of("STR", "WATK");
            case "DEX_WATK" -> List.of("DEX", "WATK");
            case "LUK_WATK" -> List.of("LUK", "WATK");
            case "INT_MATK" -> List.of("INT", "MATK");
            case "HP_MP" -> List.of("HP", "MP");
            case "ACC_AVOID" -> List.of("ACC", "AVOID");
            case "SPEED_JUMP" -> List.of("SPEED", "JUMP");
            case "WDEF_MDEF" -> List.of("WDEF", "MDEF");
            case "BOSS_DAMAGE_IGNORE_DEFENSE" -> List.of("BOSS_DAMAGE", "IGNORE_DEFENSE");
            case "DROP_EXP" -> List.of("DROP_RATE", "EXP_RATE");
            case "EXP_MESO" -> List.of("EXP_RATE", "MESO_RATE");
            case "DROP_MESO" -> List.of("DROP_RATE", "MESO_RATE");
            case "STR_ACC" -> List.of("STR", "ACC");
            case "DEX_SPEED" -> List.of("DEX", "SPEED");
            case "INT_MP" -> List.of("INT", "MP");
            case "LUK_AVOID" -> List.of("LUK", "AVOID");
            case "WATK_ACC" -> List.of("WATK", "ACC");
            case "MATK_MP" -> List.of("MATK", "MP");
            case "STR_HP" -> List.of("STR", "HP");
            case "DEX_JUMP" -> List.of("DEX", "JUMP");
            case "INT_MDEF" -> List.of("INT", "MDEF");
            case "LUK_SPEED" -> List.of("LUK", "SPEED");
            case "WATK_SPEED" -> List.of("WATK", "SPEED");
            case "MATK_MDEF" -> List.of("MATK", "MDEF");
            case "STR_MP" -> List.of("STR", "MP");
            case "DEX_HP" -> List.of("DEX", "HP");
            case "INT_HP" -> List.of("INT", "HP");
            case "LUK_MP" -> List.of("LUK", "MP");
            case "HP_MDEF" -> List.of("HP", "MDEF");
            case "MP_MDEF" -> List.of("MP", "MDEF");
            case "HP_ACC" -> List.of("HP", "ACC");
            case "MP_ACC" -> List.of("MP", "ACC");
            default -> List.of();
        };
        if (codes.isEmpty()) {
            return "";
        }
        Map<String, String> labels = codes.stream().collect(Collectors.toMap(
                code -> code,
                code -> I18nUtil.getMessage("EquipmentAffixFormatter.affix." + code)
        ));
        return codes.stream()
                .map(code -> I18nUtil.getMessage(
                        "EquipmentAffixFormatter.contribution",
                        labels.get(code),
                        contributionValue(affix.getAffixCode(), code, affix.getValue()),
                        isRateAffix(code) ? "%" : ""
                ))
                .collect(Collectors.joining(", ", " [", "]"));
    }

    private static int contributionValue(String affixCode, String code, int value) {
        if ("INT_MATK".equals(affixCode) && "MATK".equals(code)) {
            return value * 2;
        }
        String primaryCode = switch (affixCode) {
            case "STR_ACC" -> "STR";
            case "DEX_SPEED" -> "DEX";
            case "INT_MP" -> "INT";
            case "LUK_AVOID" -> "LUK";
            case "WATK_ACC", "WATK_SPEED" -> "WATK";
            case "MATK_MP", "MATK_MDEF" -> "MATK";
            case "STR_HP", "STR_MP" -> "STR";
            case "DEX_JUMP", "DEX_HP" -> "DEX";
            case "INT_MDEF", "INT_HP" -> "INT";
            case "LUK_SPEED", "LUK_MP" -> "LUK";
            case "HP_MDEF", "HP_ACC" -> "HP";
            case "MP_MDEF", "MP_ACC" -> "MP";
            default -> "";
        };
        if (!primaryCode.isEmpty() && !primaryCode.equals(code)) {
            double multiplier = switch (code) {
                case "HP", "MP" -> 0.65;
                case "ACC" -> 0.60;
                case "SPEED", "JUMP", "MDEF" -> 0.50;
                default -> 1.0;
            };
            return Math.max(1, (int) Math.round(value * multiplier));
        }
        String reducedCode = switch (affixCode) {
            case "BOSS_DAMAGE_IGNORE_DEFENSE" -> "IGNORE_DEFENSE";
            case "DROP_EXP" -> "EXP_RATE";
            case "EXP_MESO", "DROP_MESO" -> "MESO_RATE";
            default -> "";
        };
        if (reducedCode.equals(code)) {
            return Math.max(1, (int) Math.round(value * 0.50));
        }
        return value;
    }

    private static boolean isRateAffix(String affixCode) {
        return switch (affixCode) {
            case "BOSS_DAMAGE", "IGNORE_DEFENSE", "DROP_RATE", "EXP_RATE", "MESO_RATE",
                    "BOSS_DAMAGE_REDUCTION", "FIRE_DAMAGE", "ICE_DAMAGE",
                    "LIGHTNING_DAMAGE", "HOLY_DAMAGE", "BOSS_DAMAGE_IGNORE_DEFENSE",
                    "DROP_EXP", "EXP_MESO", "DROP_MESO" -> true;
            default -> false;
        };
    }
}

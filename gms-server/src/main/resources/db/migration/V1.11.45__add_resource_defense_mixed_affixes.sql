-- Add resource, survivability, and utility combinations. The second
-- component is reduced at runtime so mixed affixes remain sidegrades.
INSERT IGNORE INTO `equipment_affix_definition`
(`affix_code`, `name_key`, `value_type`, `effect_type`, `max_per_item`, `display_order`)
VALUES
    ('STR_MP', 'equipment.affix.str_mp', 'FLAT', 'ATTRIBUTE', 1, 65),
    ('DEX_HP', 'equipment.affix.dex_hp', 'FLAT', 'ATTRIBUTE', 1, 66),
    ('INT_HP', 'equipment.affix.int_hp', 'FLAT', 'ATTRIBUTE', 1, 67),
    ('LUK_MP', 'equipment.affix.luk_mp', 'FLAT', 'ATTRIBUTE', 1, 68),
    ('HP_MDEF', 'equipment.affix.hp_mdef', 'FLAT', 'ATTRIBUTE', 1, 69),
    ('MP_MDEF', 'equipment.affix.mp_mdef', 'FLAT', 'ATTRIBUTE', 1, 70),
    ('HP_ACC', 'equipment.affix.hp_acc', 'FLAT', 'ATTRIBUTE', 1, 71),
    ('MP_ACC', 'equipment.affix.mp_acc', 'FLAT', 'ATTRIBUTE', 1, 72);

INSERT IGNORE INTO `equipment_affix_range`
(`affix_code`, `rarity`, `min_value`, `max_value`, `weight`)
SELECT codes.`affix_code`, ranges.`rarity`, ranges.`min_value`, ranges.`max_value`, ranges.`weight`
FROM (
    SELECT 'STR_MP' AS affix_code, 'STR' AS source_code
    UNION ALL SELECT 'DEX_HP', 'DEX'
    UNION ALL SELECT 'INT_HP', 'INT'
    UNION ALL SELECT 'LUK_MP', 'LUK'
    UNION ALL SELECT 'HP_MDEF', 'HP'
    UNION ALL SELECT 'MP_MDEF', 'MP'
    UNION ALL SELECT 'HP_ACC', 'HP'
    UNION ALL SELECT 'MP_ACC', 'MP'
) codes
JOIN `equipment_affix_range` ranges ON ranges.`affix_code` = codes.`source_code`;

INSERT IGNORE INTO `equipment_affix_name`
(`affix_code`, `affix_tier`, `name_key`, `priority`)
SELECT codes.`affix_code`, tiers.`affix_tier`,
       CONCAT('equipment.prefix.', LOWER(codes.`affix_code`), '.t', tiers.`affix_tier`),
       codes.`priority`
FROM (
    SELECT 'STR_MP' AS affix_code, 65 AS priority
    UNION ALL SELECT 'DEX_HP', 66
    UNION ALL SELECT 'INT_HP', 67
    UNION ALL SELECT 'LUK_MP', 68
    UNION ALL SELECT 'HP_MDEF', 69
    UNION ALL SELECT 'MP_MDEF', 70
    UNION ALL SELECT 'HP_ACC', 71
    UNION ALL SELECT 'MP_ACC', 72
) codes
JOIN (SELECT DISTINCT `affix_tier` FROM `equipment_affix_name`) tiers ON 1 = 1;

INSERT IGNORE INTO `equipment_affix_pool`
(`equip_type`, `affix_code`, `affix_group`, `weight`, `enabled`)
SELECT pools.`equip_type`, codes.`affix_code`, pools.`affix_group`, pools.`weight`, pools.`enabled`
FROM (
    SELECT 'STR_MP' AS affix_code, 'STR' AS source_code
    UNION ALL SELECT 'DEX_HP', 'DEX'
    UNION ALL SELECT 'INT_HP', 'INT'
    UNION ALL SELECT 'LUK_MP', 'LUK'
    UNION ALL SELECT 'HP_MDEF', 'HP'
    UNION ALL SELECT 'MP_MDEF', 'MP'
    UNION ALL SELECT 'HP_ACC', 'HP'
    UNION ALL SELECT 'MP_ACC', 'MP'
) codes
JOIN `equipment_affix_pool` pools ON pools.`affix_code` = codes.`source_code`;

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`)
SELECT pools.`equip_type`, codes.`affix_code`, pools.`affix_group`,
       pools.`min_req_level`, pools.`max_req_level`, pools.`weight`, pools.`enabled`
FROM (
    SELECT 'STR_MP' AS affix_code, 'STR' AS source_code
    UNION ALL SELECT 'DEX_HP', 'DEX'
    UNION ALL SELECT 'INT_HP', 'INT'
    UNION ALL SELECT 'LUK_MP', 'LUK'
    UNION ALL SELECT 'HP_MDEF', 'HP'
    UNION ALL SELECT 'MP_MDEF', 'MP'
    UNION ALL SELECT 'HP_ACC', 'HP'
    UNION ALL SELECT 'MP_ACC', 'MP'
) codes
JOIN `equipment_affix_level_pool` pools ON pools.`affix_code` = codes.`source_code`;

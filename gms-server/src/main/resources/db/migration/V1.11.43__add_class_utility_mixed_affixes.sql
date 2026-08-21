-- Class-oriented mixed affixes combine a primary/offensive stat with a
-- utility stat. The runtime applies the utility component at half value.
INSERT IGNORE INTO `equipment_affix_definition`
(`affix_code`, `name_key`, `value_type`, `effect_type`, `max_per_item`, `display_order`)
VALUES
    ('STR_ACC', 'equipment.affix.str_acc', 'FLAT', 'ATTRIBUTE', 1, 53),
    ('DEX_SPEED', 'equipment.affix.dex_speed', 'FLAT', 'ATTRIBUTE', 1, 54),
    ('INT_MP', 'equipment.affix.int_mp', 'FLAT', 'ATTRIBUTE', 1, 55),
    ('LUK_AVOID', 'equipment.affix.luk_avoid', 'FLAT', 'ATTRIBUTE', 1, 56),
    ('WATK_ACC', 'equipment.affix.watk_acc', 'FLAT', 'ATTRIBUTE', 1, 57),
    ('MATK_MP', 'equipment.affix.matk_mp', 'FLAT', 'ATTRIBUTE', 1, 58);

INSERT IGNORE INTO `equipment_affix_range`
(`affix_code`, `rarity`, `min_value`, `max_value`, `weight`)
SELECT codes.`affix_code`, ranges.`rarity`, ranges.`min_value`, ranges.`max_value`, ranges.`weight`
FROM (
    SELECT 'STR_ACC' AS affix_code, 'STR' AS source_code
    UNION ALL SELECT 'DEX_SPEED', 'DEX'
    UNION ALL SELECT 'INT_MP', 'INT'
    UNION ALL SELECT 'LUK_AVOID', 'LUK'
    UNION ALL SELECT 'WATK_ACC', 'WATK'
    UNION ALL SELECT 'MATK_MP', 'MATK'
) codes
JOIN `equipment_affix_range` ranges ON ranges.`affix_code` = codes.`source_code`;

INSERT IGNORE INTO `equipment_affix_name`
(`affix_code`, `affix_tier`, `name_key`, `priority`)
SELECT codes.`affix_code`, tiers.`affix_tier`,
       CONCAT('equipment.prefix.', LOWER(codes.`affix_code`), '.t', tiers.`affix_tier`),
       codes.`priority`
FROM (
    SELECT 'STR_ACC' AS affix_code, 53 AS priority
    UNION ALL SELECT 'DEX_SPEED', 54
    UNION ALL SELECT 'INT_MP', 55
    UNION ALL SELECT 'LUK_AVOID', 56
    UNION ALL SELECT 'WATK_ACC', 57
    UNION ALL SELECT 'MATK_MP', 58
) codes
JOIN (SELECT DISTINCT `affix_tier` FROM `equipment_affix_name`) tiers ON 1 = 1;

INSERT IGNORE INTO `equipment_affix_pool`
(`equip_type`, `affix_code`, `affix_group`, `weight`, `enabled`)
SELECT pools.`equip_type`, codes.`affix_code`, pools.`affix_group`, pools.`weight`, pools.`enabled`
FROM (
    SELECT 'STR_ACC' AS affix_code, 'STR' AS source_code
    UNION ALL SELECT 'DEX_SPEED', 'DEX'
    UNION ALL SELECT 'INT_MP', 'INT'
    UNION ALL SELECT 'LUK_AVOID', 'LUK'
    UNION ALL SELECT 'WATK_ACC', 'WATK'
    UNION ALL SELECT 'MATK_MP', 'MATK'
) codes
JOIN `equipment_affix_pool` pools ON pools.`affix_code` = codes.`source_code`;

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`)
SELECT pools.`equip_type`, codes.`affix_code`, pools.`affix_group`,
       pools.`min_req_level`, pools.`max_req_level`, pools.`weight`, pools.`enabled`
FROM (
    SELECT 'STR_ACC' AS affix_code, 'STR' AS source_code
    UNION ALL SELECT 'DEX_SPEED', 'DEX'
    UNION ALL SELECT 'INT_MP', 'INT'
    UNION ALL SELECT 'LUK_AVOID', 'LUK'
    UNION ALL SELECT 'WATK_ACC', 'WATK'
    UNION ALL SELECT 'MATK_MP', 'MATK'
) codes
JOIN `equipment_affix_level_pool` pools ON pools.`affix_code` = codes.`source_code`;

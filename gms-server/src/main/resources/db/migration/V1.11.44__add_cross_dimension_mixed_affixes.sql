-- Broaden mixed affixes across combat, defense, and mobility dimensions.
-- The second component is reduced at runtime to keep the primary stat
-- meaningful without making the utility stat dominate.
INSERT IGNORE INTO `equipment_affix_definition`
(`affix_code`, `name_key`, `value_type`, `effect_type`, `max_per_item`, `display_order`)
VALUES
    ('STR_HP', 'equipment.affix.str_hp', 'FLAT', 'ATTRIBUTE', 1, 59),
    ('DEX_JUMP', 'equipment.affix.dex_jump', 'FLAT', 'ATTRIBUTE', 1, 60),
    ('INT_MDEF', 'equipment.affix.int_mdef', 'FLAT', 'ATTRIBUTE', 1, 61),
    ('LUK_SPEED', 'equipment.affix.luk_speed', 'FLAT', 'ATTRIBUTE', 1, 62),
    ('WATK_SPEED', 'equipment.affix.watk_speed', 'FLAT', 'ATTRIBUTE', 1, 63),
    ('MATK_MDEF', 'equipment.affix.matk_mdef', 'FLAT', 'ATTRIBUTE', 1, 64);

INSERT IGNORE INTO `equipment_affix_range`
(`affix_code`, `rarity`, `min_value`, `max_value`, `weight`)
SELECT codes.`affix_code`, ranges.`rarity`, ranges.`min_value`, ranges.`max_value`, ranges.`weight`
FROM (
    SELECT 'STR_HP' AS affix_code, 'STR' AS source_code
    UNION ALL SELECT 'DEX_JUMP', 'DEX'
    UNION ALL SELECT 'INT_MDEF', 'INT'
    UNION ALL SELECT 'LUK_SPEED', 'LUK'
    UNION ALL SELECT 'WATK_SPEED', 'WATK'
    UNION ALL SELECT 'MATK_MDEF', 'MATK'
) codes
JOIN `equipment_affix_range` ranges ON ranges.`affix_code` = codes.`source_code`;

INSERT IGNORE INTO `equipment_affix_name`
(`affix_code`, `affix_tier`, `name_key`, `priority`)
SELECT codes.`affix_code`, tiers.`affix_tier`,
       CONCAT('equipment.prefix.', LOWER(codes.`affix_code`), '.t', tiers.`affix_tier`),
       codes.`priority`
FROM (
    SELECT 'STR_HP' AS affix_code, 59 AS priority
    UNION ALL SELECT 'DEX_JUMP', 60
    UNION ALL SELECT 'INT_MDEF', 61
    UNION ALL SELECT 'LUK_SPEED', 62
    UNION ALL SELECT 'WATK_SPEED', 63
    UNION ALL SELECT 'MATK_MDEF', 64
) codes
JOIN (SELECT DISTINCT `affix_tier` FROM `equipment_affix_name`) tiers ON 1 = 1;

INSERT IGNORE INTO `equipment_affix_pool`
(`equip_type`, `affix_code`, `affix_group`, `weight`, `enabled`)
SELECT pools.`equip_type`, codes.`affix_code`, pools.`affix_group`, pools.`weight`, pools.`enabled`
FROM (
    SELECT 'STR_HP' AS affix_code, 'STR' AS source_code
    UNION ALL SELECT 'DEX_JUMP', 'DEX'
    UNION ALL SELECT 'INT_MDEF', 'INT'
    UNION ALL SELECT 'LUK_SPEED', 'LUK'
    UNION ALL SELECT 'WATK_SPEED', 'WATK'
    UNION ALL SELECT 'MATK_MDEF', 'MATK'
) codes
JOIN `equipment_affix_pool` pools ON pools.`affix_code` = codes.`source_code`;

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`)
SELECT pools.`equip_type`, codes.`affix_code`, pools.`affix_group`,
       pools.`min_req_level`, pools.`max_req_level`, pools.`weight`, pools.`enabled`
FROM (
    SELECT 'STR_HP' AS affix_code, 'STR' AS source_code
    UNION ALL SELECT 'DEX_JUMP', 'DEX'
    UNION ALL SELECT 'INT_MDEF', 'INT'
    UNION ALL SELECT 'LUK_SPEED', 'LUK'
    UNION ALL SELECT 'WATK_SPEED', 'WATK'
    UNION ALL SELECT 'MATK_MDEF', 'MATK'
) codes
JOIN `equipment_affix_level_pool` pools ON pools.`affix_code` = codes.`source_code`;

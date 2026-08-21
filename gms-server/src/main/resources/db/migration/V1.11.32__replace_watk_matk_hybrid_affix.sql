-- Replace the ineffective dual-attack hybrid with class-oriented attack hybrids.
-- WATK is paired with STR/DEX/LUK; MATK is paired with INT.
INSERT IGNORE INTO `equipment_affix_definition`
(`affix_code`, `name_key`, `value_type`, `effect_type`, `max_per_item`, `display_order`)
VALUES
    ('STR_WATK', 'equipment.affix.str_watk', 'FLAT', 'ATTRIBUTE', 1, 48),
    ('DEX_WATK', 'equipment.affix.dex_watk', 'FLAT', 'ATTRIBUTE', 1, 49),
    ('LUK_WATK', 'equipment.affix.luk_watk', 'FLAT', 'ATTRIBUTE', 1, 50),
    ('INT_MATK', 'equipment.affix.int_matk', 'FLAT', 'ATTRIBUTE', 1, 51);

INSERT IGNORE INTO `equipment_affix_range`
(`affix_code`, `rarity`, `affix_tier`, `min_value`, `max_value`, `weight`)
VALUES
    ('STR_WATK', 1, 1, 1, 1, 100), ('STR_WATK', 2, 2, 2, 2, 100),
    ('STR_WATK', 3, 3, 4, 4, 100), ('STR_WATK', 4, 4, 6, 6, 100),
    ('STR_WATK', 5, 5, 9, 9, 100), ('STR_WATK', 6, 6, 13, 13, 100),
    ('STR_WATK', 7, 7, 13, 18, 100), ('STR_WATK', 8, 8, 18, 25, 100),
    ('STR_WATK', 6, 9, 20, 27, 100), ('STR_WATK', 6, 10, 21, 30, 100),
    ('STR_WATK', 6, 11, 23, 32, 100), ('STR_WATK', 6, 12, 25, 35, 100),
    ('DEX_WATK', 1, 1, 1, 1, 100), ('DEX_WATK', 2, 2, 2, 2, 100),
    ('DEX_WATK', 3, 3, 4, 4, 100), ('DEX_WATK', 4, 4, 6, 6, 100),
    ('DEX_WATK', 5, 5, 9, 9, 100), ('DEX_WATK', 6, 6, 13, 13, 100),
    ('DEX_WATK', 7, 7, 13, 18, 100), ('DEX_WATK', 8, 8, 18, 25, 100),
    ('DEX_WATK', 6, 9, 20, 27, 100), ('DEX_WATK', 6, 10, 21, 30, 100),
    ('DEX_WATK', 6, 11, 23, 32, 100), ('DEX_WATK', 6, 12, 25, 35, 100),
    ('LUK_WATK', 1, 1, 1, 1, 100), ('LUK_WATK', 2, 2, 2, 2, 100),
    ('LUK_WATK', 3, 3, 4, 4, 100), ('LUK_WATK', 4, 4, 6, 6, 100),
    ('LUK_WATK', 5, 5, 9, 9, 100), ('LUK_WATK', 6, 6, 13, 13, 100),
    ('LUK_WATK', 7, 7, 13, 18, 100), ('LUK_WATK', 8, 8, 18, 25, 100),
    ('LUK_WATK', 6, 9, 20, 27, 100), ('LUK_WATK', 6, 10, 21, 30, 100),
    ('LUK_WATK', 6, 11, 23, 32, 100), ('LUK_WATK', 6, 12, 25, 35, 100),
    ('INT_MATK', 1, 1, 1, 1, 100), ('INT_MATK', 2, 2, 2, 2, 100),
    ('INT_MATK', 3, 3, 4, 4, 100), ('INT_MATK', 4, 4, 6, 6, 100),
    ('INT_MATK', 5, 5, 9, 9, 100), ('INT_MATK', 6, 6, 13, 13, 100),
    ('INT_MATK', 7, 7, 13, 18, 100), ('INT_MATK', 8, 8, 18, 25, 100),
    ('INT_MATK', 6, 9, 20, 27, 100), ('INT_MATK', 6, 10, 21, 30, 100),
    ('INT_MATK', 6, 11, 23, 32, 100), ('INT_MATK', 6, 12, 25, 35, 100);

INSERT IGNORE INTO `equipment_affix_name`
(`affix_code`, `affix_tier`, `name_key`, `priority`)
SELECT codes.`affix_code`,
       tiers.`affix_tier`,
       CONCAT('equipment.prefix.', LOWER(codes.`affix_code`), '.t', tiers.`affix_tier`),
       codes.`priority`
FROM (
    SELECT 'STR_WATK' AS affix_code, 48 AS priority
    UNION ALL SELECT 'DEX_WATK', 49
    UNION ALL SELECT 'LUK_WATK', 50
    UNION ALL SELECT 'INT_MATK', 51
) codes
JOIN (
    SELECT 1 AS affix_tier
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
    UNION ALL SELECT 7
    UNION ALL SELECT 8
    UNION ALL SELECT 9
    UNION ALL SELECT 10
    UNION ALL SELECT 11
    UNION ALL SELECT 12
) tiers ON 1 = 1;

DELETE FROM `equipment_affix_level_pool`
WHERE `affix_code` = 'WATK_MATK';

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `min_req_level`, `max_req_level`, `weight`)
SELECT types.`equip_type`, codes.`affix_code`, bands.`min_req_level`, bands.`max_req_level`, 25
FROM (
    SELECT 'WEAPON' AS equip_type
    UNION ALL SELECT 'GLOVE'
    UNION ALL SELECT 'CAPE'
) types
JOIN (
    SELECT 'STR_WATK' AS affix_code
    UNION ALL SELECT 'DEX_WATK'
    UNION ALL SELECT 'LUK_WATK'
    UNION ALL SELECT 'INT_MATK'
) codes ON 1 = 1
JOIN (
    SELECT 80 AS min_req_level, 89 AS max_req_level
    UNION ALL SELECT 90, 99
    UNION ALL SELECT 100, 109
    UNION ALL SELECT 110, 119
    UNION ALL SELECT 120, 129
    UNION ALL SELECT 130, 139
    UNION ALL SELECT 140, 149
    UNION ALL SELECT 150, 159
    UNION ALL SELECT 160, 169
    UNION ALL SELECT 170, 179
    UNION ALL SELECT 180, 189
    UNION ALL SELECT 190, 199
    UNION ALL SELECT 200, 209
    UNION ALL SELECT 210, 219
    UNION ALL SELECT 220, 229
    UNION ALL SELECT 230, 239
    UNION ALL SELECT 240, 249
    UNION ALL SELECT 250, 255
) bands ON 1 = 1;

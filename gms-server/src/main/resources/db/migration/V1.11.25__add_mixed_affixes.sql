-- Add hybrid affixes. Their values are applied to both component stats while
-- the original affix code remains available for display and persistence.
INSERT IGNORE INTO `equipment_affix_definition`
(`affix_code`, `name_key`, `value_type`, `effect_type`, `max_per_item`, `display_order`)
VALUES
    ('STR_DEX', 'equipment.affix.str_dex', 'FLAT', 'ATTRIBUTE', 1, 46),
    ('INT_LUK', 'equipment.affix.int_luk', 'FLAT', 'ATTRIBUTE', 1, 47),
    ('WATK_MATK', 'equipment.affix.watk_matk', 'FLAT', 'ATTRIBUTE', 1, 48),
    ('HP_MP', 'equipment.affix.hp_mp', 'FLAT', 'ATTRIBUTE', 1, 49),
    ('ACC_AVOID', 'equipment.affix.acc_avoid', 'FLAT', 'ATTRIBUTE', 1, 121),
    ('SPEED_JUMP', 'equipment.affix.speed_jump', 'FLAT', 'ATTRIBUTE', 1, 141);

INSERT IGNORE INTO `equipment_affix_range`
(`affix_code`, `rarity`, `min_value`, `max_value`, `weight`)
VALUES
    ('STR_DEX', 1, 1, 2, 100), ('STR_DEX', 2, 2, 4, 100),
    ('STR_DEX', 3, 4, 7, 100), ('STR_DEX', 4, 7, 12, 100),
    ('STR_DEX', 5, 10, 16, 100), ('STR_DEX', 6, 14, 21, 100),
    ('STR_DEX', 7, 19, 28, 100), ('STR_DEX', 8, 27, 38, 100),
    ('INT_LUK', 1, 1, 2, 100), ('INT_LUK', 2, 2, 4, 100),
    ('INT_LUK', 3, 4, 7, 100), ('INT_LUK', 4, 7, 12, 100),
    ('INT_LUK', 5, 10, 16, 100), ('INT_LUK', 6, 14, 21, 100),
    ('INT_LUK', 7, 19, 28, 100), ('INT_LUK', 8, 27, 38, 100),
    ('WATK_MATK', 1, 1, 2, 100), ('WATK_MATK', 2, 2, 4, 100),
    ('WATK_MATK', 3, 4, 7, 100), ('WATK_MATK', 4, 7, 12, 100),
    ('WATK_MATK', 5, 10, 16, 100), ('WATK_MATK', 6, 14, 21, 100),
    ('WATK_MATK', 7, 19, 28, 100), ('WATK_MATK', 8, 27, 38, 100),
    ('HP_MP', 1, 30, 70, 100), ('HP_MP', 2, 70, 150, 100),
    ('HP_MP', 3, 150, 280, 100), ('HP_MP', 4, 280, 480, 100),
    ('HP_MP', 5, 480, 750, 100), ('HP_MP', 6, 750, 1100, 100),
    ('HP_MP', 7, 1100, 1600, 100), ('HP_MP', 8, 1600, 2300, 100),
    ('ACC_AVOID', 1, 2, 5, 100), ('ACC_AVOID', 2, 5, 10, 100),
    ('ACC_AVOID', 3, 10, 18, 100), ('ACC_AVOID', 4, 18, 30, 100),
    ('ACC_AVOID', 5, 30, 45, 100), ('ACC_AVOID', 6, 45, 65, 100),
    ('ACC_AVOID', 7, 65, 90, 100), ('ACC_AVOID', 8, 90, 125, 100),
    ('SPEED_JUMP', 1, 1, 2, 100), ('SPEED_JUMP', 2, 2, 4, 100),
    ('SPEED_JUMP', 3, 4, 7, 100), ('SPEED_JUMP', 4, 7, 10, 100),
    ('SPEED_JUMP', 5, 10, 13, 100), ('SPEED_JUMP', 6, 13, 16, 100),
    ('SPEED_JUMP', 7, 16, 20, 100), ('SPEED_JUMP', 8, 20, 25, 100);

INSERT IGNORE INTO `equipment_affix_name`
(`affix_code`, `affix_tier`, `name_key`, `priority`)
SELECT codes.`affix_code`,
       tiers.`affix_tier`,
       CONCAT('equipment.prefix.', LOWER(codes.`affix_code`), '.t', tiers.`affix_tier`),
       codes.`priority`
FROM (
    SELECT 'STR_DEX' AS affix_code, 46 AS priority
    UNION ALL SELECT 'INT_LUK', 47
    UNION ALL SELECT 'WATK_MATK', 48
    UNION ALL SELECT 'HP_MP', 49
    UNION ALL SELECT 'ACC_AVOID', 121
    UNION ALL SELECT 'SPEED_JUMP', 141
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
) tiers ON 1 = 1;

-- Hybrid primary attributes are available from level 40, offensive hybrids
-- from level 80, and movement/accuracy hybrids from their relevant level bands.
INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `min_req_level`, `max_req_level`, `weight`)
SELECT types.`equip_type`, codes.`affix_code`, bands.`min_req_level`, bands.`max_req_level`,
       CASE WHEN bands.`min_req_level` >= 120 THEN 30 ELSE 20 END
FROM (
    SELECT 'HAT' AS equip_type
    UNION ALL SELECT 'TOP'
    UNION ALL SELECT 'BOTTOM'
    UNION ALL SELECT 'SHOES'
    UNION ALL SELECT 'GLOVE'
    UNION ALL SELECT 'CAPE'
    UNION ALL SELECT 'RING'
    UNION ALL SELECT 'PENDANT'
    UNION ALL SELECT 'ACCESSORY'
    UNION ALL SELECT 'WEAPON'
) types
JOIN (
    SELECT 'STR_DEX' AS affix_code
    UNION ALL SELECT 'INT_LUK'
) codes ON 1 = 1
JOIN (
    SELECT 40 AS min_req_level, 49 AS max_req_level
    UNION ALL SELECT 50, 59
    UNION ALL SELECT 60, 69
    UNION ALL SELECT 70, 79
    UNION ALL SELECT 80, 89
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

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `min_req_level`, `max_req_level`, `weight`)
SELECT types.`equip_type`, 'WATK_MATK', bands.`min_req_level`, bands.`max_req_level`, 25
FROM (
    SELECT 'WEAPON' AS equip_type
    UNION ALL SELECT 'GLOVE'
    UNION ALL SELECT 'CAPE'
) types
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

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `min_req_level`, `max_req_level`, `weight`)
SELECT types.`equip_type`, codes.`affix_code`, bands.`min_req_level`, bands.`max_req_level`, 25
FROM (
    SELECT 'HAT' AS equip_type
    UNION ALL SELECT 'TOP'
    UNION ALL SELECT 'BOTTOM'
    UNION ALL SELECT 'SHOES'
    UNION ALL SELECT 'CAPE'
    UNION ALL SELECT 'RING'
    UNION ALL SELECT 'PENDANT'
    UNION ALL SELECT 'ACCESSORY'
) types
JOIN (
    SELECT 'HP_MP' AS affix_code
) codes ON 1 = 1
JOIN (
    SELECT 40 AS min_req_level, 49 AS max_req_level
    UNION ALL SELECT 50, 59
    UNION ALL SELECT 60, 69
    UNION ALL SELECT 70, 79
    UNION ALL SELECT 80, 89
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

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `min_req_level`, `max_req_level`, `weight`)
SELECT types.`equip_type`, 'ACC_AVOID', bands.`min_req_level`, bands.`max_req_level`, 20
FROM (
    SELECT 'WEAPON' AS equip_type
    UNION ALL SELECT 'GLOVE'
    UNION ALL SELECT 'RING'
    UNION ALL SELECT 'ACCESSORY'
) types
JOIN (
    SELECT 50 AS min_req_level, 59 AS max_req_level
    UNION ALL SELECT 60, 69
    UNION ALL SELECT 70, 79
    UNION ALL SELECT 80, 89
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

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `min_req_level`, `max_req_level`, `weight`)
SELECT types.`equip_type`, 'SPEED_JUMP', bands.`min_req_level`, bands.`max_req_level`, 30
FROM (
    SELECT 'SHOES' AS equip_type
    UNION ALL SELECT 'CAPE'
    UNION ALL SELECT 'ACCESSORY'
) types
JOIN (
    SELECT 20 AS min_req_level, 29 AS max_req_level
    UNION ALL SELECT 30, 39
    UNION ALL SELECT 40, 49
    UNION ALL SELECT 50, 59
    UNION ALL SELECT 60, 69
    UNION ALL SELECT 70, 79
    UNION ALL SELECT 80, 89
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

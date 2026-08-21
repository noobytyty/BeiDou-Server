-- Split affix selection into ten-level requirement bands. Existing pools remain
-- as the fallback for equipment types without a level-specific configuration.
CREATE TABLE IF NOT EXISTS `equipment_affix_level_pool`
(
    `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `equip_type`    VARCHAR(32)      NOT NULL,
    `affix_code`    VARCHAR(32)      NOT NULL,
    `min_req_level` SMALLINT UNSIGNED NOT NULL,
    `max_req_level` SMALLINT UNSIGNED NOT NULL,
    `weight`        INT UNSIGNED     NOT NULL DEFAULT 100,
    `enabled`       TINYINT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_level_affix_pool`
        (`equip_type`, `affix_code`, `min_req_level`, `max_req_level`),
    KEY `idx_level_affix_lookup`
        (`equip_type`, `min_req_level`, `max_req_level`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4;

-- Keep the original pool shape while making high-level equipment favor
-- offensive and special effects, and low-level equipment avoid special effects.
INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `min_req_level`, `max_req_level`, `weight`)
SELECT pool.`equip_type`,
       pool.`affix_code`,
       bands.`min_req_level`,
       bands.`max_req_level`,
       CASE
           WHEN bands.`min_req_level` < 60
                AND pool.`affix_code` IN
                    ('BOSS_DAMAGE', 'IGNORE_DEFENSE', 'DROP_RATE', 'EXP_RATE',
                     'MESO_RATE', 'BOSS_DAMAGE_REDUCTION') THEN 0
           WHEN bands.`min_req_level` >= 120
                AND pool.`affix_code` IN ('WATK', 'MATK', 'BOSS_DAMAGE', 'IGNORE_DEFENSE') THEN
               pool.`weight` + 20
           ELSE pool.`weight`
       END
FROM `equipment_affix_pool` pool
JOIN (
    SELECT 0 AS min_req_level, 9 AS max_req_level
    UNION ALL SELECT 10, 19
    UNION ALL SELECT 20, 29
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

-- A high-level-only attribute affix. Runtime handling is implemented in Equip
-- so it contributes to STR/DEX/INT/LUK without being written into base stats.
INSERT IGNORE INTO `equipment_affix_definition`
(`affix_code`, `name_key`, `value_type`, `effect_type`, `max_per_item`, `display_order`)
VALUES
    ('ALL_STAT', 'equipment.affix.all_stat', 'FLAT', 'ATTRIBUTE', 1, 45);

INSERT IGNORE INTO `equipment_affix_range`
(`affix_code`, `rarity`, `min_value`, `max_value`, `weight`)
VALUES
    ('ALL_STAT', 1, 1, 2, 100),
    ('ALL_STAT', 2, 2, 4, 100),
    ('ALL_STAT', 3, 4, 7, 100),
    ('ALL_STAT', 4, 7, 12, 100),
    ('ALL_STAT', 5, 10, 16, 100),
    ('ALL_STAT', 6, 14, 21, 100),
    ('ALL_STAT', 7, 19, 28, 100),
    ('ALL_STAT', 8, 27, 38, 100);

INSERT IGNORE INTO `equipment_affix_name`
(`affix_code`, `affix_tier`, `name_key`, `priority`)
SELECT 'ALL_STAT',
       tiers.`affix_tier`,
       CONCAT('equipment.prefix.all_stat.t', tiers.`affix_tier`),
       45
FROM (
    SELECT 1 AS affix_tier
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
    UNION ALL SELECT 7
    UNION ALL SELECT 8
) tiers;

-- Unlock ALL_STAT only for equipment requiring level 100 or higher.
INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `min_req_level`, `max_req_level`, `weight`)
SELECT equip_types.`equip_type`,
       'ALL_STAT',
       bands.`min_req_level`,
       bands.`max_req_level`,
       CASE
           WHEN bands.`min_req_level` >= 160 THEN 45
           ELSE 25
       END
FROM (
    SELECT 'WEAPON' AS equip_type
    UNION ALL SELECT 'HAT'
    UNION ALL SELECT 'TOP'
    UNION ALL SELECT 'BOTTOM'
    UNION ALL SELECT 'SHOES'
    UNION ALL SELECT 'GLOVE'
    UNION ALL SELECT 'CAPE'
    UNION ALL SELECT 'RING'
    UNION ALL SELECT 'PENDANT'
    UNION ALL SELECT 'ACCESSORY'
) equip_types
JOIN (
    SELECT 100 AS min_req_level, 109 AS max_req_level
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

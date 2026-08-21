-- Diversify equipment-specific affix routes without introducing universal
-- fallback candidates.

-- Tops and bottoms gain a low-weight attribute-oriented primary route.
INSERT IGNORE INTO `equipment_affix_pool`
(`equip_type`, `affix_code`, `affix_group`, `weight`)
VALUES
    ('TOP', 'STR', 'MAIN', 20), ('TOP', 'DEX', 'MAIN', 20),
    ('TOP', 'INT', 'MAIN', 20), ('TOP', 'LUK', 'MAIN', 20),
    ('BOTTOM', 'STR', 'MAIN', 20), ('BOTTOM', 'DEX', 'MAIN', 20),
    ('BOTTOM', 'INT', 'MAIN', 20), ('BOTTOM', 'LUK', 'MAIN', 20);

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`)
SELECT types.`equip_type`,
       codes.`affix_code`,
       'MAIN',
       bands.`min_req_level`,
       bands.`max_req_level`,
       20
FROM (
    SELECT 'TOP' AS equip_type
    UNION ALL SELECT 'BOTTOM'
) types
JOIN (
    SELECT 'STR' AS affix_code
    UNION ALL SELECT 'DEX'
    UNION ALL SELECT 'INT'
    UNION ALL SELECT 'LUK'
) codes ON 1 = 1
JOIN (
    SELECT DISTINCT `min_req_level`, `max_req_level`
    FROM `equipment_affix_level_pool`
    WHERE `equip_type` = 'WEAPON'
      AND `affix_code` = 'STR'
      AND `affix_group` = 'MAIN'
) bands ON 1 = 1;

-- Pendants gain a low-weight attribute-oriented primary route.
INSERT IGNORE INTO `equipment_affix_pool`
(`equip_type`, `affix_code`, `affix_group`, `weight`)
VALUES
    ('PENDANT', 'STR', 'MAIN', 20), ('PENDANT', 'DEX', 'MAIN', 20),
    ('PENDANT', 'INT', 'MAIN', 20), ('PENDANT', 'LUK', 'MAIN', 20);

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`)
SELECT 'PENDANT',
       codes.`affix_code`,
       'MAIN',
       bands.`min_req_level`,
       bands.`max_req_level`,
       20
FROM (
    SELECT 'STR' AS affix_code
    UNION ALL SELECT 'DEX'
    UNION ALL SELECT 'INT'
    UNION ALL SELECT 'LUK'
) codes
JOIN (
    SELECT DISTINCT `min_req_level`, `max_req_level`
    FROM `equipment_affix_level_pool`
    WHERE `equip_type` = 'WEAPON'
      AND `affix_code` = 'STR'
      AND `affix_group` = 'MAIN'
) bands ON 1 = 1;

-- Rings specialize in progression/economy effects; other accessories
-- specialize in boss combat effects.
UPDATE `equipment_affix_pool`
SET `enabled` = 0
WHERE (`equip_type` = 'RING' AND `affix_code` = 'BOSS_DAMAGE')
   OR (`equip_type` = 'ACCESSORY'
       AND `affix_code` IN ('DROP_RATE', 'EXP_RATE', 'MESO_RATE'));

UPDATE `equipment_affix_level_pool`
SET `enabled` = 0
WHERE (`equip_type` = 'RING' AND `affix_code` = 'BOSS_DAMAGE')
   OR (`equip_type` = 'ACCESSORY'
       AND `affix_code` IN ('DROP_RATE', 'EXP_RATE', 'MESO_RATE'));

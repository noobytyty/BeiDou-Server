-- Fill type-appropriate candidates so configured primary/secondary slots can
-- be populated without falling back to an unrelated universal pool.
INSERT IGNORE INTO `equipment_affix_pool`
(`equip_type`, `affix_code`, `affix_group`, `weight`)
VALUES
    ('SHOES', 'STR', 'MAIN', 20), ('SHOES', 'DEX', 'MAIN', 20),
    ('SHOES', 'INT', 'MAIN', 20), ('SHOES', 'LUK', 'MAIN', 20),
    ('GLOVE', 'STR', 'MAIN', 20), ('GLOVE', 'DEX', 'MAIN', 20),
    ('GLOVE', 'INT', 'MAIN', 20), ('GLOVE', 'LUK', 'MAIN', 20),
    ('GLOVE', 'ACC', 'SECONDARY', 10), ('GLOVE', 'AVOID', 'SECONDARY', 10);

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`)
SELECT types.`equip_type`,
       codes.`affix_code`,
       'MAIN',
       bands.`min_req_level`,
       bands.`max_req_level`,
       20
FROM (
    SELECT 'SHOES' AS equip_type
    UNION ALL SELECT 'GLOVE'
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

-- Defensive equipment can also roll its core defensive values as secondary
-- affixes, while movement remains the natural secondary pool for shoes.
INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`)
SELECT pool.`equip_type`,
       pool.`affix_code`,
       'SECONDARY',
       pool.`min_req_level`,
       pool.`max_req_level`,
       GREATEST(3, FLOOR(pool.`weight` * 0.10))
FROM `equipment_affix_level_pool` pool
WHERE pool.`affix_group` = 'MAIN'
  AND pool.`equip_type` IN ('HAT', 'TOP', 'BOTTOM', 'SHOES', 'CAPE', 'PENDANT')
  AND pool.`affix_code` IN ('HP', 'MP', 'WDEF', 'MDEF');

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`)
SELECT 'GLOVE',
       codes.`affix_code`,
       'SECONDARY',
       bands.`min_req_level`,
       bands.`max_req_level`,
       10
FROM (
    SELECT 'ACC' AS affix_code
    UNION ALL SELECT 'AVOID'
) codes
JOIN (
    SELECT DISTINCT `min_req_level`, `max_req_level`
    FROM `equipment_affix_level_pool`
    WHERE `equip_type` = 'WEAPON'
) bands ON 1 = 1;

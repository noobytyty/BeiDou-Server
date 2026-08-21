-- Add additional two-stat combinations. Pool and level availability are
-- copied from comparable existing affixes so every combination follows the
-- same equipment and level restrictions as its component family.
INSERT IGNORE INTO `equipment_affix_definition`
(`affix_code`, `name_key`, `value_type`, `effect_type`, `max_per_item`, `display_order`)
VALUES
    ('STR_INT', 'equipment.affix.str_int', 'FLAT', 'ATTRIBUTE', 1, 50),
    ('DEX_LUK', 'equipment.affix.dex_luk', 'FLAT', 'ATTRIBUTE', 1, 51),
    ('WDEF_MDEF', 'equipment.affix.wdef_mdef', 'FLAT', 'ATTRIBUTE', 1, 122);

INSERT IGNORE INTO `equipment_affix_range`
(`affix_code`, `rarity`, `min_value`, `max_value`, `weight`)
SELECT 'STR_INT', `rarity`, `min_value`, `max_value`, `weight`
FROM `equipment_affix_range`
WHERE `affix_code` = 'STR_DEX';

INSERT IGNORE INTO `equipment_affix_range`
(`affix_code`, `rarity`, `min_value`, `max_value`, `weight`)
SELECT 'DEX_LUK', `rarity`, `min_value`, `max_value`, `weight`
FROM `equipment_affix_range`
WHERE `affix_code` = 'STR_DEX';

INSERT IGNORE INTO `equipment_affix_range`
(`affix_code`, `rarity`, `min_value`, `max_value`, `weight`)
SELECT 'WDEF_MDEF', `rarity`, `min_value`, `max_value`, `weight`
FROM `equipment_affix_range`
WHERE `affix_code` = 'WDEF';

INSERT IGNORE INTO `equipment_affix_name`
(`affix_code`, `affix_tier`, `name_key`, `priority`)
SELECT codes.`affix_code`,
       names.`affix_tier`,
       CONCAT('equipment.prefix.', LOWER(codes.`affix_code`), '.t', names.`affix_tier`),
       codes.`priority`
FROM (
    SELECT 'STR_INT' AS affix_code, 50 AS priority
    UNION ALL SELECT 'DEX_LUK', 51
    UNION ALL SELECT 'WDEF_MDEF', 122
) codes
JOIN (
    SELECT DISTINCT `affix_tier`
    FROM `equipment_affix_name`
) names ON 1 = 1;

INSERT IGNORE INTO `equipment_affix_pool`
(`equip_type`, `affix_code`, `affix_group`, `weight`, `enabled`)
SELECT `equip_type`, 'STR_INT', `affix_group`, `weight`, `enabled`
FROM `equipment_affix_pool`
WHERE `affix_code` = 'STR_DEX';

INSERT IGNORE INTO `equipment_affix_pool`
(`equip_type`, `affix_code`, `affix_group`, `weight`, `enabled`)
SELECT `equip_type`, 'DEX_LUK', `affix_group`, `weight`, `enabled`
FROM `equipment_affix_pool`
WHERE `affix_code` = 'STR_DEX';

INSERT IGNORE INTO `equipment_affix_pool`
(`equip_type`, `affix_code`, `affix_group`, `weight`, `enabled`)
SELECT `equip_type`, 'WDEF_MDEF', `affix_group`, `weight`, `enabled`
FROM `equipment_affix_pool`
WHERE `affix_code` = 'WDEF';

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`)
SELECT `equip_type`, 'STR_INT', `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`
FROM `equipment_affix_level_pool`
WHERE `affix_code` = 'STR_DEX';

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`)
SELECT `equip_type`, 'DEX_LUK', `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`
FROM `equipment_affix_level_pool`
WHERE `affix_code` = 'STR_DEX';

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`)
SELECT `equip_type`, 'WDEF_MDEF', `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`
FROM `equipment_affix_level_pool`
WHERE `affix_code` = 'WDEF';

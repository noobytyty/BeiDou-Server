-- Add mixed effects that share the same percentage scale and have clear
-- combat or economy value.
INSERT IGNORE INTO `equipment_affix_definition`
(`affix_code`, `name_key`, `value_type`, `effect_type`, `max_per_item`, `display_order`)
VALUES
    ('BOSS_DAMAGE_IGNORE_DEFENSE', 'equipment.affix.boss_damage_ignore_defense', 'PERCENT', 'SPECIAL', 1, 181),
    ('DROP_EXP', 'equipment.affix.drop_exp', 'PERCENT', 'SPECIAL', 1, 182),
    ('EXP_MESO', 'equipment.affix.exp_meso', 'PERCENT', 'SPECIAL', 1, 183),
    ('DROP_MESO', 'equipment.affix.drop_meso', 'PERCENT', 'SPECIAL', 1, 184);

INSERT IGNORE INTO `equipment_affix_range`
(`affix_code`, `rarity`, `min_value`, `max_value`, `weight`)
SELECT codes.`affix_code`, ranges.`rarity`, ranges.`min_value`, ranges.`max_value`, ranges.`weight`
FROM (
    SELECT 'BOSS_DAMAGE_IGNORE_DEFENSE' AS affix_code
    UNION ALL SELECT 'DROP_EXP'
    UNION ALL SELECT 'EXP_MESO'
    UNION ALL SELECT 'DROP_MESO'
) codes
JOIN `equipment_affix_range` ranges
  ON ranges.`affix_code` = 'BOSS_DAMAGE';

INSERT IGNORE INTO `equipment_affix_name`
(`affix_code`, `affix_tier`, `name_key`, `priority`)
SELECT codes.`affix_code`,
       tiers.`affix_tier`,
       CONCAT('equipment.prefix.', LOWER(codes.`affix_code`), '.t', tiers.`affix_tier`),
       codes.`priority`
FROM (
    SELECT 'BOSS_DAMAGE_IGNORE_DEFENSE' AS affix_code, 181 AS priority
    UNION ALL SELECT 'DROP_EXP', 182
    UNION ALL SELECT 'EXP_MESO', 183
    UNION ALL SELECT 'DROP_MESO', 184
) codes
JOIN (
    SELECT DISTINCT `affix_tier`
    FROM `equipment_affix_name`
) tiers ON 1 = 1;

INSERT IGNORE INTO `equipment_affix_pool`
(`equip_type`, `affix_code`, `affix_group`, `weight`, `enabled`)
SELECT `equip_type`, 'BOSS_DAMAGE_IGNORE_DEFENSE', `affix_group`, `weight`, `enabled`
FROM `equipment_affix_pool`
WHERE `affix_code` = 'BOSS_DAMAGE';

INSERT IGNORE INTO `equipment_affix_pool`
(`equip_type`, `affix_code`, `affix_group`, `weight`, `enabled`)
SELECT `equip_type`, 'DROP_EXP', `affix_group`, `weight`, `enabled`
FROM `equipment_affix_pool`
WHERE `affix_code` = 'DROP_RATE';

INSERT IGNORE INTO `equipment_affix_pool`
(`equip_type`, `affix_code`, `affix_group`, `weight`, `enabled`)
SELECT `equip_type`, 'EXP_MESO', `affix_group`, `weight`, `enabled`
FROM `equipment_affix_pool`
WHERE `affix_code` = 'EXP_RATE';

INSERT IGNORE INTO `equipment_affix_pool`
(`equip_type`, `affix_code`, `affix_group`, `weight`, `enabled`)
SELECT `equip_type`, 'DROP_MESO', `affix_group`, `weight`, `enabled`
FROM `equipment_affix_pool`
WHERE `affix_code` = 'DROP_RATE';

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`)
SELECT `equip_type`, 'BOSS_DAMAGE_IGNORE_DEFENSE', `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`
FROM `equipment_affix_level_pool`
WHERE `affix_code` = 'BOSS_DAMAGE';

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`)
SELECT `equip_type`, 'DROP_EXP', `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`
FROM `equipment_affix_level_pool`
WHERE `affix_code` = 'DROP_RATE';

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`)
SELECT `equip_type`, 'EXP_MESO', `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`
FROM `equipment_affix_level_pool`
WHERE `affix_code` = 'EXP_RATE';

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`)
SELECT `equip_type`, 'DROP_MESO', `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`
FROM `equipment_affix_level_pool`
WHERE `affix_code` = 'DROP_RATE';

-- Element-specialization affixes for wands and staffs. The server maps
-- elemental weapon families to FIRE/ICE/LIGHTNING/HOLY at runtime.
INSERT IGNORE INTO `equipment_affix_definition`
(`affix_code`, `name_key`, `value_type`, `effect_type`, `max_per_item`, `display_order`)
VALUES
    ('FIRE_DAMAGE', 'equipment.affix.fire_damage', 'PERCENT', 'SPECIAL', 1, 185),
    ('ICE_DAMAGE', 'equipment.affix.ice_damage', 'PERCENT', 'SPECIAL', 1, 186),
    ('LIGHTNING_DAMAGE', 'equipment.affix.lightning_damage', 'PERCENT', 'SPECIAL', 1, 187),
    ('HOLY_DAMAGE', 'equipment.affix.holy_damage', 'PERCENT', 'SPECIAL', 1, 188);

INSERT IGNORE INTO `equipment_affix_range`
(`affix_code`, `rarity`, `min_value`, `max_value`, `weight`)
SELECT codes.`affix_code`, ranges.`rarity`, ranges.`min_value`, ranges.`max_value`, ranges.`weight`
FROM (
    SELECT 'FIRE_DAMAGE' AS affix_code
    UNION ALL SELECT 'ICE_DAMAGE'
    UNION ALL SELECT 'LIGHTNING_DAMAGE'
    UNION ALL SELECT 'HOLY_DAMAGE'
) codes
JOIN `equipment_affix_range` ranges ON ranges.`affix_code` = 'BOSS_DAMAGE';

INSERT IGNORE INTO `equipment_affix_name`
(`affix_code`, `affix_tier`, `name_key`, `priority`)
SELECT codes.`affix_code`, tiers.`affix_tier`,
       CONCAT('equipment.prefix.', LOWER(codes.`affix_code`), '.t', tiers.`affix_tier`),
       codes.`priority`
FROM (
    SELECT 'FIRE_DAMAGE' AS affix_code, 185 AS priority
    UNION ALL SELECT 'ICE_DAMAGE', 186
    UNION ALL SELECT 'LIGHTNING_DAMAGE', 187
    UNION ALL SELECT 'HOLY_DAMAGE', 188
) codes
JOIN (SELECT DISTINCT `affix_tier` FROM `equipment_affix_name`) tiers ON 1 = 1;

INSERT IGNORE INTO `equipment_affix_pool`
(`equip_type`, `affix_code`, `affix_group`, `weight`, `enabled`)
SELECT 'WEAPON', codes.`affix_code`, 'SECONDARY', 18, 1
FROM (
    SELECT 'FIRE_DAMAGE' AS affix_code
    UNION ALL SELECT 'ICE_DAMAGE'
    UNION ALL SELECT 'LIGHTNING_DAMAGE'
    UNION ALL SELECT 'HOLY_DAMAGE'
) codes;

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`)
SELECT 'WEAPON', codes.`affix_code`, 'SECONDARY',
       bands.`min_req_level`, bands.`max_req_level`, 18, 1
FROM (
    SELECT 'FIRE_DAMAGE' AS affix_code
    UNION ALL SELECT 'ICE_DAMAGE'
    UNION ALL SELECT 'LIGHTNING_DAMAGE'
    UNION ALL SELECT 'HOLY_DAMAGE'
) codes
JOIN (
    SELECT 1 AS min_req_level, 255 AS max_req_level
) bands ON 1 = 1;

-- Earrings are the primary dropped accessory, so keep economy affixes on
-- earrings while leaving face and eye accessories combat-focused.
INSERT IGNORE INTO `equipment_affix_pool`
(`equip_type`, `affix_code`, `affix_group`, `weight`, `enabled`)
SELECT 'EARRING', `affix_code`, `affix_group`, `weight`, 1
FROM `equipment_affix_pool`
WHERE `equip_type` = 'ACCESSORY';

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`)
SELECT 'EARRING', `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`, 1
FROM `equipment_affix_level_pool`
WHERE `equip_type` = 'ACCESSORY';

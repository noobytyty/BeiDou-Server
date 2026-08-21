-- Overall equipment uses the same defensive and attribute routes as tops,
-- but is kept as a distinct equipment type for future balancing.
INSERT IGNORE INTO `equipment_affix_pool`
(`equip_type`, `affix_code`, `affix_group`, `weight`, `enabled`)
SELECT 'OVERALL', `affix_code`, `affix_group`, `weight`, `enabled`
FROM `equipment_affix_pool`
WHERE `equip_type` = 'TOP';

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`)
SELECT 'OVERALL', `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`, `enabled`
FROM `equipment_affix_level_pool`
WHERE `equip_type` = 'TOP';

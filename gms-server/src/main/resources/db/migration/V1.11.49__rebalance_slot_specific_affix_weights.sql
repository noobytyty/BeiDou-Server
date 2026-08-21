-- Give each equipment slot a clear identity. Core attributes remain
-- available everywhere, while the most relevant routes are weighted higher.
UPDATE `equipment_affix_pool`
SET `weight` = CASE
    WHEN `equip_type` = 'WEAPON' AND `affix_code` IN ('WATK', 'MATK') THEN 100
    WHEN `equip_type` = 'WEAPON' AND `affix_code` IN ('STR_WATK', 'DEX_WATK', 'LUK_WATK', 'INT_MATK') THEN 45
    WHEN `equip_type` = 'WEAPON' AND `affix_code` IN ('BOSS_DAMAGE', 'IGNORE_DEFENSE') THEN 70
    WHEN `equip_type` = 'WEAPON' THEN 10
    WHEN `equip_type` IN ('TOP', 'BOTTOM', 'OVERALL')
         AND `affix_code` IN ('HP', 'MP', 'WDEF', 'MDEF') THEN 90
    WHEN `equip_type` IN ('TOP', 'BOTTOM', 'OVERALL')
         AND `affix_code` IN ('BOSS_DAMAGE_REDUCTION', 'HP_MP', 'WDEF_MDEF') THEN 45
    WHEN `equip_type` IN ('TOP', 'BOTTOM', 'OVERALL')
         AND `affix_code` IN ('STR', 'DEX', 'INT', 'LUK') THEN 25
    WHEN `equip_type` IN ('TOP', 'BOTTOM', 'OVERALL') THEN 12
    WHEN `equip_type` = 'SHOES'
         AND `affix_code` IN ('SPEED', 'JUMP', 'SPEED_JUMP', 'DEX_SPEED', 'DEX_JUMP') THEN 90
    WHEN `equip_type` = 'SHOES'
         AND `affix_code` IN ('HP', 'MP') THEN 55
    WHEN `equip_type` = 'GLOVE'
         AND `affix_code` IN ('WATK', 'MATK', 'STR_WATK', 'DEX_WATK', 'LUK_WATK', 'INT_MATK') THEN 100
    WHEN `equip_type` = 'GLOVE'
         AND `affix_code` IN ('ACC', 'AVOID', 'ACC_AVOID', 'WATK_ACC') THEN 45
    WHEN `equip_type` = 'CAPE'
         AND `affix_code` IN ('HP', 'MP', 'WATK', 'MATK', 'HP_MP') THEN 65
    WHEN `equip_type` = 'CAPE'
         AND `affix_code` IN ('BOSS_DAMAGE', 'IGNORE_DEFENSE') THEN 45
    WHEN `equip_type` = 'RING'
         AND `affix_code` IN ('DROP_RATE', 'EXP_RATE', 'MESO_RATE', 'DROP_EXP', 'EXP_MESO', 'DROP_MESO') THEN 100
    WHEN `equip_type` = 'RING'
         AND `affix_code` IN ('STR', 'DEX', 'INT', 'LUK', 'HP', 'MP') THEN 70
    WHEN `equip_type` = 'RING' THEN 15
    WHEN `equip_type` = 'EARRING'
         AND `affix_code` IN ('DROP_RATE', 'EXP_RATE', 'MESO_RATE', 'DROP_EXP', 'EXP_MESO', 'DROP_MESO') THEN 120
    WHEN `equip_type` = 'EARRING'
         AND `affix_code` IN ('HP', 'MP', 'HP_MP', 'STR_MP', 'LUK_MP', 'INT_MP') THEN 75
    WHEN `equip_type` = 'PENDANT'
         AND `affix_code` IN ('HP', 'MP', 'WDEF', 'MDEF', 'HP_MP', 'WDEF_MDEF') THEN 80
    WHEN `equip_type` = 'PENDANT'
         AND `affix_code` IN ('BOSS_DAMAGE', 'IGNORE_DEFENSE', 'BOSS_DAMAGE_REDUCTION') THEN 50
    WHEN `equip_type` = 'ACCESSORY'
         AND `affix_code` IN ('BOSS_DAMAGE', 'IGNORE_DEFENSE', 'BOSS_DAMAGE_IGNORE_DEFENSE') THEN 90
    WHEN `equip_type` = 'ACCESSORY'
         AND `affix_code` IN ('STR', 'DEX', 'INT', 'LUK') THEN 55
    ELSE `weight`
END;

UPDATE `equipment_affix_level_pool`
SET `weight` = CASE
    WHEN `equip_type` = 'WEAPON' AND `affix_code` IN ('WATK', 'MATK') THEN 100
    WHEN `equip_type` = 'WEAPON' AND `affix_code` IN ('STR_WATK', 'DEX_WATK', 'LUK_WATK', 'INT_MATK') THEN 45
    WHEN `equip_type` = 'WEAPON' AND `affix_code` IN ('BOSS_DAMAGE', 'IGNORE_DEFENSE') THEN 70
    WHEN `equip_type` = 'WEAPON' THEN 10
    WHEN `equip_type` IN ('TOP', 'BOTTOM', 'OVERALL') AND `affix_code` IN ('HP', 'MP', 'WDEF', 'MDEF') THEN 90
    WHEN `equip_type` IN ('TOP', 'BOTTOM', 'OVERALL') AND `affix_code` IN ('BOSS_DAMAGE_REDUCTION', 'HP_MP', 'WDEF_MDEF') THEN 45
    WHEN `equip_type` IN ('TOP', 'BOTTOM', 'OVERALL') AND `affix_code` IN ('STR', 'DEX', 'INT', 'LUK') THEN 25
    WHEN `equip_type` = 'SHOES' AND `affix_code` IN ('SPEED', 'JUMP', 'SPEED_JUMP', 'DEX_SPEED', 'DEX_JUMP') THEN 90
    WHEN `equip_type` = 'GLOVE' AND `affix_code` IN ('WATK', 'MATK', 'STR_WATK', 'DEX_WATK', 'LUK_WATK', 'INT_MATK') THEN 100
    WHEN `equip_type` = 'CAPE' AND `affix_code` IN ('HP', 'MP', 'WATK', 'MATK', 'HP_MP') THEN 65
    WHEN `equip_type` = 'RING' AND `affix_code` IN ('DROP_RATE', 'EXP_RATE', 'MESO_RATE', 'DROP_EXP', 'EXP_MESO', 'DROP_MESO') THEN 100
    WHEN `equip_type` = 'RING' AND `affix_code` IN ('STR', 'DEX', 'INT', 'LUK', 'HP', 'MP') THEN 70
    WHEN `equip_type` = 'EARRING' AND `affix_code` IN ('DROP_RATE', 'EXP_RATE', 'MESO_RATE', 'DROP_EXP', 'EXP_MESO', 'DROP_MESO') THEN 120
    WHEN `equip_type` = 'EARRING' AND `affix_code` IN ('HP', 'MP', 'HP_MP', 'STR_MP', 'LUK_MP', 'INT_MP') THEN 75
    WHEN `equip_type` = 'PENDANT' AND `affix_code` IN ('HP', 'MP', 'WDEF', 'MDEF', 'HP_MP', 'WDEF_MDEF') THEN 80
    WHEN `equip_type` = 'ACCESSORY' AND `affix_code` IN ('BOSS_DAMAGE', 'IGNORE_DEFENSE', 'BOSS_DAMAGE_IGNORE_DEFENSE') THEN 90
    ELSE `weight`
END;

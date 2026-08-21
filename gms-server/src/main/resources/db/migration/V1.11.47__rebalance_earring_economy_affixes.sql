-- Earrings are primarily obtained as drops, so emphasize economy and
-- resource utility while keeping combat affixes as low-weight alternatives.
UPDATE `equipment_affix_pool`
SET `weight` = CASE
    WHEN `affix_code` IN ('DROP_RATE', 'EXP_RATE', 'MESO_RATE') THEN 120
    WHEN `affix_code` IN ('DROP_EXP', 'EXP_MESO', 'DROP_MESO') THEN 70
    WHEN `affix_code` IN ('HP', 'MP', 'HP_MP', 'STR_MP', 'LUK_MP', 'INT_MP') THEN 75
    WHEN `affix_code` IN ('STR', 'DEX', 'INT', 'LUK', 'ALL_STAT') THEN 45
    WHEN `affix_code` IN ('WATK', 'MATK', 'STR_WATK', 'DEX_WATK', 'LUK_WATK', 'INT_MATK',
                          'WATK_MATK', 'WATK_ACC', 'MATK_MP', 'WATK_SPEED', 'MATK_MDEF') THEN 12
    WHEN `affix_code` IN ('BOSS_DAMAGE', 'IGNORE_DEFENSE', 'BOSS_DAMAGE_IGNORE_DEFENSE') THEN 10
    ELSE `weight`
END
WHERE `equip_type` = 'EARRING';

UPDATE `equipment_affix_level_pool`
SET `weight` = CASE
    WHEN `affix_code` IN ('DROP_RATE', 'EXP_RATE', 'MESO_RATE') THEN 120
    WHEN `affix_code` IN ('DROP_EXP', 'EXP_MESO', 'DROP_MESO') THEN 70
    WHEN `affix_code` IN ('HP', 'MP', 'HP_MP', 'STR_MP', 'LUK_MP', 'INT_MP') THEN 75
    WHEN `affix_code` IN ('STR', 'DEX', 'INT', 'LUK', 'ALL_STAT') THEN 45
    WHEN `affix_code` IN ('WATK', 'MATK', 'STR_WATK', 'DEX_WATK', 'LUK_WATK', 'INT_MATK',
                          'WATK_MATK', 'WATK_ACC', 'MATK_MP', 'WATK_SPEED', 'MATK_MDEF') THEN 12
    WHEN `affix_code` IN ('BOSS_DAMAGE', 'IGNORE_DEFENSE', 'BOSS_DAMAGE_IGNORE_DEFENSE') THEN 10
    ELSE `weight`
END
WHERE `equip_type` = 'EARRING';

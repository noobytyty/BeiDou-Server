-- Compress low-signal mixed affixes while retaining historical instances.
UPDATE `equipment_affix_pool`
SET `enabled` = 0
WHERE `affix_code` IN ('STR_DEX', 'INT_LUK', 'STR_INT', 'DEX_LUK', 'WATK_MATK');

UPDATE `equipment_affix_level_pool`
SET `enabled` = 0
WHERE `affix_code` IN ('STR_DEX', 'INT_LUK', 'STR_INT', 'DEX_LUK', 'WATK_MATK');

UPDATE `equipment_affix_pool`
SET `weight` = CASE
    WHEN `affix_code` IN (
        'BOSS_DAMAGE_IGNORE_DEFENSE', 'DROP_EXP', 'EXP_MESO', 'DROP_MESO',
        'STR_ACC', 'DEX_SPEED', 'INT_MP', 'LUK_AVOID',
        'WATK_ACC', 'MATK_MP', 'STR_HP', 'DEX_JUMP', 'INT_MDEF',
        'LUK_SPEED', 'WATK_SPEED', 'MATK_MDEF', 'STR_MP', 'DEX_HP',
        'INT_HP', 'LUK_MP', 'HP_MDEF', 'MP_MDEF', 'HP_ACC', 'MP_ACC'
    ) THEN LEAST(`weight`, 12)
    ELSE `weight`
END
WHERE `enabled` = 1;

UPDATE `equipment_affix_level_pool`
SET `weight` = CASE
    WHEN `affix_code` IN (
        'BOSS_DAMAGE_IGNORE_DEFENSE', 'DROP_EXP', 'EXP_MESO', 'DROP_MESO',
        'STR_ACC', 'DEX_SPEED', 'INT_MP', 'LUK_AVOID',
        'WATK_ACC', 'MATK_MP', 'STR_HP', 'DEX_JUMP', 'INT_MDEF',
        'LUK_SPEED', 'WATK_SPEED', 'MATK_MDEF', 'STR_MP', 'DEX_HP',
        'INT_HP', 'LUK_MP', 'HP_MDEF', 'MP_MDEF', 'HP_ACC', 'MP_ACC'
    ) THEN LEAST(`weight`, 12)
    ELSE `weight`
END
WHERE `enabled` = 1;

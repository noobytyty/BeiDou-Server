-- Keep single-stat and class-aligned combat affixes dominant while making
-- mixed utility affixes meaningful but less common.
UPDATE `equipment_affix_pool`
SET `weight` = CASE
    WHEN `affix_code` IN ('STR_WATK', 'DEX_WATK', 'LUK_WATK', 'INT_MATK') THEN 35
    WHEN `affix_code` IN ('STR_ACC', 'DEX_SPEED', 'INT_MP', 'LUK_AVOID',
                          'WATK_ACC', 'MATK_MP') THEN 20
    WHEN `affix_code` IN ('STR_HP', 'DEX_JUMP', 'INT_MDEF', 'LUK_SPEED',
                          'WATK_SPEED', 'MATK_MDEF', 'STR_MP', 'DEX_HP',
                          'INT_HP', 'LUK_MP', 'HP_MDEF', 'MP_MDEF',
                          'HP_ACC', 'MP_ACC') THEN 12
    WHEN `affix_code` IN ('BOSS_DAMAGE_IGNORE_DEFENSE', 'DROP_EXP',
                          'EXP_MESO', 'DROP_MESO') THEN 10
    ELSE `weight`
END
WHERE `affix_code` IN (
    'STR_WATK', 'DEX_WATK', 'LUK_WATK', 'INT_MATK',
    'STR_ACC', 'DEX_SPEED', 'INT_MP', 'LUK_AVOID', 'WATK_ACC', 'MATK_MP',
    'STR_HP', 'DEX_JUMP', 'INT_MDEF', 'LUK_SPEED', 'WATK_SPEED', 'MATK_MDEF',
    'STR_MP', 'DEX_HP', 'INT_HP', 'LUK_MP', 'HP_MDEF', 'MP_MDEF',
    'HP_ACC', 'MP_ACC', 'BOSS_DAMAGE_IGNORE_DEFENSE', 'DROP_EXP',
    'EXP_MESO', 'DROP_MESO'
);

UPDATE `equipment_affix_level_pool`
SET `weight` = CASE
    WHEN `affix_code` IN ('STR_WATK', 'DEX_WATK', 'LUK_WATK', 'INT_MATK') THEN 35
    WHEN `affix_code` IN ('STR_ACC', 'DEX_SPEED', 'INT_MP', 'LUK_AVOID',
                          'WATK_ACC', 'MATK_MP') THEN 20
    WHEN `affix_code` IN ('STR_HP', 'DEX_JUMP', 'INT_MDEF', 'LUK_SPEED',
                          'WATK_SPEED', 'MATK_MDEF', 'STR_MP', 'DEX_HP',
                          'INT_HP', 'LUK_MP', 'HP_MDEF', 'MP_MDEF',
                          'HP_ACC', 'MP_ACC') THEN 12
    WHEN `affix_code` IN ('BOSS_DAMAGE_IGNORE_DEFENSE', 'DROP_EXP',
                          'EXP_MESO', 'DROP_MESO') THEN 10
    ELSE `weight`
END
WHERE `affix_code` IN (
    'STR_WATK', 'DEX_WATK', 'LUK_WATK', 'INT_MATK',
    'STR_ACC', 'DEX_SPEED', 'INT_MP', 'LUK_AVOID', 'WATK_ACC', 'MATK_MP',
    'STR_HP', 'DEX_JUMP', 'INT_MDEF', 'LUK_SPEED', 'WATK_SPEED', 'MATK_MDEF',
    'STR_MP', 'DEX_HP', 'INT_HP', 'LUK_MP', 'HP_MDEF', 'MP_MDEF',
    'HP_ACC', 'MP_ACC', 'BOSS_DAMAGE_IGNORE_DEFENSE', 'DROP_EXP',
    'EXP_MESO', 'DROP_MESO'
);

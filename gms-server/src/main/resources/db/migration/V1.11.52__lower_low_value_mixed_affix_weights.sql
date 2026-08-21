-- Keep mixed affixes available as occasional utility rolls, but make
-- non-core resource and utility combinations materially rarer than core
-- attributes and class-oriented offensive combinations.
UPDATE `equipment_affix_pool`
SET `weight` = 4
WHERE `enabled` = 1
  AND `affix_code` IN (
      'STR_MP', 'LUK_MP', 'INT_MP',
      'DEX_HP', 'INT_HP',
      'HP_ACC', 'MP_ACC',
      'WATK_SPEED', 'MATK_MDEF',
      'INT_MDEF', 'LUK_SPEED', 'DEX_JUMP'
  );

UPDATE `equipment_affix_level_pool`
SET `weight` = 4
WHERE `enabled` = 1
  AND `affix_code` IN (
      'STR_MP', 'LUK_MP', 'INT_MP',
      'DEX_HP', 'INT_HP',
      'HP_ACC', 'MP_ACC',
      'WATK_SPEED', 'MATK_MDEF',
      'INT_MDEF', 'LUK_SPEED', 'DEX_JUMP'
  );

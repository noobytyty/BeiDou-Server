-- Cross-class primary-stat combinations have no meaningful value for the
-- single-primary-stat class design used by MapleStory v83. Keep historical
-- instances readable, but stop generating these combinations.
UPDATE `equipment_affix_pool`
SET `enabled` = 0
WHERE `affix_code` IN ('STR_DEX', 'INT_LUK', 'STR_INT', 'DEX_LUK');

UPDATE `equipment_affix_level_pool`
SET `enabled` = 0
WHERE `affix_code` IN ('STR_DEX', 'INT_LUK', 'STR_INT', 'DEX_LUK');

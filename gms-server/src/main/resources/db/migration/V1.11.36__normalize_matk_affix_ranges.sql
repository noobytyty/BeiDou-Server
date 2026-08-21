-- MATK is approximately half as effective as WATK in the MapleStory formula.
-- Keep displayed MATK values aligned with that ratio by doubling standalone
-- MATK ranges relative to the current WATK ranges.
UPDATE `equipment_affix_range` matk
JOIN `equipment_affix_range` watk
    ON watk.`affix_code` = 'WATK'
   AND watk.`affix_tier` = matk.`affix_tier`
SET matk.`min_value` = watk.`min_value` * 2,
    matk.`max_value` = watk.`max_value` * 2
WHERE matk.`affix_code` = 'MATK';

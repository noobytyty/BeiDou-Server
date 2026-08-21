-- Magic attack contributes roughly half as much as weapon attack.
-- Keep each MATK tier aligned with the corresponding WATK tier at 2x.
UPDATE `equipment_affix_range` matk
JOIN `equipment_affix_range` watk
    ON watk.`affix_code` = 'WATK'
   AND watk.`affix_tier` = matk.`affix_tier`
SET matk.`min_value` = watk.`min_value` * 2,
    matk.`max_value` = watk.`max_value` * 2
WHERE matk.`affix_code` = 'MATK';

-- Extend the shared affix tier scale from T1-T8 to T1-T12.
UPDATE `equipment_rarity_config`
SET `max_affix_tier` = CASE `rarity`
    WHEN 0 THEN 0
    WHEN 1 THEN 2
    WHEN 2 THEN 4
    WHEN 3 THEN 6
    WHEN 4 THEN 8
    WHEN 5 THEN 10
    WHEN 6 THEN 12
    ELSE `max_affix_tier`
END;

-- Scale each existing T8 range forward so every existing and mixed affix gets
-- consistent T9-T12 values without duplicating per-affix balance definitions.
INSERT IGNORE INTO `equipment_affix_range`
(`affix_code`, `rarity`, `affix_tier`, `min_value`, `max_value`, `weight`, `allow_duplicate`)
SELECT ranges.`affix_code`, 6, tiers.`affix_tier`,
       CEIL(ranges.`min_value` * tiers.`multiplier`),
       CEIL(ranges.`max_value` * tiers.`multiplier`),
       ranges.`weight`,
       ranges.`allow_duplicate`
FROM `equipment_affix_range` ranges
JOIN (
    SELECT 9 AS affix_tier, 1.15 AS multiplier
    UNION ALL SELECT 10, 1.35
    UNION ALL SELECT 11, 1.60
    UNION ALL SELECT 12, 1.90
) tiers ON 1 = 1
WHERE ranges.`affix_tier` = 8;

INSERT IGNORE INTO `equipment_affix_name`
(`affix_code`, `affix_tier`, `name_key`, `priority`)
SELECT names.`affix_code`,
       tiers.`affix_tier`,
       CONCAT('equipment.prefix.', LOWER(names.`affix_code`), '.t', tiers.`affix_tier`),
       names.`priority`
FROM `equipment_affix_name` names
JOIN (
    SELECT 9 AS affix_tier
    UNION ALL SELECT 10
    UNION ALL SELECT 11
    UNION ALL SELECT 12
) tiers ON 1 = 1
WHERE names.`affix_tier` = 8;

-- Rebalance the late tiers with clearer but still restrained progression.
-- T9/T10/T11/T12 use 1.15x/1.40x/1.75x/2.20x of the corresponding T8 range.
UPDATE `equipment_affix_range` current_range
JOIN `equipment_affix_range` tier_eight
    ON tier_eight.`affix_code` = current_range.`affix_code`
   AND tier_eight.`affix_tier` = 8
SET current_range.`min_value` = CEIL(tier_eight.`min_value` * CASE current_range.`affix_tier`
        WHEN 9 THEN 1.15
        WHEN 10 THEN 1.40
        WHEN 11 THEN 1.75
        WHEN 12 THEN 2.20
    END),
    current_range.`max_value` = CEIL(tier_eight.`max_value` * CASE current_range.`affix_tier`
        WHEN 9 THEN 1.15
        WHEN 10 THEN 1.40
        WHEN 11 THEN 1.75
        WHEN 12 THEN 2.20
    END)
WHERE current_range.`affix_tier` BETWEEN 9 AND 12;

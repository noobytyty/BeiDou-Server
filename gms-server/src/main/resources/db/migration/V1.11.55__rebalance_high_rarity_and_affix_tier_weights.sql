-- Slightly reduce the chance of high-rarity equipment while preserving the
-- existing quality progression and affix counts.
UPDATE `equipment_rarity_config`
SET `drop_weight` = CASE `rarity`
        WHEN 4 THEN 40
        WHEN 5 THEN 5
        WHEN 6 THEN 1
        ELSE `drop_weight`
    END,
    `boss_drop_weight` = CASE `rarity`
        WHEN 4 THEN 800
        WHEN 5 THEN 300
        WHEN 6 THEN 60
        ELSE `boss_drop_weight`
    END,
    `dungeon_drop_weight` = CASE `rarity`
        WHEN 4 THEN 500
        WHEN 5 THEN 300
        WHEN 6 THEN 75
        ELSE `dungeon_drop_weight`
    END,
    `gachapon_drop_weight` = CASE `rarity`
        WHEN 4 THEN 500
        WHEN 5 THEN 120
        WHEN 6 THEN 35
        ELSE `gachapon_drop_weight`
    END
WHERE `rarity` BETWEEN 4 AND 6;

-- Keep T1-T2 common, then progressively reduce higher tiers without changing
-- their numeric ranges or the equipment-level tier window.
UPDATE `equipment_affix_range`
SET `weight` = CASE `affix_tier`
        WHEN 3 THEN 95
        WHEN 4 THEN 90
        WHEN 5 THEN 80
        WHEN 6 THEN 70
        WHEN 7 THEN 60
        WHEN 8 THEN 50
        WHEN 9 THEN 40
        WHEN 10 THEN 30
        WHEN 11 THEN 20
        WHEN 12 THEN 12
        ELSE `weight`
    END
WHERE `affix_tier` BETWEEN 3 AND 12
  AND `enabled` = 1;

-- Allow a small chance for core primary affixes to appear as secondary affixes.
-- The group-aware unique keys permit the same affix code in both pools.
ALTER TABLE `equipment_affix_pool`
    DROP INDEX `uk_equip_affix`,
    ADD UNIQUE KEY `uk_equip_affix_group` (`equip_type`, `affix_code`, `affix_group`);

ALTER TABLE `equipment_affix_level_pool`
    DROP INDEX `uk_level_affix_pool`,
    ADD UNIQUE KEY `uk_level_pool_group`
        (`equip_type`, `affix_code`, `min_req_level`, `max_req_level`, `affix_group`);

INSERT IGNORE INTO `equipment_affix_level_pool`
(`equip_type`, `affix_code`, `affix_group`, `min_req_level`, `max_req_level`, `weight`)
SELECT pool.`equip_type`,
       pool.`affix_code`,
       'SECONDARY',
       pool.`min_req_level`,
       pool.`max_req_level`,
       GREATEST(3, FLOOR(pool.`weight` * 0.10))
FROM `equipment_affix_level_pool` pool
WHERE pool.`affix_group` = 'MAIN'
  AND pool.`affix_code` IN ('STR', 'DEX', 'INT', 'LUK', 'WATK', 'MATK');

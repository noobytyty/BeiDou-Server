-- 方案A：装备品质重新限制可抽取的最高词缀阶级（激进档）
--
-- 说明：
--   V1.11.26 时期曾用 equipment_rarity_config.max_affix_tier 控制品质阶级上限，
--   V1.11.37 认为"阶级仅由需求等级决定"将其删除，导致低级品质也能随出高阶级（超模）。
--   本迁移重新引入该上限（采用更缓和的激进档数值），只影响新掉落与 @reroll 的抽取，
--   不修改已有装备实例，也不修改词条数值范围与命名。
--
-- 激进档：精良 T4 / 稀有 T6 / 史诗 T8 / 传奇 T10 / 远古 T11 / 神话 T12

ALTER TABLE `equipment_rarity_config`
    ADD COLUMN `max_affix_tier` TINYINT UNSIGNED NOT NULL DEFAULT 12
        COMMENT '该品质允许抽取的最高词缀阶级(T1-T12)，实际阶级 = min(等级窗口上限, 本值)' AFTER `secondary_affix_count`;

UPDATE `equipment_rarity_config`
SET `max_affix_tier` = CASE `rarity`
        WHEN 0 THEN 4    -- 普通：无词条（占位值，不生效）
        WHEN 1 THEN 4    -- 精良
        WHEN 2 THEN 6    -- 稀有
        WHEN 3 THEN 8    -- 史诗
        WHEN 4 THEN 10   -- 传奇
        WHEN 5 THEN 11   -- 远古
        WHEN 6 THEN 12   -- 神话
        ELSE 12
    END;

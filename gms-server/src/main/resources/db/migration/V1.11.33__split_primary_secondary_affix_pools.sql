-- Split affixes into independent primary and secondary groups.
ALTER TABLE `equipment_rarity_config`
    ADD COLUMN `main_affix_count` TINYINT UNSIGNED NOT NULL DEFAULT 0
        COMMENT '主词缀数量',
    ADD COLUMN `secondary_affix_count` TINYINT UNSIGNED NOT NULL DEFAULT 0
        COMMENT '副词缀数量';

UPDATE `equipment_rarity_config`
SET `main_affix_count` = CASE `rarity`
        WHEN 0 THEN 0
        WHEN 1 THEN 1
        WHEN 2 THEN 2
        WHEN 3 THEN 2
        WHEN 4 THEN 3
        WHEN 5 THEN 3
        WHEN 6 THEN 3
        ELSE 0
    END,
    `secondary_affix_count` = CASE `rarity`
        WHEN 0 THEN 0
        WHEN 1 THEN 0
        WHEN 2 THEN 0
        WHEN 3 THEN 1
        WHEN 4 THEN 1
        WHEN 5 THEN 2
        WHEN 6 THEN 3
        ELSE 0
    END;

ALTER TABLE `equipment_affix_pool`
    ADD COLUMN `affix_group` VARCHAR(16) NOT NULL DEFAULT 'MAIN'
        COMMENT 'MAIN 主词缀，SECONDARY 副词缀';

ALTER TABLE `equipment_affix_level_pool`
    ADD COLUMN `affix_group` VARCHAR(16) NOT NULL DEFAULT 'MAIN'
        COMMENT 'MAIN 主词缀，SECONDARY 副词缀';

UPDATE `equipment_affix_pool`
SET `affix_group` = CASE
        WHEN `affix_code` IN (
            'ACC', 'AVOID', 'SPEED', 'JUMP', 'BOSS_DAMAGE', 'IGNORE_DEFENSE',
            'DROP_RATE', 'EXP_RATE', 'MESO_RATE', 'BOSS_DAMAGE_REDUCTION',
            'ACC_AVOID', 'SPEED_JUMP'
        ) THEN 'SECONDARY'
        ELSE 'MAIN'
    END;

UPDATE `equipment_affix_level_pool`
SET `affix_group` = CASE
        WHEN `affix_code` IN (
            'ACC', 'AVOID', 'SPEED', 'JUMP', 'BOSS_DAMAGE', 'IGNORE_DEFENSE',
            'DROP_RATE', 'EXP_RATE', 'MESO_RATE', 'BOSS_DAMAGE_REDUCTION',
            'ACC_AVOID', 'SPEED_JUMP'
        ) THEN 'SECONDARY'
        ELSE 'MAIN'
    END;

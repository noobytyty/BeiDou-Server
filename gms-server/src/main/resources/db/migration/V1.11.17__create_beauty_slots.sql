-- 美容存档槽位：每个账号独立的发型/脸型存档（基础各 5 个，可花钱扩展）
CREATE TABLE IF NOT EXISTS `beauty_slots`
(
    `id`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `account_id` INT             NOT NULL,
    `slot_type`  TINYINT         NOT NULL COMMENT '0=发型 1=脸型',
    `slot_index` TINYINT         NOT NULL COMMENT '槽位下标 0 起',
    `item_id`    INT             NOT NULL COMMENT '发型/脸型ID（含颜色）',
    `created_at` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_account_slot` (`account_id`, `slot_type`, `slot_index`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4;

-- 账号美容槽位上限（基础 5，购买扩展 +1）
ALTER TABLE `accounts`
    ADD COLUMN `beauty_hair_slots` TINYINT UNSIGNED NOT NULL DEFAULT 5 COMMENT '发型存档槽位数',
    ADD COLUMN `beauty_face_slots` TINYINT UNSIGNED NOT NULL DEFAULT 5 COMMENT '脸型存档槽位数';

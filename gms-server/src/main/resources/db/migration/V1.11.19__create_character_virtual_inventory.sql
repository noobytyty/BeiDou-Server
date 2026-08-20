CREATE TABLE IF NOT EXISTS `character_virtual_inventory`
(
    `id`             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `character_id`   INT             NOT NULL,
    `inventory_type` TINYINT         NOT NULL COMMENT '1=scroll, 2=ore',
    `item_id`        INT             NOT NULL,
    `quantity`       INT UNSIGNED    NOT NULL DEFAULT 0,
    `created_at`     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_character_virtual_inventory` (`character_id`, `inventory_type`, `item_id`),
    KEY `idx_character_virtual_inventory_character` (`character_id`, `inventory_type`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4;

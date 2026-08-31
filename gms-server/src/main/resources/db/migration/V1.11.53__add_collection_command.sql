INSERT INTO `command_info` (`syntax`, `level`, `enabled`, `clazz`, `default_level`)
SELECT 'collection', 0, 1, 'CollectionCommand', 0
WHERE NOT EXISTS (
    SELECT 1 FROM `command_info` WHERE `syntax` = 'collection'
);

INSERT INTO `command_info` (`syntax`, `level`, `enabled`, `clazz`, `default_level`)
SELECT 'collect', 0, 1, 'CollectionCommand', 0
WHERE NOT EXISTS (
    SELECT 1 FROM `command_info` WHERE `syntax` = 'collect'
);

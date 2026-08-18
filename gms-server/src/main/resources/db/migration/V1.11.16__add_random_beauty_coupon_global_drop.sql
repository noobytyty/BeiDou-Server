-- 随机美容券 2438000：全局掉落（continent=-1 表示所有大陆所有怪物，chance 基于 1000000，1000 = 0.1%）
INSERT INTO `drop_data_global` (`continent`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`, `comments`)
VALUES (-1, 2438000, 1, 1, 0, 1000, 'Random Beauty Coupon 2438000');

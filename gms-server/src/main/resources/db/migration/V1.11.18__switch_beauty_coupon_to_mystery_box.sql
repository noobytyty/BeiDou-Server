-- 随机美容券改用神秘盒子(2430029)：全局掉落物品从 2438000 迁移到 2430029（复用已有图标的道具）
UPDATE `drop_data_global`
SET `itemid` = 2430029
WHERE `itemid` = 2438000;

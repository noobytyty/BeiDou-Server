-- Ravana Helmet has no corresponding boss encounter in the current WZ data.
-- Make the existing equipment available through the common forge progression.
INSERT IGNORE INTO `makercreatedata`
(`id`, `itemid`, `req_level`, `req_maker_level`, `req_meso`, `req_item`, `req_equip`, `catalyst`, `quantity`, `tuc`)
VALUES
    (1, 1003068, 120, 3, 2500000, 0, 0, 0, 1, 1);

INSERT IGNORE INTO `makerrecipedata`
(`itemid`, `req_item`, `count`)
VALUES
    (1003068, 4001083, 3),
    (1003068, 4001084, 1),
    (1003068, 4001085, 1),
    (1003068, 4260001, 15),
    (1003068, 4020009, 10),
    (1003068, 4007004, 20);

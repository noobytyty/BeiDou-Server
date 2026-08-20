-- Reuse the existing Zakum Certificate item as the universal forge token.
-- The item already has client-side icon and string resources.
INSERT IGNORE INTO `drop_data`
(`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`)
VALUES
    (8500002, 4001083, 1, 2, 0, 999999),
    (8510000, 4001083, 1, 2, 0, 999999),
    (8520000, 4001083, 1, 2, 0, 999999),
    (8800002, 4001083, 2, 3, 0, 999999),
    (8810018, 4001083, 3, 4, 0, 999999);

-- 8510000 is Pianus in the current WZ data; there is no Ravana encounter.
DELETE FROM `drop_data`
WHERE `dropperid` = 8510000
  AND `itemid` = 1003068
  AND `questid` = 0;

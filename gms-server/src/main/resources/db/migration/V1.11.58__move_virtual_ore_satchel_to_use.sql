-- The virtual ore satchel is a scripted USE item; migrate legacy character
-- inventory rows that were previously stored in the ETC tab.
UPDATE `inventoryitems`
SET `inventorytype` = 2
WHERE `type` = 1
  AND `characterid` IS NOT NULL
  AND `itemid` = 2430012
  AND `inventorytype` = 4;

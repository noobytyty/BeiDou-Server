-- Commodity.img is the authoritative source for the item delivered by a cash shop SN.
-- Existing item_id overrides can make the client display one item while the server grants another.
UPDATE `modified_cash_item`
SET `item_id` = NULL
WHERE `item_id` IS NOT NULL;

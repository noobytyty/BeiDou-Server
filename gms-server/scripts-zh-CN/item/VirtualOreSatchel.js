var BAG_TYPE = 2;
var status = 0;
var selectedItemId = 0;

function start() {
    im.prepareVirtualInventory(BAG_TYPE);
    if (im.hasVirtualInventoryItems(BAG_TYPE)) {
        status = 0;
        im.sendSimple(im.getVirtualInventoryMenuText(BAG_TYPE));
    } else {
        im.sendOk(im.getVirtualInventoryMenuText(BAG_TYPE));
        im.dispose();
    }
}

function action(mode, type, selection) {
    if (mode !== 1) {
        im.dispose();
        return;
    }

    if (status === 0) {
        selectedItemId = im.getVirtualInventoryEntryItemId(BAG_TYPE, selection);
        var maxQuantity = im.getVirtualInventoryEntryQuantity(BAG_TYPE, selectedItemId);
        if (selectedItemId <= 0 || maxQuantity <= 0) {
            im.sendOk(im.getVirtualInventoryMenuText(BAG_TYPE));
            im.dispose();
            return;
        }
        status = 1;
        im.sendGetNumber(im.getVirtualInventoryWithdrawPrompt(BAG_TYPE, selectedItemId), 1, 1, maxQuantity);
        return;
    }

    im.sendOk(im.withdrawVirtualInventoryItem(BAG_TYPE, selectedItemId, selection));
    im.dispose();
}

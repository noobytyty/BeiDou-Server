/**
 * BeiDou NPC
 *
 * Beautician 9977778
 *
 * Direct hairstyle and face selection is disabled. Saved hairstyles, faces,
 * and skin colors, slot purchases, and preview-room application remain.
 */
var beautyMode = -1;
var slotMode = -1;
var slotType = -1;
var slotStep = 0;
var slotSel = -1;
var previewOrig = -1;
var previewChoices = [];
var beautySlotPrice = 5000000;
var SLOT_HAIR = 0;
var SLOT_FACE = 1;
var SLOT_SKIN = 2;
var SLOT_PURCHASE = 5;
var SLOT_EXIT = 6;
var slotSvc = Java.type("org.gms.server.BeautySlotService").getInstance();
var SKIN_NAMES = {
    0: "Normal",
    1: "Dark",
    2: "Black",
    3: "Pale",
    4: "Blue",
    5: "Green",
    9: "White",
    10: "Pink"
};

function beautyTypeName(type) {
    return type == SLOT_HAIR ? "hairstyle" : type == SLOT_FACE ? "face" : "skin color";
}

function beautyStyleLabel(type, itemId) {
    if (type == SLOT_SKIN) {
        return "skin color " + itemId + " (" + (SKIN_NAMES[itemId] || "unknown") + ")";
    }
    return "#t" + itemId + "#";
}

function currentBeautyStyle(player, type) {
    if (type == SLOT_HAIR) {
        return player.getHair();
    }
    if (type == SLOT_FACE) {
        return player.getFace();
    }
    return player.getSkinColor().getId();
}

function applyBeautyStyle(cm, type, itemId) {
    if (type == SLOT_HAIR) {
        cm.setHair(itemId);
    } else if (type == SLOT_FACE) {
        cm.setFace(itemId);
    } else {
        cm.setSkin(itemId);
    }
}

function currentBeautyLabel(player, type) {
    return beautyStyleLabel(type, currentBeautyStyle(player, type));
}

function beautyMainMenu() {
    beautyMode = -1;
    slotMode = -1;
    slotType = -1;
    slotStep = 0;
    slotSel = -1;
    previewOrig = -1;
    previewChoices = [];
    cm.sendSimple("The direct hairstyle, face, and skin color selection service is unavailable.\r\nYou can still manage saved styles, skin colors, and preview them before applying.\r\n\r\nCurrent hairstyle: " + currentBeautyLabel(cm.getPlayer(), SLOT_HAIR)
        + "\r\nCurrent face: " + currentBeautyLabel(cm.getPlayer(), SLOT_FACE)
        + "\r\nCurrent skin color: " + currentBeautyLabel(cm.getPlayer(), SLOT_SKIN)
        + "\r\n\r\n#L2#Manage saved hairstyles#l\r\n#L3#Manage saved faces#l\r\n#L4#Manage saved skin colors#l\r\n#L5#Buy beauty slots (" + beautySlotPrice + " mesos each)#l\r\n#L6#Exit#l");
}

function beautySlotsMenu(notice) {
    var accountId = cm.getPlayer().getAccountId();
    var prefix = notice ? notice + "\r\n\r\n" : "";
    if (slotMode == SLOT_PURCHASE) {
        var hairLimit = slotSvc.getSlotLimit(accountId, SLOT_HAIR);
        var faceLimit = slotSvc.getSlotLimit(accountId, SLOT_FACE);
        var skinLimit = slotSvc.getSlotLimit(accountId, SLOT_SKIN);
        cm.sendSimple(prefix + "Buy beauty slots (" + beautySlotPrice + " mesos each):\r\nCurrent: " + hairLimit + " hairstyle / " + faceLimit + " face / " + skinLimit + " skin color slots\r\n#L0#Buy a hairstyle slot#l\r\n#L1#Buy a face slot#l\r\n#L2#Buy a skin color slot#l\r\n#L3#Back#l");
        return;
    }
    var typeName = beautyTypeName(slotType);
    var limit = slotSvc.getSlotLimit(accountId, slotType);
    cm.sendSimple(prefix + "Saved " + typeName + "s (" + limit + " slots):\r\n#L0#Save current " + typeName + "#l\r\n#L1#Apply from a saved slot (preview room)#l\r\n#L2#View saved slots#l\r\n#L3#Back#l");
}

function beautySlotsAction(selection, mode) {
    var player = cm.getPlayer();
    var accountId = player.getAccountId();
    if (slotMode == SLOT_PURCHASE) {
        if (slotStep == 0) {
            if (selection == 3) {
                beautyMainMenu();
                return;
            }
            if (selection < 0 || selection > 2) {
                cm.dispose();
                return;
            }
            slotType = selection;
            slotStep = 1;
            var purchaseTypeName = beautyTypeName(slotType);
            var currentLimit = slotSvc.getSlotLimit(accountId, slotType);
            cm.sendYesNo("Spend " + beautySlotPrice + " mesos to buy one " + purchaseTypeName + " slot?\r\nCurrent: " + currentLimit + " -> " + (currentLimit + 1));
        } else if (slotStep == 1) {
            if (mode != 1) {
                slotStep = 0;
                beautySlotsMenu();
                return;
            }
            if (player.getMeso() < beautySlotPrice) {
                cm.sendOk("You do not have enough mesos. Required: " + beautySlotPrice + ".");
                cm.dispose();
                return;
            }
            player.gainMeso(-beautySlotPrice);
            var newLimit = slotSvc.purchaseSlot(accountId, slotType);
            if (newLimit < 0) {
                player.gainMeso(beautySlotPrice);
                cm.sendOk("The purchase failed. Your mesos were returned.");
            } else {
                cm.sendOk("Purchase successful. You now have " + newLimit + " " + beautyTypeName(slotType) + " slots.");
            }
            cm.dispose();
        }
        return;
    }

    var typeName = beautyTypeName(slotType);
    if (slotStep == 0) {
        if (selection == 3) {
            beautyMainMenu();
            return;
        }
        if (selection == 0) {
            slotStep = 1;
            var saveLimit = slotSvc.getSlotLimit(accountId, slotType);
            var saveList = "Choose a slot:\r\n";
            for (var i = 0; i < saveLimit; i++) {
                var saved = slotSvc.getSlot(accountId, slotType, i);
                saveList += "#L" + i + "#Slot " + (i + 1) + ": " + (saved > 0 ? beautyStyleLabel(slotType, saved) : "(empty)") + "#l\r\n";
            }
            saveList += "#L" + saveLimit + "#Back#l";
            cm.sendSimple(saveList);
        } else if (selection == 1) {
            slotStep = 2;
            var applyLimit = slotSvc.getSlotLimit(accountId, slotType);
            previewChoices = [];
            var savedCount = 0;
            for (var j = 0; j < applyLimit; j++) {
                var savedItem = slotSvc.getSlot(accountId, slotType, j);
                if (savedItem > 0) {
                    previewChoices.push({
                        slot: j,
                        style: savedItem
                    });
                    savedCount++;
                }
            }
            if (savedCount == 0) {
                slotStep = 0;
                beautySlotsMenu("You have no saved " + typeName + "s.");
                return;
            }
            var styles = [];
            for (var choiceIndex = 0; choiceIndex < previewChoices.length; choiceIndex++) {
                styles.push(previewChoices[choiceIndex].style);
            }
            cm.sendStyle("Choose a saved " + typeName + " to preview:", styles);
        } else if (selection == 2) {
            var viewLimit = slotSvc.getSlotLimit(accountId, slotType);
            var viewMessage = "Saved " + typeName + "s:\r\n";
            var viewCount = 0;
            for (var k = 0; k < viewLimit; k++) {
                var viewItem = slotSvc.getSlot(accountId, slotType, k);
                if (viewItem > 0) {
                    viewMessage += "Slot " + (k + 1) + ": " + beautyStyleLabel(slotType, viewItem) + "\r\n";
                    viewCount++;
                }
            }
            if (viewCount == 0) {
                viewMessage += "(empty)";
            }
            cm.sendOk(viewMessage);
            cm.dispose();
        }
        return;
    }

    if (slotStep == 1) {
        var saveSlotLimit = slotSvc.getSlotLimit(accountId, slotType);
        if (selection < 0 || selection >= saveSlotLimit) {
            slotStep = 0;
            beautySlotsMenu();
            return;
        }
        var existingStyle = slotSvc.getSlot(accountId, slotType, selection);
        if (existingStyle > 0) {
            slotSel = selection;
            slotStep = 4;
            cm.sendYesNo("Slot " + (selection + 1) + " already contains " + beautyStyleLabel(slotType, existingStyle) + ".\r\nOverwrite it with your current " + typeName + "?");
            return;
        }
        var currentStyle = currentBeautyStyle(player, slotType);
        slotSvc.saveSlot(accountId, slotType, selection, currentStyle);
        cm.sendOk("Saved your current " + typeName + " to slot " + (selection + 1) + ": " + beautyStyleLabel(slotType, currentStyle));
        cm.dispose();
    } else if (slotStep == 4) {
        if (mode != 1) {
            slotStep = 0;
            slotSel = -1;
            beautySlotsMenu("Save cancelled.");
            return;
        }
        var overwriteStyle = currentBeautyStyle(player, slotType);
        slotSvc.saveSlot(accountId, slotType, slotSel, overwriteStyle);
        cm.sendOk("Saved your current " + typeName + " to slot " + (slotSel + 1) + ": " + beautyStyleLabel(slotType, overwriteStyle));
        cm.dispose();
    } else if (slotStep == 2) {
        if (selection < 0 || selection >= previewChoices.length) {
            slotStep = 0;
            previewChoices = [];
            beautySlotsMenu();
            return;
        }
        var selectedChoice = previewChoices[selection];
        var previewItem = selectedChoice.style;
        if (previewItem <= 0) {
            slotStep = 0;
            previewChoices = [];
            beautySlotsMenu("That slot is empty.");
            return;
        }
        slotSel = selectedChoice.slot;
        previewOrig = currentBeautyStyle(player, slotType);
        applyBeautyStyle(cm, slotType, previewItem);
        previewChoices = [];
        slotStep = 3;
        cm.sendYesNo("Preview room: you are wearing " + beautyStyleLabel(slotType, previewItem) + ".\r\nKeep this style?");
    } else if (slotStep == 3) {
        var selectedItem = slotSvc.getSlot(accountId, slotType, slotSel);
        if (mode != 1) {
            if (previewOrig > 0 || slotType == SLOT_SKIN) {
                applyBeautyStyle(cm, slotType, previewOrig);
            }
            slotStep = 0;
            slotSel = -1;
            previewOrig = -1;
            beautySlotsMenu("Your original style has been restored.");
        } else {
            cm.sendOk("Style kept: " + beautyStyleLabel(slotType, selectedItem));
            cm.dispose();
        }
    }
}

function start() {
    beautyMainMenu();
}

function action(mode, type, selection) {
    if (mode === -1) {
        cm.dispose();
        return;
    }
    if (mode === 0) {
        if ((slotMode == SLOT_PURCHASE && slotStep == 1) || slotStep == 3 || slotStep == 4) {
            beautySlotsAction(selection, mode);
        } else {
            cm.dispose();
        }
        return;
    }
    if (beautyMode == -1) {
        if (selection == SLOT_EXIT) {
            cm.dispose();
            return;
        }
        if (selection < 2 || selection > SLOT_PURCHASE) {
            cm.dispose();
            return;
        }
        beautyMode = selection;
        slotMode = selection;
        slotType = selection == 2 ? SLOT_HAIR : selection == 3 ? SLOT_FACE : selection == 4 ? SLOT_SKIN : -1;
        slotStep = 0;
        beautySlotsMenu();
        return;
    }
    beautySlotsAction(selection, mode);
}

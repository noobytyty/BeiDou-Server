/**北斗脚本
 *
 * 美容师 9977778
 *
 * 关闭直接选择指定发型和脸型，保留美容存档、槽位购买和试衣间预览，
 * 并增加肤色存档。
 */
var beautyMode = -1;
var slotMode = -1;
var slotType = -1;
var slotStep = 0;
var slotSel = -1;
var previewOrig = -1;
var beautySlotPrice = 5000000;
var SLOT_HAIR = 0;
var SLOT_FACE = 1;
var SLOT_SKIN = 2;
var SLOT_PURCHASE = 5;
var SLOT_EXIT = 6;
var slotSvc = Java.type("org.gms.server.BeautySlotService").getInstance();
var SKIN_NAMES = {
    0: "普通",
    1: "深色",
    2: "黑色",
    3: "苍白",
    4: "蓝色",
    5: "绿色",
    9: "白色",
    10: "粉色"
};

function beautyTypeName(type) {
    return type == SLOT_HAIR ? "发型" : type == SLOT_FACE ? "脸型" : "肤色";
}

function beautyStyleLabel(type, itemId) {
    if (type == SLOT_SKIN) {
        return "肤色 " + itemId + "（" + (SKIN_NAMES[itemId] || "未知") + "）";
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
    cm.sendSimple("直接选择指定发型、脸型和肤色的服务已关闭。\r\n你仍然可以管理发型、脸型和肤色存档，并在试衣间预览后应用。\r\n\r\n当前发型：" + currentBeautyLabel(cm.getPlayer(), SLOT_HAIR)
        + "\r\n当前脸型：" + currentBeautyLabel(cm.getPlayer(), SLOT_FACE)
        + "\r\n当前肤色：" + currentBeautyLabel(cm.getPlayer(), SLOT_SKIN)
        + "\r\n\r\n#L2#管理发型存档#l\r\n#L3#管理脸型存档#l\r\n#L4#管理肤色存档#l\r\n#L5#购买美容槽位（" + beautySlotPrice + " 金币/个）#l\r\n#L6#退出#l");
}

function beautySlotsMenu(notice) {
    var accountId = cm.getPlayer().getAccountId();
    var prefix = notice ? notice + "\r\n\r\n" : "";
    if (slotMode == SLOT_PURCHASE) {
        var hairLimit = slotSvc.getSlotLimit(accountId, SLOT_HAIR);
        var faceLimit = slotSvc.getSlotLimit(accountId, SLOT_FACE);
        var skinLimit = slotSvc.getSlotLimit(accountId, SLOT_SKIN);
        cm.sendSimple(prefix + "购买美容槽位（每个 " + beautySlotPrice + " 金币）：\r\n当前：发型 " + hairLimit + " 个 / 脸型 " + faceLimit + " 个 / 肤色 " + skinLimit + " 个\r\n#L0#购买发型槽位#l\r\n#L1#购买脸型槽位#l\r\n#L2#购买肤色槽位#l\r\n#L3#返回#l");
        return;
    }
    var typeName = beautyTypeName(slotType);
    var limit = slotSvc.getSlotLimit(accountId, slotType);
    cm.sendSimple(prefix + typeName + "存档（" + limit + " 个槽位）：\r\n#L0#保存当前" + typeName + "#l\r\n#L1#从存档应用（试衣间预览）#l\r\n#L2#查看存档#l\r\n#L3#返回#l");
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
            cm.sendYesNo("花费 " + beautySlotPrice + " 金币新增一个" + purchaseTypeName + "槽位？\r\n当前：" + currentLimit + " 个 → " + (currentLimit + 1) + " 个");
        } else if (slotStep == 1) {
            if (mode != 1) {
                slotStep = 0;
                beautySlotsMenu();
                return;
            }
            if (player.getMeso() < beautySlotPrice) {
                cm.sendOk("你没有足够的金币，需要 " + beautySlotPrice + " 金币。");
                cm.dispose();
                return;
            }
            player.gainMeso(-beautySlotPrice);
            var newLimit = slotSvc.purchaseSlot(accountId, slotType);
            if (newLimit < 0) {
                player.gainMeso(beautySlotPrice);
                cm.sendOk("购买失败，金币已退回。");
            } else {
                cm.sendOk("购买成功，现在有 " + newLimit + " 个" + beautyTypeName(slotType) + "槽位。");
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
            var saveList = "选择要保存到哪个槽位：\r\n";
            for (var i = 0; i < saveLimit; i++) {
                var saved = slotSvc.getSlot(accountId, slotType, i);
                saveList += "#L" + i + "#槽位 " + (i + 1) + "：" + (saved > 0 ? beautyStyleLabel(slotType, saved) : "（空）") + "#l\r\n";
            }
            saveList += "#L" + saveLimit + "#返回#l";
            cm.sendSimple(saveList);
        } else if (selection == 1) {
            slotStep = 2;
            var applyLimit = slotSvc.getSlotLimit(accountId, slotType);
            var applyList = "选择要预览的存档：\r\n";
            var savedCount = 0;
            for (var j = 0; j < applyLimit; j++) {
                var savedItem = slotSvc.getSlot(accountId, slotType, j);
                if (savedItem > 0) {
                    applyList += "#L" + j + "#槽位 " + (j + 1) + "：" + beautyStyleLabel(slotType, savedItem) + "#l\r\n";
                    savedCount++;
                }
            }
            if (savedCount == 0) {
                slotStep = 0;
                beautySlotsMenu("还没有保存任何" + typeName + "。");
                return;
            }
            applyList += "#L" + applyLimit + "#返回#l";
            cm.sendSimple(applyList);
        } else if (selection == 2) {
            var viewLimit = slotSvc.getSlotLimit(accountId, slotType);
            var viewMessage = "已保存的" + typeName + "：\r\n";
            var viewCount = 0;
            for (var k = 0; k < viewLimit; k++) {
                var viewItem = slotSvc.getSlot(accountId, slotType, k);
                if (viewItem > 0) {
                    viewMessage += "槽位 " + (k + 1) + "：" + beautyStyleLabel(slotType, viewItem) + "\r\n";
                    viewCount++;
                }
            }
            if (viewCount == 0) {
                viewMessage += "（空）";
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
            cm.sendYesNo("槽位 " + (selection + 1) + " 已保存 " + beautyStyleLabel(slotType, existingStyle) + "。\r\n确定用当前" + typeName + "覆盖吗？");
            return;
        }
        var currentStyle = currentBeautyStyle(player, slotType);
        slotSvc.saveSlot(accountId, slotType, selection, currentStyle);
        cm.sendOk("已将当前" + typeName + "保存到槽位 " + (selection + 1) + "：" + beautyStyleLabel(slotType, currentStyle));
        cm.dispose();
    } else if (slotStep == 4) {
        if (mode != 1) {
            slotStep = 0;
            slotSel = -1;
            beautySlotsMenu("保存已取消。");
            return;
        }
        var overwriteStyle = currentBeautyStyle(player, slotType);
        slotSvc.saveSlot(accountId, slotType, slotSel, overwriteStyle);
        cm.sendOk("已将当前" + typeName + "保存到槽位 " + (slotSel + 1) + "：" + beautyStyleLabel(slotType, overwriteStyle));
        cm.dispose();
    } else if (slotStep == 2) {
        var applySlotLimit = slotSvc.getSlotLimit(accountId, slotType);
        if (selection < 0 || selection >= applySlotLimit) {
            slotStep = 0;
            beautySlotsMenu();
            return;
        }
        var previewItem = slotSvc.getSlot(accountId, slotType, selection);
        if (previewItem <= 0) {
            slotStep = 0;
            beautySlotsMenu("该槽位是空的。");
            return;
        }
        slotSel = selection;
        previewOrig = currentBeautyStyle(player, slotType);
        applyBeautyStyle(cm, slotType, previewItem);
        slotStep = 3;
        cm.sendYesNo("试衣间：你当前试穿的是 " + beautyStyleLabel(slotType, previewItem) + "。\r\n确定保留这个造型吗？");
    } else if (slotStep == 3) {
        var selectedItem = slotSvc.getSlot(accountId, slotType, slotSel);
        if (mode != 1) {
            if (previewOrig > 0 || slotType == SLOT_SKIN) {
                applyBeautyStyle(cm, slotType, previewOrig);
            }
            slotStep = 0;
            slotSel = -1;
            previewOrig = -1;
            beautySlotsMenu("已恢复原来的造型。");
        } else {
            cm.sendOk("已保留造型：" + beautyStyleLabel(slotType, selectedItem));
            cm.dispose();
        }
    }
}

function start() {
    beautyMainMenu();
}

function action(mode, type, selection) {
    if (mode <= 0) {
        cm.dispose();
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

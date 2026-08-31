/*
    This file is part of the HeavenMS MapleStory Server
    Copyleft (L) 2016 - 2019 RonanLana

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation version 3 as published by
    the Free Software Foundation. You may not use, modify or distribute
    this program under the terms of the GNU Affero General Public
    License.
*/

var status = 0;
var affixOperation = -1;
var affixEquipSlot = -1;
var InventoryType = Java.type("org.gms.client.inventory.InventoryType");
var Equip = Java.type("org.gms.client.inventory.Equip");
var EquipmentAffixFormatter = Java.type("org.gms.client.inventory.EquipmentAffixFormatter");
var I18nUtil = Java.type("org.gms.util.I18nUtil");

function t(key, arg0) {
    return arguments.length > 1 ? I18nUtil.getMessage(key, arg0) : I18nUtil.getMessage(key);
}

function runAffixCommand(commandClass, params) {
    var command = new (Java.type(commandClass))();
    command.execute(cm.getClient(), params);
}

function mainMenu(notice) {
    status = 0;
    affixOperation = -1;
    affixEquipSlot = -1;
    var message = notice ? notice + "\r\n\r\n" : "";
    message += t("AffixArtisan.menu.title") + "\r\n"
        + "#L0#" + t("AffixArtisan.menu.inspect") + "#l\r\n"
        + "#L1#" + t("AffixArtisan.menu.reroll") + "#l\r\n"
        + "#L2#" + t("AffixArtisan.menu.lock") + "#l\r\n"
        + "#L3#" + t("AffixArtisan.menu.salvage") + "#l\r\n"
        + "#L4#" + t("AffixArtisan.menu.exit") + "#l";
    cm.sendSimple(message);
}

function sendEquipSelection(prompt) {
    status = 1;
    var inventory = cm.getPlayer().getInventory(InventoryType.EQUIP);
    var text = prompt + "\r\n";
    var iterator = inventory.iterator();
    var hasEquipment = false;
    while (iterator.hasNext()) {
        var item = iterator.next();
        if (item instanceof Equip) {
            hasEquipment = true;
            text += "#L" + item.getPosition() + "##v" + item.getItemId() + "# #z" + item.getItemId()
                + t("AffixArtisan.equipment.affixes", item.getAffixes().size()) + "#l\r\n";
        }
    }
    if (!hasEquipment) {
        cm.sendOk(t("AffixArtisan.equipment.empty"));
        cm.dispose();
        return;
    }
    text += "#L999#" + t("AffixArtisan.back") + "#l";
    cm.sendSimple(text);
}

function getEquipment(slot) {
    var item = cm.getPlayer().getInventory(InventoryType.EQUIP).getItem(slot);
    return item instanceof Equip ? item : null;
}

function action(mode, type, selection) {
    if (mode < 1) {
        cm.dispose();
        return;
    }

    if (status == 0) {
        if (selection == 4) {
            cm.dispose();
            return;
        }
        if (selection < 0 || selection > 3) {
            mainMenu(t("AffixArtisan.invalid.operation"));
            return;
        }
        affixOperation = selection;
        sendEquipSelection(t(
                selection == 0 ? "AffixArtisan.prompt.inspect" : "AffixArtisan.prompt.operation"
        ));
        return;
    }

    if (status == 1) {
        if (selection == 999) {
            mainMenu();
            return;
        }
        if (selection <= 0 || selection >= 97) {
            sendEquipSelection(t("AffixArtisan.invalid.equipment"));
            return;
        }

        var equip = getEquipment(selection);
        if (equip == null) {
            sendEquipSelection(t("AffixArtisan.invalid.equipment"));
            return;
        }

        affixEquipSlot = selection;
        if (affixOperation == 0) {
            runAffixCommand("org.gms.client.command.commands.gm0.InspectCommand", [String(selection)]);
            cm.dispose();
        } else if (affixOperation == 1) {
            status = 2;
            cm.sendYesNo(Java.type("org.gms.client.command.commands.gm0.RerollAffixCommand").preview(equip)
                + "\r\n" + t("AffixArtisan.confirm.reroll"));
        } else if (affixOperation == 2) {
            status = 2;
            cm.sendSimple(EquipmentAffixFormatter.formatSelection(equip));
        } else if (affixOperation == 3) {
            status = 2;
            cm.sendYesNo(Java.type("org.gms.client.command.commands.gm0.SalvageEquipmentCommand").preview(equip)
                + "\r\n" + t("AffixArtisan.confirm.salvage"));
        }
        return;
    }

    if (status == 2 && affixOperation == 2) {
        if (selection == 999) {
            sendEquipSelection(t("AffixArtisan.prompt.operation"));
            return;
        }
        var lockEquip = getEquipment(affixEquipSlot);
        if (lockEquip == null) {
            sendEquipSelection(t("AffixArtisan.invalid.equipment"));
            return;
        }
        if (selection < 0 || selection >= lockEquip.getAffixes().size()) {
            cm.sendSimple(EquipmentAffixFormatter.formatSelection(lockEquip));
            return;
        }
        runAffixCommand("org.gms.client.command.commands.gm0.LockAffixCommand", [
            String(affixEquipSlot),
            String(selection)
        ]);
        cm.sendSimple(EquipmentAffixFormatter.formatSelection(lockEquip));
        return;
    }

    if (status == 2 && (affixOperation == 1 || affixOperation == 3)) {
        if (mode != 1) {
            sendEquipSelection(t("AffixArtisan.cancelled"));
            return;
        }
        if (affixOperation == 1) {
            runAffixCommand("org.gms.client.command.commands.gm0.RerollAffixCommand", [
                String(affixEquipSlot)
            ]);
        } else {
            runAffixCommand("org.gms.client.command.commands.gm0.SalvageEquipmentCommand", [
                String(affixEquipSlot)
            ]);
        }
        cm.dispose();
    }
}

function start() {
    mainMenu();
}

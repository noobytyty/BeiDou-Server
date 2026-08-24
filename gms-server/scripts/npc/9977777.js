/*
    This file is part of the HeavenMS MapleStory Server
    Copyleft (L) 2016 - 2019 RonanLana

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation version 3 as published by
    the Free Software Foundation. You may not use, modify or distribute
    this program under any other version of the GNU Affero General Public
    License.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
/* 词条工匠 NPC - 装备词条服务（查看/重铸/锁定/分解） */

var status;
var affixOperation = -1;
var affixEquipSlot = -1;
var InventoryType = Java.type("org.gms.client.inventory.InventoryType");
var Equip = Java.type("org.gms.client.inventory.Equip");
var RerollAffixCommand = Java.type("org.gms.client.command.commands.gm0.RerollAffixCommand");
var SalvageEquipmentCommand = Java.type("org.gms.client.command.commands.gm0.SalvageEquipmentCommand");

function isAffixNpcMap() {
    return cm.getPlayer().getMapId() == 910000000;
}

function runAffixCommand(commandClass, params) {
    var command = new (Java.type(commandClass))();
    command.execute(cm.getClient(), params);
}

function sendEquipSelection(prompt) {
    var inventory = cm.getPlayer().getInventory(InventoryType.EQUIP);
    var iterator = inventory.iterator();
    var text = prompt + "\r\n";
    var hasEquipment = false;
    while (iterator.hasNext()) {
        var item = iterator.next();
        if (item instanceof Equip) {
            hasEquipment = true;
            text += "#L" + item.getPosition() + "##v" + item.getItemId() + "# #z" + item.getItemId()
                + "#（词条 " + item.getAffixes().size() + " 条）#l\r\n";
        }
    }
    if (!hasEquipment) {
        cm.sendOk("装备背包中没有可操作的装备。");
        cm.dispose();
        return;
    }
    cm.sendSimple(text);
}

function start() {
    status = 0;
    affixOperation = -1;
    affixEquipSlot = -1;
    cm.sendSimple("请选择词条工匠服务：\r\n#L0#查看装备词条#l\r\n#L1#重铸词条#l\r\n#L2#锁定或解锁词条#l\r\n#L3#分解装备#l\r\n");
}

function action(mode, type, selection) {
    if (mode < 1) {
        cm.dispose();
        return;
    }
    if (status == 0) {
        affixOperation = selection;
        status = 1;
        if (selection == 0) {
            sendEquipSelection("请选择要查看词条的装备：");
        } else {
            sendEquipSelection("请选择要操作的装备：");
        }
    } else if (status == 1) {
        if (selection > 0 && selection < 97) {
            if (affixOperation == 0) {
                runAffixCommand("org.gms.client.command.commands.gm0.InspectCommand", [String(selection)]);
                cm.dispose();
            } else if (affixOperation == 1) {
                affixEquipSlot = selection;
                status = 2;
                var rerollEquip = cm.getPlayer().getInventory(InventoryType.EQUIP).getItem(selection);
                cm.sendYesNo(RerollAffixCommand.preview(rerollEquip)
                    + "\r\n锁定词条会保留，确定继续吗？");
            } else if (affixOperation == 2) {
                affixEquipSlot = selection;
                status = 2;
                cm.sendGetNumber("请输入词条序号（从0开始）：", 0, 0, 7);
            } else if (affixOperation == 3) {
                affixEquipSlot = selection;
                status = 2;
                var salvageEquip = cm.getPlayer().getInventory(InventoryType.EQUIP).getItem(selection);
                cm.sendYesNo(SalvageEquipmentCommand.preview(salvageEquip)
                    + "\r\n装备将被删除，确定继续吗？");
            }
        }
    } else if (status == 2 && affixOperation == 2) {
        runAffixCommand("org.gms.client.command.commands.gm0.LockAffixCommand", [
            String(affixEquipSlot),
            String(selection)
        ]);
        cm.dispose();
    } else if (status == 2 && (affixOperation == 1 || affixOperation == 3)) {
        if (mode != 1) {
            cm.dispose();
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

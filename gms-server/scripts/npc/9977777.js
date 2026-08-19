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

function isAffixNpcMap() {
    return cm.getPlayer().getMapId() == 910000000;
}

function runAffixCommand(commandClass, params) {
    var command = new (Java.type(commandClass))();
    command.execute(cm.getClient(), params);
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
            runAffixCommand("org.gms.client.command.commands.gm0.InspectCommand", []);
            cm.dispose();
        } else {
            cm.sendGetNumber("请输入装备栏位（1-96）：", 1, 1, 96);
        }
    } else if (status == 1) {
        if (selection > 0 && selection < 97) {
            if (affixOperation == 1) {
                runAffixCommand("org.gms.client.command.commands.gm0.RerollAffixCommand", [String(selection)]);
                cm.dispose();
            } else if (affixOperation == 2) {
                affixEquipSlot = selection;
                status = 2;
                cm.sendGetNumber("请输入词条序号（从0开始）：", 0, 0, 7);
            } else if (affixOperation == 3) {
                runAffixCommand("org.gms.client.command.commands.gm0.SalvageEquipmentCommand", [String(selection)]);
                cm.dispose();
            }
        }
    } else if (status == 2 && affixOperation == 2) {
        runAffixCommand("org.gms.client.command.commands.gm0.LockAffixCommand", [
            String(affixEquipSlot),
            String(selection)
        ]);
        cm.dispose();
    }
}

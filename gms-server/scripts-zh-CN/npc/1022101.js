/*  
      
    Copyright (C) This file is part of the OdinMS Maple Story Server  
Copyright (C) 2008 Patrick Huy <patrick.huy@frz.cc>   
Matthias Butz <matze@odinms.de>  
Jan Christian Meyer <vimes@odinms.de>  
    This program is free software: you can redistribute it and/or modify  
    it under the terms of the GNU Affero General Public License version 3  
    as published by the Free Software Foundation. You may not use, modify  
    or distribute this program under any other version of the  
    GNU Affero General Public License.  
  
    This program is distributed in the hope that it will be useful,  
    but WITHOUT ANY WARRANTY; without even the implied warranty of  
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  
    GNU Affero General Public License for more details.  
  
    You should have received a copy of the GNU Affero General Public License  
    along with this program.  If not, see <http://www.gnu.org/licenses/>.  
*/

/**
 Rooney - Happyville Warp NPC
 **/

var status = -1;

function start() {
    action(1, 0, 0);
}

function action(mode, type, selection) {
    if (mode == -1) {
        cm.dispose();
        return;
    }
    if (mode == 0) {
        cm.dispose();
        return;
    }
    status++;

    if (status == 0) {
        cm.sendSimple("#e#b<幸福村圣诞活动中心>#k#n\r\n\r\n"
            + "圣诞老人让我来到这里，负责接待准备参加冬季活动的冒险者。\r\n\r\n"
            + "#L0#前往幸福村#l\r\n"
            + "#L1#查看圣诞组队任务说明#l\r\n"
            + "#L2#查看活动流程和奖励规则#l\r\n"
            + "#L3#离开#l");
    } else if (status == 1) {
        if (selection == 0) {
            cm.getPlayer().saveLocation("HAPPYVILLE");
            cm.warp(209000000, 0);
            cm.dispose();
        } else if (selection == 1) {
            cm.sendOk(buildPartyQuestInfo());
            cm.dispose();
        } else if (selection == 2) {
            cm.sendOk("#e#b活动流程#k#n\r\n"
                + "1. 前往幸福村，与雪精灵 NPC 对话报名。\r\n"
                + "2. 队长与队伍成员必须在招募地图集合。\r\n"
                + "3. 保护巨大雪人，收集并投放雪之力量。\r\n"
                + "4. 击败斯克鲁奇后完成活动。\r\n"
                + "5. 活动结束后按难度领取奖励。\r\n\r\n"
                + "#e#b奖励规则#k#n\r\n"
                + "奖励按 Easy、Normal、Hard 三个难度发放，每名玩家随机获得奖励池中的一项。"
                + "请确保装备、消耗、设置和其他栏各有空位。");
            cm.dispose();
        } else {
            cm.dispose();
        }
    }
}

function buildPartyQuestInfo() {
    var text = "#e#b<圣诞组队任务>#k#n\r\n\r\n";
    text += "幸福村共有三个等级段的雪人守护任务：\r\n";
    text += "#bEasy#k：21～30级，3～6人，15分钟\r\n";
    text += "#bNormal#k：31～40级，3～6人，20分钟\r\n";
    text += "#bHard#k：41～50级，3～6人，25分钟\r\n\r\n";
    text += "如果服务器开启单人远征或解除等级限制，人数和等级要求会按服务器设置放宽。\r\n";
    text += "到达幸福村后，请与雪精灵 NPC 对话并由队长发起任务。";
    return text;
}
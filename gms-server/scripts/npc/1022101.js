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
        cm.sendSimple("#e#b<HappyVille Christmas Activity Center>#k#n\r\n\r\n"
            + "Santa asked me to guide adventurers preparing for the winter activities.\r\n\r\n"
            + "#L0#Go to HappyVille#l\r\n"
            + "#L1#View Holiday Party Quest requirements#l\r\n"
            + "#L2#View activity flow and rewards#l\r\n"
            + "#L3#Leave#l");
    } else if (status == 1) {
        if (selection == 0) {
            cm.getPlayer().saveLocation("HAPPYVILLE");
            cm.warp(209000000, 0);
            cm.dispose();
        } else if (selection == 1) {
            cm.sendOk(buildPartyQuestInfo());
            cm.dispose();
        } else if (selection == 2) {
            cm.sendOk("#e#bActivity flow#k#n\r\n"
                + "1. Go to HappyVille and talk to a Snow Spirit NPC.\r\n"
                + "2. Gather your party in the recruitment map.\r\n"
                + "3. Protect the giant snowman and collect Snow Vigor.\r\n"
                + "4. Defeat Scrooge to clear the activity.\r\n"
                + "5. Claim rewards based on the completed difficulty.\r\n\r\n"
                + "#e#bReward rules#k#n\r\n"
                + "Easy, Normal, and Hard each have a separate reward pool. "
                + "Each player receives one random reward, so keep one free slot in Equip, Use, Setup, and Etc.");
            cm.dispose();
        } else {
            cm.dispose();
        }
    }
}

function buildPartyQuestInfo() {
    var text = "#e#b<Holiday Party Quest>#k#n\r\n\r\n";
    text += "HappyVille has three level brackets:\r\n";
    text += "#bEasy#k: level 21-30, 3-6 players, 15 minutes\r\n";
    text += "#bNormal#k: level 31-40, 3-6 players, 20 minutes\r\n";
    text += "#bHard#k: level 41-50, 3-6 players, 25 minutes\r\n\r\n";
    text += "Solo expedition and level-limit settings may relax these requirements.\r\n";
    text += "After entering HappyVille, talk to a Snow Spirit NPC; the party leader starts the quest.";
    return text;
}

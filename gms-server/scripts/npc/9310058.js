/**
 * Santa - Happyville Christmas activity center
 */
var status = -1;

function start() {
    action(1, 0, 0);
}

function action(mode, type, selection) {
    if (mode <= 0) {
        cm.dispose();
        return;
    }

    status++;
    if (status == 0) {
        cm.sendSimple("#e#b<HappyVille Christmas Activity>#k#n\r\n\r\n"
            + "Welcome to #bHappyVille#k. May this winter bring you warmth and good luck.\r\n\r\n"
            + "#L0#View Holiday Party Quest details#l\r\n"
            + "#L1#View stage rewards#l\r\n"
            + "#L2#Leave#l");
    } else if (status == 1) {
        if (selection == 0) {
            cm.sendOk("#e#bHoliday Party Quest#k#n\r\n"
                + "Protect the giant snowman, collect Snow Vigor, and defeat Scrooge with your party.\r\n\r\n"
                + "Easy: level 21-30, 3-6 players, 15 minutes\r\n"
                + "Normal: level 31-40, 3-6 players, 20 minutes\r\n"
                + "Hard: level 41-50, 3-6 players, 25 minutes\r\n\r\n"
                + "Talk to a Snow Spirit NPC; the party leader starts the quest.");
            cm.dispose();
        } else if (selection == 1) {
            cm.dispose();
            cm.openNpc(9000038);
        } else {
            cm.dispose();
        }
    }
}

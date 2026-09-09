/**
 * Halloween Haunted House transport and activity guide
 */
var status = -1;
var fee = 15000;

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
        if (cm.getPlayer().getMapId() == 682000000) {
            cm.sendSimple("#e#b<Haunted House>#k#n\r\n\r\n"
                + "#L0#Return to New Leaf City (" + fee + " mesos)#l\r\n"
                + "#L1#View the Halloween activity#l\r\n"
                + "#L2#Leave#l");
        } else {
            cm.sendSimple("#e#b<Haunted House>#k#n\r\n\r\n"
                + "The trip to the Haunted House costs " + fee + " mesos.\r\n"
                + "#L0#Go to the Haunted House#l\r\n"
                + "#L1#View the Halloween activity#l\r\n"
                + "#L2#Leave#l");
        }
    } else if (status == 1) {
        if (selection == 1) {
            cm.sendOk("#e#bHaunted House Activity#k#n\r\n"
                + "The Haunted House entrance is at map 682000000 near New Leaf City.\r\n"
                + "Explore the Pumpkin Cellar and talk to the maid NPC for the Jack-o'-Lantern activity.\r\n"
                + "Quest 9923 requires 50 pumpkin pieces (2022255) and rewards a temporary Pumpkin Head (1002699).");
            cm.dispose();
            return;
        }
        if (selection == 2) {
            cm.dispose();
            return;
        }

        if (cm.getPlayer().getMapId() == 682000000) {
            if (cm.getMeso() < fee) {
                cm.sendOk("You do not have enough mesos to pay " + fee + " mesos.");
            } else {
                cm.gainMeso(-fee);
                cm.warp(600000000, 0);
            }
        } else if (cm.getMeso() < fee) {
            cm.sendOk("You do not have enough mesos to pay " + fee + " mesos.");
        } else {
            cm.gainMeso(-fee);
            cm.warp(682000000, 0);
        }
        cm.dispose();
    }
}

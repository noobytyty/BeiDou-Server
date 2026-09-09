/**
 * Halloween Haunted House maid
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
        var pumpkinPieces = cm.getItemQuantity(2022255);
        cm.sendSimple("#e#b<Haunted House Halloween Activity>#k#n\r\n\r\n"
            + "Welcome to the haunted house. The master has prepared a Jack-o'-Lantern activity.\r\n\r\n"
            + "#L0#View the Jack-o'-Lantern activity#l\r\n"
            + "#L1#Check my pumpkin pieces#l\r\n"
            + "#L2#Leave#l");
    } else if (status == 1) {
        if (selection == 0) {
            cm.sendOk("#e#bJack-o'-Lantern Activity#k#n\r\n"
                + "After completing the prerequisite quest, accept quest 9923.\r\n"
                + "Collect 50 pumpkin pieces left over from making Jack-o'-Lanterns: #i2022255# #t2022255#.\r\n"
                + "The quest rewards a temporary Pumpkin Head: #i1002699# #t1002699#.\r\n\r\n"
                + "Submit the materials through the quest system; the quest handles the reward.");
            cm.dispose();
        } else if (selection == 1) {
            cm.sendOk("You have #b" + pumpkinPieces + "#k pumpkin pieces. You need "
                + Math.max(0, 50 - pumpkinPieces) + " more to complete the activity.");
            cm.dispose();
        } else {
            cm.dispose();
        }
    }
}

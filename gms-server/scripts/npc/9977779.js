/**
 * BeiDou NPC
 *
 * Collector 9977779
 *
 * Monster card and quest collection progress, collector belt, and achievement medals.
 */
var collectionMode = -1;
var collSvc = Java.type("org.gms.server.CollectionService").getInstance();
var COLLECTOR_BELT = 1132991;
var ACHIEVEMENTS = [
    [1142992, 25, 0, "Card Novice"],
    [1142993, 50, 0, "Card Master"],
    [1142994, 100, 0, "Card Collector"],
    [1142995, 0, 50, "Quest Novice"],
    [1142996, 0, 100, "Quest Expert"],
    [1142997, 0, 200, "Quest Master"],
    [1142998, 100, 100, "Collection Master"]
];

function collectionMenu(notice) {
    collectionMode = 1;
    var player = cm.getPlayer();
    var snapshot = collSvc.getSnapshot(player);
    var beltStatus = player.isCollectorBeltEquipped() ? "equipped" : "not equipped";
    var progress = snapshot.available()
        ? "Belt level: " + snapshot.beltLevel() + "\r\nMonster cards: " + snapshot.cards()
            + " (all stats +1 per 25 cards)\r\nCompleted quests: " + snapshot.quests()
            + " (all stats +1, attack +1, HP/MP +100 per 50 quests)"
        : "Collection data is temporarily unavailable. Please try again later.";
    var prefix = notice ? notice + "\r\n\r\n" : "";
    cm.sendSimple(prefix + "Collection Codex\r\nBelt: " + beltStatus + "\r\n" + progress
        + "\r\n\r\n#L0#View full collection status#l\r\n#L1#Claim Collector Belt (" + COLLECTOR_BELT + ")#l\r\n#L2#Claim achievement medals#l\r\n#L3#Exit#l");
}

function collectionAction(selection) {
    var player = cm.getPlayer();
    if (selection == 3) {
        cm.dispose();
        return;
    }
    if (selection == 9) {
        collectionMenu();
        return;
    }
    if (selection == 0) {
        collectionMode = 2;
        cm.sendSimple(collSvc.formatStatus(player) + "\r\n\r\n#L9#Back#l");
        return;
    }
    if (selection == 1) {
        if (cm.haveItem(COLLECTOR_BELT)) {
            cm.sendOk("You already have the Collector Belt.");
        } else if (!cm.canHold(COLLECTOR_BELT)) {
            cm.sendOk("You do not have enough equipment inventory space.");
        } else {
            cm.gainItem(COLLECTOR_BELT, 1);
            cm.sendOk("You received the Collector Belt #t" + COLLECTOR_BELT + "#. Equip it to activate your collection bonuses.");
        }
        collectionMode = -1;
        cm.dispose();
        return;
    }
    if (selection == 2) {
        var snapshot = collSvc.getSnapshot(player);
        if (!snapshot.available()) {
            cm.sendOk("Collection data is temporarily unavailable. Please try again later.");
            cm.dispose();
            return;
        }
        var cards = snapshot.cards();
        var quests = snapshot.quests();
        var got = [];
        var failed = [];
        for (var i = 0; i < ACHIEVEMENTS.length; i++) {
            var a = ACHIEVEMENTS[i];
            var itemId = a[0];
            if (cards >= a[1] && quests >= a[2]) {
                if (cm.haveItem(itemId)) {
                    failed.push("#t" + itemId + "# (already owned)");
                } else if (!cm.canHold(itemId)) {
                    failed.push("#t" + itemId + "# (not enough inventory space)");
                } else {
                    cm.gainItem(itemId, 1);
                    got.push("#t" + itemId + "#");
                }
            } else {
                failed.push(a[3] + " (cards " + a[1] + ", quests " + a[2] + ")");
            }
        }
        var msg = "Achievement medal results:\r\n";
        if (got.length > 0) {
            msg += "Received: " + got.join(", ") + "\r\n";
        } else {
            msg += "No new achievement medals are available.\r\n";
        }
        if (failed.length > 0) {
            msg += "Unavailable: " + failed.join(", ");
        }
        cm.sendOk(msg);
        collectionMode = -1;
        cm.dispose();
        return;
    }
    collectionMenu("Invalid option. Please choose again.");
}

function start() {
    collectionMenu();
}

function action(mode, type, selection) {
    if (mode <= 0) {
        cm.dispose();
        return;
    }
    if (collectionMode > 0) {
        collectionAction(selection);
        return;
    }
    cm.dispose();
}

/**北斗脚本

收藏家 9977779

收藏图鉴：怪物卡 + 任务达人进度、领取收藏家腰带与成就勋章。
*/
var collectionMode = -1;
var collSvc = Java.type("org.gms.server.CollectionService").getInstance();
var COLLECTOR_BELT = 1132991;
var ACHIEVEMENTS = [
    [1142992, 25, 0, "卡牌新星"],       // 收集 25 张怪物卡
    [1142993, 50, 0, "卡牌大师"],       // 收集 50 张怪物卡
    [1142994, 100, 0, "卡牌收藏家"],    // 收集 100 张怪物卡
    [1142995, 0, 50, "任务新秀"],       // 完成 50 个任务
    [1142996, 0, 100, "任务达人"],      // 完成 100 个任务
    [1142997, 0, 200, "任务大师"],      // 完成 200 个任务
    [1142998, 100, 100, "收藏大师"]     // 100 卡 + 100 任务
];

function collectionMenu(notice) {
    collectionMode = 1;
    var player = cm.getPlayer();
    var snapshot = collSvc.getSnapshot(player);
    var beltStatus = player.isCollectorBeltEquipped() ? "已装备" : "未装备";
    var progress = snapshot.available()
        ? "腰带等级：" + snapshot.beltLevel() + "\r\n怪物卡：" + snapshot.cards()
            + " 张（每 25 张全属性+1）\r\n完成任务：" + snapshot.quests()
            + " 个（每 50 个全属性+1、攻+1、HP/MP+100）"
        : "收藏数据暂时不可用，请稍后再试。";
    var prefix = notice ? notice + "\r\n\r\n" : "";
    cm.sendSimple(prefix + "收藏图鉴\r\n腰带状态：" + beltStatus + "\r\n" + progress
        + "\r\n\r\n#L0#查看完整收藏状态#l\r\n#L1#领取收藏家腰带（" + COLLECTOR_BELT + "）#l\r\n#L2#领取成就勋章#l\r\n#L3#退出#l");
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
        // 查看加成
        collectionMode = 2;
        cm.sendSimple(collSvc.formatStatus(player) + "\r\n\r\n#L9#返回#l");
        return;
    }
    if (selection == 1) {
        // 领取收藏家腰带
        if (cm.haveItem(COLLECTOR_BELT)) {
            cm.sendOk("你已经拥有收藏家腰带了！");
        } else if (!cm.canHold(COLLECTOR_BELT)) {
            cm.sendOk("背包空间不足！");
        } else {
            cm.gainItem(COLLECTOR_BELT, 1);
            cm.sendOk("已领取收藏家腰带 #t" + COLLECTOR_BELT + "#！穿戴后按你的收藏进度获得属性加成。");
        }
        collectionMode = -1;
        cm.dispose();
        return;
    }
    if (selection == 2) {
        // 领取成就勋章
        var snapshot = collSvc.getSnapshot(player);
        if (!snapshot.available()) {
            cm.sendOk("收藏数据暂时不可用，请稍后再试。");
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
                    failed.push("#t" + itemId + "#（已拥有）");
                } else if (!cm.canHold(itemId)) {
                    failed.push("#t" + itemId + "#（背包不足）");
                } else {
                    cm.gainItem(itemId, 1);
                    got.push("#t" + itemId + "#");
                }
            } else {
                failed.push("#t" + itemId + "#（需卡 " + a[1] + "/任务 " + a[2] + "）");
            }
        }
        var msg = "成就勋章领取结果：\r\n";
        if (got.length > 0) { msg += "已领取：" + got.join("、") + "\r\n"; } else { msg += "没有新达成的成就勋章。\r\n"; }
        if (failed.length > 0) { msg += "未达成：" + failed.join("、"); }
        cm.sendOk(msg);
        collectionMode = -1;
        cm.dispose();
        return;
    }
    collectionMenu("无效选项，请重新选择。");
}

// ===== 高级美容服务结束 =====


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
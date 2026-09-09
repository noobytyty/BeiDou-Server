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
            cm.sendSimple("#e#b<万圣节鬼屋>#k#n\r\n\r\n"
                + "#L0#返回新叶城市区（" + fee + "金币）#l\r\n"
                + "#L1#查看鬼屋活动说明#l\r\n"
                + "#L2#离开#l");
        } else {
            cm.sendSimple("#e#b<万圣节鬼屋>#k#n\r\n\r\n"
                + "前往鬼屋入口需要支付 " + fee + " 金币。\r\n"
                + "#L0#前往鬼屋入口#l\r\n"
                + "#L1#查看鬼屋活动说明#l\r\n"
                + "#L2#离开#l");
        }
    } else if (status == 1) {
        if (selection == 1) {
            cm.sendOk("#e#b鬼屋活动说明#k#n\r\n"
                + "鬼屋位于新叶城附近，入口地图为 682000000。\r\n"
                + "进入鬼屋后，可以探索南瓜地窖，并与女仆 NPC 对话了解南瓜灯活动。\r\n"
                + "相关任务：9923；收集 50 个南瓜片（2022255），完成后获得限时南瓜头（1002699）。");
            cm.dispose();
            return;
        }
        if (selection == 2) {
            cm.dispose();
            return;
        }

        if (cm.getPlayer().getMapId() == 682000000) {
            if (cm.getMeso() < fee) {
                cm.sendOk("你没有足够的金币支付 " + fee + " 金币。");
            } else {
                cm.gainMeso(-fee);
                cm.warp(600000000, 0);
            }
        } else if (cm.getMeso() < fee) {
            cm.sendOk("你没有足够的金币支付 " + fee + " 金币。");
        } else {
            cm.gainMeso(-fee);
            cm.warp(682000000, 0);
        }
        cm.dispose();
    }
}

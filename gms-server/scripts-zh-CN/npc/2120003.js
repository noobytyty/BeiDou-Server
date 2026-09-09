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
        cm.sendSimple("#e#b<万圣节鬼屋活动>#k#n\r\n\r\n"
            + "您好，欢迎来到鬼屋。主人为客人准备了南瓜灯活动。\r\n\r\n"
            + "#L0#查看南瓜灯活动说明#l\r\n"
            + "#L1#查看我的南瓜片数量#l\r\n"
            + "#L2#离开#l");
    } else if (status == 1) {
        if (selection == 0) {
            cm.sendOk("#e#b南瓜灯活动#k#n\r\n"
                + "完成前置任务后，可以接受任务 9923。\r\n"
                + "收集制作南瓜灯剩下的南瓜片：#i2022255# #t2022255# 50 个。\r\n"
                + "完成任务后可获得限时南瓜头：#i1002699# #t1002699#。\r\n\r\n"
                + "南瓜片可以从万圣节鬼屋相关怪物和活动内容中获得。"
                + "请通过任务界面提交材料，奖励由任务系统发放。");
            cm.dispose();
        } else if (selection == 1) {
            cm.sendOk("你当前拥有 #b" + pumpkinPieces + "#k 个南瓜片，还需要 "
                + Math.max(0, 50 - pumpkinPieces) + " 个即可完成南瓜灯活动。");
            cm.dispose();
        } else {
            cm.dispose();
        }
    }
}

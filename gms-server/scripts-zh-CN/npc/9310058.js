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
        cm.sendSimple("#e#b<幸福村圣诞活动>#k#n\r\n\r\n"
            + "欢迎来到#b幸福村#k，愿这个冬天带给你温暖和好运。\r\n\r\n"
            + "#L0#查看圣诞活动说明#l\r\n"
            + "#L1#查看各阶段奖励#l\r\n"
            + "#L2#离开#l");
    } else if (status == 1) {
        if (selection == 0) {
            cm.sendOk("#e#b圣诞组队任务#k#n\r\n"
                + "与队友保护巨大雪人，收集并投放雪之力量，最后击败斯克鲁奇。\r\n\r\n"
                + "Easy：21～30级，3～6人，15分钟\r\n"
                + "Normal：31～40级，3～6人，20分钟\r\n"
                + "Hard：41～50级，3～6人，25分钟\r\n\r\n"
                + "请前往雪精灵 NPC 报名，由队长发起任务。");
            cm.dispose();
        } else if (selection == 1) {
            cm.dispose();
            cm.openNpc(9000038);
        } else {
            cm.dispose();
        }
    }
}

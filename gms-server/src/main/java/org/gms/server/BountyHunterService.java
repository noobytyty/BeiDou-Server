package org.gms.server;

import org.gms.client.Character;
import org.gms.client.inventory.manipulator.InventoryManipulator;
import org.gms.net.server.Server;
import org.gms.net.server.channel.Channel;
import org.gms.net.server.world.World;
import org.gms.server.life.LifeFactory;
import org.gms.server.life.Monster;
import org.gms.server.maps.MapleMap;
import org.gms.server.maps.Portal;
import org.gms.util.PacketCreator;
import org.gms.util.Randomizer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.awt.Point;

/**
 * 赏金猎人/通缉怪：定时在随机地图刷一只通缉怪，全服公告位置，
 * 击杀者获得赏金（金币 + 随机美容券），再次全服公告。
 */
public class BountyHunterService {

    private static final Logger log = LoggerFactory.getLogger(BountyHunterService.class);
    private static final BountyHunterService instance = new BountyHunterService();

    public static BountyHunterService getInstance() {
        return instance;
    }

    /** 通缉怪池（专属通缉犯：9900000-9900004） */
    private static final int[] BOUNTY_MOBS = {9900000, 9900001, 9900002, 9900003, 9900004};
    /** 通缉地图池（热门打怪地图，非主城） */
    private static final int[] BOUNTY_MAPS = {
            101020000, 101030000, 102030000, 103000200, 105030000, 105040000, 105040100,
            110010000, 110030000, 211010000, 211020000, 211030000, 211040000,
            220010000, 220020000, 220030000, 221020000, 222010000,
            230010000, 230020000, 230030000, 230040000,
            240010000, 240010100, 240020000, 240030000, 240040000,
            250010000, 250010200, 250020000, 251010000,
            260010000, 260010100, 260020000,
            270010100, 800010000, 800020000, 800030000, 801010000
    };
    /** 刷怪间隔（毫秒）：30 分钟 */
    private static final long INTERVAL_MS = 30 * 60 * 1000L;
    /** 赏金金币 */
    private static final int BOUNTY_MESO = 2_000_000;
    /** 赏金道具：随机美容券 */
    private static final int BOUNTY_ITEM = 2430029;

    private volatile Monster bountyMonster;
    private volatile boolean bountyActive = false;

    public void init() {
        scheduleNext(30_000);   // 服务器启动 30 秒后首次刷通缉怪
    }

    private void scheduleNext(long delay) {
        TimerManager.getInstance().schedule(this::spawnBounty, delay);
    }

    private void spawnBounty() {
        try {
            if (bountyActive) {
                // 上一只还未被讨伐：本次不刷，等下一轮
                scheduleNext(INTERVAL_MS);
                return;
            }
            int mobId = BOUNTY_MOBS[Randomizer.nextInt(BOUNTY_MOBS.length)];
            int mapId = BOUNTY_MAPS[Randomizer.nextInt(BOUNTY_MAPS.length)];
            World world = Server.getInstance().getWorld(0);
            if (world == null) {
                scheduleNext(INTERVAL_MS);
                return;
            }
            int channel = Randomizer.rand(1, world.getChannelsSize());
            Channel ch = world.getChannel(channel);
            if (ch == null) {
                scheduleNext(INTERVAL_MS);
                return;
            }
            MapleMap map = ch.getMapFactory().getMap(mapId);
            if (map == null) {
                scheduleNext(INTERVAL_MS);
                return;
            }
            Monster m = LifeFactory.getMonster(mobId);
            if (m == null) {
                scheduleNext(INTERVAL_MS);
                return;
            }
            Portal portal = map.getPortal(0);
            Point pos = portal != null ? portal.getPosition() : new Point(100, 100);
            map.spawnMonsterOnGroundBelow(m, pos);

            bountyMonster = m;
            bountyActive = true;
            Server.getInstance().broadcastMessage(0, PacketCreator.serverNotice(6,
                    "[通缉令] 逃犯「" + m.getName() + "」现身于 " + map.getMapName() + "（频道 " + channel + "）！前往讨伐可获得赏金！"));
            log.info("Bounty monster spawned: mob {} at map {} channel {}", mobId, mapId, channel);
        } catch (Exception e) {
            log.error("Error spawning bounty monster", e);
        }
        scheduleNext(INTERVAL_MS);
    }

    /** 怪物被击杀时调用：若为通缉怪则发放赏金（按 oid + 地图实例校验） */
    public void onMonsterKilled(Monster m, Character killer) {
        if (bountyActive && bountyMonster != null
                && m.getObjectId() == bountyMonster.getObjectId()
                && m.getMap() != null && m.getMap() == bountyMonster.getMap()) {
            bountyActive = false;
            bountyMonster = null;
            if (killer != null) {
                killer.gainMeso(BOUNTY_MESO, true, true, false);
                if (killer.canHold(BOUNTY_ITEM)) {
                    InventoryManipulator.addById(killer.getClient(), BOUNTY_ITEM, (short) 1);
                }
                Server.getInstance().broadcastMessage(0, PacketCreator.serverNotice(6,
                        "[通缉令] 逃犯已被「" + killer.getName() + "」讨伐！赏金 " + BOUNTY_MESO + " 金币与随机美容券已发放！"));
            }
        }
    }
}

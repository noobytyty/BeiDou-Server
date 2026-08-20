package org.gms.server;

import org.gms.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 收藏系统服务：怪物卡图鉴 + 任务达人。
 * 每 25 张怪物卡：全属性 +1；每 50 个任务：全属性 +1、物攻/魔攻 +1、HP/MP +100。
 * 同一种怪物卡最多计入 5 张。
 * 加成在穿戴「收藏家勋章」(1142991) 时，由角色属性计算入口按账号进度动态结算。
 */
public class CollectionService {

    private static final Logger log = LoggerFactory.getLogger(CollectionService.class);
    private static final CollectionService instance = new CollectionService();

    /** 收藏家腰带：动态属性载体（勋章栏留给成就称号勋章） */
    public static final int COLLECTOR_BELT = 1132991;
    public static final int CARDS_PER_STAT = 25;
    public static final int QUESTS_PER_STAT = 50;

    public static CollectionService getInstance() {
        return instance;
    }

    public static class Bonus {
        public int str;
        public int dex;
        public int int_;
        public int luk;
        public int watk;
        public int matk;
        public int maxhp;
        public int maxmp;
    }

    private static class Cache {
        final int cards;
        final int quests;
        final long time;

        Cache(int cards, int quests) {
            this.cards = cards;
            this.quests = quests;
            this.time = System.currentTimeMillis();
        }
    }

    private final ConcurrentHashMap<Integer, Cache> cache = new ConcurrentHashMap<>();
    private static final long CACHE_TTL = 30_000;

    private Cache load(int accountId) {
        Cache c = cache.get(accountId);
        if (c != null && System.currentTimeMillis() - c.time < CACHE_TTL) {
            return c;
        }
        int cards = 0;
        int quests = 0;
        try (Connection con = DatabaseConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COALESCE(SUM(LEAST(level, 5)), 0) FROM monsterbook " +
                            "WHERE charid IN (SELECT id FROM characters WHERE accountid = ?)")) {
                ps.setInt(1, accountId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        cards = rs.getInt(1);
                    }
                }
            }
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(DISTINCT quest) FROM queststatus " +
                            "WHERE status = 2 AND characterid IN (SELECT id FROM characters WHERE accountid = ?)")) {
                ps.setInt(1, accountId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        quests = rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            log.error("Error loading collection data for account {}", accountId, e);
        }
        Cache nc = new Cache(cards, quests);
        cache.put(accountId, nc);
        return nc;
    }

    public int getCardCount(int accountId) {
        return load(accountId).cards;
    }

    public int getQuestCount(int accountId) {
        return load(accountId).quests;
    }

    public Bonus getBonus(int accountId) {
        Cache c = load(accountId);
        int cardBonus = c.cards / CARDS_PER_STAT;
        int questBonus = c.quests / QUESTS_PER_STAT;
        Bonus b = new Bonus();
        b.str = cardBonus + questBonus;
        b.dex = cardBonus + questBonus;
        b.int_ = cardBonus + questBonus;
        b.luk = cardBonus + questBonus;
        b.watk = questBonus;
        b.matk = questBonus;
        b.maxhp = questBonus * 100;
        b.maxmp = questBonus * 100;
        return b;
    }
}

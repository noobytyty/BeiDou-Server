package org.gms.server;

import org.gms.client.Character;
import org.gms.net.server.Server;
import org.gms.net.server.world.World;
import org.gms.util.DatabaseConnection;
import org.gms.util.I18nUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * 收藏系统服务：怪物卡图鉴 + 任务达人。
 * 每 25 张怪物卡：全属性 +1；每 50 个任务：全属性 +1、物攻/魔攻 +1、HP/MP +100。
 * 同一种怪物卡在账号范围内最多计入 5 张。
 * 加成在穿戴「收藏家腰带」(1132991) 时，由角色属性计算入口按账号进度动态结算。
 */
public class CollectionService {

    private static final Logger log = LoggerFactory.getLogger(CollectionService.class);
    private static final CollectionService instance = new CollectionService();

    /** 收藏家腰带：动态属性载体（勋章栏留给成就称号勋章） */
    public static final int COLLECTOR_BELT = 1132991;
    public static final int CARDS_PER_STAT = 25;
    public static final int QUESTS_PER_STAT = 50;

    private static final long CACHE_TTL = 30_000;
    private static final long FAILED_CACHE_TTL = 5_000;

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

    public record CollectionSnapshot(
            int cards,
            int quests,
            Map<Integer, Integer> cardCounts,
            int cardTier,
            int questTier,
            int beltLevel,
            Bonus bonus,
            boolean available,
            boolean stale
    ) {
    }

    private static class Cache {
        final int cards;
        final int quests;
        final Map<Integer, Integer> cardCounts;
        final long time;
        final Set<Integer> onlineCharacterIds;
        final boolean available;
        final boolean stale;

        Cache(int cards, int quests, Map<Integer, Integer> cardCounts, long time, Collection<Integer> onlineCharacterIds, boolean available, boolean stale) {
            this.cards = cards;
            this.quests = quests;
            this.cardCounts = Collections.unmodifiableMap(new LinkedHashMap<>(cardCounts));
            this.time = time;
            this.onlineCharacterIds = Set.copyOf(onlineCharacterIds);
            this.available = available;
            this.stale = stale;
        }

        boolean isFresh(Set<Integer> currentOnlineCharacterIds, long now) {
            long ttl = available ? CACHE_TTL : FAILED_CACHE_TTL;
            return onlineCharacterIds.equals(currentOnlineCharacterIds) && now - time < ttl;
        }

        Cache asStale(long now) {
            return new Cache(cards, quests, cardCounts, now, onlineCharacterIds, true, true);
        }
    }

    private final ConcurrentHashMap<Integer, Cache> cache = new ConcurrentHashMap<>();

    public CollectionSnapshot getSnapshot(Character character) {
        Cache cached = load(character.getAccountId(), character);
        return toSnapshot(cached);
    }

    public CollectionSnapshot getSnapshot(int accountId) {
        return toSnapshot(load(accountId, null));
    }

    public int getCardCount(Character character) {
        return getSnapshot(character).cards();
    }

    public int getQuestCount(Character character) {
        return getSnapshot(character).quests();
    }

    public Bonus getBonus(Character character) {
        return getSnapshot(character).bonus();
    }

    public Bonus getEffectiveBonus(Character character) {
        if (!character.isCollectorBeltEquipped()) {
            return new Bonus();
        }
        return getBonus(character);
    }

    public int getCardCount(int accountId) {
        return getSnapshot(accountId).cards();
    }

    public int getQuestCount(int accountId) {
        return getSnapshot(accountId).quests();
    }

    public Bonus getBonus(int accountId) {
        return getSnapshot(accountId).bonus();
    }

    public void invalidate(int accountId) {
        cache.remove(accountId);
    }

    public void refreshOnlineCharacters(Character source) {
        for (Character character : getOnlineAccountCharacters(source.getAccountId(), source)) {
            if (character.isCollectorBeltEquipped()) {
                character.refreshCollectionBonus();
            }
        }
    }

    public String formatStatus(Character character) {
        CollectionSnapshot snapshot = getSnapshot(character);
        StringBuilder message = new StringBuilder();
        message.append("#e").append(I18nUtil.getMessage("CollectionStatus.title")).append("#n\r\n");

        if (!snapshot.available()) {
            message.append(I18nUtil.getMessage("CollectionStatus.status.unavailable")).append("\r\n");
            message.append(I18nUtil.getMessage("CollectionStatus.scope"));
            return message.toString();
        }

        message.append(I18nUtil.getMessage(
                character.isCollectorBeltEquipped()
                        ? "CollectionStatus.status.equipped"
                        : "CollectionStatus.status.notEquipped"
        )).append("\r\n");
        if (snapshot.stale()) {
            message.append(I18nUtil.getMessage("CollectionStatus.status.stale")).append("\r\n");
        }
        message.append(I18nUtil.getMessage("CollectionStatus.scope")).append("\r\n");
        message.append(I18nUtil.getMessage(
                "CollectionStatus.level",
                snapshot.beltLevel(),
                snapshot.cardTier(),
                snapshot.questTier()
        )).append("\r\n");

        int cardTiers = snapshot.cardTier();
        int questTiers = snapshot.questTier();
        int nextCardTarget = (cardTiers + 1) * CARDS_PER_STAT;
        int nextQuestTarget = (questTiers + 1) * QUESTS_PER_STAT;
        message.append(I18nUtil.getMessage(
                "CollectionStatus.cards",
                snapshot.cards(),
                cardTiers,
                nextCardTarget - snapshot.cards()
        )).append("\r\n");
        message.append(I18nUtil.getMessage(
                "CollectionStatus.quests",
                snapshot.quests(),
                questTiers,
                nextQuestTarget - snapshot.quests()
        )).append("\r\n");
        message.append(I18nUtil.getMessage(
                "CollectionStatus.stats",
                snapshot.bonus().str,
                snapshot.bonus().dex,
                snapshot.bonus().int_,
                snapshot.bonus().luk
        )).append("\r\n");
        message.append(I18nUtil.getMessage(
                "CollectionStatus.combat",
                snapshot.bonus().watk,
                snapshot.bonus().matk,
                snapshot.bonus().maxhp,
                snapshot.bonus().maxmp
        ));
        return message.toString();
    }

    public String formatCardMilestone(Character character, int totalCards) {
        return I18nUtil.getMessage(
                "CollectionStatus.cardMilestone",
                totalCards,
                totalCards / CARDS_PER_STAT
        ) + "\r\n" + formatStatus(character);
    }

    public String formatQuestMilestone(Character character, int totalQuests) {
        return I18nUtil.getMessage(
                "CollectionStatus.questMilestone",
                totalQuests,
                totalQuests / QUESTS_PER_STAT
        ) + "\r\n" + formatStatus(character);
    }

    public String formatEquipmentChange(Character character, boolean equipped) {
        return I18nUtil.getMessage(
                equipped ? "CollectionStatus.equip.enabled" : "CollectionStatus.equip.disabled"
        ) + "\r\n" + formatStatus(character);
    }

    static int calculateCappedCardCount(Map<Integer, Integer> cardCounts) {
        return cardCounts.values().stream()
                .mapToInt(count -> Math.min(Math.max(count, 0), 5))
                .sum();
    }

    static void mergeCardCounts(Map<Integer, Integer> target, Map<Integer, Integer> source) {
        source.forEach((cardId, quantity) -> {
            if (quantity != null && quantity > 0) {
                target.merge(cardId, Math.min(quantity, 5), Integer::sum);
            }
        });
    }

    static Bonus createBonus(int cards, int quests) {
        int cardBonus = calculateTier(cards, CARDS_PER_STAT);
        int questBonus = calculateTier(quests, QUESTS_PER_STAT);
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

    static int calculateTier(int progress, int threshold) {
        return Math.max(progress, 0) / threshold;
    }

    public static int calculateMonsterBookDisplayLevel(int cardTier) {
        return Math.max(1, cardTier + 1);
    }

    static Map<Integer, Integer> capCardCounts(Map<Integer, Integer> cardCounts) {
        Map<Integer, Integer> capped = new LinkedHashMap<>();
        cardCounts.forEach((cardId, count) -> {
            if (cardId != null && count != null && count > 0) {
                capped.put(cardId, Math.min(count, 5));
            }
        });
        return capped;
    }

    private CollectionSnapshot toSnapshot(Cache cached) {
        return new CollectionSnapshot(
                cached.cards,
                cached.quests,
                cached.cardCounts,
                calculateTier(cached.cards, CARDS_PER_STAT),
                calculateTier(cached.quests, QUESTS_PER_STAT),
                calculateTier(cached.cards, CARDS_PER_STAT) + calculateTier(cached.quests, QUESTS_PER_STAT),
                createBonus(cached.cards, cached.quests),
                cached.available,
                cached.stale
        );
    }

    private Cache load(int accountId, Character currentCharacter) {
        List<Character> onlineCharacters = getOnlineAccountCharacters(accountId, currentCharacter);
        Set<Integer> onlineCharacterIds = onlineCharacters.stream()
                .map(Character::getId)
                .collect(Collectors.toCollection(LinkedHashSet::new));
        long now = System.currentTimeMillis();
        Cache cached = cache.get(accountId);
        if (cached != null && cached.isFresh(onlineCharacterIds, now)) {
            return cached;
        }

        try {
            Cache loaded = loadFromDatabase(accountId, onlineCharacters, onlineCharacterIds, now);
            cache.put(accountId, loaded);
            return loaded;
        } catch (SQLException e) {
            log.error(I18nUtil.getLogMessage("CollectionService.load.error"), accountId, e);
            if (cached != null && cached.available && cached.onlineCharacterIds.equals(onlineCharacterIds)) {
                Cache stale = cached.asStale(now);
                cache.put(accountId, stale);
                return stale;
            }

            Cache unavailable = new Cache(0, 0, Collections.emptyMap(), now, onlineCharacterIds, false, false);
            cache.put(accountId, unavailable);
            return unavailable;
        }
    }

    private Cache loadFromDatabase(
            int accountId,
            List<Character> onlineCharacters,
            Set<Integer> onlineCharacterIds,
            long now
    ) throws SQLException {
        Map<Integer, Integer> cardCounts = new HashMap<>();
        Set<Integer> questIds = new HashSet<>();

        try (Connection con = DatabaseConnection.getConnection()) {
            String cardQuery = appendCharacterExclusion(
                    "SELECT m.cardid, SUM(LEAST(m.level, 5)) " +
                            "FROM monsterbook m " +
                            "JOIN characters c ON c.id = m.charid " +
                            "WHERE c.accountid = ?",
                    "m.charid",
                    onlineCharacterIds.size()
            ) + " GROUP BY m.cardid";
            try (PreparedStatement ps = con.prepareStatement(cardQuery)) {
                bindAccountAndCharacterIds(ps, accountId, onlineCharacterIds);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        cardCounts.put(rs.getInt(1), rs.getInt(2));
                    }
                }
            }

            String questQuery = appendCharacterExclusion(
                    "SELECT DISTINCT qs.quest " +
                            "FROM queststatus qs " +
                            "JOIN characters c ON c.id = qs.characterid " +
                            "WHERE c.accountid = ? AND qs.status = 2",
                    "qs.characterid",
                    onlineCharacterIds.size()
            );
            try (PreparedStatement ps = con.prepareStatement(questQuery)) {
                bindAccountAndCharacterIds(ps, accountId, onlineCharacterIds);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        questIds.add(rs.getInt(1));
                    }
                }
            }
        }

        for (Character character : onlineCharacters) {
            mergeCardCounts(cardCounts, character.getMonsterBook().getCards());
            questIds.addAll(character.getCompletedQuestIds());
        }

        Map<Integer, Integer> cappedCardCounts = capCardCounts(cardCounts);
        return new Cache(
                calculateCappedCardCount(cappedCardCounts),
                questIds.size(),
                cappedCardCounts,
                now,
                onlineCharacterIds,
                true,
                false
        );
    }

    private List<Character> getOnlineAccountCharacters(int accountId, Character currentCharacter) {
        Map<Integer, Character> characters = new LinkedHashMap<>();
        for (World world : Server.getInstance().getWorlds()) {
            for (Character character : world.getPlayerStorage().getAllCharacters()) {
                if (character.getAccountId() == accountId && character.getMonsterBook() != null) {
                    characters.put(character.getId(), character);
                }
            }
        }
        if (currentCharacter != null
                && currentCharacter.getAccountId() == accountId
                && currentCharacter.getMonsterBook() != null) {
            characters.put(currentCharacter.getId(), currentCharacter);
        }
        return new ArrayList<>(characters.values());
    }

    private static String appendCharacterExclusion(String query, String column, int characterCount) {
        if (characterCount == 0) {
            return query;
        }
        return query + " AND " + column + " NOT IN (" +
                String.join(",", Collections.nCopies(characterCount, "?")) + ")";
    }

    private static void bindAccountAndCharacterIds(
            PreparedStatement ps,
            int accountId,
            Set<Integer> characterIds
    ) throws SQLException {
        ps.setInt(1, accountId);
        int index = 2;
        for (int characterId : characterIds) {
            ps.setInt(index++, characterId);
        }
    }
}

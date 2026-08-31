package org.gms.server;

import org.junit.jupiter.api.Test;

import java.util.LinkedHashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;

class CollectionServiceTest {

    @Test
    void capsEachCardAtFiveAcrossCharacters() {
        Map<Integer, Integer> cardCounts = new LinkedHashMap<>();
        cardCounts.put(2380001, 10);
        cardCounts.put(2380002, 3);

        assertEquals(8, CollectionService.calculateCappedCardCount(cardCounts));
    }

    @Test
    void mergesPerCharacterCardCountsBeforeApplyingAccountCap() {
        Map<Integer, Integer> cardCounts = new LinkedHashMap<>();
        CollectionService.mergeCardCounts(cardCounts, Map.of(2380001, 5, 2380002, 2));
        CollectionService.mergeCardCounts(cardCounts, Map.of(2380001, 5, 2380002, 4));

        assertEquals(10, CollectionService.calculateCappedCardCount(cardCounts));
    }

    @Test
    void calculatesCardAndQuestMilestoneBonuses() {
        CollectionService.Bonus bonus = CollectionService.createBonus(50, 100);

        assertEquals(4, bonus.str);
        assertEquals(4, bonus.dex);
        assertEquals(4, bonus.int_);
        assertEquals(4, bonus.luk);
        assertEquals(2, bonus.watk);
        assertEquals(2, bonus.matk);
        assertEquals(200, bonus.maxhp);
        assertEquals(200, bonus.maxmp);
    }

    @Test
    void calculatesIndependentProgressTiersAndBeltLevel() {
        int cardTier = CollectionService.calculateTier(49, CollectionService.CARDS_PER_STAT);
        int questTier = CollectionService.calculateTier(100, CollectionService.QUESTS_PER_STAT);

        assertEquals(1, cardTier);
        assertEquals(2, questTier);
        assertEquals(3, cardTier + questTier);
    }

    @Test
    void mapsCollectorCardTiersToMonsterBookDisplayLevels() {
        assertEquals(1, CollectionService.calculateMonsterBookDisplayLevel(0));
        assertEquals(2, CollectionService.calculateMonsterBookDisplayLevel(1));
        assertEquals(4, CollectionService.calculateMonsterBookDisplayLevel(3));
    }

    @Test
    void capsAccountCardCountsBeforeSendingDisplayData() {
        Map<Integer, Integer> cardCounts = new LinkedHashMap<>();
        cardCounts.put(2380001, 9);
        cardCounts.put(2380002, 2);

        assertEquals(Map.of(2380001, 5, 2380002, 2), CollectionService.capCardCounts(cardCounts));
    }
}

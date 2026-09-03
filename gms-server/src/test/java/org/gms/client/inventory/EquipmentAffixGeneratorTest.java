package org.gms.client.inventory;

import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class EquipmentAffixGeneratorTest {

    @Test
    void blocksStrengthAndPhysicalAttackAffixesForMagicianEquipment() {
        assertFalse(EquipmentAffixGenerator.isAffixCompatibleWithJob("STR", 2));
        assertFalse(EquipmentAffixGenerator.isAffixCompatibleWithJob("STR_DEX", 2));
        assertFalse(EquipmentAffixGenerator.isAffixCompatibleWithJob("WATK", 2));
        assertTrue(EquipmentAffixGenerator.isAffixCompatibleWithJob("INT", 2));
        assertTrue(EquipmentAffixGenerator.isAffixCompatibleWithJob("INT_MATK", 2));
        assertTrue(EquipmentAffixGenerator.isAffixCompatibleWithJob("HP", 2));
    }

    @Test
    void mapsRawWzJobFlagsToTheirCorrectClass() {
        assertFalse(EquipmentAffixGenerator.isAffixCompatibleWithJob("INT", 1));
        assertTrue(EquipmentAffixGenerator.isAffixCompatibleWithJob("INT", 2));
        assertFalse(EquipmentAffixGenerator.isAffixCompatibleWithJob("INT", 4));
        assertTrue(EquipmentAffixGenerator.isAffixCompatibleWithJob("LUK", 8));
        assertTrue(EquipmentAffixGenerator.isAffixCompatibleWithJob("STR", 16));
        assertFalse(EquipmentAffixGenerator.isAffixCompatibleWithJob("STR", 10));
        assertTrue(EquipmentAffixGenerator.isAffixCompatibleWithJob("INT", 10));
    }

    @Test
    void infersMageCompatibilityForUnrestrictedIntEquipment() {
        Map<String, Integer> equipmentStats = Map.of(
                "reqJob", 0,
                "reqINT", 100,
                "reqSTR", 0,
                "reqDEX", 0,
                "STR", 0,
                "DEX", 0,
                "INT", 3
        );

        assertFalse(EquipmentAffixGenerator.isAffixCompatibleWithEquipmentStats("STR", equipmentStats));
        assertTrue(EquipmentAffixGenerator.isAffixCompatibleWithEquipmentStats("INT", equipmentStats));
    }

    @Test
    void equipmentQualityOnlyModifiesHigherTierWeights() {
        assertEquals(1.0, EquipmentAffixGenerator.qualityTierWeightMultiplier(0, 4));
        assertEquals(0.92, EquipmentAffixGenerator.qualityTierWeightMultiplier(0, 12), 0.0001);
        assertEquals(1.0, EquipmentAffixGenerator.qualityTierWeightMultiplier(2, 12), 0.0001);
        assertEquals(1.16, EquipmentAffixGenerator.qualityTierWeightMultiplier(6, 12), 0.0001);
        assertTrue(EquipmentAffixGenerator.qualityTierWeightMultiplier(6, 12)
                > EquipmentAffixGenerator.qualityTierWeightMultiplier(2, 12));
    }
}

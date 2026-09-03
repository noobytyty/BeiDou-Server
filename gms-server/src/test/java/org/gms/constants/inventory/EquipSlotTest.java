package org.gms.constants.inventory;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class EquipSlotTest {

    @Test
    void cashWeaponsMustUseTheCashWeaponSlot() {
        assertTrue(EquipSlot.WEAPON.isAllowed(-111, true));
        assertFalse(EquipSlot.WEAPON.isAllowed(-11, true));
        assertTrue(EquipSlot.WEAPON.isAllowed(-11, false));
    }
}

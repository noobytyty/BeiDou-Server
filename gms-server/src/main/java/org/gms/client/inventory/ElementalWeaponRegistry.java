package org.gms.client.inventory;

import org.gms.server.life.Element;

public final class ElementalWeaponRegistry {
    private ElementalWeaponRegistry() {
    }

    public static Element elementOf(int itemId) {
        int suffix = itemId - 1372035;
        if (suffix >= 0 && suffix <= 7) {
            return elementForIndex(suffix);
        }
        suffix = itemId - 1382045;
        if (suffix >= 0 && suffix <= 7) {
            return elementForIndex(suffix);
        }
        return null;
    }

    public static boolean isWandOrStaff(int itemId) {
        int category = itemId / 10000;
        return category == 137 || category == 138;
    }

    private static Element elementForIndex(int index) {
        return switch (index) {
            case 0, 5 -> Element.FIRE;
            case 1, 6 -> Element.ICE;
            case 2, 7 -> Element.LIGHTING;
            case 3, 4 -> Element.HOLY;
            default -> Element.NEUTRAL;
        };
    }
}

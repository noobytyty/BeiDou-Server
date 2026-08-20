package org.gms.client.inventory;

import lombok.Getter;
import org.gms.constants.id.ItemId;
import org.gms.util.I18nUtil;

@Getter
public enum VirtualInventoryType {
    SCROLL(1, ItemId.VIRTUAL_SCROLL_SATCHEL, InventoryType.USE),
    ORE(2, ItemId.VIRTUAL_ORE_SATCHEL, InventoryType.ETC);

    private final int code;
    private final int accessItemId;
    private final InventoryType inventoryType;

    VirtualInventoryType(int code, int accessItemId, InventoryType inventoryType) {
        this.code = code;
        this.accessItemId = accessItemId;
        this.inventoryType = inventoryType;
    }

    public String getDisplayName() {
        return I18nUtil.getMessage("VirtualInventoryType." + name());
    }

    public static VirtualInventoryType fromCode(int code) {
        for (VirtualInventoryType value : values()) {
            if (value.code == code) {
                return value;
            }
        }
        return null;
    }

    public static VirtualInventoryType fromItemId(int itemId) {
        for (VirtualInventoryType value : values()) {
            if (value.matches(itemId)) {
                return value;
            }
        }
        return null;
    }

    public boolean matches(int itemId) {
        return switch (this) {
            case SCROLL -> itemId / 10000 == 204 || itemId == ItemId.WHITE_SCROLL;
            case ORE -> {
                int itemType = itemId / 10000;
                yield itemType == 401 || itemType == 402;
            }
        };
    }
}

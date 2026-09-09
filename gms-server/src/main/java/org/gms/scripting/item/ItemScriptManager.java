/*
This file is part of the OdinMS Maple Story Server
Copyright (C) 2008 Patrick Huy <patrick.huy@frz.cc>
Matthias Butz <matze@odinms.de>
Jan Christian Meyer <vimes@odinms.de>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation version 3 as published by
the Free Software Foundation. You may not use, modify or distribute
this program under any other version of the GNU Affero General Public
License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.gms.scripting.item;

import org.gms.client.Client;
import org.gms.client.inventory.InventoryType;
import org.gms.client.inventory.Item;
import org.gms.constants.id.ItemId;
import org.gms.constants.inventory.ItemConstants;
import org.gms.scripting.npc.NPCScriptManager;
import org.gms.server.ItemInformationProvider.ScriptedItem;

public class ItemScriptManager {

    private static final ItemScriptManager instance = new ItemScriptManager();

    public static ItemScriptManager getInstance() {
        return instance;
    }

    public void runItemScript(Client c, ScriptedItem scriptItem) {
        NPCScriptManager.getInstance().start(c, scriptItem, null);
    }

    public Item findScriptedItem(Client c, int itemId, short slot) {
        InventoryType primaryType = ItemConstants.getInventoryType(itemId);
        Item item = findScriptedItem(c, primaryType, itemId, slot);
        if (item != null || !isVirtualSatchel(itemId)) {
            return item;
        }

        InventoryType fallbackType = primaryType == InventoryType.ETC
                ? InventoryType.USE
                : InventoryType.ETC;
        return findScriptedItem(c, fallbackType, itemId, slot);
    }

    private Item findScriptedItem(Client c, InventoryType inventoryType, int itemId, short slot) {
        if (inventoryType == null || inventoryType == InventoryType.UNDEFINED) {
            return null;
        }
        Item item = c.getPlayer().getInventory(inventoryType).getItem(slot);
        if (isMatchingScriptedItem(item, itemId)) {
            return item;
        }
        item = c.getPlayer().getInventory(inventoryType).findById(itemId);
        return isMatchingScriptedItem(item, itemId) ? item : null;
    }

    private boolean isVirtualSatchel(int itemId) {
        return itemId == ItemId.VIRTUAL_SCROLL_SATCHEL || itemId == ItemId.VIRTUAL_ORE_SATCHEL;
    }

    private boolean isMatchingScriptedItem(Item item, int itemId) {
        return item != null && item.getItemId() == itemId && item.getQuantity() > 0;
    }
}
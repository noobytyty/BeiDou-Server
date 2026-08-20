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
import org.gms.client.inventory.Inventory;
import org.gms.client.inventory.Item;
import org.gms.client.inventory.VirtualInventoryType;
import org.gms.client.inventory.manipulator.InventoryManipulator;
import org.gms.scripting.AbstractPlayerInteraction;
import org.gms.scripting.npc.NPCConversationManager;
import org.gms.server.VirtualInventoryService;
import org.gms.util.I18nUtil;
import org.gms.util.Pair;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * @author kevintjuh93
 */
public class ItemScriptMethods extends NPCConversationManager {
    public ItemScriptMethods(Client c) {
        super(c, 9010000, -1, null, true);
    }

    public void prepareVirtualInventory(int inventoryType) {
        VirtualInventoryType type = VirtualInventoryType.fromCode(inventoryType);
        if (type == null) {
            return;
        }

        Inventory inventory = getPlayer().getInventory(type.getInventoryType());
        int movedTypes = 0;
        int movedQuantity = 0;
        int blockedItems = 0;
        int skippedSpecialItems = 0;
        Set<Integer> movedItemIds = new HashSet<>();

        for (Item item : inventory.list()) {
            if (!type.matches(item.getItemId())) {
                continue;
            }
            if (!InventoryManipulator.shouldUseVirtualInventory(item.getItemId(), item.getOwner(), item.getFlag(), item.getExpiration())) {
                skippedSpecialItems++;
                continue;
            }
            if (!getPlayer().canHoldVirtualItem(type, item.getItemId(), item.getQuantity())) {
                blockedItems++;
                continue;
            }

            short quantity = item.getQuantity();
            InventoryManipulator.removeFromSlot(c, type.getInventoryType(), item.getPosition(), quantity, false);
            if (!getPlayer().addVirtualItem(type, item.getItemId(), quantity)) {
                InventoryManipulator.addByIdToInventory(c, item.getItemId(), quantity, item.getOwner(), item.getPetId(), item.getFlag(), item.getExpiration());
                blockedItems++;
                continue;
            }

            movedQuantity += quantity;
            if (movedItemIds.add(item.getItemId())) {
                movedTypes++;
            }
        }

        if (movedQuantity > 0) {
            getPlayer().dropMessage(5, I18nUtil.getMessage("VirtualInventory.sync.moved", movedTypes, movedQuantity, type.getDisplayName()));
        }
        if (blockedItems > 0) {
            getPlayer().dropMessage(5, I18nUtil.getMessage("VirtualInventory.sync.partial", type.getDisplayName()));
        }
        if (skippedSpecialItems > 0) {
            getPlayer().dropMessage(5, I18nUtil.getMessage("VirtualInventory.sync.skip-special"));
        }
    }

    public boolean hasVirtualInventoryItems(int inventoryType) {
        VirtualInventoryType type = VirtualInventoryType.fromCode(inventoryType);
        return type != null && getPlayer().hasVirtualInventoryEntries(type);
    }

    public String getVirtualInventoryMenuText(int inventoryType) {
        VirtualInventoryType type = VirtualInventoryType.fromCode(inventoryType);
        if (type == null) {
            return I18nUtil.getMessage("VirtualInventory.invalid");
        }

        List<Pair<Integer, Integer>> entries = getPlayer().listVirtualInventory(type);
        StringBuilder builder = new StringBuilder(I18nUtil.getMessage("VirtualInventory.menu.header", type.getDisplayName(), entries.size(), VirtualInventoryService.MAX_ITEM_TYPES));
        if (entries.isEmpty()) {
            builder.append(I18nUtil.getMessage("VirtualInventory.menu.empty"));
            return builder.toString();
        }

        for (int i = 0; i < entries.size(); i++) {
            Pair<Integer, Integer> entry = entries.get(i);
            builder.append("#L").append(i)
                    .append("##i").append(entry.getLeft()).append("# #t").append(entry.getLeft()).append("##k x #r")
                    .append(entry.getRight()).append("##l\r\n");
        }
        return builder.toString();
    }

    public int getVirtualInventoryEntryItemId(int inventoryType, int index) {
        Pair<Integer, Integer> entry = getVirtualInventoryEntry(inventoryType, index);
        return entry == null ? 0 : entry.getLeft();
    }

    public int getVirtualInventoryEntryQuantity(int inventoryType, int itemId) {
        VirtualInventoryType type = VirtualInventoryType.fromCode(inventoryType);
        if (type == null || !type.matches(itemId)) {
            return 0;
        }
        return Math.min(getPlayer().getVirtualItemQuantity(itemId), Short.MAX_VALUE);
    }

    public String getVirtualInventoryWithdrawPrompt(int inventoryType, int itemId) {
        VirtualInventoryType type = VirtualInventoryType.fromCode(inventoryType);
        if (type == null || itemId <= 0) {
            return I18nUtil.getMessage("VirtualInventory.invalid");
        }
        return I18nUtil.getMessage("VirtualInventory.withdraw.prompt", type.getDisplayName(), itemId, getPlayer().getVirtualItemQuantity(itemId));
    }

    public String withdrawVirtualInventoryItem(int inventoryType, int itemId, int quantity) {
        VirtualInventoryType type = VirtualInventoryType.fromCode(inventoryType);
        if (type == null || itemId <= 0 || quantity <= 0) {
            return I18nUtil.getMessage("VirtualInventory.invalid");
        }
        if (getPlayer().getVirtualItemQuantity(itemId) < quantity) {
            return I18nUtil.getMessage("VirtualInventory.withdraw.not-enough");
        }
        if (!InventoryManipulator.checkSpaceIgnoringVirtual(c, itemId, quantity, "")) {
            return I18nUtil.getMessage("VirtualInventory.withdraw.inventory-full", type.getInventoryType().getName());
        }
        if (!getPlayer().removeVirtualItem(type, itemId, quantity)) {
            return I18nUtil.getMessage("VirtualInventory.withdraw.not-enough");
        }
        if (!InventoryManipulator.addByIdToInventory(c, itemId, (short) quantity, "", -1, (short) 0, -1)) {
            getPlayer().addVirtualItem(type, itemId, quantity);
            return I18nUtil.getMessage("VirtualInventory.withdraw.inventory-full", type.getInventoryType().getName());
        }
        return I18nUtil.getMessage("VirtualInventory.withdraw.success", quantity, itemId, type.getDisplayName());
    }

    private Pair<Integer, Integer> getVirtualInventoryEntry(int inventoryType, int index) {
        VirtualInventoryType type = VirtualInventoryType.fromCode(inventoryType);
        if (type == null || index < 0) {
            return null;
        }
        List<Pair<Integer, Integer>> entries = getPlayer().listVirtualInventory(type);
        if (index >= entries.size()) {
            return null;
        }
        return entries.get(index);
    }
}

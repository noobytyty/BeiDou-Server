package org.gms.server;

import org.gms.client.inventory.VirtualInventoryType;
import org.gms.util.DatabaseConnection;
import org.gms.util.Pair;
import org.springframework.stereotype.Service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.EnumMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class VirtualInventoryService {
    public static final int MAX_ITEM_TYPES = 100;

    public EnumMap<VirtualInventoryType, LinkedHashMap<Integer, Integer>> loadByCharacterId(int characterId) {
        EnumMap<VirtualInventoryType, LinkedHashMap<Integer, Integer>> result = createEmptyInventories();
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("""
                     SELECT inventory_type, item_id, quantity
                     FROM character_virtual_inventory
                     WHERE character_id = ?
                     ORDER BY inventory_type, item_id
                     """)) {
            ps.setInt(1, characterId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    VirtualInventoryType type = VirtualInventoryType.fromCode(rs.getInt("inventory_type"));
                    if (type == null) {
                        continue;
                    }
                    result.get(type).put(rs.getInt("item_id"), rs.getInt("quantity"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to load virtual inventory for character " + characterId, e);
        }
        return result;
    }

    public void save(Connection con, int characterId, Map<VirtualInventoryType, ? extends Map<Integer, Integer>> inventories) throws SQLException {
        try (PreparedStatement delete = con.prepareStatement("DELETE FROM character_virtual_inventory WHERE character_id = ?")) {
            delete.setInt(1, characterId);
            delete.executeUpdate();
        }

        List<Pair<VirtualInventoryType, Pair<Integer, Integer>>> rows = new ArrayList<>();
        for (VirtualInventoryType type : VirtualInventoryType.values()) {
            Map<Integer, Integer> inventory = inventories.get(type);
            if (inventory == null) {
                continue;
            }
            for (Map.Entry<Integer, Integer> entry : inventory.entrySet()) {
                if (entry.getValue() != null && entry.getValue() > 0) {
                    rows.add(new Pair<>(type, new Pair<>(entry.getKey(), entry.getValue())));
                }
            }
        }

        if (rows.isEmpty()) {
            return;
        }

        try (PreparedStatement insert = con.prepareStatement("""
                INSERT INTO character_virtual_inventory
                    (character_id, inventory_type, item_id, quantity)
                VALUES (?, ?, ?, ?)
                """)) {
            for (Pair<VirtualInventoryType, Pair<Integer, Integer>> row : rows) {
                insert.setInt(1, characterId);
                insert.setInt(2, row.getLeft().getCode());
                insert.setInt(3, row.getRight().getLeft());
                insert.setInt(4, row.getRight().getRight());
                insert.addBatch();
            }
            insert.executeBatch();
        }
    }

    public void deleteByCharacterId(int characterId) {
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM character_virtual_inventory WHERE character_id = ?")) {
            ps.setInt(1, characterId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete virtual inventory for character " + characterId, e);
        }
    }

    private EnumMap<VirtualInventoryType, LinkedHashMap<Integer, Integer>> createEmptyInventories() {
        EnumMap<VirtualInventoryType, LinkedHashMap<Integer, Integer>> result = new EnumMap<>(VirtualInventoryType.class);
        for (VirtualInventoryType type : VirtualInventoryType.values()) {
            result.put(type, new LinkedHashMap<>());
        }
        return result;
    }
}

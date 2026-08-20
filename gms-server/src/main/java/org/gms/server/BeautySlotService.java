package org.gms.server;

import org.gms.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 美容存档槽位服务：每个账号独立的发型/脸型存档（基础 5 槽，可花钱扩展）。
 * 与 NPC 脚本（9977777 美容服务）配合，提供保存/读取/购买槽位能力。
 */
public class BeautySlotService {

    private static final Logger log = LoggerFactory.getLogger(BeautySlotService.class);

    public static final int TYPE_HAIR = 0;
    public static final int TYPE_FACE = 1;
    public static final int BASE_SLOTS = 5;

    private static final BeautySlotService instance = new BeautySlotService();

    public static BeautySlotService getInstance() {
        return instance;
    }

    public static class BeautySlot {
        public final int slotIndex;
        public final int itemId;

        public BeautySlot(int slotIndex, int itemId) {
            this.slotIndex = slotIndex;
            this.itemId = itemId;
        }
    }

    private String slotColumn(int slotType) {
        return slotType == TYPE_HAIR ? "beauty_hair_slots" : "beauty_face_slots";
    }

    /** 账号当前槽位上限（基础 5 + 已购买数量） */
    public int getSlotLimit(int accountId, int slotType) {
        String col = slotColumn(slotType);
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT " + col + " FROM accounts WHERE id = ?")) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Math.max(rs.getInt(1), BASE_SLOTS);
                }
            }
        } catch (SQLException e) {
            log.error("Error reading beauty slot limit for account {}", accountId, e);
        }
        return BASE_SLOTS;
    }

    /** 扩展一个槽位（+1），返回新上限 */
    public int purchaseSlot(int accountId, int slotType) {
        String col = slotColumn(slotType);
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("UPDATE accounts SET " + col + " = " + col + " + 1 WHERE id = ?")) {
            ps.setInt(1, accountId);
            if (ps.executeUpdate() != 1) {
                return -1;
            }
        } catch (SQLException e) {
            log.error("Error purchasing beauty slot for account {}", accountId, e);
            return -1;
        }
        return getSlotLimit(accountId, slotType);
    }

    /** 已存档的槽位列表 */
    public List<BeautySlot> getSlots(int accountId, int slotType) {
        List<BeautySlot> ret = new ArrayList<>();
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT slot_index, item_id FROM beauty_slots WHERE account_id = ? AND slot_type = ? ORDER BY slot_index")) {
            ps.setInt(1, accountId);
            ps.setInt(2, slotType);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ret.add(new BeautySlot(rs.getInt(1), rs.getInt(2)));
                }
            }
        } catch (SQLException e) {
            log.error("Error reading beauty slots for account {}", accountId, e);
        }
        return ret;
    }

    /** 读取指定槽位内容，空槽返回 -1 */
    public int getSlot(int accountId, int slotType, int slotIndex) {
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT item_id FROM beauty_slots WHERE account_id = ? AND slot_type = ? AND slot_index = ?")) {
            ps.setInt(1, accountId);
            ps.setInt(2, slotType);
            ps.setInt(3, slotIndex);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            log.error("Error reading beauty slot account {} type {} index {}", accountId, slotType, slotIndex, e);
        }
        return -1;
    }

    /** 保存（覆盖）槽位 */
    public void saveSlot(int accountId, int slotType, int slotIndex, int itemId) {
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO beauty_slots (account_id, slot_type, slot_index, item_id) VALUES (?, ?, ?, ?) " +
                             "ON DUPLICATE KEY UPDATE item_id = VALUES(item_id)")) {
            ps.setInt(1, accountId);
            ps.setInt(2, slotType);
            ps.setInt(3, slotIndex);
            ps.setInt(4, itemId);
            ps.executeUpdate();
        } catch (SQLException e) {
            log.error("Error saving beauty slot account {} type {} index {}", accountId, slotType, slotIndex, e);
        }
    }

    /** 清空槽位 */
    public void clearSlot(int accountId, int slotType, int slotIndex) {
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "DELETE FROM beauty_slots WHERE account_id = ? AND slot_type = ? AND slot_index = ?")) {
            ps.setInt(1, accountId);
            ps.setInt(2, slotType);
            ps.setInt(3, slotIndex);
            ps.executeUpdate();
        } catch (SQLException e) {
            log.error("Error clearing beauty slot account {} type {} index {}", accountId, slotType, slotIndex, e);
        }
    }
}

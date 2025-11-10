package com.hrm.dao;

import com.hrm.model.entity.RolePermission;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class RolePermissionDAO {
    private static final Logger logger = Logger.getLogger(RolePermissionDAO.class.getName());
    
    /**
     * Kiểm tra role có permission không
     */
    public boolean hasRolePermission(int roleId, int permissionId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM RolePermission WHERE RoleID = ? AND PermissionID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roleId);
            stmt.setInt(2, permissionId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking role permission", e);
            throw e;
        }
        return false;
    }
    
    /**
     * Lấy tất cả permissions của một role
     */
    public List<RolePermission> getRolePermissions(int roleId) throws SQLException {
        List<RolePermission> permissions = new ArrayList<>();
        String sql = "SELECT * FROM RolePermission WHERE RoleID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roleId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    RolePermission rp = new RolePermission();
                    rp.setRolePermissionId(rs.getInt("RolePermissionID"));
                    rp.setRoleId(rs.getInt("RoleID"));
                    rp.setPermissionId(rs.getInt("PermissionID"));
                    if (rs.getTimestamp("CreatedDate") != null) {
                        rp.setCreatedDate(rs.getTimestamp("CreatedDate").toLocalDateTime());
                    }
                    permissions.add(rp);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting role permissions", e);
            throw e;
        }
        return permissions;
    }
}



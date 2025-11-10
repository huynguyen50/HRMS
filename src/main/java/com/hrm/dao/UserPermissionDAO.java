package com.hrm.dao;

import com.hrm.model.entity.UserPermission;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * DAO for UserPermission entity - Core permission matrix management
 * @author admin
 */
public class UserPermissionDAO {
    private static final Logger logger = Logger.getLogger(UserPermissionDAO.class.getName());

    /**
     * Get all user permissions for a specific user
     */
    public List<UserPermission> getUserPermissions(int userId) throws SQLException {
        List<UserPermission> userPermissions = new ArrayList<>();
        String sql = "SELECT UserPermissionID, UserID, PermissionID, IsGranted, Scope, ScopeValue, " +
                     "CreatedDate, UpdatedDate, CreatedBy " +
                     "FROM UserPermission WHERE UserID = ? ORDER BY PermissionID";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    UserPermission up = mapResultSetToUserPermission(rs);
                    userPermissions.add(up);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting user permissions for user: " + userId, e);
            throw e;
        }

        return userPermissions;
    }

    /**
     * Get user permission map (PermissionID -> UserPermission) for quick lookup
     */
    public Map<Integer, UserPermission> getUserPermissionMap(int userId) throws SQLException {
        Map<Integer, UserPermission> permissionMap = new HashMap<>();
        List<UserPermission> permissions = getUserPermissions(userId);
        for (UserPermission up : permissions) {
            permissionMap.put(up.getPermissionId(), up);
        }
        return permissionMap;
    }

    /**
     * Get a specific user permission
     */
    public UserPermission getUserPermission(int userId, int permissionId, String scope, Integer scopeValue) throws SQLException {
        String sql = "SELECT UserPermissionID, UserID, PermissionID, IsGranted, Scope, ScopeValue, " +
                     "CreatedDate, UpdatedDate, CreatedBy " +
                     "FROM UserPermission WHERE UserID = ? AND PermissionID = ? AND Scope = ? " +
                     "AND (ScopeValue = ? OR (ScopeValue IS NULL AND ? IS NULL))";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, permissionId);
            stmt.setString(3, scope);
            if (scopeValue != null) {
                stmt.setInt(4, scopeValue);
                stmt.setInt(5, scopeValue);
            } else {
                stmt.setNull(4, java.sql.Types.INTEGER);
                stmt.setNull(5, java.sql.Types.INTEGER);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUserPermission(rs);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting user permission", e);
            throw e;
        }

        return null;
    }

    /**
     * Create or update user permission
     */
    public boolean saveUserPermission(UserPermission userPermission) throws SQLException {
        // Check if exists
        UserPermission existing = getUserPermission(
            userPermission.getUserId(),
            userPermission.getPermissionId(),
            userPermission.getScope(),
            userPermission.getScopeValue()
        );

        if (existing != null) {
            // Update existing
            return updateUserPermission(userPermission);
        } else {
            // Create new
            return createUserPermission(userPermission);
        }
    }

    /**
     * Create new user permission
     */
    public boolean createUserPermission(UserPermission userPermission) throws SQLException {
        String sql = "INSERT INTO UserPermission (UserID, PermissionID, IsGranted, Scope, ScopeValue, CreatedBy) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userPermission.getUserId());
            stmt.setInt(2, userPermission.getPermissionId());
            stmt.setBoolean(3, userPermission.isIsGranted());
            stmt.setString(4, userPermission.getScope());
            if (userPermission.getScopeValue() != null) {
                stmt.setInt(5, userPermission.getScopeValue());
            } else {
                stmt.setNull(5, java.sql.Types.INTEGER);
            }
            if (userPermission.getCreatedBy() != null) {
                stmt.setInt(6, userPermission.getCreatedBy());
            } else {
                stmt.setNull(6, java.sql.Types.INTEGER);
            }

            int result = stmt.executeUpdate();
            logger.log(Level.INFO, "User permission created: UserID=" + userPermission.getUserId() + 
                      ", PermissionID=" + userPermission.getPermissionId());
            return result > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating user permission", e);
            throw e;
        }
    }

    /**
     * Update existing user permission
     */
    public boolean updateUserPermission(UserPermission userPermission) throws SQLException {
        String sql = "UPDATE UserPermission SET IsGranted = ?, Scope = ?, ScopeValue = ?, " +
                     "UpdatedDate = CURRENT_TIMESTAMP, CreatedBy = ? " +
                     "WHERE UserPermissionID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, userPermission.isIsGranted());
            stmt.setString(2, userPermission.getScope());
            if (userPermission.getScopeValue() != null) {
                stmt.setInt(3, userPermission.getScopeValue());
            } else {
                stmt.setNull(3, java.sql.Types.INTEGER);
            }
            if (userPermission.getCreatedBy() != null) {
                stmt.setInt(4, userPermission.getCreatedBy());
            } else {
                stmt.setNull(4, java.sql.Types.INTEGER);
            }
            stmt.setInt(5, userPermission.getUserPermissionId());

            int result = stmt.executeUpdate();
            logger.log(Level.INFO, "User permission updated: UserPermissionID=" + userPermission.getUserPermissionId());
            return result > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating user permission", e);
            throw e;
        }
    }

    /**
     * Delete user permission
     */
    public boolean deleteUserPermission(int userPermissionId) throws SQLException {
        String sql = "DELETE FROM UserPermission WHERE UserPermissionID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userPermissionId);
            int result = stmt.executeUpdate();
            logger.log(Level.INFO, "User permission deleted: UserPermissionID=" + userPermissionId);
            return result > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting user permission", e);
            throw e;
        }
    }

    /**
     * Delete all permissions for a user
     */
    public boolean deleteAllUserPermissions(int userId) throws SQLException {
        String sql = "DELETE FROM UserPermission WHERE UserID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            int result = stmt.executeUpdate();
            logger.log(Level.INFO, "All user permissions deleted: UserID=" + userId);
            return result >= 0; // >= 0 because no rows deleted is also valid
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting all user permissions", e);
            throw e;
        }
    }

    /**
     * Batch save user permissions
     */
    public boolean batchSaveUserPermissions(List<UserPermission> userPermissions) throws SQLException {
        if (userPermissions == null || userPermissions.isEmpty()) {
            return true;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Delete existing permissions for this user
            int userId = userPermissions.get(0).getUserId();
            deleteAllUserPermissions(userId);

            // Insert new permissions
            String sql = "INSERT INTO UserPermission (UserID, PermissionID, IsGranted, Scope, ScopeValue, CreatedBy) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                for (UserPermission up : userPermissions) {
                    stmt.setInt(1, up.getUserId());
                    stmt.setInt(2, up.getPermissionId());
                    stmt.setBoolean(3, up.isIsGranted());
                    stmt.setString(4, up.getScope());
                    if (up.getScopeValue() != null) {
                        stmt.setInt(5, up.getScopeValue());
                    } else {
                        stmt.setNull(5, java.sql.Types.INTEGER);
                    }
                    if (up.getCreatedBy() != null) {
                        stmt.setInt(6, up.getCreatedBy());
                    } else {
                        stmt.setNull(6, java.sql.Types.INTEGER);
                    }
                    stmt.addBatch();
                }
                stmt.executeBatch();
            }

            conn.commit();
            logger.log(Level.INFO, "Batch saved " + userPermissions.size() + " user permissions for UserID=" + userId);
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            logger.log(Level.SEVERE, "Error batch saving user permissions", e);
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
            }
        }
    }

    /**
     * Helper method to map ResultSet to UserPermission
     */
    private UserPermission mapResultSetToUserPermission(ResultSet rs) throws SQLException {
        UserPermission up = new UserPermission();
        up.setUserPermissionId(rs.getInt("UserPermissionID"));
        up.setUserId(rs.getInt("UserID"));
        up.setPermissionId(rs.getInt("PermissionID"));
        up.setIsGranted(rs.getBoolean("IsGranted"));
        up.setScope(rs.getString("Scope"));
        Integer scopeValue = rs.getObject("ScopeValue", Integer.class);
        up.setScopeValue(scopeValue);
        if (rs.getTimestamp("CreatedDate") != null) {
            up.setCreatedDate(rs.getTimestamp("CreatedDate").toLocalDateTime());
        }
        if (rs.getTimestamp("UpdatedDate") != null) {
            up.setUpdatedDate(rs.getTimestamp("UpdatedDate").toLocalDateTime());
        }
        Integer createdBy = rs.getObject("CreatedBy", Integer.class);
        up.setCreatedBy(createdBy);
        return up;
    }
}


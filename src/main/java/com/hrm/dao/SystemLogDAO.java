/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.hrm.dao;

import com.hrm.model.entity.SystemLog;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Hask
 */
public class SystemLogDAO {

    private static final Logger logger = Logger.getLogger(SystemLogDAO.class.getName());

    /**
     * Insert a new system log entry
     */
    public boolean insertSystemLog(SystemLog systemLog) {
        String query = "INSERT INTO SystemLog (UserID, Action, ObjectType, OldValue, NewValue, Timestamp) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn != null) {
                stmt.setInt(1, systemLog.getUserId());
                stmt.setString(2, systemLog.getAction());
                stmt.setString(3, systemLog.getObjectType());
                stmt.setString(4, systemLog.getOldValue());
                stmt.setString(5, systemLog.getNewValue());
                stmt.setTimestamp(6, Timestamp.valueOf(systemLog.getTimestamp()));

                int rowsAffected = stmt.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error inserting system log", e);
        }

        return false;
    }

    /**
     * Insert a new system log entry with current timestamp
     */
    public boolean insertSystemLog(int userID, String action, String objectType, String oldValue, String newValue) {
        String query = "INSERT INTO SystemLog (UserID, Action, ObjectType, OldValue, NewValue, Timestamp) VALUES (?, ?, ?, ?, ?, NOW())";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn != null) {
                stmt.setInt(1, userID);
                stmt.setString(2, action);
                stmt.setString(3, objectType);
                stmt.setString(4, oldValue);
                stmt.setString(5, newValue);

                int rowsAffected = stmt.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error inserting system log", e);
        }

        return false;
    }

    /**
     * Get system logs by user ID
     */
    public List<SystemLog> getSystemLogsByUserID(int userID) {
        List<SystemLog> logs = new ArrayList<>();
        String query = "SELECT * FROM SystemLog WHERE UserID = ? ORDER BY Timestamp DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn != null) {
                stmt.setInt(1, userID);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        SystemLog log = mapResultSetToSystemLog(rs);
                        logs.add(log);
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting system logs by user ID", e);
        }

        return logs;
    }

    /**
     * Get system logs by user ID with limit
     */
    public List<SystemLog> getSystemLogsByUserID(int userID, int limit) {
        List<SystemLog> logs = new ArrayList<>();
        String query = "SELECT * FROM SystemLog WHERE UserID = ? ORDER BY Timestamp DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn != null) {
                stmt.setInt(1, userID);
                stmt.setInt(2, limit);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        SystemLog log = mapResultSetToSystemLog(rs);
                        logs.add(log);
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting system logs by user ID with limit", e);
        }

        return logs;
    }

    /**
     * Get system logs by action
     */
    public List<SystemLog> getSystemLogsByAction(String action) {
        List<SystemLog> logs = new ArrayList<>();
        String query = "SELECT * FROM SystemLog WHERE Action = ? ORDER BY Timestamp DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn != null) {
                stmt.setString(1, action);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        SystemLog log = mapResultSetToSystemLog(rs);
                        logs.add(log);
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting system logs by action", e);
        }

        return logs;
    }

    /**
     * Get system logs by object type
     */
    public List<SystemLog> getSystemLogsByObjectType(String objectType) {
        List<SystemLog> logs = new ArrayList<>();
        String query = "SELECT * FROM SystemLog WHERE ObjectType = ? ORDER BY Timestamp DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn != null) {
                stmt.setString(1, objectType);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        SystemLog log = mapResultSetToSystemLog(rs);
                        logs.add(log);
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting system logs by object type", e);
        }

        return logs;
    }

    /**
     * Get all system logs with user information
     */
    public List<SystemLog> getAllSystemLogsWithUserInfo() {
        List<SystemLog> logs = new ArrayList<>();
        String query = "SELECT sl.*, e.FullName as UserName "
                  + "FROM SystemLog sl "
                  + "LEFT JOIN SystemUser su ON sl.UserID = su.UserID "
                  + "LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID "
                  + "ORDER BY sl.Timestamp DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {

            if (conn != null) {
                while (rs.next()) {
                    SystemLog log = mapResultSetToSystemLog(rs);
                    logs.add(log);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all system logs with user info", e);
        }

        return logs;
    }

    /**
     * Get system logs by date range
     */
    public List<SystemLog> getSystemLogsByDateRange(Timestamp startDate, Timestamp endDate) {
        List<SystemLog> logs = new ArrayList<>();
        String query = "SELECT * FROM SystemLog WHERE Timestamp BETWEEN ? AND ? ORDER BY Timestamp DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn != null) {
                stmt.setTimestamp(1, startDate);
                stmt.setTimestamp(2, endDate);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        SystemLog log = mapResultSetToSystemLog(rs);
                        logs.add(log);
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting system logs by date range", e);
        }

        return logs;
    }

    /**
     * Get system logs by user ID and action
     */
    public List<SystemLog> getSystemLogsByUserIDAndAction(int userID, String action) {
        List<SystemLog> logs = new ArrayList<>();
        String query = "SELECT * FROM SystemLog WHERE UserID = ? AND Action = ? ORDER BY Timestamp DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn != null) {
                stmt.setInt(1, userID);
                stmt.setString(2, action);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        SystemLog log = mapResultSetToSystemLog(rs);
                        logs.add(log);
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting system logs by user ID and action", e);
        }

        return logs;
    }

    /**
     * Get count of system logs by user ID
     */
    public int getSystemLogCountByUserID(int userID) {
        String query = "SELECT COUNT(*) as count FROM SystemLog WHERE UserID = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn != null) {
                stmt.setInt(1, userID);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("count");
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting system log count by user ID", e);
        }

        return 0;
    }

    /**
     * Get count of system logs by action
     */
    public int getSystemLogCountByAction(String action) {
        String query = "SELECT COUNT(*) as count FROM SystemLog WHERE Action = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn != null) {
                stmt.setString(1, action);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("count");
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting system log count by action", e);
        }

        return 0;
    }

    /**
     * Delete system logs older than specified date
     */
    public boolean deleteOldSystemLogs(Timestamp cutoffDate) {
        String query = "DELETE FROM SystemLog WHERE Timestamp < ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn != null) {
                stmt.setTimestamp(1, cutoffDate);
                int rowsAffected = stmt.executeUpdate();
                return rowsAffected >= 0;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting old system logs", e);
        }

        return false;
    }

    /**
     * Delete system logs by user ID
     */
    public boolean deleteSystemLogsByUserID(int userID) {
        String query = "DELETE FROM SystemLog WHERE UserID = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn != null) {
                stmt.setInt(1, userID);
                int rowsAffected = stmt.executeUpdate();
                return rowsAffected >= 0;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting system logs by user ID", e);
        }

        return false;
    }

    private SystemLog mapResultSetToSystemLog(ResultSet rs) throws SQLException {
        // ... (Giữ nguyên các thuộc tính cũ) ...
        SystemLog log = new SystemLog();
        log.setLogId(rs.getInt("LogID"));
        log.setUserId(rs.getInt("UserID"));
        log.setAction(rs.getString("Action"));
        log.setObjectType(rs.getString("ObjectType"));
        log.setOldValue(rs.getString("OldValue"));
        log.setNewValue(rs.getString("NewValue"));
        log.setTimestamp(rs.getTimestamp("Timestamp").toLocalDateTime());

        // THÊM THÔNG TIN USER TỪ JOIN
        String fullName = rs.getString("FullName");
        String username = rs.getString("Username");

        if (fullName != null && !fullName.trim().isEmpty()) {
            log.setUserName(fullName); // Giả sử SystemLog có field userName
        } else if (username != null && !username.trim().isEmpty()) {
            log.setUserName(username);
        } else {
            log.setUserName("N/A");
        }

        return log;
    }

    public int getTotalSystemLogCount(String searchQuery, String filterAction, String filterObjectType) {
        // Query cơ bản (SELECT COUNT(*))
        String query = "SELECT COUNT(sl.LogID) "
                  + "FROM SystemLog sl "
                  + "LEFT JOIN SystemUser su ON sl.UserID = su.UserID "
                  + "LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID ";

        // Thêm các điều kiện lọc/tìm kiếm
        StringBuilder whereClause = new StringBuilder();
        List<Object> params = new ArrayList<>();

        // 1. Điều kiện tìm kiếm (áp dụng cho UserName, Action, ObjectType, LogID)
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            whereClause.append("WHERE (e.FullName LIKE ? OR su.Username LIKE ? OR sl.Action LIKE ? OR sl.ObjectType LIKE ? OR sl.LogID = ?) ");
            String searchPattern = "%" + searchQuery.trim() + "%";
            params.add(searchPattern); // FullName
            params.add(searchPattern); // Username
            params.add(searchPattern); // Action
            params.add(searchPattern); // ObjectType

            // Xử lý LogID là số
            try {
                int logId = Integer.parseInt(searchQuery.trim());
                params.add(logId); // LogID
            } catch (NumberFormatException e) {
                // Nếu không phải số, LogID = ? vẫn được thêm vào câu truy vấn
                // nhưng với tham số là searchPattern, MySQL sẽ không tìm thấy, nên an toàn.
                params.add(-1); // Sử dụng giá trị không bao giờ tồn tại
            }
        }

        // 2. Điều kiện lọc theo Action
        if (filterAction != null && !filterAction.trim().isEmpty() && !filterAction.equalsIgnoreCase("all")) {
            if (whereClause.length() == 0) {
                whereClause.append("WHERE ");
            } else {
                whereClause.append("AND ");
            }
            whereClause.append("sl.Action = ? ");
            params.add(filterAction);
        }

        // 3. Điều kiện lọc theo ObjectType
        if (filterObjectType != null && !filterObjectType.trim().isEmpty() && !filterObjectType.equalsIgnoreCase("all")) {
            if (whereClause.length() == 0) {
                whereClause.append("WHERE ");
            } else {
                whereClause.append("AND ");
            }
            whereClause.append("sl.ObjectType = ? ");
            params.add(filterObjectType);
        }

        query += whereClause.toString();

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn != null) {
                for (int i = 0; i < params.size(); i++) {
                    stmt.setObject(i + 1, params.get(i));
                }

                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting total system log count", e);
        }
        return 0;
    }

    /**
     * Lấy danh sách SystemLog có phân trang, lọc, tìm kiếm và sắp xếp.
     */
    public List<SystemLog> getPagedSystemLogsWithUserInfo(int offset, int limit,
              String searchQuery, String filterAction, String filterObjectType,
              String sortBy, String sortOrder) {

        List<SystemLog> logList = new ArrayList<>();

        // Query cơ bản
        String query = "SELECT sl.*, su.Username, e.FullName "
                  + "FROM SystemLog sl "
                  + "LEFT JOIN SystemUser su ON sl.UserID = su.UserID "
                  + "LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID ";

        // Xây dựng điều kiện WHERE (Giống hệt hàm getTotalSystemLogCount)
        StringBuilder whereClause = new StringBuilder();
        List<Object> params = new ArrayList<>();

        // 1. Điều kiện tìm kiếm (UserName, Action, ObjectType, LogID)
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            whereClause.append("WHERE (e.FullName LIKE ? OR su.Username LIKE ? OR sl.Action LIKE ? OR sl.ObjectType LIKE ? OR sl.LogID = ?) ");
            String searchPattern = "%" + searchQuery.trim() + "%";
            params.add(searchPattern); // FullName
            params.add(searchPattern); // Username
            params.add(searchPattern); // Action
            params.add(searchPattern); // ObjectType

            try {
                int logId = Integer.parseInt(searchQuery.trim());
                params.add(logId); // LogID
            } catch (NumberFormatException e) {
                params.add(-1);
            }
        }

        // 2. Điều kiện lọc theo Action
        if (filterAction != null && !filterAction.trim().isEmpty() && !filterAction.equalsIgnoreCase("all")) {
            if (whereClause.length() == 0) {
                whereClause.append("WHERE ");
            } else {
                whereClause.append("AND ");
            }
            whereClause.append("sl.Action = ? ");
            params.add(filterAction);
        }

        // 3. Điều kiện lọc theo ObjectType
        if (filterObjectType != null && !filterObjectType.trim().isEmpty() && !filterObjectType.equalsIgnoreCase("all")) {
            if (whereClause.length() == 0) {
                whereClause.append("WHERE ");
            } else {
                whereClause.append("AND ");
            }
            whereClause.append("sl.ObjectType = ? ");
            params.add(filterObjectType);
        }

        query += whereClause.toString();

        // Thêm ORDER BY (Sắp xếp)
        String orderByClause = " ORDER BY ";
        // Mapping cột cho sắp xếp (để tránh SQL Injection)
        if (sortBy == null || sortBy.trim().isEmpty()) {
            sortBy = "Timestamp"; // Mặc định
        }

        switch (sortBy.toLowerCase()) {
            case "logid":
                orderByClause += "sl.LogID ";
                break;
            case "username":
                orderByClause += "e.FullName, su.Username "; // Sắp xếp theo tên người dùng
                break;
            case "action":
                orderByClause += "sl.Action ";
                break;
            case "objecttype":
                orderByClause += "sl.ObjectType ";
                break;
            case "timestamp":
            default:
                orderByClause += "sl.Timestamp ";
                break;
        }

        // Mapping thứ tự sắp xếp (ASC/DESC)
        if (sortOrder == null || sortOrder.trim().isEmpty() || (!sortOrder.equalsIgnoreCase("ASC") && !sortOrder.equalsIgnoreCase("DESC"))) {
            sortOrder = "DESC"; // Mặc định
        }
        orderByClause += sortOrder;

        query += orderByClause;

        // Thêm LIMIT và OFFSET (Phân trang)
        query += " LIMIT ? OFFSET ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            if (conn != null) {
                int paramIndex = 1;
                // Bind các tham số cho WHERE clause
                for (Object param : params) {
                    stmt.setObject(paramIndex++, param);
                }

                // Bind các tham số cho LIMIT và OFFSET
                stmt.setInt(paramIndex++, limit);
                stmt.setInt(paramIndex++, offset);

                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        logList.add(mapResultSetToSystemLog(rs));
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting paged system logs with user info", e);
        }

        return logList;
    }

    /**
     * Map ResultSet to SystemLog object (Cần thêm FullName/Username vào
     * SystemLog object)
     */
    // Phương thức này có thể được dùng để lấy danh sách các Action/ObjectType duy nhất cho Filter
    public List<String> getAllDistinctActions() {
        return getDistinctValues("Action");
    }

    public List<String> getAllDistinctObjectTypes() {
        return getDistinctValues("ObjectType");
    }

    private List<String> getDistinctValues(String columnName) {
        List<String> values = new ArrayList<>();
        String query = "SELECT DISTINCT " + columnName + " FROM SystemLog WHERE " + columnName + " IS NOT NULL ORDER BY " + columnName;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                values.add(rs.getString(1));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error fetching distinct values for " + columnName, e);
        }
        return values;
    }
}

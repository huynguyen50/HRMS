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
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
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
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
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
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
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
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
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
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
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
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
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
        String query = "SELECT sl.*, e.FullName as UserName " +
                      "FROM SystemLog sl " +
                      "LEFT JOIN SystemUser su ON sl.UserID = su.UserID " +
                      "LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID " +
                      "ORDER BY sl.Timestamp DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
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
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
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
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
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
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
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
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
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
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
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
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
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
    
    /**
     * Map ResultSet to SystemLog object
     */
    private SystemLog mapResultSetToSystemLog(ResultSet rs) throws SQLException {
        SystemLog log = new SystemLog();
        log.setLogId(rs.getInt("LogID"));
        log.setUserId(rs.getInt("UserID"));
        log.setAction(rs.getString("Action"));
        log.setObjectType(rs.getString("ObjectType"));
        log.setOldValue(rs.getString("OldValue"));
        log.setNewValue(rs.getString("NewValue"));
        log.setTimestamp(rs.getTimestamp("Timestamp").toLocalDateTime());
        return log;
    }
}

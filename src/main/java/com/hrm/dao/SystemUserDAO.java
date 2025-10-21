package com.hrm.dao;

import com.hrm.model.entity.SystemUser;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SystemUserDAO {
    
    /**
     * Lấy tất cả system users
     */
    public List<SystemUser> getAll() {
        List<SystemUser> list = new ArrayList<>();
        String sql = """
            SELECT su.*, r.RoleName, e.FullName 
            FROM SystemUser su 
            LEFT JOIN Role r ON su.RoleID = r.RoleID
            LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID
            ORDER BY su.Username
        """;

        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToSystemUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Lấy system user theo ID
     */
    public SystemUser getById(int userId) {
        String sql = """
            SELECT su.*, r.RoleName, e.FullName 
            FROM SystemUser su 
            LEFT JOIN Role r ON su.RoleID = r.RoleID
            LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID
            WHERE su.UserID = ?
        """;

        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToSystemUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Lấy system user theo username
     */
    public SystemUser getByUsername(String username) {
        String sql = """
            SELECT su.*, r.RoleName, e.FullName 
            FROM SystemUser su 
            LEFT JOIN Role r ON su.RoleID = r.RoleID
            LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID
            WHERE su.Username = ?
        """;

        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToSystemUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Cập nhật last login
     */
    public boolean updateLastLogin(int userId) {
        String sql = "UPDATE SystemUser SET LastLogin = CURRENT_TIMESTAMP WHERE UserID = ?";
        
        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Tạo system user mới
     */
    public boolean create(SystemUser user) {
        String sql = """
            INSERT INTO SystemUser (Username, Password, RoleID, EmployeeID, IsActive)
            VALUES (?, ?, ?, ?, ?)
        """;
        
        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setInt(3, user.getRoleId());
            ps.setInt(4, user.getEmployeeId());
            ps.setBoolean(5, user.isActive());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Map ResultSet to SystemUser object
     */
    private SystemUser mapResultSetToSystemUser(ResultSet rs) throws SQLException {
        SystemUser user = new SystemUser();
        user.setUserId(rs.getInt("UserID"));
        user.setUsername(rs.getString("Username"));
        user.setPassword(rs.getString("Password"));
        user.setRoleId(rs.getInt("RoleID"));
        
        if (rs.getInt("EmployeeID") != 0) {
            user.setEmployeeId(rs.getInt("EmployeeID"));
        }
        
        user.setActive(rs.getBoolean("IsActive"));
        
        Timestamp lastLogin = rs.getTimestamp("LastLogin");
        if (lastLogin != null) {
            user.setLastLogin(lastLogin.toLocalDateTime());
        }
        
        Timestamp createdDate = rs.getTimestamp("CreatedDate");
        if (createdDate != null) {
            user.setCreatedDate(createdDate.toLocalDateTime());
        }
        
        return user;
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.hrm.dao;

import com.hrm.model.entity.SystemUser;
import com.hrm.model.entity.Role;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Hask
 */
public class SystemUserDAO {

    // Lấy tất cả SystemUser
    public List<SystemUser> getAll() {
        List<SystemUser> list = new ArrayList<>();
        String sql = """
            SELECT su.*, r.RoleName 
            FROM SystemUser su 
            LEFT JOIN Role r ON su.RoleID = r.RoleID
            ORDER BY su.UserID
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                SystemUser user = new SystemUser();
                user.setUserId(rs.getInt("UserID"));
                user.setUsername(rs.getString("Username"));
                user.setPassword(rs.getString("Password"));
                user.setRoleId(rs.getInt("RoleID"));
                user.setLastLogin(rs.getTimestamp("LastLogin") != null ? 
                    rs.getTimestamp("LastLogin").toLocalDateTime() : null);
                user.setIsActive(rs.getBoolean("IsActive"));
                user.setCreatedDate(rs.getTimestamp("CreatedDate") != null ? 
                    rs.getTimestamp("CreatedDate").toLocalDateTime() : null);
                user.setEmployeeId(rs.getObject("EmployeeID", Integer.class));
                
                // Set Role information
                Role role = new Role();
                role.setRoleId(rs.getInt("RoleID"));
                role.setRoleName(rs.getString("RoleName"));
                user.setRole(role);
                
                list.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy SystemUser theo ID
    public SystemUser getById(int userId) {
        String sql = """
            SELECT su.*, r.RoleName 
            FROM SystemUser su 
            LEFT JOIN Role r ON su.RoleID = r.RoleID
            WHERE su.UserID = ?
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SystemUser user = new SystemUser();
                    user.setUserId(rs.getInt("UserID"));
                    user.setUsername(rs.getString("Username"));
                    user.setPassword(rs.getString("Password"));
                    user.setRoleId(rs.getInt("RoleID"));
                    user.setLastLogin(rs.getTimestamp("LastLogin") != null ? 
                        rs.getTimestamp("LastLogin").toLocalDateTime() : null);
                    user.setIsActive(rs.getBoolean("IsActive"));
                    user.setCreatedDate(rs.getTimestamp("CreatedDate") != null ? 
                        rs.getTimestamp("CreatedDate").toLocalDateTime() : null);
                    user.setEmployeeId(rs.getObject("EmployeeID", Integer.class));
                    
                    // Set Role information
                    Role role = new Role();
                    role.setRoleId(rs.getInt("RoleID"));
                    role.setRoleName(rs.getString("RoleName"));
                    user.setRole(role);
                    
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy SystemUser theo username
    public SystemUser getByUsername(String username) {
        String sql = """
            SELECT su.*, r.RoleName 
            FROM SystemUser su 
            LEFT JOIN Role r ON su.RoleID = r.RoleID
            WHERE su.Username = ?
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SystemUser user = new SystemUser();
                    user.setUserId(rs.getInt("UserID"));
                    user.setUsername(rs.getString("Username"));
                    user.setPassword(rs.getString("Password"));
                    user.setRoleId(rs.getInt("RoleID"));
                    user.setLastLogin(rs.getTimestamp("LastLogin") != null ? 
                        rs.getTimestamp("LastLogin").toLocalDateTime() : null);
                    user.setIsActive(rs.getBoolean("IsActive"));
                    user.setCreatedDate(rs.getTimestamp("CreatedDate") != null ? 
                        rs.getTimestamp("CreatedDate").toLocalDateTime() : null);
                    user.setEmployeeId(rs.getObject("EmployeeID", Integer.class));
                    
                    // Set Role information
                    Role role = new Role();
                    role.setRoleId(rs.getInt("RoleID"));
                    role.setRoleName(rs.getString("RoleName"));
                    user.setRole(role);
                    
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy SystemUser theo EmployeeID
    public SystemUser getByEmployeeId(int employeeId) {
        String sql = """
            SELECT su.*, r.RoleName 
            FROM SystemUser su 
            LEFT JOIN Role r ON su.RoleID = r.RoleID
            WHERE su.EmployeeID = ?
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SystemUser user = new SystemUser();
                    user.setUserId(rs.getInt("UserID"));
                    user.setUsername(rs.getString("Username"));
                    user.setPassword(rs.getString("Password"));
                    user.setRoleId(rs.getInt("RoleID"));
                    user.setLastLogin(rs.getTimestamp("LastLogin") != null ? 
                        rs.getTimestamp("LastLogin").toLocalDateTime() : null);
                    user.setIsActive(rs.getBoolean("IsActive"));
                    user.setCreatedDate(rs.getTimestamp("CreatedDate") != null ? 
                        rs.getTimestamp("CreatedDate").toLocalDateTime() : null);
                    user.setEmployeeId(rs.getObject("EmployeeID", Integer.class));
                    
                    // Set Role information
                    Role role = new Role();
                    role.setRoleId(rs.getInt("RoleID"));
                    role.setRoleName(rs.getString("RoleName"));
                    user.setRole(role);
                    
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm SystemUser mới
    public boolean insert(SystemUser user) {
        String sql = """
            INSERT INTO SystemUser (Username, Password, RoleID, IsActive, CreatedDate, EmployeeID)
            VALUES (?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setInt(3, user.getRoleId());
            ps.setBoolean(4, user.isIsActive());
            ps.setTimestamp(5, user.getCreatedDate() != null ? 
                Timestamp.valueOf(user.getCreatedDate()) : Timestamp.valueOf(LocalDateTime.now()));
            ps.setObject(6, user.getEmployeeId(), Types.INTEGER);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật SystemUser
    public boolean update(SystemUser user) {
        String sql = """
            UPDATE SystemUser SET Username=?, Password=?, RoleID=?, IsActive=?, 
                                LastLogin=?, EmployeeID=? 
            WHERE UserID=?
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setInt(3, user.getRoleId());
            ps.setBoolean(4, user.isIsActive());
            ps.setTimestamp(5, user.getLastLogin() != null ? 
                Timestamp.valueOf(user.getLastLogin()) : null);
            ps.setObject(6, user.getEmployeeId(), Types.INTEGER);
            ps.setInt(7, user.getUserId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa SystemUser
    public boolean delete(int userId) {
        String sql = "DELETE FROM SystemUser WHERE UserID=?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật password
    public boolean changePassword(String username, String newPassword) {
        String sql = "UPDATE SystemUser SET Password=? WHERE Username=?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, newPassword);
            ps.setString(2, username);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật last login
    public boolean updateLastLogin(int userId, LocalDateTime lastLogin) {
        String sql = "UPDATE SystemUser SET LastLogin=? WHERE UserID=?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setTimestamp(1, Timestamp.valueOf(lastLogin));
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật trạng thái active
    public boolean updateActiveStatus(int userId, boolean isActive) {
        String sql = "UPDATE SystemUser SET IsActive=? WHERE UserID=?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setBoolean(1, isActive);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra username có tồn tại không
    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM SystemUser WHERE Username=?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đếm tổng số SystemUser
    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM SystemUser";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}

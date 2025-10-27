package com.hrm.dao;

import com.hrm.model.entity.Role;
import com.hrm.model.entity.SystemUser;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Hask
 */
public class SystemUserDAO {
    
    
    public List<SystemUser> getAllUsers(int page, int pageSize) throws SQLException {
        List<SystemUser> users = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        String sql = "SELECT su.UserID, su.Username, su.RoleID, su.LastLogin, su.IsActive, " +
                     "su.CreatedDate, su.EmployeeID, r.RoleName, e.FullName, d.DeptName " +
                     "FROM SystemUser su " +
                     "LEFT JOIN Role r ON su.RoleID = r.RoleID " +
                     "LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID " +
                     "LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID " +
                     "ORDER BY su.CreatedDate DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, pageSize);
            stmt.setInt(2, offset);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                SystemUser user = mapResultSetToUser(rs);
                users.add(user);
            }
        }
        return users;
    }

    public List<SystemUser> getUsersWithFilters(int page, int pageSize, Integer roleId, 
                                                 Integer status, Integer departmentId, 
                                                 String username) throws SQLException {
        List<SystemUser> users = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        StringBuilder sql = new StringBuilder(
            "SELECT su.UserID, su.Username, su.RoleID, su.LastLogin, su.IsActive, " +
            "su.CreatedDate, su.EmployeeID, r.RoleName, e.FullName, d.DeptName " +
            "FROM SystemUser su " +
            "LEFT JOIN Role r ON su.RoleID = r.RoleID " +
            "LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID " +
            "LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID " +
            "WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        
        if (roleId != null) {
            sql.append(" AND su.RoleID = ?");
            params.add(roleId);
        }
        if (status != null) {
            sql.append(" AND su.IsActive = ?");
            params.add(status == 1);
        }
        if (departmentId != null) {
            sql.append(" AND d.DepartmentID = ?");
            params.add(departmentId);
        }
        if (username != null && !username.isEmpty()) {
            sql.append(" AND su.Username LIKE ?");
            params.add("%" + username + "%");
        }
        
        sql.append(" ORDER BY su.CreatedDate DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(offset);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                SystemUser user = mapResultSetToUser(rs);
                users.add(user);
            }
        }
        return users;
    }

    public int getTotalUserCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM SystemUser";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getTotalUserCountWithFilters(Integer roleId, Integer status, 
                                            Integer departmentId, String username) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM SystemUser su " +
            "LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID " +
            "LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID " +
            "WHERE 1=1");
        
        List<Object> params = new ArrayList<>();
        
        if (roleId != null) {
            sql.append(" AND su.RoleID = ?");
            params.add(roleId);
        }
        if (status != null) {
            sql.append(" AND su.IsActive = ?");
            params.add(status == 1);
        }
        if (departmentId != null) {
            sql.append(" AND d.DepartmentID = ?");
            params.add(departmentId);
        }
        if (username != null && !username.isEmpty()) {
            sql.append(" AND su.Username LIKE ?");
            params.add("%" + username + "%");
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public SystemUser getUserById(int userId) throws SQLException {
        String sql = "SELECT su.UserID, su.Username, su.RoleID, su.LastLogin, su.IsActive, " +
                     "su.CreatedDate, su.EmployeeID, r.RoleName, e.FullName, d.DeptName " +
                     "FROM SystemUser su " +
                     "LEFT JOIN Role r ON su.RoleID = r.RoleID " +
                     "LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID " +
                     "LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID " +
                     "WHERE su.UserID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        }
        return null;
    }

    public boolean createUser(SystemUser user) throws SQLException {
        String sql = "INSERT INTO SystemUser (Username, Password, RoleID, EmployeeID, IsActive, CreatedDate) " +
                     "VALUES (?, ?, ?, ?, ?, NOW())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setInt(3, user.getRoleId());
            stmt.setObject(4, user.getEmployeeId());
            stmt.setBoolean(5, user.isIsActive());
            
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateUser(SystemUser user) throws SQLException {
        String sql = "UPDATE SystemUser SET Username = ?, RoleID = ?, EmployeeID = ?, IsActive = ? " +
                     "WHERE UserID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setInt(2, user.getRoleId());
            stmt.setObject(3, user.getEmployeeId());
            stmt.setBoolean(4, user.isIsActive());
            stmt.setInt(5, user.getUserId());
            
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updatePassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE SystemUser SET Password = ? WHERE UserID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);
            
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean toggleUserStatus(int userId) throws SQLException {
        String sql = "UPDATE SystemUser SET IsActive = !IsActive WHERE UserID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM SystemUser WHERE UserID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM SystemUser WHERE Username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    private SystemUser mapResultSetToUser(ResultSet rs) throws SQLException {
        SystemUser user = new SystemUser();
        user.setUserId(rs.getInt("UserID"));
        user.setUsername(rs.getString("Username"));
        user.setRoleId(rs.getInt("RoleID"));
        user.setLastLogin(rs.getTimestamp("LastLogin") != null ? 
                         rs.getTimestamp("LastLogin").toLocalDateTime() : null);
        user.setIsActive(rs.getBoolean("IsActive"));
        user.setCreatedDate(rs.getTimestamp("CreatedDate") != null ? 
                           rs.getTimestamp("CreatedDate").toLocalDateTime() : null);
        user.setEmployeeId(rs.getInt("EmployeeID") > 0 ? rs.getInt("EmployeeID") : null);
        
        Role role = new Role();
        role.setRoleId(rs.getInt("RoleID"));
        role.setRoleName(rs.getString("RoleName"));
        user.setRole(role);
        
        return user;
    }

    public int getTotalSystemUser() {
        String sql = "SELECT COUNT(*) as total FROM SystemUser";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}

package com.hrm.dao;

import com.hrm.model.entity.Role;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO {
    
    // Get roles with pagination and search
    public List<Role> getRoles(int page, int pageSize, String searchKeyword) throws SQLException {
        List<Role> roles = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        StringBuilder sql = new StringBuilder("SELECT RoleID, RoleName FROM Role WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND RoleName LIKE ?");
            params.add("%" + searchKeyword.trim() + "%");
        }
        
        sql.append(" ORDER BY RoleID LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(offset);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("RoleID"));
                role.setRoleName(rs.getString("RoleName"));
                roles.add(role);
            }
        }
        return roles;
    }
    
    // Get total count for pagination
    public int getTotalRoleCount(String searchKeyword) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Role WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND RoleName LIKE ?");
            params.add("%" + searchKeyword.trim() + "%");
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

    public List<Role> getAllRoles() {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT RoleID, RoleName FROM Role";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("RoleID"));
                role.setRoleName(rs.getString("RoleName"));
                roles.add(role);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return roles;
    }

    public Role getRoleById(int roleId) throws SQLException {
        String sql = "SELECT RoleID, RoleName FROM Role WHERE RoleID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con != null ? con.prepareStatement(sql) : null) {
            
            if (ps == null) {
                return null;
            }
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Role role = new Role();
                    role.setRoleId(rs.getInt("RoleID"));
                    role.setRoleName(rs.getString("RoleName"));
                    return role;
                }
            }
        }
        return null;
    }
    
    public boolean createRole(Role role) throws SQLException {
        String sql = "INSERT INTO Role (RoleName) VALUES (?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, role.getRoleName());
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean updateRole(Role role) throws SQLException {
        String sql = "UPDATE Role SET RoleName = ? WHERE RoleID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, role.getRoleName());
            stmt.setInt(2, role.getRoleId());
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean deleteRole(int roleId) throws SQLException {
        // First check if role is in use
        if (isRoleInUse(roleId)) {
            return false;
        }
        
        String sql = "DELETE FROM Role WHERE RoleID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roleId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    private boolean isRoleInUse(int roleId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM SystemUser WHERE RoleID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roleId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    /**
     * Normalize role name from DB to internal groups used for authorization.
     * Admin -> admin HR Manager/HR Staff -> hr Dept Manager/Employee ->
     * employee Others -> guest
     */
    public String normalizeRoleName(String dbRoleName) {
        if (dbRoleName == null) {
            return "guest";
        }
        String name = dbRoleName.trim().toLowerCase();

        if (name.contains("admin")) {
            return "admin";
        }
        if (name.contains("hr")) {
            return "hr";
        }
        if (name.contains("employee") || name.contains("manager")) {
            return "employee";
        }
        return "guest";
    }
}

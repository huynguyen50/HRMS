/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.hrm.dao;

import com.hrm.model.entity.Role;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Hask
 */
public class RoleDAO {
    public Role getRoleById(int roleId) throws SQLException {
        String sql = "SELECT RoleID, RoleName FROM Role WHERE RoleID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con != null ? con.prepareStatement(sql) : null) {
            if (ps == null) return null;
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

    /**
     * Normalize role name from DB to internal groups used for authorization.
     * Admin -> admin
     * HR Manager/HR Staff -> hr
     * Dept Manager/Employee -> employee
     * Others -> guest
     */
    public String normalizeRoleName(String dbRoleName) {
        if (dbRoleName == null) return "guest";
        String name = dbRoleName.trim().toLowerCase();

        if (name.contains("admin")) return "admin";
        if (name.contains("hr")) return "hr";
        if (name.contains("employee") || name.contains("manager")) return "employee";
        return "guest";
    }
}

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

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

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

    public int getTotalRoleCount(String searchKeyword) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(RoleID) FROM Role WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (RoleName LIKE ? OR RoleID = ?)");
            params.add("%" + searchKeyword.trim() + "%");

            // Thử parse RoleID là số để tìm kiếm chính xác ID
            try {
                int roleId = Integer.parseInt(searchKeyword.trim());
                params.add(roleId);
            } catch (NumberFormatException e) {
                // Nếu không phải số, đặt giá trị không tồn tại để chỉ tìm kiếm theo tên
                params.add(-1);
            }
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

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

    /**
     * Lấy danh sách Role có phân trang, tìm kiếm và sắp xếp.
     */
    public List<Role> getPagedRoles(int offset, int limit,
              String searchKeyword, String sortBy, String sortOrder) throws SQLException {

        List<Role> roles = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT RoleID, RoleName FROM Role WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // 1. Thêm điều kiện tìm kiếm
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (RoleName LIKE ? OR RoleID = ?)");
            params.add("%" + searchKeyword.trim() + "%");

            try {
                int roleId = Integer.parseInt(searchKeyword.trim());
                params.add(roleId);
            } catch (NumberFormatException e) {
                params.add(-1);
            }
        }

        // 2. Thêm ORDER BY (Sắp xếp)
        String orderByClause = " ORDER BY ";

        // Mapping cột cho sắp xếp (Mặc định RoleID)
        if (sortBy == null || sortBy.trim().isEmpty()) {
            sortBy = "RoleID";
        }

        switch (sortBy.toLowerCase()) {
            case "rolename":
                orderByClause += "RoleName ";
                break;
            case "roleid":
            default:
                orderByClause += "RoleID ";
                break;
        }

        // Mapping thứ tự sắp xếp (Mặc định ASC)
        if (sortOrder == null || sortOrder.trim().isEmpty() || (!sortOrder.equalsIgnoreCase("ASC") && !sortOrder.equalsIgnoreCase("DESC"))) {
            sortOrder = "ASC";
        }
        orderByClause += sortOrder;

        sql.append(orderByClause);

        // 3. Thêm LIMIT và OFFSET (Phân trang)
        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            // Bind các tham số cho WHERE clause
            for (Object param : params) {
                stmt.setObject(paramIndex++, param);
            }

            // Bind các tham số cho LIMIT và OFFSET
            stmt.setInt(paramIndex++, limit);
            stmt.setInt(paramIndex++, offset);

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

    public List<Role> getAllRoles() {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT RoleID, RoleName FROM Role";

        try (Connection conn = DBConnection.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {

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
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con != null ? con.prepareStatement(sql) : null) {

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
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, role.getRoleName());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateRole(Role role) throws SQLException {
        String sql = "UPDATE Role SET RoleName = ? WHERE RoleID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

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
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, roleId);
            return stmt.executeUpdate() > 0;
        }
    }

    private boolean isRoleInUse(int roleId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM SystemUser WHERE RoleID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

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

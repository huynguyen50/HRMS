/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.hrm.dao;

import com.hrm.model.entity.Department;
import com.hrm.model.entity.Employee;
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

    public List<SystemUser> getAllUsers(int page, int pageSize) throws SQLException {
        return getAllUsers(page, pageSize, "CreatedDate", "DESC");
    }

    public List<SystemUser> getAllUsers(int page, int pageSize, String sortBy, String sortOrder) throws SQLException {
        List<SystemUser> users = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        // Validate sort field to prevent SQL injection
        String validSortField = validateSortField(sortBy);
        String validSortOrder = "DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC";

        String sql = "SELECT su.UserID, su.Username, su.RoleID, su.LastLogin, su.IsActive, "
                  + "su.CreatedDate, su.EmployeeID, r.RoleName, e.FullName, d.DeptName "
                  + "FROM SystemUser su "
                  + "LEFT JOIN Role r ON su.RoleID = r.RoleID "
                  + "LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID "
                  + "LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID "
                  + "ORDER BY " + validSortField + " " + validSortOrder + " LIMIT ? OFFSET ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
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

    // Lấy SystemUser theo ID
    public SystemUser getById(int userId) {
        String sql = """
            SELECT su.*, r.RoleName 
            FROM SystemUser su 
            LEFT JOIN Role r ON su.RoleID = r.RoleID
            WHERE su.UserID = ?
        """;

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SystemUser user = new SystemUser();
                    user.setUserId(rs.getInt("UserID"));
                    user.setUsername(rs.getString("Username"));
                    user.setPassword(rs.getString("Password"));
                    user.setRoleId(rs.getInt("RoleID"));
                    user.setLastLogin(rs.getTimestamp("LastLogin") != null
                              ? rs.getTimestamp("LastLogin").toLocalDateTime() : null);
                    user.setIsActive(rs.getBoolean("IsActive"));
                    user.setCreatedDate(rs.getTimestamp("CreatedDate") != null
                              ? rs.getTimestamp("CreatedDate").toLocalDateTime() : null);
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

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SystemUser user = new SystemUser();
                    user.setUserId(rs.getInt("UserID"));
                    user.setUsername(rs.getString("Username"));
                    user.setPassword(rs.getString("Password"));
                    user.setRoleId(rs.getInt("RoleID"));
                    user.setLastLogin(rs.getTimestamp("LastLogin") != null
                              ? rs.getTimestamp("LastLogin").toLocalDateTime() : null);
                    user.setIsActive(rs.getBoolean("IsActive"));
                    user.setCreatedDate(rs.getTimestamp("CreatedDate") != null
                              ? rs.getTimestamp("CreatedDate").toLocalDateTime() : null);
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

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SystemUser user = new SystemUser();
                    user.setUserId(rs.getInt("UserID"));
                    user.setUsername(rs.getString("Username"));
                    user.setPassword(rs.getString("Password"));
                    user.setRoleId(rs.getInt("RoleID"));
                    user.setLastLogin(rs.getTimestamp("LastLogin") != null
                              ? rs.getTimestamp("LastLogin").toLocalDateTime() : null);
                    user.setIsActive(rs.getBoolean("IsActive"));
                    user.setCreatedDate(rs.getTimestamp("CreatedDate") != null
                              ? rs.getTimestamp("CreatedDate").toLocalDateTime() : null);
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

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setInt(3, user.getRoleId());
            ps.setBoolean(4, user.isIsActive());
            ps.setTimestamp(5, user.getCreatedDate() != null
                      ? Timestamp.valueOf(user.getCreatedDate()) : Timestamp.valueOf(LocalDateTime.now()));
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

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setInt(3, user.getRoleId());
            ps.setBoolean(4, user.isIsActive());
            ps.setTimestamp(5, user.getLastLogin() != null
                      ? Timestamp.valueOf(user.getLastLogin()) : null);
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

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

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

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

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

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

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

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

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

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

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

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<SystemUser> getUsersWithFilters(int page, int pageSize, Integer roleId,
              Integer status, Integer departmentId,
              String username) throws SQLException {
        return getUsersWithFilters(page, pageSize, roleId, status, departmentId, username, "CreatedDate", "DESC");
    }

    public List<SystemUser> getUsersWithFilters(int page, int pageSize, Integer roleId,
              Integer status, Integer departmentId,
              String username, String sortBy, String sortOrder) throws SQLException {
        List<SystemUser> users = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        // Validate sort field to prevent SQL injection
        String validSortField = validateSortField(sortBy);
        String validSortOrder = "DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC";

        StringBuilder sql = new StringBuilder(
                  "SELECT su.UserID, su.Username, su.RoleID, su.LastLogin, su.IsActive, "
                  + "su.CreatedDate, su.EmployeeID, r.RoleName, e.FullName, d.DeptName "
                  + "FROM SystemUser su "
                  + "LEFT JOIN Role r ON su.RoleID = r.RoleID "
                  + "LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID "
                  + "LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID "
                  + "WHERE 1=1"
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

        sql.append(" ORDER BY " + validSortField + " " + validSortOrder + " LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(offset);

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
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


    private String validateSortField(String sortBy) {
        switch (sortBy != null ? sortBy : "") {
            case "UserID":
                return "su.UserID";
            case "Username":
                return "su.Username";
            case "FullName":
                return "e.FullName";
            case "DeptName":
                return "d.DeptName";
            case "RoleName":
                return "r.RoleName";
            case "Status":
                return "su.IsActive";
            case "LastLogin":
                return "su.LastLogin";
            case "CreatedDate":
            default:
                return "su.CreatedDate";
        }
    }


    public int getTotalUserCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM SystemUser";
        try (Connection conn = DBConnection.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getTotalUserCountWithFilters(Integer roleId, Integer status,
              Integer departmentId, String username) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM SystemUser su "
                  + "LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID "
                  + "LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID "
                  + "WHERE 1=1");

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

    public SystemUser getUserById(int userId) throws SQLException {
        String sql = "SELECT su.UserID, su.Username, su.RoleID, su.LastLogin, su.IsActive, "
                  + "su.CreatedDate, su.EmployeeID, r.RoleName, e.FullName, d.DeptName "
                  + "FROM SystemUser su "
                  + "LEFT JOIN Role r ON su.RoleID = r.RoleID "
                  + "LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID "
                  + "LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID "
                  + "WHERE su.UserID = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        }
        return null;
    }

    public boolean createUser(SystemUser user) throws SQLException {
        String sql = "INSERT INTO SystemUser (Username, Password, RoleID, EmployeeID, IsActive, CreatedDate) "
                  + "VALUES (?, ?, ?, ?, ?, NOW())";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setInt(3, user.getRoleId());
            stmt.setObject(4, user.getEmployeeId());
            stmt.setBoolean(5, user.isIsActive());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateUser(SystemUser user) throws SQLException {
        String sql = "UPDATE SystemUser SET Username = ?, RoleID = ?, EmployeeID = ?, IsActive = ? "
                  + "WHERE UserID = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
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

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean toggleUserStatus(int userId) throws SQLException {
        String sql = "UPDATE SystemUser "
                  + "SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END "
                  + "WHERE UserID = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM SystemUser WHERE UserID = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM SystemUser WHERE Username = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        user.setLastLogin(rs.getTimestamp("LastLogin") != null
                  ? rs.getTimestamp("LastLogin").toLocalDateTime() : null);
        user.setIsActive(rs.getBoolean("IsActive"));
        user.setCreatedDate(rs.getTimestamp("CreatedDate") != null
                  ? rs.getTimestamp("CreatedDate").toLocalDateTime() : null);
        user.setEmployeeId(rs.getInt("EmployeeID") > 0 ? rs.getInt("EmployeeID") : null);

        Role role = new Role();
        role.setRoleId(rs.getInt("RoleID"));
        role.setRoleName(rs.getString("RoleName"));
        user.setRole(role);

        return user;
    }

    public int getTotalSystemUser() {
        String sql = "SELECT COUNT(*) as total FROM SystemUser";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean usernameExistsForOtherUser(String username, int currentUserId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM SystemUser WHERE Username = ? AND UserID <> ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setInt(2, currentUserId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

   private String buildFilterQuery(StringBuilder sql, List<Object> params, Integer roleId, Integer status, Integer departmentId, String username) {
        // Lưu ý: Nếu username/roleId/status/departmentId là null hoặc giá trị 'all' (ví dụ: -1), thì không thêm điều kiện
        
        if (roleId != null && roleId > 0) {
            sql.append(" AND su.RoleID = ?");
            params.add(roleId);
        }
        
        // Giả sử status: 1=Active, 0=Inactive. Cần đảm bảo status khác null và khác giá trị 'all' (ví dụ: -1)
        if (status != null && status != -1) { 
            sql.append(" AND su.IsActive = ?");
            params.add(status == 1); // Sử dụng boolean cho SQL
        }
        
        if (username != null && !username.trim().isEmpty()) {
            sql.append(" AND su.Username LIKE ?");
            params.add("%" + username.trim() + "%");
        }
        
        if (departmentId != null && departmentId > 0) {
            sql.append(" AND e.DepartmentID = ?"); 
            params.add(departmentId);
        }
        return sql.toString();
    }
    
    // PHƯƠNG THỨC MỚI: Ánh xạ ResultSet đầy đủ thông tin Employee và Department
    private SystemUser mapResultSetToSystemUserWithEmployeeInfo(ResultSet rs) throws SQLException {
        // Phương thức này cần được bạn định nghĩa trong file gốc
        // Đây là ví dụ dựa trên cấu trúc CSDL bạn gửi:
        SystemUser user = new SystemUser();
        // Ánh xạ SystemUser
        user.setUserId(rs.getInt("UserID"));
        user.setUsername(rs.getString("Username"));
        user.setLastLogin(rs.getTimestamp("LastLogin") != null 
                  ? rs.getTimestamp("LastLogin").toLocalDateTime() : null);
        user.setIsActive(rs.getBoolean("IsActive"));
        user.setCreatedDate(rs.getTimestamp("CreatedDate") != null
                  ? rs.getTimestamp("CreatedDate").toLocalDateTime() : null);
        
        Integer employeeId = rs.getInt("EmployeeID");
        if (rs.wasNull() || employeeId == 0) {
            user.setEmployeeId(null);
        } else {
            user.setEmployeeId(employeeId);
        }

        // Ánh xạ Role
        Role role = new Role();
        role.setRoleId(rs.getInt("RoleID"));
        role.setRoleName(rs.getString("RoleName"));
        user.setRole(role);
        
        // Ánh xạ Employee và Department (Nếu có EmployeeID)
        if (user.getEmployeeId() != null) {
            Employee employee = new Employee();
            employee.setEmployeeId(user.getEmployeeId());
            // Lấy FullName từ bảng Employee (e)
            employee.setFullName(rs.getString("FullName")); 
            
            Department department = new Department();
            // Lấy DeptName từ bảng Department (d)
            department.setDeptName(rs.getString("DeptName")); 
            
            employee.setDepartment(department); 
            user.setEmployee(employee);
        }
        return user;
    }


    // PHƯƠNG THỨC MỚI: Lấy tổng số người dùng có áp dụng bộ lọc (để tính TotalPages)
    public int getTotalFilteredUsers(Integer roleId, Integer status, Integer departmentId, String username) throws SQLException {
        int total = 0;
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT COUNT(su.UserID) ");
        sql.append("FROM SystemUser su ");
        // Phải JOIN để lọc theo Department và Employee
        sql.append("LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID "); 

        buildFilterQuery(sql, params, roleId, status, departmentId, username);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        }
        return total;
    }

    // SỬA ĐỔI PHƯƠNG THỨC getAllUsers: Thêm tham số lọc và phân trang
    public List<SystemUser> getFilteredUsers(int page, int pageSize, Integer roleId, Integer status, Integer departmentId, String username) throws SQLException {
        List<SystemUser> users = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        List<Object> params = new ArrayList<>();

        String baseSelect = "SELECT su.UserID, su.Username, su.RoleID, su.LastLogin, su.IsActive, "
                  + "su.CreatedDate, su.EmployeeID, r.RoleName, e.FullName, d.DeptName "
                  + "FROM SystemUser su "
                  + "LEFT JOIN Role r ON su.RoleID = r.RoleID "
                  + "LEFT JOIN Employee e ON su.EmployeeID = e.EmployeeID "
                  + "LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID ";
        
        StringBuilder sql = new StringBuilder(baseSelect);

        // Thêm mệnh đề WHERE từ hàm tiện ích
        buildFilterQuery(sql, params, roleId, status, departmentId, username);

        sql.append(" ORDER BY su.CreatedDate DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(offset);

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToSystemUserWithEmployeeInfo(rs)); 
                }
            }
        }
        return users;
    }
}

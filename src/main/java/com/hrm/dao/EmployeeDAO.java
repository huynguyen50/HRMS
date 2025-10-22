package com.hrm.dao;

import com.hrm.model.entity.Department;
import com.hrm.model.entity.Employee;
import com.hrm.model.entity.Role;
import com.hrm.model.entity.SystemUser;
import com.hrm.dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {

    public List<Employee> getAll() {
        List<Employee> list = new ArrayList<>();
        String sql = """
            SELECT e.*, d.DeptName, su.UserID, su.Username, su.LastLogin, r.RoleName
            FROM Employee e 
            LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID
            LEFT JOIN SystemUser su ON e.EmployeeID = su.EmployeeID
            LEFT JOIN Role r ON su.RoleID = r.RoleID
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Employee e = new Employee();
                e.setEmployeeId(rs.getInt("EmployeeID"));
                e.setFullName(rs.getString("FullName"));
                e.setGender(rs.getString("Gender"));
                e.setDob(rs.getDate("DOB") != null ? rs.getDate("DOB").toLocalDate() : null);
                e.setAddress(rs.getString("Address"));
                e.setPhone(rs.getString("Phone"));
                e.setEmail(rs.getString("Email"));
                e.setDepartmentId(rs.getInt("DepartmentID"));
                e.setDepartmentName(rs.getString("DeptName"));
                e.setPosition(rs.getString("Position"));
                e.setStatus(rs.getString("Status"));
                e.setEmploymentPeriod(rs.getString("EmploymentPeriod"));
                
                // Set SystemUser information if exists
                if (rs.getInt("UserID") != 0) {
                    SystemUser systemUser = new SystemUser();
                    systemUser.setUserId(rs.getInt("UserID"));
                    systemUser.setUsername(rs.getString("Username"));
                    
                    Timestamp lastLoginTimestamp = rs.getTimestamp("LastLogin");
                    if (lastLoginTimestamp != null) {
                        systemUser.setLastLogin(lastLoginTimestamp.toLocalDateTime());
                    }
                    
                    Role role = new Role();
                    role.setRoleName(rs.getString("RoleName"));
                    systemUser.setRole(role);
                    
                    e.setSystemUser(systemUser);
                }
              
                list.add(e);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    

    public Employee getById(int id) {
        String sql = "SELECT * FROM Employee WHERE EmployeeID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Employee e = new Employee();
                e.setEmployeeId(rs.getInt("EmployeeID"));
                e.setFullName(rs.getString("FullName"));
                e.setGender(rs.getString("Gender"));
                e.setDob(rs.getDate("DOB") != null ? rs.getDate("DOB").toLocalDate() : null);
                e.setAddress(rs.getString("Address"));
                e.setPhone(rs.getString("Phone"));
                e.setEmail(rs.getString("Email"));
                e.setDepartmentId(rs.getInt("DepartmentID"));
                e.setPosition(rs.getString("Position"));
                e.setHireDate(rs.getDate("HireDate") != null ? rs.getDate("HireDate").toLocalDate() : null);
                e.setSalary(rs.getDouble("Salary"));
                e.setActive(rs.getBoolean("Active"));
                return e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(Employee e) {
        String sql = """
            INSERT INTO Employee (FullName, Gender, DOB, Address, Phone, Email, 
                                  DepartmentID, Position, HireDate, Salary, Active)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, e.getFullName());
            ps.setString(2, e.getGender());
            ps.setDate(3, e.getDob() != null ? Date.valueOf(e.getDob()) : null);
            ps.setString(4, e.getAddress());
            ps.setString(5, e.getPhone());
            ps.setString(6, e.getEmail());
            ps.setObject(7, e.getDepartmentId(), Types.INTEGER);
            ps.setString(8, e.getPosition());
            ps.setDate(9, e.getHireDate() != null ? Date.valueOf(e.getHireDate()) : null);
            ps.setDouble(10, e.getSalary());
            ps.setBoolean(11, e.isActive());

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean update(Employee e) {
        String sql = """
            UPDATE Employee SET FullName=?, Gender=?, DOB=?, Address=?, Phone=?, Email=?, 
                                DepartmentID=?, Position=?, HireDate=?, Salary=?, Active=? 
            WHERE EmployeeID=?
        """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, e.getFullName());
            ps.setString(2, e.getGender());
            ps.setDate(3, e.getDob() != null ? Date.valueOf(e.getDob()) : null);
            ps.setString(4, e.getAddress());
            ps.setString(5, e.getPhone());
            ps.setString(6, e.getEmail());
            ps.setObject(7, e.getDepartmentId(), Types.INTEGER);
            ps.setString(8, e.getPosition());
            ps.setDate(9, e.getHireDate() != null ? Date.valueOf(e.getHireDate()) : null);
            ps.setDouble(10, e.getSalary());
            ps.setBoolean(11, e.isActive());
            ps.setInt(12, e.getEmployeeId());

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Employee WHERE EmployeeID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateEmployeeInfo(Employee e) {
        String sql = """
            UPDATE Employee SET FullName=?, Gender=?, DOB=?, Address=?, Phone=?, Email=?, 
                                DepartmentID=?, Position=?, EmploymentPeriod=?, Status=?
            WHERE EmployeeID=?
        """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, e.getFullName());
            ps.setString(2, e.getGender());
            ps.setDate(3, e.getDob() != null ? Date.valueOf(e.getDob()) : null);
            ps.setString(4, e.getAddress());
            ps.setString(5, e.getPhone());
            ps.setString(6, e.getEmail());
            ps.setObject(7, e.getDepartmentId(), Types.INTEGER);
            ps.setString(8, e.getPosition());
            ps.setString(9, e.getEmploymentPeriod());
            ps.setString(10, e.getStatus());
            ps.setInt(11, e.getEmployeeId());

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean updateEmployeeStatus(int employeeId, String status) {
        String sql = "UPDATE Employee SET Status = ? WHERE EmployeeID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, employeeId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Employee getEmployeeBySystemUserId(int systemUserId) {
        String sql = "SELECT e.*, e.Status, e.EmploymentPeriod, d.DeptName, su.Username, su.LastLogin, r.RoleName " +
                     "FROM Employee e " +
                     "LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID " +
                     "JOIN SystemUser su ON e.EmployeeID = su.EmployeeID " +
                     "LEFT JOIN Role r ON su.RoleID = r.RoleID " +
                     "WHERE su.UserID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, systemUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    System.out.println("EmployeeDAO: Found record for systemUserId: " + systemUserId);
                    Employee employee = new Employee();
                    employee.setEmployeeId(rs.getInt("EmployeeID"));
                    employee.setFullName(rs.getString("FullName"));
                    employee.setGender(rs.getString("Gender"));
                    employee.setDob(rs.getDate("DOB") != null ? rs.getDate("DOB").toLocalDate() : null);
                    employee.setAddress(rs.getString("Address"));
                    employee.setPhone(rs.getString("Phone"));
                    employee.setEmail(rs.getString("Email"));
                    employee.setPosition(rs.getString("Position"));
                    employee.setHireDate(rs.getDate("HireDate") != null ? rs.getDate("HireDate").toLocalDate() : null);
                    employee.setSalary(rs.getDouble("Salary"));
                    employee.setActive(rs.getBoolean("Active"));
                    
                    // Assuming 'Status' and 'EmploymentPeriod' are columns in the Employee table
                    employee.setStatus(rs.getString("Status"));
                    employee.setEmploymentPeriod(rs.getString("EmploymentPeriod"));

                    // Populate Department
                    if (rs.getInt("DepartmentID") != 0) {
                        Department department = new Department();
                        department.setDepartmentId(rs.getInt("DepartmentID")); // Sửa lỗi gán sai ID
                        department.setDeptName(rs.getString("DeptName"));
                        employee.setDepartment(department);
                    }

                    // Populate SystemUser and Role
                    SystemUser systemUser = new SystemUser();
                    systemUser.setUsername(rs.getString("Username"));
                    Timestamp lastLoginTimestamp = rs.getTimestamp("LastLogin");
                    if (lastLoginTimestamp != null) {
                        systemUser.setLastLogin(lastLoginTimestamp.toLocalDateTime());
                    }
                    
                    Role role = new Role();
                    role.setRoleName(rs.getString("RoleName"));
                    systemUser.setRole(role);
                    
                    employee.setSystemUser(systemUser);

                    return employee;
                }
            }
        } catch (SQLException e) {
            System.err.println("EmployeeDAO: SQL Exception for systemUserId: " + systemUserId);
            e.printStackTrace();
        }
        System.out.println("EmployeeDAO: No employee found for systemUserId: " + systemUserId);
        return null;
    }

    public List<Employee> getPaged(int offset, int limit) {
        List<Employee> list = new ArrayList<>();
        String sql = """
        SELECT e.*, d.DeptName, COALESCE(c.BaseSalary, 0) as BaseSalary
        FROM Employee e
        LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID
        LEFT JOIN Contract c ON e.EmployeeID = c.EmployeeID AND c.ContractID = (
            SELECT ContractID FROM Contract
            WHERE EmployeeID = e.EmployeeID
            ORDER BY StartDate DESC
            LIMIT 1
        )
        ORDER BY e.EmployeeID
        LIMIT ?, ?
    """;

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Employee e = new Employee();
                    e.setEmployeeId(rs.getInt("EmployeeID"));
                    e.setFullName(rs.getString("FullName"));
                    e.setGender(rs.getString("Gender"));
                    e.setDob(rs.getDate("DOB") != null ? rs.getDate("DOB").toLocalDate() : null);
                    e.setAddress(rs.getString("Address"));
                    e.setPhone(rs.getString("Phone"));
                    e.setEmail(rs.getString("Email"));
                    e.setDepartmentId(rs.getInt("DepartmentID"));
                    e.setDepartmentName(rs.getString("DeptName"));
                    e.setPosition(rs.getString("Position"));
                    e.setEmploymentPeriod(rs.getString("EmploymentPeriod"));
                    e.setActive("Active".equalsIgnoreCase(rs.getString("Status")));
                    e.setSalary(rs.getDouble("BaseSalary"));
                    e.setStatus(rs.getString("Status"));
                    list.add(e);
                }
            }
        } catch (SQLException e) {
            System.err.println("[v0] Error in getPaged: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalEmployeesCount() {
        String sql = "SELECT COUNT(*) as total FROM Employee";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Employee> searchEmployeesPaged(String keyword, int offset, int limit) {
        List<Employee> list = new ArrayList<>();
        String sql = """
            SELECT e.*, d.DeptName, COALESCE(c.BaseSalary, 0) as BaseSalary
            FROM Employee e
            LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID
            LEFT JOIN Contract c ON e.EmployeeID = c.EmployeeID AND c.ContractID = (
                SELECT ContractID FROM Contract
                WHERE EmployeeID = e.EmployeeID
                ORDER BY StartDate DESC
                LIMIT 1
            )
            WHERE e.FullName LIKE ? OR e.Email LIKE ? OR e.Position LIKE ?
            ORDER BY e.EmployeeID
            LIMIT ?, ?
        """;

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setInt(4, offset);
            ps.setInt(5, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Employee e = new Employee();
                    e.setEmployeeId(rs.getInt("EmployeeID"));
                    e.setFullName(rs.getString("FullName"));
                    e.setGender(rs.getString("Gender"));
                    e.setDob(rs.getDate("DOB") != null ? rs.getDate("DOB").toLocalDate() : null);
                    e.setAddress(rs.getString("Address"));
                    e.setPhone(rs.getString("Phone"));
                    e.setEmail(rs.getString("Email"));
                    e.setDepartmentId(rs.getInt("DepartmentID"));
                    e.setDepartmentName(rs.getString("DeptName"));
                    e.setPosition(rs.getString("Position"));
                    e.setEmploymentPeriod(rs.getString("EmploymentPeriod"));
                    e.setActive("Active".equalsIgnoreCase(rs.getString("Status")));
                    e.setSalary(rs.getDouble("BaseSalary"));
                    e.setStatus(rs.getString("Status"));
                    list.add(e);
                }
            }
        } catch (SQLException e) {
            System.err.println("[v0] Error in searchEmployeesPaged: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public int searchEmployeesCount(String keyword) {
        String sql = "SELECT COUNT(*) as total FROM Employee WHERE FullName LIKE ? OR Email LIKE ? OR Position LIKE ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            System.err.println("[v0] Error in searchEmployeesCount: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }


    public int getTotalEmployees() {
        String sql = "SELECT COUNT(*) as total FROM Employee";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getActiveEmployees() {
        String sql = "SELECT COUNT(*) as total FROM Employee WHERE Active = 1";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Employee> getManagerList() {
        List<Employee> managers = new ArrayList<>();
        String sql = "SELECT DISTINCT e.EmployeeID, e.FullName, e.Email, e.DepartmentID "
                  + "FROM Employee e "
                  + "WHERE e.EmployeeID IN (SELECT DeptManagerID FROM Department WHERE DeptManagerID IS NOT NULL) "
                  + "ORDER BY e.FullName";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Employee emp = new Employee();
                emp.setEmployeeId(rs.getInt("EmployeeID"));
                emp.setFullName(rs.getString("FullName"));
                emp.setEmail(rs.getString("Email"));
                emp.setDepartmentId(rs.getInt("DepartmentID"));
                managers.add(emp);
            }
        } catch (SQLException e) {
            System.err.println("[v0] Error in getManagerList: " + e.getMessage());
            e.printStackTrace();
        }
        return managers;
    }

    public int getEmployeeCountByDepartment(int departmentId) {
        String sql = "SELECT COUNT(*) as count FROM Employee WHERE DepartmentID = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, departmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    public List<Employee> searchEmployees(String keyword) {
        List<Employee> list = new ArrayList<>();
        String sql = """
            SELECT e.*, d.DeptName, COALESCE(c.BaseSalary, 0) as BaseSalary
            FROM Employee e
            LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID
            LEFT JOIN Contract c ON e.EmployeeID = c.EmployeeID AND c.ContractID = (
                SELECT ContractID FROM Contract
                WHERE EmployeeID = e.EmployeeID
                ORDER BY StartDate DESC
                LIMIT 1
            )
            WHERE e.FullName LIKE ? OR e.Email LIKE ? OR e.Position LIKE ? OR d.DeptName LIKE ?
            ORDER BY e.EmployeeID
        """;

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Employee e = new Employee();
                    e.setEmployeeId(rs.getInt("EmployeeID"));
                    e.setFullName(rs.getString("FullName"));
                    e.setGender(rs.getString("Gender"));
                    e.setDob(rs.getDate("DOB") != null ? rs.getDate("DOB").toLocalDate() : null);
                    e.setAddress(rs.getString("Address"));
                    e.setPhone(rs.getString("Phone"));
                    e.setEmail(rs.getString("Email"));
                    e.setDepartmentId(rs.getInt("DepartmentID"));
                    e.setDepartmentName(rs.getString("DeptName"));
                    e.setPosition(rs.getString("Position"));
                    e.setEmploymentPeriod(rs.getString("EmploymentPeriod"));
                    e.setActive("Active".equalsIgnoreCase(rs.getString("Status")));
                    e.setSalary(rs.getDouble("BaseSalary"));
                    e.setStatus(rs.getString("Status"));
                    list.add(e);
                }
            }
        } catch (SQLException e) {
            System.err.println("[v0] Error in searchEmployees: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

}

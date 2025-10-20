package com.hrm.dao;

import com.hrm.model.entity.Department;
import com.hrm.dao.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Department entity
 * Handles all database operations for departments
 */
public class DepartmentDAO {

    public List<Department> getAll() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT * FROM Department ORDER BY DeptName";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Department dept = new Department(
                    rs.getInt("DepartmentID"),
                    rs.getString("DeptName"),
                    rs.getObject("DeptManagerID") != null ? rs.getInt("DeptManagerID") : null
                );
                list.add(dept);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Department> getPaged(int offset, int limit) {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT * FROM Department ORDER BY DeptName LIMIT ? OFFSET ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Department dept = new Department(
                        rs.getInt("DepartmentID"),
                        rs.getString("DeptName"),
                        rs.getObject("DeptManagerID") != null ? rs.getInt("DeptManagerID") : null
                    );
                    list.add(dept);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalDepartmentsCount() {
        String sql = "SELECT COUNT(*) AS total FROM Department";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Department getById(int id) {
        String sql = "SELECT * FROM Department WHERE DepartmentID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Department(
                    rs.getInt("DepartmentID"),
                    rs.getString("DeptName"),
                    rs.getObject("DeptManagerID") != null ? rs.getInt("DeptManagerID") : null
                );
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return null;
    }

    public boolean insert(Department d) {
        String sql = "INSERT INTO Department (DeptName, DeptManagerID) VALUES (?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, d.getDeptName());
            if (d.getDeptManagerId() != null)
                ps.setInt(2, d.getDeptManagerId());
            else 
                ps.setNull(2, Types.INTEGER);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return false;
    }

    public boolean update(Department d) {
        String sql = "UPDATE Department SET DeptName=?, DeptManagerID=? WHERE DepartmentID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, d.getDeptName());
            if (d.getDeptManagerId() != null)
                ps.setInt(2, d.getDeptManagerId());
            else 
                ps.setNull(2, Types.INTEGER);
            ps.setInt(3, d.getDepartmentId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Department WHERE DepartmentID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return false;
    }
    
    public int getTotalDepartments() {
        String sql = "SELECT COUNT(*) as total FROM Department";
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

public List<Department> searchDepartments(String keyword) throws SQLException {
        List<Department> departments = new ArrayList<>();
        String query = "SELECT * FROM Department WHERE DeptName LIKE ? ORDER BY DeptName";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Department dept = new Department(
                        rs.getInt("DepartmentID"),
                        rs.getString("DeptName"),
                        rs.getObject("DeptManagerID") != null ? rs.getInt("DeptManagerID") : null
                    );
                    departments.add(dept);
                }
            }
        }
        return departments;
    }

    public List<Department> searchDepartmentsPaged(String keyword, int offset, int limit) throws SQLException {
        List<Department> departments = new ArrayList<>();
        String query = "SELECT * FROM Department WHERE DeptName LIKE ? ORDER BY DeptName LIMIT ? OFFSET ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setInt(2, limit);
            pstmt.setInt(3, offset);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Department dept = new Department(
                        rs.getInt("DepartmentID"),
                        rs.getString("DeptName"),
                        rs.getObject("DeptManagerID") != null ? rs.getInt("DeptManagerID") : null
                    );
                    departments.add(dept);
                }
            }
        }
        return departments;
    }

    public int searchDepartmentsCount(String keyword) throws SQLException {
        String query = "SELECT COUNT(*) as total FROM Department WHERE DeptName LIKE ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }


    public boolean isDepartmentNameExists(String deptName, int excludeDeptId) throws SQLException {
        String query = "SELECT COUNT(*) as count FROM Department WHERE DeptName = ? AND DepartmentID != ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, deptName);
            pstmt.setInt(2, excludeDeptId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        }
        return false;
    }
    
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.hrm.dao;

import com.hrm.model.entity.MailRequest;
import com.hrm.dao.DBConnection;
import java.sql.*;
import java.util.*;

public class MailRequestDAO {

    public boolean insert(MailRequest r) {
        String sql = """
            INSERT INTO MailRequest (EmployeeID, RequestType, StartDate, EndDate, Reason, Status)
            VALUES (?, ?, ?, ?, ?, 'Pending')
        """;
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, r.getEmployeeId());
            ps.setString(2, r.getRequestType());
            ps.setObject(3, r.getStartDate());
            ps.setObject(4, r.getEndDate());
            ps.setString(5, r.getReason());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int requestId, String status, int approverId) {
        String sql = "UPDATE MailRequest SET Status=?, ApprovedBy=? WHERE RequestID=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, approverId);
            ps.setInt(3, requestId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<MailRequest> getByEmployee(int empId) {
        List<MailRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM MailRequest WHERE EmployeeID=? ORDER BY RequestID DESC";
        try (Connection con = DBConnection.getJDBCConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, empId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToMailRequest(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Lấy tất cả đơn từ đang chờ phê duyệt (for HR Manager)
     */
    public List<MailRequest> getAllPendingRequests() {
        List<MailRequest> list = new ArrayList<>();
        String sql = """
            SELECT mr.*, e.FullName, e.Position, d.DeptName 
            FROM MailRequest mr 
            JOIN Employee e ON mr.EmployeeID = e.EmployeeID 
            LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID 
            WHERE mr.Status = 'Pending' 
            ORDER BY mr.RequestID DESC
        """;
        try (Connection con = DBConnection.getJDBCConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToMailRequest(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Lấy đơn từ đang chờ phê duyệt theo phòng ban (for Department Manager)
     */
    public List<MailRequest> getPendingRequestsByDepartment(int managerId) {
        List<MailRequest> list = new ArrayList<>();
        String sql = """
            SELECT mr.*, e.FullName, e.Position, d.DeptName 
            FROM MailRequest mr 
            JOIN Employee e ON mr.EmployeeID = e.EmployeeID 
            JOIN Department d ON e.DepartmentID = d.DepartmentID 
            WHERE mr.Status = 'Pending' AND d.DeptManagerID = ?
            ORDER BY mr.RequestID DESC
        """;
        try (Connection con = DBConnection.getJDBCConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToMailRequest(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Lấy đơn từ theo ID
     */
    public MailRequest getById(int requestId) {
        String sql = """
            SELECT mr.*, e.FullName, e.Position, d.DeptName 
            FROM MailRequest mr 
            JOIN Employee e ON mr.EmployeeID = e.EmployeeID 
            LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID 
            WHERE mr.RequestID = ?
        """;
        try (Connection con = DBConnection.getJDBCConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToMailRequest(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Map ResultSet to MailRequest object
     */
    private MailRequest mapResultSetToMailRequest(ResultSet rs) throws SQLException {
        MailRequest r = new MailRequest();
        r.setRequestId(rs.getInt("RequestID"));
        r.setEmployeeId(rs.getInt("EmployeeID"));
        r.setRequestType(rs.getString("RequestType"));
          java.sql.Date startDate = rs.getDate("StartDate");
        if (startDate != null) {
            r.setStartDate(startDate.toLocalDate());
        }
        
        java.sql.Date endDate = rs.getDate("EndDate");
        if (endDate != null) {
            r.setEndDate(endDate.toLocalDate());
        }
        
        r.setReason(rs.getString("Reason"));
        r.setStatus(rs.getString("Status"));
        
        if (rs.getInt("ApprovedBy") != 0) {
            r.setApprovedBy(rs.getInt("ApprovedBy"));
        }
        
        return r;
    }
}

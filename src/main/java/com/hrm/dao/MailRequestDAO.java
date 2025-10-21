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
        String sql = "SELECT * FROM MailRequest WHERE EmployeeID=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, empId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MailRequest r = new MailRequest();
                r.setRequestId(rs.getInt("RequestID"));
                r.setEmployeeId(empId);
                r.setRequestType(rs.getString("RequestType"));
                r.setStartDate(rs.getDate("StartDate").toLocalDate());
                r.setEndDate(rs.getDate("EndDate").toLocalDate());
                r.setReason(rs.getString("Reason"));
                r.setStatus(rs.getString("Status"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

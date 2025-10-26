package com.hrm.dao;

import static com.hrm.dao.DBConnection.getConnection;
import com.hrm.model.entity.*;
import com.hrm.model.dto.*;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;

public class DashboardDAO {

    public List<DepartmentStats> getEmployeeByDepartment() {
        List<DepartmentStats> result = new ArrayList<>();
        String sql = "SELECT d.department_id, d.department_name, COUNT(e.employee_id) as count " +
                     "FROM department d " +
                     "LEFT JOIN employee e ON d.department_id = e.department_id " +
                     "WHERE e.status != 'Intern' " +
                     "GROUP BY d.department_id, d.department_name " +
                     "ORDER BY count DESC";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                DepartmentStats stats = new DepartmentStats(
                    rs.getInt("department_id"),
                    rs.getString("department_name"),
                    rs.getInt("count")
                );
                result.add(stats);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<StatusDistribution> getEmployeeStatusDistribution() {
        List<StatusDistribution> result = new ArrayList<>();
        String sql = "SELECT status, COUNT(*) as count FROM employee WHERE status != 'Intern' GROUP BY status";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                StatusDistribution dist = new StatusDistribution(
                    rs.getString("status"),
                    rs.getInt("count")
                );
                result.add(dist);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<SystemLog> getRecentActivity(int limit) {
        List<SystemLog> result = new ArrayList<>();
        String sql = "SELECT log_id, user_id, action, object_type, old_value, new_value, timestamp " +
                     "FROM system_log " +
                     "ORDER BY timestamp DESC LIMIT ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limit);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    SystemLog log = new SystemLog();
                    log.setLogId(rs.getInt("log_id"));
                    log.setUserId(rs.getInt("user_id"));
                    log.setAction(rs.getString("action"));
                    log.setObjectType(rs.getString("object_type"));
                    log.setOldValue(rs.getString("old_value"));
                    log.setNewValue(rs.getString("new_value"));
                    log.setTimestamp(rs.getTimestamp("timestamp").toLocalDateTime());
                    result.add(log);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<ActivityStats> getActivityLast7Days() {
        List<ActivityStats> result = new ArrayList<>();
        String sql = "SELECT DATE(timestamp) as date, COUNT(*) as count " +
                     "FROM system_log " +
                     "WHERE timestamp >= DATE_SUB(NOW(), INTERVAL 7 DAY) " +
                     "GROUP BY DATE(timestamp) " +
                     "ORDER BY date ASC";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                LocalDate date = rs.getDate("date").toLocalDate();
                int count = rs.getInt("count");
                ActivityStats stats = new ActivityStats(date, count);
                result.add(stats);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
}

//package com.hrm.dao;
//
//import com.hrm.model.entity.Task;
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class TaskDAO {
//
//    public List<Task> getAll() {
//        List<Task> list = new ArrayList<>();
//        String sql = """
//            SELECT t.*, e1.FullName as AssignedByName, e2.FullName as AssignToName
//            FROM Task t 
//            LEFT JOIN Employee e1 ON t.AssignedBy = e1.EmployeeID
//            LEFT JOIN Employee e2 ON t.AssignTo = e2.EmployeeID
//            ORDER BY t.DueDate DESC
//        """;
//
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            while (rs.next()) {
//                Task task = new Task();
//                task.setTaskId(rs.getInt("TaskID"));
//                task.setTitle(rs.getString("Title"));
//                task.setDescription(rs.getString("Description"));
//                task.setAssignedBy(rs.getInt("AssignedBy"));
//                task.setAssignTo(rs.getInt("AssignTo"));
//                
//                if (rs.getDate("StartDate") != null) {
//                    task.setStartDate(rs.getDate("StartDate").toLocalDate());
//                }
//                
//                if (rs.getDate("DueDate") != null) {
//                    task.setDueDate(rs.getDate("DueDate").toLocalDate());
//                }
//                
//                task.setStatus(rs.getString("Status"));
//                list.add(task);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//
//    public Task getById(int id) {
//        String sql = "SELECT * FROM Task WHERE TaskID = ?";
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)) {
//
//            ps.setInt(1, id);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                Task task = new Task();
//                task.setTaskId(rs.getInt("TaskID"));
//                task.setTitle(rs.getString("Title"));
//                task.setDescription(rs.getString("Description"));
//                task.setAssignedBy(rs.getInt("AssignedBy"));
//                task.setAssignTo(rs.getInt("AssignTo"));
//                
//                if (rs.getDate("StartDate") != null) {
//                    task.setStartDate(rs.getDate("StartDate").toLocalDate());
//                }
//                
//                if (rs.getDate("DueDate") != null) {
//                    task.setDueDate(rs.getDate("DueDate").toLocalDate());
//                }
//                
//                task.setStatus(rs.getString("Status"));
//                return task;
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//    public boolean insert(Task task) {
//        String sql = """
//            INSERT INTO Task (Title, Description, AssignedBy, AssignTo, StartDate, DueDate, Status)
//            VALUES (?, ?, ?, ?, ?, ?, ?)
//        """;
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)) {
//
//            ps.setString(1, task.getTitle());
//            ps.setString(2, task.getDescription());
//            ps.setInt(3, task.getAssignedBy());
//            ps.setInt(4, task.getAssignTo());
//            
//            if (task.getStartDate() != null) {
//                ps.setDate(5, Date.valueOf(task.getStartDate()));
//            } else {
//                ps.setDate(5, new Date(System.currentTimeMillis())); // Current date
//            }
//            
//            if (task.getDueDate() != null) {
//                ps.setDate(6, Date.valueOf(task.getDueDate()));
//            } else {
//                ps.setNull(6, Types.DATE);
//            }
//            
//            ps.setString(7, task.getStatus());
//
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//
//    public boolean update(Task task) {
//        String sql = """
//            UPDATE Task SET Title=?, Description=?, AssignedBy=?, AssignTo=?, 
//                          StartDate=?, DueDate=?, Status=? 
//            WHERE TaskID=?
//        """;
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)) {
//
//            ps.setString(1, task.getTitle());
//            ps.setString(2, task.getDescription());
//            ps.setInt(3, task.getAssignedBy());
//            ps.setInt(4, task.getAssignTo());
//            
//            if (task.getStartDate() != null) {
//                ps.setDate(5, Date.valueOf(task.getStartDate()));
//            } else {
//                ps.setNull(5, Types.DATE);
//            }
//            
//            if (task.getDueDate() != null) {
//                ps.setDate(6, Date.valueOf(task.getDueDate()));
//            } else {
//                ps.setNull(6, Types.DATE);
//            }
//            
//            ps.setString(7, task.getStatus());
//            ps.setInt(8, task.getTaskId());
//
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//
//    public boolean delete(int id) {
//        String sql = "DELETE FROM Task WHERE TaskID = ?";
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)) {
//            ps.setInt(1, id);
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//
//    public List<Task> getTasksByEmployee(int employeeId) {
//        List<Task> list = new ArrayList<>();
//        String sql = "SELECT * FROM Task WHERE AssignTo = ? ORDER BY DueDate DESC";
//
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)) {
//
//            ps.setInt(1, employeeId);
//            ResultSet rs = ps.executeQuery();
//
//            while (rs.next()) {
//                Task task = new Task();
//                task.setTaskId(rs.getInt("TaskID"));
//                task.setTitle(rs.getString("Title"));
//                task.setDescription(rs.getString("Description"));
//                task.setAssignedBy(rs.getInt("AssignedBy"));
//                task.setAssignTo(rs.getInt("AssignTo"));
//                
//                if (rs.getDate("StartDate") != null) {
//                    task.setStartDate(rs.getDate("StartDate").toLocalDate());
//                }
//                
//                if (rs.getDate("DueDate") != null) {
//                    task.setDueDate(rs.getDate("DueDate").toLocalDate());
//                }
//                
//                task.setStatus(rs.getString("Status"));
//                list.add(task);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//}
//
//
//

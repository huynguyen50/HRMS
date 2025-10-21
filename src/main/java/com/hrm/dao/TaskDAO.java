package com.hrm.dao;

import com.hrm.model.entity.Task;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TaskDAO {

    public List<Task> getAll() {
        List<Task> list = new ArrayList<>();
        String sql = """
            SELECT t.*, e1.FullName as AssignedByName, e2.FullName as AssignToName
            FROM Task t 
            LEFT JOIN Employee e1 ON t.AssignedBy = e1.EmployeeID
            LEFT JOIN Employee e2 ON t.AssignTo = e2.EmployeeID
            ORDER BY t.DueDate DESC
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("TaskID"));
                task.setTitle(rs.getString("Title"));
                task.setDescription(rs.getString("Description"));
                task.setAssignedBy(rs.getInt("AssignedBy"));
                task.setAssignTo(rs.getInt("AssignTo"));
                
                if (rs.getDate("StartDate") != null) {
                    task.setStartDate(rs.getDate("StartDate").toLocalDate());
                }
                
                if (rs.getDate("DueDate") != null) {
                    task.setDueDate(rs.getDate("DueDate").toLocalDate());
                }
                
                task.setStatus(rs.getString("Status"));
                list.add(task);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Task getById(int id) {
        String sql = "SELECT * FROM Task WHERE TaskID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("TaskID"));
                task.setTitle(rs.getString("Title"));
                task.setDescription(rs.getString("Description"));
                task.setAssignedBy(rs.getInt("AssignedBy"));
                task.setAssignTo(rs.getInt("AssignTo"));
                
                if (rs.getDate("StartDate") != null) {
                    task.setStartDate(rs.getDate("StartDate").toLocalDate());
                }
                
                if (rs.getDate("DueDate") != null) {
                    task.setDueDate(rs.getDate("DueDate").toLocalDate());
                }
                
                task.setStatus(rs.getString("Status"));
                return task;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(Task task) {
        String sql = """
            INSERT INTO Task (Title, Description, AssignedBy, AssignTo, StartDate, DueDate, Status)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, task.getTitle());
            ps.setString(2, task.getDescription());
            ps.setInt(3, task.getAssignedBy());
            ps.setInt(4, task.getAssignTo());
            
            if (task.getStartDate() != null) {
                ps.setDate(5, Date.valueOf(task.getStartDate()));
            } else {
                ps.setDate(5, new Date(System.currentTimeMillis())); // Current date
            }
            
            if (task.getDueDate() != null) {
                ps.setDate(6, Date.valueOf(task.getDueDate()));
            } else {
                ps.setNull(6, Types.DATE);
            }
            
            ps.setString(7, task.getStatus());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Task task) {
        String sql = """
            UPDATE Task SET Title=?, Description=?, AssignedBy=?, AssignTo=?, 
                          StartDate=?, DueDate=?, Status=? 
            WHERE TaskID=?
        """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, task.getTitle());
            ps.setString(2, task.getDescription());
            ps.setInt(3, task.getAssignedBy());
            ps.setInt(4, task.getAssignTo());
            
            if (task.getStartDate() != null) {
                ps.setDate(5, Date.valueOf(task.getStartDate()));
            } else {
                ps.setNull(5, Types.DATE);
            }
            
            if (task.getDueDate() != null) {
                ps.setDate(6, Date.valueOf(task.getDueDate()));
            } else {
                ps.setNull(6, Types.DATE);
            }
            
            ps.setString(7, task.getStatus());
            ps.setInt(8, task.getTaskId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Task WHERE TaskID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Task> getTasksByEmployee(int employeeId) {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT * FROM Task WHERE AssignTo = ? ORDER BY DueDate DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("TaskID"));
                task.setTitle(rs.getString("Title"));
                task.setDescription(rs.getString("Description"));
                task.setAssignedBy(rs.getInt("AssignedBy"));
                task.setAssignTo(rs.getInt("AssignTo"));
                
                if (rs.getDate("StartDate") != null) {
                    task.setStartDate(rs.getDate("StartDate").toLocalDate());
                }
                
                if (rs.getDate("DueDate") != null) {
                    task.setDueDate(rs.getDate("DueDate").toLocalDate());
                }
                
                task.setStatus(rs.getString("Status"));
                list.add(task);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy danh sách task được giao cho một nhân viên
     */
    public List<Task> getTasksByAssignee(int employeeId) {
        List<Task> list = new ArrayList<>();
        String sql = """
            SELECT t.*, e1.FullName as AssignedByName, e2.FullName as AssignToName,
                   d.DeptName as AssignerDept
            FROM Task t 
            LEFT JOIN Employee e1 ON t.AssignedBy = e1.EmployeeID
            LEFT JOIN Employee e2 ON t.AssignTo = e2.EmployeeID
            LEFT JOIN Department d ON e1.DepartmentID = d.DepartmentID
            WHERE t.AssignTo = ?
            ORDER BY t.DueDate ASC, t.TaskID DESC
        """;

        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Lấy danh sách task do một manager giao
     */
    public List<Task> getTasksByAssigner(int managerId) {
        List<Task> list = new ArrayList<>();
        String sql = """
            SELECT t.*, e1.FullName as AssignedByName, e2.FullName as AssignToName,
                   d1.DeptName as AssignerDept, d2.DeptName as AssigneeDept
            FROM Task t 
            LEFT JOIN Employee e1 ON t.AssignedBy = e1.EmployeeID
            LEFT JOIN Employee e2 ON t.AssignTo = e2.EmployeeID
            LEFT JOIN Department d1 ON e1.DepartmentID = d1.DepartmentID
            LEFT JOIN Department d2 ON e2.DepartmentID = d2.DepartmentID
            WHERE t.AssignedBy = ?
            ORDER BY t.DueDate ASC, t.TaskID DESC
        """;

        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, managerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Cập nhật trạng thái task
     */
    public boolean updateTaskStatus(int taskId, String status, String progress, String note) {
        String sql = """
            UPDATE Task 
            SET Status = ?, 
                Progress = ?, 
                Note = ?,
                UpdatedAt = CURRENT_TIMESTAMP
            WHERE TaskID = ?
        """;
        
        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setString(2, progress);
            ps.setString(3, note);
            ps.setInt(4, taskId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Approve hoặc reject task results
     */
    public boolean approveTaskResult(int taskId, String status, String approverComment, int approverId) {
        String sql = """
            UPDATE Task 
            SET Status = ?, 
                ApproverComment = ?,
                ApprovedBy = ?,
                ApprovedDate = CURRENT_TIMESTAMP
            WHERE TaskID = ?
        """;
        
        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setString(2, approverComment);
            ps.setInt(3, approverId);
            ps.setInt(4, taskId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Gửi progress report
     */
    public boolean submitProgress(int taskId, String progressReport, String attachments, int employeeId) {
        String sql = """
            UPDATE Task 
            SET ProgressReport = ?, 
                Attachments = ?,
                LastProgressUpdate = CURRENT_TIMESTAMP
            WHERE TaskID = ? AND AssignTo = ?
        """;
        
        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, progressReport);
            ps.setString(2, attachments);
            ps.setInt(3, taskId);
            ps.setInt(4, employeeId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy các task Completed theo người giao việc (for approval)
     */
    public List<Task> getCompletedTasksByAssigner(int assignerId) {
        List<Task> list = new ArrayList<>();
        String sql = """
            SELECT t.*, e1.FullName as AssignedByName, e2.FullName as AssignToName,
                   d1.DeptName as AssignerDept, d2.DeptName as AssigneeDept
            FROM Task t 
            LEFT JOIN Employee e1 ON t.AssignedBy = e1.EmployeeID
            LEFT JOIN Employee e2 ON t.AssignTo = e2.EmployeeID
            LEFT JOIN Department d1 ON e1.DepartmentID = d1.DepartmentID
            LEFT JOIN Department d2 ON e2.DepartmentID = d2.DepartmentID
            WHERE t.AssignedBy = ? AND t.Status = 'Completed'
            ORDER BY t.DueDate ASC, t.TaskID DESC
        """;

        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, assignerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Reassign task to another employee
     */
    public boolean reassignTask(int taskId, int newAssigneeId, String comment) {
        String sql = """
            UPDATE Task 
            SET AssignTo = ?, 
                Status = 'Pending',
                ReassignNote = ?,
                UpdatedAt = CURRENT_TIMESTAMP
            WHERE TaskID = ?
        """;
        
        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, newAssigneeId);
            ps.setString(2, comment);
            ps.setInt(3, taskId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Map ResultSet to Task object
     */
    private Task mapResultSetToTask(ResultSet rs) throws SQLException {
        Task task = new Task();
        task.setTaskId(rs.getInt("TaskID"));
        task.setTitle(rs.getString("Title"));
        task.setDescription(rs.getString("Description"));
        task.setAssignedBy(rs.getInt("AssignedBy"));
        task.setAssignTo(rs.getInt("AssignTo"));
        
        if (rs.getDate("StartDate") != null) {
            task.setStartDate(rs.getDate("StartDate").toLocalDate());
        }
        
        if (rs.getDate("DueDate") != null) {
            task.setDueDate(rs.getDate("DueDate").toLocalDate());
        }
        
        task.setStatus(rs.getString("Status"));
        
        // Additional fields if available
        try {
            task.setProgress(rs.getString("Progress"));
            task.setNote(rs.getString("Note"));
            task.setProgressReport(rs.getString("ProgressReport"));
            task.setAttachments(rs.getString("Attachments"));
            task.setApproverComment(rs.getString("ApproverComment"));
            if (rs.getInt("ApprovedBy") != 0) {
                task.setApprovedBy(rs.getInt("ApprovedBy"));
            }
        } catch (SQLException e) {
            // These fields might not exist in all queries, ignore
        }
        
        return task;
    }
}


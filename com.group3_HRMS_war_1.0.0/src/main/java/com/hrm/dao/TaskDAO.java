/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.hrm.dao;

import com.hrm.model.dto.TaskDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TaskDAO {

    private static final Logger LOGGER = LoggerFactory.getLogger(TaskDAO.class);

    public List<TaskDTO> findTasksToday() {
        String sql = "SELECT t.task_id, t.title, t.description, t.assigned_by, t.assign_to,"
                + " t.start_date, t.due_date, t.status, e.full_name AS assign_to_name"
                + " FROM tasks t"
                + " LEFT JOIN employees e ON e.employee_id = t.assign_to"
                + " WHERE DATE(t.due_date) = CURRENT_DATE() OR DATE(t.start_date) = CURRENT_DATE()"
                + " ORDER BY COALESCE(t.due_date, t.start_date) ASC";
        return queryTasks(sql);
    }

    public List<TaskDTO> findTasksUpcoming() {
        String sql = "SELECT t.task_id, t.title, t.description, t.assigned_by, t.assign_to,"
                + " t.start_date, t.due_date, t.status, e.full_name AS assign_to_name"
                + " FROM tasks t"
                + " LEFT JOIN employees e ON e.employee_id = t.assign_to"
                + " WHERE (t.start_date > CURRENT_DATE() OR t.due_date > CURRENT_DATE())"
                + " ORDER BY COALESCE(t.start_date, t.due_date) ASC"
                + " LIMIT 100";
        return queryTasks(sql);
    }

    private List<TaskDTO> queryTasks(String sql) {
        List<TaskDTO> tasks = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TaskDTO dto = new TaskDTO();
                    dto.setTaskId(rs.getInt("task_id"));
                    dto.setTitle(rs.getString("title"));
                    dto.setDescription(rs.getString("description"));
                    dto.setAssignedBy((Integer) rs.getObject("assigned_by"));
                    dto.setAssignTo((Integer) rs.getObject("assign_to"));
                    dto.setAssignToName(rs.getString("assign_to_name"));
                    Date start = (Date) rs.getObject("start_date");
                    Date due = (Date) rs.getObject("due_date");
                    dto.setStartDate(start);
                    dto.setDueDate(due);
                    dto.setStatus(rs.getString("status"));
                    tasks.add(dto);
                }
            }
        } catch (SQLException e) {
            // log and return empty list
            LOGGER.error("TaskDAO query failed", e);
        }
        return tasks;
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.hrm.controller.dept;

import com.hrm.dao.DAO;
import com.hrm.model.entity.Task;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author DELL
 */
@WebServlet(name = "TaskManager", urlPatterns = {"/taskManager"})
public class TaskManager extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        // Actions similar to PostRecruitmentController but for Task
        if ("progress".equals(action)) { // move to In Progress
            handleStatusChange(request, response, "In Progress");
            return;
        } else if ("complete".equals(action)) { // move to Completed
            handleStatusChange(request, response, "Completed");
            return;
        } else if ("delete".equals(action)) { // delete task
            handleDelete(request, response);
            return;
        }

        int page = 1;
        int pageSize = 5;
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            try { page = Integer.parseInt(pageStr); } catch (Exception ignore) { page = 1; }
        }

        String searchByTitle = request.getParameter("searchByTitle");
        String filterStatus = request.getParameter("filterStatus");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        // Use DAO for search and pagination
        List<Task> tasks;
        int total;
        boolean hasSearch = (searchByTitle != null && !searchByTitle.trim().isEmpty())
                || (filterStatus != null && !filterStatus.trim().isEmpty() && !"all".equalsIgnoreCase(filterStatus))
                || (startDate != null && !startDate.trim().isEmpty())
                || (endDate != null && !endDate.trim().isEmpty());

        if (hasSearch) {
            tasks = DAO.getInstance().searchTasks(searchByTitle, filterStatus, startDate, endDate, page, pageSize);
            total = DAO.getInstance().searchCountTasks(searchByTitle, filterStatus, startDate, endDate);
        } else {
            tasks = DAO.getInstance().getAllTasks(page, pageSize);
            total = DAO.getInstance().getCountTasks();
        }

        int totalPages = (int) Math.ceil((double) total / pageSize);
        if (totalPages == 0) totalPages = 1;

        request.setAttribute("tasks", tasks);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchByTitle", searchByTitle);
        request.setAttribute("filterStatus", filterStatus);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);

        request.getRequestDispatcher("/Views/DeptManager/taskManager.jsp").forward(request, response);
    }

    private void handleStatusChange(HttpServletRequest request, HttpServletResponse response, String newStatus)
            throws IOException {
        try {
            String idStr = request.getParameter("id");
            int taskId = Integer.parseInt(idStr);
            DAO.getInstance().updateTaskStatus(taskId, newStatus);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/taskManager");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String idStr = request.getParameter("id");
            int taskId = Integer.parseInt(idStr);
            DAO.getInstance().deleteTaskById(taskId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/taskManager");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // For future use (e.g., bulk actions); currently redirect to GET
        response.sendRedirect(request.getContextPath() + "/taskManager");
    }

    @Override
    public String getServletInfo() {
        return "Department Task Manager";
    }
}

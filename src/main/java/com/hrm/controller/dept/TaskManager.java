/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.hrm.controller.dept;

import com.hrm.dao.DAO;
import com.hrm.model.entity.Employee;
import com.hrm.model.entity.SystemUser;
import com.hrm.model.entity.Task;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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

        if ("viewAssignees".equals(action)) {
            String taskIdStr = request.getParameter("id");
            if (taskIdStr != null && !taskIdStr.trim().isEmpty()) {
                try {
                    int taskId = Integer.parseInt(taskIdStr);
                    
                    List<Integer> empIds = DAO.getInstance().getEmployeeIdsByTaskId(taskId);
                    
                    List<Employee> employees = new ArrayList<>();
                    for (Integer empId : empIds) {
                        Employee emp = DAO.getInstance().getEmp(empId);
                        if (emp != null) {
                            employees.add(emp);
                        }
                    }
                    
                    response.setContentType("text/html");
                    PrintWriter out = response.getWriter();
                    
                    if (employees.isEmpty()) {
                        out.println("<div class='alert alert-info'>No employees assigned to this task.</div>");
                    } else {
                        for (Employee emp : employees) {
                            out.println("<div class='employee-name'>" + emp.getFullName() + "</div>");
                        }
                    }
                    return;
                } catch (NumberFormatException e) {
                }
            }
            return;
        } else if ("reject".equals(action)) {
            int TaskID = Integer.parseInt(request.getParameter("id"));
            DAO.getInstance().updateTaskStatus(TaskID, "Rejected");
            request.setAttribute("mess", "Reject successfully!");
        } else if("send".equals(action)) {
            int TaskID = Integer.parseInt(request.getParameter("id"));
            DAO.getInstance().updateTaskStatus(TaskID, "Waiting");
            request.setAttribute("mess", "Send successfully!");
        }
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
            return;
        }
        
        SystemUser currentUser = (SystemUser) session.getAttribute("systemUser");
        if (currentUser == null || currentUser.getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
            return;
        }
        
        int employeeId = currentUser.getEmployeeId();

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

        List<Task> tasks;
        int total;
        boolean hasSearch = (searchByTitle != null && !searchByTitle.trim().isEmpty())
                || (filterStatus != null && !filterStatus.trim().isEmpty() && !"all".equalsIgnoreCase(filterStatus))
                || (startDate != null && !startDate.trim().isEmpty())
                || (endDate != null && !endDate.trim().isEmpty());

        if (hasSearch) {
            tasks = DAO.getInstance().searchTasks(employeeId, searchByTitle, filterStatus, startDate, endDate, page, pageSize);
            total = DAO.getInstance().searchCountTasks(employeeId,searchByTitle, filterStatus, startDate, endDate);
        } else {
            tasks = DAO.getInstance().getAllTasks(employeeId,page, pageSize);
            total = DAO.getInstance().getCountTasks(employeeId);
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
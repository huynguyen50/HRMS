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
import java.util.ArrayList;
import java.util.List;
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
@WebServlet(name = "ViewTask", urlPatterns={"/viewTask"})
public class ViewTask extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("systemUser") == null) {
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
            return;
        }

        SystemUser sys = (SystemUser) session.getAttribute("systemUser");
        Employee emp = DAO.getInstance().getEmp(sys.getEmployeeId());
        
        int taskID = Integer.parseInt(request.getParameter("id"));
        
        Task task = DAO.getInstance().getTaskById(taskID);
        List<Employee> employeeList = DAO.getInstance().loadEmpFollowDepartment(emp.getDepartmentId());
        List<Integer> assignedEmpIds = DAO.getInstance().getEmployeeIdsByTaskId(taskID);
        List<Employee> assignedEmployees = new ArrayList<>();
        
        for (Integer empId : assignedEmpIds) {
            Employee assignedEmp = DAO.getInstance().getEmp(empId);
            if (assignedEmp != null) {
                assignedEmployees.add(assignedEmp);
            }
        }
        
        request.setAttribute("task", task);
        request.setAttribute("employeeList", employeeList);
        request.setAttribute("assignedEmployees", assignedEmployees);
        request.getRequestDispatcher("/Views/DeptManager/viewTask.jsp").forward(request, response);
    } 
    
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    HttpSession session = request.getSession();
    if (session == null || session.getAttribute("systemUser") == null) {
        response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
        return;
    }

    int taskId = Integer.parseInt(request.getParameter("taskId"));
    String title = request.getParameter("title");
    String description = request.getParameter("description");
    String startDate = request.getParameter("startDate");
    String dueDate = request.getParameter("dueDate");
    
    boolean success = DAO.getInstance().updateTask(taskId, title, description, startDate, dueDate);
    
    if(success) {
        DAO.getInstance().deleteTaskAssignments(taskId);
        
        String[] assignToIds = request.getParameterValues("assignTo");
        if(assignToIds != null) {
            for(String empIdStr : assignToIds) {
                try {
                    int empId = Integer.parseInt(empIdStr);
                    DAO.getInstance().assignTaskToEmployee(taskId, empId);
                } catch (NumberFormatException e) {
                }
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/viewTask?id=" + taskId + "&mess=Task updated successfully");
    } else {
        response.sendRedirect(request.getContextPath() + "/viewTask?id=" + taskId + "&error=Failed to update task");
    }
}
    
    @Override
    public String getServletInfo() {
        return "View Task Controller";
    }
}
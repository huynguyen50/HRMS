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
@WebServlet(name = "postTask", urlPatterns = {"/postTask"})
public class PostTask extends HttpServlet {

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

        // Lấy danh sách nhân viên trong cùng phòng
        List<Employee> eList = DAO.getInstance().loadEmpFollowDepartment(emp.getDepartmentId());

        request.setAttribute("employeeList", eList);
        request.getRequestDispatcher("Views/DeptManager/postTask.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("systemUser") == null) {
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
            return;
        }

        SystemUser sys = (SystemUser) session.getAttribute("systemUser");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String startDate = request.getParameter("startDate");
        String dueDate = request.getParameter("dueDate");

        int taskId = DAO.getInstance().createTask(title, description, sys.getEmployeeId(), startDate, dueDate);

        if (taskId > 0) {
            String[] assignToIds = request.getParameterValues("assignTo");
            if (assignToIds != null) {
                for (String empIdStr : assignToIds) {
                    try {
                        int empId = Integer.parseInt(empIdStr);
                        DAO.getInstance().assignTaskToEmployee(taskId, empId);
                    } catch (NumberFormatException e) {
                    }
                }
            }

            response.sendRedirect(request.getContextPath() + "/taskManager?mess=Task created successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/postTask?error=Failed to create task");
        }
    }

    @Override
    public String getServletInfo() {
        return "Post Task Controller";
    }
}

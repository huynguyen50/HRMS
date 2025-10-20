package com.hrm.servlet.auth;

import com.hrm.dao.EmployeeDAO;
import com.hrm.model.entity.Employee;
import com.hrm.model.entity.SystemUser;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("systemUser") == null) {
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
            return;
        }

        SystemUser systemUser = (SystemUser) session.getAttribute("systemUser");
        System.out.println("ProfileServlet: Getting employee for user ID: " + systemUser.getUserId());
        Employee employee = employeeDAO.getEmployeeBySystemUserId(systemUser.getUserId());

        if (employee != null) {
            System.out.println("ProfileServlet: Employee found: " + employee.getFullName());
            request.setAttribute("employee", employee);
            request.getRequestDispatcher("/Views/Profile.jsp").forward(request, response);
        } else {
            System.out.println("ProfileServlet: Employee not found for user ID: " + systemUser.getUserId());
            // Handle case where employee is not found for the logged-in user
            response.sendRedirect(request.getContextPath() + "/Views/Dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // This can be implemented later to handle profile updates
        doGet(request, response);
    }
}

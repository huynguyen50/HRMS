package com.hrm.controller.admin;

import com.hrm.dao.SystemUserDAO;
import com.hrm.dao.RoleDAO;
import com.hrm.dao.EmployeeDAO;
import com.hrm.dao.DepartmentDAO;
import com.hrm.model.entity.SystemUser;
import com.hrm.model.entity.Role;
import com.hrm.model.entity.Employee;
import com.hrm.model.entity.Department;
import com.hrm.dao.DBConnection;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;

@WebServlet("/admin/users")
public class UserController extends HttpServlet {
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try (Connection conn = DBConnection.getConnection()) {
            if ("getUser".equals(action)) {
                handleGetUser(request, response, conn);
            } else if ("list".equals(action)) {
                handleListUsers(request, response, conn);
            } else {
                handleListUsers(request, response, conn);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try (Connection conn = DBConnection.getConnection()) {
            if ("save".equals(action)) {
                handleSaveUser(request, response, conn);
            } else if ("update".equals(action)) {
                handleUpdateUser(request, response, conn);
            } else if ("resetPassword".equals(action)) {
                handleResetPassword(request, response, conn);
            } else if ("toggleStatus".equals(action)) {
                handleToggleStatus(request, response, conn);
            } else if ("delete".equals(action)) {
                handleDeleteUser(request, response, conn);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    private void handleListUsers(HttpServletRequest request, HttpServletResponse response, Connection conn) 
            throws Exception {
        SystemUserDAO userDAO = new SystemUserDAO();
        RoleDAO roleDAO = new RoleDAO();
        EmployeeDAO employeeDAO = new EmployeeDAO();
        DepartmentDAO departmentDAO = new DepartmentDAO();
        
        // Get pagination parameters
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            page = Integer.parseInt(pageParam);
        }
        
        // Get filter parameters
        Integer roleFilter = null;
        Integer statusFilter = null;
        Integer departmentFilter = null;
        String usernameFilter = null;
        
        String roleParam = request.getParameter("roleFilter");
        if (roleParam != null && !roleParam.isEmpty()) {
            roleFilter = Integer.parseInt(roleParam);
        }
        
        String statusParam = request.getParameter("statusFilter");
        if (statusParam != null && !statusParam.isEmpty()) {
            statusFilter = Integer.parseInt(statusParam);
        }
        
        String deptParam = request.getParameter("departmentFilter");
        if (deptParam != null && !deptParam.isEmpty()) {
            departmentFilter = Integer.parseInt(deptParam);
        }
        
        usernameFilter = request.getParameter("usernameFilter");
        
        // Get users
        List<SystemUser> users;
        int totalCount;
        
        if (roleFilter != null || statusFilter != null || departmentFilter != null || usernameFilter != null) {
            users = userDAO.getUsersWithFilters(page, PAGE_SIZE, roleFilter, statusFilter, departmentFilter, usernameFilter);
            totalCount = userDAO.getTotalUserCountWithFilters(roleFilter, statusFilter, departmentFilter, usernameFilter);
        } else {
            users = userDAO.getAllUsers(page, PAGE_SIZE);
            totalCount = userDAO.getTotalUserCount();
        }
        
        int totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;
        
        // Get reference data
        List<Role> roles = roleDAO.getAllRoles();
        List<Employee> employees = employeeDAO.getAll();
        List<Department> departments = departmentDAO.getAll();
        
        // Set request attributes
        request.setAttribute("users", users);
        request.setAttribute("roles", roles);
        request.setAttribute("employees", employees);
        request.setAttribute("departments", departments);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("activePage", "users");

        
        request.getRequestDispatcher("/Admin/Users.jsp").forward(request, response);
    }

    private void handleGetUser(HttpServletRequest request, HttpServletResponse response, Connection conn) 
            throws Exception {
        int userId = Integer.parseInt(request.getParameter("id"));
        SystemUserDAO userDAO = new SystemUserDAO();
        SystemUser user = userDAO.getUserById(userId);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(new Gson().toJson(user));
        out.flush();
    }

    private void handleSaveUser(HttpServletRequest request, HttpServletResponse response, Connection conn) 
            throws Exception {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        Integer employeeId = null;
        String empParam = request.getParameter("employeeId");
        if (empParam != null && !empParam.isEmpty()) {
            employeeId = Integer.parseInt(empParam);
        }
        boolean isActive = request.getParameter("isActive") != null;
        
        SystemUserDAO userDAO = new SystemUserDAO();
        
        // Check if username exists
        if (userDAO.usernameExists(username)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Username already exists");
            return;
        }
        
        SystemUser user = new SystemUser();
        user.setUsername(username);
        user.setPassword(password); // Should be hashed in production
        user.setRoleId(roleId);
        user.setEmployeeId(employeeId);
        user.setIsActive(isActive);
        
        if (userDAO.createUser(user)) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create user");
        }
    }

    private void handleUpdateUser(HttpServletRequest request, HttpServletResponse response, Connection conn) 
            throws Exception {
        int userId = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        Integer employeeId = null;
        String empParam = request.getParameter("employeeId");
        if (empParam != null && !empParam.isEmpty()) {
            employeeId = Integer.parseInt(empParam);
        }
        boolean isActive = request.getParameter("isActive") != null;
        
        SystemUserDAO userDAO = new SystemUserDAO();
        SystemUser user = new SystemUser();
        user.setUserId(userId);
        user.setUsername(username);
        user.setRoleId(roleId);
        user.setEmployeeId(employeeId);
        user.setIsActive(isActive);
        
        if (userDAO.updateUser(user)) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update user");
        }
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response, Connection conn) 
            throws Exception {
        int userId = Integer.parseInt(request.getParameter("id"));
        String tempPassword = "TempPass123!"; // Generate random password in production
        
        SystemUserDAO userDAO = new SystemUserDAO();
        if (userDAO.updatePassword(userId, tempPassword)) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to reset password");
        }
    }

    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response, Connection conn) 
            throws Exception {
        int userId = Integer.parseInt(request.getParameter("id"));
        SystemUserDAO userDAO = new SystemUserDAO();
        
        if (userDAO.toggleUserStatus(userId)) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to toggle user status");
        }
    }

    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response, Connection conn) 
            throws Exception {
        int userId = Integer.parseInt(request.getParameter("id"));
        SystemUserDAO userDAO = new SystemUserDAO();
        
        if (userDAO.deleteUser(userId)) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete user");
        }
    }
}

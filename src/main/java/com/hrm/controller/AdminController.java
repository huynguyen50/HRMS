package com.hrm.controller;

import com.hrm.dao.*;
import com.hrm.model.entity.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminController", urlPatterns = {"/admin"})
public class AdminController extends HttpServlet {

    private EmployeeDAO employeeDAO = new EmployeeDAO();
    private DepartmentDAO departmentDAO = new DepartmentDAO();
    private SystemUserDAO userDAO = new SystemUserDAO();
    private RoleDAO roleDAO = new RoleDAO();
    private AuditLogDAO auditLogDAO = new AuditLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "dashboard";
        }

        switch (action) {
            case "dashboard":
                loadDashboard(request, response);
                break;

            case "employees":
                loadEmployees(request, response);
                break;

            case "employee-view":
                viewEmployee(request, response);
                break;

            case "employee-edit":
                editEmployee(request, response);
                break;

            case "employee-delete":
                deleteEmployee(request, response);
                break;

            case "employee-get-data":
                getEmployeeData(request, response);
                break;

            case "departments":
                loadDepartments(request, response);
                break;

            case "department-add":
                loadDepartmentForm(request, response, null);
                break;

            case "department-edit":
                loadDepartmentEdit(request, response);
                break;

            case "department-delete":
                deleteDepartment(request, response);
                break;

            case "department-permissions":
                loadDepartmentPermissions(request, response);
                break;

            case "users":
                loadUsers(request, response);
                break;

            case "roles":
                loadRoles(request, response);
                break;

            case "audit-log":
                loadAuditLog(request, response);
                break;

            case "profile":
                request.setAttribute("activePage", "profile");
                request.getRequestDispatcher("Admin/Profile.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect("Admin/Login.jsp");
        }
    }

    private void loadDashboard(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        request.setAttribute("activePage", "dashboard");

        int totalEmployees = employeeDAO.getTotalEmployees();
        int activeEmployees = employeeDAO.getActiveEmployees();
        int totalDepartments = departmentDAO.getTotalDepartments();
        int totalUsers = userDAO.getTotalUsers();

        request.setAttribute("totalEmployees", totalEmployees);
        request.setAttribute("activeEmployees", activeEmployees);
        request.setAttribute("totalDepartments", totalDepartments);
        request.setAttribute("totalUsers", totalUsers);

        System.out.println("Dashboard counts -> total=" + totalEmployees + ", active=" + activeEmployees + ", depts=" + totalDepartments + ", users=" + totalUsers);

        request.getRequestDispatcher("Admin/AdminHome.jsp").forward(request, response);
    }

 private void loadEmployees(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        request.setAttribute("activePage", "employees");

        String searchKeyword = request.getParameter("search");
        List<Employee> employeeList = new ArrayList<>();

        int page = 1;
        int pageSize = 10;
        try {
            String pageStr = request.getParameter("page");
            String sizeStr = request.getParameter("pageSize");
            if (pageStr != null) page = Math.max(1, Integer.parseInt(pageStr));
            if (sizeStr != null) pageSize = Math.max(1, Integer.parseInt(sizeStr));
        } catch (NumberFormatException ignore) {}

        try {
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                int totalEmployees = employeeDAO.searchEmployeesCount(searchKeyword);
                int totalPages = (int) Math.ceil(totalEmployees / (double) pageSize);
                if (page < 1) page = 1;
                if (totalPages == 0) totalPages = 1;
                if (page > totalPages) page = totalPages;
                int offset = (page - 1) * pageSize;
                
                employeeList = employeeDAO.searchEmployeesPaged(searchKeyword, offset, pageSize);
                request.setAttribute("total", totalEmployees);
                request.setAttribute("totalPages", totalPages);
            } else {
                int total = employeeDAO.getTotalEmployeesCount();
                int totalPages = (int) Math.ceil(total / (double) pageSize);
                int offset = (page - 1) * pageSize;

                employeeList = employeeDAO.getPaged(offset, pageSize);
                request.setAttribute("total", total);
                request.setAttribute("totalPages", totalPages);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading employees: " + e.getMessage());
        }

        List<Department> departments = departmentDAO.getAll();

        request.setAttribute("employeeList", employeeList);
        request.setAttribute("departments", departments);
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("Admin/Employees.jsp").forward(request, response);
    }


    private void viewEmployee(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        try {
            String empIdStr = request.getParameter("id");
            if (empIdStr != null && !empIdStr.isEmpty()) {
                int empId = Integer.parseInt(empIdStr);
                Employee employee = employeeDAO.getById(empId);
                
                if (employee != null) {
                    jakarta.servlet.http.HttpSession session = request.getSession(false);
                    if (session != null) {
                        String successMessage = (String) session.getAttribute("successMessage");
                        String errorMessage = (String) session.getAttribute("errorMessage");
                        if (successMessage != null) {
                            request.setAttribute("successMessage", successMessage);
                            session.removeAttribute("successMessage");
                        }
                        if (errorMessage != null) {
                            request.setAttribute("errorMessage", errorMessage);
                            session.removeAttribute("errorMessage");
                        }
                    }
                    List<Department> departments = departmentDAO.getAll();
                    request.setAttribute("employee", employee);
                    request.setAttribute("departments", departments);
                    request.setAttribute("mode", "view");
                    request.getRequestDispatcher("Admin/EmployeeDetail.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Employee not found");
                    loadEmployees(request, response);
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid employee ID");
            loadEmployees(request, response);
        }
    }

    private void editEmployee(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        try {
            String empIdStr = request.getParameter("id");
            if (empIdStr != null && !empIdStr.isEmpty()) {
                int empId = Integer.parseInt(empIdStr);
                Employee employee = employeeDAO.getById(empId);
                
                if (employee != null) {
                    List<Department> departments = departmentDAO.getAll();
                    request.setAttribute("employee", employee);
                    request.setAttribute("departments", departments);
                    request.setAttribute("mode", "edit");
                    request.getRequestDispatcher("Admin/EmployeeForm.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Employee not found");
                    loadEmployees(request, response);
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid employee ID");
            loadEmployees(request, response);
        }
    }

    private void deleteEmployee(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        try {
            String empIdStr = request.getParameter("id");
            if (empIdStr != null && !empIdStr.isEmpty()) {
                int empId = Integer.parseInt(empIdStr);
                
                if (employeeDAO.delete(empId)) {
                    request.setAttribute("successMessage", "Employee deleted successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete employee");
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid employee ID");
        }
        
        loadEmployees(request, response);
    }

    private void getEmployeeData(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        try {
            String empIdStr = request.getParameter("id");
            if (empIdStr != null && !empIdStr.isEmpty()) {
                int empId = Integer.parseInt(empIdStr);
                Employee employee = employeeDAO.getById(empId);
                
                if (employee != null) {
                    String json = String.format(
                        "{\"id\":%d,\"fullName\":\"%s\",\"gender\":\"%s\",\"email\":\"%s\",\"phone\":\"%s\",\"address\":\"%s\",\"dob\":\"%s\",\"departmentId\":%d,\"position\":\"%s\",\"employmentPeriod\":\"%s\",\"status\":\"%s\"}",
                        employee.getEmployeeId(),
                        escapeJson(employee.getFullName()),
                        employee.getGender() != null ? employee.getGender() : "",
                        escapeJson(employee.getEmail()),
                        employee.getPhone() != null ? escapeJson(employee.getPhone()) : "",
                        employee.getAddress() != null ? escapeJson(employee.getAddress()) : "",
                        employee.getDob() != null ? employee.getDob().toString() : "",
                        employee.getDepartmentId(),
                        escapeJson(employee.getPosition()),
                        employee.getEmploymentPeriod() != null ? escapeJson(employee.getEmploymentPeriod()) : "",
                        employee.getStatus() != null ? employee.getStatus() : "Active"
                    );
                    response.getWriter().write(json);
                } else {
                    response.getWriter().write("{\"error\":\"Employee not found\"}");
                }
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"error\":\"Invalid employee ID\"}");
        }
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }

    private void loadDepartments(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        request.setAttribute("activePage", "departments");

        String searchKeyword = request.getParameter("search");
        List<Department> departmentList = new ArrayList<>();

        int page = 1;
        int pageSize = 10;
        try {
            String pageStr = request.getParameter("page");
            String sizeStr = request.getParameter("pageSize");
            if (pageStr != null) page = Math.max(1, Integer.parseInt(pageStr));
            if (sizeStr != null) pageSize = Math.max(1, Integer.parseInt(sizeStr));
        } catch (NumberFormatException ignore) {}

        try {
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                departmentList = departmentDAO.searchDepartments(searchKeyword);
                request.setAttribute("total", departmentList.size());
                request.setAttribute("totalPages", 1);
            } else {
                int totalDepartments = departmentDAO.getTotalDepartmentsCount();
                int totalPages = (int) Math.ceil(totalDepartments / (double) pageSize);
                if (page < 1) page = 1;
                if (totalPages == 0) totalPages = 1;
                if (page > totalPages) page = totalPages;
                int offset = (page - 1) * pageSize;
                departmentList = departmentDAO.getPaged(offset, pageSize);
                request.setAttribute("total", totalDepartments);
                request.setAttribute("totalPages", totalPages);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading departments: " + e.getMessage());
        }

        for (Department dept : departmentList) {
            int count = employeeDAO.getEmployeeCountByDepartment(dept.getDepartmentId());
            dept.setEmployeeCount(count);
        }

        List<Employee> managers = employeeDAO.getManagerList();

        request.setAttribute("departmentList", departmentList);
        request.setAttribute("managers", managers);
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("Admin/Departments.jsp").forward(request, response);
    }

    private void loadDepartmentForm(HttpServletRequest request, HttpServletResponse response, Department dept)
              throws ServletException, IOException {
        request.setAttribute("activePage", "departments");
        
        List<Employee> managers = employeeDAO.getManagerList();
        request.setAttribute("managers", managers);
        
        if (dept != null) {
            request.setAttribute("department", dept);
        }
        
        request.getRequestDispatcher("Admin/DepartmentForm.jsp").forward(request, response);
    }

    private void loadDepartmentEdit(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        request.setAttribute("activePage", "departments");
        
        try {
            String deptIdStr = request.getParameter("id");
            if (deptIdStr != null && !deptIdStr.isEmpty()) {
                int deptId = Integer.parseInt(deptIdStr);
                Department dept = departmentDAO.getById(deptId);
                
                if (dept != null) {
                    List<Employee> managers = employeeDAO.getManagerList();
                    request.setAttribute("managers", managers);
                    request.setAttribute("department", dept);
                    request.getRequestDispatcher("Admin/DepartmentForm.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Department not found");
                    loadDepartments(request, response);
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid department ID");
            loadDepartments(request, response);
        }
    }

    private void deleteDepartment(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        try {
            String deptIdStr = request.getParameter("id");
            if (deptIdStr != null && !deptIdStr.isEmpty()) {
                int deptId = Integer.parseInt(deptIdStr);
                
                if (departmentDAO.delete(deptId)) {
                    request.setAttribute("successMessage", "Department deleted successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete department");
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid department ID");
        }
        
        loadDepartments(request, response);
    }

    private void loadDepartmentPermissions(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        request.setAttribute("activePage", "departments");
        
        try {
            String deptIdStr = request.getParameter("id");
            if (deptIdStr != null && !deptIdStr.isEmpty()) {
                int deptId = Integer.parseInt(deptIdStr);
                Department dept = departmentDAO.getById(deptId);
                
                if (dept != null) {
                    request.setAttribute("department", dept);
                    request.getRequestDispatcher("Admin/DepartmentPermissions.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Department not found");
                    loadDepartments(request, response);
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid department ID");
            loadDepartments(request, response);
        }
    }

    private void loadUsers(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        request.setAttribute("activePage", "users");

        List<SystemUser> userList = userDAO.getAllUsers();
        request.setAttribute("userList", userList);

        request.getRequestDispatcher("Admin/Users.jsp").forward(request, response);
    }

    private void loadRoles(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        request.setAttribute("activePage", "roles");

        List<Role> roleList = roleDAO.getAllRoles();
        request.setAttribute("roleList", roleList);

        request.getRequestDispatcher("Admin/Roles.jsp").forward(request, response);
    }

    private void loadAuditLog(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        request.setAttribute("activePage", "audit-log");

        List<SystemLog> logList = auditLogDAO.getAllAuditLogs();
        request.setAttribute("logList", logList);

        request.getRequestDispatcher("Admin/AuditLog.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("save-employee".equals(action)) {
            saveEmployee(request, response);
        } else {
            doGet(request, response);
        }
    }

private void saveEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String empIdStr = request.getParameter("employeeId");
            if (empIdStr != null && !empIdStr.isEmpty()) {
                int empId = Integer.parseInt(empIdStr);
                Employee employee = employeeDAO.getById(empId);
                
                if (employee != null) {
                    // Update employee information
                    employee.setFullName(request.getParameter("fullName"));
                    employee.setGender(request.getParameter("gender"));
                    
                    String dobStr = request.getParameter("dob");
                    if (dobStr != null && !dobStr.isEmpty()) {
                        try {
                            employee.setDob(LocalDate.parse(dobStr));
                        } catch (Exception e) {
                            jakarta.servlet.http.HttpSession session = request.getSession();
                            session.setAttribute("errorMessage", "Invalid date format for Date of Birth");
                            response.sendRedirect(request.getContextPath() + "/admin?action=employee-view&id=" + empId);
                            return;
                        }
                    }
                    
                    employee.setEmail(request.getParameter("email"));
                    employee.setPhone(request.getParameter("phone"));
                    employee.setAddress(request.getParameter("address"));
                    employee.setPosition(request.getParameter("position"));
                    employee.setEmploymentPeriod(request.getParameter("employmentPeriod"));
                    employee.setStatus(request.getParameter("status"));
                    
                    // Update department assignment
                    String deptIdStr = request.getParameter("departmentId");
                    if (deptIdStr != null && !deptIdStr.isEmpty()) {
                        employee.setDepartmentId(Integer.parseInt(deptIdStr));
                    }
                    
                    if (employeeDAO.update(employee)) {
                        jakarta.servlet.http.HttpSession session = request.getSession();
                        session.setAttribute("successMessage", "Employee information saved successfully");
                    } else {
                        jakarta.servlet.http.HttpSession session = request.getSession();
                        session.setAttribute("errorMessage", "Failed to save employee information");
                    }
                    // Redirect-after-POST to avoid double submit and blank responses
                    response.sendRedirect(request.getContextPath() + "/admin?action=employee-view&id=" + empId);
                } else {
                    jakarta.servlet.http.HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", "Employee not found");
                    response.sendRedirect(request.getContextPath() + "/admin?action=employees");
                }
            }
        } catch (NumberFormatException e) {
            jakarta.servlet.http.HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Invalid input data");
            response.sendRedirect(request.getContextPath() + "/admin?action=employees");
        }
    }

    @Override
    public String getServletInfo() {
        return "Admin Controller - Handles admin panel navigation and data loading";
    }
}

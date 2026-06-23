package com.hrm.controller.dept;

import com.hrm.dao.EmployeeDAO;
import com.hrm.dao.DepartmentDAO;
import com.hrm.model.entity.SystemUser;
import com.hrm.util.PermissionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "DeptController", urlPatterns = {"/dept"})
public class DeptController extends HttpServlet {

    private EmployeeDAO employeeDAO = new EmployeeDAO();
    private DepartmentDAO departmentDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check authentication - only roleID 3 can access
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
            return;
        }
        
        SystemUser currentUser = (SystemUser) session.getAttribute("systemUser");
        if (!canAccessDept(currentUser)) {
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "dashboard";
        }

        switch (action) {
            case "dashboard":
                loadDashboard(request, response, currentUser);
                break;
            case "taskManager":
                request.getRequestDispatcher("/Views/DeptManager/postTask.jsp").forward(request, response);
                break;
            default:
                loadDashboard(request, response, currentUser);
        }
    }

    private void loadDashboard(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        request.setAttribute("activePage", "dashboard");
        
        // Get department ID from current user
        int departmentId = getDepartmentIdForUser(currentUser);
        
        // Get department name
        String departmentName = "N/A";
        if (departmentId > 0) {
            com.hrm.model.entity.Department department = departmentDAO.getById(departmentId);
            if (department != null && department.getDeptName() != null) {
                departmentName = department.getDeptName();
            }
        }
        
        // Get statistics
        int totalEmployees = employeeDAO.getEmployeeCountByDepartment(departmentId);
        int activeEmployees = getActiveEmployeesCount(departmentId);
        
        request.setAttribute("totalEmployees", totalEmployees);
        request.setAttribute("activeEmployees", activeEmployees);
        request.setAttribute("departmentName", departmentName);
        
        request.getRequestDispatcher("/Views/DeptManager/deptHome.jsp").forward(request, response);
    }

    private int getDepartmentIdForUser(SystemUser user) {
        try {
            Integer employeeId = user.getEmployeeId();
            if (employeeId != null) {
                com.hrm.model.entity.Employee employee = employeeDAO.getById(employeeId);
                if (employee != null) {
                    Integer deptId = employee.getDepartmentId();
                    if (deptId != null) {
                        return deptId;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private boolean canAccessDept(SystemUser user) {
        if (user == null) {
            return false;
        }
        int roleId = user.getRoleId();
        return roleId == PermissionUtil.ROLE_ADMIN || roleId == PermissionUtil.ROLE_DEPT_MANAGER;
    }

    private int getActiveEmployeesCount(int departmentId) {
        try {
            int count = 0;
            java.util.List<com.hrm.model.entity.Employee> allEmployees = employeeDAO.getAll();
            for (com.hrm.model.entity.Employee emp : allEmployees) {
                Integer deptId = emp.getDepartmentId();
                if (deptId != null && deptId.intValue() == departmentId 
                    && "Active".equalsIgnoreCase(emp.getStatus())) {
                    count++;
                }
            }
            return count;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}


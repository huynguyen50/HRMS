package com.hrm.controller.admin;

import com.hrm.dao.*;
import com.hrm.model.dto.ActivityStats;
import com.hrm.model.dto.DepartmentStats;
import com.hrm.model.dto.StatusDistribution;
import com.hrm.model.entity.*;
import com.hrm.util.PermissionUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.*;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminController", urlPatterns = {"/admin"})
public class AdminController extends HttpServlet {

    private EmployeeDAO employeeDAO = new EmployeeDAO();
    private DepartmentDAO departmentDAO = new DepartmentDAO();
    private SystemUserDAO userDAO = new SystemUserDAO();
    private SystemLogDAO systemLogDAO = new SystemLogDAO();

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

            case "dashboard-data":
                getDashboardData(request, response);
                break;

            case "departments":
                if (!checkPermission(request, response, "VIEW_DEPARTMENTS", "View Departments")) {
                    return;
                }
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
                if (!checkPermission(request, response, "VIEW_USERS", "View Users")) {
                    return;
                }
                loadUsers(request, response);
                break;

            case "roles":
                loadRoles(request, response);
                break;

            case "audit-log":
                if (!checkPermission(request, response, "VIEW_AUDIT_LOG", "View Audit Log")) {
                    return;
                }
                loadAuditLog(request, response);
                break;

            case "profile":
                loadProfile(request, response);
                break;

            case "get-user-permissions":
                getUserPermissions(request, response);
                break;

            default:
                response.sendRedirect("Admin/Login.jsp");
        }
    }

    private void loadDashboard(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        // Kiểm tra quyền
        HttpSession session = request.getSession();
        SystemUser currentUser = (SystemUser) session.getAttribute("systemUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
            return;
        }
        
        if (!PermissionUtil.hasPermission(currentUser, "VIEW_DASHBOARD")) {
            PermissionUtil.redirectToAccessDenied(request, response, "VIEW_DASHBOARD", "View Dashboard");
            return;
        }
        
        request.setAttribute("activePage", "dashboard");

        int totalEmployees = employeeDAO.getTotalEmployees();
        int activeEmployees = employeeDAO.getActiveEmployees();
        int totalDepartments = departmentDAO.getTotalDepartments();
        int totalUser = userDAO.getTotalSystemUser();

        request.setAttribute("totalEmployees", totalEmployees);
        request.setAttribute("activeEmployees", activeEmployees);
        request.setAttribute("totalDepartments", totalDepartments);
        request.setAttribute("totalUser", totalUser);

        DashboardDAO dashboardDAO = new DashboardDAO();

        List<DepartmentStats> employeeByDept = dashboardDAO.getEmployeeByDepartment();
        StringBuilder deptJson = new StringBuilder("{");
        for (int i = 0; i < employeeByDept.size(); i++) {
            DepartmentStats dept = employeeByDept.get(i);
            deptJson.append("\"").append(dept.getDeptName()).append("\": ").append(dept.getCount());
            if (i < employeeByDept.size() - 1) {
                deptJson.append(",");
            }
        }
        deptJson.append("}");
        request.setAttribute("employeeDistributionJson", deptJson.toString());

        List<StatusDistribution> statusDistList = dashboardDAO.getEmployeeStatusDistribution();
        StringBuilder statusJson = new StringBuilder("{");
        for (int i = 0; i < statusDistList.size(); i++) {
            StatusDistribution status = statusDistList.get(i);
            statusJson.append("\"").append(status.getStatus()).append("\": ").append(status.getCount());
            if (i < statusDistList.size() - 1) {
                statusJson.append(",");
            }
        }
        statusJson.append("}");
        request.setAttribute("employeeStatusJson", statusJson.toString());

        List<ActivityStats> activityLast7 = dashboardDAO.getActivityLast7Days();
        StringBuilder activityJson = new StringBuilder("[");
        for (int i = 0; i < activityLast7.size(); i++) {
            ActivityStats activity = activityLast7.get(i);
            activityJson.append("{\"date\":\"").append(activity.getDate())
                       .append("\",\"count\":").append(activity.getCount()).append("}");
            if (i < activityLast7.size() - 1) {
                activityJson.append(",");
            }
        }
        activityJson.append("]");
        request.setAttribute("activityDataJson", activityJson.toString());

        List<SystemLog> recentActivity = dashboardDAO.getRecentActivity(5);
        request.setAttribute("recentActivity", recentActivity);

        // Load users and permissions for permission manager
        try {
            List<SystemUser> allUsers = userDAO.getAllUsers(1, 1000); // Get all users
            for (SystemUser user : allUsers) {
                if (user.getEmployeeId() != null) {
                    Employee emp = employeeDAO.getById(user.getEmployeeId());
                    if (emp != null) {
                        user.setEmployee(emp);
                        if (emp.getDepartmentId() > 0) {
                            Department dept = departmentDAO.getById(emp.getDepartmentId());
                            emp.setDepartment(dept);
                        }
                    }
                }
            }
            request.setAttribute("allUsers", allUsers);
            
            PermissionDAO permissionDAO = new PermissionDAO();
            List<Permission> allPermissions = permissionDAO.getAllPermissions();
            request.setAttribute("allPermissions", allPermissions);
            
            // Get unique categories
            Set<String> categories = new HashSet<>();
            for (Permission perm : allPermissions) {
                if (perm.getCategory() != null && !perm.getCategory().isEmpty()) {
                    categories.add(perm.getCategory());
                }
            }
            request.setAttribute("permissionCategories", new ArrayList<>(categories));
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("allUsers", new ArrayList<>());
            request.setAttribute("allPermissions", new ArrayList<>());
            request.setAttribute("permissionCategories", new ArrayList<>());
        }

        System.out.println("Dashboard counts -> total=" + totalEmployees + ", active=" + activeEmployees + ", depts=" + totalDepartments + ", user=" + totalUser);

        request.getRequestDispatcher("Admin/AdminHome.jsp").forward(request, response);
    }

    private void getDashboardData(HttpServletRequest request, HttpServletResponse response)
              throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            DashboardDAO dashboardDAO = new DashboardDAO();

            int totalEmployees = employeeDAO.getTotalEmployees();
            int activeEmployees = employeeDAO.getActiveEmployees();
            int inactiveEmployees = totalEmployees - activeEmployees;

            List<DepartmentStats> employeeByDept = dashboardDAO.getEmployeeByDepartment();
            List<StatusDistribution> statusDistribution = dashboardDAO.getEmployeeStatusDistribution();
            List<SystemLog> recentActivity = dashboardDAO.getRecentActivity(5);
            List<ActivityStats> activityLast7Days = dashboardDAO.getActivityLast7Days();

            // Build JSON response
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"totalEmployees\": ").append(totalEmployees).append(",");
            json.append("\"activeEmployees\": ").append(activeEmployees).append(",");
            json.append("\"inactiveEmployees\": ").append(inactiveEmployees).append(",");

            // Employee by department
            json.append("\"employeeByDepartment\": [");
            for (int i = 0; i < employeeByDept.size(); i++) {
                DepartmentStats dept = employeeByDept.get(i);
                json.append("{\"department\": \"").append(dept.getDeptName()).append("\", ");
                json.append("\"count\": ").append(dept.getCount()).append("}");
                if (i < employeeByDept.size() - 1) {
                    json.append(",");
                }
            }
            json.append("],");

            // Status distribution
            json.append("\"statusDistribution\": [");
            for (int i = 0; i < statusDistribution.size(); i++) {
                StatusDistribution status = statusDistribution.get(i);
                json.append("{\"status\": \"").append(status.getStatus()).append("\", ");
                json.append("\"count\": ").append(status.getCount()).append("}");
                if (i < statusDistribution.size() - 1) {
                    json.append(",");
                }
            }
            json.append("],");

            // Recent activity
            json.append("\"recentActivity\": [");
            for (int i = 0; i < recentActivity.size(); i++) {
                SystemLog activity = recentActivity.get(i);
                json.append("{\"action\": \"").append(escapeJson(activity.getAction())).append("\", ");
                json.append("\"objectType\": \"").append(escapeJson(activity.getObjectType())).append("\", ");
                json.append("\"newValue\": \"").append(escapeJson(activity.getNewValue())).append("\"}");
                if (i < recentActivity.size() - 1) {
                    json.append(",");
                }
            }
            json.append("],");

            // Activity last 7 days
            json.append("\"activityLast7Days\": [");
            for (int i = 0; i < activityLast7Days.size(); i++) {
                ActivityStats activity = activityLast7Days.get(i);
                json.append("{\"date\": \"").append(activity.getDate()).append("\", ");
                json.append("\"count\": ").append(activity.getCount()).append("}");
                if (i < activityLast7Days.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");

            json.append("}");

            System.out.println("[v0] Dashboard data JSON: " + json.toString());
            response.getWriter().write(json.toString());

        } catch (Exception e) {
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }



    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }
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
        String departmentIdStr = request.getParameter("departmentId");
        String timeRange = request.getParameter("timeRange");
        
        List<Department> departmentList = new ArrayList<>();

        int page = 1;
        int pageSize = 10;
        try {
            String pageStr = request.getParameter("page");
            String sizeStr = request.getParameter("pageSize");
            if (pageStr != null) {
                page = Math.max(1, Integer.parseInt(pageStr));
            }
            if (sizeStr != null) {
                pageSize = Math.max(1, Integer.parseInt(sizeStr));
            }
        } catch (NumberFormatException ignore) {
        }

        try {
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                int total = departmentDAO.searchDepartmentsCount(searchKeyword);
                int totalPages = (int) Math.ceil(total / (double) pageSize);
                if (totalPages == 0) {
                    totalPages = 1;
                }
                if (page > totalPages) {
                    page = totalPages;
                }
                int offset = (page - 1) * pageSize;
                departmentList = departmentDAO.searchDepartmentsPaged(searchKeyword, offset, pageSize);
                request.setAttribute("total", total);
                request.setAttribute("totalPages", totalPages);
            } else {
                int totalDepartments = departmentDAO.getTotalDepartmentsCount();
                int totalPages = (int) Math.ceil(totalDepartments / (double) pageSize);
                if (page < 1) {
                    page = 1;
                }
                if (totalPages == 0) {
                    totalPages = 1;
                }
                if (page > totalPages) {
                    page = totalPages;
                }
                int offset = (page - 1) * pageSize;
                
                if ((departmentIdStr != null && !departmentIdStr.isEmpty()) || 
                    (timeRange != null && !timeRange.isEmpty())) {
                    int deptId = (departmentIdStr != null && !departmentIdStr.isEmpty()) ? 
                                 Integer.parseInt(departmentIdStr) : 0;
                    departmentList = departmentDAO.getPagedByDepartmentAndTimeRange(deptId, timeRange, offset, pageSize);
                    totalDepartments = departmentDAO.getCountByDepartmentAndTimeRange(deptId, timeRange);
                    totalPages = (int) Math.ceil(totalDepartments / (double) pageSize);
                } else {
                    departmentList = departmentDAO.getPaged(offset, pageSize);
                }
                
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
        List<Department> allDepartments = departmentDAO.getAll();

        request.setAttribute("departmentList", departmentList);
        request.setAttribute("managers", managers);
        request.setAttribute("allDepartments", allDepartments);
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("selectedDepartmentId", departmentIdStr != null ? departmentIdStr : "");
        request.setAttribute("selectedTimeRange", timeRange != null ? timeRange : "");

        request.getRequestDispatcher("Admin/Departments.jsp").forward(request, response);
    }

    private void loadDepartmentForm(HttpServletRequest request, HttpServletResponse response, Object dept)
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
        request.getRequestDispatcher("Admin/Users.jsp").forward(request, response);
    }

    private void loadRoles(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        request.setAttribute("activePage", "roles");
        request.getRequestDispatcher("Admin/Roles.jsp").forward(request, response);
    }

    private void loadAuditLog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int page = 1;
            int pageSize = 10; // Default value
            if (request.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            // Read pageSize from request parameter
            if (request.getParameter("pageSize") != null) {
                try {
                    pageSize = Integer.parseInt(request.getParameter("pageSize"));
                    // Validate pageSize to prevent invalid values
                    if (pageSize < 1) {
                        pageSize = 10;
                    }
                } catch (NumberFormatException e) {
                    pageSize = 10;
                }
            }

            String search = request.getParameter("search");
            String filterAction = request.getParameter("filterAction");
            String filterObjectType = request.getParameter("filterObjectType");
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");
            if (sortBy == null || sortBy.isEmpty()) {
                sortBy = "Timestamp";
            }
            if (sortOrder == null || sortOrder.isEmpty()) {
                sortOrder = "DESC";
            }

            int offset = (page - 1) * pageSize;
            List<SystemLog> logList = systemLogDAO.getPagedSystemLogsWithUserInfo(
                    offset, pageSize, search, filterAction, filterObjectType, sortBy, sortOrder);

            int totalLogs = systemLogDAO.getTotalSystemLogCount(search, filterAction, filterObjectType);
            int totalPages = (int) Math.ceil((double) totalLogs / pageSize);
            
            System.out.println("[DEBUG] Total logs from DAO: " + totalLogs);
            System.out.println("[DEBUG] Log list size from DAO: " + logList.size());
            
            List<String> actions = systemLogDAO.getAllDistinctActions();
            List<String> objectTypes = systemLogDAO.getAllDistinctObjectTypes();

            request.setAttribute("systemLogs", logList);
            request.setAttribute("page", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("total", totalLogs);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("distinctActions", actions);
            request.setAttribute("distinctObjectTypes", objectTypes);
            request.setAttribute("searchQuery", search);
            request.setAttribute("filterAction", filterAction);
            request.setAttribute("filterObjectType", filterObjectType);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);

            request.setAttribute("activePage", "audit-log");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading audit log: " + e.getMessage());
        }

        request.getRequestDispatcher("Admin/AuditLog.jsp").forward(request, response);
    }

    private void loadProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("activePage", "profile");
        
        try {
            jakarta.servlet.http.HttpSession session = request.getSession();
            SystemUser currentUser = (SystemUser) session.getAttribute("systemUser");
            
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
                return;
            }
            
            SystemUser fullUser = userDAO.getUserById(currentUser.getUserId());
            if (fullUser != null) {
                // Load employee info if exists
                if (fullUser.getEmployeeId() != null) {
                    Employee employee = employeeDAO.getById(fullUser.getEmployeeId());
                    if (employee != null) {
                        fullUser.setEmployee(employee);
                        if (employee.getDepartmentId() > 0) {
                            Department dept = departmentDAO.getById(employee.getDepartmentId());
                            fullUser.setDepartment(dept);
                        }
                    }
                }
                
                // Convert LocalDateTime to Timestamp for JSP fmt:formatDate compatibility
                if (fullUser.getCreatedDate() != null) {
                    request.setAttribute("createdDateTimestamp", 
                        java.sql.Timestamp.valueOf(fullUser.getCreatedDate()));
                }
                if (fullUser.getLastLogin() != null) {
                    request.setAttribute("lastLoginTimestamp", 
                        java.sql.Timestamp.valueOf(fullUser.getLastLogin()));
                }
                
                request.setAttribute("currentUser", fullUser);
            } else {
                // Convert LocalDateTime to Timestamp for currentUser as well
                if (currentUser.getCreatedDate() != null) {
                    request.setAttribute("createdDateTimestamp", 
                        java.sql.Timestamp.valueOf(currentUser.getCreatedDate()));
                }
                if (currentUser.getLastLogin() != null) {
                    request.setAttribute("lastLoginTimestamp", 
                        java.sql.Timestamp.valueOf(currentUser.getLastLogin()));
                }
                request.setAttribute("currentUser", currentUser);
            }
            
            // Get recent activity logs for this user (limit to 10)
            List<SystemLog> recentLogs = systemLogDAO.getSystemLogsByUserID(currentUser.getUserId(), 10);
            // Convert LocalDateTime to Timestamp for each log for JSP compatibility
            for (SystemLog log : recentLogs) {
                if (log.getTimestamp() != null) {
                    log.setTimestampDate(java.util.Date.from(
                        log.getTimestamp().atZone(java.time.ZoneId.systemDefault()).toInstant()));
                }
            }
            request.setAttribute("recentLogs", recentLogs);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading profile: " + e.getMessage());
        }
        
        request.getRequestDispatcher("Admin/Profile.jsp").forward(request, response);
    }

    private void getUserPermissions(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String userIdStr = request.getParameter("userId");
            if (userIdStr == null || userIdStr.isEmpty()) {
                response.getWriter().write("{\"error\": \"User ID is required\"}");
                return;
            }
            
            int userId = Integer.parseInt(userIdStr);
            UserPermissionDAO userPermissionDAO = new UserPermissionDAO();
            PermissionDAO permissionDAO = new PermissionDAO();
            
            // Get all permissions
            List<Permission> allPermissions = permissionDAO.getAllPermissions();
            
            // Get user permissions
            List<UserPermission> userPermissions = userPermissionDAO.getUserPermissions(userId);
            
            // Build response
            JsonObject jsonResponse = new JsonObject();
            
            // All permissions
            JsonArray permissionsArray = new JsonArray();
            for (Permission perm : allPermissions) {
                JsonObject permObj = new JsonObject();
                permObj.addProperty("permissionId", perm.getPermissionId());
                permObj.addProperty("permissionCode", perm.getPermissionCode());
                permObj.addProperty("permissionName", perm.getPermissionName());
                permObj.addProperty("category", perm.getCategory() != null ? perm.getCategory() : "");
                permObj.addProperty("description", perm.getDescription() != null ? perm.getDescription() : "");
                permissionsArray.add(permObj);
            }
            jsonResponse.add("allPermissions", permissionsArray);
            
            // User permissions as map
            JsonObject userPermsObj = new JsonObject();
            for (UserPermission userPerm : userPermissions) {
                JsonObject upObj = new JsonObject();
                upObj.addProperty("userPermissionId", userPerm.getUserPermissionId());
                upObj.addProperty("userId", userPerm.getUserId());
                upObj.addProperty("permissionId", userPerm.getPermissionId());
                upObj.addProperty("isGranted", userPerm.isIsGranted()); // Using isIsGranted() as per entity
                upObj.addProperty("scope", userPerm.getScope() != null ? userPerm.getScope() : "ALL");
                upObj.addProperty("scopeValue", userPerm.getScopeValue() != null ? userPerm.getScopeValue() : 0);
                userPermsObj.add(String.valueOf(userPerm.getPermissionId()), upObj);
            }
            jsonResponse.add("userPermissions", userPermsObj);
            
            response.getWriter().write(new Gson().toJson(jsonResponse));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("save-user-permissions".equals(action)) {
            saveUserPermissions(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    private void saveUserPermissions(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Read JSON from request body
            StringBuilder jsonBuilder = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                jsonBuilder.append(line);
            }
            String jsonString = jsonBuilder.toString();
            
            Gson gson = new Gson();
            JsonObject jsonObject = gson.fromJson(jsonString, JsonObject.class);
            JsonArray changesArray = jsonObject.getAsJsonArray("changes");
            
            UserPermissionDAO userPermissionDAO = new UserPermissionDAO();
            SystemUser currentUser = (SystemUser) request.getSession().getAttribute("systemUser");
            int createdBy = currentUser != null ? currentUser.getUserId() : 1;
            
            int successCount = 0;
            int failCount = 0;
            
            for (int i = 0; i < changesArray.size(); i++) {
                JsonObject change = changesArray.get(i).getAsJsonObject();
                try {
                    UserPermission userPerm = new UserPermission();
                    userPerm.setUserId(change.get("userId").getAsInt());
                    userPerm.setPermissionId(change.get("permissionId").getAsInt());
                    userPerm.setIsGranted(change.get("isGranted").getAsBoolean());
                    userPerm.setScope(change.has("scope") && !change.get("scope").isJsonNull() 
                        ? change.get("scope").getAsString() : "ALL");
                    if (change.has("scopeValue") && !change.get("scopeValue").isJsonNull()) {
                        int scopeValue = change.get("scopeValue").getAsInt();
                        userPerm.setScopeValue(scopeValue > 0 ? scopeValue : null);
                    } else {
                        userPerm.setScopeValue(null);
                    }
                    userPerm.setCreatedBy(createdBy);
                    
                    // Check if exists
                    UserPermission existing = userPermissionDAO.getUserPermission(
                        userPerm.getUserId(), userPerm.getPermissionId(), 
                        userPerm.getScope(), userPerm.getScopeValue());
                    
                    if (existing != null) {
                        // Update
                        userPerm.setUserPermissionId(existing.getUserPermissionId());
                        userPermissionDAO.updateUserPermission(userPerm);
                    } else {
                        // Insert
                        userPermissionDAO.createUserPermission(userPerm);
                    }
                    successCount++;
                } catch (Exception e) {
                    e.printStackTrace();
                    failCount++;
                }
            }
            
            JsonObject result = new JsonObject();
            result.addProperty("success", failCount == 0);
            result.addProperty("successCount", successCount);
            result.addProperty("failCount", failCount);
            result.addProperty("message", failCount == 0 
                ? "All permissions saved successfully" 
                : "Saved " + successCount + " permissions, " + failCount + " failed");
            
            response.getWriter().write(gson.toJson(result));
            
        } catch (Exception e) {
            e.printStackTrace();
            JsonObject error = new JsonObject();
            error.addProperty("success", false);
            error.addProperty("message", "Error: " + e.getMessage());
            response.getWriter().write(new Gson().toJson(error));
        }
    }

    /**
     * Helper method để kiểm tra quyền
     */
    private boolean checkPermission(HttpServletRequest request, HttpServletResponse response, 
                                   String permissionCode, String permissionName) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        SystemUser currentUser = (SystemUser) session.getAttribute("systemUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
            return false;
        }
        
        if (!PermissionUtil.hasPermission(currentUser, permissionCode)) {
            PermissionUtil.redirectToAccessDenied(request, response, permissionCode, permissionName);
            return false;
        }
        
        return true;
    }

    @Override
    public String getServletInfo() {
        return "Admin Controller - Handles admin panel navigation and data loading";
    }
}

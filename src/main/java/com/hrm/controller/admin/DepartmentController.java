package com.hrm.controller.admin;

import com.hrm.dao.*;
import com.hrm.model.entity.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
// Bỏ import java.sql.Statement;
import java.sql.PreparedStatement; // Thêm import này
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "DepartmentController", urlPatterns = {"/departments"})
public class DepartmentController extends HttpServlet {

    private DepartmentDAO departmentDAO = new DepartmentDAO();
    private EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "departments":
                listDepartments(request, response);
                break;
            case "edit":
                editDepartment(request, response);
                break;
            case "permissions":
                manageDepartmentPermissions(request, response);
                break;
            default:
                listDepartments(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "save";
        }

        switch (action) {
            case "department-save":
                saveDepartment(request, response);
                break;
            case "department-delete":
                deleteDepartment(request, response);
                break;
            case "department-permissions-save":
                savePermissions(request, response);
                break;
            default:
                listDepartments(request, response);
        }
    }

  private void listDepartments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("activePage", "departments");

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

        String searchKeyword = request.getParameter("search");
        String status = request.getParameter("status");
        String sortBy = request.getParameter("sortBy");

        // Convert status parameter
        String effectiveStatus = (status != null && !status.isEmpty()) ? status : "all";
        
        List<Department> departmentList = new ArrayList<>(); // Khởi tạo list ở đây
        List<Object> paramsCount = new ArrayList<>(); // List tham số cho query count
        List<Object> paramsList = new ArrayList<>(); // List tham số cho query list

        int page = 1;
        int pageSize = 10;
        try {
            String pageStr = request.getParameter("page");
            String sizeStr = request.getParameter("pageSize");
            if (pageStr != null) page = Math.max(1, Integer.parseInt(pageStr));
            if (sizeStr != null) pageSize = Math.max(1, Integer.parseInt(sizeStr));
        } catch (NumberFormatException ignore) {}

        int total = 0;
        int offset = (page - 1) * pageSize;
        
        // Build the SQL query based on filters
        StringBuilder sqlCount = new StringBuilder(
            "SELECT COUNT(*) as total FROM department d WHERE 1=1"
        );
        
        // SỬA LỖI: Thêm JOIN để lấy ManagerName và sửa GROUP BY
        StringBuilder sql = new StringBuilder(
            "SELECT d.*, COUNT(e.EmployeeID) as emp_count, m.FullName as ManagerName " +
            "FROM department d " +
            "LEFT JOIN employee e ON d.DepartmentID = e.DepartmentID " +
            "LEFT JOIN employee m ON d.DeptManagerID = m.EmployeeID " + // Thêm join này
            "WHERE 1=1"
        );
        
        // Add status filter
        if (!"all".equals(effectiveStatus)) {
            String statusCondition = " AND d.Status = ?";
            sqlCount.append(statusCondition);
            sql.append(statusCondition);
            paramsCount.add(effectiveStatus); // Thêm tham số
            paramsList.add(effectiveStatus); // Thêm tham số
        }
        
        // Add search filter
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            String searchCondition = " AND d.DeptName LIKE ?";
            sqlCount.append(searchCondition);
            sql.append(searchCondition);
            String searchParam = "%" + searchKeyword.trim() + "%";
            paramsCount.add(searchParam); // Thêm tham số
            paramsList.add(searchParam); // Thêm tham số
        }
        
        // SỬA LỖI: Cập nhật GROUP BY
        sql.append(" GROUP BY d.DepartmentID, m.FullName ");
        
        // Add sorting
        sql.append(" ORDER BY ");
        if (sortBy != null && !sortBy.isEmpty()) {
            switch (sortBy) {
                case "name":
                    sql.append("d.DeptName ASC");
                    break;
                case "employees":
                    sql.append("emp_count DESC");
                    break;
                case "created":
                    sql.append("d.CreatedAt DESC");
                    break;
                default:
                    sql.append("d.DeptName ASC");
            }
        } else {
            sql.append("d.DeptName ASC");
        }
        
        // Add pagination
        sql.append(" LIMIT ? OFFSET ?");
        paramsList.add(pageSize); // Thêm tham số limit
        paramsList.add(offset);   // Thêm tham số offset
        
        Connection conn = null;
        PreparedStatement psCount = null; // Dùng PreparedStatement
        PreparedStatement ps = null; // Dùng PreparedStatement
        ResultSet rsCount = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                throw new SQLException("Cannot connect to database");
            }
            
            // Get total count
            psCount = conn.prepareStatement(sqlCount.toString());
            // Set tham số cho count
            for (int i = 0; i < paramsCount.size(); i++) {
                psCount.setObject(i + 1, paramsCount.get(i));
            }
            rsCount = psCount.executeQuery();
            if (rsCount.next()) {
                total = rsCount.getInt("total");
            }

            // Get department list
            ps = conn.prepareStatement(sql.toString());
            // Set tham số cho list
            for (int i = 0; i < paramsList.size(); i++) {
                ps.setObject(i + 1, paramsList.get(i));
            }
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Department dept = new Department(
                    rs.getInt("DepartmentID"),
                    rs.getString("DeptName"),
                    rs.getObject("DeptManagerID") != null ? rs.getInt("DeptManagerID") : null
                );
                dept.setEmployeeCount(rs.getInt("emp_count"));
                dept.setStatus(rs.getString("Status"));
                dept.setCreatedAt(rs.getTimestamp("CreatedAt"));
                dept.setManagerName(rs.getString("ManagerName")); // Bây giờ sẽ hoạt động
                departmentList.add(dept);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading departments: " + e.getMessage());
        } finally {
            // Đóng resources theo thứ tự
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (rsCount != null) rsCount.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (psCount != null) psCount.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        int totalPages = (int) Math.ceil((double) total / pageSize);

        request.setAttribute("departmentList", departmentList);
        request.setAttribute("total", total);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("status", effectiveStatus); // Gửi effectiveStatus (sẽ là "all" nếu null)
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        
        request.getRequestDispatcher("Admin/Departments.jsp").forward(request, response);
    }

    private void saveDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String deptId = request.getParameter("deptId");
        String deptName = request.getParameter("deptName");
        String deptManagerId = request.getParameter("deptManagerId");

        if (deptName == null || deptName.trim().isEmpty()) {
            jakarta.servlet.http.HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Tên phòng ban là bắt buộc!");
            response.sendRedirect(request.getContextPath() + "/departments?action=departments");
            return;
        }

        Department dept = new Department();
        dept.setDeptName(deptName.trim());
        dept.setDeptManagerId(deptManagerId != null && !deptManagerId.isEmpty() ? Integer.parseInt(deptManagerId) : null);

        boolean success = false;
        String message = "";
        try {
            if (deptId == null || deptId.isEmpty()) {
                // Thêm mới
                success = departmentDAO.insert(dept);
                message = success ? "Phòng ban '" + deptName.trim() + "' đã được thêm." : "Không thể thêm phòng ban.";
            } else {
                // Cập nhật
                dept.setDepartmentId(Integer.parseInt(deptId));
                success = departmentDAO.update(dept);
                message = success ? "Phòng ban '" + deptName.trim() + "' đã được cập nhật." : "Không thể cập nhật phòng ban.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            success = false;
            message = "Đã xảy ra lỗi: " + e.getMessage();
        }

        jakarta.servlet.http.HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("successMessage", message);
        } else {
            session.setAttribute("errorMessage", message);
        }
        response.sendRedirect(request.getContextPath() + "/departments?action=departments");
    }

    private void editDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String deptId = request.getParameter("id");
        try {
            Department dept = departmentDAO.getById(Integer.parseInt(deptId));
            List<Employee> managerList = employeeDAO.getAll(); // Giả sử bạn có hàm này
            
            request.setAttribute("department", dept);
            request.setAttribute("managerList", managerList); // Gửi danh sách quản lý
            request.getRequestDispatcher("Admin/DepartmentForm.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Không thể tải chi tiết phòng ban.");
            response.sendRedirect(request.getContextPath() + "/departments?action=departments");
        }
    }

    private void deleteDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String deptId = request.getParameter("deptId");
        String message = "";
        boolean success = false;
        try {
            int id = Integer.parseInt(deptId);
            // Kiểm tra xem phòng ban còn nhân viên không
            if (employeeDAO.getEmployeeCountByDepartment(id) > 0) {
                message = "Không thể xóa phòng ban. Vẫn còn nhân viên trong phòng ban này.";
                success = false;
            } else {
                success = departmentDAO.delete(id);
                message = success ? "Phòng ban đã được xóa." : "Không thể xóa phòng ban.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Lỗi khi xóa phòng ban: " + e.getMessage();
            success = false;
        }

        jakarta.servlet.http.HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("successMessage", message);
        } else {
            session.setAttribute("errorMessage", message);
        }
        response.sendRedirect(request.getContextPath() + "/departments?action=departments");
    }

    private void manageDepartmentPermissions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String deptId = request.getParameter("id");
            Department dept = departmentDAO.getById(Integer.parseInt(deptId));
            // Logic để lấy quyền
            List<String> allPermissions = Arrays.asList("View Reports", "Manage Employees", "Edit Settings");
            List<String> currentPermissions = Arrays.asList("View Reports"); // Lấy quyền thực tế từ DB

            request.setAttribute("department", dept);
            request.setAttribute("allPermissions", allPermissions);
            request.setAttribute("currentPermissions", currentPermissions);
            request.getRequestDispatcher("Admin/DepartmentPermissions.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Failed to load department permissions.");
            listDepartments(request, response);
        }
    }

    private void savePermissions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String deptId = request.getParameter("deptId");
        String[] permissions = request.getParameterValues("permissions");

        try {
            int id = Integer.parseInt(deptId);
            String permissionList = permissions != null ? String.join(", ", permissions) : "None";
            System.out.println("Permissions saved for department " + id + ": " + permissionList); 
            String message = "Permissions updated successfully!";
            
            // SỬA LỖI: Dùng session để gửi thông báo qua redirect
            jakarta.servlet.http.HttpSession session = request.getSession();
            session.setAttribute("successMessage", message);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid department ID format.");
            e.printStackTrace();
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error saving permissions: " + e.getMessage());
            e.printStackTrace();
        }

        // SỬA LỖI: Sai đường dẫn, thiếu 's'
        response.sendRedirect(request.getContextPath() + "/departments?action=departments");
    }

    @Override
    public String getServletInfo() {
        return "Department Controller - Handles department management operations";
    }
}
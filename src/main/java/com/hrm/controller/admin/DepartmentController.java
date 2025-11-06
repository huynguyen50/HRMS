package com.hrm.controller.admin;

import com.hrm.dao.*;
import com.hrm.model.entity.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
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
        
        List<Department> departmentList;

        int page = 1;
        int pageSize = 10;
        try {
            String pageStr = request.getParameter("page");
            String sizeStr = request.getParameter("pageSize");
            if (pageStr != null) page = Math.max(1, Integer.parseInt(pageStr));
            if (sizeStr != null) pageSize = Math.max(1, Integer.parseInt(sizeStr));
        } catch (NumberFormatException ignore) {}

        try {
            int total = 0;
            int offset = (page - 1) * pageSize;
            
            // Build the SQL query based on filters
            StringBuilder sqlCount = new StringBuilder(
                "SELECT COUNT(*) as total FROM department d WHERE 1=1"
            );
            
            StringBuilder sql = new StringBuilder(
                "SELECT d.*, COUNT(e.EmployeeID) as emp_count " +
                "FROM department d " +
                "LEFT JOIN employee e ON d.DepartmentID = e.DepartmentID " +
                "WHERE 1=1"
            );
            
            // Add status filter
            if (!"all".equals(effectiveStatus)) {
                String statusCondition = " AND d.Status = '" + effectiveStatus + "'";
                sqlCount.append(statusCondition);
                sql.append(statusCondition);
            }
            
            // Add search filter
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String searchCondition = " AND d.DeptName LIKE '%" + searchKeyword.trim() + "%'";
                sqlCount.append(searchCondition);
                sql.append(searchCondition);
            }
            
            sql.append(" GROUP BY d.DepartmentID ");
            
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
            sql.append(" LIMIT ").append(pageSize).append(" OFFSET ").append(offset);
            
            Connection conn = null;
            Statement stCount = null;
            Statement st = null;
            ResultSet rsCount = null;
            ResultSet rs = null;
            
            try {
                conn = DBConnection.getConnection();
                if (conn == null) {
                    throw new SQLException("Cannot connect to database");
                }
                
                // Get total count
                stCount = conn.createStatement();
                rsCount = stCount.executeQuery(sqlCount.toString());
                if (rsCount.next()) {
                    total = rsCount.getInt("total");
                }
                
                // Get department list
                departmentList = new ArrayList<>();
                st = conn.createStatement();
                rs = st.executeQuery(sql.toString());
                
                while (rs.next()) {
                    Department dept = new Department(
                        rs.getInt("DepartmentID"),
                        rs.getString("DeptName"),
                        rs.getObject("DeptManagerID") != null ? rs.getInt("DeptManagerID") : null
                    );
                    dept.setEmployeeCount(rs.getInt("emp_count"));
                    departmentList.add(dept);
                }
            } catch (SQLException e) {
                throw new ServletException("Database error: " + e.getMessage(), e);
            } finally {
                // Đóng tất cả các resources theo thứ tự ngược lại
                try {
                    if (rs != null) rs.close();
                    if (st != null) st.close();
                    if (rsCount != null) rsCount.close();
                    if (stCount != null) stCount.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    Logger.getLogger(DepartmentController.class.getName())
                          .log(Level.SEVERE, "Error closing database resources", e);
                }
            }
            
            int totalPages = (int) Math.ceil(total / (double) pageSize);
            if (totalPages == 0) totalPages = 1;
            if (page > totalPages) page = totalPages;
            
            request.setAttribute("total", total);
            request.setAttribute("totalPages", totalPages);
        } catch (Exception e) {
            // Fallback to loading all departments if filtering/query fails
            departmentList = departmentDAO.getAll();
            request.setAttribute("errorMessage", "Search failed, showing all departments: " + e.getMessage());
            e.printStackTrace();

            // Ensure pagination attributes exist to avoid NPE in JSP
            int totalFallback = departmentList != null ? departmentList.size() : 0;
            int totalPagesFallback = (int) Math.ceil(totalFallback / (double) pageSize);
            if (totalPagesFallback == 0) totalPagesFallback = 1;
            request.setAttribute("total", totalFallback);
            request.setAttribute("totalPages", totalPagesFallback);
        }

        // Ensure employeeCount is accurate for each department
        if (departmentList != null) {
            for (Department d : departmentList) {
                try {
                    int count = employeeDAO.getEmployeeCountByDepartment(d.getDepartmentId());
                    d.setEmployeeCount(count);
                } catch (Exception ignore) {}
            }
        }

        List<Employee> managers = employeeDAO.getManagerList();
        List<Department> allDepartments = departmentDAO.getAll();

        request.setAttribute("departmentList", departmentList);
        request.setAttribute("allDepartments", allDepartments);
        request.setAttribute("managers", managers);
        request.setAttribute("searchKeyword", searchKeyword);
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
                success = departmentDAO.insert(dept);
                message = success ? "Phòng ban '" + deptName.trim() + "' đã được thêm thành công!" 
                                  : "Không thể thêm phòng ban '" + deptName.trim() + "'. Vui lòng thử lại.";
            } else {
                dept.setDepartmentId(Integer.parseInt(deptId));
                success = departmentDAO.update(dept);
                message = success ? "Phòng ban '" + deptName.trim() + "' đã được cập nhật thành công!" 
                                  : "Không thể cập nhật phòng ban '" + deptName.trim() + "'. Vui lòng thử lại.";
            }
        } catch (NumberFormatException e) {
            message = "Lỗi: ID phòng ban không hợp lệ.";
            e.printStackTrace();
        } catch (Exception e) {
            message = "Lỗi: " + e.getMessage();
            e.printStackTrace();
        }

        jakarta.servlet.http.HttpSession session = request.getSession();
        session.setAttribute(success ? "successMessage" : "errorMessage", message);
        
        response.sendRedirect(request.getContextPath() + "/departments?action=departments");
    }

    private void deleteDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String deptId = request.getParameter("deptId");
        String message = "";
        boolean success = false;

        try {
            int id = Integer.parseInt(deptId);
            
            Department dept = departmentDAO.getById(id);
            String deptName = dept != null ? dept.getDeptName() : "Phòng ban";
            
            int employeeCount = employeeDAO.getEmployeeCountByDepartment(id);
            if (employeeCount > 0) {
                message = "Không thể xóa phòng ban '" + deptName + "' vì nó có " + employeeCount + " nhân viên. Vui lòng chuyển nhân viên sang phòng ban khác trước.";
            } else {
                success = departmentDAO.delete(id);
                message = success ? "Phòng ban '" + deptName + "' đã được xóa thành công!" 
                                  : "Không thể xóa phòng ban '" + deptName + "'. Vui lòng thử lại.";
            }
        } catch (NumberFormatException e) {
            message = "Lỗi: ID phòng ban không hợp lệ.";
            e.printStackTrace();
        } catch (Exception e) {
            message = "Lỗi: " + e.getMessage();
            e.printStackTrace();
        }

        jakarta.servlet.http.HttpSession session = request.getSession();
        session.setAttribute(success ? "successMessage" : "errorMessage", message);
        
        response.sendRedirect(request.getContextPath() + "/departments?action=departments");
    }

    private void editDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String deptId = request.getParameter("id");
        try {
            Department dept = departmentDAO.getById(Integer.parseInt(deptId));
            request.setAttribute("department", dept);
            request.getRequestDispatcher("Admin/DepartmentForm.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Failed to load department.");
            listDepartments(request, response);
        }
    }

    private void manageDepartmentPermissions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String deptId = request.getParameter("id");
        try {
            Department dept = departmentDAO.getById(Integer.parseInt(deptId));
            request.setAttribute("department", dept);
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
            request.setAttribute("successMessage", message);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid department ID format.");
            e.printStackTrace();
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error saving permissions: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/department?action=departments");
    }

    @Override
    public String getServletInfo() {
        return "Department Controller - Handles department management operations";
    }
}

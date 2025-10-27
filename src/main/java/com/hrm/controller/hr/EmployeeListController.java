/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.hrm.controller.hr;

import com.hrm.dao.EmployeeDAO;
import com.hrm.dao.DepartmentDAO;
import com.hrm.model.entity.Employee;
import com.hrm.model.entity.Department;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
@WebServlet(name="EmployeeListController", urlPatterns={"/hr/employee-list"})
public class EmployeeListController extends HttpServlet {
   
    private EmployeeDAO employeeDAO = new EmployeeDAO();
    private DepartmentDAO departmentDAO = new DepartmentDAO();
    
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if EmployeeListController servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Get filter parameters
            String searchKeyword = request.getParameter("search");
            String statusFilter = request.getParameter("status");
            String departmentFilter = request.getParameter("department");
            String positionFilter = request.getParameter("position");
            
            // Get pagination parameters
            int page = 1;
            int pageSize = 10;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.trim().isEmpty()) {
                    page = Integer.parseInt(pageParam);
                }
                String pageSizeParam = request.getParameter("pageSize");
                if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
                    pageSize = Integer.parseInt(pageSizeParam);
                }
            } catch (NumberFormatException e) {
                // Use default values if parsing fails
            }
            
            // Calculate offset
            int offset = (page - 1) * pageSize;
            
            List<Employee> employees;
            int totalCount;
            
            // Apply filters and get employees
            if (hasFilters(searchKeyword, statusFilter, departmentFilter, positionFilter)) {
                employees = getFilteredEmployees(searchKeyword, statusFilter, departmentFilter, positionFilter, offset, pageSize);
                totalCount = getFilteredEmployeesCount(searchKeyword, statusFilter, departmentFilter, positionFilter);
            } else {
                employees = employeeDAO.getPaged(offset, pageSize);
                totalCount = employeeDAO.getTotalEmployeesCount();
            }
            
            // Get departments for filter dropdown
            List<Department> departments = departmentDAO.getAll();
            
            // Calculate pagination info
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            
            // Set attributes
            request.setAttribute("employees", employees);
            request.setAttribute("departments", departments);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("searchKeyword", searchKeyword);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("departmentFilter", departmentFilter);
            request.setAttribute("positionFilter", positionFilter);
            
            // Check for success/error messages in session
            jakarta.servlet.http.HttpSession session = request.getSession(false);
            if (session != null) {
                String successMessage = (String) session.getAttribute("success");
                String errorMessage = (String) session.getAttribute("error");
                
                if (successMessage != null) {
                    request.setAttribute("success", successMessage);
                    session.removeAttribute("success");
                }
                if (errorMessage != null) {
                    request.setAttribute("error", errorMessage);
                    session.removeAttribute("error");
                }
            }
            
            // Forward to EmployeeList.jsp
            request.getRequestDispatcher("/Views/hr/EmployeeList.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading employee list: " + e.getMessage());
            request.getRequestDispatcher("/Views/hr/EmployeeList.jsp").forward(request, response);
        }
    }
    
    private boolean hasFilters(String searchKeyword, String statusFilter, String departmentFilter, String positionFilter) {
        return (searchKeyword != null && !searchKeyword.trim().isEmpty()) ||
               (statusFilter != null && !statusFilter.trim().isEmpty()) ||
               (departmentFilter != null && !departmentFilter.trim().isEmpty()) ||
               (positionFilter != null && !positionFilter.trim().isEmpty());
    }
    
    private List<Employee> getFilteredEmployees(String searchKeyword, String statusFilter, String departmentFilter, String positionFilter, int offset, int pageSize) {
        // For now, use the existing search method and filter in memory
        // In a production environment, you'd want to modify the DAO to handle complex filtering
        List<Employee> allEmployees = employeeDAO.getAll();
        
        // Apply filters
        return allEmployees.stream()
            .filter(emp -> searchKeyword == null || searchKeyword.trim().isEmpty() || 
                    emp.getFullName().toLowerCase().contains(searchKeyword.toLowerCase()) ||
                    emp.getEmail().toLowerCase().contains(searchKeyword.toLowerCase()) ||
                    emp.getPosition().toLowerCase().contains(searchKeyword.toLowerCase()) ||
                    (emp.getDepartmentName() != null && emp.getDepartmentName().toLowerCase().contains(searchKeyword.toLowerCase())))
            .filter(emp -> statusFilter == null || statusFilter.trim().isEmpty() || 
                    emp.getStatus().equals(statusFilter))
            .filter(emp -> departmentFilter == null || departmentFilter.trim().isEmpty() || 
                    String.valueOf(emp.getDepartmentId()).equals(departmentFilter))
            .filter(emp -> positionFilter == null || positionFilter.trim().isEmpty() || 
                    emp.getPosition().toLowerCase().contains(positionFilter.toLowerCase()))
            .skip(offset)
            .limit(pageSize)
            .collect(java.util.stream.Collectors.toList());
    }
    
    private int getFilteredEmployeesCount(String searchKeyword, String statusFilter, String departmentFilter, String positionFilter) {
        List<Employee> allEmployees = employeeDAO.getAll();
        
        return (int) allEmployees.stream()
            .filter(emp -> searchKeyword == null || searchKeyword.trim().isEmpty() || 
                    emp.getFullName().toLowerCase().contains(searchKeyword.toLowerCase()) ||
                    emp.getEmail().toLowerCase().contains(searchKeyword.toLowerCase()) ||
                    emp.getPosition().toLowerCase().contains(searchKeyword.toLowerCase()) ||
                    (emp.getDepartmentName() != null && emp.getDepartmentName().toLowerCase().contains(searchKeyword.toLowerCase())))
            .filter(emp -> statusFilter == null || statusFilter.trim().isEmpty() || 
                    emp.getStatus().equals(statusFilter))
            .filter(emp -> departmentFilter == null || departmentFilter.trim().isEmpty() || 
                    String.valueOf(emp.getDepartmentId()).equals(departmentFilter))
            .filter(emp -> positionFilter == null || positionFilter.trim().isEmpty() || 
                    emp.getPosition().toLowerCase().contains(positionFilter.toLowerCase()))
            .count();
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if EmployeeListController servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if EmployeeListController servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            System.out.println("POST request received with action: " + action);
            
            if ("updateStatus".equals(action)) {
                handleStatusUpdate(request, response);
            } else if ("editEmployee".equals(action)) {
                handleEmployeeEdit(request, response);
            } else {
                System.out.println("Unknown action: " + action);
                processRequest(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            processRequest(request, response);
        }
    }
    
    private void handleStatusUpdate(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            int employeeId = Integer.parseInt(request.getParameter("employeeId"));
            String newStatus = request.getParameter("status");
            
            System.out.println("Updating status for employee ID: " + employeeId + " to: " + newStatus);
            boolean success = employeeDAO.updateEmployeeStatus(employeeId, newStatus);
            
            jakarta.servlet.http.HttpSession session = request.getSession();
            if (success) {
                session.setAttribute("success", "Employee status updated successfully!");
                System.out.println("Status update successful");
            } else {
                session.setAttribute("error", "Failed to update employee status!");
                System.out.println("Status update failed");
            }
            
            response.sendRedirect(request.getContextPath() + "/hr/employee-list");
            
        } catch (Exception e) {
            e.printStackTrace();
            jakarta.servlet.http.HttpSession session = request.getSession();
            session.setAttribute("error", "Error updating employee status: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/hr/employee-list");
        }
    }
    
    private void handleEmployeeEdit(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            String employeeIdStr = request.getParameter("employeeId");
            System.out.println("Received employeeId parameter: " + employeeIdStr);
            
            if (employeeIdStr == null || employeeIdStr.trim().isEmpty()) {
                jakarta.servlet.http.HttpSession session = request.getSession();
                session.setAttribute("error", "Employee ID is missing!");
                response.sendRedirect(request.getContextPath() + "/hr/employee-list");
                return;
            }
            
            int employeeId = Integer.parseInt(employeeIdStr);
            System.out.println("Parsed employeeId: " + employeeId);
            
            Employee employee = employeeDAO.getById(employeeId);
            System.out.println("Found employee: " + (employee != null ? employee.getFullName() : "null"));
            
            if (employee != null) {
                // Update employee information (excluding position since it's readonly)
                employee.setFullName(request.getParameter("fullName"));
                employee.setEmail(request.getParameter("email"));
                employee.setPhone(request.getParameter("phone"));
                
                // Handle start and end dates
                String startDate = request.getParameter("startDate");
                String endDate = request.getParameter("endDate");
                String employmentPeriod = "";
                if (startDate != null && !startDate.trim().isEmpty()) {
                    employmentPeriod = startDate;
                    if (endDate != null && !endDate.trim().isEmpty()) {
                        employmentPeriod += " - " + endDate;
                    }
                }
                employee.setEmploymentPeriod(employmentPeriod);
                
                System.out.println("Updating employee with:");
                System.out.println("FullName: " + employee.getFullName());
                System.out.println("Email: " + employee.getEmail());
                System.out.println("Phone: " + employee.getPhone());
                System.out.println("StartDate: " + startDate);
                System.out.println("EndDate: " + endDate);
                System.out.println("EmploymentPeriod: " + employee.getEmploymentPeriod());
                System.out.println("Position (unchanged): " + employee.getPosition());
                
                boolean success = employeeDAO.updateEmployeeInfo(employee);
                System.out.println("EmployeeDAO.updateEmployeeInfo result: " + success);
                
                jakarta.servlet.http.HttpSession session = request.getSession();
                if (success) {
                    session.setAttribute("success", "Employee information updated successfully!");
                    System.out.println("Success message set in session");
                } else {
                    session.setAttribute("error", "Failed to update employee information!");
                    System.out.println("Error message set in session");
                }
            } else {
                jakarta.servlet.http.HttpSession session = request.getSession();
                session.setAttribute("error", "Employee not found!");
                System.out.println("Employee not found for ID: " + employeeId);
            }
            
            response.sendRedirect(request.getContextPath() + "/hr/employee-list");
            
        } catch (Exception e) {
            e.printStackTrace();
            jakarta.servlet.http.HttpSession session = request.getSession();
            session.setAttribute("error", "Error updating employee: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/hr/employee-list");
        }
    }

    /** 
     * Returns EmployeeListController short description of the servlet.
     * @return EmployeeListController String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Employee List Controller";
    }// </editor-fold>

}

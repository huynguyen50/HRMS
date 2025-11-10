/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.hrm.controller.hr;

import com.hrm.dao.EmployeeDAO;
import com.hrm.dao.DepartmentDAO;
import com.hrm.dao.PayrollDAO;
import com.hrm.model.entity.Employee;
import com.hrm.model.entity.Department;
import com.hrm.model.entity.SystemUser;
import com.hrm.util.PermissionUtil;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author admin
 */
@WebServlet(name="ProfileManagementController", urlPatterns={"/ProfileManagementController"})
public class ProfileManagementController extends HttpServlet {
   
    private EmployeeDAO employeeDAO = new EmployeeDAO();
    private DepartmentDAO departmentDAO = new DepartmentDAO();
    private PayrollDAO payrollDAO = new PayrollDAO();
    
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Kiểm tra quyền xem employees
        HttpSession session = request.getSession();
        SystemUser currentUser = (SystemUser) session.getAttribute("systemUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
            return;
        }
        
        if (!PermissionUtil.hasPermission(currentUser, "VIEW_EMPLOYEES")) {
            PermissionUtil.redirectToAccessDenied(request, response, "VIEW_EMPLOYEES", "View Employees");
            return;
        }
        
        try {
            System.out.println("ProfileManagementController: Starting processRequest...");
            
            // Get all employees with their department information
            List<Employee> employees = employeeDAO.getAll();
            System.out.println("ProfileManagementController: Loaded " + employees.size() + " employees");
            
            // Get all departments for dropdown
            List<Department> departments = departmentDAO.getAll();
            System.out.println("ProfileManagementController: Loaded " + departments.size() + " departments");
            
            // Check if we need to load payroll data (when section=payroll-management)
            String section = request.getParameter("section");
            String payrollStatus = request.getParameter("payrollStatus");
            String employeeFilter = request.getParameter("employeeFilter");
            String monthFilter = request.getParameter("monthFilter");
            
            // Always load payroll counts for the status tabs
            int pendingCount = payrollDAO.getTotalPayrollCount(null, "Pending");
            int approvedCount = payrollDAO.getTotalPayrollCount(null, "Approved");
            int rejectedCount = payrollDAO.getTotalPayrollCount(null, "Rejected");
            int paidCount = payrollDAO.getTotalPayrollCount(null, "Paid");
            
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("approvedCount", approvedCount);
            request.setAttribute("rejectedCount", rejectedCount);
            request.setAttribute("paidCount", paidCount);
            
            // Load payroll data if section is payroll-management or payrollStatus is provided
            if ("payroll-management".equals(section) || payrollStatus != null) {
                // Load payroll data
                if (payrollStatus == null || payrollStatus.trim().isEmpty()) {
                    payrollStatus = "Pending";
                }
                
                Integer employeeId = null;
                if (employeeFilter != null && !employeeFilter.trim().isEmpty()) {
                    try {
                        employeeId = Integer.parseInt(employeeFilter);
                    } catch (NumberFormatException e) {
                        // Invalid employee ID, ignore
                    }
                }
                
                // Get payrolls by status
                List<Map<String, Object>> payrolls = payrollDAO.getAll(employeeId, payrollStatus);
                
                // Filter by month if provided
                if (monthFilter != null && !monthFilter.trim().isEmpty()) {
                    payrolls.removeIf(p -> !monthFilter.equals(p.get("payPeriod")));
                }
                
                request.setAttribute("payrolls", payrolls);
                request.setAttribute("payrollStatus", payrollStatus);
                request.setAttribute("payrollEmployeeFilter", employeeFilter);
                request.setAttribute("payrollMonthFilter", monthFilter);
            } else {
                // Initialize empty lists if not loading payroll data
                request.setAttribute("payrolls", new java.util.ArrayList<>());
                request.setAttribute("payrollStatus", "Pending");
                request.setAttribute("payrollEmployeeFilter", "");
                request.setAttribute("payrollMonthFilter", "");
            }
            
            // Set attributes for JSP
            request.setAttribute("employees", employees);
            request.setAttribute("departments", departments);
            request.setAttribute("section", section != null ? section : "hr-home");
            request.setAttribute("controllerMessage", "ProfileManagementController executed successfully!");
            
            System.out.println("ProfileManagementController: Forwarding to HrHome.jsp");
            
            // Forward to HrHome.jsp
            request.getRequestDispatcher("/Views/hr/HrHome.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("ProfileManagementController: Error occurred: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading employee data: " + e.getMessage());
            request.getRequestDispatcher("/Views/hr/HrHome.jsp").forward(request, response);
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
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
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

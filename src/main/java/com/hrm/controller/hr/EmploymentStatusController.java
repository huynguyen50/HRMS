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
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
@WebServlet(name="EmploymentStatusController", urlPatterns={"/EmploymentStatusController"})
public class EmploymentStatusController extends HttpServlet {
   
    private EmployeeDAO employeeDAO = new EmployeeDAO();
    private DepartmentDAO departmentDAO = new DepartmentDAO();
    
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Get all employees excluding admin users
            List<Employee> allEmployees = employeeDAO.getAll();
            List<Employee> employees = new ArrayList<>();
            
            // Filter out admin users (RoleID = 1)
            for (Employee emp : allEmployees) {
                if (emp.getSystemUser() != null && 
                    emp.getSystemUser().getRole() != null && 
                    !"Admin".equalsIgnoreCase(emp.getSystemUser().getRole().getRoleName())) {
                    employees.add(emp);
                }
            }
            
            // Get all departments for dropdown
            List<Department> departments = departmentDAO.getAll();
            
            // Set attributes for JSP
            request.setAttribute("employees", employees);
            request.setAttribute("departments", departments);
            
            // Forward to EmploymentStatus.jsp
            request.getRequestDispatcher("/Views/hr/EmploymentStatus.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading employment status data: " + e.getMessage());
            request.getRequestDispatcher("/Views/hr/EmploymentStatus.jsp").forward(request, response);
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
        try {
            String action = request.getParameter("action");
            
            if ("updateStatus".equals(action)) {
                int employeeId = Integer.parseInt(request.getParameter("employeeId"));
                String newStatus = request.getParameter("status");
                
                boolean success = employeeDAO.updateEmployeeStatus(employeeId, newStatus);
                
                if (success) {
                    request.setAttribute("success", "Employee status updated successfully!");
                } else {
                    request.setAttribute("error", "Failed to update employee status!");
                }
            }
            
            // Redirect back to EmploymentStatusController to reload data
            response.sendRedirect(request.getContextPath() + "/EmploymentStatusController");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating employee status: " + e.getMessage());
            processRequest(request, response);
        }
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

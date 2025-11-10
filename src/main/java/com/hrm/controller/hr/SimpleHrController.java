/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.hrm.controller.hr;

import com.hrm.dao.EmployeeDAO;
import com.hrm.dao.DepartmentDAO;
import com.hrm.model.entity.Employee;
import com.hrm.model.entity.Department;
import com.hrm.model.entity.SystemUser;
import com.hrm.util.PermissionUtil;
import java.io.IOException;
import java.util.List;
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
@WebServlet(name="SimpleHrController", urlPatterns={"/SimpleHrController"})
public class SimpleHrController extends HttpServlet {
   
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
            System.out.println("SimpleHrController: Starting...");
            
            // Get all employees with their department information
            List<Employee> employees = employeeDAO.getAll();
            System.out.println("SimpleHrController: Loaded " + employees.size() + " employees");
            
            // Get all departments for dropdown
            List<Department> departments = departmentDAO.getAll();
            System.out.println("SimpleHrController: Loaded " + departments.size() + " departments");
            
            // Set attributes for JSP
            request.setAttribute("employees", employees);
            request.setAttribute("departments", departments);
            request.setAttribute("controllerMessage", "SimpleHrController executed successfully!");
            
            System.out.println("SimpleHrController: Forwarding to HrHomeSimple.jsp");
            
            // Forward to HrHomeSimple.jsp
            request.getRequestDispatcher("/Views/hr/HrHomeSimple.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("SimpleHrController: Error occurred: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading data: " + e.getMessage());
            request.getRequestDispatcher("/Views/hr/HrHomeSimple.jsp").forward(request, response);
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Simple HR Controller";
    }
}




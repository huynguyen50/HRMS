package com.hrm.controller.hrstaff;

import com.hrm.dao.EmployeeAllowanceDAO;
import com.hrm.util.PermissionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * Controller for Employee Allowance
 * Handles POST /hrstaff/payroll/allowance - Create/Update allowance
 * @author admin
 */
@WebServlet(name = "PayrollAllowanceController", urlPatterns = {"/hrstaff/payroll/allowance", "/hrstaff/payroll/allowance/delete"})
public class PayrollAllowanceController extends HttpServlet {

    private final EmployeeAllowanceDAO employeeAllowanceDAO = new EmployeeAllowanceDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureAccess(request, response)) {
            return;
        }
        try {
            String allowanceIdStr = request.getParameter("allowanceId");
            String employeeIdStr = request.getParameter("employeeId");
            String allowanceTypeIdStr = request.getParameter("allowanceTypeId");
            String amountStr = request.getParameter("amount");
            String month = request.getParameter("month");

            // Validate required fields
            if (employeeIdStr == null || allowanceTypeIdStr == null || amountStr == null || month == null) {
                request.setAttribute("error", "Missing required fields");
                response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=allowance");
                return;
            }

            int employeeId = Integer.parseInt(employeeIdStr);
            int allowanceTypeId = Integer.parseInt(allowanceTypeIdStr);
            BigDecimal amount = new BigDecimal(amountStr);

            boolean success;
            if (allowanceIdStr != null && !allowanceIdStr.trim().isEmpty()) {
                // Update existing allowance
                int allowanceId = Integer.parseInt(allowanceIdStr);
                success = employeeAllowanceDAO.update(allowanceId, allowanceTypeId, amount, month);
            } else {
                // Create new allowance
                success = employeeAllowanceDAO.create(employeeId, allowanceTypeId, amount, month);
            }

            if (success) {
                request.getSession().setAttribute("success", "Allowance saved successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to save allowance.");
            }

            response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=allowance");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error processing allowance: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=allowance");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureAccess(request, response)) {
            return;
        }
        String path = request.getServletPath();
        if (path != null && path.contains("/delete")) {
            doDelete(request, response);
        }
    }
    
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureAccess(request, response)) {
            return;
        }
        try {
            String allowanceIdStr = request.getParameter("allowanceId");
            if (allowanceIdStr == null) {
                request.getSession().setAttribute("error", "Missing allowance ID");
                response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=allowance");
                return;
            }
            
            int allowanceId = Integer.parseInt(allowanceIdStr);
            boolean success = employeeAllowanceDAO.delete(allowanceId);
            
            if (success) {
                request.getSession().setAttribute("success", "Allowance deleted successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to delete allowance.");
            }
            
            response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=allowance");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error deleting allowance: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=allowance");
        }
    }

    private boolean ensureAccess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        return PermissionUtil.ensureRolePermission(
                request,
                response,
                PermissionUtil.ROLE_HR_STAFF,
                "VIEW_PAYROLLS",
                "This page is restricted to HR Staff.",
                "You do not have permission to manage payroll allowances."
        );
    }
}


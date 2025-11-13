package com.hrm.controller.hrstaff;

import com.hrm.dao.EmployeeDeductionDAO;
import com.hrm.util.PermissionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * Controller for Employee Deduction
 * Handles POST /hrstaff/payroll/deduction - Create/Update deduction
 * @author admin
 */
@WebServlet(name = "PayrollDeductionController", urlPatterns = {"/hrstaff/payroll/deduction", "/hrstaff/payroll/deduction/delete"})
public class PayrollDeductionController extends HttpServlet {

    private final EmployeeDeductionDAO employeeDeductionDAO = new EmployeeDeductionDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureAccess(request, response)) {
            return;
        }
        try {
            String deductionIdStr = request.getParameter("deductionId");
            String employeeIdStr = request.getParameter("employeeId");
            String deductionTypeIdStr = request.getParameter("deductionTypeId");
            String amountStr = request.getParameter("amount");
            String month = request.getParameter("month");

            // Validate required fields
            if (employeeIdStr == null || deductionTypeIdStr == null || amountStr == null || month == null) {
                request.setAttribute("error", "Missing required fields");
                response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=deduction");
                return;
            }

            int employeeId = Integer.parseInt(employeeIdStr);
            int deductionTypeId = Integer.parseInt(deductionTypeIdStr);
            BigDecimal amount = new BigDecimal(amountStr);

            boolean success;
            if (deductionIdStr != null && !deductionIdStr.trim().isEmpty()) {
                // Update existing deduction
                int deductionId = Integer.parseInt(deductionIdStr);
                success = employeeDeductionDAO.update(deductionId, deductionTypeId, amount, month);
            } else {
                // Create new deduction
                success = employeeDeductionDAO.create(employeeId, deductionTypeId, amount, month);
            }

            if (success) {
                request.getSession().setAttribute("success", "Deduction saved successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to save deduction.");
            }

            response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=deduction");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error processing deduction: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=deduction");
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
            String deductionIdStr = request.getParameter("deductionId");
            if (deductionIdStr == null) {
                request.getSession().setAttribute("error", "Missing deduction ID");
                response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=deduction");
                return;
            }
            
            int deductionId = Integer.parseInt(deductionIdStr);
            boolean success = employeeDeductionDAO.delete(deductionId);
            
            if (success) {
                request.getSession().setAttribute("success", "Deduction deleted successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to delete deduction.");
            }
            
            response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=deduction");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error deleting deduction: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=deduction");
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
                "You do not have permission to manage payroll deductions."
        );
    }
}


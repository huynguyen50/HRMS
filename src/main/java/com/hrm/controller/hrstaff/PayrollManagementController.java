package com.hrm.controller.hrstaff;

import com.hrm.dao.*;
import com.hrm.model.entity.Employee;
import com.hrm.model.entity.Payroll;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * Controller for Payroll Management
 * Handles GET /hrstaff/payroll - Display payroll management page
 * Handles POST /hrstaff/payroll - Create/Update payroll
 * @author admin
 */
@WebServlet(name = "PayrollManagementController", urlPatterns = {"/hrstaff/payroll", "/hrstaff/payroll/delete", "/hrstaff/payroll/submit"})
public class PayrollManagementController extends HttpServlet {

    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final AllowanceTypeDAO allowanceTypeDAO = new AllowanceTypeDAO();
    private final EmployeeAllowanceDAO employeeAllowanceDAO = new EmployeeAllowanceDAO();
    private final DeductionTypeDAO deductionTypeDAO = new DeductionTypeDAO();
    private final EmployeeDeductionDAO employeeDeductionDAO = new EmployeeDeductionDAO();
    private final PayrollDAO payrollDAO = new PayrollDAO();


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            
            if ("save".equals(action) || "submit".equals(action)) {
                // Get parameters
                String payrollIdStr = request.getParameter("payrollId");
                String employeeIdStr = request.getParameter("employeeId");
                String payPeriod = request.getParameter("payPeriod");
                String baseSalaryStr = request.getParameter("baseSalary");
                String allowanceStr = request.getParameter("allowance");
                String bonusStr = request.getParameter("bonus");
                String deductionStr = request.getParameter("deduction");
                String netSalaryStr = request.getParameter("netSalary");

                // Validate required fields
                if (employeeIdStr == null || payPeriod == null || baseSalaryStr == null) {
                    request.setAttribute("error", "Missing required fields");
                    doGet(request, response);
                    return;
                }

                int employeeId = Integer.parseInt(employeeIdStr);
                BigDecimal baseSalary = new BigDecimal(baseSalaryStr);
                BigDecimal allowance = new BigDecimal(allowanceStr != null ? allowanceStr : "0");
                BigDecimal bonus = new BigDecimal(bonusStr != null ? bonusStr : "0");
                BigDecimal deduction = new BigDecimal(deductionStr != null ? deductionStr : "0");
                BigDecimal netSalary = new BigDecimal(netSalaryStr != null ? netSalaryStr : "0");

                Payroll payroll = new Payroll();
                
                if (payrollIdStr != null && !payrollIdStr.trim().isEmpty()) {
                    // Update existing payroll
                    int payrollId = Integer.parseInt(payrollIdStr);
                    Payroll existing = payrollDAO.getById(payrollId);
                    if (existing == null) {
                        request.setAttribute("error", "Payroll not found.");
                        doGet(request, response);
                        return;
                    }
                    // Note: Status check is done in DAO update method
                    payroll.setPayrollId(payrollId);
                } else {
                    // Check if payroll already exists for this employee and period
                    if (payrollDAO.exists(employeeId, payPeriod)) {
                        request.setAttribute("error", "Payroll already exists for this employee and period.");
                        doGet(request, response);
                        return;
                    }
                }

                payroll.setEmployeeId(employeeId);
                payroll.setPayPeriod(payPeriod);
                payroll.setBaseSalary(baseSalary);
                payroll.setAllowance(allowance);
                payroll.setBonus(bonus);
                payroll.setDeduction(deduction);
                payroll.setNetSalary(netSalary);

                boolean success;
                int finalPayrollId = 0;
                
                if (payroll.getPayrollId() > 0) {
                    // Update existing payroll
                    success = payrollDAO.update(payroll);
                    finalPayrollId = payroll.getPayrollId();
                } else {
                    // Create new payroll
                    finalPayrollId = payrollDAO.create(payroll);
                    success = (finalPayrollId > 0);
                }

                if (success && "submit".equals(action)) {
                    // Submit for approval
                    if (finalPayrollId > 0) {
                        payrollDAO.updateStatus(finalPayrollId, "Pending");
                        request.setAttribute("success", "Payroll submitted for approval successfully!");
                    } else {
                        request.setAttribute("error", "Failed to submit payroll. Payroll ID not found.");
                    }
                } else if (success) {
                    request.setAttribute("success", "Payroll saved successfully!");
                } else {
                    request.setAttribute("error", "Failed to save payroll.");
                }
            }

            // Reload page
            doGet(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing payroll: " + e.getMessage());
            doGet(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if (path != null && path.contains("/delete")) {
            handleDelete(request, response);
        } else if (path != null && path.contains("/submit")) {
            handleSubmit(request, response);
        } else {
            handleGet(request, response);
        }
    }
    
    private void handleGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get filter parameters
            String employeeFilter = request.getParameter("employeeFilter");
            String statusFilter = request.getParameter("statusFilter");
            
            Integer employeeId = null;
            if (employeeFilter != null && !employeeFilter.trim().isEmpty()) {
                try {
                    employeeId = Integer.parseInt(employeeFilter);
                } catch (NumberFormatException e) {
                    // Invalid employee ID, ignore
                }
            }

            // Load all employees for dropdown
            List<Employee> employees = employeeDAO.getAll();
            
            // Load allowance types
            List<Map<String, Object>> allowanceTypes = allowanceTypeDAO.getAll();
            
            // Load deduction types
            List<Map<String, Object>> deductionTypes = deductionTypeDAO.getAll();
            
            // Load allowances (with filters)
            String allowanceMonth = request.getParameter("allowanceMonth");
            List<Map<String, Object>> allowances = employeeAllowanceDAO.getAll(
                employeeId, allowanceMonth
            );
            
            // Load deductions (with filters)
            String deductionMonth = request.getParameter("deductionMonth");
            List<Map<String, Object>> deductions = employeeDeductionDAO.getAll(
                employeeId, deductionMonth
            );
            
            // Load payrolls (with filters)
            List<Map<String, Object>> payrolls = payrollDAO.getAll(employeeId, statusFilter);

            // Set attributes
            request.setAttribute("employees", employees);
            request.setAttribute("allowanceTypes", allowanceTypes);
            request.setAttribute("deductionTypes", deductionTypes);
            request.setAttribute("allowances", allowances);
            request.setAttribute("deductions", deductions);
            request.setAttribute("payrolls", payrolls);
            request.setAttribute("employeeFilter", employeeFilter);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("allowanceMonth", allowanceMonth);
            request.setAttribute("deductionMonth", deductionMonth);

            // Forward to JSP
            request.getRequestDispatcher("/Views/HrStaff/PayrollManagement.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading payroll data: " + e.getMessage());
            request.getRequestDispatcher("/Views/HrStaff/PayrollManagement.jsp").forward(request, response);
        }
    }
    
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String payrollIdStr = request.getParameter("payrollId");
            if (payrollIdStr == null) {
                request.getSession().setAttribute("error", "Missing payroll ID");
                response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=payroll");
                return;
            }
            
            int payrollId = Integer.parseInt(payrollIdStr);
            boolean success = payrollDAO.delete(payrollId);
            
            if (success) {
                request.getSession().setAttribute("success", "Payroll deleted successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to delete payroll. Only Draft payrolls can be deleted.");
            }
            
            response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=payroll");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error deleting payroll: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=payroll");
        }
    }
    
    private void handleSubmit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String payrollIdStr = request.getParameter("payrollId");
            if (payrollIdStr == null) {
                request.getSession().setAttribute("error", "Missing payroll ID");
                response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=payroll");
                return;
            }
            
            int payrollId = Integer.parseInt(payrollIdStr);
            Payroll payroll = payrollDAO.getById(payrollId);
            
            if (payroll == null) {
                request.getSession().setAttribute("error", "Payroll not found.");
                response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=payroll");
                return;
            }
            
            if (payroll.getStatus() == null || !"Draft".equals(payroll.getStatus())) {
                request.getSession().setAttribute("error", "Only Draft payrolls can be submitted.");
                response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=payroll");
                return;
            }
            
            boolean success = payrollDAO.updateStatus(payrollId, "Pending");
            
            if (success) {
                request.getSession().setAttribute("success", "Payroll submitted for approval successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to submit payroll.");
            }
            
            response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=payroll");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error submitting payroll: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=payroll");
        }
    }
}


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
@WebServlet(name = "PayrollManagementController", urlPatterns = {"/hrstaff/payroll", "/hrstaff/payroll/delete", "/hrstaff/payroll/submit", "/hrstaff/payroll/generate-all"})
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
                // Note: baseSalary is contract base salary (for reference)
                // actualBaseSalary is the calculated actual base salary (based on attendance)
                String baseSalaryStr = request.getParameter("baseSalary");
                String actualBaseSalaryStr = request.getParameter("actualBaseSalary");
                String otSalaryStr = request.getParameter("otSalary");
                String allowanceStr = request.getParameter("allowance");
                String deductionStr = request.getParameter("deduction");
                String netSalaryStr = request.getParameter("netSalary");

                // Validate required fields
                if (employeeIdStr == null || payPeriod == null) {
                    request.setAttribute("error", "Missing required fields");
                    doGet(request, response);
                    return;
                }

                int employeeId = Integer.parseInt(employeeIdStr);
                // Use actualBaseSalary if provided, otherwise fall back to baseSalary
                BigDecimal actualBaseSalary = (actualBaseSalaryStr != null && !actualBaseSalaryStr.trim().isEmpty()) 
                    ? new BigDecimal(actualBaseSalaryStr) 
                    : (baseSalaryStr != null && !baseSalaryStr.trim().isEmpty() 
                        ? new BigDecimal(baseSalaryStr) 
                        : BigDecimal.ZERO);
                BigDecimal otSalary = (otSalaryStr != null && !otSalaryStr.trim().isEmpty()) 
                    ? new BigDecimal(otSalaryStr) 
                    : BigDecimal.ZERO;
                BigDecimal allowance = (allowanceStr != null && !allowanceStr.trim().isEmpty()) 
                    ? new BigDecimal(allowanceStr) 
                    : BigDecimal.ZERO;
                BigDecimal deduction = (deductionStr != null && !deductionStr.trim().isEmpty()) 
                    ? new BigDecimal(deductionStr) 
                    : BigDecimal.ZERO;
                BigDecimal netSalary = (netSalaryStr != null && !netSalaryStr.trim().isEmpty()) 
                    ? new BigDecimal(netSalaryStr) 
                    : BigDecimal.ZERO;

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
                // Store actualBaseSalary in BaseSalary field (as per stored procedure logic)
                payroll.setBaseSalary(actualBaseSalary);
                payroll.setAllowance(allowance);
                // Store otSalary in Bonus field (as per stored procedure logic)
                payroll.setBonus(otSalary);
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
        } else if (path != null && path.contains("/generate-all")) {
            handleGenerateAll(request, response);
        } else {
            handleGet(request, response);
        }
    }
    
    private static final int DEFAULT_PAGE_SIZE = 10;
    
    private void handleGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get tab parameter (default to 'allowance')
            String tab = request.getParameter("tab");
            if (tab == null || tab.trim().isEmpty()) {
                tab = "allowance";
            }
            // Validate tab value
            if (!tab.matches("^(allowance|deduction|attendance|payroll)$")) {
                tab = "allowance";
            }
            
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
            
            // Load payrolls with pagination (only for payroll tab)
            List<Map<String, Object>> payrolls;
            int totalPayrolls = 0;
            int totalPages = 1;
            int page = 1;
            int pageSize = DEFAULT_PAGE_SIZE;
            String sortBy = "PayPeriod";
            String sortOrder = "DESC";
            
            if ("payroll".equals(tab)) {
                // Get pagination parameters
                String pageStr = request.getParameter("page");
                String pageSizeStr = request.getParameter("pageSize");
                String sortByParam = request.getParameter("sortBy");
                String sortOrderParam = request.getParameter("sortOrder");
                
                try {
                    page = (pageStr != null && pageStr.matches("\\d+")) ? Integer.parseInt(pageStr) : 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
                try {
                    pageSize = (pageSizeStr != null && pageSizeStr.matches("\\d+")) ? Integer.parseInt(pageSizeStr) : DEFAULT_PAGE_SIZE;
                    if (pageSize > 100) pageSize = 100;
                } catch (NumberFormatException e) {
                    pageSize = DEFAULT_PAGE_SIZE;
                }
                
                if (sortByParam != null && !sortByParam.trim().isEmpty()) {
                    sortBy = sortByParam;
                }
                if (sortOrderParam != null && !sortOrderParam.trim().isEmpty()) {
                    sortOrder = sortOrderParam;
                }
                
                // Get total count
                totalPayrolls = payrollDAO.getTotalPayrollCount(employeeId, statusFilter);
                
                // Calculate total pages
                totalPages = (int) Math.ceil((double) totalPayrolls / pageSize);
                if (page < 1) page = 1;
                if (page > totalPages && totalPages > 0) page = totalPages;
                
                // Calculate offset
                int offset = (page - 1) * pageSize;
                
                // Get paged payrolls
                payrolls = payrollDAO.getPagedPayrolls(offset, pageSize, employeeId, statusFilter, sortBy, sortOrder);
                
                // Set pagination attributes
                request.setAttribute("page", page);
                request.setAttribute("pageSize", pageSize);
                request.setAttribute("total", totalPayrolls);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("sortBy", sortBy);
                request.setAttribute("sortOrder", sortOrder);
            } else {
                // For other tabs, load all payrolls without pagination
                payrolls = payrollDAO.getAll(employeeId, statusFilter);
            }
            
            // Load attendance month filter
            String attendanceMonth = request.getParameter("attendanceMonth");

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
            request.setAttribute("attendanceMonth", attendanceMonth);
            request.setAttribute("currentTab", tab); // Set current tab

            // Forward to JSP
            request.getRequestDispatcher("/Views/HrStaff/PayrollManagement.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading payroll data: " + e.getMessage());
            request.getRequestDispatcher("/Views/HrStaff/PayrollManagement.jsp").forward(request, response);
        }
    }
    
    /**
     * Build redirect URL with pagination parameters preserved
     */
    private String buildPayrollRedirectUrl(HttpServletRequest request) {
        StringBuilder url = new StringBuilder(request.getContextPath() + "/hrstaff/payroll?tab=payroll");
        
        // Preserve pagination parameters
        String page = request.getParameter("page");
        String pageSize = request.getParameter("pageSize");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        String employeeFilter = request.getParameter("employeeFilter");
        String statusFilter = request.getParameter("statusFilter");
        
        if (page != null && !page.trim().isEmpty()) {
            url.append("&page=").append(page);
        }
        if (pageSize != null && !pageSize.trim().isEmpty()) {
            url.append("&pageSize=").append(pageSize);
        }
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            url.append("&sortBy=").append(sortBy);
        }
        if (sortOrder != null && !sortOrder.trim().isEmpty()) {
            url.append("&sortOrder=").append(sortOrder);
        }
        if (employeeFilter != null && !employeeFilter.trim().isEmpty()) {
            url.append("&employeeFilter=").append(employeeFilter);
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            url.append("&statusFilter=").append(statusFilter);
        }
        
        return url.toString();
    }
    
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String payrollIdStr = request.getParameter("payrollId");
            if (payrollIdStr == null) {
                request.getSession().setAttribute("error", "Missing payroll ID");
                response.sendRedirect(buildPayrollRedirectUrl(request));
                return;
            }
            
            int payrollId = Integer.parseInt(payrollIdStr);
            boolean success = payrollDAO.delete(payrollId);
            
            if (success) {
                request.getSession().setAttribute("success", "Payroll deleted successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to delete payroll. Only Draft payrolls can be deleted.");
            }
            
            response.sendRedirect(buildPayrollRedirectUrl(request));
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error deleting payroll: " + e.getMessage());
            response.sendRedirect(buildPayrollRedirectUrl(request));
        }
    }
    
    private void handleSubmit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String payrollIdStr = request.getParameter("payrollId");
            if (payrollIdStr == null) {
                request.getSession().setAttribute("error", "Missing payroll ID");
                response.sendRedirect(buildPayrollRedirectUrl(request));
                return;
            }
            
            int payrollId = Integer.parseInt(payrollIdStr);
            Payroll payroll = payrollDAO.getById(payrollId);
            
            if (payroll == null) {
                request.getSession().setAttribute("error", "Payroll not found.");
                response.sendRedirect(buildPayrollRedirectUrl(request));
                return;
            }
            
            if (payroll.getStatus() == null || !"Draft".equals(payroll.getStatus())) {
                request.getSession().setAttribute("error", "Only Draft payrolls can be submitted.");
                response.sendRedirect(buildPayrollRedirectUrl(request));
                return;
            }
            
            boolean success = payrollDAO.updateStatus(payrollId, "Pending");
            
            if (success) {
                request.getSession().setAttribute("success", "Payroll submitted for approval successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to submit payroll.");
            }
            
            response.sendRedirect(buildPayrollRedirectUrl(request));
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error submitting payroll: " + e.getMessage());
            response.sendRedirect(buildPayrollRedirectUrl(request));
        }
    }
    
    /**
     * Handle generate payroll for all employees using stored procedure
     */
    private void handleGenerateAll(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String period = request.getParameter("period");
            if (period == null || period.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Missing pay period parameter");
                response.sendRedirect(buildPayrollRedirectUrl(request));
                return;
            }
            
            // Call stored procedure sp_GeneratePayroll
            boolean success = callStoredProcedureGeneratePayroll(period);
            
            if (success) {
                request.getSession().setAttribute("success", 
                    "Payroll generated successfully for all active employees for period " + period + " using stored procedure sp_GeneratePayrollImproved!\n" +
                    "The system has automatically calculated:\n" +
                    "- Actual working days and paid leave days\n" +
                    "- Actual base salary based on attendance\n" +
                    "- Overtime salary\n" +
                    "- Insurance (BHXH, BHYT, BHTN)\n" +
                    "- Personal income tax (TNCN)\n" +
                    "- Net salary\n" +
                    "All payroll records have been created/updated in PayrollAudit and Payroll tables.");
            } else {
                request.getSession().setAttribute("error", "Failed to generate payroll using stored procedure. Please check the logs for details.");
            }
            
            response.sendRedirect(buildPayrollRedirectUrl(request));
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error generating payroll: " + e.getMessage());
            response.sendRedirect(buildPayrollRedirectUrl(request));
        }
    }
    
    /**
     * Call stored procedure sp_GeneratePayrollImproved
     * Parameters: p_pay_period, p_mode ('CREATE'), p_calculated_by (optional)
     */
    private boolean callStoredProcedureGeneratePayroll(String period) {
        String sql = "CALL sp_GeneratePayrollImproved(?, ?, ?)";
        
        try (var con = com.hrm.dao.DBConnection.getConnection();
             var cs = con.prepareCall(sql)) {
            
            cs.setString(1, period); // p_pay_period
            cs.setString(2, "CREATE"); // p_mode
            // Get current user ID if available from session
            // For now, set to NULL (will be handled by stored procedure)
            cs.setNull(3, java.sql.Types.INTEGER); // p_calculated_by
            
            cs.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}


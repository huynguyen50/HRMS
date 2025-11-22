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
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.hrm.util.PermissionUtil;

/**
 * Controller for Payroll Management
 * Handles GET /hrstaff/payroll - Display payroll management page
 * Handles POST /hrstaff/payroll - Create/Update payroll
 * @author admin
 */
@WebServlet(name = "PayrollManagementController", urlPatterns = {"/hrstaff/payroll", "/hrstaff/payroll/delete", "/hrstaff/payroll/submit", "/hrstaff/payroll/batch-delete", "/hrstaff/payroll/batch-submit", "/hrstaff/payroll/generate-all", "/hrstaff/payroll/details", "/api/payroll"})
public class PayrollManagementController extends HttpServlet {

    private static final String REQUIRED_PERMISSION = "VIEW_PAYROLLS";
    private static final String DEFAULT_DENIED_MESSAGE = "You do not have permission to manage payroll.";

    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final AllowanceTypeDAO allowanceTypeDAO = new AllowanceTypeDAO();
    private final EmployeeAllowanceDAO employeeAllowanceDAO = new EmployeeAllowanceDAO();
    private final DeductionTypeDAO deductionTypeDAO = new DeductionTypeDAO();
    private final EmployeeDeductionDAO employeeDeductionDAO = new EmployeeDeductionDAO();
    private final PayrollDAO payrollDAO = new PayrollDAO();


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureHtmlAccess(request, response, DEFAULT_DENIED_MESSAGE)) {
            return;
        }
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

                // Validate Net Salary formula: Net Salary = ActualBaseSalary + OTSalary + Allowance - Deduction
                BigDecimal calculatedNetSalary = actualBaseSalary.add(otSalary).add(allowance).subtract(deduction);
                if (calculatedNetSalary.compareTo(BigDecimal.ZERO) < 0) {
                    calculatedNetSalary = BigDecimal.ZERO;
                }
                
                BigDecimal difference = netSalary.subtract(calculatedNetSalary).abs();
                BigDecimal tolerance = new BigDecimal("0.01"); // Allow 1 cent difference for rounding
                
                String overrideReason = request.getParameter("overrideReason");
                String manualOverride = request.getParameter("manualOverride");
                boolean hasOverride = "on".equals(manualOverride) && overrideReason != null && !overrideReason.trim().isEmpty();
                
                // If Net Salary doesn't match formula, require override reason
                if (difference.compareTo(tolerance) > 0) {
                    if (!hasOverride) {
                        request.setAttribute("error", "Net Salary does not match the formula!\n" +
                            "Expected: " + calculatedNetSalary + " (Actual Base Salary + OT Salary + Allowance - Deduction)\n" +
                            "Provided: " + netSalary + "\n" +
                            "Please check 'Manual Override' and provide a reason if this is intentional.");
                        doGet(request, response);
                        return;
                    }
                    // Log override to PayrollAudit notes if exists
                    if (payrollIdStr != null && !payrollIdStr.trim().isEmpty()) {
                        int payrollId = Integer.parseInt(payrollIdStr);
                        com.hrm.model.entity.Payroll existingPayroll = payrollDAO.getById(payrollId);
                        if (existingPayroll != null) {
                            // Update PayrollAudit notes with override information
                            String auditNote = String.format("[MANUAL OVERRIDE] %s\nUser: %s\nReason: %s\n" +
                                "Net Salary Override: Expected %s, Set to %s",
                                java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")),
                                request.getSession().getAttribute("systemUser") != null ? 
                                    ((com.hrm.model.entity.SystemUser)request.getSession().getAttribute("systemUser")).getUsername() : "Unknown",
                                overrideReason.trim(),
                                calculatedNetSalary,
                                netSalary);
                            
                            try {
                                payrollDAO.updatePayrollAuditNotes(existingPayroll.getEmployeeId(), existingPayroll.getPayPeriod(), auditNote);
                            } catch (Exception e) {
                                System.err.println("Failed to update PayrollAudit notes: " + e.getMessage());
                            }
                        }
                    } else if (employeeIdStr != null && payPeriod != null) {
                        // For new payroll, we can't update audit yet, but we'll log it when creating
                        // Store override note in request attribute for later use
                        String auditNote = String.format("[MANUAL OVERRIDE] %s\nUser: %s\nReason: %s\n" +
                            "Net Salary Override: Expected %s, Set to %s",
                            java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")),
                            request.getSession().getAttribute("systemUser") != null ? 
                                ((com.hrm.model.entity.SystemUser)request.getSession().getAttribute("systemUser")).getUsername() : "Unknown",
                            overrideReason.trim(),
                            calculatedNetSalary,
                            netSalary);
                        
                        // Will be applied after payroll creation
                        request.setAttribute("pendingAuditNote", auditNote);
                        request.setAttribute("pendingEmployeeId", employeeId);
                        request.setAttribute("pendingPayPeriod", payPeriod);
                    }
                }
                
                // Also log manual override even if formula matches (user explicitly checked override)
                if (hasOverride && difference.compareTo(tolerance) <= 0 && payrollIdStr != null && !payrollIdStr.trim().isEmpty()) {
                    int payrollId = Integer.parseInt(payrollIdStr);
                    com.hrm.model.entity.Payroll existingPayroll = payrollDAO.getById(payrollId);
                    if (existingPayroll != null) {
                        String auditNote = String.format("[MANUAL OVERRIDE - CONFIRMED] %s\nUser: %s\nReason: %s\n" +
                            "Values match formula but user confirmed manual override.",
                            java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")),
                            request.getSession().getAttribute("systemUser") != null ? 
                                ((com.hrm.model.entity.SystemUser)request.getSession().getAttribute("systemUser")).getUsername() : "Unknown",
                            overrideReason.trim());
                        
                        try {
                            payrollDAO.updatePayrollAuditNotes(existingPayroll.getEmployeeId(), existingPayroll.getPayPeriod(), auditNote);
                        } catch (Exception e) {
                            System.err.println("Failed to update PayrollAudit notes: " + e.getMessage());
                        }
                    }
                }

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
                    // Submit for approval (can be Draft or Rejected)
                    if (finalPayrollId > 0) {
                        Payroll updatedPayroll = payrollDAO.getById(finalPayrollId);
                        String previousStatus = updatedPayroll != null ? updatedPayroll.getStatus() : "";
                        boolean statusUpdated = payrollDAO.updateStatus(finalPayrollId, "Pending");
                        
                        if (statusUpdated) {
                            if ("Rejected".equals(previousStatus)) {
                                request.setAttribute("success", "Payroll resubmitted for approval successfully!");
                            } else {
                                request.setAttribute("success", "Payroll submitted for approval successfully!");
                            }
                        } else {
                            request.setAttribute("error", "Payroll updated but failed to change status to Pending.");
                        }
                    } else {
                        request.setAttribute("error", "Failed to submit payroll. Payroll ID not found.");
                    }
                } else if (success) {
                    request.setAttribute("success", "Payroll saved successfully!");
                } else {
                    request.setAttribute("error", "Failed to save payroll. Make sure the payroll is in Draft or Rejected status.");
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
        if (path != null && path.contains("/batch-delete")) {
            handleBatchDelete(request, response);
        } else if (path != null && path.contains("/batch-submit")) {
            handleBatchSubmit(request, response);
        } else if (path != null && path.contains("/delete")) {
            handleDelete(request, response);
        } else if (path != null && path.contains("/submit")) {
            handleSubmit(request, response);
        } else if (path != null && path.contains("/generate-all")) {
            handleGenerateAll(request, response);
        } else if (path != null && (path.contains("/details") || path.contains("/api/payroll"))) {
            handleGetPayrollDetails(request, response);
        } else {
            handleGet(request, response);
        }
    }
    
    private static final int DEFAULT_PAGE_SIZE = 10;
    
    private void handleGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureHtmlAccess(request, response, DEFAULT_DENIED_MESSAGE)) {
            return;
        }
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
            
            // Load allowances (with pagination if on allowance tab)
            String allowanceMonth = request.getParameter("allowanceMonth");
            List<Map<String, Object>> allowances;
            int totalAllowances = 0;
            int allowancePage = 1;
            int allowancePageSize = DEFAULT_PAGE_SIZE;
            int allowanceTotalPages = 1;
            
            // Always get pagination parameters for allowance (for consistency)
            String allowancePageStr = request.getParameter("allowancePage");
            String allowancePageSizeStr = request.getParameter("allowancePageSize");
            
            try {
                allowancePage = (allowancePageStr != null && allowancePageStr.matches("\\d+")) ? Integer.parseInt(allowancePageStr) : 1;
            } catch (NumberFormatException e) {
                allowancePage = 1;
            }
            try {
                allowancePageSize = (allowancePageSizeStr != null && allowancePageSizeStr.matches("\\d+")) ? Integer.parseInt(allowancePageSizeStr) : DEFAULT_PAGE_SIZE;
                if (allowancePageSize > 100) allowancePageSize = 100;
            } catch (NumberFormatException e) {
                allowancePageSize = DEFAULT_PAGE_SIZE;
            }
            
            // Always get total count (needed for pagination display)
            totalAllowances = employeeAllowanceDAO.getTotalCount(employeeId, allowanceMonth);
            
            if ("allowance".equals(tab)) {
                // Calculate total pages (ensure at least 1 page even if empty)
                allowanceTotalPages = totalAllowances == 0 ? 1 : (int) Math.ceil((double) totalAllowances / allowancePageSize);
                if (allowanceTotalPages < 1) allowanceTotalPages = 1;
                if (allowancePage < 1) allowancePage = 1;
                if (allowancePage > allowanceTotalPages) allowancePage = allowanceTotalPages;
                
                // Calculate offset
                int offset = (allowancePage - 1) * allowancePageSize;
                
                // Get paged allowances
                allowances = employeeAllowanceDAO.getPaged(employeeId, allowanceMonth, offset, allowancePageSize);
            } else {
                // For other tabs, load all allowances without pagination
                allowances = employeeAllowanceDAO.getAll(employeeId, allowanceMonth);
                // Still calculate total pages for consistency
                allowanceTotalPages = totalAllowances == 0 ? 1 : (int) Math.ceil((double) totalAllowances / allowancePageSize);
            }
            
            // Load deductions (with pagination if on deduction tab)
            String deductionMonth = request.getParameter("deductionMonth");
            List<Map<String, Object>> deductions;
            int totalDeductions = 0;
            int deductionPage = 1;
            int deductionPageSize = DEFAULT_PAGE_SIZE;
            int deductionTotalPages = 1;
            
            // Always get pagination parameters for deduction (for consistency)
            String deductionPageStr = request.getParameter("deductionPage");
            String deductionPageSizeStr = request.getParameter("deductionPageSize");
            
            try {
                deductionPage = (deductionPageStr != null && deductionPageStr.matches("\\d+")) ? Integer.parseInt(deductionPageStr) : 1;
            } catch (NumberFormatException e) {
                deductionPage = 1;
            }
            try {
                deductionPageSize = (deductionPageSizeStr != null && deductionPageSizeStr.matches("\\d+")) ? Integer.parseInt(deductionPageSizeStr) : DEFAULT_PAGE_SIZE;
                if (deductionPageSize > 100) deductionPageSize = 100;
            } catch (NumberFormatException e) {
                deductionPageSize = DEFAULT_PAGE_SIZE;
            }
            
            // Always get total count (needed for pagination display)
            totalDeductions = employeeDeductionDAO.getTotalCount(employeeId, deductionMonth);
            
            if ("deduction".equals(tab)) {
                // Calculate total pages (ensure at least 1 page even if empty)
                deductionTotalPages = totalDeductions == 0 ? 1 : (int) Math.ceil((double) totalDeductions / deductionPageSize);
                if (deductionTotalPages < 1) deductionTotalPages = 1;
                if (deductionPage < 1) deductionPage = 1;
                if (deductionPage > deductionTotalPages) deductionPage = deductionTotalPages;
                
                // Calculate offset
                int offset = (deductionPage - 1) * deductionPageSize;
                
                // Get paged deductions
                deductions = employeeDeductionDAO.getPaged(employeeId, deductionMonth, offset, deductionPageSize);
            } else {
                // For other tabs, load all deductions without pagination
                deductions = employeeDeductionDAO.getAll(employeeId, deductionMonth);
                // Still calculate total pages for consistency
                deductionTotalPages = totalDeductions == 0 ? 1 : (int) Math.ceil((double) totalDeductions / deductionPageSize);
            }
            
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
            
            // Always set pagination attributes for allowance (even if not current tab, to maintain state)
            request.setAttribute("allowancePage", allowancePage);
            request.setAttribute("allowancePageSize", allowancePageSize);
            request.setAttribute("totalAllowances", totalAllowances);
            request.setAttribute("allowanceTotalPages", allowanceTotalPages);
            
            // Always set pagination attributes for deduction (even if not current tab, to maintain state)
            request.setAttribute("deductionPage", deductionPage);
            request.setAttribute("deductionPageSize", deductionPageSize);
            request.setAttribute("totalDeductions", totalDeductions);
            request.setAttribute("deductionTotalPages", deductionTotalPages);

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
        if (!ensureHtmlAccess(request, response, "You do not have permission to delete payroll records.")) {
            return;
        }
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
        if (!ensureHtmlAccess(request, response, "You do not have permission to submit payroll for approval.")) {
            return;
        }
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
            
            // Allow submitting Draft or Rejected payrolls
            if (payroll.getStatus() == null || (!"Draft".equals(payroll.getStatus()) && !"Rejected".equals(payroll.getStatus()))) {
                request.getSession().setAttribute("error", "Only Draft or Rejected payrolls can be submitted.");
                response.sendRedirect(buildPayrollRedirectUrl(request));
                return;
            }
            
            boolean success = payrollDAO.updateStatus(payrollId, "Pending");
            
            if (success) {
                String message = "Rejected".equals(payroll.getStatus()) 
                    ? "Payroll resubmitted for approval successfully!" 
                    : "Payroll submitted for approval successfully!";
                request.getSession().setAttribute("success", message);
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
     * Handle batch submit for multiple payrolls
     */
    private void handleBatchSubmit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureHtmlAccess(request, response, "You do not have permission to submit payrolls for approval.")) {
            return;
        }
        try {
            String payrollIdsStr = request.getParameter("payrollIds");
            if (payrollIdsStr == null || payrollIdsStr.trim().isEmpty()) {
                request.getSession().setAttribute("error", "No payroll IDs provided");
                response.sendRedirect(buildPayrollRedirectUrl(request));
                return;
            }
            
            String[] payrollIdStrs = payrollIdsStr.split(",");
            List<Integer> payrollIds = new ArrayList<>();
            for (String idStr : payrollIdStrs) {
                try {
                    payrollIds.add(Integer.parseInt(idStr.trim()));
                } catch (NumberFormatException e) {
                    // Skip invalid IDs
                }
            }
            
            if (payrollIds.isEmpty()) {
                request.getSession().setAttribute("error", "No valid payroll IDs provided");
                response.sendRedirect(buildPayrollRedirectUrl(request));
                return;
            }
            
            int successCount = 0;
            int failCount = 0;
            int skippedCount = 0;
            
            for (Integer payrollId : payrollIds) {
                Payroll payroll = payrollDAO.getById(payrollId);
                if (payroll == null) {
                    skippedCount++;
                    continue;
                }
                
                // Only allow submitting Draft or Rejected payrolls
                if (payroll.getStatus() == null || (!"Draft".equals(payroll.getStatus()) && !"Rejected".equals(payroll.getStatus()))) {
                    skippedCount++;
                    continue;
                }
                
                boolean success = payrollDAO.updateStatus(payrollId, "Pending");
                if (success) {
                    successCount++;
                } else {
                    failCount++;
                }
            }
            
            // Build result message
            StringBuilder message = new StringBuilder();
            if (successCount > 0) {
                message.append(successCount).append(" payroll(s) submitted successfully. ");
            }
            if (failCount > 0) {
                message.append(failCount).append(" payroll(s) failed to submit. ");
            }
            if (skippedCount > 0) {
                message.append(skippedCount).append(" payroll(s) skipped (not in Draft/Rejected status). ");
            }
            
            if (successCount > 0) {
                request.getSession().setAttribute("success", message.toString().trim());
            } else {
                request.getSession().setAttribute("error", message.toString().trim());
            }
            
            response.sendRedirect(buildPayrollRedirectUrl(request));
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error batch submitting payrolls: " + e.getMessage());
            response.sendRedirect(buildPayrollRedirectUrl(request));
        }
    }
    
    /**
     * Handle batch delete for multiple payrolls
     */
    private void handleBatchDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureHtmlAccess(request, response, "You do not have permission to delete payroll records.")) {
            return;
        }
        try {
            String payrollIdsStr = request.getParameter("payrollIds");
            if (payrollIdsStr == null || payrollIdsStr.trim().isEmpty()) {
                request.getSession().setAttribute("error", "No payroll IDs provided");
                response.sendRedirect(buildPayrollRedirectUrl(request));
                return;
            }
            
            String[] payrollIdStrs = payrollIdsStr.split(",");
            List<Integer> payrollIds = new ArrayList<>();
            for (String idStr : payrollIdStrs) {
                try {
                    payrollIds.add(Integer.parseInt(idStr.trim()));
                } catch (NumberFormatException e) {
                    // Skip invalid IDs
                }
            }
            
            if (payrollIds.isEmpty()) {
                request.getSession().setAttribute("error", "No valid payroll IDs provided");
                response.sendRedirect(buildPayrollRedirectUrl(request));
                return;
            }
            
            int successCount = 0;
            int failCount = 0;
            int skippedCount = 0;
            
            for (Integer payrollId : payrollIds) {
                Payroll payroll = payrollDAO.getById(payrollId);
                if (payroll == null) {
                    skippedCount++;
                    continue;
                }
                
                // Only allow deleting Draft payrolls
                if (!"Draft".equals(payroll.getStatus())) {
                    skippedCount++;
                    continue;
                }
                
                boolean success = payrollDAO.delete(payrollId);
                if (success) {
                    successCount++;
                } else {
                    failCount++;
                }
            }
            
            // Build result message
            StringBuilder message = new StringBuilder();
            if (successCount > 0) {
                message.append(successCount).append(" payroll(s) deleted successfully. ");
            }
            if (failCount > 0) {
                message.append(failCount).append(" payroll(s) failed to delete. ");
            }
            if (skippedCount > 0) {
                message.append(skippedCount).append(" payroll(s) skipped (not in Draft status). ");
            }
            
            if (successCount > 0) {
                request.getSession().setAttribute("success", message.toString().trim());
            } else {
                request.getSession().setAttribute("error", message.toString().trim());
            }
            
            response.sendRedirect(buildPayrollRedirectUrl(request));
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error batch deleting payrolls: " + e.getMessage());
            response.sendRedirect(buildPayrollRedirectUrl(request));
        }
    }
    
    /**
     * Handle generate payroll for all employees using stored procedure
     */
    private void handleGenerateAll(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureHtmlAccess(request, response, "You do not have permission to generate payroll for all employees.")) {
            return;
        }
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
     * Handle GET request for payroll details (JSON API)
     */
    private void handleGetPayrollDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureJsonAccess(request, response, "You do not have permission to view payroll details.")) {
            return;
        }
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String payrollIdStr = request.getParameter("payrollId");
            if (payrollIdStr == null || payrollIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                PrintWriter out = response.getWriter();
                out.print("{\"error\":\"Missing payroll ID\"}");
                return;
            }
            
            int payrollId = Integer.parseInt(payrollIdStr);
            Map<String, Object> details = payrollDAO.getDetailsById(payrollId);
            
            if (details == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                PrintWriter out = response.getWriter();
                out.print("{\"error\":\"Payroll not found\"}");
                return;
            }
            
            // Convert to JSON
            Gson gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd")
                .create();
            
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(details));
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            PrintWriter out = response.getWriter();
            out.print("{\"error\":\"Invalid payroll ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = response.getWriter();
            out.print("{\"error\":\"Error retrieving payroll details: " + e.getMessage() + "\"}");
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

    private boolean ensureHtmlAccess(HttpServletRequest request,
                                     HttpServletResponse response,
                                     String permissionMessage) throws ServletException, IOException {
        return PermissionUtil.ensureRolePermission(
                request,
                response,
                PermissionUtil.ROLE_HR_STAFF,
                REQUIRED_PERMISSION,
                "This section is restricted to HR Staff.",
                permissionMessage);
    }

    private boolean ensureJsonAccess(HttpServletRequest request,
                                     HttpServletResponse response,
                                     String permissionMessage) throws IOException {
        return PermissionUtil.ensureRolePermissionJson(
                request,
                response,
                PermissionUtil.ROLE_HR_STAFF,
                REQUIRED_PERMISSION,
                "This section is restricted to HR Staff.",
                permissionMessage);
    }
}


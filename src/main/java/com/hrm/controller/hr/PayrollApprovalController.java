package com.hrm.controller.hr;

import com.hrm.dao.PayrollDAO;
import com.hrm.dao.EmployeeDAO;
import com.hrm.model.entity.SystemUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * Controller for Payroll Approval by HR Manager
 * Handles GET /hr/payroll-approval - Display payroll approval page
 * Handles POST /hr/payroll-approval - Approve/Reject payroll
 * @author admin
 */
@WebServlet(name = "PayrollApprovalController", urlPatterns = {"/hr/payroll-approval"})
public class PayrollApprovalController extends HttpServlet {

    private static final String PAYROLL_MANAGEMENT_JSP = "/Views/hr/PayrollManagement.jsp";
    private static final String STATUS_PENDING = "Pending";
    
    private final PayrollDAO payrollDAO = new PayrollDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check authentication
        HttpSession session = request.getSession();
        SystemUser currentUser = (SystemUser) session.getAttribute("systemUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
            return;
        }
        
        try {
            // Get filter parameters
            String statusFilter = request.getParameter("status");
            String employeeFilter = request.getParameter("employeeFilter");
            String payPeriodFilter = request.getParameter("payPeriod");
            
            // Default to Pending status if not specified
            if (statusFilter == null || statusFilter.trim().isEmpty()) {
                statusFilter = STATUS_PENDING;
            }
            
            // Parse employee filter
            Integer employeeId = null;
            if (employeeFilter != null && !employeeFilter.trim().isEmpty()) {
                try {
                    employeeId = Integer.parseInt(employeeFilter);
                } catch (NumberFormatException e) {
                    // Invalid employee ID, ignore
                }
            }
            
            // Get pagination parameters
            int page = 1;
            int pageSize = 10;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            int offset = (page - 1) * pageSize;
            
            // Get sort parameters
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");
            if (sortBy == null || sortBy.trim().isEmpty()) {
                sortBy = "PayPeriod";
            }
            if (sortOrder == null || sortOrder.trim().isEmpty()) {
                sortOrder = "DESC";
            }
            
            // Load payrolls with filters and pagination
            List<Map<String, Object>> payrolls = payrollDAO.getPagedPayrolls(
                offset, pageSize, employeeId, statusFilter, sortBy, sortOrder
            );
            
            // Get total count for pagination
            int totalCount = payrollDAO.getTotalPayrollCount(employeeId, statusFilter);
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            
            // Load all employees for filter dropdown
            List<com.hrm.model.entity.Employee> employees = employeeDAO.getAll();
            
            // Set attributes
            request.setAttribute("payrolls", payrolls);
            request.setAttribute("employees", employees);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("employeeFilter", employeeFilter);
            request.setAttribute("payPeriodFilter", payPeriodFilter);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            request.setAttribute("currentUser", currentUser);
            
            // Check for success/error messages from URL parameters
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if (success != null && !success.trim().isEmpty()) {
                request.setAttribute("success", success);
            }
            if (error != null && !error.trim().isEmpty()) {
                request.setAttribute("error", error);
            }
            
            request.getRequestDispatcher(PAYROLL_MANAGEMENT_JSP).forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading payroll list: " + e.getMessage());
            request.getRequestDispatcher(PAYROLL_MANAGEMENT_JSP).forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check authentication
        HttpSession session = request.getSession();
        SystemUser currentUser = (SystemUser) session.getAttribute("systemUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
            return;
        }
        
        try {
            String action = request.getParameter("action");
            String payrollIdStr = request.getParameter("payrollId");
            
            if (payrollIdStr == null || payrollIdStr.trim().isEmpty()) {
                redirectWithMessage(response, request.getContextPath() + "/hr/payroll-approval", 
                    "error", "Payroll ID is required");
                return;
            }
            
            int payrollId = Integer.parseInt(payrollIdStr);
            
            // Get payroll to verify it exists and is in correct status
            com.hrm.model.entity.Payroll payroll = payrollDAO.getById(payrollId);
            if (payroll == null) {
                redirectWithMessage(response, request.getContextPath() + "/hr/payroll-approval", 
                    "error", "Payroll not found");
                return;
            }
            
            // Get current user ID (from employeeId if available, otherwise userId)
            Integer approvedBy = currentUser.getEmployeeId();
            if (approvedBy == null) {
                // If no employeeId, use userId as fallback
                approvedBy = currentUser.getUserId();
            }
            
            if ("approve".equals(action)) {
                // Verify payroll is in Pending status
                if (!STATUS_PENDING.equals(payroll.getStatus())) {
                    redirectWithMessage(response, request.getContextPath() + "/hr/payroll-approval", 
                        "error", "Payroll is not in Pending status. Current status: " + payroll.getStatus());
                    return;
                }
                
                // Approve payroll
                boolean success = payrollDAO.approvePayroll(payrollId, approvedBy, LocalDate.now());
                
                if (success) {
                    String employeeName = getEmployeeName(payroll.getEmployeeId());
                    String successMsg = "✅ Payroll approved successfully!" + 
                        (employeeName.isEmpty() ? "" : " Payroll for " + employeeName + " has been approved.");
                    redirectWithMessage(response, request.getContextPath() + "/hr/payroll-approval", 
                        "success", successMsg);
                } else {
                    redirectWithMessage(response, request.getContextPath() + "/hr/payroll-approval", 
                        "error", "❌ Unable to approve payroll. Please try again.");
                }
                
            } else if ("reject".equals(action)) {
                // Verify payroll is in Pending status
                if (!STATUS_PENDING.equals(payroll.getStatus())) {
                    redirectWithMessage(response, request.getContextPath() + "/hr/payroll-approval", 
                        "error", "Payroll is not in Pending status. Current status: " + payroll.getStatus());
                    return;
                }
                
                // Reject payroll
                boolean success = payrollDAO.rejectPayroll(payrollId, approvedBy, LocalDate.now());
                
                if (success) {
                    String employeeName = getEmployeeName(payroll.getEmployeeId());
                    String successMsg = "✅ Payroll rejected successfully!" + 
                        (employeeName.isEmpty() ? "" : " Payroll for " + employeeName + " has been rejected.");
                    redirectWithMessage(response, request.getContextPath() + "/hr/payroll-approval", 
                        "success", successMsg);
                } else {
                    redirectWithMessage(response, request.getContextPath() + "/hr/payroll-approval", 
                        "error", "❌ Unable to reject payroll. Please try again.");
                }
                
            } else {
                redirectWithMessage(response, request.getContextPath() + "/hr/payroll-approval", 
                    "error", "Invalid action");
            }
            
        } catch (NumberFormatException e) {
            redirectWithMessage(response, request.getContextPath() + "/hr/payroll-approval", 
                "error", "Invalid payroll ID");
        } catch (Exception e) {
            e.printStackTrace();
            redirectWithMessage(response, request.getContextPath() + "/hr/payroll-approval", 
                "error", "Error: " + e.getMessage());
        }
    }
    
    /**
     * Get employee name by ID
     */
    private String getEmployeeName(int employeeId) {
        try {
            com.hrm.model.entity.Employee employee = employeeDAO.getById(employeeId);
            if (employee != null && employee.getFullName() != null) {
                return employee.getFullName();
            }
        } catch (Exception e) {
            // Ignore, return empty name
        }
        return "";
    }
    
    /**
     * Redirect with success or error message
     */
    private void redirectWithMessage(HttpServletResponse response, String url, String type, String message) 
            throws IOException {
        try {
            String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8.toString());
            response.sendRedirect(url + "?" + type + "=" + encodedMessage);
        } catch (UnsupportedEncodingException e) {
            // Fallback to default encoding if UTF-8 is not supported (should not happen)
            response.sendRedirect(url + "?" + type + "=" + URLEncoder.encode(message, "UTF-8"));
        }
    }
}

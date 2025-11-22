package com.hrm.controller.hrstaff;

import com.hrm.dao.EmployeeAllowanceDAO;
import com.hrm.dao.PayrollDAO;
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
    private final PayrollDAO payrollDAO = new PayrollDAO();

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

            // Check payroll status before allowing allowance creation/update
            String payrollStatus = payrollDAO.getPayrollStatusByEmployeeAndPeriod(employeeId, month);
            if (payrollStatus != null && isPayrollStatusBlocked(payrollStatus)) {
                String statusDisplay = getStatusDisplayName(payrollStatus);
                String errorMessage = String.format(
                    "⚠️ Không thể tạo/sửa allowance!\n\n" +
                    "Bảng lương của nhân viên này cho tháng %s đã ở trạng thái '%s'.\n\n" +
                    "Để thêm allowance:\n" +
                    "1. Nếu payroll đang Pending: Yêu cầu HR Manager reject payroll\n" +
                    "2. Nếu payroll đã Approved: Tạo payroll mới cho tháng tiếp theo hoặc tạo adjustment payroll\n" +
                    "3. Nếu payroll đã Paid: Liên hệ quản lý để xử lý",
                    month, statusDisplay
                );
                request.getSession().setAttribute("error", errorMessage);
                response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=allowance");
                return;
            }

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
            
            // Get allowance info to check payroll status
            var allowanceInfo = employeeAllowanceDAO.getById(allowanceId);
            if (allowanceInfo != null) {
                Integer employeeId = (Integer) allowanceInfo.get("employeeId");
                String month = (String) allowanceInfo.get("month");
                
                if (employeeId != null && month != null) {
                    // Check payroll status before allowing deletion
                    String payrollStatus = payrollDAO.getPayrollStatusByEmployeeAndPeriod(employeeId, month);
                    if (payrollStatus != null && isPayrollStatusBlocked(payrollStatus)) {
                        String statusDisplay = getStatusDisplayName(payrollStatus);
                        String errorMessage = String.format(
                            "⚠️ Không thể xóa allowance!\n\n" +
                            "Bảng lương của nhân viên này cho tháng %s đã ở trạng thái '%s'.\n\n" +
                            "Để xóa allowance:\n" +
                            "1. Nếu payroll đang Pending: Yêu cầu HR Manager reject payroll\n" +
                            "2. Nếu payroll đã Approved: Tạo payroll mới cho tháng tiếp theo hoặc tạo adjustment payroll\n" +
                            "3. Nếu payroll đã Paid: Liên hệ quản lý để xử lý",
                            month, statusDisplay
                        );
                        request.getSession().setAttribute("error", errorMessage);
                        response.sendRedirect(request.getContextPath() + "/hrstaff/payroll?tab=allowance");
                        return;
                    }
                }
            }
            
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

    /**
     * Check if payroll status blocks allowance/deduction modification
     * Blocked statuses: Pending, Approved, Paid
     * Allowed statuses: Draft, Rejected, null (no payroll)
     */
    private boolean isPayrollStatusBlocked(String status) {
        if (status == null) {
            return false; // No payroll exists, allow modification
        }
        return "Pending".equals(status) || "Approved".equals(status) || "Paid".equals(status);
    }
    
    /**
     * Get display name for payroll status
     */
    private String getStatusDisplayName(String status) {
        if (status == null) return "N/A";
        switch (status) {
            case "Draft": return "Nháp";
            case "Pending": return "Đang chờ duyệt";
            case "Approved": return "Đã duyệt";
            case "Rejected": return "Đã từ chối";
            case "Paid": return "Đã thanh toán";
            default: return status;
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


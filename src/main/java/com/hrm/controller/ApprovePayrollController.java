package com.hrm.controller;

import com.hrm.dao.PayrollDAO;
import com.hrm.dao.SystemLogDAO;
import com.hrm.model.entity.Payroll;
import com.hrm.model.entity.SystemUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Controller xử lý phê duyệt bảng lương
 * Chức năng #28: Approve Payroll (Level 2)
 * @author NamHD
 */
@WebServlet(name = "ApprovePayrollController", urlPatterns = {"/approve-payroll"})
public class ApprovePayrollController extends HttpServlet {
    
    private final PayrollDAO payrollDAO = new PayrollDAO();
    private final SystemLogDAO systemLogDAO = new SystemLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        SystemUser currentUser = (SystemUser) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Chỉ HR Manager mới có quyền approve payroll (BR-06, BR-32)
        if (currentUser.getRoleId() != 2) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền phê duyệt bảng lương");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "list":
                    showPendingPayrolls(request, response);
                    break;
                case "detail":
                    showPayrollDetail(request, response);
                    break;
                case "monthly-review":
                    showMonthlyReview(request, response);
                    break;
                default:
                    showPendingPayrolls(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        SystemUser currentUser = (SystemUser) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "approve-single":
                    approveSinglePayroll(request, response, currentUser);
                    break;
                case "approve-batch":
                    approveBatchPayroll(request, response, currentUser);
                    break;
                case "reject":
                    rejectPayroll(request, response, currentUser);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị danh sách bảng lương chờ phê duyệt
     */
    private void showPendingPayrolls(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String payPeriod = request.getParameter("period");
            if (payPeriod == null || payPeriod.trim().isEmpty()) {
                payPeriod = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
            }
            
            List<Payroll> pendingPayrolls = payrollDAO.getPendingPayrolls(payPeriod);
            
            // Tính tổng số tiền cần phê duyệt
            double totalAmount = pendingPayrolls.stream()
                .mapToDouble(p -> p.getNetSalary().doubleValue())
                .sum();
            
            request.setAttribute("pendingPayrolls", pendingPayrolls);
            request.setAttribute("currentPeriod", payPeriod);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("totalCount", pendingPayrolls.size());
            
            request.getRequestDispatcher("/Views/hr/PayrollApprovalList.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách bảng lương: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị chi tiết bảng lương
     */
    private void showPayrollDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int payrollId = Integer.parseInt(request.getParameter("id"));
            Payroll payroll = payrollDAO.getById(payrollId);
            
            if (payroll == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy bảng lương");
                return;
            }
            
            request.setAttribute("payroll", payroll);
            request.getRequestDispatcher("/Views/hr/PayrollApprovalDetail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID bảng lương không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải chi tiết bảng lương: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị tổng hợp hàng tháng để review (BR-32)
     */
    private void showMonthlyReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String payPeriod = request.getParameter("period");
            if (payPeriod == null || payPeriod.trim().isEmpty()) {
                payPeriod = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
            }
            
            List<Payroll> allPayrolls = payrollDAO.getAllPayrollByPeriod(payPeriod);
            List<Payroll> pendingPayrolls = payrollDAO.getPendingPayrolls(payPeriod);
            List<Payroll> approvedPayrolls = payrollDAO.getApprovedPayrolls(payPeriod);
            
            // Thống kê tổng hợp
            double totalPending = pendingPayrolls.stream()
                .mapToDouble(p -> p.getNetSalary().doubleValue()).sum();
            double totalApproved = approvedPayrolls.stream()
                .mapToDouble(p -> p.getNetSalary().doubleValue()).sum();
            double grandTotal = allPayrolls.stream()
                .mapToDouble(p -> p.getNetSalary().doubleValue()).sum();
            
            request.setAttribute("allPayrolls", allPayrolls);
            request.setAttribute("pendingPayrolls", pendingPayrolls);
            request.setAttribute("approvedPayrolls", approvedPayrolls);
            request.setAttribute("period", payPeriod);
            request.setAttribute("totalPending", totalPending);
            request.setAttribute("totalApproved", totalApproved);
            request.setAttribute("grandTotal", grandTotal);
            request.setAttribute("pendingCount", pendingPayrolls.size());
            request.setAttribute("approvedCount", approvedPayrolls.size());
            
            request.getRequestDispatcher("/Views/hr/PayrollMonthlyReview.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải báo cáo tháng: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Phê duyệt một bảng lương
     */
    private void approveSinglePayroll(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            int payrollId = Integer.parseInt(request.getParameter("payrollId"));
            String comment = request.getParameter("comment");
            
            Payroll payroll = payrollDAO.getById(payrollId);
            if (payroll == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy bảng lương");
                return;
            }
            
            // Kiểm tra trạng thái - chỉ approve những payroll chưa được approve
            if (payroll.getApprovedBy() != null) {
                request.setAttribute("error", "Bảng lương này đã được phê duyệt");
                response.sendRedirect("approve-payroll?action=list");
                return;
            }
            
            // Phê duyệt
            boolean success = payrollDAO.approvePayroll(payrollId, currentUser.getEmployeeId(), comment);
            
            if (success) {
                // Ghi log (BR-15)
                systemLogDAO.insertLog(currentUser.getUserId(), 
                    "APPROVE_PAYROLL", 
                    "Payroll", 
                    "PayrollID: " + payrollId + ", Status: Pending", 
                    "Status: Approved" + (comment != null ? ", Comment: " + comment : ""));
                
                request.setAttribute("success", "Đã phê duyệt bảng lương thành công");
                
                // BR-33: Sau khi approve, payroll trở thành read-only
                // TODO: Gửi thông báo cho nhân viên (BR-24)
                
            } else {
                request.setAttribute("error", "Không thể phê duyệt bảng lương");
            }
            
            response.sendRedirect("approve-payroll?action=list");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID bảng lương không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi phê duyệt: " + e.getMessage());
            response.sendRedirect("approve-payroll?action=list");
        }
    }
    
    /**
     * Phê duyệt hàng loạt bảng lương
     */
    private void approveBatchPayroll(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            String payPeriod = request.getParameter("payPeriod");
            String comment = request.getParameter("comment");
            
            if (payPeriod == null || payPeriod.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng chọn kỳ lương");
                response.sendRedirect("approve-payroll?action=list");
                return;
            }
            
            List<Payroll> pendingPayrolls = payrollDAO.getPendingPayrolls(payPeriod);
            
            if (pendingPayrolls.isEmpty()) {
                request.setAttribute("error", "Không có bảng lương nào cần phê duyệt trong kỳ này");
                response.sendRedirect("approve-payroll?action=list");
                return;
            }
            
            int successCount = 0;
            int failCount = 0;
            
            for (Payroll payroll : pendingPayrolls) {
                boolean success = payrollDAO.approvePayroll(payroll.getPayrollId(), currentUser.getEmployeeId(), comment);
                if (success) {
                    successCount++;
                } else {
                    failCount++;
                }
            }
            
            // Ghi log tổng hợp
            systemLogDAO.insertLog(currentUser.getUserId(), 
                "APPROVE_BATCH_PAYROLL", 
                "Payroll", 
                "Period: " + payPeriod, 
                "Approved: " + successCount + ", Failed: " + failCount +
                (comment != null ? ", Comment: " + comment : ""));
            
            if (successCount > 0) {
                request.setAttribute("success", "Đã phê duyệt " + successCount + " bảng lương" +
                    (failCount > 0 ? ". Có " + failCount + " bảng lương không thể phê duyệt." : ""));
            } else {
                request.setAttribute("error", "Không thể phê duyệt bất kỳ bảng lương nào");
            }
            
            response.sendRedirect("approve-payroll?action=list&period=" + payPeriod);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi phê duyệt hàng loạt: " + e.getMessage());
            response.sendRedirect("approve-payroll?action=list");
        }
    }
    
    /**
     * Từ chối bảng lương
     */
    private void rejectPayroll(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            int payrollId = Integer.parseInt(request.getParameter("payrollId"));
            String rejectionReason = request.getParameter("rejectionReason");
            
            // BR-19: Khi reject phải có lý do
            if (rejectionReason == null || rejectionReason.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập lý do từ chối");
                response.sendRedirect("approve-payroll?action=detail&id=" + payrollId + "&error=missing_reason");
                return;
            }
            
            Payroll payroll = payrollDAO.getById(payrollId);
            if (payroll == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy bảng lương");
                return;
            }
            
            // Từ chối và cho phép HR sửa lại
            boolean success = payrollDAO.rejectPayroll(payrollId, currentUser.getEmployeeId(), rejectionReason);
            
            if (success) {
                // Ghi log (BR-15)
                systemLogDAO.insertLog(currentUser.getUserId(), 
                    "REJECT_PAYROLL", 
                    "Payroll", 
                    "PayrollID: " + payrollId + ", Status: Pending", 
                    "Status: Rejected, Reason: " + rejectionReason);
                
                request.setAttribute("success", "Đã từ chối bảng lương. HR có thể chỉnh sửa lại.");
                
                // TODO: Gửi thông báo cho HR về lý do từ chối (BR-24)
                
            } else {
                request.setAttribute("error", "Không thể từ chối bảng lương");
            }
            
            response.sendRedirect("approve-payroll?action=list");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID bảng lương không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi từ chối: " + e.getMessage());
            response.sendRedirect("approve-payroll?action=list");
        }
    }
}

package com.hrm.controller;

import com.hrm.dao.PayrollDAO;
import com.hrm.dao.EmployeeDAO;
import com.hrm.dao.SystemLogDAO;
import com.hrm.model.entity.Payroll;
import com.hrm.model.entity.Employee;
import com.hrm.model.entity.SystemUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;

import java.util.List;

/**
 * Controller xử lý xem phiếu lương
 * Chức năng #29: View Payslip (Level 3)
 * @author NamHD
 */
@WebServlet(name = "ViewPayslipController", urlPatterns = {"/view-payslip"})
public class ViewPayslipController extends HttpServlet {
    
    private final PayrollDAO payrollDAO = new PayrollDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();
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
        
        if (currentUser.getEmployeeId() == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tài khoản chưa được liên kết với nhân viên");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "list":
                    showPayslipHistory(request, response, currentUser);
                    break;
                case "detail":
                    showPayslipDetail(request, response, currentUser);
                    break;
                case "download":
                    downloadPayslip(request, response, currentUser);
                    break;
                default:
                    showPayslipHistory(request, response, currentUser);
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
                case "acknowledge":
                    acknowledgeReceipt(request, response, currentUser);
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
     * Hiển thị lịch sử phiếu lương của nhân viên
     */
    private void showPayslipHistory(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            // BR-11: Employees can view only their own salary records
            List<Payroll> myPayrolls = payrollDAO.getApprovedPayrollsByEmployee(currentUser.getEmployeeId());
            
            // Lấy thông tin nhân viên
            Employee employee = employeeDAO.getById(currentUser.getEmployeeId());
            
            // Tính tổng số tiền đã nhận
            double totalEarnings = myPayrolls.stream()
                .mapToDouble(p -> p.getNetSalary().doubleValue())
                .sum();
            
            // Thống kê theo năm
            String currentYear = String.valueOf(LocalDate.now().getYear());
            double yearlyEarnings = myPayrolls.stream()
                .filter(p -> p.getPayPeriod().startsWith(currentYear))
                .mapToDouble(p -> p.getNetSalary().doubleValue())
                .sum();
            
            request.setAttribute("myPayrolls", myPayrolls);
            request.setAttribute("employee", employee);
            request.setAttribute("totalEarnings", totalEarnings);
            request.setAttribute("yearlyEarnings", yearlyEarnings);
            request.setAttribute("currentYear", currentYear);
            
            request.getRequestDispatcher("/Views/employee/PayslipHistory.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải lịch sử phiếu lương: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị chi tiết phiếu lương
     */
    private void showPayslipDetail(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            int payrollId = Integer.parseInt(request.getParameter("id"));
            Payroll payroll = payrollDAO.getById(payrollId);
            
            if (payroll == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy phiếu lương");
                return;
            }
              // BR-11: Chỉ được xem phiếu lương của chính mình
            if (payroll.getEmployeeId() != currentUser.getEmployeeId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem phiếu lương này");
                return;
            }
            
            // Chỉ được xem phiếu lương đã được approve
            if (payroll.getApprovedBy() == null) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Phiếu lương chưa được phê duyệt");
                return;
            }
            
            // Lấy thông tin nhân viên
            Employee employee = employeeDAO.getById(currentUser.getEmployeeId());
            
            // Ghi log việc xem phiếu lương (BR-48: Restrict access based on hierarchy)
            systemLogDAO.insertLog(currentUser.getUserId(), 
                "VIEW_PAYSLIP", 
                "Payroll", 
                null, 
                "PayrollID: " + payrollId + ", Period: " + payroll.getPayPeriod());
            
            request.setAttribute("payroll", payroll);
            request.setAttribute("employee", employee);
            
            request.getRequestDispatcher("/Views/employee/PayslipDetail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID phiếu lương không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải chi tiết phiếu lương: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Download phiếu lương dưới dạng PDF
     */
    private void downloadPayslip(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            int payrollId = Integer.parseInt(request.getParameter("id"));
            Payroll payroll = payrollDAO.getById(payrollId);
            
            if (payroll == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy phiếu lương");
                return;
            }
              // Kiểm tra quyền
            if (payroll.getEmployeeId() != currentUser.getEmployeeId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền tải phiếu lương này");
                return;
            }
            
            if (payroll.getApprovedBy() == null) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Phiếu lương chưa được phê duyệt");
                return;
            }
            
            // Lấy thông tin nhân viên
            Employee employee = employeeDAO.getById(currentUser.getEmployeeId());
            
            // Ghi log việc download
            systemLogDAO.insertLog(currentUser.getUserId(), 
                "DOWNLOAD_PAYSLIP", 
                "Payroll", 
                null, 
                "PayrollID: " + payrollId + ", Period: " + payroll.getPayPeriod());
            
            // Set response headers for PDF download
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", 
                "attachment; filename=\"payslip_" + payroll.getPayPeriod() + "_" + employee.getFullName() + ".pdf\"");
            
            // TODO: Generate PDF content
            // For now, redirect to a PDF generation service or return HTML that can be printed
            request.setAttribute("payroll", payroll);
            request.setAttribute("employee", employee);
            request.setAttribute("downloadMode", true);
            
            request.getRequestDispatcher("/Views/employee/PayslipPDF.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID phiếu lương không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải phiếu lương: " + e.getMessage());
            response.sendRedirect("view-payslip?action=list");
        }
    }
    
    /**
     * Xác nhận đã nhận phiếu lương (BR-41)
     */
    private void acknowledgeReceipt(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            int payrollId = Integer.parseInt(request.getParameter("payrollId"));
            String acknowledgmentNote = request.getParameter("note");
            
            Payroll payroll = payrollDAO.getById(payrollId);
            if (payroll == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy phiếu lương");
                return;
            }
              // Kiểm tra quyền
            if (payroll.getEmployeeId() != currentUser.getEmployeeId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xác nhận phiếu lương này");
                return;
            }
            
            if (payroll.getApprovedBy() == null) {
                request.setAttribute("error", "Phiếu lương chưa được phê duyệt, không thể xác nhận");
                response.sendRedirect("view-payslip?action=detail&id=" + payrollId);
                return;
            }
            
            // Cập nhật trạng thái xác nhận
            boolean success = payrollDAO.acknowledgePayslip(payrollId, currentUser.getEmployeeId(), acknowledgmentNote);
            
            if (success) {
                // Ghi log (BR-41: Digital confirmation system)
                systemLogDAO.insertLog(currentUser.getUserId(), 
                    "ACKNOWLEDGE_PAYSLIP", 
                    "Payroll", 
                    "PayrollID: " + payrollId, 
                    "Acknowledged" + (acknowledgmentNote != null ? ", Note: " + acknowledgmentNote : ""));
                
                request.setAttribute("success", "Đã xác nhận nhận phiếu lương thành công");
                
            } else {
                request.setAttribute("error", "Không thể xác nhận nhận phiếu lương");
            }
            
            response.sendRedirect("view-payslip?action=detail&id=" + payrollId);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID phiếu lương không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi xác nhận: " + e.getMessage());
            response.sendRedirect("view-payslip?action=list");
        }
    }
}

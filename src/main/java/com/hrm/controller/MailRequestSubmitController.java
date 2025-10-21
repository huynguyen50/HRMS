package com.hrm.controller;

import com.hrm.dao.MailRequestDAO;
import com.hrm.dao.SystemLogDAO;
import com.hrm.dao.EmployeeDAO;
import com.hrm.model.entity.MailRequest;
import com.hrm.model.entity.SystemUser;
import com.hrm.model.entity.Employee;
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
 * Controller xử lý gửi đơn từ
 * Chức năng #15: Mail Request - Submit (Level 3)
 * @author NamHD
 */
@WebServlet(name = "MailRequestSubmitController", urlPatterns = {"/mail-request-submit"})
public class MailRequestSubmitController extends HttpServlet {
    
    private final MailRequestDAO mailRequestDAO = new MailRequestDAO();
    private final SystemLogDAO systemLogDAO = new SystemLogDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        SystemUser currentUser = (SystemUser) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "list":
                    showMyRequests(request, response, currentUser);
                    break;
                case "new":
                    showNewRequestForm(request, response);
                    break;
                case "detail":
                    showRequestDetail(request, response, currentUser);
                    break;
                default:
                    showMyRequests(request, response, currentUser);
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
                case "submit":
                    submitNewRequest(request, response, currentUser);
                    break;
                case "cancel":
                    cancelRequest(request, response, currentUser);
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
     * Hiển thị danh sách đơn từ của nhân viên hiện tại
     */
    private void showMyRequests(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            if (currentUser.getEmployeeId() == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tài khoản chưa được liên kết với nhân viên");
                return;
            }
            
            List<MailRequest> myRequests = mailRequestDAO.getByEmployee(currentUser.getEmployeeId());
            
            request.setAttribute("myRequests", myRequests);
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("/Views/employee/MailRequestList.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách đơn từ: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị form tạo đơn từ mới
     */
    private void showNewRequestForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/Views/employee/MailRequestForm.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị chi tiết đơn từ
     */
    private void showRequestDetail(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            int requestId = Integer.parseInt(request.getParameter("id"));
            MailRequest mailRequest = mailRequestDAO.getById(requestId);
            
            if (mailRequest == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn từ");
                return;
            }
              // Kiểm tra quyền xem (chỉ người tạo đơn mới được xem)
            if (mailRequest.getEmployeeId() != currentUser.getEmployeeId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem đơn từ này");
                return;
            }
            
            request.setAttribute("mailRequest", mailRequest);
            request.getRequestDispatcher("/Views/employee/MailRequestDetail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID đơn từ không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải chi tiết đơn từ: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Gửi đơn từ mới
     */
    private void submitNewRequest(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            if (currentUser.getEmployeeId() == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tài khoản chưa được liên kết với nhân viên");
                return;
            }
            
            // Lấy thông tin từ form
            String requestType = request.getParameter("requestType");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String reason = request.getParameter("reason");
            
            // Validate input
            if (requestType == null || requestType.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng chọn loại đơn từ");
                showNewRequestForm(request, response);
                return;
            }
            
            if (reason == null || reason.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập lý do");
                showNewRequestForm(request, response);
                return;
            }
            
            // Validate dates cho đơn nghỉ phép
            LocalDate startDate = null;
            LocalDate endDate = null;
            
            if ("Leave".equals(requestType)) {
                if (startDateStr == null || startDateStr.trim().isEmpty()) {
                    request.setAttribute("error", "Vui lòng chọn ngày bắt đầu nghỉ");
                    showNewRequestForm(request, response);
                    return;
                }
                
                try {
                    startDate = LocalDate.parse(startDateStr);
                    if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                        endDate = LocalDate.parse(endDateStr);
                        
                        if (endDate.isBefore(startDate)) {
                            request.setAttribute("error", "Ngày kết thúc phải sau ngày bắt đầu");
                            showNewRequestForm(request, response);
                            return;
                        }
                    }
                    
                    // Kiểm tra không được nghỉ quá khứ
                    if (startDate.isBefore(LocalDate.now())) {
                        request.setAttribute("error", "Không thể đăng ký nghỉ phép cho ngày đã qua");
                        showNewRequestForm(request, response);
                        return;
                    }
                    
                } catch (Exception e) {
                    request.setAttribute("error", "Định dạng ngày không hợp lệ");
                    showNewRequestForm(request, response);
                    return;
                }
            }
            
            // Tạo đơn từ mới
            MailRequest mailRequest = new MailRequest();
            mailRequest.setEmployeeId(currentUser.getEmployeeId());
            mailRequest.setRequestType(requestType);
            mailRequest.setStartDate(startDate);
            mailRequest.setEndDate(endDate);
            mailRequest.setReason(reason.trim());
            mailRequest.setStatus("Pending");
            
            // Lưu vào database
            boolean success = mailRequestDAO.insert(mailRequest);
            
            if (success) {
                // Ghi log
                systemLogDAO.insertLog(currentUser.getUserId(), 
                    "SUBMIT_MAIL_REQUEST", 
                    "MailRequest", 
                    null, 
                    "Type: " + requestType + ", Reason: " + reason);
                
                request.setAttribute("success", "Đã gửi đơn từ thành công. Đơn của bạn đang chờ phê duyệt.");
                
                // Gửi email thông báo cho manager (optional)
                // sendNotificationEmail(currentUser.getEmployeeId(), mailRequest);
                
            } else {
                request.setAttribute("error", "Không thể gửi đơn từ. Vui lòng thử lại.");
            }
            
            // Redirect về danh sách
            response.sendRedirect("mail-request-submit?action=list");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi gửi đơn từ: " + e.getMessage());
            showNewRequestForm(request, response);
        }
    }
    
    /**
     * Hủy đơn từ (chỉ với đơn đang Pending)
     */
    private void cancelRequest(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            MailRequest mailRequest = mailRequestDAO.getById(requestId);
            
            if (mailRequest == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn từ");
                return;
            }
              // Kiểm tra quyền hủy
            if (mailRequest.getEmployeeId() != currentUser.getEmployeeId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền hủy đơn từ này");
                return;
            }
            
            // Chỉ được hủy đơn đang Pending
            if (!"Pending".equals(mailRequest.getStatus())) {
                request.setAttribute("error", "Chỉ có thể hủy đơn từ đang chờ phê duyệt");
                response.sendRedirect("mail-request-submit?action=list");
                return;
            }
            
            // Cập nhật trạng thái thành Cancelled
            boolean success = mailRequestDAO.updateStatus(requestId, "Cancelled", currentUser.getUserId());
            
            if (success) {
                // Ghi log
                systemLogDAO.insertLog(currentUser.getUserId(), 
                    "CANCEL_MAIL_REQUEST", 
                    "MailRequest", 
                    "Pending", 
                    "Cancelled - RequestID: " + requestId);
                
                request.setAttribute("success", "Đã hủy đơn từ thành công");
            } else {
                request.setAttribute("error", "Không thể hủy đơn từ");
            }
            
            // Redirect về danh sách
            response.sendRedirect("mail-request-submit?action=list");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID đơn từ không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi hủy đơn từ: " + e.getMessage());
            response.sendRedirect("mail-request-submit?action=list");
        }
    }
    
    /**
     * Gửi email thông báo cho manager (optional feature)
     */
    // private void sendNotificationEmail(int employeeId, MailRequest mailRequest) {
    //     // Implementation để gửi email thông báo
    //     // Có thể sử dụng EmailSender class đã có sẵn
    // }
}

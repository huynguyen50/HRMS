package com.hrm.controller;

import com.hrm.dao.MailRequestDAO;
import com.hrm.dao.SystemLogDAO;
import com.hrm.model.entity.MailRequest;
import com.hrm.model.entity.SystemUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller xử lý phê duyệt đơn từ
 * Chức năng #14: Mail Request - Approval (Level 2)
 * @author NamHD
 */
@WebServlet(name = "MailRequestApprovalController", urlPatterns = {"/mail-request-approval"})
public class MailRequestApprovalController extends HttpServlet {
    
    private final MailRequestDAO mailRequestDAO = new MailRequestDAO();
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
        
        // Chỉ Department Manager và HR Manager mới có quyền approve
        if (currentUser.getRoleId() != 2 && currentUser.getRoleId() != 3) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "list":
                    showPendingRequests(request, response, currentUser);
                    break;
                case "detail":
                    showRequestDetail(request, response);
                    break;
                default:
                    showPendingRequests(request, response, currentUser);
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
                case "approve":
                    approveRequest(request, response, currentUser);
                    break;
                case "reject":
                    rejectRequest(request, response, currentUser);
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
     * Hiển thị danh sách đơn từ đang chờ phê duyệt
     */
    private void showPendingRequests(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            List<MailRequest> pendingRequests;
            
            // HR Manager có thể xem tất cả đơn từ
            if (currentUser.getRoleId() == 2) {
                pendingRequests = mailRequestDAO.getAllPendingRequests();
            } else {
                // Department Manager chỉ xem đơn từ của phòng ban mình
                pendingRequests = mailRequestDAO.getPendingRequestsByDepartment(currentUser.getEmployeeId());
            }
            
            request.setAttribute("pendingRequests", pendingRequests);
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("/Views/hr/MailRequestApproval.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách đơn từ: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị chi tiết đơn từ
     */
    private void showRequestDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int requestId = Integer.parseInt(request.getParameter("id"));
            MailRequest mailRequest = mailRequestDAO.getById(requestId);
            
            if (mailRequest == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn từ");
                return;
            }
            
            request.setAttribute("mailRequest", mailRequest);
            request.getRequestDispatcher("/Views/hr/MailRequestDetail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID đơn từ không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải chi tiết đơn từ: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Phê duyệt đơn từ
     */
    private void approveRequest(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            String comment = request.getParameter("comment");
            
            // Cập nhật trạng thái đơn từ
            boolean success = mailRequestDAO.updateStatus(requestId, "Approved", currentUser.getUserId());
            
            if (success) {
                // Ghi log
                systemLogDAO.insertLog(currentUser.getUserId(), 
                    "APPROVE_MAIL_REQUEST", 
                    "MailRequest", 
                    "Pending", 
                    "Approved - RequestID: " + requestId + (comment != null ? ", Comment: " + comment : ""));
                
                request.setAttribute("success", "Đã phê duyệt đơn từ thành công");
            } else {
                request.setAttribute("error", "Không thể phê duyệt đơn từ");
            }
            
            // Redirect về danh sách
            response.sendRedirect("mail-request-approval?action=list");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID đơn từ không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi phê duyệt: " + e.getMessage());
            response.sendRedirect("mail-request-approval?action=list&error=" + e.getMessage());
        }
    }
    
    /**
     * Từ chối đơn từ
     */
    private void rejectRequest(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            String comment = request.getParameter("comment");
            
            // Cập nhật trạng thái đơn từ
            boolean success = mailRequestDAO.updateStatus(requestId, "Rejected", currentUser.getUserId());
            
            if (success) {
                // Ghi log
                systemLogDAO.insertLog(currentUser.getUserId(), 
                    "REJECT_MAIL_REQUEST", 
                    "MailRequest", 
                    "Pending", 
                    "Rejected - RequestID: " + requestId + (comment != null ? ", Comment: " + comment : ""));
                
                request.setAttribute("success", "Đã từ chối đơn từ");
            } else {
                request.setAttribute("error", "Không thể từ chối đơn từ");
            }
            
            // Redirect về danh sách
            response.sendRedirect("mail-request-approval?action=list");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID đơn từ không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi từ chối: " + e.getMessage());
            response.sendRedirect("mail-request-approval?action=list&error=" + e.getMessage());
        }
    }
}

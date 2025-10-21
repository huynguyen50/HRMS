package com.hrm.controller;

import com.hrm.dao.TaskDAO;
import com.hrm.dao.EmployeeDAO;
import com.hrm.dao.SystemLogDAO;
import com.hrm.model.entity.Task;
import com.hrm.model.entity.Employee;
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
 * Controller xử lý phê duyệt kết quả công việc
 * Chức năng #27: Approve Task Results (Level 2)
 * @author NamHD
 */
@WebServlet(name = "ApproveTaskResultController", urlPatterns = {"/approve-task-result"})
public class ApproveTaskResultController extends HttpServlet {
    
    private final TaskDAO taskDAO = new TaskDAO();
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
        
        // Chỉ Department Manager mới có quyền approve task results (BR-07)
        if (currentUser.getRoleId() != 3) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền phê duyệt kết quả công việc");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "list":
                    showPendingApprovals(request, response, currentUser);
                    break;
                case "detail":
                    showTaskDetail(request, response, currentUser);
                    break;
                default:
                    showPendingApprovals(request, response, currentUser);
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
                    approveTaskResult(request, response, currentUser);
                    break;
                case "reject":
                    rejectTaskResult(request, response, currentUser);
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
     * Hiển thị danh sách task đang chờ phê duyệt
     */
    private void showPendingApprovals(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            // Lấy task được giao bởi manager này và đang ở trạng thái Completed
            List<Task> pendingApprovals = taskDAO.getCompletedTasksByAssigner(currentUser.getEmployeeId());
            
            request.setAttribute("pendingApprovals", pendingApprovals);
            request.setAttribute("currentUser", currentUser);
            
            request.getRequestDispatcher("/Views/manager/TaskApprovalList.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách task cần phê duyệt: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị chi tiết task cần phê duyệt
     */
    private void showTaskDetail(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            int taskId = Integer.parseInt(request.getParameter("id"));
            Task task = taskDAO.getById(taskId);
            
            if (task == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy task");
                return;
            }
            
            // Kiểm tra quyền - chỉ người giao việc mới được phê duyệt (BR-09)
            if (task.getAssignedBy() != currentUser.getEmployeeId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền phê duyệt task này");
                return;
            }
            
            // Chỉ được phê duyệt task ở trạng thái Completed
            if (!"Completed".equals(task.getStatus())) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Task chưa hoàn thành, không thể phê duyệt");
                return;
            }
            
            // Lấy thông tin nhân viên thực hiện
            Employee assignee = employeeDAO.getById(task.getAssignTo());
            
            request.setAttribute("task", task);
            request.setAttribute("assignee", assignee);
            request.setAttribute("currentUser", currentUser);
            
            request.getRequestDispatcher("/Views/manager/TaskApprovalDetail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID task không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải chi tiết task: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Phê duyệt kết quả task
     */
    private void approveTaskResult(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            String approverComment = request.getParameter("comment");
            
            Task task = taskDAO.getById(taskId);
            if (task == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy task");
                return;
            }
            
            // Kiểm tra quyền (BR-09: Không thể approve task của chính mình)
            if (task.getAssignedBy() != currentUser.getEmployeeId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền phê duyệt task này");
                return;
            }
            
            // Kiểm tra trạng thái
            if (!"Completed".equals(task.getStatus())) {
                request.setAttribute("error", "Chỉ có thể phê duyệt task đã hoàn thành");
                response.sendRedirect("approve-task-result?action=detail&id=" + taskId);
                return;
            }
            
            // Cập nhật trạng thái thành Approved
            boolean success = taskDAO.approveTaskResult(taskId, "Approved", approverComment, currentUser.getEmployeeId());
            
            if (success) {
                // Ghi log (BR-15: Log mọi hành động approve/reject)
                systemLogDAO.insertLog(currentUser.getUserId(), 
                    "APPROVE_TASK_RESULT", 
                    "Task", 
                    "TaskID: " + taskId + ", Status: Completed", 
                    "Status: Approved" + (approverComment != null ? ", Comment: " + approverComment : ""));
                
                request.setAttribute("success", "Đã phê duyệt kết quả task thành công");
                
                // TODO: Gửi thông báo cho nhân viên (BR-24)
                
            } else {
                request.setAttribute("error", "Không thể phê duyệt task");
            }
            
            response.sendRedirect("approve-task-result?action=list");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID task không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi phê duyệt: " + e.getMessage());
            response.sendRedirect("approve-task-result?action=list");
        }
    }
    
    /**
     * Từ chối kết quả task
     */
    private void rejectTaskResult(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            String rejectionReason = request.getParameter("rejectionReason");
            
            // BR-19: Khi reject phải có lý do
            if (rejectionReason == null || rejectionReason.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập lý do từ chối");
                response.sendRedirect("approve-task-result?action=detail&id=" + taskId + "&error=missing_reason");
                return;
            }
            
            Task task = taskDAO.getById(taskId);
            if (task == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy task");
                return;
            }
            
            // Kiểm tra quyền
            if (task.getAssignedBy() != currentUser.getEmployeeId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền từ chối task này");
                return;
            }
            
            // Kiểm tra trạng thái
            if (!"Completed".equals(task.getStatus())) {
                request.setAttribute("error", "Chỉ có thể từ chối task đã hoàn thành");
                response.sendRedirect("approve-task-result?action=detail&id=" + taskId);
                return;
            }
            
            // Cập nhật trạng thái thành Rejected và cho phép làm lại
            boolean success = taskDAO.approveTaskResult(taskId, "In Progress", rejectionReason, currentUser.getEmployeeId());
            
            if (success) {
                // Ghi log (BR-15)
                systemLogDAO.insertLog(currentUser.getUserId(), 
                    "REJECT_TASK_RESULT", 
                    "Task", 
                    "TaskID: " + taskId + ", Status: Completed", 
                    "Status: In Progress, Reason: " + rejectionReason);
                
                request.setAttribute("success", "Đã từ chối kết quả task. Nhân viên có thể làm lại.");
                
                // TODO: Gửi thông báo cho nhân viên về lý do từ chối (BR-24)
                
            } else {
                request.setAttribute("error", "Không thể từ chối task");
            }
            
            response.sendRedirect("approve-task-result?action=list");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID task không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi từ chối: " + e.getMessage());
            response.sendRedirect("approve-task-result?action=list");
        }
    }
}

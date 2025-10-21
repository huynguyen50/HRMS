package com.hrm.controller;

import com.hrm.dao.TaskDAO;
import com.hrm.dao.SystemLogDAO;
import com.hrm.model.entity.Task;
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
 * Controller xử lý cập nhật trạng thái công việc
 * Chức năng #25: Update Task Status (Level 3)
 * @author NamHD
 */
@WebServlet(name = "UpdateTaskStatusController", urlPatterns = {"/update-task-status"})
public class UpdateTaskStatusController extends HttpServlet {
    
    private final TaskDAO taskDAO = new TaskDAO();
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
                    showMyTasks(request, response, currentUser);
                    break;
                default:
                    showMyTasks(request, response, currentUser);
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
                case "update-status":
                    updateTaskStatus(request, response, currentUser);
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
     * Hiển thị danh sách công việc được giao cho nhân viên hiện tại
     */
    private void showMyTasks(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            List<Task> myTasks = taskDAO.getTasksByAssignee(currentUser.getEmployeeId());
            
            // Phân loại task theo status
            long pendingTasks = myTasks.stream().filter(t -> "Pending".equals(t.getStatus())).count();
            long inProgressTasks = myTasks.stream().filter(t -> "In Progress".equals(t.getStatus())).count();
            long completedTasks = myTasks.stream().filter(t -> "Completed".equals(t.getStatus())).count();
            
            request.setAttribute("myTasks", myTasks);
            request.setAttribute("pendingCount", pendingTasks);
            request.setAttribute("inProgressCount", inProgressTasks);
            request.setAttribute("completedCount", completedTasks);
            request.setAttribute("currentUser", currentUser);
            
            request.getRequestDispatcher("/Views/employee/TaskList.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách công việc: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Cập nhật trạng thái công việc
     */
    private void updateTaskStatus(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            String newStatus = request.getParameter("status");
            String progress = request.getParameter("progress");
            String note = request.getParameter("note");
            
            Task task = taskDAO.getById(taskId);
            if (task == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy công việc");
                return;
            }
              // Kiểm tra quyền cập nhật (BR-09: Không thể approve công việc của chính mình)
            if (task.getAssignTo() != currentUser.getEmployeeId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền cập nhật công việc này");
                return;
            }
            
            // Validate status transition
            if (!isValidStatusTransition(task.getStatus(), newStatus)) {
                request.setAttribute("error", "Không thể chuyển từ trạng thái '" + task.getStatus() + "' sang '" + newStatus + "'");
                response.sendRedirect("update-task-status?action=list&error=invalid_transition");
                return;
            }
            
            // Cập nhật task
            String oldStatus = task.getStatus();
            boolean success = taskDAO.updateTaskStatus(taskId, newStatus, progress, note);
            
            if (success) {
                // Ghi log (BR-15: Log mọi hành động)
                systemLogDAO.insertLog(currentUser.getUserId(), 
                    "UPDATE_TASK_STATUS", 
                    "Task", 
                    "TaskID: " + taskId + ", Status: " + oldStatus, 
                    "Status: " + newStatus + (progress != null ? ", Progress: " + progress : "") + 
                    (note != null ? ", Note: " + note : ""));
                
                request.setAttribute("success", "Đã cập nhật trạng thái công việc thành công");
                
            } else {
                request.setAttribute("error", "Không thể cập nhật trạng thái công việc");
            }
            
            response.sendRedirect("update-task-status?action=list");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thông tin không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi cập nhật: " + e.getMessage());
            response.sendRedirect("update-task-status?action=list");
        }
    }
    
    // ...existing code... (additional methods)
    
    /**
     * Kiểm tra tính hợp lệ của việc chuyển trạng thái
     */
    private boolean isValidStatusTransition(String currentStatus, String newStatus) {
        switch (currentStatus) {
            case "Pending":
                return "In Progress".equals(newStatus);
            case "In Progress":
                return "Completed".equals(newStatus) || "Pending".equals(newStatus);
            case "Completed":
                return false; // Không thể thay đổi từ Completed
            case "Rejected":
                return false; // Không thể thay đổi từ Rejected
            default:
                return false;
        }
    }
}
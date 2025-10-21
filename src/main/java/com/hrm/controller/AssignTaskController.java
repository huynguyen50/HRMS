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
import java.time.LocalDate;
import java.util.List;

/**
 * Controller xử lý giao việc
 * Chức năng #26: Assign Task (Level 3)
 * @author NamHD
 */
@WebServlet(name = "AssignTaskController", urlPatterns = {"/assign-task"})
public class AssignTaskController extends HttpServlet {
    
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
        
        // Chỉ Department Manager mới có quyền giao việc (BR-07)
        if (currentUser.getRoleId() != 3) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền giao việc");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "list":
                    showAssignedTasks(request, response, currentUser);
                    break;
                case "new":
                    showAssignForm(request, response, currentUser);
                    break;
                default:
                    showAssignedTasks(request, response, currentUser);
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
                case "assign":
                    assignNewTask(request, response, currentUser);
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
     * Hiển thị danh sách task đã giao
     */
    private void showAssignedTasks(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            List<Task> assignedTasks = taskDAO.getTasksByAssigner(currentUser.getEmployeeId());
            
            request.setAttribute("assignedTasks", assignedTasks);
            request.setAttribute("currentUser", currentUser);
            
            request.getRequestDispatcher("/Views/manager/AssignedTaskList.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách task: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị form giao việc mới
     */
    private void showAssignForm(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            // Lấy danh sách nhân viên trong phòng ban (BR-07)
            List<Employee> departmentEmployees = employeeDAO.getEmployeesByManager(currentUser.getEmployeeId());
            
            request.setAttribute("employees", departmentEmployees);
            request.getRequestDispatcher("/Views/manager/AssignTaskForm.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải form giao việc: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Giao việc mới
     */
    private void assignNewTask(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            // Lấy thông tin từ form
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            int assignToId = Integer.parseInt(request.getParameter("assignTo"));
            String startDateStr = request.getParameter("startDate");
            String dueDateStr = request.getParameter("dueDate");
            
            // Validate input
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập tiêu đề công việc");
                showAssignForm(request, response, currentUser);
                return;
            }
            
            // Parse dates
            LocalDate startDate = LocalDate.now();
            LocalDate dueDate = null;
            
            if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                startDate = LocalDate.parse(startDateStr);
            }
            
            if (dueDateStr != null && !dueDateStr.trim().isEmpty()) {
                dueDate = LocalDate.parse(dueDateStr);
            }
            
            // Tạo task mới
            Task task = new Task();
            task.setTitle(title.trim());
            task.setDescription(description != null ? description.trim() : "");
            task.setAssignedBy(currentUser.getEmployeeId());
            task.setAssignTo(assignToId);
            task.setStartDate(startDate);
            task.setDueDate(dueDate);
            task.setStatus("Pending");
            
            // Lưu vào database
            boolean success = taskDAO.insert(task);
            
            if (success) {
                // Ghi log (BR-15)
                systemLogDAO.insertLog(currentUser.getUserId(), 
                    "ASSIGN_TASK", 
                    "Task", 
                    null, 
                    "Assigned to EmployeeID: " + assignToId + ", Title: " + title);
                
                request.setAttribute("success", "Đã giao việc thành công");
            } else {
                request.setAttribute("error", "Không thể giao việc. Vui lòng thử lại.");
            }
            
            response.sendRedirect("assign-task?action=list");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thông tin nhân viên không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi giao việc: " + e.getMessage());
            showAssignForm(request, response, currentUser);
        }
    }
}
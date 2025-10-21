
package com.hrm.controller.hr;

import com.hrm.dao.EmployeeDAO;
import com.hrm.dao.TaskDAO;
import com.hrm.model.entity.Employee;
import com.hrm.model.entity.Task;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
@WebServlet(name="TaskManagementController", urlPatterns={"/TaskManagementController"})
public class TaskManagementController extends HttpServlet {
   
    private EmployeeDAO employeeDAO = new EmployeeDAO();
    private TaskDAO taskDAO = new TaskDAO();
    
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Get all employees for task assignment
            List<Employee> employees = employeeDAO.getAll();
            
            // Get all tasks
            List<Task> tasks = taskDAO.getAll();
            
            // Set attributes for JSP
            request.setAttribute("employees", employees);
            request.setAttribute("tasks", tasks);
            
            // Forward to TaskManagement.jsp
            request.getRequestDispatcher("/Views/hr/TaskManagement.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading task management data: " + e.getMessage());
            request.getRequestDispatcher("/Views/hr/TaskManagement.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            
            if ("createTask".equals(action)) {
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                int assignedBy = Integer.parseInt(request.getParameter("assignedBy"));
                int assignTo = Integer.parseInt(request.getParameter("assignTo"));
                String dueDate = request.getParameter("dueDate");
                String status = request.getParameter("status");
                
                Task task = new Task();
                task.setTitle(title);
                task.setDescription(description);
                task.setAssignedBy(assignedBy);
                task.setAssignTo(assignTo);
                task.setDueDate(java.time.LocalDate.parse(dueDate));
                task.setStatus(status);
                
                boolean success = taskDAO.insert(task);
                
                if (success) {
                    request.setAttribute("success", "Task created successfully!");
                } else {
                    request.setAttribute("error", "Failed to create task!");
                }
            }
            
            // Redirect back to TaskManagementController to reload data
            response.sendRedirect(request.getContextPath() + "/TaskManagementController");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error creating task: " + e.getMessage());
            processRequest(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Task Management Controller";
    }
}
package com.hrm.controller;

import com.hrm.dao.PayrollDAO;
import com.hrm.dao.EmployeeDAO;
import com.hrm.dao.SystemLogDAO;
import com.hrm.model.entity.Payroll;
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
 * Controller xử lý bảng lương
 * Chức năng #24: Payroll (Level 2)
 * @author NamHD
 */
@WebServlet(name = "PayrollController", urlPatterns = {"/payroll"})
public class PayrollController extends HttpServlet {
    
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
        
        // Chỉ HR có quyền truy cập payroll
        if (currentUser.getRoleId() != 2 && currentUser.getRoleId() != 4) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "list":
                    showPayrollList(request, response);
                    break;
                case "calculate":
                    showCalculateForm(request, response);
                    break;
                case "employee-payroll":
                    showEmployeePayroll(request, response);
                    break;
                case "period-summary":
                    showPeriodSummary(request, response);
                    break;
                default:
                    showPayrollList(request, response);
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
        
        // Chỉ HR có quyền thực hiện các action payroll
        if (currentUser.getRoleId() != 2 && currentUser.getRoleId() != 4) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thực hiện chức năng này");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "calculate-single":
                    calculateSingleEmployeePayroll(request, response, currentUser);
                    break;
                case "calculate-all":
                    calculateAllEmployeesPayroll(request, response, currentUser);
                    break;
                case "calculate-department":
                    calculateDepartmentPayroll(request, response, currentUser);
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
     * Hiển thị danh sách bảng lương theo kỳ
     */
    private void showPayrollList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String payPeriod = request.getParameter("period");
            if (payPeriod == null || payPeriod.trim().isEmpty()) {
                // Mặc định là tháng hiện tại
                payPeriod = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
            }
            
            List<Payroll> payrolls = payrollDAO.getAllPayrollByPeriod(payPeriod);
            
            request.setAttribute("payrolls", payrolls);
            request.setAttribute("currentPeriod", payPeriod);
            request.getRequestDispatcher("/Views/hr/PayrollList.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách bảng lương: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị form tính lương
     */
    private void showCalculateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy danh sách nhân viên đang active
            List<Employee> activeEmployees = employeeDAO.getActiveEmployees();
            
            request.setAttribute("employees", activeEmployees);
            request.getRequestDispatcher("/Views/hr/PayrollCalculate.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải form tính lương: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị bảng lương của một nhân viên
     */
    private void showEmployeePayroll(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int employeeId = Integer.parseInt(request.getParameter("employeeId"));
            String payPeriod = request.getParameter("period");
            
            if (payPeriod == null || payPeriod.trim().isEmpty()) {
                payPeriod = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
            }
            
            List<Payroll> employeePayrolls = payrollDAO.getPayrollByEmployee(employeeId, payPeriod);
            Employee employee = employeeDAO.getById(employeeId);
            
            request.setAttribute("employeePayrolls", employeePayrolls);
            request.setAttribute("employee", employee);
            request.setAttribute("period", payPeriod);
            request.getRequestDispatcher("/Views/hr/EmployeePayroll.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID nhân viên không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải bảng lương nhân viên: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị tổng hợp lương theo kỳ
     */
    private void showPeriodSummary(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String payPeriod = request.getParameter("period");
            if (payPeriod == null || payPeriod.trim().isEmpty()) {
                payPeriod = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
            }
            
            List<Payroll> payrolls = payrollDAO.getAllPayrollByPeriod(payPeriod);
            
            // Tính tổng hợp
            double totalBaseSalary = payrolls.stream()
                .mapToDouble(p -> p.getBaseSalary().doubleValue())
                .sum();
            
            double totalAllowance = payrolls.stream()
                .mapToDouble(p -> p.getAllowance().doubleValue())
                .sum();
            
            double totalBonus = payrolls.stream()
                .mapToDouble(p -> p.getBonus().doubleValue())
                .sum();
            
            double totalDeduction = payrolls.stream()
                .mapToDouble(p -> p.getDeduction().doubleValue())
                .sum();
            
            double totalNetSalary = payrolls.stream()
                .mapToDouble(p -> p.getNetSalary().doubleValue())
                .sum();
            
            request.setAttribute("payrolls", payrolls);
            request.setAttribute("period", payPeriod);
            request.setAttribute("totalBaseSalary", totalBaseSalary);
            request.setAttribute("totalAllowance", totalAllowance);
            request.setAttribute("totalBonus", totalBonus);
            request.setAttribute("totalDeduction", totalDeduction);
            request.setAttribute("totalNetSalary", totalNetSalary);
            request.setAttribute("employeeCount", payrolls.size());
            
            request.getRequestDispatcher("/Views/hr/PayrollSummary.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải tổng hợp lương: " + e.getMessage());
            request.getRequestDispatcher("/Views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Tính lương cho một nhân viên
     */
    private void calculateSingleEmployeePayroll(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            int employeeId = Integer.parseInt(request.getParameter("employeeId"));
            String payPeriod = request.getParameter("payPeriod");
            
            if (payPeriod == null || payPeriod.trim().isEmpty()) {
                payPeriod = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
            }
            
            // Kiểm tra xem đã có bảng lương cho kỳ này chưa
            List<Payroll> existingPayrolls = payrollDAO.getPayrollByEmployee(employeeId, payPeriod);
            if (!existingPayrolls.isEmpty()) {
                request.setAttribute("error", "Đã có bảng lương cho nhân viên này trong kỳ " + payPeriod);
                showCalculateForm(request, response);
                return;
            }
            
            boolean success = payrollDAO.calculatePayroll(employeeId, payPeriod, currentUser.getUserId());
            
            if (success) {
                // Ghi log
                systemLogDAO.insertLog(currentUser.getUserId(), 
                    "CALCULATE_PAYROLL", 
                    "Payroll", 
                    null, 
                    "EmployeeID: " + employeeId + ", Period: " + payPeriod);
                
                request.setAttribute("success", "Đã tính lương thành công cho nhân viên");
            } else {
                request.setAttribute("error", "Không thể tính lương. Vui lòng kiểm tra dữ liệu chấm công và hợp đồng.");
            }
            
            response.sendRedirect("payroll?action=list&period=" + payPeriod);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thông tin không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi tính lương: " + e.getMessage());
            showCalculateForm(request, response);
        }
    }
    
    /**
     * Tính lương cho tất cả nhân viên
     */
    private void calculateAllEmployeesPayroll(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            String payPeriod = request.getParameter("payPeriod");
            
            if (payPeriod == null || payPeriod.trim().isEmpty()) {
                payPeriod = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
            }
            
            List<Employee> activeEmployees = employeeDAO.getActiveEmployees();
            int successCount = 0;
            int failCount = 0;
            
            for (Employee employee : activeEmployees) {
                try {
                    // Kiểm tra xem đã có bảng lương chưa
                    List<Payroll> existingPayrolls = payrollDAO.getPayrollByEmployee(employee.getEmployeeId(), payPeriod);
                    if (!existingPayrolls.isEmpty()) {
                        continue; // Skip nếu đã có
                    }
                    
                    boolean success = payrollDAO.calculatePayroll(employee.getEmployeeId(), payPeriod, currentUser.getUserId());
                    if (success) {
                        successCount++;
                    } else {
                        failCount++;
                    }
                } catch (Exception e) {
                    failCount++;
                    System.err.println("Error calculating payroll for employee " + employee.getEmployeeId() + ": " + e.getMessage());
                }
            }
            
            // Ghi log
            systemLogDAO.insertLog(currentUser.getUserId(), 
                "CALCULATE_ALL_PAYROLL", 
                "Payroll", 
                null, 
                "Period: " + payPeriod + ", Success: " + successCount + ", Failed: " + failCount);
            
            if (successCount > 0) {
                request.setAttribute("success", "Đã tính lương thành công cho " + successCount + " nhân viên" +
                    (failCount > 0 ? ". Có " + failCount + " nhân viên không thể tính lương." : ""));
            } else {
                request.setAttribute("error", "Không thể tính lương cho bất kỳ nhân viên nào. Vui lòng kiểm tra dữ liệu.");
            }
            
            response.sendRedirect("payroll?action=list&period=" + payPeriod);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi tính lương hàng loạt: " + e.getMessage());
            showCalculateForm(request, response);
        }
    }
    
    /**
     * Tính lương cho tất cả nhân viên trong một phòng ban
     */
    private void calculateDepartmentPayroll(HttpServletRequest request, HttpServletResponse response, SystemUser currentUser)
            throws ServletException, IOException {
        
        try {
            int departmentId = Integer.parseInt(request.getParameter("departmentId"));
            String payPeriod = request.getParameter("payPeriod");
            
            if (payPeriod == null || payPeriod.trim().isEmpty()) {
                payPeriod = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
            }
            
            List<Employee> departmentEmployees = employeeDAO.getByDepartment(departmentId);
            int successCount = 0;
            int failCount = 0;
            
            for (Employee employee : departmentEmployees) {
                if (!"Active".equals(employee.getStatus())) {
                    continue; // Skip inactive employees
                }
                
                try {
                    // Kiểm tra xem đã có bảng lương chưa
                    List<Payroll> existingPayrolls = payrollDAO.getPayrollByEmployee(employee.getEmployeeId(), payPeriod);
                    if (!existingPayrolls.isEmpty()) {
                        continue; // Skip nếu đã có
                    }
                    
                    boolean success = payrollDAO.calculatePayroll(employee.getEmployeeId(), payPeriod, currentUser.getUserId());
                    if (success) {
                        successCount++;
                    } else {
                        failCount++;
                    }
                } catch (Exception e) {
                    failCount++;
                    System.err.println("Error calculating payroll for employee " + employee.getEmployeeId() + ": " + e.getMessage());
                }
            }
            
            // Ghi log
            systemLogDAO.insertLog(currentUser.getUserId(), 
                "CALCULATE_DEPT_PAYROLL", 
                "Payroll", 
                null, 
                "DepartmentID: " + departmentId + ", Period: " + payPeriod + ", Success: " + successCount + ", Failed: " + failCount);
            
            if (successCount > 0) {
                request.setAttribute("success", "Đã tính lương thành công cho " + successCount + " nhân viên trong phòng ban" +
                    (failCount > 0 ? ". Có " + failCount + " nhân viên không thể tính lương." : ""));
            } else {
                request.setAttribute("error", "Không thể tính lương cho nhân viên nào trong phòng ban này.");
            }
            
            response.sendRedirect("payroll?action=list&period=" + payPeriod);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID phòng ban không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi tính lương phòng ban: " + e.getMessage());
            showCalculateForm(request, response);
        }
    }
}

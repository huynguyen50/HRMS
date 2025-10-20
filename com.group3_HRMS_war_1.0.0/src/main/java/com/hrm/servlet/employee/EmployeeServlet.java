package com.hrm.servlet.employee;

import com.hrm.model.entity.Employee;
import com.hrm.service.DepartmentService;
import com.hrm.service.EmployeeService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;

@WebServlet("/admin/employees")
@MultipartConfig
public class EmployeeServlet extends HttpServlet {
    private final EmployeeService employeeService = new EmployeeService();
    private final DepartmentService departmentService = new DepartmentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "edit":
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("employee", employeeService.getById(id));
                req.setAttribute("departments", departmentService.getAll());
                req.getRequestDispatcher("/Views/EmployeeForm.jsp").forward(req, resp);
                break;
            case "new":
                req.setAttribute("departments", departmentService.getAll());
                req.getRequestDispatcher("/Views/EmployeeForm.jsp").forward(req, resp);
                break;
            case "delete":
                employeeService.delete(Integer.parseInt(req.getParameter("id")));
                resp.sendRedirect(req.getContextPath() + "/admin/employees?success=deleted");
                break;
            default:
                req.setAttribute("employees", employeeService.getAll());
                req.getRequestDispatcher("/Views/EmployeeList.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Handle optional avatar upload
        try {
            Part avatarPart = null;
            try {
                avatarPart = req.getPart("avatar");
            } catch (IllegalStateException | ServletException ex) {
                avatarPart = null;
            }
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String uploadsDir = "/uploads/employees";
                String realPath = req.getServletContext().getRealPath("") + uploadsDir;
                Path uploadPath = Paths.get(realPath);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                String submitted = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();
                String filename = System.currentTimeMillis() + "_" + submitted.replaceAll("[^a-zA-Z0-9._-]", "_");
                Path filePath = uploadPath.resolve(filename);
                try (InputStream in = avatarPart.getInputStream()) {
                    Files.copy(in, filePath, StandardCopyOption.REPLACE_EXISTING);
                }
                req.setAttribute("avatarPath", req.getContextPath() + uploadsDir + "/" + filename);
            }
        } catch (Exception ignore) {
            // non-fatal upload failure should not block form processing
        }
        Employee e = new Employee();
        String id = req.getParameter("id");
        if (id != null && !id.isEmpty()) e.setEmployeeId(Integer.parseInt(id));

        e.setFullName(req.getParameter("fullName"));
        e.setGender(req.getParameter("gender"));
        e.setDob(LocalDate.parse(req.getParameter("dob")));
        e.setAddress(req.getParameter("address"));
        e.setPhone(req.getParameter("phone"));
        e.setEmail(req.getParameter("email"));
        e.setDepartmentId(Integer.parseInt(req.getParameter("departmentId")));
        e.setPosition(req.getParameter("position"));
        e.setHireDate(LocalDate.parse(req.getParameter("hireDate")));
        e.setSalary(Double.parseDouble(req.getParameter("salary")));
        e.setActive("true".equalsIgnoreCase(req.getParameter("active")));

        boolean isUpdate = (id != null && !id.isEmpty());
        employeeService.save(e);
        resp.sendRedirect(req.getContextPath() + "/admin/employees?success=" + (isUpdate ? "updated" : "created"));
    }
}

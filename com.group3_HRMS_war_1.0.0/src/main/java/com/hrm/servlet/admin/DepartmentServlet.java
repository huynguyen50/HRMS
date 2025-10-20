/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.hrm.servlet.admin;

import com.hrm.model.entity.Department;
import com.hrm.service.DepartmentService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 *
 * @author Hask
 */

@WebServlet("/admin/departments")
public class DepartmentServlet extends HttpServlet {
    private final DepartmentService service = new DepartmentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "edit":
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("department", service.getById(id));
                req.getRequestDispatcher("/WEB-INF/jsp/admin/department-form.jsp").forward(req, resp);
                break;
            case "new":
                req.getRequestDispatcher("/WEB-INF/jsp/admin/department-form.jsp").forward(req, resp);
                break;
            case "delete":
                service.delete(Integer.parseInt(req.getParameter("id")));
                resp.sendRedirect("departments");
                break;
            default:
                req.setAttribute("departments", service.getAll());
                req.getRequestDispatcher("/WEB-INF/jsp/admin/department-management.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Department d = new Department();
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.isEmpty())
            d.setDepartmentId(Integer.parseInt(idStr));
        d.setDeptName(req.getParameter("name"));
        d.setDeptManagerId(
            req.getParameter("managerId") == null || req.getParameter("managerId").isEmpty()
            ? null : Integer.parseInt(req.getParameter("managerId"))
        );
        service.save(d);
        resp.sendRedirect("departments");
    }
}


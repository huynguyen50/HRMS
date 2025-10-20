/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.hrm.servlet.request;

import com.hrm.model.entity.MailRequest;
import com.hrm.service.MailRequestService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/employee/mail-request")
public class MailRequestServlet extends HttpServlet {
    private final MailRequestService service = new MailRequestService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int empId = (int) req.getSession().getAttribute("employeeId");
        req.setAttribute("requests", service.getByEmployee(empId));
        req.getRequestDispatcher("/WEB-INF/jsp/request/my-requests.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        MailRequest r = new MailRequest();
        r.setEmployeeId((int) req.getSession().getAttribute("employeeId"));
        r.setRequestType(req.getParameter("type"));
        r.setStartDate(LocalDate.parse(req.getParameter("startDate")));
        r.setEndDate(LocalDate.parse(req.getParameter("endDate")));
        r.setReason(req.getParameter("reason"));
        service.submit(r);
        resp.sendRedirect("mail-request");
    }
}


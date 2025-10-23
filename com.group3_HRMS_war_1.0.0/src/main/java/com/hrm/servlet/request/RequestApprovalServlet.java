/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.hrm.servlet.request;

import com.hrm.service.MailRequestService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/manager/request-approval")
public class RequestApprovalServlet extends HttpServlet {
    private final MailRequestService service = new MailRequestService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int requestId = Integer.parseInt(req.getParameter("requestId"));
        String action = req.getParameter("action"); // approve / reject
        int approverId = (int) req.getSession().getAttribute("employeeId");

        service.updateStatus(requestId, action.equals("approve") ? "Approved" : "Rejected", approverId);
        resp.sendRedirect("requests");
    }
}


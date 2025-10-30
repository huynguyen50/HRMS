package com.hrm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RecoveryController", urlPatterns = {"/Recovery"})
public class RecoveryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Views/Recovery.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String inputPin = request.getParameter("pin");
        String sessionPin = (String) request.getSession().getAttribute("pinCode");

        if (sessionPin != null && inputPin.equals(sessionPin)) {
            response.sendRedirect(request.getContextPath() + "/changepassRE");
        } else {
            request.setAttribute("mess", "Invalid PIN code!");
            request.getRequestDispatcher("/Views/Recovery.jsp").forward(request, response);
        }
    }
}

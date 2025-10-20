/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.hrm.controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
@WebServlet(name = "AdminController", urlPatterns = {"/admin"})
public class AdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "dashboard";
        }

        switch (action) {
            case "dashboard":
                request.getRequestDispatcher("Admin/AdminHome.jsp").forward(request, response);
                break;
            case "employees":
                request.getRequestDispatcher("Admin/Employees.jsp").forward(request, response);
                break;
            case "departments":
                request.getRequestDispatcher("Admin/Departments.jsp").forward(request, response);
                break;
            case "profile":
                request.getRequestDispatcher("Admin/Profile.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect("Admin/Login.jsp");
        }
    }

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
public String getServletInfo() {
        return "Handles admin home page navigation";
    }
}

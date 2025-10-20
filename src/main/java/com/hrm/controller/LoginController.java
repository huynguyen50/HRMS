/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.hrm.controller;

import com.hrm.dao.DAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.hrm.model.entity.SystemUser;

/**
 *
 * @author DELL
 */
@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                request.setAttribute(cookie.getName(), cookie.getValue());
            }
        }
        request.getRequestDispatcher("/Views/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("user");
        String password = request.getParameter("pass");
        String remember = request.getParameter("rememberMe");

        SystemUser sys = DAO.getInstance().getAccountByUsername(username);

        if (sys != null && sys.getPassword().equals(password)) {
            request.getSession().setAttribute("systemUser", sys);

            Cookie userCookie = new Cookie("username", username);
            Cookie passCookie = new Cookie("password", password);

            if (remember != null) {
                userCookie.setMaxAge(24 * 60 * 60);//1 day
                passCookie.setMaxAge(24 * 60 * 60);
            } else {
                userCookie.setMaxAge(0);
                passCookie.setMaxAge(0);
            }
            response.addCookie(userCookie);
            response.addCookie(passCookie);

            response.sendRedirect(request.getContextPath() + "/homepage");
        } else {
            request.setAttribute("mess", "Wrong username or password!");
            request.getRequestDispatcher("/Views/Login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles user login authentication";
    }
}

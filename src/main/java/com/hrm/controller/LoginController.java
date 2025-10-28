package com.hrm.controller;

import com.hrm.dao.DAO;
import com.hrm.model.entity.Recruitment;
import com.hrm.model.entity.SystemUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        Recruitment recruitment = DAO.getInstance().getRecruitmentInfo();
//        request.setAttribute("recruitment", recruitment);

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
                userCookie.setMaxAge(24 * 60 * 60);
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
//            request.setAttribute("recruitment", DAO.getInstance().getRecruitmentInfo());
            request.getRequestDispatcher("/Views/Login.jsp").forward(request, response);
        }
    }
}
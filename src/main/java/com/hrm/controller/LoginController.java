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

        if(password.length()<8 || password.length()>16 || username.length()<8 || password.length()>16){
            request.setAttribute("mess", "Username and password must be between 8 and 16 characters long!");
            request.getRequestDispatcher("/Views/Login.jsp").forward(request, response);
            return;
        }
        
        String allowPattern = "[a-zA-Z0-9]+";
        if(!password.matches(allowPattern) || !username.matches(allowPattern)){
            request.setAttribute("mess", "Username and password must contain no special characters!");
            request.getRequestDispatcher("/Views/Login.jsp").forward(request, response);
            return;
        }
        
        if (sys != null && DAO.getInstance().checkPassword(password, sys.getPassword())) {
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
            request.getRequestDispatcher("/Views/Login.jsp").forward(request, response);
        }
    }
}

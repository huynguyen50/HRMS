package com.hrm.controller;

import com.hrm.dao.DAO;
import com.hrm.model.entity.SystemUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ChangePassController", urlPatterns = {"/changepass"})
public class ChangePassController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Views/ChangePassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String curPass = request.getParameter("curPass");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");
        
        if(newPass.length()<8 && newPass.length()>16){
            request.setAttribute("mess", "New password must be between 8 and 16 characters long!");
            request.getRequestDispatcher("/Views/ChangePassword.jsp").forward(request, response);
            return;
        }
        
        String allowPattern = "[a-zA-Z0-9]+";
        if(!newPass.matches(allowPattern)){
            request.setAttribute("mess", "New password must contain no special characters!");
            request.getRequestDispatcher("/Views/ChangePassword.jsp").forward(request, response);
            return;
        }
        
        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("systemUser") == null) {
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
            return;
        }

        SystemUser sys = (SystemUser) session.getAttribute("systemUser");
        if (!DAO.getInstance().checkPassword(curPass, sys.getPassword())) {
            request.setAttribute("mess", "Wrong current password!!!");
            request.getRequestDispatcher("/Views/ChangePassword.jsp").forward(request, response); // Sửa lại đường dẫn
            return;
        }
        if (!newPass.equals(confirmPass)) {
            request.setAttribute("mess", "New password is not match with confirm password!!!");
            request.getRequestDispatcher("/Views/ChangePassword.jsp").forward(request, response); // Sửa lại đường dẫn
        }
        int r = DAO.getInstance().changePassword(sys.getUsername(), newPass);
        if (r > 0) {
        session.invalidate();
        request.setAttribute("mess", "Password changed successfully! Please login again.");
        request.getRequestDispatcher("/Views/Login.jsp").forward(request, response);
        } else {
        request.setAttribute("mess", "An error occurred. Please try again.");
        request.getRequestDispatcher("/Views/ChangePassword.jsp").forward(request, response);
        }
    }
}
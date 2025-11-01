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

        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("systemUser") == null) {
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp"); // Sửa lại đường dẫn
            return;
        }

        SystemUser sys = (SystemUser) session.getAttribute("systemUser");
        if (!sys.getPassword().equals(curPass)) {
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
            sys.setPassword(newPass);
            session.setAttribute("systemUser", sys);
            request.setAttribute("mess", "Password changed successfully!!!");
        } else {
            request.setAttribute("mess", "An error occurred. Please try again.");
        }
        request.getRequestDispatcher("/Views/ChangePassword.jsp").forward(request, response);
    }
}
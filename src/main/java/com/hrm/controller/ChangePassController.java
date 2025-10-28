/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.hrm.controller;

import com.hrm.dao.DAO;
import com.hrm.model.entity.SystemUser;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author DELL
 */
@WebServlet(name = "ChangePassController", urlPatterns = {"/changepass"})
public class ChangePassController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String curPass = request.getParameter("curPass");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");

        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("systemUser") == null) {
            response.sendRedirect("Views/Login.jsp");
            return;
        }

        SystemUser sys = (SystemUser) session.getAttribute("systemUser");
        if (!sys.getPassword().equals(curPass)) {
            request.setAttribute("mess", "Wrong current password!!!");
        } else if (!newPass.equals(confirmPass)) {
            request.setAttribute("mess", "Current password is not match with confirm password!!!");
        }

        int r = DAO.getInstance().changePassword(sys.getUsername(), newPass);
        if(r>0){
        sys.setPassword(newPass);
        session.setAttribute("systemUser", sys);
        request.setAttribute("mess", "Password changed successfully!!!");
        }
        request.getRequestDispatcher("Views/ChangePassword.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

package com.hrm.controller;

import com.hrm.dao.DAO;
import com.hrm.model.entity.Employee;
import com.hrm.model.entity.SystemUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ChangePassREController", urlPatterns = {"/changepassRE"})
public class ChangePassREController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String recoveryEmail = (String) session.getAttribute("recoveryEmail");

        if (recoveryEmail == null) {
            response.sendRedirect(request.getContextPath() + "/Views/ForgotPassword.jsp");
            return;
        }
        request.getRequestDispatcher("/Views/ChangePasswordRE.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("recoveryEmail");

        if (email == null) {
            request.setAttribute("mess", "Session expired. Please try again.");
            request.getRequestDispatcher("/Views/ForgotPassword.jsp").forward(request, response);
            return;
        }

        if (!newPass.equals(confirmPass)) {
            request.setAttribute("mess", "New password does not match with confirm password!");
            request.getRequestDispatcher("/Views/ChangePasswordRE.jsp").forward(request, response);
            return;
        }
        Employee empID = DAO.getInstance().findEmployeeByEmail(email);
        SystemUser user = DAO.getInstance().findSystemUserByEmpID(empID.getEmployeeId());

        if (user == null) {
            request.setAttribute("mess", "An error occurred. Could not find your account.");
            request.getRequestDispatcher("/Views/ChangePasswordRE.jsp").forward(request, response);
            return;
        }
        int result = DAO.getInstance().changePassword(user.getUsername(), newPass);

        if (result > 0) {
            session.removeAttribute("recoveryEmail");
            session.removeAttribute("pinCode");
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp?passChanged=true");
        } else {
            request.setAttribute("mess", "Failed to change password. Please try again.");
            request.getRequestDispatcher("/Views/ChangePasswordRE.jsp").forward(request, response);
        }
    }
}
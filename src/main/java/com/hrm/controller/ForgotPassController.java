package com.hrm.controller;

import com.hrm.dao.DAO;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

@WebServlet(name = "ForgotPassController", urlPatterns = {"/ForgotPassword"})
public class ForgotPassController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("mess", "Please enter email to get back your account!");
            request.getRequestDispatcher("/Views/ForgotPassword.jsp").forward(request, response);
            return;
        }
        Boolean flag = DAO.getInstance().checkEmailExist(email);
        if (flag) {
            String pin = String.format("%06d", new Random().nextInt(999999));
            try {
                EmailSender.sendEmail(email, "Your PIN", "Your pin code is " + pin + ". This pin will expired after 10 minutes");
            } catch (Exception e) {
                request.setAttribute("mess", "Failed to send email. Try again later.");
                request.getRequestDispatcher("/Views/ForgotPassword.jsp").forward(request, response);
                return;
            }
            HttpSession ses = request.getSession();
            ses.setAttribute("recoveryEmail", email);
            ses.setAttribute("pinCode", pin);
            ses.setMaxInactiveInterval(600); // 10 phút
            response.sendRedirect(request.getContextPath() + "/Recovery");
        } else {
            request.setAttribute("mess", "This email does not exist!!!");
            request.getRequestDispatcher("/Views/ForgotPassword.jsp").forward(request, response);
        }
    }
}

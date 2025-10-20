/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.hrm.controller;

import com.hrm.dao.DAO;
import jakarta.mail.MessagingException;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author DELL
 */
@WebServlet(name="ForgotPassController", urlPatterns={"/ForgotPassword"})
public class ForgotPassController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String email = request.getParameter("email");
        Boolean flag = DAO.getInstance().checkEmailExist(email);
        if(flag){
            String pin = String.format("%06d", new Random().nextInt(999999));
            try {
                EmailSender.sendEmail(email, "Your PIN", "Your pin code is"+pin+"<h1>This pin will expired after 10 minutes</h1>");
            } catch (Exception e) {
                request.setAttribute("mess", "Failed to send email. Try again later.");
                request.getRequestDispatcher("/Views/ForgotPassword.jsp").forward(request, response);
                return;
            }
            
            HttpSession ses = request.getSession();
            ses.setAttribute("recoveryEmail", email);
            ses.setAttribute("pinCode", pin);
            ses.setMaxInactiveInterval(600);//10m
            
            response.sendRedirect(request.getContextPath() + "/Views/Recovery.jsp");
        }else{
            request.setAttribute("mess", "This email does not exist!!!");
            request.getRequestDispatcher("/Views/ForgotPassword.jsp").forward(request, response);
        }
    }
    @Override
    public String getServletInfo() {
        return "Short description";
    }

}

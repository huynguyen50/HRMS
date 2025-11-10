/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.hrm.controller.hr;

import com.hrm.controller.EmailSender;
import com.hrm.dao.DAO;
import com.hrm.model.entity.Guest;
import com.hrm.model.entity.Recruitment;
import com.hrm.model.entity.SystemUser;
import com.hrm.util.PermissionUtil;
import jakarta.mail.MessagingException; // Import MessagingException
import java.io.IOException;
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
@WebServlet(name="ViewCV", urlPatterns={"/viewCV"})
public class ViewCV extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Kiểm tra quyền quản lý ứng viên
        HttpSession session = request.getSession();
        SystemUser currentUser = (SystemUser) session.getAttribute("systemUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
            return;
        }
        
        if (!PermissionUtil.hasPermission(currentUser, "MANAGE_APPLICANTS")) {
            PermissionUtil.redirectToAccessDenied(request, response, "MANAGE_APPLICANTS", "Manage Applicants");
            return;
        }
        
        int gId = Integer.parseInt(request.getParameter("guestId"));
        Guest g = DAO.getInstance().getCandidateById(gId);
        if(g != null){
            request.setAttribute("g", g);
        }
        
        Recruitment r = DAO.getInstance().getRecruitmentById(g.getRecruitmentId());
        if(r!= null){
            request.setAttribute("r", r);
        }
        
        request.getRequestDispatcher("/Views/hr/ViewCV.jsp").forward(request, response);
    } 
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Kiểm tra quyền quản lý ứng viên
        HttpSession session = request.getSession();
        SystemUser currentUser = (SystemUser) session.getAttribute("systemUser");
        
        if (currentUser == null || !PermissionUtil.hasPermission(currentUser, "MANAGE_APPLICANTS")) {
            PermissionUtil.redirectToAccessDenied(request, response, "MANAGE_APPLICANTS", "Manage Applicants");
            return;
        }
        
        String action = request.getParameter("action");
        String gIDRaw = request.getParameter("guestId");
        
        int gID = Integer.parseInt(gIDRaw);
        int n = 0;
        String messageToHR = ""; // Thông báo sẽ hiển thị cho HR

        // Lấy lại thông tin ứng viên để có email và để hiển thị lại trên JSP
        Guest g = DAO.getInstance().getCandidateById(gID);
        if (g == null) {
            request.setAttribute("mess", "Candidate not found!");
            request.getRequestDispatcher("/Views/hr/ViewCV.jsp").forward(request, response);
            return;
        }

        if ("apply".equals(action)) {
            n = DAO.getInstance().updateCandidateStatus(gID, "Hired");
            if (n > 0) {
                try {
                    String subject = "Good News: Your CV has passed the initial screening!";
                    String body = "Congratulations, your CV has passed our initial screening. An interview schedule will be sent to you soon!";
                    EmailSender.sendEmail(g.getEmail(), subject, body);
                    messageToHR = "Candidate hired successfully and notification email sent!";
                } catch (MessagingException e) {
                    // Log lỗi ra console để debug
                    e.printStackTrace();
                    messageToHR = "Candidate status updated, but failed to send notification email.";
                }
            } else {
                messageToHR = "Hired fail, seem like something went wrong!";
            }
            
        } else if ("reject".equals(action)) {
            n = DAO.getInstance().updateCandidateStatus(gID, "Rejected");
            if (n > 0) {
                try {
                    String subject = "Update on your application";
                    String body = "We regret to inform you that your CV does not meet our current requirements.";
                    EmailSender.sendEmail(g.getEmail(), subject, body);
                    messageToHR = "Candidate rejected and notification email sent.";
                } catch (MessagingException e) {
                    e.printStackTrace();
                    messageToHR = "Candidate status updated, but failed to send notification email.";
                }
            } else {
                messageToHR = "Reject fail, seem like something went wrong!";
            }
        }
        
        // Cần set lại các attribute để JSP không bị lỗi khi render lại
        request.setAttribute("g", g);
        Recruitment r = DAO.getInstance().getRecruitmentById(g.getRecruitmentId());
        request.setAttribute("r", r);
        request.setAttribute("mess", messageToHR);
        
        request.getRequestDispatcher("/Views/hr/ViewCV.jsp").forward(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
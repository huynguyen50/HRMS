/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.hrm.controller.hr;

import com.hrm.dao.DAO;
import com.hrm.model.entity.SystemUser;
import com.hrm.util.PermissionUtil;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;

/**
 *
 * @author DELL
 */
@WebServlet(name="DetailRecruitmentCreate", urlPatterns={"/detailRecruitmentCreate"})
public class DetailRecruitmentCreate extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Kiểm tra quyền tạo recruitment
        HttpSession session = request.getSession();
        SystemUser currentUser = (SystemUser) session.getAttribute("systemUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
            return;
        }
        
        if (!PermissionUtil.hasPermission(currentUser, "CREATE_RECRUITMENT")) {
            PermissionUtil.redirectToAccessDenied(request, response, "CREATE_RECRUITMENT", "Create Recruitment");
            return;
        }
        
        request.getRequestDispatcher("/Views/hr/CreateNewRecruitment.jsp").forward(request, response);
    } 
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException {
    // Kiểm tra quyền tạo recruitment
    HttpSession session = request.getSession();
    SystemUser currentUser = (SystemUser) session.getAttribute("systemUser");
    
    if (currentUser == null || !PermissionUtil.hasPermission(currentUser, "CREATE_RECRUITMENT")) {
        PermissionUtil.redirectToAccessDenied(request, response, "CREATE_RECRUITMENT", "Create Recruitment");
        return;
    }
    
    String title = request.getParameter("Title");
    String description = request.getParameter("Description");
    String requirement = request.getParameter("Requirement");
    String location = request.getParameter("Location");
    String salaryStr = request.getParameter("Salary");
    String applicantStr = request.getParameter("Applicant");

        double salary = Double.parseDouble(salaryStr);
        int applicant = Integer.parseInt(applicantStr);
        
        if(salary<=0 || applicant<=0){
            request.setAttribute("mess", "Salary and applicant must be a positive number!");
            request.getRequestDispatcher("/Views/hr/CreateNewRecruitment.jsp").forward(request, response);
            return;
        }
        
        int result = DAO.getInstance().createRecruitment(title, description, requirement, location, salary, LocalDateTime.now(), applicant);
        
        if (result > 0) {
            response.sendRedirect(request.getContextPath() + "/postRecruitments");
        } else {
            request.setAttribute("mess", "Failed to create recruitment. Please try again.");
            request.getRequestDispatcher("/Views/hr/CreateNewRecruitment.jsp").forward(request, response);
        }
}
    @Override
    public String getServletInfo() {
        return "Short description";
    }

}

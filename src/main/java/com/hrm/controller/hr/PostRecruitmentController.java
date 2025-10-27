/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.hrm.controller.hr;

import com.hrm.dao.DAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author DELL
 */
@WebServlet(name="PostRecruitmentController", urlPatterns={"/postRecruitment"})
public class PostRecruitmentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String Title = request.getParameter("title");
        String Description = request.getParameter("description");
        String Requirement = request.getParameter("requirement");
        String Location = request.getParameter("location");
        String SalaryRaw = request.getParameter("salary");
        
        double Salary = Double.parseDouble(SalaryRaw);
        
        DAO.getInstance().setRecruitment(Title, Description, Requirement, Location, Salary);
        
        response.sendRedirect(request.getContextPath() + "/Views/Success.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}

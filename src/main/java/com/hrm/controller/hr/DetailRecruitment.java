/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.hrm.controller.hr;

import com.hrm.dao.DAO;
import com.hrm.model.entity.Recruitment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 * @author DELL
 */
@WebServlet(name = "DetailRecruitment", urlPatterns = {"/detailRecruitment"})
public class DetailRecruitment extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Recruitment rec = DAO.getInstance().getRecruitmentById(id);
            request.setAttribute("rec", rec);
            request.getRequestDispatcher("Views/hr/DetailRecruitment.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/postRecruitments?error=invalidid");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        try {
            int id = Integer.parseInt(idParam);
            if ("delete".equals(action)) {
                int result = DAO.getInstance().deleteRecruitmentById(id);

                if (result > 0) {
                    response.sendRedirect(request.getContextPath() + "/postRecruitments?mess=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/postRecruitments?error=notfound");
                }

            } else {
                String title = request.getParameter("Title");
                String description = request.getParameter("Description");
                String requirement = request.getParameter("Requirement");
                String location = request.getParameter("Location");
                double salary = Double.parseDouble(request.getParameter("Salary"));
                int applicant = Integer.parseInt("Applicant");

                if (salary < 0) {
                    request.setAttribute("mess", "Salary must be a positive number.");
                    Recruitment rec = DAO.getInstance().getRecruitmentById(id);
                    request.setAttribute("rec", rec);
                    request.getRequestDispatcher("Views/hr/DetailRecruitment.jsp").forward(request, response);
                    return;
                }

                int update = DAO.getInstance().setRecruitmentById(title, description, requirement, location, salary, applicant,id);
                response.sendRedirect(request.getContextPath() + "/detailRecruitment?id=" + id);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/postRecruitments?error=invalidformat");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/postRecruitments?error=servererror");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}

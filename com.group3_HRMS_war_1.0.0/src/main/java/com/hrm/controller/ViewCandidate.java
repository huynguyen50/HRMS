/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.hrm.controller;

import com.hrm.dao.DAO;
import com.hrm.model.entity.Guest;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author DELL
 */
@WebServlet(name = "ViewCandidate", urlPatterns = {"/candidates"})
public class ViewCandidate extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Guest> gList = DAO.getInstance().getAllCandidates();
        request.setAttribute("guest", gList);
        request.getRequestDispatcher("/Views/ViewCandidate.jsp").forward(request, response);
    }
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String action = request.getParameter("action");
    String gIDRaw = request.getParameter("guestId");
    if (gIDRaw == null || gIDRaw.isEmpty()) {
        request.setAttribute("mess", "There are currently no candidates submitted.");
        request.getRequestDispatcher("/Views/ViewCandidate.jsp").forward(request, response);
        return;
    }

    int gID = Integer.parseInt(gIDRaw);
    int n = 0;
    if ("apply".equals(action)) {
        n = DAO.getInstance().updateCandidateStatus(gID, "Hired");
    } else if ("reject".equals(action)) {
        n = DAO.getInstance().updateCandidateStatus(gID, "Rejected");
    }
    response.sendRedirect(request.getContextPath() + "/candidates");
}

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}

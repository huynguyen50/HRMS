/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.hrm.controller.hr;

import com.hrm.dao.DAO;
import com.hrm.model.entity.Guest;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
        int page = 1;
        int pageSize = 5;
        String pageStr = request.getParameter("page");
        
        if(pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
            } catch(Exception e) {
                page = 1;
            }
        }
        
        // Get search parameters
        String searchByName = request.getParameter("searchByName");
        String filterStatus = request.getParameter("filterStatus");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        List<Guest> gList;
        int totalCandidates;
        
        // Check if any search parameter is provided
        boolean hasSearch = (searchByName != null && !searchByName.trim().isEmpty()) || 
                           (filterStatus != null && !filterStatus.trim().isEmpty()) || 
                           (startDate != null && !startDate.trim().isEmpty()) || 
                           (endDate != null && !endDate.trim().isEmpty());
        
        if (hasSearch) {
            // Get filtered candidates
            gList = DAO.getInstance().searchCandidates(searchByName, filterStatus, startDate, endDate, page, pageSize);
            totalCandidates = DAO.getInstance().searchCountCandidates(searchByName, filterStatus, startDate, endDate);
        } else {
            // Get all candidates
            gList = DAO.getInstance().getAllCandidates(page, pageSize);
            totalCandidates = DAO.getInstance().getCountCandidate();
        }
        
        int totalPages = (int) Math.ceil((double) totalCandidates / pageSize);
        
        request.setAttribute("guest", gList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        // Preserve search parameters in request for form
        request.setAttribute("searchByName", searchByName);
        request.setAttribute("filterStatus", filterStatus);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
request.getRequestDispatcher("/Views/hr/ViewCandidate.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String gIDRaw = request.getParameter("guestId");
        if (gIDRaw == null || gIDRaw.isEmpty()) {
            request.setAttribute("mess", "There are currently no candidates submitted.");
            request.getRequestDispatcher("/Views/hr/ViewCandidate.jsp").forward(request, response);
            return;
        }

        int gID = Integer.parseInt(gIDRaw);
        int n = 0;
        if ("apply".equals(action)) {
            n = DAO.getInstance().updateCandidateStatus(gID, "Hired");
        } else if ("reject".equals(action)) {
            n = DAO.getInstance().updateCandidateStatus(gID, "Rejected");
        }
        
        // Preserve search parameters when redirecting
        String searchByName = request.getParameter("searchByName");
        String filterStatus = request.getParameter("filterStatus");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/candidates?");
        
        if (searchByName != null && !searchByName.trim().isEmpty()) {
            redirectUrl.append("searchByName=").append(searchByName).append("&");
        }
        if (filterStatus != null && !filterStatus.trim().isEmpty()) {
            redirectUrl.append("filterStatus=").append(filterStatus).append("&");
        }
        if (startDate != null && !startDate.trim().isEmpty()) {
            redirectUrl.append("startDate=").append(startDate).append("&");
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            redirectUrl.append("endDate=").append(endDate).append("&");
        }
        
        response.sendRedirect(redirectUrl.toString());
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.hrm.controller.hr;

import com.hrm.dao.DAO;
import com.hrm.model.entity.Guest;
import com.hrm.util.PermissionUtil;
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

    private static final String REQUIRED_PERMISSION = "VIEW_RECRUITMENT";
    private static final String DENIED_MESSAGE = "You do not have permission to view candidate information.";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureAccess(request, response)) {
            return;
        }
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
        if (!ensureAccess(request, response)) {
            return;
        }
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

    private boolean ensureAccess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        return PermissionUtil.ensurePermission(request, response, REQUIRED_PERMISSION, DENIED_MESSAGE);
    }
}
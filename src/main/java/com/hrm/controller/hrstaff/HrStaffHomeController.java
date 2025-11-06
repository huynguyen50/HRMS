package com.hrm.controller.hrstaff;

import com.hrm.dao.ContractDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "HrStaffHomeController", urlPatterns = {"/hrstaff"})
public class HrStaffHomeController extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int days = 30;
        try {
            String daysParam = request.getParameter("days");
            if (daysParam != null) {
                days = Math.max(1, Integer.parseInt(daysParam));
            }
        } catch (NumberFormatException ignored) {
        }

        List<Map<String, Object>> expiringContracts = contractDAO.getExpiringWithinDays(days);
        request.setAttribute("expiringContracts", expiringContracts);
        request.setAttribute("expiringDays", days);

        request.getRequestDispatcher("/Views/HrStaff/HrStaffHome.jsp").forward(request, response);
    }
}



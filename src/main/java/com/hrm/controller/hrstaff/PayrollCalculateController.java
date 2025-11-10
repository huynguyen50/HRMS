package com.hrm.controller.hrstaff;

import com.hrm.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

/**
 * Controller for Payroll Calculation (API)
 * Handles GET /hrstaff/payroll/calculate - Calculate payroll data (returns JSON)
 * @author admin
 */
@WebServlet(name = "PayrollCalculateController", urlPatterns = {"/hrstaff/payroll/calculate"})
public class PayrollCalculateController extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();
    private final EmployeeAllowanceDAO employeeAllowanceDAO = new EmployeeAllowanceDAO();
    private final EmployeeDeductionDAO employeeDeductionDAO = new EmployeeDeductionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String employeeIdStr = request.getParameter("employeeId");
            String month = request.getParameter("month");

            if (employeeIdStr == null || month == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                PrintWriter out = response.getWriter();
                out.print("{\"error\":\"Missing required parameters\"}");
                return;
            }

            int employeeId = Integer.parseInt(employeeIdStr);
            
            // Get BaseSalary from Contract
            BigDecimal baseSalary = BigDecimal.ZERO;
            try {
                var contract = contractDAO.getActiveContractByEmployeeId(employeeId);
                if (contract != null && contract.getBaseSalary() != null) {
                    baseSalary = contract.getBaseSalary();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Get total allowance
            BigDecimal totalAllowance = employeeAllowanceDAO.getTotalAllowance(employeeId, month);

            // Get total deduction
            BigDecimal totalDeduction = employeeDeductionDAO.getTotalDeduction(employeeId, month);

            // Build response
            Map<String, Object> result = new HashMap<>();
            result.put("baseSalary", baseSalary);
            result.put("totalAllowance", totalAllowance);
            result.put("totalDeduction", totalDeduction);

            // Convert to JSON manually (simple approach)
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"baseSalary\":").append(baseSalary != null ? baseSalary : 0);
            json.append(",\"totalAllowance\":").append(totalAllowance != null ? totalAllowance : 0);
            json.append(",\"totalDeduction\":").append(totalDeduction != null ? totalDeduction : 0);
            json.append("}");

            PrintWriter out = response.getWriter();
            out.print(json.toString());
            out.flush();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = response.getWriter();
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}


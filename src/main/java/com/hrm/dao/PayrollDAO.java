package com.hrm.dao;

import com.hrm.model.entity.Payroll;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO for Payroll table
 * @author admin
 */
public class PayrollDAO {
    
    /**
     * Create new payroll and return the generated ID
     */
    public int create(Payroll payroll) {
        String sql = """
            INSERT INTO Payroll (EmployeeID, PayPeriod, BaseSalary, Allowance, Bonus, Deduction, NetSalary, Status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, payroll.getEmployeeId());
            ps.setString(2, payroll.getPayPeriod());
            ps.setBigDecimal(3, payroll.getBaseSalary());
            ps.setBigDecimal(4, payroll.getAllowance());
            ps.setBigDecimal(5, payroll.getBonus());
            ps.setBigDecimal(6, payroll.getDeduction());
            ps.setBigDecimal(7, payroll.getNetSalary());
            ps.setString(8, "Draft");
            
            int result = ps.executeUpdate();
            if (result > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    /**
     * Get payroll by ID
     */
    public Payroll getById(int payrollId) {
        String sql = """
            SELECT p.*, e.FullName
            FROM Payroll p
            JOIN Employee e ON p.EmployeeID = e.EmployeeID
            WHERE p.PayrollID = ?
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, payrollId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayroll(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get all payrolls with filters
     */
    public List<Map<String, Object>> getAll(Integer employeeId, String status) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT p.*, e.FullName
            FROM Payroll p
            JOIN Employee e ON p.EmployeeID = e.EmployeeID
            WHERE 1=1
        """);
        
        List<Object> params = new ArrayList<>();
        
        if (employeeId != null) {
            sql.append(" AND p.EmployeeID = ?");
            params.add(employeeId);
        }
        
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND p.Status = ?");
            params.add(status);
        }
        
        sql.append(" ORDER BY p.PayPeriod DESC, e.FullName");
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("payrollId", rs.getInt("PayrollID"));
                    item.put("employeeId", rs.getInt("EmployeeID"));
                    item.put("employeeName", rs.getString("FullName"));
                    item.put("payPeriod", rs.getString("PayPeriod"));
                    item.put("baseSalary", rs.getBigDecimal("BaseSalary"));
                    item.put("allowance", rs.getBigDecimal("Allowance"));
                    item.put("bonus", rs.getBigDecimal("Bonus"));
                    item.put("deduction", rs.getBigDecimal("Deduction"));
                    item.put("netSalary", rs.getBigDecimal("NetSalary"));
                    item.put("status", rs.getString("Status"));
                    item.put("approvedBy", rs.getObject("ApprovedBy"));
                    item.put("approvedDate", rs.getDate("ApprovedDate"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Update payroll
     */
    public boolean update(Payroll payroll) {
        String sql = """
            UPDATE Payroll 
            SET BaseSalary = ?, Allowance = ?, Bonus = ?, Deduction = ?, NetSalary = ?
            WHERE PayrollID = ? AND Status = 'Draft'
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setBigDecimal(1, payroll.getBaseSalary());
            ps.setBigDecimal(2, payroll.getAllowance());
            ps.setBigDecimal(3, payroll.getBonus());
            ps.setBigDecimal(4, payroll.getDeduction());
            ps.setBigDecimal(5, payroll.getNetSalary());
            ps.setInt(6, payroll.getPayrollId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Update payroll status (submit for approval)
     */
    public boolean updateStatus(int payrollId, String status) {
        String sql = "UPDATE Payroll SET Status = ? WHERE PayrollID = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, payrollId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Delete payroll (only if Draft)
     */
    public boolean delete(int payrollId) {
        String sql = "DELETE FROM Payroll WHERE PayrollID = ? AND Status = 'Draft'";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, payrollId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Check if payroll exists for employee and month
     */
    public boolean exists(int employeeId, String payPeriod) {
        String sql = "SELECT COUNT(*) FROM Payroll WHERE EmployeeID = ? AND PayPeriod = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, employeeId);
            ps.setString(2, payPeriod);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Map ResultSet to Payroll object
     */
    private Payroll mapResultSetToPayroll(ResultSet rs) throws SQLException {
        Payroll payroll = new Payroll();
        payroll.setPayrollId(rs.getInt("PayrollID"));
        payroll.setEmployeeId(rs.getInt("EmployeeID"));
        payroll.setPayPeriod(rs.getString("PayPeriod"));
        payroll.setBaseSalary(rs.getBigDecimal("BaseSalary"));
        payroll.setAllowance(rs.getBigDecimal("Allowance"));
        payroll.setBonus(rs.getBigDecimal("Bonus"));
        payroll.setDeduction(rs.getBigDecimal("Deduction"));
        payroll.setNetSalary(rs.getBigDecimal("NetSalary"));
        payroll.setStatus(rs.getString("Status"));
        
        Object approvedByObj = rs.getObject("ApprovedBy");
        if (approvedByObj != null) {
            payroll.setApprovedBy((Integer) approvedByObj);
        }
        
        Date approvedDate = rs.getDate("ApprovedDate");
        if (approvedDate != null) {
            payroll.setApprovedDate(approvedDate.toLocalDate());
        }
        
        return payroll;
    }
}

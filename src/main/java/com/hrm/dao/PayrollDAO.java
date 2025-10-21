package com.hrm.dao;

import com.hrm.model.entity.Payroll;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;
import java.time.LocalDate;

public class PayrollDAO {
    
    /**
     * Tạo bảng lương mới
     */
    public boolean createPayroll(Payroll payroll) {
        String sql = """
            INSERT INTO Payroll (EmployeeID, PayPeriod, BaseSalary, Allowance, Bonus, Deduction, NetSalary)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;
        try (Connection con = DBConnection.getJDBCConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, payroll.getEmployeeId());
            ps.setString(2, payroll.getPayPeriod());
            ps.setBigDecimal(3, payroll.getBaseSalary());
            ps.setBigDecimal(4, payroll.getAllowance());
            ps.setBigDecimal(5, payroll.getBonus());
            ps.setBigDecimal(6, payroll.getDeduction());
            ps.setBigDecimal(7, payroll.getNetSalary());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy danh sách bảng lương theo nhân viên và kỳ lương
     */
    public List<Payroll> getPayrollByEmployee(int employeeId, String payPeriod) {
        List<Payroll> payrolls = new ArrayList<>();
        String sql = """
            SELECT p.*, e.FullName, e.Position, d.DeptName 
            FROM Payroll p 
            JOIN Employee e ON p.EmployeeID = e.EmployeeID 
            LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID 
            WHERE p.EmployeeID = ? AND p.PayPeriod = ?
        """;
        
        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, employeeId);
            ps.setString(2, payPeriod);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                payrolls.add(mapResultSetToPayroll(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payrolls;
    }
    
    /**
     * Lấy tất cả bảng lương của một kỳ
     */
    public List<Payroll> getAllPayrollByPeriod(String payPeriod) {
        List<Payroll> payrolls = new ArrayList<>();
        String sql = """
            SELECT p.*, e.FullName, e.Position, d.DeptName 
            FROM Payroll p 
            JOIN Employee e ON p.EmployeeID = e.EmployeeID 
            LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID 
            WHERE p.PayPeriod = ?
            ORDER BY e.FullName
        """;
        
        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, payPeriod);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                payrolls.add(mapResultSetToPayroll(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payrolls;
    }
    
    /**
     * Tính lương tự động dựa trên attendance và contract
     */
    public boolean calculatePayroll(int employeeId, String payPeriod, int hrId) {
        String sql = """
            CALL CalculateEmployeePayroll(?, ?, ?)
        """;
        
        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, employeeId);
            ps.setString(2, payPeriod);
            ps.setInt(3, hrId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // Nếu stored procedure chưa có, tính manual
            return calculatePayrollManual(employeeId, payPeriod, hrId);
        }
    }
    
    /**
     * Tính lương manual khi chưa có stored procedure
     */
    private boolean calculatePayrollManual(int employeeId, String payPeriod, int hrId) {
        String getContractSql = """
            SELECT BaseSalary, Allowance FROM Contract 
            WHERE EmployeeID = ? AND (EndDate IS NULL OR EndDate >= CURDATE())
            ORDER BY StartDate DESC LIMIT 1
        """;
        
        String getAttendanceSql = """
            SELECT SUM(WorkingHours) as totalHours, SUM(OvertimeHours) as totalOvertime
            FROM Attendance 
            WHERE EmployeeID = ? AND DATE_FORMAT(Date, '%Y-%m') = ?
        """;
        
        try (Connection con = DBConnection.getJDBCConnection()) {
            // Lấy thông tin hợp đồng
            BigDecimal baseSalary = BigDecimal.ZERO;
            BigDecimal allowance = BigDecimal.ZERO;
            
            try (PreparedStatement ps1 = con.prepareStatement(getContractSql)) {
                ps1.setInt(1, employeeId);
                ResultSet rs1 = ps1.executeQuery();
                if (rs1.next()) {
                    baseSalary = rs1.getBigDecimal("BaseSalary");
                    allowance = rs1.getBigDecimal("Allowance");
                }
            }
            
            // Lấy thông tin chấm công
            double totalHours = 0;
            double overtimeHours = 0;
            
            try (PreparedStatement ps2 = con.prepareStatement(getAttendanceSql)) {
                ps2.setInt(1, employeeId);
                ps2.setString(2, payPeriod);
                ResultSet rs2 = ps2.executeQuery();
                if (rs2.next()) {
                    totalHours = rs2.getDouble("totalHours");
                    overtimeHours = rs2.getDouble("totalOvertime");
                }
            }
            
            // Tính lương (giả sử 22 ngày công/tháng, 8h/ngày)
            double standardHours = 22 * 8; // 176 giờ chuẩn
            BigDecimal hourlyRate = baseSalary.divide(BigDecimal.valueOf(standardHours), 2, BigDecimal.ROUND_HALF_UP);
            BigDecimal actualSalary = hourlyRate.multiply(BigDecimal.valueOf(totalHours));
            BigDecimal overtimeBonus = hourlyRate.multiply(BigDecimal.valueOf(overtimeHours * 1.5)); // x1.5 cho overtime
            BigDecimal netSalary = actualSalary.add(allowance).add(overtimeBonus);
            
            // Tạo payroll record
            Payroll payroll = new Payroll();
            payroll.setEmployeeId(employeeId);
            payroll.setPayPeriod(payPeriod);
            payroll.setBaseSalary(baseSalary);
            payroll.setAllowance(allowance);
            payroll.setBonus(overtimeBonus);
            payroll.setDeduction(BigDecimal.ZERO);
            payroll.setNetSalary(netSalary);
            
            return createPayroll(payroll);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy danh sách payroll chờ phê duyệt
     */
    public List<Payroll> getPendingPayrolls(String payPeriod) {
        List<Payroll> payrolls = new ArrayList<>();
        String sql = """
            SELECT p.*, e.FullName, e.Position, d.DeptName 
            FROM Payroll p 
            JOIN Employee e ON p.EmployeeID = e.EmployeeID 
            LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID 
            WHERE p.PayPeriod = ? AND p.ApprovedBy IS NULL
            ORDER BY e.FullName
        """;
        
        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, payPeriod);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                payrolls.add(mapResultSetToPayroll(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payrolls;
    }
    
    /**
     * Lấy danh sách payroll đã được phê duyệt
     */
    public List<Payroll> getApprovedPayrolls(String payPeriod) {
        List<Payroll> payrolls = new ArrayList<>();
        String sql = """
            SELECT p.*, e.FullName, e.Position, d.DeptName 
            FROM Payroll p 
            JOIN Employee e ON p.EmployeeID = e.EmployeeID 
            LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID 
            WHERE p.PayPeriod = ? AND p.ApprovedBy IS NOT NULL
            ORDER BY e.FullName
        """;
        
        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, payPeriod);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                payrolls.add(mapResultSetToPayroll(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payrolls;
    }
    
    /**
     * Lấy payroll đã approve của một nhân viên
     */
    public List<Payroll> getApprovedPayrollsByEmployee(int employeeId) {
        List<Payroll> payrolls = new ArrayList<>();
        String sql = """
            SELECT p.*, e.FullName, e.Position, d.DeptName 
            FROM Payroll p 
            JOIN Employee e ON p.EmployeeID = e.EmployeeID 
            LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID 
            WHERE p.EmployeeID = ? AND p.ApprovedBy IS NOT NULL
            ORDER BY p.PayPeriod DESC
        """;
        
        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                payrolls.add(mapResultSetToPayroll(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payrolls;
    }
    
    /**
     * Lấy payroll theo ID
     */
    public Payroll getById(int payrollId) {
        String sql = """
            SELECT p.*, e.FullName, e.Position, d.DeptName 
            FROM Payroll p 
            JOIN Employee e ON p.EmployeeID = e.EmployeeID 
            LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID 
            WHERE p.PayrollID = ?
        """;
        
        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, payrollId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPayroll(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Phê duyệt payroll
     */
    public boolean approvePayroll(int payrollId, int approverId, String comment) {
        String sql = """
            UPDATE Payroll 
            SET ApprovedBy = ?, 
                ApprovedDate = CURRENT_DATE,
                ApprovalComment = ?
            WHERE PayrollID = ?
        """;
        
        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, approverId);
            ps.setString(2, comment);
            ps.setInt(3, payrollId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Từ chối payroll
     */
    public boolean rejectPayroll(int payrollId, int rejectedBy, String reason) {
        String sql = """
            UPDATE Payroll 
            SET RejectedBy = ?, 
                RejectedDate = CURRENT_DATE,
                RejectionReason = ?,
                ApprovedBy = NULL,
                ApprovedDate = NULL
            WHERE PayrollID = ?
        """;
        
        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, rejectedBy);
            ps.setString(2, reason);
            ps.setInt(3, payrollId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Xác nhận đã nhận payslip
     */
    public boolean acknowledgePayslip(int payrollId, int employeeId, String note) {
        String sql = """
            UPDATE Payroll 
            SET AcknowledgedBy = ?, 
                AcknowledgedDate = CURRENT_DATE,
                AcknowledgmentNote = ?
            WHERE PayrollID = ? AND EmployeeID = ?
        """;
        
        try (Connection con = DBConnection.getJDBCConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, employeeId);
            ps.setString(2, note);
            ps.setInt(3, payrollId);
            ps.setInt(4, employeeId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
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
        
        if (rs.getInt("ApprovedBy") != 0) {
            payroll.setApprovedBy(rs.getInt("ApprovedBy"));
        }        java.sql.Date approvedDate = rs.getDate("ApprovedDate");
        if (approvedDate != null) {
            payroll.setApprovedDate(approvedDate.toLocalDate());
        }
        
        return payroll;
    }
}

package com.hrm.dao;

import com.hrm.model.entity.Guest;
import com.hrm.model.entity.Recruitment;
import com.hrm.model.entity.SystemUser;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAO {

    private static DAO instance;
    private Connection con;

    private DAO() {
        con = DBConnection.getConnection();
    }

    public static synchronized DAO getInstance() {
        if (instance == null) {
            instance = new DAO();
        }
        return instance;
    }

    public SystemUser getAccountByUsername(String username) {
        String sql = "SELECT * FROM SystemUser WHERE username = ?";
        SystemUser sys = null;
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                sys = new SystemUser(rs.getInt("userId"), rs.getString("username"), rs.getString("password"), rs.getInt("roleId"),
                        rs.getObject("lastLogin", java.time.LocalDateTime.class), rs.getBoolean("isActive"),
                        rs.getObject("createdDate", java.time.LocalDateTime.class), rs.getInt("employeeId")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error getting systemUser by username: " + e.getMessage());
        }
        return sys;
    }

    public int changePassword(String username, String newPass) {
        String sql = "UPDATE SystemUser SET password=? Where username=?";
        int result = 0;
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, newPass);
            ps.setString(2, username);
            result = ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error getting systemUser by username: " + e.getMessage());
        }
        return result;
    }

    public boolean checkEmailExist(String email) {
        String sql = "SELECT COUNT(*) FROM Employee WHERE email = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                return rs.getInt(1) > 0; // Nếu có ít nhất 1 dòng, email đã tồn tại
            }
        } catch (SQLException e) {
            System.err.println("Error checking email existence: " + e.getMessage());
        }
        return false;
    }

    public int updateCandidateStatus(int gID, String newStatus) {
        String sql = "UPDATE Guest SET status = ? WHERE guestId = ?";
        int result = 0;
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, gID);
            result = ps.executeUpdate();

        } catch (Exception e) {
e.printStackTrace();
        }
        return result;
    }

    public List<Guest> getAllCandidates() {
        List<Guest> gList = new ArrayList<Guest>();
        String sql = "SELECT * from Guest";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Guest guest = new Guest(rs.getInt("guestId"), rs.getString("fullName"), rs.getString("email"),
                        rs.getString("phone"), rs.getString("cv"), rs.getString("status"), rs.getObject("recruitmentId", Integer.class),
                        rs.getObject("appliedDate", java.time.LocalDateTime.class));
                gList.add(guest);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return gList;
    }

    public int setRecruitment(String title, String description, String req, String location, Double salary) {
        String sql = "UPDATE Recruitment SET JobDescription = ?, Requirement = ?, Location = ?, Salary = ?, JobTitle = ? WHERE RecruitmentID = 1";
        int result = 0;
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, description);
            ps.setString(2, req);
            ps.setString(3, location);
            ps.setDouble(4, salary);
            ps.setString(5, title);
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public Recruitment getRecruitmentInfo() {
        String sql = "SELECT JobTitle, JobDescription, Requirement, Location, Salary FROM Recruitment WHERE RecruitmentID = 1";
        try {
            PreparedStatement ps = con.prepareStatement(sql); 
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Recruitment rec = new Recruitment();
                rec.setTitle(rs.getString("JobTitle"));
                rec.setDescription(rs.getString("JobDescription"));
                rec.setRequirement(rs.getString("Requirement"));
                rec.setLocate(rs.getString("Location"));
                rec.setSalary(rs.getDouble("Salary"));
                return rec;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}

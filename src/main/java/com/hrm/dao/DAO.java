package com.hrm.dao;

import com.hrm.model.entity.Guest;
import com.hrm.model.entity.Employee;
import com.hrm.model.entity.Recruitment;
import com.hrm.model.entity.Task;
import com.hrm.model.entity.SystemUser;
import java.sql.*;
import java.time.LocalDate;
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

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, gID);
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Guest> getAllCandidates(int page, int size) {
        List<Guest> gList = new ArrayList<Guest>();
        int offset = (page - 1) * size;
        String sql = "SELECT * from Guest ORDER BY guestId LIMIT ? OFFSET ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, size);
            ps.setInt(2, offset);
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

    public int getCountCandidate() {
        String sql = "SELECT COUNT(*) FROM Guest";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return 0;
    }

    public Guest getCandidateById(int id) {
        String sql = "SELECT * FROM Guest WHERE guestId = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Guest g = new Guest(
                        rs.getInt("guestId"),
                        rs.getString("fullName"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("cv"),
                        rs.getString("status"),
                        rs.getInt("recruitmentId"),
                        rs.getObject("appliedDate", LocalDateTime.class)
                );
                return g;
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy candidate theo ID: " + e.getMessage());
            e.printStackTrace(); // In ra chi tiết lỗi để dễ dàng gỡ lỗi
        }
        return null;
    }

    public List<Guest> searchCandidates(String fullName, String status, String startDate, String endDate, int page, int size) {
        List<Guest> gList = new ArrayList<>();
        int offset = (page - 1) * size;
        StringBuilder sql = new StringBuilder("SELECT * FROM Guest WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (fullName != null && !fullName.trim().isEmpty()) {
            sql.append(" AND fullName LIKE ?");
            params.add("%" + fullName + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status);
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND appliedDate >= ?");
            params.add(startDate);
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND appliedDate <= ?");
            params.add(endDate);
        }

        sql.append(" ORDER BY guestId LIMIT ? OFFSET ?");
        params.add(size);
        params.add(offset);

        try {
            PreparedStatement ps = con.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

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

    public int searchCountCandidates(String fullName, String status, String startDate, String endDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Guest WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (fullName != null && !fullName.trim().isEmpty()) {
            sql.append(" AND fullName LIKE ?");
            params.add("%" + fullName + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status);
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND appliedDate >= ?");
            params.add(startDate);
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND appliedDate <= ?");
            params.add(endDate);
        }

        try {
            PreparedStatement ps = con.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }

        return 0;
    }

    public Employee findEmployeeByEmail(String email) {
        String sql = "SELECT * FROM employee WHERE Email = ? ";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Employee emp = new Employee();
                emp.setEmployeeId(rs.getInt("EmployeeID"));
                emp.setFullName(rs.getString("FullName"));
                emp.setEmail(rs.getString("Email"));
                return emp;
            }
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
        return null;
    }

    public SystemUser findSystemUserByEmpID(int employeeID) {
        String sql = "SELECT * FROM systemuser WHERE employeeID = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, employeeID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                SystemUser sys = new SystemUser(rs.getInt("userId"), rs.getString("username"), rs.getString("password"), rs.getInt("roleId"),
                        rs.getObject("lastLogin", java.time.LocalDateTime.class), rs.getBoolean("isActive"),
                        rs.getObject("createdDate", java.time.LocalDateTime.class), rs.getInt("employeeId")
                );
                return sys;
            }
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
        return null;
    }

    public List<Guest> getAllCandidates() {
        List<Guest> gList = new ArrayList<Guest>();
        String sql = "SELECT * from Guest ORDER BY GuestID";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Guest guest = new Guest(rs.getInt("GuestID"), rs.getString("FullName"), rs.getString("Email"),
                        rs.getString("Phone"), rs.getString("CV"), rs.getString("Status"), rs.getObject("RecruitmentID", Integer.class),
                        rs.getObject("AppliedDate", java.time.LocalDateTime.class));
                gList.add(guest);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return gList;
    }

    public List<Recruitment> searchRecruitment(String title, String status, String startDate, String endDate, int page, int size) {
        List<Recruitment> rList = new ArrayList<>();
        int offset = (page - 1) * size;
        StringBuilder sql = new StringBuilder("SELECT * FROM Recruitment WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (title != null && !title.trim().isEmpty()) {
            sql.append(" AND JobTitle LIKE ?");
            params.add("%" + title + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
            params.add(status);
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND PostedDate >= ?");
            params.add(startDate);
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND PostedDate <= ?");
            params.add(endDate);
        }
        sql.append(" ORDER BY RecruitmentID LIMIT ? OFFSET ?");
        params.add(size);
        params.add(offset);

        try {
            PreparedStatement ps = con.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Recruitment rec = new Recruitment(rs.getInt("RecruitmentID"), rs.getString("JobTitle"),
                        rs.getString("JobDescription"), rs.getString("Requirement"), rs.getString("Location"), rs.getDouble("Salary"),
                        rs.getString("Status"), rs.getInt("Applicant"), rs.getObject("PostedDate", java.time.LocalDateTime.class));
                rList.add(rec);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi trong searchRecruitment: " + e.getMessage());
        }

        return rList;
    }

    public int searchCountRecruitment(String title, String status, String startDate, String endDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Recruitment WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (title != null && !title.trim().isEmpty()) {
            sql.append(" AND JobTitle LIKE ?");
            params.add("%" + title + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
            params.add(status);
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND PostedDate >= ?");
            params.add(startDate);
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND PostedDate <= ?");
            params.add(endDate);
        }

        try {
            PreparedStatement ps = con.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi trong searchCountRecruitment: " + e.getMessage()); // Thêm thông báo lỗi
        }

        return 0;
    }

    public List<Recruitment> getAllRecruitment(int page, int size) {
        List<Recruitment> rList = new ArrayList<>();
        int offset = (page - 1) * size;
        String sql = "SELECT * from Recruitment ORDER BY RecruitmentID LIMIT ? OFFSET ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, size);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Recruitment rec = new Recruitment(rs.getInt("RecruitmentID"), rs.getString("JobTitle"),
                        rs.getString("JobDescription"), rs.getString("Requirement"), rs.getString("Location"), rs.getDouble("Salary"),
                        rs.getString("Status"), rs.getInt("Applicant"), rs.getObject("PostedDate", java.time.LocalDateTime.class));
                rList.add(rec);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return rList;
    }

    public int getCountRecruitment() {
        String sql = "SELECT COUNT(*) FROM Recruitment";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return 0;
    }

    public Recruitment getRecruitmentById(int id) {
        String sql = "SELECT * FROM Recruitment WHERE recruitmentId = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Recruitment rec = new Recruitment(rs.getInt("RecruitmentID"), rs.getString("JobTitle"),
                        rs.getString("JobDescription"), rs.getString("Requirement"), rs.getString("Location"), rs.getDouble("Salary"),
                        rs.getString("Status"), rs.getInt("Applicant"), rs.getObject("PostedDate", java.time.LocalDateTime.class));
                return rec;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int setRecruitmentById(String title, String description, String requirement, String location, Double salary, int applicant, int id) {
        String sql = "UPDATE Recruitment SET JobTitle = ?, JobDescription = ?, Requirement = ?, Location = ?, Salary = ?, Applicant=? WHERE RecruitmentID = ?";
        int result = 0;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, requirement);
            ps.setString(4, location);
            ps.setDouble(5, salary);
            ps.setInt(6, applicant);
            ps.setInt(7, id);

            result = ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public int deleteRecruitmentById(int id) {
        String sql = "DELETE FROM Recruitment WHERE RecruitmentID = ?";
        int result = 0;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public int createRecruitment(String title, String description, String requirement,
            String location, double salary,
            LocalDateTime postedDate, int applicant) {
        String sql = "INSERT INTO Recruitment (JobTitle, JobDescription, Requirement, Location, Salary, Status, PostedDate, Applicant) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        int result = 0;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, requirement);
            ps.setString(4, location);
            ps.setDouble(5, salary);
            ps.setString(6, "New");
            ps.setTimestamp(7, java.sql.Timestamp.valueOf(postedDate));
            ps.setInt(8, applicant);

            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public int updateRecruitmentStatus(int id, String status) {
        String sql = "UPDATE Recruitment SET Status = ? WHERE RecruitmentID = ?";
        int result = 0;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);

            result = ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error updating recruitment status: " + e.getMessage());
        }

        return result;
    }

    public List<Recruitment> searchRecruitmentWaiting(String title, String startDate, String endDate, int page, int size) {
        List<Recruitment> rList = new ArrayList<>();
        int offset = (page - 1) * size;
        StringBuilder sql = new StringBuilder("SELECT * FROM Recruitment WHERE Status = 'Waiting'");
        List<Object> params = new ArrayList<>();

        if (title != null && !title.trim().isEmpty()) {
            sql.append(" AND JobTitle LIKE ?");
            params.add("%" + title + "%");
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND PostedDate >= ?");
            params.add(startDate);
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND PostedDate <= ?");
            params.add(endDate);
        }
        sql.append(" ORDER BY RecruitmentID LIMIT ? OFFSET ?");
        params.add(size);
        params.add(offset);

        try (PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Recruitment rec = new Recruitment(rs.getInt("RecruitmentID"), rs.getString("JobTitle"),
                        rs.getString("JobDescription"), rs.getString("Requirement"), rs.getString("Location"), rs.getDouble("Salary"),
                        rs.getString("Status"), rs.getInt("Applicant"), rs.getObject("PostedDate", java.time.LocalDateTime.class));
                rList.add(rec);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi trong searchRecruitmentWaiting: " + e.getMessage());
        }

        return rList;
    }

    public int searchCountRecruitmentWaiting(String title, String startDate, String endDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Recruitment WHERE Status = 'Waiting'");
        List<Object> params = new ArrayList<>();

        if (title != null && !title.trim().isEmpty()) {
            sql.append(" AND JobTitle LIKE ?");
            params.add("%" + title + "%");
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND PostedDate >= ?");
            params.add(startDate);
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND PostedDate <= ?");
            params.add(endDate);
        }

        try (PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi trong countRecruitmentWaiting: " + e.getMessage());
        }

        return 0;
    }

    public int getCountRecruitmentWaiting() {
        String sql = "SELECT COUNT(*) FROM Recruitment WHERE Status = 'Waiting'";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return 0;
    }

    public List<Recruitment> getAllRecruitmentWaiting(int page, int size) {
        List<Recruitment> rList = new ArrayList<>();
        int offset = (page - 1) * size;
        String sql = "SELECT * from Recruitment WHERE Status = 'Waiting' ORDER BY RecruitmentID LIMIT ? OFFSET ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, size);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Recruitment rec = new Recruitment(rs.getInt("RecruitmentID"), rs.getString("JobTitle"),
                        rs.getString("JobDescription"), rs.getString("Requirement"), rs.getString("Location"), rs.getDouble("Salary"),
                        rs.getString("Status"), rs.getInt("Applicant"), rs.getObject("PostedDate", java.time.LocalDateTime.class));
                rList.add(rec);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return rList;
    }

    // ==========================
    // Task Management (for Dept)
    // ==========================

    public List<Task> getAllTasks(int page, int size) {
        List<Task> list = new ArrayList<>();
        int offset = (page - 1) * size;
        String sql = "SELECT * FROM Task ORDER BY TaskID LIMIT ? OFFSET ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, size);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Task t = new Task();
                t.setTaskId(rs.getInt("TaskID"));
                t.setTitle(rs.getString("Title"));
                t.setDescription(rs.getString("Description"));
                t.setAssignedBy(rs.getInt("AssignedBy"));
                t.setAssignTo(rs.getInt("AssignTo"));
                if (rs.getDate("StartDate") != null) {
                    t.setStartDate(rs.getDate("StartDate").toLocalDate());
                }
                if (rs.getDate("DueDate") != null) {
                    t.setDueDate(rs.getDate("DueDate").toLocalDate());
                }
                t.setStatus(rs.getString("Status"));
                list.add(t);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return list;
    }

    public int getCountTasks() {
        String sql = "SELECT COUNT(*) FROM Task";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return 0;
    }

    public List<Task> searchTasks(String title, String status, String startDate, String endDate, int page, int size) {
        List<Task> list = new ArrayList<>();
        int offset = (page - 1) * size;
        StringBuilder sql = new StringBuilder("SELECT * FROM Task WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (title != null && !title.trim().isEmpty()) {
            sql.append(" AND Title LIKE ?");
            params.add("%" + title.trim() + "%");
        }

        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append(" AND Status = ?");
            params.add(status.trim());
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND (DueDate IS NOT NULL AND DueDate >= ?)");
            params.add(startDate.trim());
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND (DueDate IS NOT NULL AND DueDate <= ?)");
            params.add(endDate.trim());
        }

        sql.append(" ORDER BY TaskID LIMIT ? OFFSET ?");
        params.add(size);
        params.add(offset);

        try {
            PreparedStatement ps = con.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Task t = new Task();
                t.setTaskId(rs.getInt("TaskID"));
                t.setTitle(rs.getString("Title"));
                t.setDescription(rs.getString("Description"));
                t.setAssignedBy(rs.getInt("AssignedBy"));
                t.setAssignTo(rs.getInt("AssignTo"));
                if (rs.getDate("StartDate") != null) {
                    t.setStartDate(rs.getDate("StartDate").toLocalDate());
                }
                if (rs.getDate("DueDate") != null) {
                    t.setDueDate(rs.getDate("DueDate").toLocalDate());
                }
                t.setStatus(rs.getString("Status"));
                list.add(t);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return list;
    }

    public int searchCountTasks(String title, String status, String startDate, String endDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Task WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (title != null && !title.trim().isEmpty()) {
            sql.append(" AND Title LIKE ?");
            params.add("%" + title.trim() + "%");
        }

        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append(" AND Status = ?");
            params.add(status.trim());
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND (DueDate IS NOT NULL AND DueDate >= ?)");
            params.add(startDate.trim());
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND (DueDate IS NOT NULL AND DueDate <= ?)");
            params.add(endDate.trim());
        }

        try {
            PreparedStatement ps = con.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return 0;
    }

    public int updateTaskStatus(int id, String status) {
        String sql = "UPDATE Task SET Status = ? WHERE TaskID = ?";
        int result = 0;
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public int deleteTaskById(int id) {
        String sql = "DELETE FROM Task WHERE TaskID = ?";
        int result = 0;
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public Task getTaskById(int id) {
        String sql = "SELECT * FROM Task WHERE TaskID = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Task t = new Task();
                t.setTaskId(rs.getInt("TaskID"));
                t.setTitle(rs.getString("Title"));
                t.setDescription(rs.getString("Description"));
                t.setAssignedBy(rs.getInt("AssignedBy"));
                t.setAssignTo(rs.getInt("AssignTo"));
                if (rs.getDate("StartDate") != null) {
                    t.setStartDate(rs.getDate("StartDate").toLocalDate());
                }
                if (rs.getDate("DueDate") != null) {
                    t.setDueDate(rs.getDate("DueDate").toLocalDate());
                }
                t.setStatus(rs.getString("Status"));
                return t;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int createTask(String title, String description, int assignedBy, int assignTo, String startDate, String dueDate, String status) {
        String sql = "INSERT INTO Task (Title, Description, AssignedBy, AssignTo, StartDate, DueDate, Status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        int result = 0;
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setInt(3, assignedBy);
            ps.setInt(4, assignTo);
            if (startDate != null && !startDate.trim().isEmpty()) {
                ps.setDate(5, java.sql.Date.valueOf(startDate));
            } else {
                ps.setDate(5, new java.sql.Date(System.currentTimeMillis()));
            }
            if (dueDate != null && !dueDate.trim().isEmpty()) {
                ps.setDate(6, java.sql.Date.valueOf(dueDate));
            } else {
                ps.setNull(6, java.sql.Types.DATE);
            }
            ps.setString(7, status != null && !status.trim().isEmpty() ? status.trim() : "Pending");
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Employee> loadEmpFollowDepartment(int deptID) {
        List<Employee> eList = new ArrayList<>();
        String sql = "SELECT * from Employee WHERE DepartmentID = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, deptID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Employee emp = new Employee(
                        rs.getInt("EmployeeID"),
                        rs.getString("FullName"),
                        rs.getString("Address"),
                        rs.getString("Phone"),
                        rs.getString("Email"),
                        rs.getString("Position"),
                        rs.getInt("DepartmentID")
                );
                eList.add(emp);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return eList;
    }
    
    public Employee getEmp(int sysID){
    String sql = "SELECT * from Employee WHERE EmployeeID = ?";
    try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, sysID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Employee emp = new Employee(
                        rs.getInt("EmployeeID"),
                        rs.getString("FullName"),
                        rs.getString("Address"),
                        rs.getString("Phone"),
                        rs.getString("Email"),
                        rs.getString("Position"),
                        rs.getInt("DepartmentID")
                );
                return emp;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }
}

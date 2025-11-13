/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.hrm.dao;

import com.hrm.model.entity.Guest;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Hask
 */
public class GuestDAO {

    // Lấy tất cả Guest
    public List<Guest> getAll() {
        List<Guest> list = new ArrayList<>();
        String sql = "SELECT * FROM Guest ORDER BY GuestID";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Guest guest = new Guest();
                guest.setGuestId(rs.getInt("GuestID"));
                guest.setFullName(rs.getString("FullName"));
                guest.setEmail(rs.getString("Email"));
                guest.setPhone(rs.getString("Phone"));
                guest.setCv(rs.getString("CV"));
                guest.setStatus(rs.getString("Status"));
                guest.setRecruitmentId(rs.getObject("RecruitmentID", Integer.class));
                guest.setAppliedDate(rs.getTimestamp("AppliedDate") != null ? 
                    rs.getTimestamp("AppliedDate").toLocalDateTime() : null);
                
                list.add(guest);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy Guest theo ID
    public Guest getById(int guestId) {
        String sql = "SELECT * FROM Guest WHERE GuestID = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, guestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Guest guest = new Guest();
                    guest.setGuestId(rs.getInt("GuestID"));
                    guest.setFullName(rs.getString("FullName"));
                    guest.setEmail(rs.getString("Email"));
                    guest.setPhone(rs.getString("Phone"));
                    guest.setCv(rs.getString("CV"));
                    guest.setStatus(rs.getString("Status"));
                    guest.setRecruitmentId(rs.getObject("RecruitmentID", Integer.class));
                    guest.setAppliedDate(rs.getTimestamp("AppliedDate") != null ? 
                        rs.getTimestamp("AppliedDate").toLocalDateTime() : null);
                    
                    return guest;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy Guest theo email
    public Guest getByEmail(String email) {
        String sql = "SELECT * FROM Guest WHERE Email = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Guest guest = new Guest();
                    guest.setGuestId(rs.getInt("GuestID"));
                    guest.setFullName(rs.getString("FullName"));
                    guest.setEmail(rs.getString("Email"));
                    guest.setPhone(rs.getString("Phone"));
                    guest.setCv(rs.getString("CV"));
                    guest.setStatus(rs.getString("Status"));
                    guest.setRecruitmentId(rs.getObject("RecruitmentID", Integer.class));
                    guest.setAppliedDate(rs.getTimestamp("AppliedDate") != null ? 
                        rs.getTimestamp("AppliedDate").toLocalDateTime() : null);
                    
                    return guest;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy Guest theo RecruitmentID
    public List<Guest> getByRecruitmentId(int recruitmentId) {
        List<Guest> list = new ArrayList<>();
        String sql = "SELECT * FROM Guest WHERE RecruitmentID = ? ORDER BY AppliedDate DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, recruitmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Guest guest = new Guest();
                    guest.setGuestId(rs.getInt("GuestID"));
                    guest.setFullName(rs.getString("FullName"));
                    guest.setEmail(rs.getString("Email"));
                    guest.setPhone(rs.getString("Phone"));
                    guest.setCv(rs.getString("CV"));
                    guest.setStatus(rs.getString("Status"));
                    guest.setRecruitmentId(rs.getObject("RecruitmentID", Integer.class));
                    guest.setAppliedDate(rs.getTimestamp("AppliedDate") != null ? 
                        rs.getTimestamp("AppliedDate").toLocalDateTime() : null);
                    
                    list.add(guest);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy Guest theo status
    public List<Guest> getByStatus(String status) {
        List<Guest> list = new ArrayList<>();
        String sql = "SELECT * FROM Guest WHERE Status = ? ORDER BY AppliedDate DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Guest guest = new Guest();
                    guest.setGuestId(rs.getInt("GuestID"));
                    guest.setFullName(rs.getString("FullName"));
                    guest.setEmail(rs.getString("Email"));
                    guest.setPhone(rs.getString("Phone"));
                    guest.setCv(rs.getString("CV"));
                    guest.setStatus(rs.getString("Status"));
                    guest.setRecruitmentId(rs.getObject("RecruitmentID", Integer.class));
                    guest.setAppliedDate(rs.getTimestamp("AppliedDate") != null ? 
                        rs.getTimestamp("AppliedDate").toLocalDateTime() : null);
                    
                    list.add(guest);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm Guest mới
    public boolean insert(Guest guest) {
        String sql = """
            INSERT INTO Guest (FullName, Email, Phone, CV, Status, RecruitmentID, AppliedDate)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;
        
        System.out.println("=== DEBUG: GuestDAO.insert ===");
        System.out.println("SQL: " + sql);
        System.out.println("Guest data: " + guest.toString());
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            System.out.println("Setting parameters...");
            ps.setString(1, guest.getFullName());
            ps.setString(2, guest.getEmail());
            ps.setString(3, guest.getPhone());
            ps.setString(4, guest.getCv());
            ps.setString(5, guest.getStatus());
            ps.setObject(6, guest.getRecruitmentId(), Types.INTEGER);
            ps.setTimestamp(7, guest.getAppliedDate() != null ? 
                Timestamp.valueOf(guest.getAppliedDate()) : Timestamp.valueOf(LocalDateTime.now()));
            
            System.out.println("Executing insert...");
            int result = ps.executeUpdate();
            System.out.println("Insert result: " + result + " rows affected");
            
            return result > 0;
        } catch (SQLException e) {
            System.err.println("=== ERROR in GuestDAO.insert ===");
            System.err.println("SQL Error: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("=== GENERAL ERROR in GuestDAO.insert ===");
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật Guest
    public boolean update(Guest guest) {
        String sql = """
            UPDATE Guest SET FullName=?, Email=?, Phone=?, CV=?, Status=?, 
                           RecruitmentID=?, AppliedDate=? 
            WHERE GuestID=?
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, guest.getFullName());
            ps.setString(2, guest.getEmail());
            ps.setString(3, guest.getPhone());
            ps.setString(4, guest.getCv());
            ps.setString(5, guest.getStatus());
            ps.setObject(6, guest.getRecruitmentId(), Types.INTEGER);
            ps.setTimestamp(7, guest.getAppliedDate() != null ? 
                Timestamp.valueOf(guest.getAppliedDate()) : null);
            ps.setInt(8, guest.getGuestId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa Guest
    public boolean delete(int guestId) {
        String sql = "DELETE FROM Guest WHERE GuestID=?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, guestId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật status của Guest
    public boolean updateStatus(int guestId, String newStatus) {
        String sql = "UPDATE Guest SET Status = ? WHERE GuestID = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, newStatus);
            ps.setInt(2, guestId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra email có tồn tại không
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Guest WHERE Email=?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, email);
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

    // Kiểm tra số điện thoại có tồn tại không
    public boolean isPhoneExists(String phone) {
        String sql = "SELECT COUNT(*) FROM Guest WHERE Phone=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, phone);
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

    // Đếm tổng số Guest
    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM Guest";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đếm số Guest theo status
    public int getCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Guest WHERE Status = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tìm kiếm Guest theo tên hoặc email
    public List<Guest> search(String keyword) {
        List<Guest> list = new ArrayList<>();
        String sql = """
            SELECT * FROM Guest 
            WHERE FullName LIKE ? OR Email LIKE ? 
            ORDER BY AppliedDate DESC
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Guest guest = new Guest();
                    guest.setGuestId(rs.getInt("GuestID"));
                    guest.setFullName(rs.getString("FullName"));
                    guest.setEmail(rs.getString("Email"));
                    guest.setPhone(rs.getString("Phone"));
                    guest.setCv(rs.getString("CV"));
                    guest.setStatus(rs.getString("Status"));
                    guest.setRecruitmentId(rs.getObject("RecruitmentID", Integer.class));
                    guest.setAppliedDate(rs.getTimestamp("AppliedDate") != null ? 
                        rs.getTimestamp("AppliedDate").toLocalDateTime() : null);
                    
                    list.add(guest);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy Guest với phân trang
    public List<Guest> getPaged(int offset, int limit) {
        List<Guest> list = new ArrayList<>();
        String sql = "SELECT * FROM Guest ORDER BY AppliedDate DESC LIMIT ?, ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Guest guest = new Guest();
                    guest.setGuestId(rs.getInt("GuestID"));
                    guest.setFullName(rs.getString("FullName"));
                    guest.setEmail(rs.getString("Email"));
                    guest.setPhone(rs.getString("Phone"));
                    guest.setCv(rs.getString("CV"));
                    guest.setStatus(rs.getString("Status"));
                    guest.setRecruitmentId(rs.getObject("RecruitmentID", Integer.class));
                    guest.setAppliedDate(rs.getTimestamp("AppliedDate") != null ? 
                        rs.getTimestamp("AppliedDate").toLocalDateTime() : null);
                    
                    list.add(guest);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

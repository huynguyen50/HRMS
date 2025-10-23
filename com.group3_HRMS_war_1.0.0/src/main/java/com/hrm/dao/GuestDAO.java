package com.hrm.dao;

import com.hrm.model.entity.Guest;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

public class GuestDAO {
    
    private static GuestDAO instance;
    private Connection con;

    private GuestDAO() {
        try {
            con = DBConnection.getConnection();
        } catch (SQLException e) {
            Logger.getLogger(DAO.class.getName()).log(Level.SEVERE, "Lỗi kết nối DB", e);
        }
    }

    public static synchronized GuestDAO getInstance() {
        if (instance == null) {
            instance = new GuestDAO();
        }
        return instance;
    }
    
    public Vector<Guest> loadGuest(){
        Vector<Guest> vector= new Vector<>();
        String sql = "Select * from Guest";
        try{
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                Guest g = new Guest(rs.getInt("guestId"), rs.getString("fullName"),
                        rs.getString("email"), rs.getString("phone"), rs.getString("cv"),
                        rs.getString("status"), rs.getInt("recruitmentId"), rs.getObject("appliedDate", LocalDateTime.class));
                vector.add(g);
            }
        } catch (Exception e){
            System.err.println("Error load Guest" + e.getMessage());
        }
        return vector;
    }
}

package com.hrm.dao;

import jakarta.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebListener
public class DBConnection {

    // --- Thông tin kết nối Database ---
    private static final String URL = "jdbc:mysql://localhost:3306/hrm_db";
    private static final String USER = "root";
    private static final String PASSWORD = "Hahahaha2%";

    /**
     * Phương thức chính để lấy kết nối JDBC.
     */
    public static Connection getJDBCConnection() {
        try {
            // Nạp driver MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Tạo kết nối và trả về
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, "Không tìm thấy Driver JDBC!", ex);
        } catch (SQLException ex) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, "Lỗi kết nối database!", ex);
        }
        return null;
    }

    /**
     * Phương thức tiện ích được DAO gọi (giống như alias).
     */
    public static Connection getConnection() {
        return getJDBCConnection();
    }

    /**
     * Dùng để test riêng file kết nối này.
     */
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("Check: Connection created successfully.");
            } else {
                System.out.println("Check: Connection not created.");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
}

package com.hrm.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.io.InputStream;
import java.util.Properties;

public final class DBConnection {

    DBConnection() {
        throw new UnsupportedOperationException("Utility class");
    }

    public static Connection getConnection() throws SQLException {
        Properties props = new Properties();

        // ✅ Thử đọc file db.properties, nếu không có thì dùng cấu hình mặc định
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                props.load(input);
            } else {
                System.out.println("⚠️ Không tìm thấy file db.properties, dùng cấu hình mặc định.");
                props.setProperty("db.url", "jdbc:mysql://localhost:3306/hrm_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
                props.setProperty("db.user", "root");
                props.setProperty("db.password", "Hahahaha2%");
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi khi đọc file db.properties", e);
        }

        String url = props.getProperty("db.url");
        String user = props.getProperty("db.user");
        String password = props.getProperty("db.password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Không tìm thấy MySQL JDBC Driver", e);
        }
    }
}

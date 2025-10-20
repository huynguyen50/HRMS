package com.hrm.util;

import com.hrm.dao.DBConnection;
import java.sql.Connection;

public class DBTest {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("Connect to MySQL succesful!");
            } else {
                System.out.println("Connect to MySQL failed!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

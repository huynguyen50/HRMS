package com.hrm.dao;

import com.hrm.model.entity.SystemUser;
import com.hrm.model.entity.Role;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

public class SystemUserDAO {
    
    public List<SystemUser> getAllUsers() {
        List<SystemUser> userList = new ArrayList<>();
        String sql = "SELECT su.SystemUserID, su.Username, su.Password, su.RoleID, " +
                     "su.LastLogin, su.Active, su.CreatedDate, su.EmployeeID, r.RoleName FROM SystemUser su " +
                     "LEFT JOIN Role r ON su.RoleID = r.RoleID";
        
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            while (rs.next()) {
                SystemUser user = new SystemUser(
                    rs.getInt("SystemUserID"),
                    rs.getString("Username"),
                    rs.getString("Password"),
                    rs.getInt("RoleID"),
                    rs.getObject("LastLogin", LocalDateTime.class),
                    rs.getBoolean("Active"),
                    rs.getObject("CreatedDate", LocalDateTime.class),
                    rs.getInt("EmployeeId")
                );
                
                if (rs.getString("RoleName") != null) {
                    Role role = new Role();
                    role.setRoleName(rs.getString("RoleName"));
                    user.setRole(role);
                }
                
                userList.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userList;
    }

    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) as total FROM SystemUser";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}

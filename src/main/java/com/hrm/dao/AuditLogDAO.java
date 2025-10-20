package com.hrm.dao;

import com.hrm.model.entity.SystemLog;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

public class AuditLogDAO {
    
   public List<SystemLog> getAllAuditLogs() {
        List<SystemLog> logList = new ArrayList<>();
        String sql = "SELECT sl.LogID, sl.SystemUserID, sl.Action, sl.ObjectType, " +
                     "sl.OldValue, sl.NewValue, sl.Timestamp FROM SystemLog sl " +
                     "ORDER BY sl.Timestamp DESC LIMIT 100";
        
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            while (rs.next()) {
                SystemLog log = new SystemLog(
                    rs.getInt("LogID"),
                    rs.getInt("SystemUserID"),
                    rs.getString("Action"),
                    rs.getString("ObjectType"),
                    rs.getString("OldValue"),
                    rs.getString("NewValue"),
                    rs.getObject("Timestamp", LocalDateTime.class)
                );
                logList.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return logList;
    }

    public int getTotalLogs() {
        String sql = "SELECT COUNT(*) as total FROM SystemLog";
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

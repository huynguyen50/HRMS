<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hrm.dao.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Database Test</title>
</head>
<body>
    <h1>Database Connection Test</h1>
    <%
        try {
            Connection conn = DBConnection.getConnection();
            if (conn != null) {
                out.println("<p style='color: green;'>✅ Database connection successful!</p>");
                out.println("<p>Database URL: " + conn.getMetaData().getURL() + "</p>");
                out.println("<p>Database Product: " + conn.getMetaData().getDatabaseProductName() + "</p>");
                out.println("<p>Database Version: " + conn.getMetaData().getDatabaseProductVersion() + "</p>");
                conn.close();
            } else {
                out.println("<p style='color: red;'>❌ Database connection failed!</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color: red;'>❌ Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    %>
</body>
</html>

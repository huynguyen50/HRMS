<%-- 
    Document   : PostRecruitment
    Created on : Oct 20, 2025, 11:44:30 AM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form>
            <h1>Post Recruitment</h1>
            Title: <input type="text" name="title" required="">
            Description: <input type="text" name="description" required="">
            Requirement: <input type="text" name="requirement" required="">
            Location: <input type="text" name="location" required="">
            Salary: <input type="text" name="salary" required="">
            <input type="submit" value="Save">
        </form>
    </body>
</html>

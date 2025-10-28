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
        <title>Post Recruitment</title>
    </head>
    <body>
        <a href="${pageContext.request.contextPath}/home.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Back to Home
        </a>
        <form action="${pageContext.request.contextPath}/postRecruitment" method="post">
            <h1>Post Recruitment</h1>
            Title: <input type="text" name="title" required="">
            Description: <input type="text" name="description" required="">
            Requirement: <input type="text" name="requirement" required="">
            Location: <input type="text" name="location" required="">
            Salary: <input type="number" name="salary" step="1000" required="">
            <input type="submit" value="Save">
        </form>
    </body>
</html>
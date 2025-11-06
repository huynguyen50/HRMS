<%-- 
    Document   : viewTask
    Created on : Nov 6, 2025, 6:42:46 PM
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
        <h1>Task manager</h1>
        <form action="${pageContext.request.contextPath}/postTask" method="post">
            Title: ${task.title}
            Description: ${task.description}
            Assign To: <br>
            <c:forEach var="emp" items="${employeeList}">
                <input type="checkbox" name="assignTo" value="${emp.employeeId}">
                <c:out value="${emp.fullName}"/><br>
            </c:forEach>
            <br>
            
            Start Date: ${task.startDate}
            Due Date: ${task.dueDate}
            Status: 
            <input type="submit" value="Send">
        </form>
    </body>
</html>

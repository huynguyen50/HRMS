<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- THAY ĐỔI: Thêm thư viện JSTL để dùng vòng lặp --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Task Manager</title>
    </head>
    <body>
        <h1>Task manager</h1>
        <form action="${pageContext.request.contextPath}/postTask" method="post">
            Title: <input type="text" required="" maxlength="50" value="" placeholder="title" name="title"><br><br>
            Description: <input type="text" required="" maxlength="1000" value="" placeholder="description" name="description"><br><br>
            Assign To: <br>
            <c:forEach var="emp" items="${employeeList}">
                <input type="checkbox" name="assignTo" value="${emp.employeeId}">
                <c:out value="${emp.fullName}"/><br>
            </c:forEach>
            <br>
            
            Start Date: <input type="datetime-local" required="" name="startDate"><br><br>
            Due Date: <input type="datetime-local" required="" name="dueDate"><br><br>
            
            <input type="submit" value="Send">
        </form>
    </body>
</html>
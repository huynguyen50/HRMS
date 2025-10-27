<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <title>Login Form</title>
    </head>
    <body>
        <div class="container">
            <!--left-->
            <div class="recruitmentContent">
                <a href="Homepage.jsp"><button type="button" class="btn btn-primary">Back to home</button></a>
                <h1>Human Resources Management</h1>

                <div class="info-box">Recruitment information</div>
                <a href="#">Recruit now</a>
            </div>
            <!--right-->
            <div id="logreg-forms"> 
                <form class="form-signin" action="/HRMS/login" method="post">
                    <input type="text" name="user" value="${username}" class="form-control" required="" autofocus="" placeholder="Username">
                    <input type="password" name="pass" value="${password}" class="form-control" required="" autofocus="" placeholder="Password">
                    <div class="remember-group">
                        <input type="checkbox" name="rememberMe" value="1" id="exampleCheck" ${username != null ? "checked" : ""}>
                        <label for="exampleCheck">Remember me</label>
                    </div>                
                    <c:if test="${not empty mess}">
                        <p style="color: red; font-size: 20px;">${mess}</p>
                    </c:if>
                    <input type="submit" value="Login" class="submit">
                    <a href="ForgotPassword.jsp">Forgot password?</a>
                    <hr class="divider">
                    <p class="login-or">Or</p>
<!--                    <button class="btn btn-danger d-flex align-items-center justify-content-center" style="gap:6px; font-weight:500;">
                        <span>Login with Gmail</span>
                        <i class="material-icons" style="font-size:20px;">mail</i>
                    </button>-->
                </form>
            </div>
        </div>
    </body>
</html>

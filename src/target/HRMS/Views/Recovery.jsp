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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forgotPass.css">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <title>Login Form</title>
    </head>
    <body>
        <div class="finding-forms">
            <a href="ForgotPassword.jsp"><button type="button" class="btn btn-primary"> Back </button></a>
            <form class="form-find" action="${pageContext.request.contextPath}/Recovery" method="post">
                <h1 class="page-title">Verify your PIN code</h1>
                <p class="page-subtitle">Enter the 6 digit code we sent to your email </p>
                <input type="text" value="" name="pin" autofocus="" placeholder="Enter PIN code here" class="input-email">
                <c:if test="${not empty pinExpireMessage}">
                    <p style="color: #ff9800; font-size: 16px; margin-top: 10px;">
                        <i class="material-icons" style="font-size: 16px; vertical-align: middle;">access_time</i>
                        ${pinExpireMessage}
                    </p>
                </c:if>
                <c:if test="${not empty mess}">
                    <p style="color: red; font-size: 20px;">${mess}</p>
                </c:if>
                
                <input type="submit" value="Confirm" class="submit">
            </form>
        </div>
    </body>
</html>
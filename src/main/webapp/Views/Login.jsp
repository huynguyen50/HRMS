<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HRM - Login</title>
        
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

        <style>
            /* --- GENERAL STYLES --- */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Poppins', sans-serif;
                background: linear-gradient(120deg, #e0c3fc 0%, #8ec5fc 100%);
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            /* --- LOGIN CONTAINER --- */
            .login-container {
                background-color: #ffffff;
                padding: 50px 40px;
                border-radius: 20px;
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 420px;
                text-align: center;
                transition: transform 0.3s ease;
            }
            .login-container:hover {
                transform: translateY(-5px);
            }

            .login-header {
                margin-bottom: 30px;
            }
            .login-header h1 {
                color: #2563eb;
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 10px;
            }
            .login-header p {
                color: #6c757d;
                font-size: 0.95rem;
            }

            /* --- FORM STYLES --- */
            .login-form {
                text-align: left;
            }
            .input-group {
                position: relative;
                margin-bottom: 25px;
            }
            .input-group i {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #adb5bd;
                font-size: 1.1rem;
                transition: color 0.3s;
            }
            .login-form .form-control {
                width: 100%;
                padding: 12px 15px 12px 45px;
                border: 2px solid #e9ecef;
                border-radius: 10px;
                font-size: 1rem;
                background-color: #f8f9fa;
                transition: all 0.3s ease;
            }
            .login-form .form-control:focus {
                border-color: #2563eb;
                box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.25);
                background-color: #fff;
            }
            .login-form .form-control:focus + i {
                color: #2563eb;
            }

            .remember-group {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
            }
            .remember-group .form-check {
                display: flex;
                align-items: center;
            }
            .remember-group .form-check-input {
                width: 18px;
                height: 18px;
                margin-right: 8px;
            }
            .remember-group .form-check-label {
                font-size: 0.9rem;
                color: #495057;
            }
            .remember-group a {
                color: #2563eb;
                text-decoration: none;
                font-size: 0.9rem;
                font-weight: 500;
                transition: color 0.3s;
            }
            .remember-group a:hover {
                color: #1d4ed8;
                text-decoration: underline;
            }

            /* --- BUTTONS --- */
            .btn-login {
                width: 100%;
                background-color: #2563eb;
                color: #ffffff;
                font-size: 1.1rem;
                font-weight: 600;
                border: none;
                border-radius: 10px;
                padding: 12px;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-bottom: 20px;
            }
            .btn-login:hover {
                background-color: #1d4ed8;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(37, 99, 235, 0.3);
            }

            .divider {
                text-align: center;
                margin: 25px 0;
                position: relative;
            }
            .divider::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 0;
                right: 0;
                height: 1px;
                background-color: #dee2e6;
            }
            .divider span {
                background-color: #fff;
                padding: 0 15px;
                color: #6c757d;
                position: relative;
                font-size: 0.9rem;
            }

            .btn-social {
                width: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                padding: 10px;
                border-radius: 10px;
                font-weight: 500;
                text-decoration: none;
                transition: all 0.3s ease;
            }
            .btn-gmail {
                background-color: #ffffff;
                color: #333;
                border: 1px solid #dadce0;
            }
            .btn-gmail:hover {
                background-color: #f8f9fa;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                text-decoration: none;
                color: #333;
            }

            /* --- ERROR MESSAGE --- */
            .error-message {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
                padding: 12px;
                border-radius: 8px;
                font-size: 0.9rem;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="login-header">
                <h1>HRMS</h1>
                <p>Please login to continue</p>
            </div>

            <form class="login-form" action="${pageContext.request.contextPath}/login" method="post">
                <div class="input-group">
                    <input type="text" name="user" value="${username}" class="form-control" placeholder="Username" required>
                    <i class="fas fa-user"></i>
                </div>
                <div class="input-group">
                    <input type="password" name="pass" value="${password}" class="form-control" placeholder="Password" required>
                    <i class="fas fa-lock"></i>
                </div>
                
                <c:if test="${not empty mess}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${mess}</span>
                    </div>
                </c:if>

                <div class="remember-group">
                    <div class="form-check">
                        <input type="checkbox" name="rememberMe" value="1" id="rememberMe" ${username != null ? "checked" : ""} class="form-check-input">
                        <label for="rememberMe" class="form-check-label">Remember me</label>
                    </div>
                    <a href="${pageContext.request.contextPath}/Views/ForgotPassword.jsp">Forgot Password?</a>
                </div>

                <button type="submit" class="btn-login">Log In</button>
            </form>

            <div class="divider">
                <span>OR</span>
            </div>

            <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20pro…2sdrgc53oqd.apps.googleusercontent.com&approval_prompt=force" class="btn-social btn-gmail">
                <i class="fab fa-google"></i>
                Login with Gmail
            </a>
        </div>
    </body>
</html>
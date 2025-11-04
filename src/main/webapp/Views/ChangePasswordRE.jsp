<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HRM - Change Password</title>
        
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

            /* --- STYLE CHO NÚT "BACK" --- */
            .back-link {
                display: inline-flex;
                align-items: center;
                justify-content: flex-start;
                width: 100%;
                color: #6c757d;
                text-decoration: none;
                font-size: 0.9rem;
                margin-bottom: 20px;
                transition: color 0.3s;
            }
            .back-link:hover {
                color: #2563eb;
                text-decoration: none;
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
                <a href="Home.jsp" class="back-link">
                    <i class="fas fa-arrow-left"></i> Back to home
                </a>
                <h1>Change Your Password</h1>
                <p>Enter your new password below</p>
            </div>

            <form class="login-form" action="${pageContext.request.contextPath}/changepassRE" method="post">
                <div class="input-group">
                    <input type="password" name="newPass" value="" required="" placeholder="New password" class="form-control">
                    <i class="fas fa-lock"></i>
                </div>
                
                <div class="input-group">
                    <input type="password" name="confirmPass" value="" required="" placeholder="Confirm password" class="form-control">
                    <i class="fas fa-lock"></i>
                </div>
                
                <c:if test="${not empty mess}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${mess}</span>
                    </div>
                </c:if>

                <button type="submit" class="btn-login">Save</button>
            </form>
        </div>
    </body>
</html>
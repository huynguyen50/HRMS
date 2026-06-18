<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>BetterHR - Xác minh mã PIN</title>
        <link href="https://fonts.googleapis.com/css2?family=Hanken+Grotesk:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

        <style>
            :root {
                --canvas-warm: #f2f0eb;
                --surface-white: #ffffff;
                --primary: #006241;
                --primary-dark: #1E3932;
                --cta: #00754A;
                --outline: #d4d0c8;
                --text-primary: rgba(0, 0, 0, 0.87);
                --text-secondary: rgba(0, 0, 0, 0.58);
                --error: #c82014;
                --error-bg: #fff3f1;
                --warning: #8a5a00;
                --warning-bg: #fff8e1;
                --radius-card: 12px;
                --radius-pill: 999px;
                --shadow-card: 0 18px 44px rgba(30, 57, 50, 0.12);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            html {
                min-height: 100%;
                background: var(--canvas-warm);
            }

            body {
                font-family: "Hanken Grotesk", "Helvetica Neue", Arial, sans-serif;
                color: var(--text-primary);
                background:
                    radial-gradient(circle at 12% 12%, rgba(0, 117, 74, 0.08), transparent 32%),
                    var(--canvas-warm);
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 32px 20px;
                -webkit-font-smoothing: antialiased;
                letter-spacing: 0;
            }

            .login-container {
                background: var(--surface-white);
                padding: 42px 40px 44px;
                border: 1px solid rgba(30, 57, 50, 0.10);
                border-radius: var(--radius-card);
                box-shadow: var(--shadow-card);
                width: 100%;
                max-width: 430px;
                text-align: center;
            }

            .login-header {
                margin-bottom: 28px;
            }

            .login-header h1 {
                color: var(--primary);
                font-size: clamp(2rem, 5vw, 2.5rem);
                line-height: 1.15;
                font-weight: 800;
                margin: 18px 0 12px;
                letter-spacing: 0;
            }

            .login-header p {
                color: var(--text-secondary);
                font-size: 1rem;
                line-height: 1.5;
            }

            .back-link {
                display: inline-flex;
                align-items: center;
                justify-content: flex-start;
                gap: 8px;
                width: 100%;
                color: var(--text-secondary);
                text-decoration: none;
                font-size: 0.95rem;
                font-weight: 600;
                transition: color 0.2s ease;
            }

            .back-link:hover {
                color: var(--primary);
                text-decoration: none;
            }

            .login-form {
                text-align: left;
            }

            .input-group {
                position: relative;
                margin-bottom: 18px;
            }

            .input-group i {
                position: absolute;
                left: 18px;
                top: 50%;
                transform: translateY(-50%);
                color: var(--text-secondary);
                font-size: 1rem;
                pointer-events: none;
                transition: color 0.2s ease;
            }

            .login-form .form-control {
                width: 100%;
                min-height: 54px;
                padding: 14px 16px 14px 50px;
                border: 1px solid var(--outline);
                border-radius: 8px;
                font-size: 1rem;
                color: var(--text-primary);
                background: var(--surface-white);
                outline: none;
                transition: border-color 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
            }

            .login-form .form-control::placeholder {
                color: rgba(0, 0, 0, 0.42);
            }

            .login-form .form-control:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 4px rgba(0, 98, 65, 0.12);
                background: #ffffff;
            }

            .login-form .form-control:focus + i {
                color: var(--primary);
            }

            .btn-login {
                width: 100%;
                background: var(--cta);
                color: #ffffff;
                font-size: 1rem;
                font-weight: 800;
                border: none;
                border-radius: var(--radius-pill);
                min-height: 54px;
                padding: 14px 18px;
                cursor: pointer;
                transition: background 0.2s ease, box-shadow 0.2s ease, transform 0.2s ease;
                margin-top: 8px;
            }

            .btn-login:hover {
                background: var(--primary);
                box-shadow: 0 10px 24px rgba(0, 117, 74, 0.22);
                transform: translateY(-1px);
            }

            .btn-login:active {
                transform: scale(0.98);
            }

            .error-message {
                background: var(--error-bg);
                color: var(--error);
                border: 1px solid rgba(200, 32, 20, 0.24);
                padding: 12px 14px;
                border-radius: 8px;
                font-size: 0.95rem;
                font-weight: 700;
                line-height: 1.4;
                margin: 0 0 18px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .info-message {
                background: var(--warning-bg);
                color: var(--warning);
                border: 1px solid rgba(138, 90, 0, 0.22);
                padding: 12px 14px;
                border-radius: 8px;
                font-size: 0.95rem;
                font-weight: 700;
                line-height: 1.4;
                margin: 0 0 18px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            @media (max-width: 520px) {
                body {
                    align-items: flex-start;
                    padding-top: 28px;
                }

                .login-container {
                    padding: 32px 24px 34px;
                }

                .login-header h1 {
                    font-size: 2rem;
                }
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="login-header">
                <a href="${pageContext.request.contextPath}/ForgotPassword" class="back-link">
                    <i class="fas fa-arrow-left"></i> Quay lại nhập email
                </a>
                <h1>Xác minh mã PIN</h1>
                <p>Nhập mã gồm 6 chữ số đã được gửi tới email của bạn.</p>
            </div>

            <form class="login-form" action="${pageContext.request.contextPath}/Recovery" method="post">
                <div class="input-group">
                    <input type="text" name="pin" value="" autofocus="" placeholder="Nhập mã PIN" class="form-control" inputmode="numeric" maxlength="6" required>
                    <i class="fas fa-key"></i>
                </div>
                
                <c:if test="${not empty pinExpireMessage}">
                    <div class="info-message">
                        <i class="fas fa-clock"></i>
                        <span>${pinExpireMessage}</span>
                    </div>
                </c:if>
                
                <c:if test="${not empty mess}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${mess}</span>
                    </div>
                </c:if>

                <button type="submit" class="btn-login">Xác nhận</button>
            </form>
        </div>
    </body>
</html>

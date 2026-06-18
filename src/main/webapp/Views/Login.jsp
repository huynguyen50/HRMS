<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - BetterHR</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        :root {
            --bh-green: #006241;
            --bh-accent: #00754A;
            --bh-house: #1E3932;
            --bh-canvas: #f2f0eb;
            --bh-ceramic: #edebe9;
            --bh-text: rgba(0, 0, 0, 0.87);
            --bh-muted: rgba(0, 0, 0, 0.58);
            --bh-border: rgba(0, 0, 0, 0.14);
            --bh-danger: #c82014;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 32px 16px;
            font-family: Inter, "Helvetica Neue", Arial, sans-serif;
            background: var(--bh-canvas);
            color: var(--bh-text);
        }

        .login-container {
            width: 100%;
            max-width: 420px;
            padding: 34px 36px 30px;
            background: #ffffff;
            border: 1px solid var(--bh-border);
            border-radius: 12px;
            box-shadow: 0 0 0.5px rgba(0, 0, 0, 0.14), 0 8px 24px rgba(0, 0, 0, 0.10);
        }

        .login-header {
            text-align: center;
            margin-bottom: 22px;
        }

        .login-header h1 {
            margin: 0 0 8px;
            color: var(--bh-green);
            font-size: 22px;
            line-height: 1.25;
            font-weight: 800;
        }

        .login-header p {
            margin: 0;
            color: var(--bh-muted);
            font-size: 14px;
            line-height: 1.55;
        }

        .google-button {
            width: 100%;
            min-height: 46px;
            border: 1px solid rgba(0, 0, 0, 0.22);
            border-radius: 50px;
            background: #ffffff;
            color: var(--bh-text);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
        }

        .google-button:hover {
            background: #f9f9f9;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.10);
        }

        .google-button:active,
        .btn-login:active {
            transform: scale(0.95);
        }

        .google-icon {
            width: 18px;
            height: 18px;
            display: inline-grid;
            place-items: center;
            border-radius: 3px;
            background: #1a73e8;
            color: #ffffff;
            font-size: 11px;
            font-weight: 800;
        }

        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 26px 0;
            color: var(--bh-muted);
            font-size: 12px;
        }

        .divider::before,
        .divider::after {
            content: "";
            flex: 1;
            height: 1px;
            background: rgba(0, 0, 0, 0.14);
        }

        .login-form {
            display: grid;
            gap: 14px;
        }

        .input-group {
            position: relative;
        }

        .input-group i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(0, 0, 0, 0.36);
            font-size: 15px;
            pointer-events: none;
        }

        .form-control {
            width: 100%;
            min-height: 48px;
            padding: 12px 14px 12px 42px;
            border: 1px solid rgba(0, 0, 0, 0.18);
            border-radius: 8px;
            background: #ffffff;
            color: var(--bh-text);
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .form-control::placeholder {
            color: rgba(0, 0, 0, 0.45);
        }

        .form-control:focus {
            border-color: var(--bh-accent);
            box-shadow: 0 0 0 3px rgba(0, 117, 74, 0.14);
        }

        .remember-group {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin: 2px 0 8px;
            font-size: 13px;
        }

        .form-check {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--bh-muted);
        }

        .form-check-input {
            width: 16px;
            height: 16px;
            accent-color: var(--bh-accent);
        }

        .remember-group a,
        .signup-line a {
            color: var(--bh-green);
            text-decoration: none;
            font-weight: 800;
        }

        .remember-group a:hover,
        .signup-line a:hover {
            text-decoration: underline;
        }

        .btn-login {
            width: 100%;
            min-height: 48px;
            border: 1px solid var(--bh-accent);
            border-radius: 50px;
            background: var(--bh-accent);
            color: #ffffff;
            font-size: 14px;
            font-weight: 800;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
        }

        .btn-login:hover {
            background: var(--bh-green);
            box-shadow: 0 6px 18px rgba(0, 98, 65, 0.24);
        }

        .error-message {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid rgba(200, 32, 20, 0.22);
            background: rgba(200, 32, 20, 0.06);
            color: var(--bh-danger);
            font-size: 13px;
            font-weight: 600;
        }

        .success-message {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid rgba(0, 117, 74, 0.24);
            background: rgba(0, 117, 74, 0.08);
            color: var(--bh-green);
            font-size: 13px;
            font-weight: 700;
        }

        .signup-line {
            margin: 26px 0 0;
            text-align: center;
            color: var(--bh-muted);
            font-size: 13px;
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 28px 22px;
            }
        }
    </style>
</head>
<body>
    <main class="login-container">
        <div class="login-header">
            <h1>Đăng nhập vào BetterHR</h1>
            <p>Chào mừng bạn quay trở lại. Hãy quản lý nhân sự một cách tinh tế nhất.</p>
        </div>

        <a href="${pageContext.request.contextPath}/auth/google" class="google-button">
            <span class="google-icon">G</span>
            <span>Tiếp tục với Google</span>
        </a>

        <div class="divider">
            <span>Hoặc sử dụng email</span>
        </div>

        <form class="login-form" action="${pageContext.request.contextPath}/login" method="post">
            <div class="input-group">
                <input type="text" name="user" value="${username}" class="form-control" placeholder="Tên đăng nhập" required>
                <i class="fas fa-user"></i>
            </div>

            <div class="input-group">
                <input type="password" name="pass" class="form-control" placeholder="Mật khẩu" required>
                <i class="fas fa-lock"></i>
            </div>

            <c:if test="${not empty mess}">
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${mess}</span>
                </div>
            </c:if>

            <c:if test="${not empty successMess}">
                <div class="success-message">
                    <i class="fas fa-circle-check"></i>
                    <span>${successMess}</span>
                </div>
            </c:if>

            <div class="remember-group">
                <label class="form-check" for="rememberMe">
                    <input type="checkbox" name="rememberMe" value="1" id="rememberMe" ${username != null ? "checked" : ""} class="form-check-input">
                    <span>Ghi nhớ tôi</span>
                </label>
                <a href="${pageContext.request.contextPath}/Views/ForgotPassword.jsp">Quên mật khẩu?</a>
            </div>

            <button type="submit" class="btn-login">Đăng nhập</button>
        </form>

        <p class="signup-line">Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Tạo tài khoản mới</a></p>
    </main>
</body>
</html>

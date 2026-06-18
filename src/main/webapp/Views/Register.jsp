<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo tài khoản - BetterHR</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        :root {
            --bh-green: #006241;
            --bh-accent: #00754A;
            --bh-canvas: #f2f0eb;
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

        .register-container {
            width: 100%;
            max-width: 440px;
            padding: 34px 36px 30px;
            background: #ffffff;
            border: 1px solid var(--bh-border);
            border-radius: 12px;
            box-shadow: 0 0 0.5px rgba(0, 0, 0, 0.14), 0 8px 24px rgba(0, 0, 0, 0.10);
        }

        .register-header {
            text-align: center;
            margin-bottom: 24px;
        }

        .register-header h1 {
            margin: 0 0 8px;
            color: var(--bh-green);
            font-size: 22px;
            line-height: 1.25;
            font-weight: 800;
        }

        .register-header p {
            margin: 0;
            color: var(--bh-muted);
            font-size: 14px;
            line-height: 1.55;
        }

        .register-form {
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

        .error-message {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid rgba(200, 32, 20, 0.22);
            background: rgba(200, 32, 20, 0.06);
            color: var(--bh-danger);
            font-size: 13px;
            font-weight: 700;
            line-height: 1.45;
        }

        .btn-register {
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

        .btn-register:hover {
            background: var(--bh-green);
            box-shadow: 0 6px 18px rgba(0, 98, 65, 0.24);
        }

        .btn-register:active {
            transform: scale(0.95);
        }

        .signin-line {
            margin: 24px 0 0;
            text-align: center;
            color: var(--bh-muted);
            font-size: 13px;
        }

        .signin-line a,
        .back-link {
            color: var(--bh-green);
            text-decoration: none;
            font-weight: 800;
        }

        .signin-line a:hover,
        .back-link:hover {
            text-decoration: underline;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 18px;
            font-size: 13px;
        }

        @media (max-width: 480px) {
            .register-container {
                padding: 28px 22px;
            }
        }
    </style>
</head>
<body>
    <main class="register-container">
        <a class="back-link" href="${pageContext.request.contextPath}/login">
            <i class="fas fa-arrow-left"></i>
            <span>Quay lại đăng nhập</span>
        </a>

        <div class="register-header">
            <h1>Tạo tài khoản BetterHR</h1>
            <p>Đăng ký tài khoản nhân viên để sử dụng hệ thống.</p>
        </div>

        <form class="register-form" action="${pageContext.request.contextPath}/register" method="post">
            <div class="input-group">
                <input type="text" name="username" value="${username}" class="form-control" placeholder="Tên đăng nhập" maxlength="100" required>
                <i class="fas fa-user"></i>
            </div>

            <div class="input-group">
                <input type="email" name="email" value="${email}" class="form-control" placeholder="Email" maxlength="150" required>
                <i class="fas fa-envelope"></i>
            </div>

            <div class="input-group">
                <input type="password" name="password" class="form-control" placeholder="Mật khẩu" minlength="6" maxlength="100" required>
                <i class="fas fa-lock"></i>
            </div>

            <div class="input-group">
                <input type="password" name="confirmPassword" class="form-control" placeholder="Xác nhận mật khẩu" minlength="6" maxlength="100" required>
                <i class="fas fa-shield-halved"></i>
            </div>

            <c:if test="${not empty mess}">
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${mess}</span>
                </div>
            </c:if>

            <button type="submit" class="btn-register">Tạo tài khoản</button>
        </form>

        <p class="signin-line">Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a></p>
    </main>
</body>
</html>

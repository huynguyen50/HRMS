<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>BetterHR - Đổi mật khẩu</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <style>
            :root {
                --bh-green: #006241;
                --bh-accent: #00754A;
                --bh-house: #1E3932;
                --bh-canvas: #f2f0eb;
                --bh-ceramic: #edebe9;
                --bh-white: #ffffff;
                --bh-text: rgba(0, 0, 0, .87);
                --bh-muted: rgba(0, 0, 0, .58);
                --bh-border: rgba(0, 0, 0, .14);
                --bh-danger: #c82014;
                --bh-danger-bg: #fff4f2;
            }

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 32px 16px;
                background: var(--bh-canvas);
                color: var(--bh-text);
                font-family: "Inter", "Helvetica Neue", Arial, sans-serif;
            }

            .password-card {
                width: 100%;
                max-width: 440px;
                padding: 42px 40px;
                background: var(--bh-white);
                border: 1px solid var(--bh-border);
                border-radius: 12px;
                box-shadow: 0 1px 2px rgba(0, 0, 0, .08), 0 12px 30px rgba(0, 0, 0, .08);
            }

            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 28px;
                color: var(--bh-muted);
                font-size: .95rem;
                font-weight: 500;
                text-decoration: none;
            }

            .back-link:hover {
                color: var(--bh-green);
            }

            .password-header {
                margin-bottom: 28px;
                text-align: center;
            }

            .password-header h1 {
                margin-bottom: 10px;
                color: var(--bh-green);
                font-size: 2.25rem;
                font-weight: 800;
                line-height: 1.15;
                letter-spacing: 0;
            }

            .password-header p {
                color: var(--bh-muted);
                font-size: .98rem;
                line-height: 1.6;
            }

            .password-form {
                display: grid;
                gap: 18px;
            }

            .input-group {
                position: relative;
            }

            .input-group i {
                position: absolute;
                top: 50%;
                left: 16px;
                color: var(--bh-muted);
                transform: translateY(-50%);
            }

            .form-control {
                width: 100%;
                min-height: 50px;
                padding: 13px 16px 13px 46px;
                border: 1px solid var(--bh-border);
                border-radius: 8px;
                background: var(--bh-white);
                color: var(--bh-text);
                font-size: 1rem;
                outline: none;
                transition: border-color .2s ease, box-shadow .2s ease;
            }

            .form-control::placeholder {
                color: rgba(0, 0, 0, .46);
            }

            .form-control:focus {
                border-color: var(--bh-green);
                box-shadow: 0 0 0 3px rgba(0, 98, 65, .14);
            }

            .btn-submit {
                width: 100%;
                min-height: 52px;
                margin-top: 4px;
                border: none;
                border-radius: 999px;
                background: var(--bh-green);
                color: var(--bh-white);
                font-size: 1rem;
                font-weight: 700;
                cursor: pointer;
                transition: background .2s ease, transform .2s ease, box-shadow .2s ease;
            }

            .btn-submit:hover {
                background: var(--bh-accent);
                box-shadow: 0 8px 18px rgba(0, 98, 65, .22);
                transform: translateY(-1px);
            }

            .message {
                display: flex;
                align-items: flex-start;
                gap: 10px;
                padding: 12px 14px;
                border: 1px solid rgba(200, 32, 20, .2);
                border-radius: 8px;
                background: var(--bh-danger-bg);
                color: var(--bh-danger);
                font-size: .92rem;
                line-height: 1.5;
            }

            @media (max-width: 520px) {
                .password-card {
                    padding: 32px 24px;
                }

                .password-header h1 {
                    font-size: 1.9rem;
                }
            }
        </style>
    </head>
    <body>
        <main class="password-card">
            <a href="${pageContext.request.contextPath}/homepage" class="back-link">
                <i class="fas fa-arrow-left"></i>
                Về trang chủ
            </a>

            <div class="password-header">
                <h1>Đổi mật khẩu</h1>
                <p>Nhập mật khẩu hiện tại và mật khẩu mới của bạn.</p>
            </div>

            <form class="password-form" action="${pageContext.request.contextPath}/changepass" method="post">
                <div class="input-group">
                    <input type="password" name="curPass" required placeholder="Mật khẩu hiện tại" class="form-control">
                    <i class="fas fa-lock-open"></i>
                </div>

                <div class="input-group">
                    <input type="password" name="newPass" required placeholder="Mật khẩu mới" class="form-control">
                    <i class="fas fa-lock"></i>
                </div>

                <div class="input-group">
                    <input type="password" name="confirmPass" required placeholder="Xác nhận mật khẩu mới" class="form-control">
                    <i class="fas fa-lock"></i>
                </div>

                <c:if test="${not empty mess}">
                    <div class="message">
                        <i class="fas fa-circle-info"></i>
                        <span>${mess}</span>
                    </div>
                </c:if>

                <button type="submit" class="btn-submit">Lưu thay đổi</button>
            </form>
        </main>
    </body>
</html>

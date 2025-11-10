<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Không có quyền truy cập</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .access-denied-container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            max-width: 500px;
            width: 100%;
            padding: 40px;
            text-align: center;
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .icon-container {
            width: 120px;
            height: 120px;
            margin: 0 auto 30px;
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 60px;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
        }

        h1 {
            color: #1f2937;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 16px;
        }

        .message {
            color: #6b7280;
            font-size: 16px;
            line-height: 1.6;
            margin-bottom: 30px;
        }

        .permission-info {
            background: #f3f4f6;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 30px;
            text-align: left;
        }

        .permission-info strong {
            color: #374151;
            display: block;
            margin-bottom: 8px;
        }

        .permission-info span {
            color: #6b7280;
            font-size: 14px;
        }

        .actions {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.2s;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: #f3f4f6;
            color: #374151;
            border: 2px solid #e5e7eb;
        }

        .btn-secondary:hover {
            background: #e5e7eb;
            border-color: #d1d5db;
        }

        .contact-info {
            margin-top: 30px;
            padding-top: 30px;
            border-top: 1px solid #e5e7eb;
            color: #9ca3af;
            font-size: 14px;
        }

        .contact-info a {
            color: #667eea;
            text-decoration: none;
        }

        .contact-info a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="access-denied-container">
        <div class="icon-container">
            🚫
        </div>
        
        <h1>Không có quyền truy cập</h1>
        
        <div class="message">
            Bạn không có quyền truy cập vào chức năng này. 
            <c:if test="${not empty permissionCode}">
                <br><br>
                <div class="permission-info">
                    <strong>Quyền yêu cầu:</strong>
                    <span>${permissionCode}</span>
                    <c:if test="${not empty permissionName}">
                        <br><strong>Tên quyền:</strong>
                        <span>${permissionName}</span>
                    </c:if>
                </div>
            </c:if>
        </div>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/Views/Homepage.jsp" class="btn btn-primary">
                🏠 Về Trang Chủ
            </a>
            <a href="javascript:history.back()" class="btn btn-secondary">
                ← Quay Lại
            </a>
        </div>

        <div class="contact-info">
            Nếu bạn cho rằng đây là lỗi, vui lòng liên hệ với quản trị viên hệ thống.
            <br>
            <c:if test="${not empty currentUser}">
                Tài khoản: <strong>${currentUser.username}</strong>
            </c:if>
        </div>
    </div>
</body>
</html>



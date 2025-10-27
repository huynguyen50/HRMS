<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Success</title>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap');

            body {
                font-family: 'Poppins', sans-serif;
                background-color: #f0f2f5;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }

            .success-container {
                text-align: center;
                background-color: white;
                padding: 50px 60px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                animation: fadeIn 0.5s ease-in-out;
            }

            /* Dấu tick lớn */
            .checkmark-circle {
                width: 120px;
                height: 120px;
                margin: 0 auto 20px;
                background-color: #28a745; /* Màu xanh lá cây */
                border-radius: 50%;
                display: flex;
                justify-content: center;
                align-items: center;
                animation: scaleIn 0.5s ease-in-out;
            }

            .checkmark {
                color: white;
                font-size: 70px;
                font-weight: bold;
                line-height: 1;
            }

            /* Thông điệp thành công */
            .success-message {
                color: #333;
                font-size: 24px;
                font-weight: 600;
                margin-bottom: 30px;
            }

            /* Nút trở về */
            .btn-back-home {
                display: inline-block;
                background-color: #007bff;
                color: white;
                padding: 12px 30px;
                font-size: 16px;
                font-weight: 600;
                text-decoration: none;
                border-radius: 50px;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
            }

            .btn-back-home:hover {
                background-color: #0056b3;
                transform: translateY(-3px);
                box-shadow: 0 6px 20px rgba(0, 123, 255, 0.4);
                text-decoration: none;
                color: white;
            }

            /* Hiệu ứng animation */
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(-20px); }
                to { opacity: 1; transform: translateY(0); }
            }

            @keyframes scaleIn {
                from { transform: scale(0); }
                to { transform: scale(1); }
            }
        </style>
    </head>
    <body>
        <div class="success-container">
            <div class="checkmark-circle">
<p class="checkmark">✓</p>
            </div>
            <h1 class="success-message">Your request is successfully!!!</h1>
            <a href="${pageContext.request.contextPath}/Views/Homepage.jsp" class="btn-back-home">Back to Home</a>
        </div>
    </body>
</html>
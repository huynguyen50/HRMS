<%--
    Document   : ApplyForm
    Created on : Oct 27, 2025, 1:45:23 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.hrm.model.entity.Recruitment"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ứng tuyển - BetterHR</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --bh-green: #006241;
            --bh-accent: #00754A;
            --bh-house: #1E3932;
            --bh-canvas: #f2f0eb;
            --bh-ceramic: #edebe9;
            --bh-white: #ffffff;
            --bh-text: rgba(0, 0, 0, 0.87);
            --bh-muted: rgba(0, 0, 0, 0.58);
            --bh-border: rgba(0, 0, 0, 0.14);
            --bh-gold: #cba258;
            --bh-red: #c82014;
            --bh-mint: #d4e9e2;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            min-height: 100vh;
            font-family: Inter, "Helvetica Neue", Arial, sans-serif;
            color: var(--bh-text);
            background: var(--bh-canvas);
            line-height: 1.6;
        }

        .header {
            background: var(--bh-house);
            color: var(--bh-white);
            padding: 42px 20px 46px;
            text-align: center;
        }

        .header h1 {
            margin-bottom: 8px;
            font-size: clamp(32px, 4vw, 48px);
            line-height: 1.16;
            font-weight: 800;
            letter-spacing: 0;
        }

        .header p {
            color: rgba(255, 255, 255, 0.72);
            font-size: 18px;
        }

        .container {
            width: min(920px, calc(100% - 32px));
            margin: 0 auto;
        }

        .navigation-buttons {
            display: flex;
            align-items: center;
            padding: 24px 0 0;
        }

        .back-btn,
        .submit-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            border-radius: 50px;
            font-weight: 800;
            text-decoration: none;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease, border-color 0.2s ease;
        }

        .back-btn {
            min-height: 44px;
            padding: 9px 18px;
            border: 1px solid var(--bh-border);
            background: var(--bh-white);
            color: var(--bh-green);
            box-shadow: 0 0 0.5px rgba(0,0,0,0.14), 0 1px 1px rgba(0,0,0,0.18);
        }

        .back-btn:hover {
            background: var(--bh-ceramic);
            transform: translateY(-2px);
        }

        .form-section {
            margin: 32px auto 56px;
            padding: 40px;
            border: 1px solid var(--bh-border);
            border-radius: 12px;
            background: var(--bh-white);
            box-shadow: 0 0 0.5px rgba(0,0,0,0.14), 0 8px 24px rgba(0,0,0,0.08);
        }

        .job-info {
            margin-bottom: 28px;
            padding: 24px;
            border-left: 4px solid var(--bh-accent);
            border-radius: 8px;
            background: var(--bh-ceramic);
        }

        .job-info h3 {
            margin-bottom: 12px;
            color: var(--bh-text);
            font-size: 22px;
            font-weight: 800;
        }

        .job-info p {
            margin-bottom: 6px;
            color: var(--bh-muted);
            font-size: 16px;
        }

        .job-info i {
            color: var(--bh-green);
            margin-right: 6px;
        }

        .form-note {
            margin-bottom: 30px;
            padding: 18px 20px;
            border-left: 4px solid var(--bh-accent);
            border-radius: 8px;
            background: var(--bh-mint);
        }

        .form-note h4 {
            margin-bottom: 8px;
            color: var(--bh-green);
            font-size: 16px;
            font-weight: 800;
        }

        .form-note p {
            color: rgba(0, 0, 0, 0.70);
            font-size: 15px;
        }

        .alert {
            margin-bottom: 24px;
            padding: 14px 16px;
            border-radius: 8px;
            font-weight: 700;
        }

        .alert-error {
            border: 1px solid rgba(200, 32, 20, 0.22);
            background: rgba(200, 32, 20, 0.08);
            color: var(--bh-red);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        .form-group {
            margin-bottom: 22px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--bh-text);
            font-size: 14px;
            font-weight: 800;
        }

        .form-group label.required::after {
            content: " *";
            color: var(--bh-red);
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            min-height: 52px;
            padding: 13px 16px;
            border: 1px solid rgba(0, 0, 0, 0.18);
            border-radius: 8px;
            background: var(--bh-white);
            color: var(--bh-text);
            font-size: 15px;
            outline: none;
            transition: border-color 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }

        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: rgba(0, 0, 0, 0.42);
        }

        .form-group input:focus,
        .form-group textarea:focus {
            border-color: var(--bh-accent);
            box-shadow: 0 0 0 3px rgba(0, 117, 74, 0.14);
        }

        .form-group input[type="file"] {
            cursor: pointer;
            background: #fafafa;
        }

        .form-group input[type="file"]:hover {
            border-color: var(--bh-accent);
        }

        .form-text {
            display: block;
            margin-top: 7px;
            color: var(--bh-muted);
            font-size: 13px;
        }

        .file-info {
            display: none;
            margin-top: 10px;
            padding: 12px 14px;
            border-left: 3px solid var(--bh-accent);
            border-radius: 8px;
            background: var(--bh-ceramic);
        }

        .file-info.show {
            display: block;
        }

        .file-name {
            color: var(--bh-text);
            font-weight: 800;
        }

        .file-size {
            color: var(--bh-muted);
            font-size: 13px;
        }

        .file-type {
            color: var(--bh-green);
            font-size: 13px;
            font-weight: 800;
        }

        .submit-btn {
            width: 100%;
            min-height: 54px;
            border: 1px solid var(--bh-accent);
            background: var(--bh-accent);
            color: var(--bh-white);
            font-size: 16px;
        }

        .submit-btn:hover {
            background: var(--bh-green);
            border-color: var(--bh-green);
            box-shadow: 0 8px 22px rgba(0, 98, 65, 0.24);
            transform: translateY(-2px);
        }

        .submit-btn:active,
        .back-btn:active {
            transform: scale(0.95);
        }

        @media (max-width: 768px) {
            .header {
                padding: 34px 16px;
            }

            .navigation-buttons {
                justify-content: stretch;
            }

            .back-btn {
                width: 100%;
            }

            .form-section {
                padding: 26px 18px;
            }

            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <h1><i class="fas fa-paper-plane"></i> Ứng tuyển vị trí</h1>
            <p>Điền thông tin của bạn để gửi hồ sơ ứng tuyển</p>
        </div>
    </div>

    <div class="container">
        <div class="navigation-buttons">
            <a href="${pageContext.request.contextPath}/RecruitmentController" class="back-btn">
                <i class="fas fa-arrow-left"></i> Quay lại danh sách việc làm
            </a>
        </div>

        <div class="form-section">
            <%
                Recruitment recruitment = (Recruitment) request.getAttribute("recruitment");
                if (recruitment != null) {
            %>
            <div class="job-info">
                <h3><i class="fas fa-briefcase"></i> <%= recruitment.getTitle() %></h3>
                <p><i class="fas fa-map-marker-alt"></i> <strong>Địa điểm:</strong> <%= recruitment.getLocation() != null ? recruitment.getLocation() : "N/A" %></p>
                <% if (recruitment.getSalary() != null) { %>
                <p><i class="fas fa-dollar-sign"></i> <strong>Mức lương:</strong> <%= String.format("%.0f", recruitment.getSalary()) %> VNĐ</p>
                <% } %>
            </div>
            <% } %>

            <div class="form-note">
                <h4><i class="fas fa-info-circle"></i> Lưu ý quan trọng</h4>
                <p>Vui lòng điền đầy đủ và chính xác thông tin cá nhân. Chúng tôi sẽ liên hệ với bạn trong vòng 3-5 ngày làm việc.</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/RecruitmentController" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="submitApplication">
                <% if (recruitment != null) { %>
                <input type="hidden" name="recruitmentId" value="<%= recruitment.getRecruitmentId() %>">
                <% } %>

                <div class="form-group">
                    <label for="fullName" class="required">Họ và tên</label>
                    <input type="text" id="fullName" name="fullName" required
                           placeholder="Nhập họ và tên"
                           value="<%= request.getParameter("fullName") != null ? request.getParameter("fullName") : "" %>">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="email" class="required">Email</label>
                        <input type="email" id="email" name="email" required
                               placeholder="example@email.com"
                               value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="phone" class="required">Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" required
                               placeholder="0123456789"
                               value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>">
                    </div>
                </div>

                <div class="form-group">
                    <label for="cvFile" class="required">CV/Hồ sơ ứng tuyển</label>
                    <input type="file" id="cvFile" name="cvFile" accept=".pdf,.doc,.docx,.txt" required>
                    <small class="form-text">Chấp nhận file: PDF, DOC, DOCX, TXT (tối đa 5MB)</small>
                    <div class="file-info" id="fileInfo">
                        <div class="file-name" id="fileName"></div>
                        <div class="file-size" id="fileSize"></div>
                        <div class="file-type" id="fileType"></div>
                    </div>
                </div>

                <button type="submit" class="submit-btn">
                    <i class="fas fa-paper-plane"></i> Gửi hồ sơ ứng tuyển
                </button>
            </form>
        </div>
    </div>

    <script>
        document.getElementById('cvFile').addEventListener('change', function(e) {
            const file = e.target.files[0];
            const fileInfo = document.getElementById('fileInfo');
            const fileName = document.getElementById('fileName');
            const fileSize = document.getElementById('fileSize');
            const fileType = document.getElementById('fileType');

            if (file) {
                const allowedTypes = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'text/plain'];
                if (!allowedTypes.includes(file.type)) {
                    alert('Chỉ chấp nhận file PDF, DOC, DOCX, TXT');
                    e.target.value = '';
                    fileInfo.classList.remove('show');
                    return;
                }

                const maxSize = 5 * 1024 * 1024;
                if (file.size > maxSize) {
                    alert('File quá lớn. Vui lòng chọn file nhỏ hơn 5MB');
                    e.target.value = '';
                    fileInfo.classList.remove('show');
                    return;
                }

                fileName.textContent = file.name;
                fileSize.textContent = formatFileSize(file.size);
                fileType.textContent = getFileTypeLabel(file.type);
                fileInfo.classList.add('show');
            } else {
                fileInfo.classList.remove('show');
            }
        });

        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
        }

        function getFileTypeLabel(type) {
            const typeLabels = {
                'application/pdf': 'Tài liệu PDF',
                'application/msword': 'Tài liệu Word',
                'application/vnd.openxmlformats-officedocument.wordprocessingml.document': 'Tài liệu Word',
                'text/plain': 'Tệp văn bản'
            };
            return typeLabels[type] || 'Không xác định';
        }

        document.querySelector('form').addEventListener('submit', function(e) {
            const fullName = document.getElementById('fullName').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const cvFile = document.getElementById('cvFile').files[0];

            if (!fullName) {
                alert('Vui lòng nhập họ và tên');
                e.preventDefault();
                return;
            }

            if (!email) {
                alert('Vui lòng nhập email');
                e.preventDefault();
                return;
            }

            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert('Vui lòng nhập email hợp lệ');
                e.preventDefault();
                return;
            }

            if (!phone) {
                alert('Vui lòng nhập số điện thoại');
                e.preventDefault();
                return;
            }

            const phoneRegex = /^[0-9]{10,11}$/;
            if (!phoneRegex.test(phone.replace(/\s/g, ''))) {
                alert('Vui lòng nhập số điện thoại hợp lệ (10-11 chữ số)');
                e.preventDefault();
                return;
            }

            if (!cvFile) {
                alert('Vui lòng chọn file CV');
                e.preventDefault();
                return;
            }

            if (!confirm('Bạn có chắc chắn muốn gửi hồ sơ ứng tuyển?')) {
                e.preventDefault();
            }
        });

        document.getElementById('phone').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length > 11) {
                value = value.substring(0, 11);
            }
            e.target.value = value;
        });

        document.getElementById('fullName').addEventListener('input', function(e) {
            let value = e.target.value;
            value = value.replace(/\b\w/g, function(char) {
                return char.toUpperCase();
            });
            e.target.value = value;
        });
    </script>
</body>
</html>

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
    <title>Job Application - HRMS</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f8f9fa;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            text-align: center;
        }

        .header h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            font-weight: 700;
        }

        .header p {
            font-size: 1.2rem;
            opacity: 0.9;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .form-section {
            background: white;
            padding: 3rem;
            margin: 2rem 0;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .job-info {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            border-left: 4px solid #667eea;
        }

        .job-info h3 {
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .job-info p {
            color: #666;
            margin-bottom: 0.3rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #2c3e50;
        }

        .form-group label.required:after {
            content: " *";
            color: #e74c3c;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 0.8rem;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 120px;
        }

        .form-group input[type="file"] {
            width: 100%;
            padding: 0.8rem;
border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
            background: white;
            cursor: pointer;
        }

        .form-group input[type="file"]:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-group input[type="file"]:hover {
            border-color: #667eea;
        }

        .form-text {
            color: #666;
            font-size: 0.85rem;
            margin-top: 0.25rem;
            display: block;
        }

        .file-info {
            background: #f8f9fa;
            padding: 0.75rem;
            border-radius: 6px;
            margin-top: 0.5rem;
            border-left: 3px solid #667eea;
            display: none;
        }

        .file-info.show {
            display: block;
        }

        .file-info .file-name {
            font-weight: 600;
            color: #2c3e50;
        }

        .file-info .file-size {
            color: #666;
            font-size: 0.9rem;
        }

        .file-info .file-type {
            color: #667eea;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .submit-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem 2rem;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .back-btn {
            background: #6c757d;
            color: white;
            padding: 0.8rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .back-btn:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }


        .navigation-buttons {
            display: flex;
            justify-content: flex-start;
            align-items: center;
            margin-bottom: 2rem;
            padding: 0 1rem;
        }

        @media (max-width: 768px) {
            .navigation-buttons {
                justify-content: center;
            }
            
            .back-btn {
                width: 100%;
                justify-content: center;
            }
        }

        .alert {
            padding: 1rem;
            margin: 1rem 0;
border-radius: 8px;
            font-weight: 500;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .form-note {
            background: #e3f2fd;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            border-left: 4px solid #2196f3;
        }

        .form-note h4 {
            color: #1976d2;
            margin-bottom: 0.5rem;
        }

        .form-note p {
            color: #1565c0;
            font-size: 0.95rem;
        }

        @media (max-width: 768px) {
            .form-section {
                padding: 2rem 1rem;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .header h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <div class="header-text">
                <h1><i class="fas fa-paper-plane"></i> Job Application</h1>
                <p>Fill in your information to apply for the desired position</p>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="navigation-buttons">
            <a href="${pageContext.request.contextPath}/RecruitmentController" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Job List
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
                <h4><i class="fas fa-info-circle"></i> Important Note</h4>
                <p>Please fill in complete and accurate personal information. We will contact you within 3-5 business days.</p>
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
                    <label for="fullName" class="required">Full Name</label>
                    <input type="text" id="fullName" name="fullName" required 
                           placeholder="Enter your full name"
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
                        <label for="phone" class="required">Phone Number</label>
                        <input type="tel" id="phone" name="phone" required 
                               placeholder="0123456789"
                               value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>">
                    </div>
                </div>

                <div class="form-group">
                    <label for="cvFile" class="required">CV/Resume</label>
                    <input type="file" id="cvFile" name="cvFile" accept=".pdf,.doc,.docx,.txt" required>
                    <small class="form-text">Accepted files: PDF, DOC, DOCX, TXT (Max 5MB)</small>
                    <div class="file-info" id="fileInfo">
                        <div class="file-name" id="fileName"></div>
                        <div class="file-size" id="fileSize"></div>
                        <div class="file-type" id="fileType"></div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="coverLetter">Cover Letter (Optional)</label>
                    <textarea id="coverLetter" name="coverLetter" 
                              placeholder="Briefly describe your experience, skills, and why you are suitable for this position..."><%= request.getParameter("coverLetter") != null ? request.getParameter("coverLetter") : "" %></textarea>
                </div>

                <button type="submit" class="submit-btn">
                    <i class="fas fa-paper-plane"></i> Submit Application
                </button>
            </form>
        </div>
    </div>

    <script>
        // File upload handling
        document.getElementById('cvFile').addEventListener('change', function(e) {
            const file = e.target.files[0];
            const fileInfo = document.getElementById('fileInfo');
const fileName = document.getElementById('fileName');
            const fileSize = document.getElementById('fileSize');
            const fileType = document.getElementById('fileType');

            if (file) {
                // Validate file type
                const allowedTypes = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'text/plain'];
                if (!allowedTypes.includes(file.type)) {
                    alert('Chỉ chấp nhận file PDF, DOC, DOCX, TXT');
                    e.target.value = '';
                    fileInfo.classList.remove('show');
                    return;
                }

                // Validate file size (5MB = 5 * 1024 * 1024 bytes)
                const maxSize = 5 * 1024 * 1024;
                if (file.size > maxSize) {
                    alert('File quá lớn. Vui lòng chọn file nhỏ hơn 5MB');
                    e.target.value = '';
                    fileInfo.classList.remove('show');
                    return;
                }

                // Display file info
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
                'application/pdf': 'PDF Document',
                'application/msword': 'Word Document',
                'application/vnd.openxmlformats-officedocument.wordprocessingml.document': 'Word Document',
                'text/plain': 'Text File'
            };
            return typeLabels[type] || 'Unknown File Type';
        }

        // Form validation
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

            // Simple email validation
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

            // Simple phone validation (Vietnamese phone numbers)
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

            // Confirm submission
            if (!confirm('Bạn có chắc chắn muốn nộp đơn ứng tuyển?')) {
                e.preventDefault();
                return;
            }
        });

        // Auto-format phone number
        document.getElementById('phone').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length > 11) {
                value = value.substring(0, 11);
            }
            e.target.value = value;
        });

        // Auto-capitalize name
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

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrm.model.entity.Employee" %>
<%@ page import="com.hrm.model.entity.Department" %>
<%@ page import="com.hrm.model.entity.SystemUser" %>
<%@ page import="com.hrm.model.entity.Role" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile - HRM System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .profile-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .profile-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            color: #667eea;
            font-weight: bold;
        }
        
        .profile-details h1 {
            margin: 0;
            font-size: 28px;
        }
        
        .profile-details p {
            margin: 5px 0;
            opacity: 0.9;
        }
        
        .profile-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: #4CAF50;
            color: white;
        }
        
        .btn-secondary {
            background: #f44336;
            color: white;
        }
        
        .btn-outline {
            background: transparent;
            color: white;
            border: 2px solid white;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        
        .profile-content {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 30px;
        }
        
        .card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .card h3 {
            margin-top: 0;
            color: #333;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }
        
        .info-group {
            margin-bottom: 20px;
        }
        
        .info-group label {
            display: block;
            font-weight: 600;
            color: #555;
            margin-bottom: 5px;
        }
        
        .info-group input,
        .info-group select,
        .info-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .info-group input:focus,
        .info-group select:focus,
        .info-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 5px rgba(102, 126, 234, 0.3);
        }
        
        .info-group .static-value {
            padding: 10px;
            background: #f5f5f5;
            border-radius: 5px;
            color: #333;
        }
        
        .status-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .status-active {
            background: #d4edda;
            color: #155724;
        }
        
        .form-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 20px;
        }
        
        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
        }
        
        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
        
        @media (max-width: 768px) {
            .profile-content {
                grid-template-columns: 1fr;
            }
            
            .profile-header {
                flex-direction: column;
                text-align: center;
                gap: 20px;
            }
            
            .profile-info {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="profile-container">
        <!-- Header -->
        <div class="profile-header">
            <div class="profile-info">
                <div class="avatar">
                    <%
                        Employee employee = (Employee) request.getAttribute("employee");
                        if (employee != null && employee.getFullName() != null) {
                            String[] names = employee.getFullName().split(" ");
                            String initials = "";
                            for (String name : names) {
                                if (!name.isEmpty()) {
                                    initials += name.charAt(0);
                                }
                            }
                            out.print(initials.toUpperCase());
                        } else {
                            out.print("NA");
                        }
                    %>
                </div>
                <div class="profile-details">
                    <h1><%= employee != null && employee.getFullName() != null ? employee.getFullName() : "User Profile" %></h1>
                    <p><i class="fas fa-briefcase"></i> <%= employee != null && employee.getPosition() != null ? employee.getPosition() : "Position" %></p>
                    <p><i class="fas fa-building"></i> <%= employee != null && employee.getDepartment() != null && employee.getDepartment().getDeptName() != null ? employee.getDepartment().getDeptName() : "Department" %></p>
                </div>
            </div>
            <div class="profile-actions">
                <button class="btn btn-outline" onclick="window.location.href='${pageContext.request.contextPath}/index.jsp'">
                    <i class="fas fa-arrow-left"></i> Back
                </button>
                <button class="btn btn-primary" id="editBtn" onclick="enableEdit()">
                    <i class="fas fa-edit"></i> Edit
                </button>
            </div>
        </div>

        <!-- Messages -->
        <% 
            String message = (String) request.getAttribute("message");
            String error = (String) request.getAttribute("error");
        %>
        <% if (message != null) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i> <%= message %>
            </div>
        <% } %>
        <% if (error != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i> <%= error %>
            </div>
        <% } %>

        <!-- Profile Content -->
        <div class="profile-content">
            <!-- Left Column - Personal Information -->
            <div class="card">
                <h3><i class="fas fa-user"></i> Personal Information</h3>
                <form id="profileForm" action="${pageContext.request.contextPath}/profile" method="post">
                    <input type="hidden" name="action" value="update">
                    
                    <div class="info-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" value="<%= employee != null && employee.getFullName() != null ? employee.getFullName() : "" %>" disabled>
                    </div>

                    <div class="info-group">
                        <label for="email">Email</label>
                        <div class="static-value">
                            <%= employee != null && employee.getEmail() != null ? employee.getEmail() : "" %>
                        </div>
                    </div>

                    <div class="info-group">
                        <label for="phone">Phone</label>
                        <input type="tel" id="phone" name="phone" value="<%= employee != null && employee.getPhone() != null ? employee.getPhone() : "" %>" disabled>
                    </div>

                    <div class="info-group">
                        <label for="gender">Gender</label>
                        <select id="gender" name="gender" disabled>
                            <option value="Male" <%= employee != null && "Male".equals(employee.getGender()) ? "selected" : "" %>>Male</option>
                            <option value="Female" <%= employee != null && "Female".equals(employee.getGender()) ? "selected" : "" %>>Female</option>
                            <option value="Other" <%= employee != null && "Other".equals(employee.getGender()) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>

                    <div class="info-group">
                        <label for="dob">Date of Birth</label>
                        <input type="date" id="dob" name="dob" value="<%= employee != null && employee.getDob() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(java.sql.Date.valueOf(employee.getDob())) : "" %>" disabled>
                    </div>

                    <div class="info-group">
                        <label for="address">Address</label>
                        <textarea id="address" name="address" rows="3" disabled><%= employee != null && employee.getAddress() != null ? employee.getAddress() : "" %></textarea>
                    </div>

                    <div class="form-actions" id="formActions" style="display: none;">
                        <button type="button" class="btn btn-secondary" onclick="cancelEdit()">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Save
                        </button>
                    </div>
                </form>
            </div>

            <!-- Right Column - Work Information -->
            <div>
                <div class="card">
                    <h3><i class="fas fa-briefcase"></i> Work Information</h3>
                    
                    <div class="info-group">
                        <label>Employee ID</label>
                        <div class="static-value">
                            <%= employee != null ? "EMP" + String.format("%05d", employee.getEmployeeId()) : "N/A" %>
                        </div>
                    </div>

                    <div class="info-group">
                        <label>Department</label>
                        <div class="static-value">
                            <%= employee != null && employee.getDepartment() != null && employee.getDepartment().getDeptName() != null ? employee.getDepartment().getDeptName() : "Not assigned" %>
                        </div>
                    </div>

                    <div class="info-group">
                        <label>Position</label>
                        <div class="static-value">
                            <%= employee != null && employee.getPosition() != null ? employee.getPosition() : "Not specified" %>
                        </div>
                    </div>

                    <div class="info-group">
                        <label>Employment Period</label>
                        <div class="static-value">
                            <%= employee != null && employee.getEmploymentPeriod() != null ? employee.getEmploymentPeriod() : "Not specified" %>
                        </div>
                    </div>

                    <div class="info-group">
                        <label>Status</label>
                        <div class="static-value">
                            <% if (employee != null && employee.getStatus() != null) { %>
                                <span class="status-badge status-active"><%= employee.getStatus() %></span>
                            <% } else { %>
                                <span class="status-badge">Unknown</span>
                            <% } %>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <h3><i class="fas fa-user-shield"></i> Account Information</h3>
                    
                    <div class="info-group">
                        <label>Username</label>
                        <div class="static-value">
                            <%= employee != null && employee.getSystemUser() != null && employee.getSystemUser().getUsername() != null ? employee.getSystemUser().getUsername() : "Not assigned" %>
                        </div>
                    </div>

                    <div class="info-group">
                        <label>Role</label>
                        <div class="static-value">
                            <%= employee != null && employee.getSystemUser() != null && employee.getSystemUser().getRole() != null && employee.getSystemUser().getRole().getRoleName() != null ? employee.getSystemUser().getRole().getRoleName() : "Not assigned" %>
                        </div>
                    </div>

                    <div class="info-group">
                        <label>Last Login</label>
                        <div class="static-value">
                            <%= employee != null && employee.getSystemUser() != null && employee.getSystemUser().getLastLogin() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(employee.getSystemUser().getLastLogin()) : "Never" %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function enableEdit() {
            // Enable all form fields
            document.getElementById('fullName').disabled = false;
            document.getElementById('phone').disabled = false;
            document.getElementById('gender').disabled = false;
            document.getElementById('dob').disabled = false;
            document.getElementById('address').disabled = false;
            
            // Show form actions
            document.getElementById('formActions').style.display = 'flex';
            
            // Hide edit button
            document.getElementById('editBtn').style.display = 'none';
        }

        function cancelEdit() {
            // Disable all form fields
            document.getElementById('fullName').disabled = true;
            document.getElementById('phone').disabled = true;
            document.getElementById('gender').disabled = true;
            document.getElementById('dob').disabled = true;
            document.getElementById('address').disabled = true;
            
            // Hide form actions
            document.getElementById('formActions').style.display = 'none';
            
            // Show edit button
            document.getElementById('editBtn').style.display = 'inline-flex';
            
            // Reset form to original values
            document.getElementById('profileForm').reset();
        }

        // Form validation
        document.getElementById('profileForm').addEventListener('submit', function(e) {
            const fullName = document.getElementById('fullName').value.trim();
            const phone = document.getElementById('phone').value.trim();
            
            if (fullName === '') {
                alert('Full name is required');
                e.preventDefault();
                return;
            }
            
            if (phone !== '' && !/^[\d\s\-\+\(\)]+$/.test(phone)) {
                alert('Please enter a valid phone number');
                e.preventDefault();
                return;
            }
        });
    </script>
</body>
</html>

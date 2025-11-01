<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
    <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - Human Resources Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #1e40af;
            --accent-color: #3b82f6;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --dark-color: #1f2937;
            --light-color: #f8fafc;
            --text-color: #374151;
            --text-muted: #6b7280;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            line-height: 1.6;
            color: var(--text-color);
            background-color: var(--light-color);
        }
        
        /* Header */
        .header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 1rem 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .navbar-brand {
            font-size: 1.5rem;
            font-weight: 700;
            color: white !important;
        }
        
        .nav-link {
            color: rgba(255, 255, 255, 0.9) !important;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .nav-link:hover {
            color: white !important;
            transform: translateY(-1px);
        }
        
        /* Profile Dropdown Styles */
        .profile-dropdown {
            position: relative;
            display: inline-block;
        }
        
        .profile-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid rgba(255, 255, 255, 0.2);
        }
        
        .profile-avatar:hover {
            transform: scale(1.1);
box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
        }
        
        .profile-dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            min-width: 200px;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(0, 0, 0, 0.1);
        }
        
        .profile-dropdown-menu.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }
        
        .profile-dropdown-item {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            color: #374151;
            text-decoration: none;
            transition: all 0.2s ease;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .profile-dropdown-item:last-child {
            border-bottom: none;
        }
        
        .profile-dropdown-item:hover {
            background: #f8fafc;
            color: #1f2937;
            text-decoration: none;
        }
        
        .profile-dropdown-item i {
            margin-right: 10px;
            width: 16px;
            text-align: center;
        }
        
        .profile-dropdown-item.logout {
            color: #dc2626;
        }
        
        .profile-dropdown-item.logout:hover {
            background: #fef2f2;
            color: #b91c1c;
        }
        
        /* Profile Page Styles */
        .profile-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }
        
        .profile-header {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border: 1px solid #e5e7eb;
        }
        
        .profile-avatar-large {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
            font-weight: 700;
            margin: 0 auto 1.5rem;
            border: 4px solid white;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .profile-name {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark-color);
            text-align: center;
            margin-bottom: 0.5rem;
        }
        
        .profile-title {
            font-size: 1.1rem;
            color: var(--text-muted);
            text-align: center;
            margin-bottom: 1rem;
        }
.profile-stats {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin-top: 1.5rem;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-number {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            display: block;
        }
        
        .stat-label {
            font-size: 0.9rem;
            color: var(--text-muted);
        }
        
        .profile-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
        }
        
        .profile-card {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border: 1px solid #e5e7eb;
        }
        
        .card-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
        }
        
        .card-title i {
            margin-right: 0.5rem;
            color: var(--primary-color);
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 0.5rem;
            display: block;
        }
        
        .form-control {
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            outline: none;
        }
        
        .form-control:disabled {
            background-color: #f8f9fa;
            color: #6c757d;
            cursor: not-allowed;
            opacity: 0.7;
        }
        
        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .btn-primary {
            background: var(--primary-color);
            color: white;
        }
        
        .btn-primary:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(37, 99, 235, 0.3);
        }
        
        .btn-outline-primary {
            background: transparent;
            color: var(--primary-color);
            border: 2px solid var(--primary-color);
        }
        
        .btn-outline-primary:hover {
background: var(--primary-color);
            color: white;
        }
        
        .btn-danger {
            background: var(--danger-color);
            color: white;
        }
        
        .btn-danger:hover {
            background: #dc2626;
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(239, 68, 68, 0.3);
        }
        
        .info-item {
            display: flex;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            margin-right: 1rem;
        }
        
        .info-content {
            flex: 1;
        }
        
        .info-label {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 0.25rem;
        }
        
        .info-value {
            color: var(--text-muted);
        }
        
        .activity-item {
            display: flex;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .activity-item:last-child {
            border-bottom: none;
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--success-color);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            margin-right: 1rem;
        }
        
        .activity-content {
            flex: 1;
        }
        
        .activity-title {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 0.25rem;
        }
        
        .activity-time {
            color: var(--text-muted);
            font-size: 0.9rem;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .profile-content {
                grid-template-columns: 1fr;
            }
            
            .profile-stats {
                flex-direction: column;
                gap: 1rem;
            }
            
            .profile-avatar-large {
                width: 100px;
                height: 100px;
                font-size: 2.5rem;
            }
            
            .profile-name {
                font-size: 1.5rem;
            }
        }
    </style>
    </head>
    <body>
    <!-- Header -->
    <header class="header">
        <nav class="navbar navbar-expand-lg" aria-label="Main navigation">
            <div class="container">
<a class="navbar-brand" href="${pageContext.request.contextPath}/homepage">
                    <i class="fas fa-users-cog me-2"></i>Human Resources Management
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/homepage">
                                <i class="fas fa-home me-1"></i>Home
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/Admin/AdminHome.jsp">
                                <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <div class="profile-dropdown">
                                <div class="profile-avatar" onclick="toggleProfileDropdown()" title="Profile Menu">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div class="profile-dropdown-menu" id="profileDropdown">
                                    <a href="${pageContext.request.contextPath}/Views/Profilepage.jsp" class="profile-dropdown-item">
                                        <i class="fas fa-user"></i>
                                        Profile
                                    </a>
                                    <a href="${pageContext.request.contextPath}/Admin/AdminHome.jsp" class="profile-dropdown-item">
                                        <i class="fas fa-tachometer-alt"></i>
                                        Dashboard
                                    </a>
                                    <a href="${pageContext.request.contextPath}/Views/ChangePassword.jsp" class="profile-dropdown-item">
                                        <i class="fas fa-key"></i>
                                        Change Password
                                    </a>
                                    <a href="#" class="profile-dropdown-item">
                                        <i class="fas fa-cog"></i>
                                        Settings
                                    </a>
                                    <a href="javascript:void(0)" onclick="handleLogout()" class="profile-dropdown-item logout">
                                        <i class="fas fa-sign-out-alt"></i>
                                        Logout
                                    </a>
                                </div>
                            </div>
</li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <!-- Success/Error Messages -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert" style="margin: 1rem; border-radius: 10px;">
            <i class="fas fa-check-circle me-2"></i>${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert" style="margin: 1rem; border-radius: 10px;">
            <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Profile Content -->
    <div class="profile-container">
        <!-- Profile Header -->
        <div class="profile-header">
            <div class="profile-avatar-large">
                <i class="fas fa-user"></i>
            </div>
            <h1 class="profile-name">${userProfile.fullName != null ? userProfile.fullName : 'User'}</h1>
            <p class="profile-title">${userProfile.role != null ? userProfile.role : 'Employee'}</p>
            <div class="profile-stats">
                <div class="stat-item">
                    <span class="stat-number">${userStats.daysSinceJoin != null ? userStats.daysSinceJoin : '0'}</span>
                    <span class="stat-label">Days Active</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">${userStats.loginCount != null ? userStats.loginCount : '0'}</span>
                    <span class="stat-label">Login Count</span>
                </div>
                
            </div>
        </div>

        <!-- Profile Content Grid -->
        <div class="profile-content">
            <!-- Personal Information -->
            <div class="profile-card">
                <h2 class="card-title">
                    <i class="fas fa-user"></i>
                    Personal Information
                </h2>
                
                <div class="info-item">
                    <div class="info-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <div class="info-content">
                        <div class="info-label">Email Address</div>
                        <div class="info-value">${userProfile.email != null ? userProfile.email : 'Not provided'}</div>
                    </div>
                </div>
                
                <div class="info-item">
                    <div class="info-icon">
                        <i class="fas fa-phone"></i>
                    </div>
                    <div class="info-content">
                        <div class="info-label">Phone Number</div>
<div class="info-value">${userProfile.phone != null ? userProfile.phone : 'Not provided'}</div>
                    </div>
                </div>
                
                <div class="info-item">
                    <div class="info-icon">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="info-content">
                        <div class="info-label">Username</div>
                        <div class="info-value">${userProfile.username != null ? userProfile.username : 'Not provided'}</div>
                    </div>
                </div>
                
                <div class="info-item">
                    <div class="info-icon">
                        <i class="fas fa-briefcase"></i>
                    </div>
                    <div class="info-content">
                        <div class="info-label">Department</div>
                        <div class="info-value">${userProfile.department != null ? userProfile.department : 'Not assigned'}</div>
                    </div>
                </div>
                
                <div class="info-item">
                    <div class="info-icon">
                        <i class="fas fa-calendar"></i>
                    </div>
                    <div class="info-content">
                        <div class="info-label">Join Date</div>
                        <div class="info-value">${userProfile.joinDate != null ? userProfile.joinDate : 'Not available'}</div>
                    </div>
                </div>
                
                <div class="info-item">
                    <div class="info-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="info-content">
                        <div class="info-label">Last Login</div>
                        <div class="info-value">${userProfile.lastLogin != null ? userProfile.lastLogin : 'Not available'}</div>
                    </div>
                </div>
            </div>

            <!-- Account Settings -->
            <div class="profile-card">
                <h2 class="card-title">
                    <i class="fas fa-cog"></i>
                    Account Settings
                </h2>
                
                <form action="${pageContext.request.contextPath}/profilepage" method="POST">
                    <input type="hidden" name="action" value="update">
                    
                    <div class="form-group">
                        <label class="form-label" for="fullName">Full Name</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" value="${userProfile.fullName != null ? userProfile.fullName : ''}" disabled required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="email">Email Address</label>
<input type="email" class="form-control" id="email" name="email" value="${userProfile.email != null ? userProfile.email : ''}" disabled required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="phone">Phone Number</label>
                        <input type="tel" class="form-control" id="phone" name="phone" value="${userProfile.phone != null ? userProfile.phone : ''}" disabled>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="department">Department</label>
                        <select class="form-control" id="department" name="department" disabled>
                            <option value="Information Technology" ${userProfile.department == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                            <option value="Human Resources" ${userProfile.department == 'Human Resources' ? 'selected' : ''}>Human Resources</option>
                            <option value="Finance" ${userProfile.department == 'Finance' ? 'selected' : ''}>Finance</option>
                            <option value="Marketing" ${userProfile.department == 'Marketing' ? 'selected' : ''}>Marketing</option>
                            <option value="Operations" ${userProfile.department == 'Operations' ? 'selected' : ''}>Operations</option>
                        </select>
                        <small class="text-muted">Department cannot be changed</small>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="bio">Bio</label>
                        <textarea class="form-control" id="bio" name="bio" rows="3" placeholder="Tell us about yourself..." disabled>Experienced professional with expertise in enterprise solutions and team management.</textarea>
                    </div>
                    
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary" disabled>
                            <i class="fas fa-save me-1"></i>Save Changes
                        </button>
                        <button type="button" class="btn btn-outline-primary" onclick="toggleEditMode()">
                            <i class="fas fa-edit me-1"></i>Edit Profile
                        </button>
                    </div>
                </form>
            </div>

            <!-- Security Settings -->
            <div class="profile-card">
                <h2 class="card-title">
                    <i class="fas fa-shield-alt"></i>
                    Security Settings
                </h2>
                
                <div class="info-item">
                    <div class="info-icon">
                        <i class="fas fa-key"></i>
                    </div>
<div class="info-content">
                        <div class="info-label">Password</div>
                        <div class="info-value">Last changed 30 days ago</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/Views/ChangePassword.jsp" class="btn btn-outline-primary btn-sm">
                        Change
                    </a>
                </div>
                
                
                <div class="info-item">
                    <div class="info-icon">
                        <i class="fas fa-history"></i>
                    </div>
                    <div class="info-content">
                        <div class="info-label">Login History</div>
                        <div class="info-value">View recent activity</div>
                    </div>
                    <button class="btn btn-outline-primary btn-sm">
                        View
                    </button>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="profile-card">
                <h2 class="card-title">
                    <i class="fas fa-clock"></i>
                    Recent Activity
                </h2>
                
                <c:choose>
                    <c:when test="${not empty userActivities}">
                        <c:forEach var="activity" items="${userActivities}">
                            <div class="activity-item">
                                <div class="activity-icon">
                                    <c:choose>
                                        <c:when test="${activity.activity == 'LOGIN'}">
                                            <i class="fas fa-sign-in-alt"></i>
                                        </c:when>
                                        <c:when test="${activity.activity == 'PROFILE_UPDATE'}">
                                            <i class="fas fa-edit"></i>
                                        </c:when>
                                        <c:when test="${activity.activity == 'PASSWORD_CHANGE'}">
                                            <i class="fas fa-key"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-cog"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="activity-content">
                                    <div class="activity-title">${activity.description}</div>
                                    <div class="activity-time">${activity.activityDate}</div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="activity-item">
<div class="activity-icon">
                                <i class="fas fa-info-circle"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">No recent activity</div>
                                <div class="activity-time">Start using the system to see your activity here</div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Profile dropdown functionality
        function toggleProfileDropdown() {
            const dropdown = document.getElementById('profileDropdown');
            if (dropdown) {
                dropdown.classList.toggle('show');
            }
        }
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function(event) {
            const dropdown = document.getElementById('profileDropdown');
            const avatar = document.querySelector('.profile-avatar');
            
            if (dropdown && avatar && !avatar.contains(event.target) && !dropdown.contains(event.target)) {
                dropdown.classList.remove('show');
            }
        });
        
        // Handle logout
        function handleLogout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '${pageContext.request.contextPath}/LogoutController';
            }
        }
        
        // Form submission
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            if (form) {
                form.addEventListener('submit', function(e) {
                    // Let the form submit normally to the server
                    // The server will handle validation and response
                });
            }
        });
        
        // Toggle edit mode
        function toggleEditMode() {
            const form = document.querySelector('form');
            const inputs = form.querySelectorAll('input, select, textarea');
            const editBtn = document.querySelector('button[onclick="toggleEditMode()"]');
            const saveBtn = document.querySelector('button[type="submit"]');
            
            // Check if we're currently in edit mode
            const isEditMode = !inputs[0].disabled; // Check first input (fullName)
            
            if (isEditMode) {
                // Exit edit mode - disable all inputs except department
                inputs.forEach(input => {
                    if (input.name !== 'department') {
                        input.disabled = true;
                    }
                });
                saveBtn.disabled = true;
editBtn.innerHTML = '<i class="fas fa-edit me-1"></i>Edit Profile';
                editBtn.classList.remove('btn-outline-danger');
                editBtn.classList.add('btn-outline-primary');
            } else {
                // Enter edit mode - enable inputs except department
                inputs.forEach(input => {
                    if (input.name !== 'department') {
                        input.disabled = false;
                    }
                });
                saveBtn.disabled = false;
                editBtn.innerHTML = '<i class="fas fa-times me-1"></i>Cancel Edit';
                editBtn.classList.remove('btn-outline-primary');
                editBtn.classList.add('btn-outline-danger');
            }
        }
        
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                if (alert.classList.contains('show')) {
                    alert.classList.remove('show');
                    setTimeout(() => alert.remove(), 300);
                }
            });
        }, 5000);
    </script>
    </body>
</html>

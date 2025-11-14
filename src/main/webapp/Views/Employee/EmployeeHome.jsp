<%-- 
    Document   : EmployeeHome
    Created on : Oct 20, 2025, 2:04:29 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Employee Dashboard - HRMS</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hr-dashboard.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Employee Dashboard Layout */
            .employee-dashboard-container {
                min-height: 100vh;
                background-color: #f8f9fa;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .employee-header {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                color: white;
                padding: 1rem 0;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .header-content {
                max-width: 1400px;
                margin: 0 auto;
                padding: 0 2rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .logo-section {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .logo-section i {
                font-size: 2rem;
            }

            .logo-section h1 {
                font-size: 1.8rem;
                font-weight: 600;
                margin: 0;
            }

            .header-actions {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .user-profile {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 8px 12px;
                background: rgba(255,255,255,0.2);
                border-radius: 20px;
                cursor: pointer;
            }

            .profile-img {
                width: 24px;
                height: 24px;
                border-radius: 50%;
            }

            .nav-btn {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 8px 16px;
                background: rgba(255,255,255,0.2);
                border: 1px solid rgba(255,255,255,0.3);
                border-radius: 20px;
                color: white;
                text-decoration: none;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .nav-btn:hover {
                background: rgba(255,255,255,0.3);
                transform: translateY(-1px);
            }

            .employee-main-content {
                max-width: 1400px;
                margin: 0 auto;
                padding: 2rem;
            }

            .welcome-card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                padding: 2rem;
                margin-bottom: 2rem;
                text-align: center;
            }

            .welcome-title {
                color: #2c3e50;
                font-size: 2rem;
                font-weight: 600;
                margin-bottom: 1rem;
            }

            .welcome-subtitle {
                color: #7f8c8d;
                font-size: 1.1rem;
                margin-bottom: 2rem;
            }

            .employee-features {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 2rem;
            }

            .feature-card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                padding: 2rem;
                text-align: center;
                transition: transform 0.3s ease;
            }

            .feature-card:hover {
                transform: translateY(-5px);
            }

            .feature-icon {
                font-size: 3rem;
                color: #28a745;
                margin-bottom: 1rem;
            }

            .feature-title {
                color: #2c3e50;
                font-size: 1.3rem;
                font-weight: 600;
                margin-bottom: 1rem;
            }

            .feature-description {
                color: #7f8c8d;
                font-size: 1rem;
                line-height: 1.6;
            }

            .logout-btn {
                background: rgba(220, 53, 69, 0.2);
                border: 1px solid rgba(220, 53, 69, 0.3);
                color: white;
            }

            .logout-btn:hover {
                background: rgba(220, 53, 69, 0.3);
            }
        </style>
    </head>
    <body>
        <!-- Employee Dashboard Container -->
        <div class="employee-dashboard-container">
            <!-- Header -->
            <header class="employee-header">
                <div class="header-content">
                    <div class="logo-section">
                        <i class="fas fa-user-tie"></i>
                        <h1>Employee Dashboard</h1>
                    </div>
                    <div class="header-actions">
                        <div class="user-profile">
                            <img src="${pageContext.request.contextPath}/image/logo/1.png" alt="Profile" class="profile-img">
                            <span>Employee</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <a href="Views/Homepage.jsp" class="nav-btn">
                            <i class="fas fa-home"></i>
                            Homepage
                        </a>
                        <a href="${pageContext.request.contextPath}/logout" class="nav-btn logout-btn">
                            <i class="fas fa-sign-out-alt"></i>
                            Logout
                        </a>
                    </div>
                </div>
            </header>

            <!-- Main Content -->
            <main class="employee-main-content">
                <div class="welcome-card">
                    <h2 class="welcome-title">Welcome to Employee Dashboard!</h2>
                    <p class="welcome-subtitle">Access your personal information and company resources</p>
                </div>

                <div class="employee-features">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-user"></i>
                        </div>
                        <h3 class="feature-title">Profile Management</h3>
                        <p class="feature-description">
                            View and update your personal information, contact details, and professional profile.
                        </p>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <h3 class="feature-title">Leave Management</h3>
                        <p class="feature-description">
                            Request time off, view your leave balance, and track your attendance records.
                        </p>
                    </div>

                    <div class="feature-card" onclick="window.location.href = '/viewTask'">
                        <div class="feature-icon">
                            <i class="fas fa-tasks"></i>
                        </div>
                        <h3 class="feature-title">View Task</h3>
                        <p class="feature-description">
                            View assigned tasks, update progress, and communicate with your team.
                        </p>
                    </div>F
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-file-alt"></i>
                        </div>
                        <h3 class="feature-title">Documents</h3>
                        <p class="feature-description">
                            Access company policies, forms, and important documents relevant to your role.
                        </p>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>

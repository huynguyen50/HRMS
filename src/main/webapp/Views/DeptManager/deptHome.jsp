<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check authentication - only roleID 3 can access
    com.hrm.model.entity.SystemUser currentUser = (com.hrm.model.entity.SystemUser) session.getAttribute("systemUser");
    if (currentUser == null || currentUser.getRoleId() != 3) {
        response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
        return;
    }
    
    // Get employee name if available
    String userName = currentUser.getUsername();
    if (currentUser.getEmployeeId() != null) {
        try {
            com.hrm.dao.EmployeeDAO employeeDAO = new com.hrm.dao.EmployeeDAO();
            com.hrm.model.entity.Employee employee = employeeDAO.getById(currentUser.getEmployeeId());
            if (employee != null && employee.getFullName() != null) {
                userName = employee.getFullName();
            }
        } catch (Exception e) {
            // Use username if employee not found
        }
    }
    request.setAttribute("userName", userName);
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Department Manager Dashboard</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/Admin_home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/user-menu.css">
    </head>
    <body>
        <div class="dashboard-container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <div class="sidebar-header">
                    <div class="logo">
                        <img src="https://cdn-icons-png.flaticon.com/512/847/847969.png" alt="Logo" width="32">
                        <span>Dept Manager</span>
                    </div>
                </div>
                
                <div class="sidebar-nav">
                    <a href="${pageContext.request.contextPath}/dept?action=dashboard"
                       class="nav-item ${activePage == 'dashboard' ? 'active' : ''}">🏠 Dashboard</a>

                    <a href="${pageContext.request.contextPath}/dept?action=taskManager"
                       class="nav-item ${activePage == 'taskManager' ? 'active' : ''}">📋 Task Manager</a>
                </div>
            </aside>

            <!-- Main Content -->
            <main class="main-content">
                <!-- Top Bar -->
                <header class="top-bar">
                    <div class="search-box">
                        <span class="search-icon">🔍</span>
                        <input type="text" placeholder="Search...">
                    </div>
                    <div class="top-bar-actions">
                        <div class="user-menu" onclick="toggleUserMenu()">
                            <div class="user-info">
                                <img src="https://i.pravatar.cc/32" alt="User">
                                <span>Welcome, ${userName}</span>
                                <span class="dropdown-arrow">▼</span>
                            </div>
                            <div class="dropdown-menu" id="userDropdown">
                                <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">
                                    <span class="icon">🚪</span> Logout
                                </a>
                            </div>
                        </div>                    
                   
                        <script>
                            function toggleUserMenu() {
                                const userMenu = document.querySelector('.user-menu');
                                userMenu.classList.toggle('active');
                            }

                            document.addEventListener('click', function (event) {
                                if (!event.target.closest('.user-menu')) {
                                    const userMenu = document.querySelector('.user-menu');
                                    if (userMenu.classList.contains('active')) {
                                        userMenu.classList.remove('active');
                                    }
                                }
                            });
                        </script>
                    </div>
                </header>

                <!-- Dashboard Content -->
                <section class="dashboard-content">
                    <h1 class="page-title">Department: ${departmentName != null ? departmentName : 'Department'}</h1>

                    <!-- Stats Grid -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-icon">👥</div>
                            <div class="stat-info">
                                <h3>Total Employees</h3>
                                <p class="stat-value">${totalEmployees != null ? totalEmployees : 0}</p>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon">✅</div>
                            <div class="stat-info">
                                <h3>Active Employees</h3>
                                <p class="stat-value">${activeEmployees != null ? activeEmployees : 0}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Task Manager Section -->
                    <div class="activity-section">
                        <div class="activity-card">
                            <h3>Task Manager</h3>
                            <div class="referrals-list">
                                <a href="${pageContext.request.contextPath}/taskManager" class="referral-item">
                                    <span class="referral-name">📋 Manage Tasks</span>
                                    <span class="referral-count">→</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </section>
            </main>
        </div>
    </body>
</html>

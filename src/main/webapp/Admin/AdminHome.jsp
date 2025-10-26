<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>
        <link rel="stylesheet" href="Admin/css/Admin_home.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>
    <body>
        <div class="dashboard-container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <div class="sidebar-header">
                    <div class="logo">
                        <img src="https://cdn-icons-png.flaticon.com/512/847/847969.png" alt="Logo" width="32">
                        <span>Admin Panel</span>
                    </div>
                </div>

                <div class="sidebar-nav">
                    <a href="${pageContext.request.contextPath}/admin?action=dashboard"
                       class="nav-item ${activePage == 'dashboard' ? 'active' : ''}">🏠 Dashboard</a>

                    <a href="${pageContext.request.contextPath}/admin?action=employees"
                       class="nav-item ${activePage == 'employees' ? 'active' : ''}">👥 Employees</a>

                    <a href="${pageContext.request.contextPath}/admin?action=departments"
                       class="nav-item ${activePage == 'departments' ? 'active' : ''}">🏢 Departments</a>

                    <a href="${pageContext.request.contextPath}/admin?action=users"
                       class="nav-item ${activePage == 'users' ? 'active' : ''}">👤 Users</a>

                    <a href="${pageContext.request.contextPath}/admin?action=roles"
                       class="nav-item ${activePage == 'roles' ? 'active' : ''}">🔐 Roles</a>

                    <a href="${pageContext.request.contextPath}/admin?action=audit-log"
                       class="nav-item ${activePage == 'audit-log' ? 'active' : ''}">📜 Audit Log</a>

                    <a href="${pageContext.request.contextPath}/admin?action=profile"
                       class="nav-item ${activePage == 'profile' ? 'active' : ''}">⚙️ Profile</a>
                </div>
            </aside>

            <!-- Main Content -->
            <main class="main-content">
                <!-- Top Bar -->
                <header class="top-bar">
                    <div class="search-box">
                        <span class="search-icon"> </span>
                        <input type="text" placeholder="Search...">
                    </div>
                    <div class="top-bar-actions">
                        <select class="env-selector">
                            <option>Production</option>
                            <option>Staging</option>
                        </select>
                        <select class="time-selector">
                            <option>Today</option>
                            <option>This Week</option>
                            <option>This Month</option>
                        </select>
                        <button class="notification-btn" >
                            🔔
                            <span class="badge">3</span>
                        </button>
                        <div class="user-menu">
                            <img src="https://i.pravatar.cc/32" alt="User">
                            <span>Admin</span>
                        </div>
                    </div>
                </header>

                <!-- Dashboard Content -->
                <section class="dashboard-content">
                    <h1 class="page-title">Dashboard Overview</h1>

                    <!-- Stats Grid -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-icon">👥</div>
                            <div class="stat-info">
                                <h3>Total Employees</h3>
                                <p class="stat-value">${totalEmployees}</p>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon">✅</div>
                            <div class="stat-info">
                                <h3>Active Employees</h3>
                                <p class="stat-value">${activeEmployees}</p>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon">🏢</div>
                            <div class="stat-info">
                                <h3>Departments</h3>
                                <p class="stat-value">${totalDepartments}</p>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon">👤</div>
                            <div class="stat-info">
                                <h3>System Users</h3>
                                <p class="stat-value">${totalUser}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Charts Section -->
                    <div class="charts-section">
                        <div class="chart-card">
                            <div class="chart-header">
                                <h3>Employee Distribution</h3>
                                <div class="chart-info">By Department</div>
                            </div>
                            <canvas id="employeeChart" height="180"></canvas>
                        </div>

                        <div class="chart-card">
                            <div class="chart-header">
                                <h3>Employee Status</h3>
                                <div class="chart-info">Active vs Inactive</div>
                            </div>
                            <canvas id="statusChart" height="180"></canvas>
                        </div>

                        <div class="chart-card">
                            <div class="chart-header">
                                <h3>System Activity</h3>
                                <div class="chart-info">Last 7 days</div>
                            </div>
                            <canvas id="activityChart" height="200"></canvas>
                        </div>
                    </div>

                    <!-- Activity Section -->
                    <div class="activity-section">
                        <div class="activity-card">
                            <h3>Recent Activity</h3>
                            <div class="activity-list">
                                <c:choose>
                                    <c:when test="${not empty recentActivity}">
                                        <c:forEach var="activity" items="${recentActivity}">
                                            <div class="activity-item">
                                                <span class="activity-time"><fmt:formatDate value="${activity.Timestamp}" pattern="MMM dd, HH:mm"/></span>
                                                <span class="activity-text">${activity.Action} - ${activity.ObjectType}: ${activity.NewValue}</span>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="activity-item">
                                            <span class="activity-text">No recent activity</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="referrals-card">
                            <h3>Quick Actions</h3>
                            <div class="referrals-list">
                                <a href="${pageContext.request.contextPath}/admin?action=employees" class="referral-item">
                                    <span class="referral-name">Manage Employees</span>
                                    <span class="referral-count">→</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin?action=departments" class="referral-item">
                                    <span class="referral-name">Manage Departments</span>
                                    <span class="referral-count">→</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin?action=users" class="referral-item">
                                    <span class="referral-name">Manage Users</span>
                                    <span class="referral-count">→</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin?action=audit-log" class="referral-item">
                                    <span class="referral-name">View Audit Log</span>
                                    <span class="referral-count">→</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </section>
            </main>
        </div>

        <script>
            window.dashboardData = {
                employeeDistribution: <c:out value="${employeeDistributionJson}" escapeXml="false" />,
                employeeStatus: <c:out value="${employeeStatusJson}" escapeXml="false" />,
                activityData: <c:out value="${activityDataJson}" escapeXml="false" />
            };
        </script>


        <script src="${pageContext.request.contextPath}/Admin/dashboard.js"></script>

    </body>
</html>

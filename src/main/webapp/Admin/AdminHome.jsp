<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>
        <link rel="stylesheet" href="Admin/css/Admin_home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/user-menu.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/chart-enhancements.css">
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

                          <!-- Employees link removed -->

                    <a href="${pageContext.request.contextPath}/admin?action=departments"
                       class="nav-item ${activePage == 'departments' ? 'active' : ''}">🏢 Departments</a>

                    <a href="${pageContext.request.contextPath}/admin/users"
                       class="nav-item ${activePage == 'users' ? 'active' : ''}">👤 Users</a>

                    <a href="${pageContext.request.contextPath}/admin/role/list"
                       class="nav-item ${activePage == 'roles' ? 'active' : ''}">🔐 Roles</a>

                    <a href="${pageContext.request.contextPath}/admin?action=role-permissions"
                       class="nav-item ${activePage == 'role-permissions' ? 'active' : ''}">🛡️ Role Permissions</a>

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
                      
                        <div class="user-menu" onclick="toggleUserMenu()">
                            <div class="user-info">
                                <img src="https://i.pravatar.cc/32" alt="User">
                                <span>Admin</span>
                                <span class="dropdown-arrow">▼</span>
                            </div>
                            <div class="dropdown-menu" id="userDropdown">
                                <a href="${pageContext.request.contextPath}/admin?action=profile" class="dropdown-item">
                                    <span class="icon">👤</span> Profile
                                </a>
                                <a href="${pageContext.request.contextPath}/homepage" class="dropdown-item">
                                    <span class="icon">🏠</span> Homepage
                                </a>
                                <div class="dropdown-divider"></div>
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
                                <div class="chart-controls">
                                    <select id="activityChartRange" class="chart-range-selector">
                                        <option value="7">Last 7 days</option>
                                        <option value="14">Last 14 days</option>
                                        <option value="30">Last 30 days</option>
                                    </select>
                                </div>
                            </div>
                            <div class="chart-container">
                                <canvas id="activityChart" height="200"></canvas>
                            </div>
                            <div class="chart-summary">
                                <div class="summary-item">
                                    <span class="summary-label">Total Activities</span>
                                    <span id="totalActivities" class="summary-value">0</span>
                                </div>
                                <div class="summary-item">
                                    <span class="summary-label">Average Per Day</span>
                                    <span id="avgActivities" class="summary-value">0</span>
                                </div>
                                <div class="summary-item">
                                    <span class="summary-label">Peak Day</span>
                                    <span id="peakDay" class="summary-value">-</span>
                                </div>
                            </div>
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
                                                            <span class="activity-time">${activity.timestamp.month} ${activity.timestamp.dayOfMonth}, ${String.format('%02d', activity.timestamp.hour)}:${String.format('%02d', activity.timestamp.minute)}</span>
                                                        <span class="activity-text">${activity.action} - ${activity.objectType}: ${activity.newValue}</span>
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
                                <!-- Manage Employees quick action removed -->
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


        <script src="${pageContext.request.contextPath}/Admin/js/dashboard.js"></script>

    </body>
</html>

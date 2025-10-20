
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Employees - HRMS</title>
        <link rel="stylesheet" href="Admin/Admin_home.css">
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
                    <a href="${pageContext.request.contextPath}/admin?action=dashboard" class="nav-item active">🏠 Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin?action=employees" class="nav-item">👥 Employees</a>
                    <a href="${pageContext.request.contextPath}/admin?action=departments" class="nav-item">🏢 Departments</a>
                    <a href="${pageContext.request.contextPath}/admin?action=profile" class="nav-item">👤 Profile</a>
                </div>


            </aside>

            <div class="main-content">
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
                <div class="dashboard-content">
                    <h1 class="page-title">Employee Management</h1>
                    <div class="table-section">
                        <table class="employee-table">
                            <thead>
                                <tr>
                                    <th>ID</th><th>Name</th><th>Department</th><th>Role</th><th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>EMP001</td>
                                    <td>Nguyễn Văn A</td>
                                    <td>IT</td>
                                    <td>Developer</td>
                                    <td>
                                        <button class="btn-edit">Edit</button>
                                        <button class="btn-delete">Delete</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
    <script src="dashboard.js"></script>
</body>
<script>
    const currentPage = window.location.pathname.split("/").pop();
    document.querySelectorAll('.nav-item').forEach(link => {
        if (link.getAttribute('href') === currentPage) {
            link.classList.add('active');
        }
    });
</script>

</html>

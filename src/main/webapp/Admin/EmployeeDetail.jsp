<%@ page import="com.hrm.model.entity.Employee" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Employee Details - HRMS</title>
        <link rel="stylesheet" href="Admin/css/Admin_home.css">
        <style>
            .detail-container {
                max-width: 800px;
                margin: 20px auto;
                background-color: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            .detail-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
                border-bottom: 2px solid #f0f0f0;
                padding-bottom: 20px;
            }
            .detail-header h1 {
                margin: 0;
                color: #333;
            }
            .btn-back {
                background-color: #2196F3;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                text-decoration: none;
                font-size: 14px;
            }
            .btn-back:hover {
                background-color: #0b7dda;
            }
            .detail-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }
            .detail-item {
                padding: 15px;
                background-color: #f9f9f9;
                border-radius: 4px;
                border-left: 4px solid #2196F3;
            }
            .detail-item label {
                display: block;
                font-weight: 600;
                color: #666;
                margin-bottom: 5px;
                font-size: 12px;
                text-transform: uppercase;
            }
            .detail-item value {
                display: block;
                font-size: 16px;
                color: #333;
            }
            .status-badge {
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
            }
            .status-badge.active {
                background-color: #d4edda;
                color: #155724;
            }
            .status-badge.inactive {
                background-color: #f8d7da;
                color: #721c24;
            }
            .action-buttons {
                display: flex;
                gap: 10px;
                margin-top: 30px;
                justify-content: center;
            }
            .btn-edit, .btn-delete {
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
            }
            .btn-edit {
                background-color: #4CAF50;
                color: white;
            }
            .btn-edit:hover {
                background-color: #45a049;
            }
            .btn-delete {
                background-color: #f44336;
                color: white;
            }
            .btn-delete:hover {
                background-color: #da190b;
            }
        </style>
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
                    <a href="${pageContext.request.contextPath}/admin?action=dashboard" class="nav-item">🏠 Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin?action=employees" class="nav-item active">👥 Employees</a>
                    <a href="${pageContext.request.contextPath}/admin?action=departments" class="nav-item">🏢 Departments</a>
                    <a href="${pageContext.request.contextPath}/admin?action=users" class="nav-item">👤 Users</a>
                    <a href="${pageContext.request.contextPath}/admin?action=roles" class="nav-item">🔐 Roles</a>
                    <a href="${pageContext.request.contextPath}/admin?action=audit-log" class="nav-item">📜 Audit Log</a>
                    <a href="${pageContext.request.contextPath}/admin?action=profile" class="nav-item">⚙️ Profile</a>
                </div>
            </aside>

            <div class="main-content">
                <header class="top-bar">
                    <div class="search-box">
                        <span class="search-icon"> </span>
                        <input type="text" placeholder="Search employees...">
                    </div>
                    <div class="top-bar-actions">
                        <button class="notification-btn">🔔<span class="badge">3</span></button>
                        <div class="user-menu">
                            <img src="https://i.pravatar.cc/32" alt="User">
                            <span>Admin</span>
                        </div>
                    </div>
                </header>

                <div class="dashboard-content">
                    <div class="detail-container">
                        <%
                            Employee employee = (Employee) request.getAttribute("employee");
                            if (employee != null) {
                        %>
                        <div class="detail-header">
                            <h1>Employee Details</h1>
                            <a href="${pageContext.request.contextPath}/admin?action=employees" class="btn-back">← Back to List</a>
                        </div>

                        <div class="detail-grid">
                            <div class="detail-item">
                                <label>Employee ID</label>
                                <value><%= employee.getEmployeeId() %></value>
                            </div>
                            <div class="detail-item">
                                <label>Full Name</label>
                                <value><%= employee.getFullName() %></value>
                            </div>
                            <div class="detail-item">
                                <label>Gender</label>
                                <value><%= employee.getGender() %></value>
                            </div>
                            <div class="detail-item">
                                <label>Email</label>
                                <value><%= employee.getEmail() %></value>
                            </div>
                            <div class="detail-item">
                                <label>Phone</label>
                                <value><%= employee.getPhone() != null ? employee.getPhone() : "N/A" %></value>
                            </div>
                            <div class="detail-item">
                                <label>Address</label>
                                <value><%= employee.getAddress() != null ? employee.getAddress() : "N/A" %></value>
                            </div>
                            <div class="detail-item">
                                <label>Date of Birth</label>
                                <value><%= employee.getDob() != null ? employee.getDob() : "N/A" %></value>
                            </div>
                            <div class="detail-item">
                                <label>Department</label>
                                <value><%= employee.getDepartmentName() != null ? employee.getDepartmentName() : "N/A" %></value>
                            </div>
                            <div class="detail-item">
                                <label>Position</label>
                                <value><%= employee.getPosition() %></value>
                            </div>
                            <div class="detail-item">
                                <label>Hire Date</label>
                                <value><%= employee.getEmploymentPeriod() != null ? employee.getEmploymentPeriod() : "N/A" %></value>
                            </div>
                            <div class="detail-item">
                                <label>Salary</label>
                                <value><%= String.format("%.2f", employee.getSalary()) %></value>
                            </div>
                            <div class="detail-item">
                                <label>Status</label>
                                <value>
                                    <span class="status-badge <%= employee.isActive() ? "active" : "inactive" %>">
                                        <%= employee.isActive() ? "Active" : "Inactive" %>
                                    </span>
                                </value>
                            </div>
                        </div>

                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/admin?action=employees" class="btn-back">Back to List</a>
                        </div>
                        <% } else { %>
                        <div class="alert alert-error">Employee not found</div>
                        <a href="${pageContext.request.contextPath}/admin?action=employees" class="btn-back">Back to List</a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

<%@ page import="java.util.List, com.hrm.model.entity.Employee, com.hrm.model.entity.Department" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Employee Detail - HRMS</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/Admin_home.css">
        <style>
            .detail-container {
                max-width: 900px;
                margin: 0 auto;
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                padding: 30px;
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
                font-size: 28px;
                color: #333;
            }
            .detail-actions {
                display: flex;
                gap: 10px;
            }
            .btn-back {
                background-color: #999;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                text-decoration: none;
                display: inline-block;
            }
            .btn-back:hover {
                background-color: #888;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: 600;
                color: #333;
            }
            .form-group input, .form-group select {
                width: 100%;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                box-sizing: border-box;
            }
            .form-group input:focus, .form-group select:focus {
                outline: none;
                border-color: #2196F3;
                box-shadow: 0 0 5px rgba(33, 150, 243, 0.3);
            }
            .form-section {
                margin-bottom: 30px;
            }
            .form-section h2 {
                font-size: 18px;
                color: #333;
                margin-bottom: 15px;
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
            }
            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }
            .form-actions {
                display: flex;
                gap: 10px;
                justify-content: flex-end;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #eee;
            }
            .btn-submit {
                background-color: #4CAF50;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
            }
            .btn-submit:hover {
                background-color: #45a049;
            }
            .btn-cancel {
                background-color: #999;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
            }
            .btn-cancel:hover {
                background-color: #888;
            }
            .alert {
                padding: 12px;
                margin-bottom: 20px;
                border-radius: 4px;
            }
            .alert-success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .alert-error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
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
                    <a href="${pageContext.request.contextPath}/admin?action=dashboard" class="nav-item">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin?action=employees" class="nav-item active">Employees</a>
                    <a href="${pageContext.request.contextPath}/admin?action=departments" class="nav-item">Departments</a>
                    <a href="${pageContext.request.contextPath}/admin?action=users" class="nav-item">Users</a>
                    <a href="${pageContext.request.contextPath}/admin?action=roles" class="nav-item">Roles</a>
                    <a href="${pageContext.request.contextPath}/admin?action=audit-log" class="nav-item">Audit Log</a>
                    <a href="${pageContext.request.contextPath}/admin?action=profile" class="nav-item">Profile</a>
                </div>
            </aside>

            <div class="main-content">
                <header class="top-bar">
                    <div class="search-box">
                        <span class="search-icon"></span>
                        <input type="text" placeholder="Search...">
                    </div>
                    <div class="top-bar-actions">
                        <button class="notification-btn">
                            Notifications
                            <span class="badge">3</span>
                        </button>
                        <div class="user-menu">
                            <img src="https://i.pravatar.cc/32" alt="User">
                            <span>Admin</span>
                        </div>
                    </div>
                </header>

                <div class="dashboard-content">
                    <% if (request.getAttribute("successMessage") != null) { %>
                    <div class="alert alert-success">
                        <%= request.getAttribute("successMessage") %>
                    </div>
                    <% } %>
                    <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-error">
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                    <% } %>

                    <div class="detail-container">
                        <div class="detail-header">
                            <h1>Edit Employee Information</h1>
                            <div class="detail-actions">
                                <a href="${pageContext.request.contextPath}/admin?action=employees" class="btn-back">Back to List</a>
                            </div>
                        </div>

                        <%
                            Employee employee = (Employee) request.getAttribute("employee");
                            if (employee != null) {
                        %>

                        <form id="editForm" method="POST" action="${pageContext.request.contextPath}/admin?action=save-employee">
                            <input type="hidden" id="employeeId" name="employeeId" value="<%= employee.getEmployeeId() %>">

                            <!-- Basic Information Section -->
                            <div class="form-section">
                                <h2>Basic Information</h2>
                                <div class="form-grid">
                                    <div class="form-group">
                                        <label for="fullName">Full Name *</label>
                                        <input type="text" id="fullName" name="fullName" value="<%= employee.getFullName() %>" required>
                                    </div>

                                    <div class="form-group">
                                        <label for="gender">Gender *</label>
                                        <select id="gender" name="gender" required>
                                            <option value="">Select Gender</option>
                                            <option value="Male" <%= "Male".equals(employee.getGender()) ? "selected" : "" %>>Male</option>
                                            <option value="Female" <%= "Female".equals(employee.getGender()) ? "selected" : "" %>>Female</option>
                                            <option value="Other" <%= "Other".equals(employee.getGender()) ? "selected" : "" %>>Other</option>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="dob">Date of Birth</label>
                                        <input type="date" id="dob" name="dob" value="<%= employee.getDob() != null ? employee.getDob().toString() : "" %>">
                                    </div>

                                    <div class="form-group">
                                        <label for="email">Email *</label>
                                        <input type="email" id="email" name="email" value="<%= employee.getEmail() != null ? employee.getEmail() : "" %>" required>
                                    </div>

                                    <div class="form-group">
                                        <label for="phone">Phone</label>
                                        <input type="tel" id="phone" name="phone" value="<%= employee.getPhone() != null ? employee.getPhone() : "" %>">
                                    </div>

                                    <div class="form-group">
                                        <label for="address">Address</label>
                                        <input type="text" id="address" name="address" value="<%= employee.getAddress() != null ? employee.getAddress() : "" %>">
                                    </div>
                                </div>
                            </div>

                            <!-- Employment Information Section -->
                            <div class="form-section">
                                <h2>Employment Information</h2>
                                <div class="form-grid">
                                    <div class="form-group">
                                        <label for="departmentId">Department *</label>
                                        <select id="departmentId" name="departmentId" required>
                                            <option value="">Select Department</option>
                                            <%
                                List<Department> departments = (List<Department>) request.getAttribute("departments");
                                if (departments != null) {
                                    for (Department dept : departments) {
                                        boolean selected = employee != null && employee.getDepartmentId() == dept.getDepartmentId();
                                            %>
                                            <option value="<%= dept.getDepartmentId() %>" <%= selected ? "selected" : "" %>><%= dept.getDeptName() %></option>
                                            <%
                                        }
                                }
                                            %>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="position">Position *</label>
                                        <input type="text" id="position" name="position" value="<%= employee.getPosition() != null ? employee.getPosition() : "" %>" required>
                                    </div>

                                    <div class="form-group">
                                        <label for="employmentPeriod">Employment Period</label>
                                        <input type="text" id="employmentPeriod" name="employmentPeriod" value="<%= employee.getEmploymentPeriod() != null ? employee.getEmploymentPeriod() : "" %>" placeholder="e.g., 2 years">
                                    </div>

                                    <div class="form-group">
                                        <label for="status">Status *</label>
                                        <select id="status" name="status" required>
                                            <option value="">Select Status</option>
                                            <option value="Active" <%= "Active".equals(employee.getStatus()) ? "selected" : "" %>>Active</option>
                                            <option value="Resigned" <%= "Resigned".equals(employee.getStatus()) ? "selected" : "" %>>Resigned</option>
                                            <option value="Probation" <%= "Probation".equals(employee.getStatus()) ? "selected" : "" %>>Probation</option>
                                            <option value="Intern" <%= "Intern".equals(employee.getStatus()) ? "selected" : "" %>>Intern</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/admin?action=employees" class="btn-cancel">Cancel</a>
                                <button type="submit" class="btn-submit">Save Changes</button>
                            </div>
                        </form>

                        <% } else { %>
                        <div class="alert alert-error">
                            Employee not found.
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

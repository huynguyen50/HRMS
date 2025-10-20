<%@ page import="java.util.List, com.hrm.model.entity.Employee, com.hrm.model.entity.Department" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Employees - HRMS</title>
        <link rel="stylesheet" href="Admin/css/Admin_home.css">
        <link rel="stylesheet" href="Admin/css/employees.css">
        <style>
            /* Add pagination styling */
            .pagination-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 20px;
                padding: 15px;
                background-color: #f8f9fa;
                border-radius: 4px;
            }

            .pagination-info {
                font-size: 14px;
                color: #666;
            }

            .pagination-controls {
                display: flex;
                gap: 5px;
            }

            .pagination-controls a,
            .pagination-controls span {
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                text-decoration: none;
                color: #5b6ef5;
                cursor: pointer;
                font-size: 14px;
            }

            .pagination-controls a:hover {
                background-color: #f0f0f0;
            }

            .pagination-controls span.active {
                background-color: #5b6ef5;
                color: white;
                border-color: #5b6ef5;
            }

            .pagination-controls a.disabled {
                color: #ccc;
                cursor: not-allowed;
                pointer-events: none;
            }

            .search-form {
                display: flex;
                gap: 10px;
                align-items: center;
                margin-bottom: 20px;
            }

            .search-form input {
                flex: 1;
                max-width: 400px;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }

            .search-form button,
            .search-form a {
                padding: 8px 16px;
                background-color: #5b6ef5;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                font-size: 14px;
            }

            .search-form button:hover {
                background-color: #4a5dd8;
            }

            .search-form a {
                background-color: #6c757d;
            }

            .search-form a:hover {
                background-color: #5a6268;
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

            <main class="main-content">
                <!-- Top Bar -->
                <header class="top-bar">
                    <!-- Add search form for employees -->
                    <form method="GET" action="${pageContext.request.contextPath}/admin" class="search-form">
                        <input type="hidden" name="action" value="employees">
                        <input type="text" name="search" placeholder="Search employees by name, email, position..." value="${searchKeyword != null ? searchKeyword : ''}">
                        <button type="submit">Search</button>
                        <% if (request.getAttribute("searchKeyword") != null && !((String)request.getAttribute("searchKeyword")).isEmpty()) { %>
                            <a href="${pageContext.request.contextPath}/admin?action=employees">Clear</a>
                        <% } %>
                    </form>
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

                    <div class="page-header">
                        <h1 class="page-title">Employee Management</h1>
                        <button class="btn-primary" onclick="openAddModal()">+ Add Employee</button>
                    </div>

                    <div class="filter-section">
                        <select id="departmentFilter" onchange="filterTable()">
                            <option value="">All Departments</option>
                            <%
                                List<Department> departments = (List<Department>) request.getAttribute("departments");
                                if (departments != null) {
                                    for (Department dept : departments) {
                            %>
                            <option value="<%= dept.getDeptName() %>"><%= dept.getDeptName() %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                        <select id="statusFilter" onchange="filterTable()">
                            <option value="">All Status</option>
                            <option value="active">Active</option>
                            <option value="resigned">Resigned</option>
                            <option value="probation">Probation</option>
                            <option value="intern">Intern</option>
                        </select>
                    </div>

                    <div class="table-section">
                        <table class="employee-table" id="employeeTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Full Name</th>
                                    <th>Gender</th>
                                    <th>Email</th>
                                    <th>Department</th>
                                    <th>Position</th>
                                    <th>Employment Period</th>
                                    <th>Salary</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Employee> employees = (List<Employee>) request.getAttribute("employeeList");
                                    if (employees != null && !employees.isEmpty()) {
                                        for (Employee emp : employees) {
                                %>
                                <tr class="employee-row" data-department="<%= emp.getDepartmentName() != null ? emp.getDepartmentName() : "" %>" 
                                    data-status="<%= emp.getStatus() != null ? emp.getStatus().toLowerCase() : "active" %>">
                                    <td><%= emp.getEmployeeId() %></td>
                                    <td><%= emp.getFullName() %></td>
                                    <td><%= emp.getGender() %></td>
                                    <td><%= emp.getEmail() %></td>
                                    <td><%= emp.getDepartmentName() != null ? emp.getDepartmentName() : "N/A" %></td>
                                    <td><%= emp.getPosition() %></td>
                                    <td><%= emp.getEmploymentPeriod() != null ? emp.getEmploymentPeriod() : "N/A" %></td>
                                    <td><%= String.format("%.2f", emp.getSalary()) %></td>
                                    <td>
                                        <span class="status-badge <%= emp.getStatus() != null ? emp.getStatus().toLowerCase() : "active" %>">
                                            <%= emp.getStatus() != null ? emp.getStatus() : "Active" %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/admin?action=employee-view&id=<%= emp.getEmployeeId() %>" class="btn-view">View/Edit</a>
                                            <button class="btn-delete" onclick="deleteEmployee(<%= emp.getEmployeeId() %>)">Delete</button>
                                        </div>
                                    </td>
                                </tr>
                                <%      }
                                    } else { %>
                                <tr><td colspan="10" style="text-align: center; padding: 20px;">No employee data</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Add pagination bar with "Showing X - Y of Z" display -->
                    <div class="pagination-bar">
                        <div class="pagination-info">
                            <%
                                int currentPage = (Integer) request.getAttribute("page");
                                int pageSize = (Integer) request.getAttribute("pageSize");
                                int total = (Integer) request.getAttribute("total");
                                int start = (currentPage - 1) * pageSize + 1;
                                int end = Math.min(currentPage * pageSize, total);
                            %>
                            Showing <%= start %> - <%= end %> of <%= total %>
                        </div>
                        <div class="pagination-controls">
                            <%
                                int totalPages = (Integer) request.getAttribute("totalPages");
                                String searchParam = request.getAttribute("searchKeyword") != null ? "&search=" + java.net.URLEncoder.encode((String)request.getAttribute("searchKeyword"), "UTF-8") : "";
                                
                                if (currentPage > 1) {
                            %>
                                <a href="${pageContext.request.contextPath}/admin?action=employees&page=<%= currentPage - 1 %><%= searchParam %>">Prev</a>
                            <% } else { %>
                                <span class="disabled">Prev</span>
                            <% } %>
                            
                            <%
                                for (int i = 1; i <= totalPages; i++) {
                                    if (i == currentPage) {
                            %>
                                <span class="active"><%= i %></span>
                            <% } else { %>
                                <a href="${pageContext.request.contextPath}/admin?action=employees&page=<%= i %><%= searchParam %>"><%= i %></a>
                            <% } } %>
                            
                            <%
                                if (currentPage < totalPages) {
                            %>
                                <a href="${pageContext.request.contextPath}/admin?action=employees&page=<%= currentPage + 1 %><%= searchParam %>">Next</a>
                            <% } else { %>
                                <span class="disabled">Next</span>
                            <% } %>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <div id="employeeModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="modalTitle">Add Employee</h2>
                    <span class="close-btn" onclick="closeModal()">&times;</span>
                </div>
                <form id="employeeForm" method="POST" action="${pageContext.request.contextPath}/admin?action=save-employee">
                    <input type="hidden" id="employeeId" name="employeeId">
                    
                    <div class="form-group">
                        <label for="fullName">Full Name *</label>
                        <input type="text" id="fullName" name="fullName" required>
                    </div>

                    <div class="form-group">
                        <label for="gender">Gender *</label>
                        <select id="gender" name="gender" required>
                            <option value="">Select Gender</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email" required>
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone</label>
                        <input type="tel" id="phone" name="phone">
                    </div>

                    <div class="form-group">
                        <label for="address">Address</label>
                        <input type="text" id="address" name="address">
                    </div>

                    <div class="form-group">
                        <label for="dob">Date of Birth</label>
                        <input type="date" id="dob" name="dob">
                    </div>

                    <div class="form-group">
                        <label for="departmentId">Department *</label>
                        <select id="departmentId" name="departmentId" required>
                            <option value="">Select Department</option>
                            <%
                                if (departments != null) {
                                    for (Department dept : departments) {
                            %>
                            <option value="<%= dept.getDepartmentId() %>"><%= dept.getDeptName() %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="position">Position *</label>
                        <input type="text" id="position" name="position" required>
                    </div>

                    <div class="form-group">
                        <label for="employmentPeriod">Employment Period</label>
                        <input type="text" id="employmentPeriod" name="employmentPeriod" placeholder="e.g., 2 years">
                    </div>

                    <div class="form-group">
                        <label for="status">Status *</label>
                        <select id="status" name="status" required>
                            <option value="">Select Status</option>
                            <option value="Active">Active</option>
                            <option value="Resigned">Resigned</option>
                            <option value="Probation">Probation</option>
                            <option value="Intern">Intern</option>
                        </select>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn-cancel" onclick="closeModal()">Cancel</button>
                        <button type="submit" class="btn-submit">Save</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openAddModal() {
                document.getElementById('modalTitle').textContent = 'Add Employee';
                document.getElementById('employeeForm').reset();
                document.getElementById('employeeId').value = '';
                document.getElementById('employeeModal').classList.add('show');
            }

            function closeModal() {
                document.getElementById('employeeModal').classList.remove('show');
            }

            function deleteEmployee(id) {
                if (confirm('Are you sure you want to delete this employee?')) {
                    window.location.href = '${pageContext.request.contextPath}/admin?action=employee-delete&id=' + id;
                }
            }

            function filterTable() {
                const departmentFilter = document.getElementById('departmentFilter').value.toLowerCase();
                const statusFilter = document.getElementById('statusFilter').value.toLowerCase();
                const rows = document.querySelectorAll('.employee-row');

                rows.forEach(row => {
                    const department = row.getAttribute('data-department').toLowerCase();
                    const status = row.getAttribute('data-status').toLowerCase();

                    const deptMatch = !departmentFilter || department.includes(departmentFilter);
                    const statusMatch = !statusFilter || status === statusFilter;

                    row.style.display = (deptMatch && statusMatch) ? '' : 'none';
                });
            }

            window.onclick = function(event) {
                const modal = document.getElementById('employeeModal');
                if (event.target === modal) {
                    modal.classList.remove('show');
                }
            }
        </script>
    </body>
</html>

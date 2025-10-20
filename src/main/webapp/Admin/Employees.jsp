<%@ page import="java.util.List, com.hrm.model.entity.Employee, com.hrm.model.entity.Department" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Employees - HRMS</title>
        <link rel="stylesheet" href="Admin/css/Admin_home.css">
        <link rel="stylesheet" href="Admin/css/employees.css">
        <style>
            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            .btn-add {
                background-color: #4CAF50;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
            }
            .btn-add:hover {
                background-color: #45a049;
            }
            .filter-section {
                display: flex;
                gap: 15px;
                margin-bottom: 20px;
                flex-wrap: wrap;
            }
            .filter-section select, .filter-section input {
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }
            .employee-table {
                width: 100%;
                border-collapse: collapse;
                background-color: white;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .employee-table thead {
                background-color: #f5f5f5;
                border-bottom: 2px solid #ddd;
            }
            .employee-table th {
                padding: 12px;
                text-align: left;
                font-weight: 600;
                color: #333;
            }
            .employee-table td {
                padding: 12px;
                border-bottom: 1px solid #eee;
            }
            .employee-table tbody tr:hover {
                background-color: #f9f9f9;
            }
            .status-badge {
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
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
                gap: 8px;
            }
            .btn-edit, .btn-delete, .btn-view {
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 12px;
            }
            .btn-edit {
                background-color: #2196F3;
                color: white;
            }
            .btn-edit:hover {
                background-color: #0b7dda;
            }
            .btn-delete {
                background-color: #f44336;
                color: white;
            }
            .btn-delete:hover {
                background-color: #da190b;
            }
            .btn-view {
                background-color: #FF9800;
                color: white;
            }
            .btn-view:hover {
                background-color: #e68900;
            }
            /* Modal Styles */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.4);
            }
            .modal.show {
                display: block;
            }
            .modal-content {
                background-color: #fefefe;
                margin: 5% auto;
                padding: 20px;
                border: 1px solid #888;
                border-radius: 8px;
                width: 90%;
                max-width: 600px;
                max-height: 80vh;
                overflow-y: auto;
            }
            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
            }
            .modal-header h2 {
                margin: 0;
                font-size: 20px;
            }
            .close-btn {
                font-size: 28px;
                font-weight: bold;
                color: #aaa;
                cursor: pointer;
            }
            .close-btn:hover {
                color: #000;
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
            .form-actions {
                display: flex;
                gap: 10px;
                justify-content: flex-end;
                margin-top: 20px;
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
            .pagination {
                display: flex;
                justify-content: center;
                gap: 5px;
                margin-top: 20px;
            }
            .pagination a, .pagination span {
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                cursor: pointer;
                text-decoration: none;
                color: #333;
            }
            .pagination a:hover {
                background-color: #f0f0f0;
            }
            .pagination .active {
                background-color: #2196F3;
                color: white;
                border-color: #2196F3;
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

            <div class="main-content">
                <header class="top-bar">
                    <div class="search-box">
                        <span class="search-icon"> </span>
                        <input type="text" id="searchInput" placeholder="Search employees...">
                    </div>
                    <div class="top-bar-actions">
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
                        <button class="btn-add" onclick="openAddModal()">+ Add Employee</button>
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
                            <option value="inactive">Inactive</option>
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
                                    data-status="<%= emp.isActive() ? "active" : "inactive" %>">
                                    <td><%= emp.getEmployeeId() %></td>
                                    <td><%= emp.getFullName() %></td>
                                    <td><%= emp.getGender() %></td>
                                    <td><%= emp.getEmail() %></td>
                                    <td><%= emp.getDepartmentName() != null ? emp.getDepartmentName() : "N/A" %></td>
                                    <td><%= emp.getPosition() %></td>
                                    <td><%= emp.getEmploymentPeriod() != null ? emp.getEmploymentPeriod() : "N/A" %></td>
                                    <td><%= String.format("%.2f", emp.getSalary()) %></td>
                                    <td>
                                        <span class="status-badge <%= emp.isActive() ? "active" : "inactive" %>">
                                            <%= emp.isActive() ? "Active" : "Inactive" %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn-view" onclick="viewEmployee(<%= emp.getEmployeeId() %>)">View</button>
                                            <button class="btn-edit" onclick="editEmployee(<%= emp.getEmployeeId() %>)">Edit</button>
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

                    <div class="pagination">
                        <%
                            int currentPage = (Integer) request.getAttribute("page");
                            int totalPages = (Integer) request.getAttribute("totalPages");
                            
                            if (currentPage > 1) {
                        %>
                            <a href="${pageContext.request.contextPath}/admin?action=employees&page=<%= currentPage - 1 %>">&laquo; Previous</a>
                        <% } %>
                        
                        <%
                            for (int i = 1; i <= totalPages; i++) {
                                if (i == currentPage) {
                        %>
                            <span class="active"><%= i %></span>
                        <% } else { %>
                            <a href="${pageContext.request.contextPath}/admin?action=employees&page=<%= i %>"><%= i %></a>
                        <% } } %>
                        
                        <%
                            if (currentPage < totalPages) {
                        %>
                            <a href="${pageContext.request.contextPath}/admin?action=employees&page=<%= currentPage + 1 %>">Next &raquo;</a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Removed hireDate and salary inputs from form since they're not editable in Employee table -->
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
                        <label for="active">Status</label>
                        <select id="active" name="active">
                            <option value="true">Active</option>
                            <option value="false">Inactive</option>
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

            function editEmployee(id) {
                document.getElementById('modalTitle').textContent = 'Edit Employee';
                
                fetch('${pageContext.request.contextPath}/admin?action=employee-get-data&id=' + id)
                    .then(response => response.json())
                    .then(data => {
                        if (data.error) {
                            alert('Error: ' + data.error);
                            return;
                        }
                        
                        document.getElementById('employeeId').value = data.id;
                        document.getElementById('fullName').value = data.fullName;
                        document.getElementById('gender').value = data.gender;
                        document.getElementById('email').value = data.email;
                        document.getElementById('phone').value = data.phone;
                        document.getElementById('address').value = data.address;
                        document.getElementById('dob').value = data.dob;
                        document.getElementById('departmentId').value = data.departmentId;
                        document.getElementById('position').value = data.position;
                        document.getElementById('active').value = data.active ? 'true' : 'false';
                        
                        document.getElementById('employeeModal').classList.add('show');
                    })
                    .catch(error => {
                        console.error('Error fetching employee data:', error);
                        alert('Error loading employee data');
                    });
            }

            function viewEmployee(id) {
                window.location.href = '${pageContext.request.contextPath}/admin?action=employee-view&id=' + id;
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

            document.getElementById('searchInput').addEventListener('keyup', function() {
                const searchTerm = this.value.toLowerCase();
                const rows = document.querySelectorAll('.employee-row');

                rows.forEach(row => {
                    const text = row.textContent.toLowerCase();
                    row.style.display = text.includes(searchTerm) ? '' : 'none';
                });
            });
        </script>
    </body>
</html>

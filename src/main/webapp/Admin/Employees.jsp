<%@ page import="java.util.List, com.hrm.model.entity.Employee, com.hrm.model.entity.Department" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Employees - HRMS</title>
        <link rel="stylesheet" href="Admin/css/employees.css">
        <link rel="stylesheet" href="Admin/css/employees-filters.css">
        <link rel="stylesheet" href="Admin/css/pagination.css">
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
                    <a href="${pageContext.request.contextPath}/admin/users"
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
                    <form method="GET" action="${pageContext.request.contextPath}/admin" class="search-form" id="filterForm">
                        <input type="hidden" name="action" value="employees">
                        
                        <!-- Search input -->
                        <div class="search-input">
                            <input type="text" name="search" placeholder="Search employees by name, email, position..." 
                                value="${searchKeyword != null ? searchKeyword : ''}">
                        </div>
                        
                        <!-- Department filter -->
                        <div class="filter-group">
                            <select name="departmentId" id="departmentFilter">
                                <option value="">All Departments</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.departmentId}" ${dept.departmentId == selectedDepartmentId ? 'selected' : ''}>
                                        ${dept.deptName} (${departmentStats[dept.deptName]})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Status filter -->
                        <div class="filter-group">
                            <select name="status" id="statusFilter">
                                <option value="">All Status</option>
                                <c:forEach var="entry" items="${statusStats}">
                                    <option value="${entry.key}" ${entry.key == selectedStatus ? 'selected' : ''}>
                                        ${entry.key} (${entry.value})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Gender filter -->
                        <div class="filter-group">
                            <select name="gender" id="genderFilter">
                                <option value="">All Genders</option>
                                <option value="Male" ${selectedGender == 'Male' ? 'selected' : ''}>Male</option>
                                <option value="Female" ${selectedGender == 'Female' ? 'selected' : ''}>Female</option>
                                <option value="Other" ${selectedGender == 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>

                        <!-- Position filter -->
                        <div class="filter-group">
                            <select name="position" id="positionFilter">
                                <option value="">All Positions</option>
                                <c:forEach var="pos" items="${positions}">
                                    <option value="${pos}" ${pos == selectedPosition ? 'selected' : ''}>
                                        ${pos}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Filter actions -->
                        <div class="filter-actions">
                            <button type="submit" class="btn-primary">Lọc</button>
                            <a href="${pageContext.request.contextPath}/admin?action=employees" class="btn-secondary">Xóa lọc</a>
                        </div>
                    </form>
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
                                <div class="dropdown-divider"></div>
                                <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">
                                    <span class="icon">🚪</span> Logout
                                </a>
                            </div>
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
                        <div class="page-actions">
                            <button class="btn-primary" onclick="openAddModal()">+ Add Employee</button>
                           
                        </div>
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
                                StringBuilder params = new StringBuilder();
                                String searchParam = request.getParameter("search");
                                String deptParam = request.getParameter("departmentId");
                                String statusParam = request.getParameter("status");
                                String genderParam = request.getParameter("gender");
                                String positionParam = request.getParameter("position");

                                if (searchParam != null && !searchParam.isEmpty()) {
                                    params.append("&search=").append(java.net.URLEncoder.encode(searchParam, "UTF-8"));
                                }
                                if (deptParam != null && !deptParam.isEmpty()) {
                                    params.append("&departmentId=").append(deptParam);
                                }
                                if (statusParam != null && !statusParam.isEmpty()) {
                                    params.append("&status=").append(java.net.URLEncoder.encode(statusParam, "UTF-8"));
                                }
                                if (genderParam != null && !genderParam.isEmpty()) {
                                    params.append("&gender=").append(java.net.URLEncoder.encode(genderParam, "UTF-8"));
                                }
                                if (positionParam != null && !positionParam.isEmpty()) {
                                    params.append("&position=").append(java.net.URLEncoder.encode(positionParam, "UTF-8"));
                                }
                                
                                // Calculate range of page numbers to show
                                int range = 2; // Show 2 pages before and after current page
                                int start_page = Math.max(1, currentPage - range);
                                int end_page = Math.min(totalPages, currentPage + range);

                                if (currentPage > 1) {
                            %>
                            <a href="${pageContext.request.contextPath}/admin?action=employees&page=<%= currentPage - 1 %><%= params.toString() %>">Prev</a>
                            <% } else { %>
                            <span class="disabled">Prev</span>
                            <% } %>

                            <% if (start_page > 1) { %>
                                <a href="${pageContext.request.contextPath}/admin?action=employees&page=1<%= params.toString() %>">1</a>
                                <% if (start_page > 2) { %>
                                    <span class="ellipsis">...</span>
                                <% } %>
                            <% } %>

                            <%
                                for (int i = start_page; i <= end_page; i++) {
                                    if (i == currentPage) {
                            %>
                            <span class="active"><%= i %></span>
                            <% } else { %>
                            <a href="${pageContext.request.contextPath}/admin?action=employees&page=<%= i %><%= params.toString() %>"><%= i %></a>
                            <% } } %>

                            <% if (end_page < totalPages) { %>
                                <% if (end_page < totalPages - 1) { %>
                                    <span class="ellipsis">...</span>
                                <% } %>
                                <a href="${pageContext.request.contextPath}/admin?action=employees&page=<%= totalPages %><%= params.toString() %>"><%= totalPages %></a>
                            <% } %>

                            <%
                                if (currentPage < totalPages) {
                            %>
                            <a href="${pageContext.request.contextPath}/admin?action=employees&page=<%= currentPage + 1 %><%= params.toString() %>">Next</a>
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
                    <h2 id="modalTitle">Accept Intern as Employee</h2>
                    <span class="close-btn" onclick="closeModal()">&times;</span>
                </div>
                <!-- Replace form with dropdown to select intern -->
                <form id="employeeForm" method="POST" action="${pageContext.request.contextPath}/admin?action=accept-intern">
                    <div class="form-group">
                        <label for="internId">Select Intern to Accept *</label>
                        <select id="internId" name="internId" required onchange="loadInternDetails()">
                            <option value="">-- Choose an Intern --</option>
                            <%
                                List<Employee> internEmployees = (List<Employee>) request.getAttribute("internEmployees");
                                if (internEmployees != null && !internEmployees.isEmpty()) {
                                    for (Employee intern : internEmployees) {
                            %>
                            <option value="<%= intern.getEmployeeId() %>">
                                <%= intern.getFullName() %> - <%= intern.getPosition() %> (<%= intern.getDepartmentName() != null ? intern.getDepartmentName() : "N/A" %>)
                            </option>
                            <%
                                    }
                                } else {
                            %>
                            <option value="" disabled>No interns available</option>
                            <%
                                }
                            %>
                        </select>
                    </div>

                    <!-- Display intern details -->
                    <div id="internDetails" style="display: none; margin-top: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 4px;">
                        <h3>Intern Details</h3>
                        <p><strong>Email:</strong> <span id="detailEmail"></span></p>
                        <p><strong>Position:</strong> <span id="detailPosition"></span></p>
                        <p><strong>Department:</strong> <span id="detailDepartment"></span></p>
                    </div>

                    <div class="form-group" style="margin-top: 20px;">
                        <label for="newStatus">Change Status To *</label>
                        <select id="newStatus" name="newStatus" required>
                            <option value="">Select New Status</option>
                            <option value="Active">Active</option>
                            <option value="Probation">Probation</option>
                        </select>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn-cancel" onclick="closeModal()">Cancel</button>
                        <button type="submit" class="btn-submit">Accept Intern</button>
                    </div>
                </form>
            </div>
        </div>

  <script>
            function openAddModal() {
                document.getElementById('modalTitle').textContent = 'Accept Intern as Employee';
                document.getElementById('employeeForm').reset();
                document.getElementById('internDetails').style.display = 'none';
                document.getElementById('employeeModal').classList.add('show');
            }

            function closeModal() {
                document.getElementById('employeeModal').classList.remove('show');
            }

            function loadInternDetails() {
                const internId = document.getElementById('internId').value;
                if (!internId) {
                    document.getElementById('internDetails').style.display = 'none';
                    return;
                }

                // Get intern data from the dropdown option
                const selectElement = document.getElementById('internId');
                const selectedOption = selectElement.options[selectElement.selectedIndex];
                
                // Fetch full details via AJAX
                fetch('${pageContext.request.contextPath}/admin?action=employee-get-data&id=' + internId)
                    .then(response => response.json())
                    .then(data => {
                        if (data.error) {
                            console.error('Error loading intern details:', data.error);
                            return;
                        }
                        document.getElementById('detailEmail').textContent = data.email;
                        document.getElementById('detailPosition').textContent = data.position;
                        document.getElementById('detailDepartment').textContent = data.departmentName || 'N/A';
                        document.getElementById('internDetails').style.display = 'block';
                    })
                    .catch(error => console.error('Error:', error));
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
                
                // Close dropdown when clicking outside
                if (!event.target.closest('.user-menu')) {
                    const userMenu = document.querySelector('.user-menu');
                    userMenu.classList.remove('active');
                }
            }

            function toggleUserMenu() {
                const userMenu = document.querySelector('.user-menu');
                userMenu.classList.toggle('active');
            }
        </script>
        <script src="Admin/js/employee-filters.js"></script>
    </body>
</html>

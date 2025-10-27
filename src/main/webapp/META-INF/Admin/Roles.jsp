<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Role Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/Admin_home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/roles.css">
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

        <!-- Main Content -->
        <main class="main-content">
            <!-- Top Bar -->
            <header class="top-bar">
                <div class="search-box">
                    <span class="search-icon">🔍</span>
                    <input type="text" id="searchInput" placeholder="Search roles...">
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
                    <button class="notification-btn">
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
                <div class="page-header">
                    <h1 class="page-title">Role Management</h1>
                    <button class="btn-primary" onclick="openAddRoleModal()">+ Add New Role</button>
                </div>

                <!-- Filter Section -->
                <div class="filter-section">
                    <input type="text" id="roleNameFilter" placeholder="Filter by role name..." class="filter-input">
                </div>

                <!-- Roles Table -->
                <div class="table-section">
                    <table class="roles-table">
                        <thead>
                            <tr>
                                <th>Role ID</th>
                                <th>Role Name</th>
                                <th>User Count</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty roles}">
                                    <c:forEach var="role" items="${roles}">
                                        <tr>
                                            <td>${role.RoleID}</td>
                                            <td>${role.RoleName}</td>
                                            <td>
                                                <span class="user-count-badge">${role.UserCount}</span>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button class="btn-edit" onclick="editRole(${role.RoleID})">Edit</button>
                                                    <button class="btn-permissions" onclick="manageRolePermissions(${role.RoleID})">Permissions</button>
                                                    <button class="btn-delete" onclick="deleteRole(${role.RoleID})">Delete</button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" style="text-align: center; padding: 20px; color: #9ca3af;">
                                            No roles found
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="pagination-bar">
                    <c:if test="${currentPage > 1}">
                        <a href="?action=roles&page=1">First</a>
                        <a href="?action=roles&page=${currentPage - 1}">Previous</a>
                    </c:if>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span class="active">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="?action=roles&page=${i}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <a href="?action=roles&page=${currentPage + 1}">Next</a>
                        <a href="?action=roles&page=${totalPages}">Last</a>
                    </c:if>
                </div>
            </section>
        </main>
    </div>

    <!-- Add/Edit Role Modal -->
    <div id="roleModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Add New Role</h2>
                <button class="close-btn" onclick="closeRoleModal()">&times;</button>
            </div>
            <form id="roleForm" method="POST" action="${pageContext.request.contextPath}/admin?action=saveRole">
                <div class="form-group">
                    <label for="roleName">Role Name *</label>
                    <input type="text" id="roleName" name="roleName" required placeholder="e.g., Manager, HR, Finance">
                </div>

                <div class="form-group">
                    <label>Permissions</label>
                    <div class="permissions-list">
                        <label class="permission-item">
                            <input type="checkbox" name="permissions" value="view_dashboard"> View Dashboard
                        </label>
                        <label class="permission-item">
                            <input type="checkbox" name="permissions" value="manage_employees"> Manage Employees
                        </label>
                        <label class="permission-item">
                            <input type="checkbox" name="permissions" value="manage_departments"> Manage Departments
                        </label>
                        <label class="permission-item">
                            <input type="checkbox" name="permissions" value="manage_users"> Manage Users
                        </label>
                        <label class="permission-item">
                            <input type="checkbox" name="permissions" value="manage_roles"> Manage Roles
                        </label>
                        <label class="permission-item">
                            <input type="checkbox" name="permissions" value="view_audit_log"> View Audit Log
                        </label>
                        <label class="permission-item">
                            <input type="checkbox" name="permissions" value="manage_payroll"> Manage Payroll
                        </label>
                        <label class="permission-item">
                            <input type="checkbox" name="permissions" value="manage_recruitment"> Manage Recruitment
                        </label>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn-cancel" onclick="closeRoleModal()">Cancel</button>
                    <button type="submit" class="btn-submit">Save Role</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openAddRoleModal() {
            document.getElementById('modalTitle').textContent = 'Add New Role';
            document.getElementById('roleForm').reset();
            document.getElementById('roleForm').action = '${pageContext.request.contextPath}/admin?action=saveRole';
            document.getElementById('roleModal').classList.add('show');
        }

        function closeRoleModal() {
            document.getElementById('roleModal').classList.remove('show');
        }

        function editRole(roleId) {
            // Fetch role data and populate form
            fetch('${pageContext.request.contextPath}/admin?action=getRole&id=' + roleId)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('modalTitle').textContent = 'Edit Role';
                    document.getElementById('roleName').value = data.RoleName;
                    
                    // Reset all checkboxes
                    document.querySelectorAll('input[name="permissions"]').forEach(checkbox => {
                        checkbox.checked = false;
                    });
                    
                    // Check permissions for this role
                    if (data.Permissions) {
                        data.Permissions.forEach(permission => {
                            const checkbox = document.querySelector(`input[name="permissions"][value="${permission}"]`);
                            if (checkbox) checkbox.checked = true;
                        });
                    }
                    
                    document.getElementById('roleForm').action = '${pageContext.request.contextPath}/admin?action=updateRole&id=' + roleId;
                    document.getElementById('roleModal').classList.add('show');
                });
        }

        function deleteRole(roleId) {
            if (confirm('Are you sure you want to delete this role? Users with this role will be affected.')) {
                window.location.href = '${pageContext.request.contextPath}/admin?action=deleteRole&id=' + roleId;
            }
        }

        function manageRolePermissions(roleId) {
            window.location.href = '${pageContext.request.contextPath}/admin?action=rolePermissions&id=' + roleId;
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('roleModal');
            if (event.target == modal) {
                modal.classList.remove('show');
            }
        }
    </script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/department.css">
</body>
</html>

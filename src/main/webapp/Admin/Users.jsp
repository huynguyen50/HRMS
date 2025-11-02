<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/Admin_home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/users.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/pagination.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/user-menu.css">
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

                <!-- Dashboard Content -->
                <section class="dashboard-content">
                    <div class="page-header">
                        <h1 class="page-title">User Management</h1>
                    </div>

                    <!-- Filter Section -->
                    <div class="filter-section" style="width:100%;">
                        <form id="filterForm" method="GET" action="${pageContext.request.contextPath}/admin/users" style="display: flex; gap: 15px; flex-wrap: wrap; width: 100%; align-items: center; justify-content: space-between;">
                            <div style="display: flex; gap: 15px; flex-wrap: wrap; align-items: center;">
                                <select name="roleFilter" class="filter-select">
                                    <option value="">All Roles</option>
                                    <c:forEach var="role" items="${roles}">
                                        <option value="${role.roleId}" ${param.roleFilter == role.roleId ? 'selected' : ''}>${role.roleName}</option>
                                    </c:forEach>
                                </select>
                                <select name="statusFilter" class="filter-select">
                                    <option value="">All Status</option>
                                    <option value="1" ${param.statusFilter == '1' ? 'selected' : ''}>Active</option>
                                    <option value="0" ${param.statusFilter == '0' ? 'selected' : ''}>Inactive</option>
                                </select>
                                <select name="departmentFilter" class="filter-select">
                                    <option value="">All Departments</option>
                                    <c:forEach var="dept" items="${departments}">
                                        <option value="${dept.departmentId}" ${param.departmentFilter == dept.departmentId ? 'selected' : ''}>${dept.deptName}</option>
                                    </c:forEach>
                                </select>
                                <input type="text" name="usernameFilter" value="${param.usernameFilter}" placeholder="Filter by username..." class="filter-input">
                                <button type="submit" class="btn-primary" style="height: 40px;">Apply Filters</button>
                                <button type="button" class="btn-secondary" style="height: 40px;" onclick="resetFilters()">Clear All</button>
                            </div>
                            <button class="btn-primary" type="button" onclick="openAddUserModal()">+ Add New User</button>
                        </form>
                        <script>
                        function resetFilters() {
                            document.querySelector('select[name=roleFilter]').selectedIndex = 0;
                            document.querySelector('select[name=statusFilter]').selectedIndex = 0;
                            document.querySelector('select[name=departmentFilter]').selectedIndex = 0;
                            document.querySelector('input[name=usernameFilter]').value = '';
                            document.getElementById('filterForm').submit();
                        }
                        </script>
                    </div>

                    <!-- Users Table -->
                    <div class="table-section">
                        <table class="users-table">
                            <thead>
                                <tr>
                                    <th>User ID</th>
                                    <th>Username</th>
                                    <th>Employee Name</th>
                                    <th>Department</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Last Login</th>
                                    <th>Created Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty users}">
                                        <c:forEach var="user" items="${users}">
                                            <tr>
                                                <td>${user.userId}</td>
                                                <td><strong>${user.username}</strong></td>
                                                <td>${user.employeeId != null ? 'Employee ' : 'N/A'}</td>
                                                <td>Department</td>
                                                <td>${user.role.roleName}</td>
                                                <td>
                                                    <span class="status-badge ${user.isActive ? 'active' : 'inactive'}">
                                                        ${user.isActive ? 'Active' : 'Inactive'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty user.lastLogin}">
                                                            ${user.lastLogin}
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted">Never</span></c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty user.createdDate}">
                                                            ${user.createdDate}
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted">N/A</span></c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <td>
                                                    <div class="action-buttons">
                                                        <button class="btn-edit" onclick="editUser(<c:out value='${user.userId}'/>)" title="Edit user">Edit</button>
                                                        <button class="btn-reset" onclick="resetPassword(<c:out value='${user.userId}'/>)" title="Reset password">Reset</button>
                                                        <button class="btn-toggle ${user.isActive ? 'btn-lock' : 'btn-unlock'}" 
                                                                onclick="toggleUserStatus(<c:out value='${user.userId}'/>)" 
                                                                title="${user.isActive ? 'Lock account' : 'Unlock account'}">
                                                            ${user.isActive ? '🔓 Lock' : '🔒 Unlock'}
                                                        </button>
                                                        <button class="btn-delete" onclick="deleteUser(<c:out value='${user.userId}'/>)" title="Delete user">Delete</button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="9" style="text-align: center; padding: 20px; color: #9ca3af;">
                                                No users found
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
                            <a href="?page=1">First</a>
                            <a href="?page=${currentPage - 1}">Previous</a>
                        </c:if>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="active">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="?page=${i}">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <a href="?page=${currentPage + 1}">Next</a>
                            <a href="?page=${totalPages}">Last</a>
                        </c:if>
                    </div>
                </section>
            </main>
        </div>

        <div id="userModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="modalTitle">Add New User</h2>
                    <button class="close-btn" onclick="closeUserModal()">&times;</button>
                </div>
                <form id="userForm" method="POST" action="${pageContext.request.contextPath}/admin/users">
                    <input type="hidden" id="userId" name="id">
                    <input type="hidden" id="actionField" name="action" value="save">

                    <div class="form-group">
                        <label for="username">Username *</label>
                        <input type="text" id="username" name="username" required>
                        <small class="form-hint">Username must be unique and contain 3-50 characters</small>
                    </div>

                    <div class="form-group">
                        <label for="password">Password *</label>
                        <input type="password" id="password" name="password" required>
                        <small class="form-hint">Password must be at least 8 characters</small>
                    </div>

                    <div class="form-group">
                        <label for="employeeId">Employee *</label>
                        <select id="employeeId" name="employeeId" required>
                            <option value="">Select Employee</option>
                            <c:forEach var="employee" items="${employees}">
                                <option value="${employee.employeeId}">${employee.fullName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="roleId">Role *</label>
                        <select id="roleId" name="roleId" required>
                            <option value="">Select Role</option>
                            <c:forEach var="role" items="${roles}">
                                <option value="${role.roleId}">${role.roleName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group checkbox-group">
                        <label>
                            <input type="checkbox" id="isActive" name="isActive" checked>
                            <span>Active Account</span>
                        </label>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn-cancel" onclick="closeUserModal()">Cancel</button>
                        <button type="submit" class="btn-submit">Save User</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Reset Password Modal -->
        <div id="resetPasswordModal" class="modal">
            <div class="modal-content modal-small">
                <div class="modal-header">
                    <h2>Reset Password</h2>
                    <button class="close-btn" onclick="closeResetPasswordModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to reset the password for this user?</p>
                    <p class="warning-text">A temporary password will be generated and the user will be required to change it on next login.</p>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn-cancel" onclick="closeResetPasswordModal()">Cancel</button>
                    <button type="button" class="btn-submit" onclick="confirmResetPassword()">Reset Password</button>
                </div>
            </div>
        </div>

        <script>
            let currentResetUserId = null;

            function openAddUserModal() {
                document.getElementById('modalTitle').textContent = 'Add New User';
                document.getElementById('userForm').reset();
                document.getElementById('userId').value = '';
                document.getElementById('actionField').value = 'save';
                document.getElementById('password').required = true;
                document.getElementById('userModal').classList.add('show');
            }

            function closeUserModal() {
                document.getElementById('userModal').classList.remove('show');
            }

            function editUser(userId) {
                fetch('${pageContext.request.contextPath}/admin/users?action=getUser&id=' + userId)
                        .then(response => response.json())
                        .then(data => {
                            document.getElementById('modalTitle').textContent = 'Edit User';
                            document.getElementById('userId').value = data.userId;
                            document.getElementById('username').value = data.username;
                            document.getElementById('password').value = '';
                            document.getElementById('password').required = false;
                            document.getElementById('employeeId').value = data.employeeId || '';
                            document.getElementById('roleId').value = data.roleId;
                            document.getElementById('isActive').checked = data.isActive;
                            document.getElementById('actionField').value = 'update';
                            document.getElementById('userModal').classList.add('show');
                        })
                        .catch(error => alert('Error loading user data: ' + error));
            }

            function resetPassword(userId) {
                currentResetUserId = userId;
                document.getElementById('resetPasswordModal').classList.add('show');
            }

            function closeResetPasswordModal() {
                document.getElementById('resetPasswordModal').classList.remove('show');
                currentResetUserId = null;
            }

            function confirmResetPassword() {
                if (currentResetUserId) {
                    window.location.href = '${pageContext.request.contextPath}/admin/users?action=resetPassword&id=' + currentResetUserId;
                }
            }

            function toggleUserStatus(userId) {
                if (confirm('Are you sure you want to toggle this user\'s status?')) {
                    window.location.href = '${pageContext.request.contextPath}/admin/users?action=toggleStatus&id=' + userId;
                }
            }

            function deleteUser(userId) {
                if (confirm('Are you sure you want to delete this user? This action cannot be undone.')) {
                    window.location.href = '${pageContext.request.contextPath}/admin/users?action=delete&id=' + userId;
                }
            }

            // Close modal when clicking outside
            window.onclick = function (event) {
                const userModal = document.getElementById('userModal');
                const resetModal = document.getElementById('resetPasswordModal');

                if (event.target == userModal) {
                    userModal.classList.remove('show');
                }
                if (event.target == resetModal) {
                    resetModal.classList.remove('show');
                }
            }
        </script>
        <script>
            // Toggle user menu dropdown
            function toggleUserMenu() {
                const userMenu = document.querySelector('.user-menu');
                userMenu.classList.toggle('active');
            }

            // Close user menu when clicking outside
            document.addEventListener('click', function(event) {
                if (!event.target.closest('.user-menu')) {
                    const userMenu = document.querySelector('.user-menu');
                    if (userMenu.classList.contains('active')) {
                        userMenu.classList.remove('active');
                    }
                }
            });
        </script>
    </body>
</html>

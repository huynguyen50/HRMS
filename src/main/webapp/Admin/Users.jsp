<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Management - HRMS</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/Admin_home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/employees.css">
    </head>
    <style>
        #toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }

        .toast {
            display: flex;
            align-items: center;
            min-width: 260px;
            padding: 14px 18px;
            margin-bottom: 10px;
            border-radius: 8px;
            color: white;
            font-size: 14px;
            font-weight: 500;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            opacity: 0;
            transform: translateX(100%);
            animation: slideIn 0.4s forwards, fadeOut 0.5s 2.8s forwards;
        }

        .toast-success {
            background-color: #4CAF50;
        }
        .toast-error {
            background-color: #f44336;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(100%);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes fadeOut {
            from {
                opacity: 1;
                transform: translateX(0);
            }
            to {
                opacity: 0;
                transform: translateX(100%);
            }
        }

        /* Search form styling for top-bar */
        .top-bar .search-form {
            display: flex;
            gap: 8px;
            align-items: center;
            flex: 1;
            max-width: 500px;
            margin-right: 20px;
        }

        .top-bar .search-form input {
            flex: 1;
            min-width: 200px;
            padding: 6px 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 13px;
            height: 32px;
        }

        .top-bar .search-form button,
        .top-bar .search-form a {
            padding: 6px 12px;
            background-color: #5b6ef5;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 13px;
            height: 32px;
            line-height: 1;
            white-space: nowrap;
        }

        .top-bar .search-form button:hover {
            background-color: #4a5dd8;
        }

        .top-bar .search-form a {
            background-color: #6c757d;
        }

        .top-bar .search-form a:hover {
            background-color: #5a6268;
        }

        /* Ensure top-bar doesn't break with search form */
        .top-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 20px;
            min-height: 60px;
        }

        .top-bar-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        /* Pagination styling - matching employee page */
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

        /* User table styling */
        .users-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .users-table th {
            background-color: #f8f9fa;
            padding: 15px 12px;
            text-align: left;
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
        }

        .users-table td {
            padding: 12px;
            border-bottom: 1px solid #dee2e6;
            vertical-align: middle;
        }

        .users-table tr:hover {
            background-color: #f8f9fa;
        }

        .user-status {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-active {
            background-color: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }

        .user-actions {
            display: flex;
            gap: 8px;
        }

        .btn-icon {
            padding: 6px 8px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.2s;
        }

        .btn-edit {
            background-color: #17a2b8;
            color: white;
        }

        .btn-edit:hover {
            background-color: #138496;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
        }

        .btn-delete:hover {
            background-color: #c82333;
        }

        .btn-reset {
            background-color: #ffc107;
            color: #212529;
        }

        .btn-reset:hover {
            background-color: #e0a800;
        }

        /* Modal styling */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background-color: white;
            padding: 0;
            border-radius: 8px;
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
        }

        .modal-header {
            padding: 20px;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h2 {
            margin: 0;
            font-size: 20px;
            color: #333;
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #999;
        }

        .modal-close:hover {
            color: #333;
        }

        .modal-body {
            padding: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #333;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #5b6ef5;
            box-shadow: 0 0 0 2px rgba(91, 110, 245, 0.2);
        }

        .form-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            padding: 20px;
            border-top: 1px solid #dee2e6;
        }

        .btn-primary {
            background-color: #5b6ef5;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-primary:hover {
            background-color: #4a5dd8;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
        }
    </style>
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
                <!-- Top Bar -->
                <header class="top-bar">
                    <div class="search-form">
                        <form method="GET" action="${pageContext.request.contextPath}/admin">
                            <input type="hidden" name="action" value="users">
                            <input type="text" name="search" placeholder="Search users by username, email..." 
                                   value="${not empty searchKeyword ? searchKeyword : ''}" />
                            <button type="submit">Search</button>
                            <c:if test="${not empty searchKeyword}">
                                <a href="${pageContext.request.contextPath}/admin?action=users">Clear</a>
                            </c:if>
                        </form>
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

                <!-- Main Content -->
                <div class="dashboard-content">
                    <div class="page-header">
                        <div>
                            <h1 class="page-title">User Management</h1>
                            <p class="page-subtitle">Manage system users, roles, and permissions</p>
                        </div>
                        <button class="btn-primary" onclick="openAddUserModal()">
                            + Add New User
                        </button>
                    </div>

                    <!-- Toast container -->
                    <div id="toast-container"></div>

                    <!-- Toast Script -->
                    <script>
                        function showToast(message, type = "success") {
                            const container = document.getElementById("toast-container");
                            const toast = document.createElement("div");
                            toast.className = "toast " + (type === "success" ? "toast-success" : "toast-error");
                            toast.innerHTML = message;
                            container.appendChild(toast);
                            setTimeout(() => toast.remove(), 3500);
                        }

                        // JSTL session messages
                        <c:if test="${not empty successMessage}">
                        showToast("✓ ${successMessage}", "success");
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                        showToast("✗ ${errorMessage}", "error");
                        </c:if>
                    </script>

                    <!-- Users Table -->
                    <div class="table-section">
                        <c:choose>
                            <c:when test="${not empty userList}">
                                <table class="users-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Username</th>
                                            <th>Email</th>
                                            <th>Role</th>
                                            <th>Last Login</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${userList}">
                                            <tr>
                                                <td>${user.userId}</td>
                                                <td>${user.username}</td>
                                                <td>${user.email}</td>
                                                <td>${user.role != null ? user.role.roleName : 'N/A'}</td>
                                                <td>${user.lastLogin != null ? user.lastLogin : 'Never'}</td>
                                                <td>
                                                    <span class="user-status ${user.isActive() ? 'status-active' : 'status-inactive'}">
                                                        ${user.isActive() ? 'Active' : 'Inactive'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="user-actions">
                                                        <button class="btn-icon btn-edit" title="Edit" 
                                                                onclick="openEditUserModal(${user.userId}, '${user.username}', '${user.email}', '${user.role != null ? user.role.roleName : ''}', ${user.isActive()})">
                                                            ✏️
                                                        </button>
                                                        <button class="btn-icon btn-reset" title="Reset Password"
                                                                onclick="resetUserPassword(${user.userId}, '${user.username}')">
                                                            🔑
                                                        </button>
                                                        <button class="btn-icon btn-delete" title="Delete"
                                                                onclick="confirmDeleteUser(${user.userId}, '${user.username}')">
                                                            🗑️
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <p>📭 No users found</p>
                                    <button class="btn-primary" onclick="openAddUserModal()">Create First User</button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${not empty totalPages && totalPages > 1}">
                        <div class="pagination-bar">
                            <div class="pagination-info">
                                <c:set var="start" value="${(page - 1) * pageSize + 1}"/>
                                <c:set var="end" value="${page * pageSize > total ? total : page * pageSize}"/>
                                Showing ${start} - ${end} of ${total}
                            </div>
                            <div class="pagination-controls">
                                <c:set var="prevPage" value="${page > 1 ? page - 1 : 1}"/>
                                <c:set var="nextPage" value="${page < totalPages ? page + 1 : totalPages}"/>
                                <c:set var="searchParam" value="${not empty searchKeyword ? '&search=' : ''}${searchKeyword}"/>

                                <a class="${page == 1 ? 'disabled' : ''}"
                                   href="?action=users&page=${prevPage}&pageSize=${pageSize}${searchParam}">Prev</a>

                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <c:choose>
                                        <c:when test="${i == page}">
                                            <span class="active">${i}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="?action=users&page=${i}&pageSize=${pageSize}${searchParam}">${i}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>

                                <a class="${page == totalPages ? 'disabled' : ''}"
                                   href="?action=users&page=${nextPage}&pageSize=${pageSize}${searchParam}">Next</a>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Add/Edit User Modal -->
        <div id="userModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="modalTitle">Add New User</h2>
                    <button class="modal-close" onclick="closeUserModal()">&times;</button>
                </div>
                <form id="userForm" method="POST" action="${pageContext.request.contextPath}/admin">
                    <input type="hidden" name="action" value="save-user">
                    <input type="hidden" id="userId" name="userId" value="">

                    <div class="modal-body">
                        <div class="form-group">
                            <label for="username">Username *</label>
                            <input type="text" id="username" name="username" required placeholder="Enter username">
                        </div>

                        <div class="form-group">
                            <label for="email">Email *</label>
                            <input type="email" id="email" name="email" required placeholder="Enter email">
                        </div>

                        <div class="form-group">
                            <label for="password">Password *</label>
                            <input type="password" id="password" name="password" placeholder="Enter password">
                        </div>

                        <div class="form-group">
                            <label for="roleId">Role *</label>
                            <select id="roleId" name="roleId" required>
                                <option value="">-- Select Role --</option>
                                <c:forEach var="role" items="${roleList}">
                                    <option value="${role.roleId}">${role.roleName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="isActive">Status</label>
                            <select id="isActive" name="isActive">
                                <option value="true">Active</option>
                                <option value="false">Inactive</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-primary">Save User</button>
                        <button type="button" class="btn-secondary" onclick="closeUserModal()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div id="deleteModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Confirm Delete</h2>
                    <button class="modal-close" onclick="closeDeleteModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete user <strong id="deleteUserName"></strong>?</p>
                    <p class="warning-text">⚠️ This action cannot be undone.</p>
                </div>
                <form id="deleteForm" method="POST" action="${pageContext.request.contextPath}/admin">
                    <input type="hidden" name="action" value="delete-user">
                    <input type="hidden" id="deleteUserId" name="userId" value="">
                    <div class="form-actions">
                        <button type="submit" class="btn-primary" style="background-color: #dc3545;">Delete</button>
                        <button type="button" class="btn-secondary" onclick="closeDeleteModal()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // Add User Modal
            function openAddUserModal() {
                document.getElementById('modalTitle').textContent = 'Add New User';
                document.getElementById('userForm').reset();
                document.getElementById('userId').value = '';
                document.getElementById('password').required = true;
                document.getElementById('userModal').style.display = 'flex';
            }

            // Edit User Modal
            function openEditUserModal(userId, username, email, roleName, isActive) {
                document.getElementById('modalTitle').textContent = 'Edit User';
                document.getElementById('userId').value = userId;
                document.getElementById('username').value = username;
                document.getElementById('email').value = email;
                document.getElementById('password').required = false;
                document.getElementById('password').placeholder = 'Leave blank to keep current password';
                document.getElementById('isActive').value = isActive;
                
                // Set role
                const roleSelect = document.getElementById('roleId');
                for (let option of roleSelect.options) {
                    if (option.text === roleName) {
                        option.selected = true;
                        break;
                    }
                }
                
                document.getElementById('userModal').style.display = 'flex';
            }

            function closeUserModal() {
                document.getElementById('userModal').style.display = 'none';
            }

            // Delete Modal
            function confirmDeleteUser(userId, username) {
                document.getElementById('deleteUserId').value = userId;
                document.getElementById('deleteUserName').textContent = username;
                document.getElementById('deleteModal').style.display = 'flex';
            }

            function closeDeleteModal() {
                document.getElementById('deleteModal').style.display = 'none';
            }

            // Reset Password
            function resetUserPassword(userId, username) {
                if (confirm('Reset password for user "' + username + '" to default password "123456"?')) {
                    // Create a form to submit the reset request
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/admin';
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'reset-password';
                    
                    const userIdInput = document.createElement('input');
                    userIdInput.type = 'hidden';
                    userIdInput.name = 'userId';
                    userIdInput.value = userId;
                    
                    form.appendChild(actionInput);
                    form.appendChild(userIdInput);
                    document.body.appendChild(form);
                    form.submit();
                }
            }

            // Close modal when clicking outside
            window.onclick = function (event) {
                const userModal = document.getElementById('userModal');
                const deleteModal = document.getElementById('deleteModal');

                if (event.target === userModal) {
                    userModal.style.display = 'none';
                }
                if (event.target === deleteModal) {
                    deleteModal.style.display = 'none';
                }
            };
        </script>
    </body>
</html>

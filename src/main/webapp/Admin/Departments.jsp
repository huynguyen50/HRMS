<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Department Management - HRMS</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/department.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/department-filters.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/pagination.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/user-menu.css">

    </head>
    <style>
        /* Filter styles */
        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-right: 15px;
        }

        .filter-select {
            padding: 6px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: white;
            font-size: 13px;
            min-width: 140px;
            cursor: pointer;
        }

        .filter-select:hover {
            border-color: #5b6ef5;
        }

        /* User menu styles */
        .user-menu {
            position: relative;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 4px 8px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .user-menu:hover {
            background-color: rgba(0, 0, 0, 0.05);
        }

        .user-menu img {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
        }

        .username {
            font-size: 14px;
            font-weight: 500;
            color: #333;
        }

        .user-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            width: 200px;
            background: white;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            padding: 8px 0;
            display: none;
            z-index: 1000;
            margin-top: 8px;
        }

        .user-menu:hover .user-dropdown {
            display: block;
        }

        .user-dropdown a {
            display: flex;
            align-items: center;
            padding: 8px 16px;
            color: #333;
            text-decoration: none;
            transition: background-color 0.2s;
        }

        .user-dropdown a:hover {
            background-color: #f5f5f5;
        }

        .user-dropdown a i {
            margin-right: 8px;
            width: 16px;
            text-align: center;
        }

        .user-dropdown a.logout {
            color: #dc3545;
            border-top: 1px solid #eee;
            margin-top: 4px;
            padding-top: 8px;
        }

        .user-dropdown a.logout:hover {
            background-color: #ffebee;
        }

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

        /* pagination styles moved to Admin/css/pagination.css */

        .top-bar select {
            padding: 6px 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 13px;
            height: 32px;
            background-color: white;
            cursor: pointer;
        }

        .top-bar select:hover {
            border-color: #5b6ef5;
        }

        /* Add user menu dropdown styles */
        .user-menu {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            position: relative;
        }

        .user-menu img {
            width: 32px;
            height: 32px;
            border-radius: 50%;
        }

        .user-menu span {
            font-size: 14px;
            font-weight: 500;
        }

        .user-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            min-width: 150px;
            z-index: 1000;
            display: none;
            margin-top: 8px;
        }

        .user-dropdown a {
            display: block;
            padding: 10px 16px;
            color: #333;
            text-decoration: none;
            font-size: 14px;
            border-bottom: 1px solid #f0f0f0;
            transition: background-color 0.2s;
        }

        .user-dropdown a:last-child {
            border-bottom: none;
        }

        .user-dropdown a:hover {
            background-color: #f5f5f5;
        }

        .user-dropdown a.logout {
            color: #f44336;
        }

        .user-dropdown a.logout:hover {
            background-color: #ffebee;
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
                    <a href="${pageContext.request.contextPath}/departments?action=departments" 
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

            <div class="main-content">
                <!-- Top Bar -->
                <header class="top-bar">
                    <form accept-charset="UTF-8" method="GET" action="${pageContext.request.contextPath}/departments" class="search-form" id="filterForm">
                        <input type="hidden" name="action" value="departments">

                        <!-- Search input -->
                        <div class="search-input">
                            <input type="text" name="search" placeholder="Search departments by name..." 
                                   value="<c:out value="${searchKeyword}"/>" />
                        </div>

                        <!-- Status filter -->
                        <div class="filter-group">
                            <select name="status" id="statusFilter">
                                <option value="all">All Status</option>
                                <option value="active" <c:if test="${status == 'active'}">selected</c:if>>Active</option>
                                <option value="inactive" <c:if test="${status == 'inactive'}">selected</c:if>>Inactive</option>
                                </select>
                            </div>

                            <!-- Sort By -->
                            <div class="filter-group">
                                <select name="sortBy" id="sortBy">
                                    <option value="name" <c:if test="${sortBy == 'name' || empty sortBy}">selected</c:if>>Sort by Name</option>
                                <option value="employees" <c:if test="${sortBy == 'employees'}">selected</c:if>>Sort by Employee Count</option>
                                <option value="created" <c:if test="${sortBy == 'created'}">selected</c:if>>Sort by Created Date</option>
                                </select>
                            </div>

                            <!-- Filter actions -->
                            <div class="filter-actions">
                                <button type="submit" class="btn-filter">Apply Filters</button>
                                <a href="${pageContext.request.contextPath}/departments?action=departments" class="btn-clear">Clear All</a>
                        </div>
                    </form>

                    <div class="top-bar-actions">

                        <!-- User Menu -->
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
                </header>

                <!-- Main Content -->
                <div class="dashboard-content">
                    <div class="page-header">
                        <div>
                            <h1 class="page-title">Department Management</h1>
                            <p class="page-subtitle">Manage departments, assign managers, and configure permissions</p>
                        </div>
                        <button class="btn-primary" onclick="openAddDepartmentModal()">
                            + Add New Department
                        </button>
                    </div>
                    <!-- Toast container -->
                    <div id="toast-container"></div>

                    <!-- Toast Script -->
                    <script>
                        // JSTL session messages
                        <c:if test="${not empty successMessage}">
                        showToast("✓ ${successMessage}", "success");
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                        showToast("✗ ${errorMessage}", "error");
                        </c:if>
                    </script>

                    <!-- Departments Table -->
                    <div class="table-section">
                        <c:choose>
                            <c:when test="${not empty departmentList}">
                                <table class="departments-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Department Name</th>
                                            <th>Manager</th>
                                            <th>Employee Count</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="dept" items="${departmentList}">
                                            <tr>
                                                <td class="dept-id">${dept.departmentId}</td>
                                                <td class="dept-name">${dept.deptName}</td>
                                                <td class="dept-manager">
                                                    <c:choose>
                                                        <c:when test="${not empty dept.deptManagerId}">
                                                            Manager ID: ${dept.deptManagerId}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-unassigned">Unassigned</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="dept-count">
                                                    <span class="badge-count">${dept.employeeCount != null ? dept.employeeCount : 0}</span>
                                                </td>
                                                <td class="dept-status">
                                                    <span class="badge-active">Active</span>
                                                </td>
                                                <td class="dept-actions">
                                                    <button class="btn-icon btn-edit" title="Edit" 
                                                            onclick="openEditDepartmentModal(${dept.departmentId}, '${dept.deptName}', ${dept.deptManagerId})">
                                                        ✏️
                                                    </button>
                                                    <button class="btn-icon btn-delete" title="Delete"
                                                            onclick="confirmDelete(${dept.departmentId}, '${dept.deptName}')">
                                                        🗑️
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <p>No departments found</p>
                                    <button class="btn-primary" onclick="openAddDepartmentModal()">Create First Department</button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Pagination -->
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
                                String statusParam = request.getParameter("status");
                                String sortByParam = request.getParameter("sortBy");

                                if (searchParam != null && !searchParam.isEmpty()) {
                                    params.append("&search=").append(java.net.URLEncoder.encode(searchParam, "UTF-8"));
                                }
                                if (statusParam != null && !statusParam.isEmpty()) {
                                    params.append("&status=").append(java.net.URLEncoder.encode(statusParam, "UTF-8"));
                                }
                                if (sortByParam != null && !sortByParam.isEmpty()) {
                                    params.append("&sortBy=").append(java.net.URLEncoder.encode(sortByParam, "UTF-8"));
                                }
                                
                                // Calculate range of page numbers to show
                                int range = 2; // Show 2 pages before and after current page
                                int start_page = Math.max(1, currentPage - range);
                                int end_page = Math.min(totalPages, currentPage + range);
                                
                                if (currentPage > 1) {
                            %>
                            <a href="${pageContext.request.contextPath}/departments?action=departments&page=<%= currentPage - 1 %><%= params.toString() %>">Prev</a>
                            <% } else { %>
                            <span class="disabled">Prev</span>
                            <% } %>

                            <% if (start_page > 1) { %>
                            <a href="${pageContext.request.contextPath}/departments?action=departments&page=1<%= params.toString() %>">1</a>
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
                            <a href="${pageContext.request.contextPath}/departments?action=departments&page=<%= i %><%= params.toString() %>"><%= i %></a>
                            <% } } %>

                            <% if (end_page < totalPages) { %>
                            <% if (end_page < totalPages - 1) { %>
                            <span class="ellipsis">...</span>
                            <% } %>
                            <a href="${pageContext.request.contextPath}/departments?action=departments&page=<%= totalPages %><%= params.toString() %>"><%= totalPages %></a>
                            <% } %>

                            <%
                                if (currentPage < totalPages) {
                            %>
                            <a href="${pageContext.request.contextPath}/departments?action=departments&page=<%= currentPage + 1 %><%= params.toString() %>">Next</a>
                            <% } else { %>
                            <span class="disabled">Next</span>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add/Edit Department Modal -->
        <div id="departmentModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="modalTitle">Add New Department</h2>
                    <button class="modal-close" onclick="closeDepartmentModal()">&times;</button>
                </div>
                <form id="departmentForm" method="POST" action="${pageContext.request.contextPath}/departments">
                    <input type="hidden" name="action" value="department-save">
                    <input type="hidden" id="deptId" name="deptId" value="">

                    <div class="form-group">
                        <label for="deptName">Department Name *</label>
                        <input type="text" id="deptName" name="deptName" required placeholder="Enter department name">
                    </div>

                    <div class="form-group">
                        <label for="deptManager">Manager</label>
                        <select id="deptManager" name="deptManagerId">
                            <option value="">-- Select Manager --</option>
                            <c:forEach var="manager" items="${managers}">
                                <option value="${manager.employeeId}">${manager.fullName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-primary">Save Department</button>
                        <button type="button" class="btn-secondary" onclick="closeDepartmentModal()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>


        <!-- Delete Confirmation Modal -->
        <div id="deleteModal" class="modal">
            <div class="modal-content modal-small">
                <div class="modal-header">
                    <h2>Confirm Delete</h2>
                    <button class="modal-close" onclick="closeDeleteModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete department <strong id="deleteDeptName"></strong>?</p>
                    <p class="warning-text">This action cannot be undone.</p>
                </div>
                <form id="deleteForm" method="POST" action="${pageContext.request.contextPath}/departments">
                    <input type="hidden" name="action" value="department-delete">
                    <input type="hidden" id="deleteDeptId" name="deptId" value="">
                    <div class="form-actions">
                        <button type="submit" class="btn-danger">Delete</button>
                        <button type="button" class="btn-secondary" onclick="closeDeleteModal()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Notifications Modal -->
        <div id="notificationsModal" class="modal">
            <div class="modal-content modal-medium">
                <div class="modal-header">
                    <h2>Notifications</h2>
                    <button class="modal-close" onclick="closeNotificationsModal()">&times;</button>
                </div>
                <div id="notificationsList" class="notifications-list">
                    <!-- Notifications will be loaded here -->
                </div>
            </div>
        </div>
    </body>
    <script>
        // Submit form on filter change
        document.querySelectorAll('#filterForm select').forEach(select => {
            select.addEventListener('change', () => {
                document.getElementById('filterForm').submit();
            });
        });

        function openNotifications() {
            document.getElementById('notificationsModal').style.display = 'flex';
            loadNotifications();
        }

        function closeNotificationsModal() {
            document.getElementById('notificationsModal').style.display = 'none';
        }

        function loadNotifications() {
            fetch('${pageContext.request.contextPath}/admin?action=get-notifications')
                    .then(response => response.json())
                    .then(data => {
                        const notificationsList = document.getElementById('notificationsList');
                        notificationsList.innerHTML = '';

                        if (data.notifications && data.notifications.length > 0) {
                            data.notifications.forEach(notification => {
                                const notifDiv = document.createElement('div');
                                notifDiv.className = 'notification-item';
                                notifDiv.innerHTML = `
                                   <div class="notification-content">
                                       <p class="notification-message">${notification.message}</p>
                                       <span class="notification-time">${notification.createdAt}</span>
                                   </div>
                               `;
                                notificationsList.appendChild(notifDiv);
                            });
                        } else {
                            notificationsList.innerHTML = '<p class="empty-notification">No notifications</p>';
                        }
                    })
                    .catch(error => console.error('Error loading notifications:', error));
        }

        function loadDepartmentPermissions(deptId) {
            fetch('${pageContext.request.contextPath}/departments?action=get-permissions&deptId=' + deptId)
                    .then(response => response.json())
                    .then(data => {
                        document.querySelectorAll('#permissionsForm input[type="checkbox"]').forEach(checkbox => {
                            checkbox.checked = false;
                        });

                        if (data.permissions && data.permissions.length > 0) {
                            data.permissions.forEach(permission => {
                                const checkbox = document.querySelector(`input[value="${permission}"]`);
                                if (checkbox) {
                                    checkbox.checked = true;
                                }
                            });
                        }
                    })
                    .catch(error => console.error('Error loading permissions:', error));
        }

        function openAddDepartmentModal() {
            document.getElementById('modalTitle').textContent = 'Add New Department';
            document.getElementById('departmentForm').reset();
            document.getElementById('deptId').value = '';
            document.getElementById('departmentModal').style.display = 'flex';
        }

        function openEditDepartmentModal(deptId, deptName, managerId) {
            document.getElementById('modalTitle').textContent = 'Edit Department';
            document.getElementById('deptId').value = deptId;
            document.getElementById('deptName').value = deptName;
            document.getElementById('deptManager').value = managerId || '';
            document.getElementById('departmentModal').style.display = 'flex';
        }

        function closeDepartmentModal() {
            document.getElementById('departmentModal').style.display = 'none';
        }

        function openPermissionsModal(deptId, deptName) {
            document.getElementById('permDeptId').value = deptId;
            document.getElementById('permDeptName').textContent = deptName;
            document.getElementById('permissionsModal').style.display = 'flex';
            loadDepartmentPermissions(deptId);
        }

        function closePermissionsModal() {
            document.getElementById('permissionsModal').style.display = 'none';
        }

        function confirmDelete(deptId, deptName) {
            document.getElementById('deleteDeptId').value = deptId;
            document.getElementById('deleteDeptName').textContent = deptName;
            document.getElementById('deleteModal').style.display = 'flex';
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
        }

        window.onclick = function (event) {
            const departmentModal = document.getElementById('departmentModal');
            const permissionsModal = document.getElementById('permissionsModal');
            const deleteModal = document.getElementById('deleteModal');
            const notificationsModal = document.getElementById('notificationsModal');

            if (event.target === departmentModal) {
                departmentModal.style.display = 'none';
            }
            if (event.target === permissionsModal) {
                permissionsModal.style.display = 'none';
            }
            if (event.target === deleteModal) {
                deleteModal.style.display = 'none';
            }
            if (event.target === notificationsModal) {
                notificationsModal.style.display = 'none';
            }
            if (!event.target.closest('.user-menu')) {
                const userMenu = document.querySelector('.user-menu');
                userMenu.classList.remove('active');
            }
        };

        function toggleUserMenu() {
            const userMenu = document.querySelector('.user-menu');
            userMenu.classList.toggle('active');
        }

        // Close dropdown when clicking outside
        document.addEventListener('click', function (event) {
            const userMenu = document.querySelector('.user-menu');
            const userDropdown = document.getElementById('userDropdown');
            if (userMenu && !userMenu.contains(event.target)) {
                if (userDropdown) {
                    userDropdown.style.display = 'none';
                }
            }
        });

        function showToast(message, type = "success") {
            const container = document.getElementById("toast-container");
            const toast = document.createElement("div");
            toast.className = "toast " + (type === "success" ? "toast-success" : "toast-error");
            toast.innerHTML = message;
            container.appendChild(toast);
            setTimeout(() => toast.remove(), 3500);
        }
    </script>
</html>

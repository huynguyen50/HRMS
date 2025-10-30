<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Department Management - HRMS</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/department.css">
 
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
                        <form method="GET" action="${pageContext.request.contextPath}/departments">
                            <input type="hidden" name="action" value="departments">
                            <input type="text" name="search" placeholder="Search departments..." 
                                   value="${not empty searchKeyword ? searchKeyword : ''}" />
                            <button type="submit">Search</button>
                            <c:if test="${not empty searchKeyword}">
                                <a href="${pageContext.request.contextPath}/departments?action=departments">Clear</a>
                            </c:if>
                        </form>
                    </div>
                    <div class="top-bar-actions">
                        <!-- Ensure dropdown IDs match the JavaScript functions -->
                        <select id="departmentSelector" class="env-selector" onchange="filterByDepartment()">
                            <option value="">All Departments</option>
                            <c:forEach var="dept" items="${allDepartments}">
                                <option value="${dept.departmentId}" 
                                        ${selectedDepartmentId == dept.departmentId ? 'selected' : ''}>
                                    ${dept.deptName}
                                </option>
                            </c:forEach>
                        </select>

                        <select id="timeRangeSelector" class="time-selector" onchange="filterByTimeRange()">
                            <option value="">All Time</option>
                            <option value="today" ${selectedTimeRange == 'today' ? 'selected' : ''}>Today</option>
                            <option value="week" ${selectedTimeRange == 'week' ? 'selected' : ''}>This Week</option>
                            <option value="month" ${selectedTimeRange == 'month' ? 'selected' : ''}>This Month</option>
                        </select>

                        <button class="notification-btn" onclick="openNotifications()">
                            🔔
                            <span class="badge" id="notificationBadge">${notificationCount != null ? notificationCount : 0}</span>
                        </button>
                        <div class="user-menu" onclick="toggleUserMenu()">
                            <img src="https://i.pravatar.cc/32" alt="User">
                            <span>Admin</span>
                            <div id="userDropdown" class="user-dropdown">
                                <a href="${pageContext.request.contextPath}/admin?action=profile">Profile</a>
                                <a href="${pageContext.request.contextPath}/admin?action=settings">Settings</a>
                                <a href="javascript:void(0);" class="logout" onclick="logout()">Logout</a>
                            </div>
                        </div>
                    </div>
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
                                                    <button class="btn-icon btn-permissions" title="Permissions"
                                                            onclick="openPermissionsModal(${dept.departmentId}, '${dept.deptName}')">
                                                        🔐
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
                     <c:if test="${not empty totalPages}">
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
                                 <c:set var="filterParams" value="${not empty selectedDepartmentId ? '&departmentId=' : ''}${selectedDepartmentId}${not empty selectedTimeRange ? '&timeRange=' : ''}${selectedTimeRange}"/>

                                 <a class="${page == 1 ? 'disabled' : ''}"
                                    href="?action=departments&page=${prevPage}&pageSize=${pageSize}${searchParam}${filterParams}">Prev</a>

                                 <c:forEach var="i" begin="1" end="${totalPages}">
                                     <c:choose>
                                         <c:when test="${i == page}">
                                             <span class="active">${i}</span>
                                         </c:when>
                                         <c:otherwise>
                                             <a href="?action=departments&page=${i}&pageSize=${pageSize}${searchParam}${filterParams}">${i}</a>
                                         </c:otherwise>
                                     </c:choose>
                                 </c:forEach>

                                 <a class="${page == totalPages ? 'disabled' : ''}"
                                    href="?action=departments&page=${nextPage}&pageSize=${pageSize}${searchParam}${filterParams}">Next</a>
                             </div>
                         </div>
                     </c:if>
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

        <!-- Permissions Modal -->
        <div id="permissionsModal" class="modal">
            <div class="modal-content modal-large">
                <div class="modal-header">
                    <h2>Department Permissions - <span id="permDeptName"></span></h2>
                    <button class="modal-close" onclick="closePermissionsModal()">&times;</button>
                </div>
                <form id="permissionsForm" method="POST" action="${pageContext.request.contextPath}/departments">
                    <input type="hidden" name="action" value="department-permissions-save">
                    <input type="hidden" id="permDeptId" name="deptId" value="">

                    <div class="permissions-grid">
                        <div class="permission-section">
                            <h3>Employee Management</h3>
                            <div class="permission-item">
                                <input type="checkbox" id="perm-view-employees" name="permissions" value="view_employees">
                                <label for="perm-view-employees">View Employees</label>
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" id="perm-add-employees" name="permissions" value="add_employees">
                                <label for="perm-add-employees">Add Employees</label>
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" id="perm-edit-employees" name="permissions" value="edit_employees">
                                <label for="perm-edit-employees">Edit Employees</label>
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" id="perm-delete-employees" name="permissions" value="delete_employees">
                                <label for="perm-delete-employees">Delete Employees</label>
                            </div>
                        </div>

                        <div class="permission-section">
                            <h3>Department Management</h3>
                            <div class="permission-item">
                                <input type="checkbox" id="perm-view-dept" name="permissions" value="view_department">
                                <label for="perm-view-dept">View Department Info</label>
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" id="perm-edit-dept" name="permissions" value="edit_department">
                                <label for="perm-edit-dept">Edit Department</label>
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" id="perm-manage-budget" name="permissions" value="manage_budget">
                                <label for="perm-manage-budget">Manage Budget</label>
                            </div>
                        </div>

                        <div class="permission-section">
                            <h3>Reports & Analytics</h3>
                            <div class="permission-item">
                                <input type="checkbox" id="perm-view-reports" name="permissions" value="view_reports">
                                <label for="perm-view-reports">View Reports</label>
                            </div>
                            <div class="permission-item">
                                <input type="checkbox" id="perm-export-data" name="permissions" value="export_data">
                                <label for="perm-export-data">Export Data</label>
                            </div>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-primary">Save Permissions</button>
                        <button type="button" class="btn-secondary" onclick="closePermissionsModal()">Cancel</button>
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
            function filterByDepartment() {
                console.log("[v0] filterByDepartment called");
                const deptId = document.getElementById('departmentSelector').value;
                const timeRange = document.getElementById('timeRangeSelector').value;
                console.log("[v0] deptId:", deptId, "timeRange:", timeRange);
                
                const url = new URL(window.location);
                url.searchParams.set('action', 'departments');
                
                if (deptId) {
                    url.searchParams.set('departmentId', deptId);
                } else {
                    url.searchParams.delete('departmentId');
                }
                
                if (timeRange) {
                    url.searchParams.set('timeRange', timeRange);
                } else {
                    url.searchParams.delete('timeRange');
                }
                
                url.searchParams.set('page', '1');
                console.log("[v0] Navigating to:", url.toString());
                window.location.href = url.toString();
            }
            
            function filterByTimeRange() {
                console.log("[v0] filterByTimeRange called");
                const deptId = document.getElementById('departmentSelector').value;
                const timeRange = document.getElementById('timeRangeSelector').value;
                console.log("[v0] deptId:", deptId, "timeRange:", timeRange);
                
                const url = new URL(window.location);
                url.searchParams.set('action', 'departments');
                
                if (deptId) {
                    url.searchParams.set('departmentId', deptId);
                } else {
                    url.searchParams.delete('departmentId');
                }
                
                if (timeRange) {
                    url.searchParams.set('timeRange', timeRange);
                } else {
                    url.searchParams.delete('timeRange');
                }
                
                url.searchParams.set('page', '1');
                console.log("[v0] Navigating to:", url.toString());
                window.location.href = url.toString();
            }
            
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
            };

            function logout() {
                if (confirm('Are you sure you want to logout?')) {
                    window.location.href = '${pageContext.request.contextPath}/admin?action=logout';
                }
            }

            function toggleUserMenu() {
                const userDropdown = document.getElementById('userDropdown');
                userDropdown.style.display = userDropdown.style.display === 'block' ? 'none' : 'block';
            }

            // Close dropdown when clicking outside
            document.addEventListener('click', function(event) {
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

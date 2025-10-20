<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Department Management - HRMS</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/Admin_home.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/department.css">
    </head>
    <style>
        /* === Toast notification CSS === */
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
                    <div class="search-box">
                        <span class="search-icon"> </span>
                        <input type="text" placeholder="Search departments...">
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
                            <h1 class="page-title">Department Management</h1>
                            <p class="page-subtitle">Manage departments, assign managers, and configure permissions</p>
                        </div>
                        <button class="btn-primary" onclick="openAddDepartmentModal()">
                            ➕ Add New Department
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
                                    <p>📭 No departments found</p>
                                    <button class="btn-primary" onclick="openAddDepartmentModal()">Create First Department</button>
                                </div>
                            </c:otherwise>
                        </c:choose>
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
                <form id="departmentForm" method="POST" action="${pageContext.request.contextPath}/department">
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
                <form id="permissionsForm" method="POST" action="${pageContext.request.contextPath}/department">
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
                    <p class="warning-text">⚠️ This action cannot be undone.</p>
                </div>
                <form id="deleteForm" method="POST" action="${pageContext.request.contextPath}/department">
                    <input type="hidden" name="action" value="department-delete">
                    <input type="hidden" id="deleteDeptId" name="deptId" value="">
                    <div class="form-actions">
                        <button type="submit" class="btn-danger">Delete</button>
                        <button type="button" class="btn-secondary" onclick="closeDeleteModal()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // Add Department Modal
            function openAddDepartmentModal() {
                document.getElementById('modalTitle').textContent = 'Add New Department';
                document.getElementById('departmentForm').reset();
                document.getElementById('deptId').value = '';
                document.getElementById('departmentModal').style.display = 'flex';
            }

            // Edit Department Modal
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

            // Permissions Modal
            function openPermissionsModal(deptId, deptName) {
                document.getElementById('permDeptId').value = deptId;
                document.getElementById('permDeptName').textContent = deptName;
                document.getElementById('permissionsModal').style.display = 'flex';
                // TODO: Load existing permissions from server
            }

            function closePermissionsModal() {
                document.getElementById('permissionsModal').style.display = 'none';
            }

            // Delete Modal
            function confirmDelete(deptId, deptName) {
                document.getElementById('deleteDeptId').value = deptId;
                document.getElementById('deleteDeptName').textContent = deptName;
                document.getElementById('deleteModal').style.display = 'flex';
            }

            function closeDeleteModal() {
                document.getElementById('deleteModal').style.display = 'none';
            }

            // Close modal when clicking outside
            window.onclick = function (event) {
                const departmentModal = document.getElementById('departmentModal');
                const permissionsModal = document.getElementById('permissionsModal');
                const deleteModal = document.getElementById('deleteModal');

                if (event.target === departmentModal) {
                    departmentModal.style.display = 'none';
                }
                if (event.target === permissionsModal) {
                    permissionsModal.style.display = 'none';
                }
                if (event.target === deleteModal) {
                    deleteModal.style.display = 'none';
                }
            };
        </script>
    </body>
</html>

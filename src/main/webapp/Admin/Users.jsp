<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - HRMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/Admin_home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/unified-layout.css">
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
                    <a href="${pageContext.request.contextPath}/admin?action=role-permissions"
                       class="nav-item ${activePage == 'role-permissions' ? 'active' : ''}">🛡️ Role Permissions</a>
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
                                <a href="${pageContext.request.contextPath}/homepage" class="dropdown-item">
                                    <span class="icon">🏠</span> Trang chủ
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
                        <button class="btn-primary" type="button" onclick="openAddUserModal()">+ Add New User</button>
                    </div>

                    <!-- Filter Section -->
                    <div class="filter-section">
                        <form id="filterForm" method="GET" action="${pageContext.request.contextPath}/admin/users">
                            <div class="filter-controls">
                                <div class="filter-group">
                                    <label for="roleFilter">Role</label>
                                    <select name="roleFilter" id="roleFilter" class="filter-select">
                                        <option value="">All Roles</option>
                                        <c:forEach var="role" items="${roles}">
                                            <option value="${role.roleId}" ${param.roleFilter == role.roleId ? 'selected' : ''}>${role.roleName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label for="statusFilter">Status</label>
                                    <select name="statusFilter" id="statusFilter" class="filter-select">
                                        <option value="">All Status</option>
                                        <option value="1" ${param.statusFilter == '1' ? 'selected' : ''}>Active</option>
                                        <option value="0" ${param.statusFilter == '0' ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label for="departmentFilter">Department</label>
                                    <select name="departmentFilter" id="departmentFilter" class="filter-select">
                                        <option value="">All Departments</option>
                                        <c:forEach var="dept" items="${departments}">
                                            <option value="${dept.departmentId}" ${param.departmentFilter == dept.departmentId ? 'selected' : ''}>${dept.deptName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label for="usernameFilter">Username</label>
                                    <input type="text" name="usernameFilter" id="usernameFilter" value="${param.usernameFilter}" placeholder="Search username..." class="filter-input">
                                </div>
                                <!-- Add hidden sort parameters to preserve sort state during filter -->
                                <input type="hidden" name="sortField" value="${sortField}">
                                <input type="hidden" name="sortOrder" value="${sortOrder}">
                                <div class="filter-buttons">
                                    <button type="submit" class="btn-primary">Apply Filters</button>
                                    <button type="button" class="btn-secondary" onclick="resetFilters()">Clear All</button>
                                </div>
                            </div>
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
                                    <th onclick="sortTable('UserID')">User ID
                                        <c:if test="${sortField == 'UserID'}">
                                            <span class="sort-arrow">${sortOrder == 'ASC' ? '▲' : '▼'}</span>
                                        </c:if>
                                    </th>
                                    <th onclick="sortTable('Username')">Username
                                        <c:if test="${sortField == 'Username'}">
                                            <span class="sort-arrow">${sortOrder == 'ASC' ? '▲' : '▼'}</span>
                                        </c:if>
                                    </th>
                                    <th onclick="sortTable('FullName')">Employee Name
                                        <c:if test="${sortField == 'FullName'}">
                                            <span class="sort-arrow">${sortOrder == 'ASC' ? '▲' : '▼'}</span>
                                        </c:if>
                                    </th>
                                    <th onclick="sortTable('DeptName')">Department
                                        <c:if test="${sortField == 'DeptName'}">
                                            <span class="sort-arrow">${sortOrder == 'ASC' ? '▲' : '▼'}</span>
                                        </c:if>
                                    </th>
                                    <th onclick="sortTable('RoleName')">Role
                                        <c:if test="${sortField == 'RoleName'}">
                                            <span class="sort-arrow">${sortOrder == 'ASC' ? '▲' : '▼'}</span>
                                        </c:if>
                                    </th>
                                    <th onclick="sortTable('Status')">Status
                                        <c:if test="${sortField == 'Status'}">
                                            <span class="sort-arrow">${sortOrder == 'ASC' ? '▲' : '▼'}</span>
                                        </c:if>
                                    </th>
                                    <th onclick="sortTable('LastLogin')">Last Login
                                        <c:if test="${sortField == 'LastLogin'}">
                                            <span class="sort-arrow">${sortOrder == 'ASC' ? '▲' : '▼'}</span>
                                        </c:if>
                                    </th>
                                    <th onclick="sortTable('CreatedDate')">Created Date
                                        <c:if test="${sortField == 'CreatedDate' || sortField == ''}">
                                            <span class="sort-arrow">${sortOrder == 'ASC' ? '▲' : '▼'}</span>
                                        </c:if>
                                    </th>
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
                                                <td>${user.employee != null ? user.employee.fullName : 'N/A'}</td>
                                                <td>${user.department != null ? user.department.deptName : 'N/A'}</td>
                                                <td>${user.role.roleName}</td>
                                                <td>
                                                    <span class="status-badge ${user.isActive ? 'active' : 'inactive'}">
                                                        ${user.isActive ? 'Active' : 'Inactive'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty user.lastLogin}">
                                                            ${user.lastLogin.toString()}
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted">Never</span></c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty user.createdDate}">
                                                            ${user.createdDate.toString()}
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

                    <div class="pagination-bar">
                        <div class="pagination-info">
                            <%-- Tính toán hiển thị --%>
                            <c:set var="start" value="${total > 0 ? (page - 1) * pageSize + 1 : 0}" />
                            <c:set var="end" value="${page * pageSize}" />
                            <c:if test="${end > total}">
                                <c:set var="end" value="${total}" />
                            </c:if>
                            <span>Showing ${start} - ${end} of ${total}</span>
                            
                            <div class="page-size-selector">
                                <label for="pageSizeSelect">Items per page:</label>
                                <select id="pageSizeSelect" onchange="changePageSize(this.value)">
                                    <option value="5" <c:if test="${pageSize == 5}">selected</c:if>>5</option>
                                    <option value="10" <c:if test="${pageSize == 10}">selected</c:if>>10</option>
                                    <option value="20" <c:if test="${pageSize == 20}">selected</c:if>>20</option>
                                    <option value="50" <c:if test="${pageSize == 50}">selected</c:if>>50</option>
                                </select>
                            </div>
                        </div>

                        <div class="pagination-controls">
                            
                            <c:url var="baseUrl" value="/admin/users">
                                <c:param name="pageSize" value="${pageSize}" />
                                <%-- Thêm các tham số filter/sort để đảm bảo liên kết giữ trạng thái --%>
                                <c:param name="roleFilter" value="${param.roleFilter}" />
                                <c:param name="statusFilter" value="${param.statusFilter}" />
                                <c:param name="departmentFilter" value="${param.departmentFilter}" />
                                <c:param name="usernameFilter" value="${param.usernameFilter}" />
                                <c:param name="sortField" value="${sortField}" />
                                <c:param name="sortOrder" value="${sortOrder}" />
                            </c:url>

                            <c:choose>
                                <c:when test="${page > 1}">
                                    <c:url var="prevUrl" value="${baseUrl}">
                                        <c:param name="page" value="${page - 1}" />
                                    </c:url>
                                    <a href="${prevUrl}" class="btn-pagination">← Prev</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="disabled">← Prev</span>
                                </c:otherwise>
                            </c:choose>

                            <c:set var="range" value="2" />
                            <c:set var="start_page" value="${page - range > 1 ? page - range : 1}" />
                            <c:set var="end_page" value="${page + range < totalPages ? page + range : totalPages}" />

                            <c:if test="${start_page > 1}">
                                <c:url var="firstPageUrl" value="${baseUrl}"><c:param name="page" value="1" /></c:url>
                                <a href="${firstPageUrl}" class="btn-pagination">1</a>
                                <c:if test="${start_page > 2}">
                                    <span class="ellipsis">...</span>
                                </c:if>
                            </c:if>

                            <c:forEach begin="${start_page}" end="${end_page}" var="i">
                                <c:choose>
                                    <c:when test="${i == page}">
                                        <span class="active btn-pagination">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url var="pageUrl" value="${baseUrl}"><c:param name="page" value="${i}" /></c:url>
                                        <a href="${pageUrl}" class="btn-pagination">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${end_page < totalPages}">
                                <c:if test="${end_page < totalPages - 1}">
                                    <span class="ellipsis">...</span>
                                </c:if>
                                <c:url var="lastPageUrl" value="${baseUrl}"><c:param name="page" value="${totalPages}" /></c:url>
                                <a href="${lastPageUrl}" class="btn-pagination">${totalPages}</a>
                            </c:if>

                            <c:choose>
                                <c:when test="${page < totalPages}">
                                    <c:url var="nextUrl" value="${baseUrl}">
                                        <c:param name="page" value="${page + 1}" />
                                    </c:url>
                                    <a href="${nextUrl}" class="btn-pagination">Next →</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="disabled">Next →</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
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
                <form id="userForm" method="POST" action="${pageContext.request.contextPath}/admin/users" onsubmit="handleFormSubmit(event)">
                    <input type="hidden" id="userId" name="id">
                    <input type="hidden" id="actionField" name="action" value="save">

                    <div class="form-group">
                        <label for="username">Username *</label>
                        <input type="text" id="username" name="username" required 
                               oninput="clearUsernameError()">
                        <small class="form-hint">Username must be unique and contain 3-50 characters (letters, numbers, ., -, _)</small>
                        <div id="usernameError" class="error-message" style="display: none;"></div>
                    </div>

                    <div class="form-group">
                        <label for="password">Password *</label>
                        <input type="password" id="password" name="password" required 
                               oninput="clearError('password')">
                        <small class="form-hint">Password must be at least 8 characters, including 1 uppercase, 1 lowercase, and 1 number</small>
                        <div id="passwordError" class="error-message" style="display: none;"></div>
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

                    <div id="formError" class="error-message" style="display: none; margin-top: 10px;"></div>
                    <div class="form-actions">
                        <button type="button" class="btn-cancel" onclick="closeUserModal()">Cancel</button>
                        <button type="submit" class="btn-submit" id="submitBtn">Save User</button>
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
            let isEditMode = false;

            function buildFetchOptions(options = {}) {
                const headers = {
                    'Accept': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                    ...(options.headers || {})
                };

                return {
                    credentials: 'same-origin',
                    ...options,
                    headers
                };
            }

            async function fetchJson(url, options = {}) {
                const response = await fetch(url, buildFetchOptions(options));
                return parseJsonResponse(response);
            }

            async function parseJsonResponse(response) {
                const text = await response.text();
                const contentType = response.headers.get('Content-Type') || '';

                if (!response.ok) {
                    if (response.status === 401) {
                        throw new Error('Phiên đăng nhập đã hết hạn hoặc bạn không có quyền. Vui lòng đăng nhập lại.');
                    }
                    const statusMessage = `HTTP ${response.status}${response.statusText ? ' ' + response.statusText : ''}`;
                    const message = text && text.trim() ? text : statusMessage;
                    throw new Error(message);
                }

                if (!text || !text.trim()) {
                    if (response.status === 204 || response.status === 205 || response.headers.get('Content-Length') === '0') {
                        return {};
                    }

                    if (contentType.includes('application/json')) {
                        return {};
                    }

                    throw new Error('Server không trả về dữ liệu.');
                }

                if (!contentType.toLowerCase().includes('application/json')) {
                    console.error('Phản hồi không phải JSON:', text);
                    throw new Error('Server trả về dữ liệu không đúng định dạng JSON.');
                }

                try {
                    return JSON.parse(text);
                } catch (error) {
                    console.error('Không thể phân tích JSON hợp lệ từ phản hồi:', text);
                    throw new Error('Server trả về dữ liệu không hợp lệ.');
                }
            }

            function openAddUserModal() {
                document.getElementById('modalTitle').textContent = 'Add New User';
                document.getElementById('userForm').reset();
                document.getElementById('userId').value = '';
                document.getElementById('actionField').value = 'save';
                document.getElementById('password').required = true;
                clearAllErrors();
                isEditMode = false;
                document.getElementById('userModal').classList.add('show');
            }

            function closeUserModal() {
                document.getElementById('userModal').classList.remove('show');
                clearAllErrors();
                isEditMode = false;
            }

            function clearAllErrors() {
                document.getElementById('usernameError').style.display = 'none';
                document.getElementById('passwordError').style.display = 'none';
                document.getElementById('formError').style.display = 'none';
                document.getElementById('username').classList.remove('error', 'success');
                document.getElementById('password').classList.remove('error', 'success');
            }

            function clearUsernameError() {
                const usernameInput = document.getElementById('username');
                const errorDiv = document.getElementById('usernameError');
                usernameInput.classList.remove('error', 'success');
                errorDiv.style.display = 'none';
            }

            function showError(fieldId, message) {
                const errorDiv = document.getElementById(fieldId + 'Error');
                const input = document.getElementById(fieldId);
                if (errorDiv && input) {
                    errorDiv.textContent = message;
                    errorDiv.style.display = 'block';
                    input.classList.add('error');
                    input.classList.remove('success');
                }
            }

            function showSuccess(fieldId, message) {
                const errorDiv = document.getElementById(fieldId + 'Error');
                const input = document.getElementById(fieldId);
                if (errorDiv && input) {
                    errorDiv.textContent = message || '';
                    errorDiv.style.display = message ? 'block' : 'none';
                    input.classList.add('success');
                    input.classList.remove('error');
                }
            }

            function clearError(fieldId) {
                const errorDiv = document.getElementById(fieldId + 'Error');
                const input = document.getElementById(fieldId);
                if (errorDiv && input) {
                    errorDiv.style.display = 'none';
                    input.classList.remove('error', 'success');
                }
            }

            function validateUsername() {
                const username = document.getElementById('username').value.trim();

                if (username.length === 0) {
                    showError('username', 'Username không được để trống.');
                    return false;
                }

                if (username.length < 3 || username.length > 50) {
                    showError('username', 'Username phải có từ 3–50 ký tự.');
                    return false;
                }

                if (!username.match(/^[A-Za-z0-9._-]+$/)) {
                    showError('username', 'Username chỉ được chứa chữ, số, dấu \'.\', \'-\' hoặc \'_\'.');
                    return false;
                }

                clearError('username');
                return true;
            }

            function validatePassword() {
                const passwordInput = document.getElementById('password');
                const password = passwordInput.value;
                const isRequired = passwordInput.required;
                
                // If editing and password is not required, skip validation if empty
                if (!isRequired && password.length === 0) {
                    clearError('password');
                    return true;
                }

                // If password is required but empty
                if (isRequired && password.length === 0) {
                    showError('password', 'Password không được để trống.');
                    return false;
                }

                // If password is provided, validate format
                if (password.length > 0) {
                    if (password.length < 8) {
                        showError('password', 'Mật khẩu phải có ít nhất 8 ký tự.');
                        return false;
                    }

                    if (!password.match(/(?=.*[A-Z])(?=.*[a-z])(?=.*\d).*/)) {
                        showError('password', 'Mật khẩu phải gồm 1 chữ hoa, 1 chữ thường và 1 số.');
                        return false;
                    }
                }

                // Password is valid
                if (password.length > 0) {
                    clearError('password');
                    passwordInput.classList.add('success');
                    passwordInput.classList.remove('error');
                } else {
                    clearError('password');
                }
                return true;
            }

            async function checkUsernameAvailability(username, userId) {
                const url = '${pageContext.request.contextPath}/admin/users?action=checkUsername&username=' +
                            encodeURIComponent(username) +
                            (userId ? '&userId=' + userId : '');

                const data = await fetchJson(url);

                if (data.exists) {
                    showError('username', data.message);
                    return false;
                }

                clearError('username');
                return true;
            }

            function editUser(userId) {
                fetchJson('${pageContext.request.contextPath}/admin/users?action=getUser&id=' + userId)
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
                            clearAllErrors();
                            isEditMode = true;
                            document.getElementById('userModal').classList.add('show');
                        })
                        .catch(error => {
                            console.error('Error loading user data:', error);
                            alert('Không thể tải thông tin người dùng: ' + error.message);
                        });
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

            function sortTable(column) {
                const urlParams = new URLSearchParams(window.location.search);
                const currentSortField = urlParams.get('sortField') || 'CreatedDate';
                const currentSortOrder = urlParams.get('sortOrder') || 'DESC';
                let newSortOrder = 'ASC';

                if (currentSortField === column) {
                    newSortOrder = (currentSortOrder === 'ASC') ? 'DESC' : 'ASC';
                }
                
                urlParams.set('sortField', column);
                urlParams.set('sortOrder', newSortOrder);
                urlParams.set('page', '1');

                window.location.href = '${pageContext.request.contextPath}/admin/users?' + urlParams.toString();
            }

            function changePageSize(newSize) {
                const urlParams = new URLSearchParams(window.location.search);
                urlParams.set('pageSize', newSize);
                urlParams.set('page', '1');

                window.location.href = '${pageContext.request.contextPath}/admin/users?' + urlParams.toString();
            }

            // Handle form submit with AJAX
            async function handleFormSubmit(event) {
                event.preventDefault();

                document.getElementById('formError').style.display = 'none';

                const usernameValid = validateUsername();
                const passwordValid = validatePassword();

                if (!usernameValid) {
                    document.getElementById('formError').textContent = 'Vui lòng sửa lỗi username trước khi tiếp tục.';
                    document.getElementById('formError').style.display = 'block';
                    return;
                }

                if (!passwordValid) {
                    document.getElementById('formError').textContent = 'Vui lòng sửa lỗi password trước khi tiếp tục.';
                    document.getElementById('formError').style.display = 'block';
                    return;
                }

                const username = document.getElementById('username').value.trim();
                const userId = document.getElementById('userId').value;

                try {
                    const isAvailable = await checkUsernameAvailability(username, userId);
                    if (!isAvailable) {
                        document.getElementById('formError').textContent = 'Vui lòng sửa lỗi username trước khi tiếp tục.';
                        document.getElementById('formError').style.display = 'block';
                        return;
                    }
                } catch (error) {
                    console.error('Error checking username:', error);
                    document.getElementById('formError').textContent = 'Không thể kiểm tra username: ' + error.message;
                    document.getElementById('formError').style.display = 'block';
                    return;
                }

                await submitForm();
            }

            async function submitForm() {
                const form = document.getElementById('userForm');
                const formData = new FormData(form);
                const submitBtn = document.getElementById('submitBtn');
                
                submitBtn.disabled = true;
                submitBtn.textContent = 'Đang xử lý...';
                
                try {
                    const data = await fetchJson('${pageContext.request.contextPath}/admin/users', {
                        method: 'POST',
                        body: formData
                    });

                    if (Object.keys(data).length === 0) {
                        console.warn('Server trả về phản hồi rỗng, giả định thao tác thành công.');
                        closeUserModal();
                        window.location.reload();
                        return;
                    }

                    if (data.success) {
                        alert(data.message || 'Thành công!');
                        closeUserModal();
                        window.location.reload();
                    } else {
                        // Show error message
                        document.getElementById('formError').textContent = data.message || 'Có lỗi xảy ra. Vui lòng thử lại.';
                        document.getElementById('formError').style.display = 'block';
                        // Try to identify which field has error
                        if (data.message && data.message.includes('Username')) {
                            showError('username', data.message);
                        } else if (data.message && data.message.includes('Mật khẩu')) {
                            showError('password', data.message);
                        }
                    }
                } catch (error) {
                    console.error('Error:', error);
                    document.getElementById('formError').textContent = error.message || 'Có lỗi xảy ra khi kết nối đến server.';
                    document.getElementById('formError').style.display = 'block';
                } finally {
                    submitBtn.disabled = false;
                    submitBtn.textContent = 'Save User';
                }
            }

            // Close modal when clicking outside
            window.onclick = function (event) {
                const userModal = document.getElementById('userModal');
                const resetModal = document.getElementById('resetPasswordModal');

                if (event.target == userModal) {
                    userModal.classList.remove('show');
                    clearAllErrors();
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

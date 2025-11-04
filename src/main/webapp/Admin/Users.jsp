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
    <style>
        .error-text {
            color: #dc2626;
            font-size: 13px;
            font-weight: 500;
            margin-top: 5px;
            display: block;
        }

        .input-error {

            border: 2px solid #ef4444 !important;
            background-color: #fef2f2;
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.2);
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
                    <a href="${pageContext.request.contextPath}/admin?action=departments"
                       class="nav-item ${activePage == 'departments' ? 'active' : ''}">🏢 Departments</a>
                    <a href="${pageContext.request.contextPath}/admin/users"
                       class="nav-item ${activePage == 'users' ? 'active' : ''}">👤 Users</a>
                    <a href="${pageContext.request.contextPath}/admin/role/list"
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
                                                <td>${empty user.employee ? 'N/A' : user.employee.fullName}</td>
                                                <td>${empty user.department ? 'N/A' : user.department.deptName}</td>
                                                <td>${empty user.role ? 'N/A' : user.role.roleName}</td>
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
                        <%-- Build base URL with all filter parameters --%>
                        <c:url var="baseUrl" value="/admin/users">
                            <c:if test="${not empty param.roleFilter}">
                                <c:param name="roleFilter" value="${param.roleFilter}" />
                            </c:if>
                            <c:if test="${not empty param.statusFilter}">
                                <c:param name="statusFilter" value="${param.statusFilter}" />
                            </c:if>
                            <c:if test="${not empty param.departmentFilter}">
                                <c:param name="departmentFilter" value="${param.departmentFilter}" />
                            </c:if>
                            <c:if test="${not empty param.usernameFilter}">
                                <c:param name="usernameFilter" value="${param.usernameFilter}" />
                            </c:if>
                        </c:url>

                        <!-- First and Previous Buttons -->
                        <c:if test="${currentPage > 1}">
                            <c:url var="firstPageUrl" value="${baseUrl}"><c:param name="page" value="1" /></c:url>
                            <a href="${firstPageUrl}">First</a>
                            <c:url var="prevPageUrl" value="${baseUrl}"><c:param name="page" value="${currentPage - 1}" /></c:url>
                            <a href="${prevPageUrl}">Previous</a>
                        </c:if>

                        <!-- Page Numbers -->
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="active">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <c:url var="pageUrl" value="${baseUrl}"><c:param name="page" value="${i}" /></c:url>
                                    <a href="${pageUrl}">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <!-- Next and Last Buttons -->
                        <c:if test="${currentPage < totalPages}">
                            <c:url var="nextPageUrl" value="${baseUrl}"><c:param name="page" value="${currentPage + 1}" /></c:url>
                            <a href="${nextPageUrl}">Next</a>
                            <c:url var="lastPageUrl" value="${baseUrl}"><c:param name="page" value="${totalPages}" /></c:url>
                            <a href="${lastPageUrl}">Last</a>
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
                <form id="userForm" >
                    <input type="hidden" id="userId" name="id">
                    <input type="hidden" id="actionField" name="action" value="save">

                    <div class="form-group">
                        <label for="username">Username *</label>
                        <input type="text" id="username" name="username" required>
                        <small class="form-hint">Username must be unique and contain 3-50 characters</small>
                        <small class="error-text" id="error-username"></small>
                    </div>

                    <div class="form-group">
                        <label for="password">Password *</label>
                        <input type="password" id="password" name="password" required **autocomplete="new-password"**>
                        <small class="form-hint">Password must be at least 8 characters</small>
                        <small class="error-text" id="error-password"></small>
                    </div>

                    <div class="form-group">
                        <label for="employeeId">Employee *</label>
                        <select id="employeeId" name="employeeId" required>
                            <option value="">Select Employee</option>
                            <c:forEach var="employee" items="${employees}">
                                <option value="${employee.employeeId}">${employee.fullName}</option>
                            </c:forEach>
                        </select>
                        <small class="error-text" id="error-employee"></small>
                    </div>

                    <div class="form-group">
                        <label for="roleId">Role *</label>
                        <select id="roleId" name="roleId" required>
                            <option value="">Select Role</option>
                            <c:forEach var="role" items="${roles}">
                                <option value="${role.roleId}">${role.roleName}</option>
                            </c:forEach>
                        </select>
                        <small class="error-text" id="error-role"></small>
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
                if (confirm("Bạn có chắc muốn đặt lại mật khẩu không? Mật khẩu tạm thời mới sẽ được tạo ngẫu nhiên.")) {
                    // 💡 Gửi request POST
                    fetch('${pageContext.request.contextPath}/admin/users', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        // Thêm action=resetPassword vào body
                        body: 'action=resetPassword&id=' + userId
                    }).then(async res => {
                        const data = await res.json();

                        if (res.ok) { // Kiểm tra status code 200-299
                            // Thành công: Hiển thị mật khẩu tạm thời mới từ server
                            alert("Đặt lại mật khẩu thành công!\n" + data.message);
                            // Không cần reload toàn bộ trang, nhưng nên cập nhật lại danh sách nếu cần
                            // Ở đây, tôi chọn reload để đồng bộ nhanh chóng
                            window.location.reload();
                        } else { // Xử lý lỗi (ví dụ: 400, 500)
                            alert("Lỗi: " + data.message);
                        }
                    }).catch(err => {
                        alert('Lỗi kết nối hoặc xử lý dữ liệu: ' + err.message);
                    });
                }
            }



            function toggleUserStatus(userId) {
                if (confirm('Bạn có chắc muốn thay đổi trạng thái tài khoản này không?')) {
                    window.location.href = '${pageContext.request.contextPath}/admin/users?action=toggleStatus&id=' + userId;
                }
            }



            function deleteUser(userId) {
                if (confirm('Are you sure you want to delete this user?')) {
                    fetch('${pageContext.request.contextPath}/admin/users', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: 'action=delete&id=' + userId
                    }).then(() => window.location.reload());
                }
            }


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
        <script>
            document.addEventListener("DOMContentLoaded", () => {
                const userForm = document.getElementById("userForm");
                if (!userForm)
                    return;

                userForm.addEventListener("submit", async (event) => {
                    event.preventDefault(); // chặn reload GET

                    const formData = new FormData(userForm);

                    try {
                        const formData = new FormData(userForm);
                        // 💡 BIẾN ĐỔI: Chuyển FormData thành URLSearchParams
                        const urlEncodedData = new URLSearchParams(formData);

                        const res = await fetch("${pageContext.request.contextPath}/admin/users", {
                            method: "POST",
                            // 💡 BIẾN ĐỔI: Chỉ định Content-Type
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded'
                            },
                            // 💡 BIẾN ĐỔI: Gửi dữ liệu đã được mã hóa
                            body: urlEncodedData
                        });

                        const text = await res.text();
                        if (!text.trim())
                            throw new Error("Empty response from server");

                        let data;
                        try {
                            data = JSON.parse(text);
                        } catch (e) {
                            throw new Error("Invalid JSON: " + text);
                        }

                        if (!data.success) {
                            alert(data.message);
                        } else {
                            alert(data.message);
                            window.location.reload();
                        }
                    } catch (err) {
                        alert("Lỗi gửi dữ liệu: " + err.message);
                    }
                });
            });
        </script>


    </body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Role Management</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="css/user-menu.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/Admin_home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/roles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/pagination.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/user-menu.css">

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        const contextPath = '${pageContext.request.contextPath}';
    </script>
    <script src="${pageContext.request.contextPath}/Admin/js/role-management.js"></script>
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
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="rolesTableBody">
                        <!-- Roles will be loaded dynamically -->
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
            <form id="roleForm">
                <div class="form-group">
                    <label for="roleName">Role Name *</label>
                    <input type="text" id="roleName" name="roleName" required placeholder="e.g., Manager, HR, Finance">
                </div>

                <div class="form-actions">
                    <button type="button" class="btn-cancel" onclick="closeRoleModal()">Cancel</button>
                    <button type="submit" class="btn-submit">Save Role</button>
                </div>
            </form>
        </div>
    </div>

    <!-- role-management.js handles modal, fetch, pagination and filtering -->

    <link rel="stylesheet" href="${pageContext.request.contextPath}/Admin/css/department.css">
</body>
</html>

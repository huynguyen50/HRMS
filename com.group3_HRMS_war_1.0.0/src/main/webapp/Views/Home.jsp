<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HRM - Home</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-color: #667eea;
                --secondary-color: #764ba2;
            }
            body {
                background-color: #f8f9fa;
            }
            .sidebar {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                min-height: 100vh;
                color: white;
            }
            .sidebar .nav-link {
                color: rgba(255, 255, 255, 0.8);
                padding: 12px 20px;
                margin: 5px 10px;
                border-radius: 10px;
                transition: all 0.3s;
            }
            .sidebar .nav-link:hover,
            .sidebar .nav-link.active {
                background: rgba(255, 255, 255, 0.2);
                color: white;
            }
            .main-content {
                padding: 20px;
            }
            .quick-action-btn {
                display: flex;
                flex-direction: column;
                align-items: center;
                padding: 20px;
                border: 2px solid #e9ecef;
                border-radius: 15px;
                text-decoration: none;
                color: #495057;
                transition: all 0.3s;
                margin-bottom: 15px;
                height: 100%;
            }
            .quick-action-btn:hover {
                border-color: var(--primary-color);
                color: var(--primary-color);
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.2);
            }
            .quick-action-btn i {
                font-size: 2.5rem;
                margin-bottom: 15px;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <nav class="col-md-3 col-lg-2 d-md-block sidebar collapse">
                    <div class="position-sticky pt-3">
                        <div class="text-center mb-4">
                            <h4><i class="fas fa-users-cog me-2"></i>HRM System</h4>
                        </div>
                        <ul class="nav flex-column">
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/Views/Home.jsp">
                                    <i class="fas fa-home me-2"></i> Home
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/Views/Dashboard.jsp">
                                    <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/Views/EmployeeList.jsp">
                                    <i class="fas fa-users me-2"></i> Employee List
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/employees?action=new">
                                    <i class="fas fa-user-plus me-2"></i> Add Employee
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/candidate">
                                    <i class="fas fa-user-plus me-2"></i> View Candidate
                                </a>
                            </li>
                        </ul>
                        <hr class="text-white-50">
                        <div class="user-info p-3 d-flex align-items-center">
                            <div class="user-avatar me-2">
                                <i class="fas fa-user-circle fa-2x"></i>
                            </div>
                            <div>
                                <div class="fw-bold">${sessionScope.systemUser.username}</div>
                            </div>
                        </div>
                        <ul class="nav flex-column">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/Views/Profile.jsp">
                                    <i class="fas fa-user me-2"></i> Profile
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/Views/ChangePassword.jsp">
                                    <i class="fas fa-key me-2"></i> Change Password
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                                    <i class="fas fa-sign-out-alt me-2"></i> Logout
                                </a>
                            </li>
                        </ul>
                    </div>
                </nav>

                <!-- Main content -->
                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                    <div class="page-header mb-4">
                        <h1 class="h2">Home</h1>
                        <p class="text-muted">Welcome back, ${systemUser.username}!</p>
                    </div>

                    <div class="row">
                        <div class="col-md-4 mb-4">
                            <a href="${pageContext.request.contextPath}/Views/Dashboard.jsp" class="quick-action-btn">
                                <i class="fas fa-tachometer-alt text-primary"></i>
                                <span>Dashboard</span>
                            </a>
                        </div>
                        <div class="col-md-4 mb-4">
                            <a href="${pageContext.request.contextPath}/admin/employees" class="quick-action-btn">
                                <i class="fas fa-users text-success"></i>
                                <span>Employee List</span>
                            </a>
                        </div>
                        <div class="col-md-4 mb-4">
                            <a href="${pageContext.request.contextPath}/admin/employees?action=new" class="quick-action-btn">
                                <i class="fas fa-user-plus text-info"></i>
                                <span>Add Employee</span>
                            </a>
                        </div>
                        <div class="col-md-4 mb-4">
                            <a href="${pageContext.request.contextPath}/Views/Profile.jsp" class="quick-action-btn">
                                <i class="fas fa-user-circle text-warning"></i>
                                <span>Your Profile</span>
                            </a>
                        </div>
                        <div class="col-md-4 mb-4">
                            <a href="#" class="quick-action-btn">
                                <i class="fas fa-tasks text-danger"></i>
                                <span>Task Management</span>
                            </a>
                        </div>
                        <div class="col-md-4 mb-4">
                            <a href="${pageContext.request.contextPath}/agenda" class="quick-action-btn">
                                <i class="fas fa-calendar-alt text-primary"></i>
                                <span>Agenda</span>
                            </a>
                        </div>
                        <div class="col-md-4 mb-4">
                            <a href="${pageContext.request.contextPath}/Views/leave_create.jsp" class="quick-action-btn">
                                <i class="fas fa-file-alt text-secondary"></i>
                                <span>Requests & Forms</span>
                            </a>

                        </div>

                    </div>

                    <!-- Agenda preview -->
                    <div class="row">
                        <div class="col-12">
                            <div class="card" style="border-radius: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.05);">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5 class="mb-0"><i class="fas fa-calendar-alt me-2 text-primary"></i>Agenda</h5>
                                        <a href="${pageContext.request.contextPath}/agenda" class="btn btn-sm btn-outline-primary">View all</a>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead>
                                                <tr>
                                                    <th scope="col">Title</th>
                                                    <th scope="col">Assignee</th>
                                                    <th scope="col">Start</th>
                                                    <th scope="col">Due</th>
                                                    <th scope="col">Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${not empty tasksUpcoming}">
                                                        <c:forEach items="${tasksUpcoming}" var="task" varStatus="loop">
                                                            <c:if test="${loop.index < 5}">
                                                                <tr>
                                                                    <td>${task.title}</td>
                                                                    <td>${empty task.assignToName ? '-' : task.assignToName}</td>
                                                                    <td>
                                                                        <c:if test="${not empty task.startDate}">
                                                                            <fmt:formatDate value="${task.startDate}" pattern="dd/MM/yyyy"/>
                                                                        </c:if>
                                                                    </td>
                                                                    <td>
                                                                        <c:if test="${not empty task.dueDate}">
                                                                            <fmt:formatDate value="${task.dueDate}" pattern="dd/MM/yyyy"/>
                                                                        </c:if>
                                                                    </td>
                                                                    <td>
                                                                        <span class="badge bg-${task.status == 'Completed' ? 'success' : (task.status == 'In Progress' ? 'warning' : 'secondary')}">${task.status}</span>
                                                                    </td>
                                                                </tr>
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr>
                                                            <td colspan="5" class="text-muted">No upcoming items. <a href="${pageContext.request.contextPath}/Views/Agenda.jsp">Create or view agenda</a>.</td>
                                                        </tr>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

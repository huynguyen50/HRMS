
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HR - HRM System</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-color: #667eea;
                --secondary-color: #764ba2;
                --success-color: #28a745;
                --warning-color: #ffc107;
                --danger-color: #dc3545;
                --info-color: #17a2b8;
            }

            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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

            .stat-card {
                border: none;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
                transition: all 0.3s;
                overflow: hidden;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            }

            .stat-card .card-body {
                padding: 25px;
            }

            .stat-icon {
                width: 60px;
                height: 60px;
                border-radius: 15px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                margin-bottom: 15px;
            }

            .stat-primary {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
            }
            .stat-success {
                background: linear-gradient(135deg, #28a745, #20c997);
                color: white;
            }
            .stat-warning {
                background: linear-gradient(135deg, #ffc107, #fd7e14);
                color: white;
            }
            .stat-danger {
                background: linear-gradient(135deg, #dc3545, #e83e8c);
                color: white;
            }
            .stat-info {
                background: linear-gradient(135deg, #17a2b8, #6f42c1);
                color: white;
            }

            .page-header {
                background: white;
                border-radius: 15px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }

            .user-info {
                display: flex;
                align-items: center;
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: bold;
                margin-right: 10px;
            }

            .chart-container {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                margin-bottom: 30px;
            }

            .quick-actions {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
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
            }

            .quick-action-btn:hover {
                border-color: var(--primary-color);
                color: var(--primary-color);
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.2);
            }

            .quick-action-btn i {
                font-size: 2rem;
                margin-bottom: 10px;
            }

            @media (max-width: 768px) {
                .sidebar {
                    min-height: auto;
                }

                .main-content {
                    padding: 10px;
                }

                .stat-card .card-body {
                    padding: 15px;
                }
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
                                <a class="nav-link" href="${pageContext.request.contextPath}/Views/Home.jsp">
                                    <i class="fas fa-home me-2"></i>
                                    Home
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link active" href="#">
                                    <i class="fas fa-tachometer-alt me-2"></i>
                                    Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/Views/EmployeeList.jsp">
                                    <i class="fas fa-users me-2"></i>
                                    Staff
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-tasks me-2"></i>
                                    Work
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-envelope me-2"></i>
                                    Application
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-money-check-alt me-2"></i>
                                    Requets
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-briefcase me-2"></i>
                                    Recruitment
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-chart-bar me-2"></i>
                                    Report
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-cog me-2"></i>
                                    Setting
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
                                    <i class="fas fa-user me-2"></i>
                                    Profile
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/change-password">
                                    <i class="fas fa-key me-2"></i>
                                    Change Password
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                                    <i class="fas fa-sign-out-alt me-2"></i>
                                    Logout
                                </a>
                            </li>
                        </ul>
                    </div>
                </nav>

                <!-- Main content -->
                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                    <!-- Page Header -->
                    <div class="page-header">
                        <div class="row align-items-center">
                            <div class="col">
                                <h1 class="h3 mb-0">Dashboard</h1>
                                <p class="text-muted mb-0">Welcome back, ${sessionScope.systemUser.username}!</p>
                            </div>
                            <div class="col-auto">
                                <span class="badge bg-success">
                                    <i class="fas fa-circle me-1"></i>
                                    Online
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Statistics Cards -->
                    <div class="row mb-4">
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stat-card">
                                <div class="card-body">
                                    <div class="stat-icon stat-primary">
                                        <i class="fas fa-users"></i>
                                    </div>
                                    <h3 class="card-title mb-2">${totalEmployees}</h3>
                                    <p class="card-text text-muted">Total Employees</p>
                                    <small class="text-success">
                                        <i class="fas fa-arrow-up me-1"></i>
                                        ${activeEmployees} Active
                                    </small>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stat-card">
                                <div class="card-body">
                                    <div class="stat-icon stat-warning">
                                        <i class="fas fa-tasks"></i>
                                    </div>
                                    <h3 class="card-title mb-2">${pendingTasks}</h3>
                                    <p class="card-text text-muted">Pending Tasks</p>
                                    <small class="text-warning">
                                        <i class="fas fa-clock me-1"></i>
                                        Update required
                                    </small>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stat-card">
                                <div class="card-body">
                                    <div class="stat-icon stat-info">
                                        <i class="fas fa-envelope"></i>
                                    </div>
                                    <h3 class="card-title mb-2">${pendingRequests}</h3>
                                    <p class="card-text text-muted">Pending Requests</p>
                                    <small class="text-info">
                                        <i class="fas fa-hourglass-half me-1"></i>
                                        In Progress
                                    </small>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card stat-card">
                                <div class="card-body">
                                    <div class="stat-icon stat-success">
                                        <i class="fas fa-money-check-alt"></i>
                                    </div>
                                    <h3 class="card-title mb-2">
                                        <fmt:formatNumber value="${thisMonthPayroll}" type="currency" currencyCode="VND"/>
                                    </h3>
                                    <p class="card-text text-muted">This Month's Payroll</p>
                                    <small class="text-success">
                                        <i class="fas fa-check-circle me-1"></i>
                                        Approved
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="chart-container">
                                <h5 class="mb-4">Quick Actions</h5>
                                <div class="row">
                                    <div class="col-md-4">
                                        <a href="#" class="quick-action-btn">
                                            <i class="fas fa-user-plus text-primary"></i>
                                            <span>Add Employee</span>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="#" class="quick-action-btn">
                                            <i class="fas fa-plus-circle text-success"></i>
                                            <span>Create Task</span>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="#" class="quick-action-btn">
                                            <i class="fas fa-file-alt text-warning"></i>
                                            <span>Request Leave</span>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="#" class="quick-action-btn">
                                            <i class="fas fa-calculator text-info"></i>
                                            <span>Calculate Payroll</span>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="#" class="quick-action-btn">
                                            <i class="fas fa-bullhorn text-danger"></i>
                                            <span>Post Recruitment</span>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="#" class="quick-action-btn">
                                            <i class="fas fa-chart-line text-secondary"></i>
                                            <span>View Reports</span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-4">
                            <div class="quick-actions">
                                <h5 class="mb-4">Notifications</h5>
                                <div class="list-group">
                                    <a href="#" class="list-group-item list-group-item-action">
                                        <div class="d-flex w-100 justify-content-between">
                                            <h6 class="mb-1">New Task Assigned</h6>
                                            <small>time</small>
                                        </div>
                                        <p class="mb-1"></p>
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action">
                                        <div class="d-flex w-100 justify-content-between">
                                            <h6 class="mb-1">Request Approved</h6>
                                            <small>time</small>
                                        </div>
                                        <p class="mb-1">Your leave request has been approved.</p>
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action">
                                        <div class="d-flex w-100 justify-content-between">
                                            <h6 class="mb-1">Payroll Processed</h6>
                                            <small></small>
                                        </div>
                                        <p class="mb-1"></p>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Auto-refresh dashboard every 5 minutes
            setInterval(function () {
                location.reload();
            }, 300000);

            // Add active state to current menu item
            document.querySelectorAll('.nav-link').forEach(link => {
                if (link.classList.contains('active')) {
                    link.style.background = 'rgba(255, 255, 255, 0.2)';
                }
            });
        </script>
    </body>
</html>

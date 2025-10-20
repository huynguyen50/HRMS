<%-- 
    Document   : TaskManagement
    Created on : Oct 20, 2025, 9:23:17 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Task Management - HR System</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hr-dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hr-dashboard-backup.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .btn-homepage {
                background: rgba(255,255,255,0.2) !important;
                color: white !important;
                padding: 0.5rem 1rem !important;
                border-radius: 25px !important;
                text-decoration: none !important;
                display: flex !important;
                align-items: center !important;
                gap: 0.5rem !important;
                transition: all 0.3s ease !important;
                border: 1px solid rgba(255,255,255,0.3) !important;
                margin-left: 0.5rem !important;
            }
            .btn-homepage:hover {
                background: rgba(255,255,255,0.3) !important;
                transform: translateY(-2px) !important;
                box-shadow: 0 4px 15px rgba(0,0,0,0.2) !important;
            }
            .btn-homepage i {
                font-size: 1rem !important;
            }
            .btn-homepage span {
                font-weight: 500 !important;
            }
        </style>
    </head>
    <body>
        <div class="hr-dashboard-container">
            <!-- Header -->
            <header class="hr-header">
                <div class="header-content">
                    <div class="logo-section">
                        <i class="fas fa-tasks"></i>
                        <h1>Task Management</h1>
                    </div>
                    <div class="header-actions">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" id="searchInput" placeholder="Search tasks...">
                        </div>
                        <div class="user-profile">
                            <img src="https://i.pravatar.cc/40" alt="HR User">
                            <span>HR Manager</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <a href="${pageContext.request.contextPath}/ProfileManagementController" class="btn-homepage" title="Back to HR Dashboard">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>HR Dashboard</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/homepage" class="btn-homepage" title="Back to Homepage">
                            <i class="fas fa-home"></i>
                            <span>Homepage</span>
                        </a>
                    </div>
                </div>
            </header>

            <!-- Main Content -->
            <main class="hr-main-content">
                <!-- Sidebar -->
                <aside class="hr-sidebar">
                    <nav class="hr-nav">
                        <div class="nav-section">
                            <h3>Navigation</h3>
                            <a href="/HRMS/Views/hr/HrHome.jsp" class="nav-item">
                                <i class="fas fa-home"></i>
                                <span>HR Dashboard</span>
                            </a>
                            <a href="/HRMS/ProfileManagementController" class="nav-item">
                                <i class="fas fa-user-edit"></i>
                                <span>Profile Management</span>
                            </a>
                            <a href="/HRMS/EmploymentStatusController" class="nav-item">
                                <i class="fas fa-user-check"></i>
                                <span>Employment Status</span>
                            </a>
                            <a href="/HRMS/TaskManagementController" class="nav-item active">
                                <i class="fas fa-tasks"></i>
                                <span>Task Management</span>
                            </a>
                        </div>
                    </nav>
                </aside>

                <!-- Content Area -->
                <div class="hr-content-area">
                    <section class="content-section active">
                        <div class="section-header">
                            <h2>Task Management</h2>
                            <p>Assign tasks to employees and track progress</p>
                        </div>
                        
                        <div class="task-management-tabs">
                            <button class="tab-btn active" data-tab="assign-tasks">Assign Tasks</button>
                            <button class="tab-btn" data-tab="task-progress">Track Progress</button>
                            <button class="tab-btn" data-tab="completed-tasks">Completed</button>
                        </div>
                        
                        <div class="tab-content">
                            <div id="assign-tasks" class="tab-panel active">
                                <div class="task-assignment-form">
                                    <h3>New Task Assignment</h3>
                                    <form method="POST" action="/HRMS/TaskManagementController">
                                        <input type="hidden" name="action" value="createTask">
                                        <div class="form-group">
                                            <label>Select Employee:</label>
                                            <select name="assignTo" class="form-select" required>
                                                <option value="">Select Employee</option>
                                                <c:forEach var="employee" items="${employees}">
                                                    <option value="${employee.employeeId}">${employee.fullName} - ${employee.departmentName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label>Task Title:</label>
                                            <input type="text" name="title" class="form-input" placeholder="Enter task title" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Detailed Description:</label>
                                            <textarea name="description" class="form-textarea" placeholder="Describe the task in detail" required></textarea>
                                        </div>
                                        <div class="form-group">
                                            <label>Deadline:</label>
                                            <input type="date" name="dueDate" class="form-input" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Priority:</label>
                                            <select name="status" class="form-select">
                                                <option value="Pending">Pending</option>
                                                <option value="In Progress">In Progress</option>
                                                <option value="Completed">Completed</option>
                                                <option value="Rejected">Rejected</option>
                                            </select>
                                        </div>
                                        <input type="hidden" name="assignedBy" value="1">
                                        <button type="submit" class="btn-primary">
                                            <i class="fas fa-paper-plane"></i>
                                            Assign Task
                                        </button>
                                    </form>
                                </div>
                            </div>
                            
                            <div id="task-progress" class="tab-panel">
                                <div class="task-list">
                                    <h3>All Tasks</h3>
                                    <c:choose>
                                        <c:when test="${not empty tasks}">
                                            <c:forEach var="task" items="${tasks}">
                                                <div class="task-card">
                                                    <div class="task-info">
                                                        <h4>${task.title}</h4>
                                                        <p><strong>Description:</strong> ${task.description}</p>
                                                        <p><strong>Assigned To:</strong> 
                                                            <c:forEach var="emp" items="${employees}">
                                                                <c:if test="${emp.employeeId == task.assignTo}">
                                                                    ${emp.fullName}
                                                                </c:if>
                                                            </c:forEach>
                                                        </p>
                                                        <p><strong>Due Date:</strong> ${task.dueDate}</p>
                                                        <p><strong>Status:</strong> <span class="status-badge ${task.status.toLowerCase().replace(' ', '-')}">${task.status}</span></p>
                                                    </div>
                                                    <div class="task-actions">
                                                        <button class="btn-secondary">
                                                            <i class="fas fa-edit"></i>
                                                            Edit
                                                        </button>
                                                        <button class="btn-primary">
                                                            <i class="fas fa-eye"></i>
                                                            View Details
                                                        </button>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-data">
                                                <i class="fas fa-tasks"></i>
                                                <h3>No tasks found</h3>
                                                <p>There are no tasks to display at the moment.</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <div id="completed-tasks" class="tab-panel">
                                <div class="task-list">
                                    <h3>Completed Tasks</h3>
                                    <c:choose>
                                        <c:when test="${not empty tasks}">
                                            <c:forEach var="task" items="${tasks}">
                                                <c:if test="${task.status == 'Completed'}">
                                                    <div class="task-card completed">
                                                        <div class="task-info">
                                                            <h4>${task.title}</h4>
                                                            <p><strong>Description:</strong> ${task.description}</p>
                                                            <p><strong>Assigned To:</strong> 
                                                            <c:forEach var="emp" items="${employees}">
                                                                <c:if test="${emp.employeeId == task.assignTo}">
                                                                    ${emp.fullName}
                                                                </c:if>
                                                            </c:forEach>
                                                        </p>
                                                            <p><strong>Due Date:</strong> ${task.dueDate}</p>
                                                            <p><strong>Status:</strong> <span class="status-badge completed">Completed</span></p>
                                                        </div>
                                                        <div class="task-actions">
                                                            <button class="btn-success">
                                                                <i class="fas fa-check"></i>
                                                                Completed
                                                            </button>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-data">
                                                <i class="fas fa-check-circle"></i>
                                                <h3>No completed tasks</h3>
                                                <p>There are no completed tasks to display.</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        
                        <c:if test="${not empty error}">
                            <div class="error-message">
                                <i class="fas fa-exclamation-triangle"></i>
                                ${error}
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty success}">
                            <div class="success-message">
                                <i class="fas fa-check-circle"></i>
                                ${success}
                            </div>
                        </c:if>
                    </section>
                </div>
            </main>
        </div>

        <script>
            // Tab functionality
            document.querySelectorAll('.tab-btn').forEach(btn => {
                btn.addEventListener('click', function() {
                    // Remove active class from all buttons and panels
                    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
                    document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
                    
                    // Add active class to clicked button
                    this.classList.add('active');
                    
                    // Show corresponding panel
                    const tabId = this.getAttribute('data-tab');
                    document.getElementById(tabId).classList.add('active');
                });
            });

            // Search functionality
            document.getElementById('searchInput').addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase();
                const cards = document.querySelectorAll('.task-card');
                
                cards.forEach(card => {
                    const taskTitle = card.querySelector('h4').textContent.toLowerCase();
                    const taskDesc = card.querySelector('p').textContent.toLowerCase();
                    
                    if (taskTitle.includes(searchTerm) || taskDesc.includes(searchTerm)) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });

            // Auto-hide success/error messages after 5 seconds
            setTimeout(function() {
                const messages = document.querySelectorAll('.success-message, .error-message');
                messages.forEach(function(msg) {
                    msg.style.opacity = '0';
                    setTimeout(function() {
                        msg.remove();
                    }, 500);
                });
            }, 5000);
        </script>
    </body>
</html>
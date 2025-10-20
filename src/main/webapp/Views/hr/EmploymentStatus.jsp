<%-- 
    Document   : EmploymentStatus
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
        <title>Employment Status Management - HR System</title>
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
                        <i class="fas fa-users-cog"></i>
                        <h1>Employment Status Management</h1>
                    </div>
                    <div class="header-actions">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" id="searchInput" placeholder="Search employees...">
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
                            <a href="/HRMS/EmploymentStatusController" class="nav-item active">
                                <i class="fas fa-user-check"></i>
                                <span>Employment Status</span>
                            </a>
                        </div>
                    </nav>
                </aside>

                <!-- Content Area -->
                <div class="hr-content-area">
                    <section class="content-section active">
                        <div class="section-header">
                            <h2>Employment Status Management</h2>
                            <p>View and manage employee employment status</p>
                        </div>
                        
                        <div class="status-management">
                            <div class="status-filters">
                                <button class="filter-btn active" data-status="all">All</button>
                                <button class="filter-btn" data-status="Active">Active</button>
                                <button class="filter-btn" data-status="Probation">Probation</button>
                                <button class="filter-btn" data-status="Intern">Intern</button>
                                <button class="filter-btn" data-status="Resigned">Resigned</button>
                            </div>
                            
                            <div class="employee-status-list">
                                <c:choose>
                                    <c:when test="${not empty employees}">
                                        <c:forEach var="employee" items="${employees}">
                                            <div class="status-card" data-status="${employee.status}">
                                                <div class="employee-basic-info">
                                                    <img src="https://i.pravatar.cc/50?img=${employee.employeeId}" alt="Employee">
                                                    <div>
                                                        <h4>${employee.fullName}</h4>
                                                        <p>${employee.position} - ${employee.departmentName}</p>
                                                        <p><strong>Email:</strong> ${employee.email}</p>
                                                        <p><strong>Phone:</strong> ${employee.phone}</p>
                                                        <p><strong>Employment Period:</strong> ${employee.employmentPeriod}</p>
                                                        <span class="current-status ${employee.status.toLowerCase()}">${employee.status}</span>
                                                    </div>
                                                </div>
                                                <div class="status-actions">
                                                    <form method="POST" action="/HRMS/EmploymentStatusController" style="display: flex; gap: 10px; align-items: center;">
                                                        <input type="hidden" name="action" value="updateStatus">
                                                        <input type="hidden" name="employeeId" value="${employee.employeeId}">
                                                        <select name="status" class="status-select">
                                                            <option value="Active" ${employee.status == 'Active' ? 'selected' : ''}>Active</option>
                                                            <option value="Probation" ${employee.status == 'Probation' ? 'selected' : ''}>Probation</option>
                                                            <option value="Intern" ${employee.status == 'Intern' ? 'selected' : ''}>Intern</option>
                                                            <option value="Resigned" ${employee.status == 'Resigned' ? 'selected' : ''}>Resigned</option>
                                                        </select>
                                                        <button type="submit" class="btn-update-status">
                                                            <i class="fas fa-save"></i>
                                                            Update
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-data">
                                            <i class="fas fa-users-slash"></i>
                                            <h3>No employees found</h3>
                                            <p>There are no employees to display at the moment.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
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
            // Filter functionality
            document.querySelectorAll('.filter-btn').forEach(btn => {
                btn.addEventListener('click', function() {
                    // Remove active class from all buttons
                    document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
                    // Add active class to clicked button
                    this.classList.add('active');
                    
                    const status = this.getAttribute('data-status');
                    const cards = document.querySelectorAll('.status-card');
                    
                    cards.forEach(card => {
                        if (status === 'all' || card.getAttribute('data-status') === status) {
                            card.style.display = 'block';
                        } else {
                            card.style.display = 'none';
                        }
                    });
                });
            });

            // Search functionality
            document.getElementById('searchInput').addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase();
                const cards = document.querySelectorAll('.status-card');
                
                cards.forEach(card => {
                    const employeeName = card.querySelector('h4').textContent.toLowerCase();
                    const position = card.querySelector('p').textContent.toLowerCase();
                    
                    if (employeeName.includes(searchTerm) || position.includes(searchTerm)) {
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

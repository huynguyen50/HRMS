<%-- 
    Document   : PayrollManagement
    Created on : Nov 5, 2025
    Author     : admin
    Description: Payroll Approval Management for HR Manager - Review and approve/reject payrolls submitted by HR Staff
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.math.BigDecimal, java.text.NumberFormat, java.util.Locale, java.text.SimpleDateFormat" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Payroll Approval - HR Manager</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-color: #667eea;
                --secondary-color: #764ba2;
                --accent-color: #3b82f6;
                --success-color: #10b981;
                --warning-color: #f59e0b;
                --danger-color: #ef4444;
                --dark-color: #1f2937;
                --light-color: #f8f9fa;
                --text-color: #374151;
                --text-muted: #6b7280;
                --border-color: #e5e7eb;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                line-height: 1.6;
                color: var(--text-color);
                background-color: var(--light-color);
            }

            /* HR Dashboard Container */
            .hr-dashboard-container {
                min-height: 100vh;
                background-color: var(--light-color);
            }

            /* Header */
            .hr-header {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                color: white;
                padding: 1rem 0;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .header-content {
                max-width: 1400px;
                margin: 0 auto;
                padding: 0 2rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .logo-section {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .logo-section i {
                font-size: 2rem;
            }

            .logo-section h1 {
                font-size: 1.8rem;
                font-weight: 600;
                margin: 0;
            }

            .header-actions {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .search-box {
                display: flex;
                align-items: center;
                background: rgba(255,255,255,0.2);
                border-radius: 25px;
                padding: 0.5rem 1rem;
                gap: 0.5rem;
            }

            .search-box input {
                background: transparent;
                border: none;
                color: white;
                outline: none;
                font-size: 0.9rem;
                width: 200px;
            }

            .search-box input::placeholder {
                color: rgba(255, 255, 255, 0.7);
            }

            .notification-bell {
                position: relative;
                background: rgba(255,255,255,0.2);
                border-radius: 50%;
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .notification-bell:hover {
                background: rgba(255,255,255,0.3);
            }

            .notification-count {
                position: absolute;
                top: -5px;
                right: -5px;
                background: var(--danger-color);
                color: white;
                border-radius: 50%;
                width: 20px;
                height: 20px;
                font-size: 0.7rem;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 600;
            }

            .user-profile {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                background: rgba(255,255,255,0.2);
                padding: 0.5rem 1rem;
                border-radius: 25px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .user-profile:hover {
                background: rgba(255,255,255,0.3);
            }

            .user-profile img {
                width: 32px;
                height: 32px;
                border-radius: 50%;
            }

            .btn-homepage {
                background: rgba(255,255,255,0.2);
                color: white;
                padding: 0.5rem 1rem;
                border-radius: 25px;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                transition: all 0.3s ease;
                border: 1px solid rgba(255,255,255,0.3);
            }

            .btn-homepage:hover {
                background: rgba(255,255,255,0.3);
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
                color: white;
            }

            /* Main Content Layout */
            .hr-main-content {
                display: flex;
                max-width: 1400px;
                margin: 0 auto;
                padding: 2rem;
                gap: 2rem;
            }

            /* Sidebar */
            .hr-sidebar {
                width: 280px;
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                padding: 1.5rem;
                height: fit-content;
            }

            .nav-section {
                margin-bottom: 2rem;
            }

            .nav-section h3 {
                font-size: 0.8rem;
                font-weight: 600;
                color: var(--text-muted);
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 1rem;
            }

            .nav-item {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                padding: 0.75rem 1rem;
                border-radius: 8px;
                text-decoration: none;
                color: var(--text-muted);
                transition: all 0.3s ease;
                font-weight: 500;
                margin-bottom: 0.5rem;
            }

            .nav-item:hover {
                background: #f1f5f9;
                color: var(--primary-color);
                transform: translateX(4px);
                text-decoration: none;
            }

            .nav-item.active {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                color: white;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            }

            .nav-item i {
                font-size: 1.1rem;
                width: 20px;
                text-align: center;
            }

            /* Content Area */
            .hr-content-area {
                flex: 1;
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                padding: 2rem;
                min-height: 600px;
            }

            /* Payroll specific styles */
            .status-tabs {
                display: flex;
                gap: 8px;
                border-bottom: 2px solid var(--border-color);
                margin-bottom: 20px;
                flex-wrap: wrap;
            }

            .status-tab-btn {
                padding: 12px 24px;
                background: none;
                border: none;
                border-bottom: 3px solid transparent;
                cursor: pointer;
                font-size: 14px;
                font-weight: 600;
                color: var(--text-muted);
                transition: all 0.2s;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .status-tab-btn:hover {
                color: var(--primary-color);
                background: rgba(102, 126, 234, 0.05);
            }

            .status-tab-btn.active {
                color: var(--primary-color);
                border-bottom-color: var(--primary-color);
                background: rgba(102, 126, 234, 0.1);
            }

            .status-tab-btn i {
                font-size: 16px;
            }

            /* Filters */
            .filters-section {
                background: #f8f9fa;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 24px;
                border: 1px solid var(--border-color);
            }

            .filters-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 16px;
            }

            .filters-header h3 {
                margin: 0;
                font-size: 1.1rem;
                font-weight: 600;
                color: var(--text-color);
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .filters-header h3 i {
                color: var(--primary-color);
            }

            .filters {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 16px;
                margin-bottom: 16px;
            }

            .form-group {
                margin-bottom: 0;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: var(--text-color);
                font-size: 14px;
            }

            .form-group select,
            .form-group input {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid var(--border-color);
                border-radius: 8px;
                font-size: 14px;
                transition: all 0.2s;
                background: white;
            }

            .form-group select:focus,
            .form-group input:focus {
                outline: none;
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            .filter-actions {
                display: flex;
                gap: 12px;
                align-items: flex-end;
            }

            .btn-secondary {
                background: var(--text-muted);
                color: white;
            }

            .btn-secondary:hover {
                background: #4b5563;
            }

            .btn-clear {
                background: var(--warning-color);
                color: white;
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .btn-clear:hover {
                background: #d97706;
            }

            .btn i {
                margin-right: 4px;
            }

            /* Tables */
            .table-container {
                overflow-x: auto;
                border-radius: 8px;
                border: 1px solid var(--border-color);
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background: white;
            }

            th, td {
                padding: 14px 16px;
                border-bottom: 1px solid var(--border-color);
                text-align: left;
            }

            th {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                font-weight: 600;
                color: var(--text-color);
                font-size: 13px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                position: sticky;
                top: 0;
                z-index: 10;
            }

            tbody tr {
                transition: all 0.2s ease;
            }

            tbody tr:hover {
                background: #f8f9fa;
            }

            tbody tr:last-child td {
                border-bottom: none;
            }

            /* Status badges */
            .status-badge {
                padding: 4px 12px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
            }

            .status-Draft {
                background: #e5e7eb;
                color: #374151;
            }

            .status-Pending {
                background: #fef3c7;
                color: #92400e;
            }

            .status-Approved {
                background: #d1fae5;
                color: #065f46;
            }

            .status-Rejected {
                background: #fee2e2;
                color: #991b1b;
            }

            .status-Paid {
                background: #dbeafe;
                color: #1e40af;
            }

            /* Action buttons */
            .action-btns {
                display: flex;
                gap: 8px;
            }

            .btn {
                display: inline-block;
                padding: 10px 14px;
                border-radius: 8px;
                text-decoration: none;
                color: #fff;
                background: #2563eb;
                border: none;
                cursor: pointer;
                font-size: 14px;
                transition: all 0.2s;
            }

            .btn:hover {
                background: #1d4ed8;
                transform: translateY(-1px);
            }

            .btn-success {
                background: var(--success-color);
            }

            .btn-success:hover {
                background: #059669;
            }

            .btn-danger {
                background: var(--danger-color);
            }

            .btn-danger:hover {
                background: #dc2626;
            }

            .btn-small {
                padding: 6px 12px;
                font-size: 12px;
            }

            /* Messages */
            .message {
                padding: 12px 16px;
                border-radius: 8px;
                margin-bottom: 20px;
            }

            .message-success {
                background: #d4edda;
                border: 1px solid #c3e6cb;
                color: #155724;
            }

            .message-error {
                background: #f8d7da;
                border: 1px solid #f5c6cb;
                color: #721c24;
            }

            /* Pagination */
            .pagination-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 1rem;
                background-color: #fff;
                border-radius: 4px;
                margin-top: 1rem;
            }

            .pagination-controls {
                display: flex;
                gap: 5px;
                align-items: center;
            }

            .pagination-controls a,
            .pagination-controls span {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 32px;
                height: 32px;
                padding: 0 8px;
                border: 1px solid #dee2e6;
                border-radius: 4px;
                font-size: 14px;
                color: #0066cc;
                text-decoration: none;
                transition: all 0.2s ease;
            }

            .pagination-controls a:hover {
                background-color: #f8f9fa;
                border-color: #0066cc;
            }

            .pagination-controls span.active {
                background-color: #0066cc;
                border-color: #0066cc;
                color: #fff;
            }

            .pagination-controls span.disabled {
                color: #ccc;
                border-color: #eee;
                cursor: not-allowed;
                pointer-events: none;
            }

            .empty {
                color: var(--text-muted);
                padding: 60px 20px;
                text-align: center;
            }

            .empty-state {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 60px 20px;
            }

            .empty-state i {
                font-size: 4rem;
                color: var(--text-muted);
                margin-bottom: 16px;
                opacity: 0.5;
            }

            .empty-state h3 {
                color: var(--text-color);
                margin-bottom: 8px;
            }

            .empty-state p {
                color: var(--text-muted);
            }

            /* Results summary */
            .results-summary {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 12px 16px;
                background: #f8f9fa;
                border-radius: 8px;
                margin-bottom: 16px;
                font-size: 14px;
            }

            .results-count {
                color: var(--text-color);
                font-weight: 600;
            }

            .results-count span {
                color: var(--primary-color);
            }

            /* Modal */
            .modal {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                z-index: 1000;
                align-items: center;
                justify-content: center;
            }

            .modal.active {
                display: flex;
            }

            .modal-content {
                background: white;
                border-radius: 12px;
                padding: 0;
                max-width: 700px;
                width: 90%;
                max-height: 90vh;
                overflow-y: auto;
                box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            }

            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 24px;
                border-bottom: 1px solid var(--border-color);
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                color: white;
                border-radius: 12px 12px 0 0;
            }

            .modal-header h3 {
                margin: 0;
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 1.5rem;
            }

            .modal-header h3 i {
                font-size: 1.3rem;
            }

            .close-btn {
                background: rgba(255,255,255,0.2);
                border: none;
                font-size: 24px;
                cursor: pointer;
                color: white;
                width: 36px;
                height: 36px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.2s;
            }

            .close-btn:hover {
                background: rgba(255,255,255,0.3);
                transform: rotate(90deg);
            }

            .modal-body {
                padding: 24px;
            }

            .detail-section {
                margin-bottom: 24px;
            }

            .detail-section-title {
                font-size: 1rem;
                font-weight: 600;
                color: var(--text-color);
                margin-bottom: 16px;
                padding-bottom: 8px;
                border-bottom: 2px solid var(--primary-color);
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .detail-section-title i {
                color: var(--primary-color);
            }

            .detail-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 16px;
            }

            .detail-item {
                background: #f8f9fa;
                padding: 16px;
                border-radius: 8px;
                border-left: 4px solid var(--primary-color);
            }

            .detail-label {
                font-size: 0.85rem;
                font-weight: 600;
                color: var(--text-muted);
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 8px;
            }

            .detail-value {
                font-size: 1.1rem;
                font-weight: 600;
                color: var(--text-color);
            }

            .detail-value.currency {
                color: var(--primary-color);
                font-size: 1.3rem;
            }

            .detail-value.status {
                display: inline-block;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.9rem;
            }

            .detail-row {
                display: flex;
                justify-content: space-between;
                padding: 12px 0;
                border-bottom: 1px solid var(--border-color);
            }

            .detail-row:last-child {
                border-bottom: none;
            }

            .currency {
                font-weight: 600;
                color: var(--primary-color);
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .hr-main-content {
                    flex-direction: column;
                    padding: 1rem;
                }

                .hr-sidebar {
                    width: 100%;
                    margin-bottom: 1rem;
                }

                .header-content {
                    flex-direction: column;
                    gap: 1rem;
                    padding: 0 1rem;
                }

                .header-actions {
                    flex-wrap: wrap;
                    justify-content: center;
                }

                .search-box input {
                    width: 150px;
                }

                .filters {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <div class="hr-dashboard-container">
            <!-- Header -->
            <header class="hr-header">
                <div class="header-content">
                    <div class="logo-section">
                        <i class="fas fa-money-bill-wave"></i>
                        <h1>Payroll Approval Management</h1>
                    </div>
                    <div class="header-actions">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" placeholder="Search payrolls...">
                        </div>
                        <div class="notification-bell">
                            <i class="fas fa-bell"></i>
                            <span class="notification-count">3</span>
                        </div>
                        <div class="user-profile">
                            <img src="https://i.pravatar.cc/40" alt="HR User">
                            <span>HR Manager</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
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
                            <a href="${pageContext.request.contextPath}/Views/hr/HrHome.jsp" class="nav-item">
                                <i class="fas fa-home"></i>
                                <span>HR Home</span>
                            </a>
                        </div>
                        
                        <div class="nav-section">
                            <h3>Requests & Approvals</h3>
                            <a href="${pageContext.request.contextPath}/Views/hr/HrHome.jsp#requests-approval" class="nav-item">
                                <i class="fas fa-clipboard-check"></i>
                                <span>Requests & Recommendations</span>
                            </a>
                        </div>
                        
                        <div class="nav-section">
                            <h3>Salary & Contracts</h3>
                            <a href="${pageContext.request.contextPath}/hr/payroll-approval" class="nav-item active">
                                <i class="fas fa-money-bill-wave"></i>
                                <span>Payroll Approval</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/hr/approve-reject-contracts" class="nav-item">
                                <i class="fas fa-file-contract"></i>
                                <span>Pending Contracts Approval</span>
                            </a>
                        </div>
                        
                        <div class="nav-section">
                            <h3>Recruitment</h3>
                            <a href="${pageContext.request.contextPath}/viewRecruitment" class="nav-item">
                                <i class="fas fa-bullhorn"></i>
                                <span>View Recruitment</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/candidates" class="nav-item">
                                <i class="fas fa-users"></i>
                                <span>View Candidates</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/hr/create-employee" class="nav-item">
                                <i class="fas fa-user-plus"></i>
                                <span>Create Employee</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/hr/employee-list" class="nav-item">
                                <i class="fas fa-list"></i>
                                <span>Employee List</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/Views/hr/HrHome.jsp#recruitment-system" class="nav-item">
                                <i class="fas fa-clipboard-list"></i>
                                <span>Recruitment System</span>
                            </a>
                        </div>
                        
                        <div class="nav-section">
                            <h3>Reports</h3>
                            <a href="${pageContext.request.contextPath}/Views/hr/HrHome.jsp#reports-analytics" class="nav-item">
                                <i class="fas fa-chart-bar"></i>
                                <span>Reports & Analytics</span>
                            </a>
                        </div>
                    </nav>
                </aside>

                <!-- Content Area -->
                <div class="hr-content-area">
                    <!-- Page Title -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h1 class="h2">Payroll Approval Management</h1>
                    </div>

                    <%-- Display success/error messages --%>
                    <c:if test="${not empty success}">
                        <div class="message message-success">
                            <strong>✓ Success:</strong> ${success}
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="message message-error">
                            <strong>✗ Error:</strong> ${error}
                        </div>
                    </c:if>

                    <div class="card" style="border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">
                        <!-- Status Tabs -->
                        <div class="status-tabs">
                            <c:url var="pendingUrl" value="/hr/payroll-approval">
                                <c:param name="status" value="Pending"/>
                                <c:if test="${not empty employeeFilter}">
                                    <c:param name="employeeFilter" value="${employeeFilter}"/>
                                </c:if>
                                <c:if test="${not empty payPeriodFilter}">
                                    <c:param name="payPeriod" value="${payPeriodFilter}"/>
                                </c:if>
                            </c:url>
                            <c:url var="approvedUrl" value="/hr/payroll-approval">
                                <c:param name="status" value="Approved"/>
                                <c:if test="${not empty employeeFilter}">
                                    <c:param name="employeeFilter" value="${employeeFilter}"/>
                                </c:if>
                                <c:if test="${not empty payPeriodFilter}">
                                    <c:param name="payPeriod" value="${payPeriodFilter}"/>
                                </c:if>
                            </c:url>
                            <c:url var="rejectedUrl" value="/hr/payroll-approval">
                                <c:param name="status" value="Rejected"/>
                                <c:if test="${not empty employeeFilter}">
                                    <c:param name="employeeFilter" value="${employeeFilter}"/>
                                </c:if>
                                <c:if test="${not empty payPeriodFilter}">
                                    <c:param name="payPeriod" value="${payPeriodFilter}"/>
                                </c:if>
                            </c:url>
                            <c:url var="paidUrl" value="/hr/payroll-approval">
                                <c:param name="status" value="Paid"/>
                                <c:if test="${not empty employeeFilter}">
                                    <c:param name="employeeFilter" value="${employeeFilter}"/>
                                </c:if>
                                <c:if test="${not empty payPeriodFilter}">
                                    <c:param name="payPeriod" value="${payPeriodFilter}"/>
                                </c:if>
                            </c:url>
                            <c:url var="allUrl" value="/hr/payroll-approval">
                                <c:if test="${not empty employeeFilter}">
                                    <c:param name="employeeFilter" value="${employeeFilter}"/>
                                </c:if>
                                <c:if test="${not empty payPeriodFilter}">
                                    <c:param name="payPeriod" value="${payPeriodFilter}"/>
                                </c:if>
                            </c:url>

                            <a class="status-tab-btn ${statusFilter == 'Pending' ? 'active' : ''}" href="${pendingUrl}">
                                <i class="fas fa-hourglass-half"></i>
                                Pending Approval
                                <span class="badge bg-warning text-dark">${pendingCount}</span>
                            </a>
                            <a class="status-tab-btn ${statusFilter == 'Approved' ? 'active' : ''}" href="${approvedUrl}">
                                <i class="fas fa-check-circle"></i>
                                Approved
                                <span class="badge bg-success">${approvedCount}</span>
                            </a>
                            <a class="status-tab-btn ${statusFilter == 'Rejected' ? 'active' : ''}" href="${rejectedUrl}">
                                <i class="fas fa-times-circle"></i>
                                Rejected
                                <span class="badge bg-danger">${rejectedCount}</span>
                            </a>
                            <a class="status-tab-btn ${statusFilter == 'Paid' ? 'active' : ''}" href="${paidUrl}">
                                <i class="fas fa-money-bill-wave"></i>
                                Paid
                                <span class="badge bg-primary">${paidCount}</span>
                            </a>
                            <a class="status-tab-btn ${empty statusFilter ? 'active' : ''}" href="${allUrl}">
                                <i class="fas fa-list"></i> All
                            </a>
                        </div>

                        <!-- Results Summary -->
                        <c:if test="${not empty payrolls}">
                            <div class="results-summary">
                                <div class="results-count">
                                    Showing <span>${(currentPage - 1) * pageSize + 1}</span> to 
                                    <span>${currentPage * pageSize > totalCount ? totalCount : currentPage * pageSize}</span> 
                                    of <span>${totalCount}</span> payrolls
                                </div>
                            </div>
                        </c:if>

                        <!-- Filters Section -->
                        <div class="filters-section">
                            <div class="filters-header">
                                <h3><i class="fas fa-filter"></i> Filters</h3>
                                <c:if test="${not empty employeeFilter || not empty payPeriodFilter}">
                                    <c:url var="clearFiltersUrl" value="/hr/payroll-approval">
                                        <c:if test="${not empty statusFilter}">
                                            <c:param name="status" value="${statusFilter}"/>
                                        </c:if>
                                    </c:url>
                                    <a class="btn btn-clear btn-small" href="${clearFiltersUrl}">
                                        <i class="fas fa-times"></i> Clear Filters
                                    </a>
                                </c:if>
                            </div>
                            <form method="GET" action="<%=request.getContextPath()%>/hr/payroll-approval" id="filterForm">
                                <input type="hidden" name="status" value="${statusFilter}"/>
                                <input type="hidden" name="page" id="pageField" value="${currentPage}"/>
                                <input type="hidden" name="pageSize" id="pageSizeField" value="${pageSize}"/>
                                <div class="filters">
                                    <div class="form-group">
                                        <label><i class="fas fa-user"></i> Employee</label>
                                        <select name="employeeFilter" id="employeeFilter">
                                            <option value="">All Employees</option>
                                            <c:forEach var="employee" items="${employees}">
                                                <option value="${employee.employeeId}" 
                                                        ${employeeFilter == employee.employeeId.toString() ? 'selected' : ''}>
                                                    ${employee.fullName} (ID: ${employee.employeeId})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label><i class="fas fa-calendar-alt"></i> Pay Period</label>
                                        <input type="month" name="payPeriod" id="payPeriod" value="${payPeriodFilter}"/>
                                    </div>
                                    <div class="form-group filter-actions">
                                        <label>&nbsp;</label>
                                        <div style="display: flex; gap: 8px;">
                                            <button type="submit" class="btn">
                                                <i class="fas fa-search"></i> Apply
                                            </button>
                                            <c:if test="${not empty employeeFilter || not empty payPeriodFilter}">
                                                <c:url var="resetFiltersUrl" value="/hr/payroll-approval">
                                                    <c:if test="${not empty statusFilter}">
                                                        <c:param name="status" value="${statusFilter}"/>
                                                    </c:if>
                                                </c:url>
                                                <a class="btn btn-secondary btn-small" href="${resetFiltersUrl}">
                                                    <i class="fas fa-redo"></i> Clear
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <!-- Payroll Table -->
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-user"></i> Employee</th>
                                        <th><i class="fas fa-calendar"></i> Pay Period</th>
                                        <th><i class="fas fa-money-bill"></i> Base Salary</th>
                                        <th><i class="fas fa-plus-circle"></i> Allowance</th>
                                        <th><i class="fas fa-gift"></i> Bonus</th>
                                        <th><i class="fas fa-minus-circle"></i> Deduction</th>
                                        <th><i class="fas fa-wallet"></i> Net Salary</th>
                                        <th><i class="fas fa-info-circle"></i> Status</th>
                                        <th><i class="fas fa-cog"></i> Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty payrolls}">
                                            <tr>
                                                <td colspan="9">
                                                    <div class="empty-state">
                                                        <i class="fas fa-inbox"></i>
                                                        <h3>No Payrolls Found</h3>
                                                        <p>There are no payrolls matching your current filters.</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="payroll" items="${payrolls}">
                                                <tr data-payroll-id="${payroll.payrollId}"
                                                    data-employee-name="${payroll.employeeName}"
                                                    data-pay-period="${payroll.payPeriod}"
                                                    data-base-salary="${payroll.baseSalary}"
                                                    data-allowance="${payroll.allowance}"
                                                    data-bonus="${payroll.bonus}"
                                                    data-deduction="${payroll.deduction}"
                                                    data-net-salary="${payroll.netSalary}"
                                                    data-status="${payroll.status}"
                                                    data-approved-date="${payroll.approvedDate}">
                                                    <td>${payroll.employeeName}</td>
                                                    <td>${payroll.payPeriod}</td>
                                                    <td class="currency">
                                                        <fmt:formatNumber value="${payroll.baseSalary}" type="number" groupingUsed="true"/> VNĐ
                                                    </td>
                                                    <td class="currency">
                                                        <fmt:formatNumber value="${payroll.allowance}" type="number" groupingUsed="true"/> VNĐ
                                                    </td>
                                                    <td class="currency">
                                                        <fmt:formatNumber value="${payroll.bonus}" type="number" groupingUsed="true"/> VNĐ
                                                    </td>
                                                    <td class="currency">
                                                        <fmt:formatNumber value="${payroll.deduction}" type="number" groupingUsed="true"/> VNĐ
                                                    </td>
                                                    <td class="currency" style="font-weight:700; color:var(--primary-color);">
                                                        <fmt:formatNumber value="${payroll.netSalary}" type="number" groupingUsed="true"/> VNĐ
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${payroll.status == 'Pending'}">
                                                                <span class="status-badge status-Pending">Pending</span>
                                                            </c:when>
                                                            <c:when test="${payroll.status == 'Approved'}">
                                                                <span class="status-badge status-Approved">Approved</span>
                                                            </c:when>
                                                            <c:when test="${payroll.status == 'Rejected'}">
                                                                <span class="status-badge status-Rejected">Rejected</span>
                                                            </c:when>
                                                            <c:when test="${payroll.status == 'Draft'}">
                                                                <span class="status-badge status-Draft">Draft</span>
                                                            </c:when>
                                                            <c:when test="${payroll.status == 'Paid'}">
                                                                <span class="status-badge status-Paid">Paid</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-badge status-Draft">${payroll.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="action-btns">
                                                            <button class="btn btn-small view-payroll-btn" 
                                                                    data-payroll-id="${payroll.payrollId}"
                                                                    data-employee-name="${payroll.employeeName}"
                                                                    data-pay-period="${payroll.payPeriod}"
                                                                    data-base-salary="${payroll.baseSalary}"
                                                                    data-allowance="${payroll.allowance}"
                                                                    data-bonus="${payroll.bonus}"
                                                                    data-deduction="${payroll.deduction}"
                                                                    data-net-salary="${payroll.netSalary}"
                                                                    data-status="${payroll.status}"
                                                                    data-approved-date="${payroll.approvedDate}"
                                                                    title="View Details">
                                                                <i class="fas fa-eye"></i> View
                                                            </button>
                                                            <c:if test="${payroll.status == 'Pending'}">
                                                                <button class="btn btn-small btn-success approve-payroll-btn" 
                                                                        data-payroll-id="${payroll.payrollId}"
                                                                        title="Approve Payroll">
                                                                    <i class="fas fa-check"></i> Approve
                                                                </button>
                                                                <button class="btn btn-small btn-danger reject-payroll-btn" 
                                                                        data-payroll-id="${payroll.payrollId}"
                                                                        title="Reject Payroll">
                                                                    <i class="fas fa-times"></i> Reject
                                                                </button>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="pagination-bar">
                            <c:set var="page" value="${currentPage != null ? currentPage : 1}" />
                            <c:set var="size" value="${pageSize != null ? pageSize : 10}" />
                            <c:set var="total" value="${totalCount != null ? totalCount : 0}" />
                            <c:set var="totalPagesCalc" value="${totalPages != null ? totalPages : 1}" />
                            <c:set var="start" value="${total > 0 ? (page - 1) * size + 1 : 0}" />
                            <c:set var="end" value="${page * size}" />
                            <c:if test="${end > total}">
                                <c:set var="end" value="${total}" />
                            </c:if>

                            <div class="pagination-info">
                                <span>Showing ${start} - ${end} of ${total} payrolls</span>
                                <div class="page-size-selector">
                                    <label for="pageSizeSelect">Items per page:</label>
                                    <select id="pageSizeSelect" onchange="changePayrollPageSize(this.value)">
                                        <option value="5" <c:if test="${size == 5}">selected</c:if>>5</option>
                                        <option value="10" <c:if test="${size == 10}">selected</c:if>>10</option>
                                        <option value="20" <c:if test="${size == 20}">selected</c:if>>20</option>
                                        <option value="50" <c:if test="${size == 50}">selected</c:if>>50</option>
                                    </select>
                                </div>
                            </div>

                            <div class="pagination-controls">
                                <c:choose>
                                    <c:when test="${page > 1}">
                                        <c:url var="prevUrl" value="/hr/payroll-approval">
                                            <c:param name="page" value="${page - 1}" />
                                            <c:param name="pageSize" value="${size}" />
                                            <c:if test="${not empty statusFilter}">
                                                <c:param name="status" value="${statusFilter}" />
                                            </c:if>
                                            <c:if test="${not empty employeeFilter}">
                                                <c:param name="employeeFilter" value="${employeeFilter}" />
                                            </c:if>
                                            <c:if test="${not empty payPeriodFilter}">
                                                <c:param name="payPeriod" value="${payPeriodFilter}" />
                                            </c:if>
                                        </c:url>
                                        <a href="${prevUrl}" class="btn-pagination">← Prev</a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="disabled">← Prev</span>
                                    </c:otherwise>
                                </c:choose>

                                <c:set var="range" value="2" />
                                <c:set var="startPage" value="${page - range > 1 ? page - range : 1}" />
                                <c:set var="endPage" value="${page + range < totalPagesCalc ? page + range : totalPagesCalc}" />

                                <c:if test="${startPage > 1}">
                                    <c:url var="firstPageUrl" value="/hr/payroll-approval">
                                        <c:param name="page" value="1" />
                                        <c:param name="pageSize" value="${size}" />
                                        <c:if test="${not empty statusFilter}">
                                            <c:param name="status" value="${statusFilter}" />
                                        </c:if>
                                        <c:if test="${not empty employeeFilter}">
                                            <c:param name="employeeFilter" value="${employeeFilter}" />
                                        </c:if>
                                        <c:if test="${not empty payPeriodFilter}">
                                            <c:param name="payPeriod" value="${payPeriodFilter}" />
                                        </c:if>
                                    </c:url>
                                    <a href="${firstPageUrl}" class="btn-pagination">1</a>
                                    <c:if test="${startPage > 2}">
                                        <span class="ellipsis">...</span>
                                    </c:if>
                                </c:if>

                                <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                    <c:choose>
                                        <c:when test="${i == page}">
                                            <span class="active btn-pagination">${i}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:url var="pageUrl" value="/hr/payroll-approval">
                                                <c:param name="page" value="${i}" />
                                                <c:param name="pageSize" value="${size}" />
                                                <c:if test="${not empty statusFilter}">
                                                    <c:param name="status" value="${statusFilter}" />
                                                </c:if>
                                                <c:if test="${not empty employeeFilter}">
                                                    <c:param name="employeeFilter" value="${employeeFilter}" />
                                                </c:if>
                                                <c:if test="${not empty payPeriodFilter}">
                                                    <c:param name="payPeriod" value="${payPeriodFilter}" />
                                                </c:if>
                                            </c:url>
                                            <a href="${pageUrl}" class="btn-pagination">${i}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>

                                <c:if test="${endPage < totalPagesCalc}">
                                    <c:if test="${endPage < totalPagesCalc - 1}">
                                        <span class="ellipsis">...</span>
                                    </c:if>
                                    <c:url var="lastPageUrl" value="/hr/payroll-approval">
                                        <c:param name="page" value="${totalPagesCalc}" />
                                        <c:param name="pageSize" value="${size}" />
                                        <c:if test="${not empty statusFilter}">
                                            <c:param name="status" value="${statusFilter}" />
                                        </c:if>
                                        <c:if test="${not empty employeeFilter}">
                                            <c:param name="employeeFilter" value="${employeeFilter}" />
                                        </c:if>
                                        <c:if test="${not empty payPeriodFilter}">
                                            <c:param name="payPeriod" value="${payPeriodFilter}" />
                                        </c:if>
                                    </c:url>
                                    <a href="${lastPageUrl}" class="btn-pagination">${totalPagesCalc}</a>
                                </c:if>

                                <c:choose>
                                    <c:when test="${page < totalPagesCalc}">
                                        <c:url var="nextUrl" value="/hr/payroll-approval">
                                            <c:param name="page" value="${page + 1}" />
                                            <c:param name="pageSize" value="${size}" />
                                            <c:if test="${not empty statusFilter}">
                                                <c:param name="status" value="${statusFilter}" />
                                            </c:if>
                                            <c:if test="${not empty employeeFilter}">
                                                <c:param name="employeeFilter" value="${employeeFilter}" />
                                            </c:if>
                                            <c:if test="${not empty payPeriodFilter}">
                                                <c:param name="payPeriod" value="${payPeriodFilter}" />
                                            </c:if>
                                        </c:url>
                                        <a href="${nextUrl}" class="btn-pagination">Next →</a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="disabled">Next →</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <!-- Payroll Details Modal -->
        <div id="payrollDetailModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3><i class="fas fa-file-invoice-dollar"></i> Payroll Details</h3>
                    <button class="close-btn" onclick="closePayrollModal()" title="Close">&times;</button>
                </div>
                <div class="modal-body" id="payrollDetailContent">
                    <!-- Content will be loaded dynamically -->
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            const appContext = '${pageContext.request.contextPath}';
            let statusFilterField;
            let employeeFilterField;
            let payPeriodFilterField;
            let pageField;
            let pageSizeField;

            const getCurrentFilters = () => {
                return {
                    status: statusFilterField && statusFilterField.value ? statusFilterField.value.trim() : '',
                    employee: employeeFilterField && employeeFilterField.value ? employeeFilterField.value.trim() : '',
                    payPeriod: payPeriodFilterField && payPeriodFilterField.value ? payPeriodFilterField.value : '',
                    page: pageField && pageField.value ? pageField.value.trim() : '',
                    pageSize: pageSizeField && pageSizeField.value ? pageSizeField.value.trim() : ''
                };
            };

            document.addEventListener('DOMContentLoaded', function() {
                const filterForm = document.getElementById('filterForm');
                statusFilterField = filterForm ? filterForm.querySelector('input[name="status"]') : null;
                employeeFilterField = document.getElementById('employeeFilter');
                payPeriodFilterField = document.getElementById('payPeriod');
                pageField = document.getElementById('pageField');
                pageSizeField = document.getElementById('pageSizeField');

                if (filterForm) {
                    filterForm.addEventListener('submit', function() {
                        if (pageField) {
                            pageField.value = '1';
                        }
                    });
                }
                
                // Event listeners for action buttons
                document.querySelectorAll('.view-payroll-btn').forEach(btn => {
                    btn.addEventListener('click', function() {
                        viewPayrollDetails(this);
                    });
                });
                
                document.querySelectorAll('.approve-payroll-btn').forEach(btn => {
                    btn.addEventListener('click', function() {
                        const payrollId = this.getAttribute('data-payroll-id');
                        approvePayroll(payrollId);
                    });
                });
                
                document.querySelectorAll('.reject-payroll-btn').forEach(btn => {
                    btn.addEventListener('click', function() {
                        const payrollId = this.getAttribute('data-payroll-id');
                        rejectPayroll(payrollId);
                    });
                });
            });

            window.viewPayrollDetails = function(trigger) {
                if (!trigger) {
                    console.error('Missing trigger element for payroll details');
                    return;
                }
                const payrollId = trigger.getAttribute('data-payroll-id');
                if (!payrollId) {
                    console.error('Invalid payroll ID');
                    return;
                }

                const modal = document.getElementById('payrollDetailModal');
                const content = document.getElementById('payrollDetailContent');
                content.innerHTML = '<div style="text-align:center; padding:32px; color: var(--muted-color);">'
                    + '<i class="fas fa-spinner fa-spin" style="font-size:32px; margin-bottom:12px;"></i>'
                    + '<div>Loading payroll details...</div>'
                    + '</div>';
                modal.classList.add('active');

                const detailsUrl = appContext + '/hr/payroll-approval?ajax=true&payrollId=' + encodeURIComponent(payrollId);
                fetch(detailsUrl, {
                    credentials: 'same-origin',
                    headers: {
                        'Accept': 'application/json'
                    }
                })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error(`Server returned ${response.status}`);
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.error) {
                            throw new Error(data.error);
                        }
                        renderPayrollDetails(data);
                    })
                    .catch(err => {
                        console.error('Error loading payroll details:', err);
                        content.innerHTML = '<div style="background:#fee2e2; border:1px solid #fca5a5; border-radius:8px; padding:20px; color:#991b1b;">'
                            + '<div style="font-weight:600; margin-bottom:8px;">Unable to load payroll details</div>'
                            + `<div>${err.message}</div>`
                            + '</div>';
                    });
            }

            const formatCurrency = (amount) => {
                const value = Number(amount || 0);
                return new Intl.NumberFormat('vi-VN', {
                    style: 'currency',
                    currency: 'VND'
                }).format(value);
            };

            const formatNumber = (value) => {
                if (value === null || value === undefined || value === '') {
                    return '0';
                }
                const num = Number(value);
                if (Number.isNaN(num)) {
                    return value;
                }
                return Number.isInteger(num) ? num.toString() : num.toFixed(2);
            };

            const formatDateTime = (value) => {
                if (!value) {
                    return '';
                }
                const date = new Date(value);
                if (Number.isNaN(date.getTime())) {
                    return value;
                }
                return date.toLocaleString('vi-VN', {
                    hour12: false
                });
            };

            const getStatusClass = (value) => ({
                'Pending': 'status-Pending',
                'Approved': 'status-Approved',
                'Rejected': 'status-Rejected',
                'Draft': 'status-Draft',
                'Paid': 'status-Paid'
            })[value] || 'status-Draft';

            window.renderPayrollDetails = function(data) {
                const content = document.getElementById('payrollDetailContent');
                const audit = data.audit || {};

                const employeeName = data.employeeName || 'N/A';
                const payPeriod = data.payPeriod || 'N/A';
                const status = data.status || 'Draft';
                const approvedDate = data.approvedDate || '';

                const parts = [];
                parts.push('<div class="detail-section">');
                parts.push('  <div class="detail-section-title"><i class="fas fa-user"></i> Employee Information</div>');
                parts.push('  <div class="detail-grid">');
                parts.push('    <div class="detail-item">');
                parts.push('      <div class="detail-label">Employee Name</div>');
                parts.push('      <div class="detail-value">' + employeeName + '</div>');
                parts.push('    </div>');
                parts.push('    <div class="detail-item">');
                parts.push('      <div class="detail-label">Pay Period</div>');
                parts.push('      <div class="detail-value">' + payPeriod + '</div>');
                parts.push('    </div>');
                parts.push('    <div class="detail-item">');
                parts.push('      <div class="detail-label">Status</div>');
                parts.push('      <div class="detail-value"><span class="status-badge ' + getStatusClass(status) + '">' + status + '</span></div>');
                parts.push('    </div>');
                if (approvedDate) {
                    parts.push('    <div class="detail-item">');
                    parts.push('      <div class="detail-label">Approved Date</div>');
                    parts.push('      <div class="detail-value">' + approvedDate + '</div>');
                    parts.push('    </div>');
                }
                parts.push('  </div>');
                parts.push('</div>');

                parts.push('<div class="detail-section">');
                parts.push('  <div class="detail-section-title"><i class="fas fa-calculator"></i> Salary Breakdown</div>');
                parts.push('  <div class="detail-grid">');
                parts.push('    <div class="detail-item">');
                parts.push('      <div class="detail-label">Payroll Base Salary</div>');
                parts.push('      <div class="detail-value currency">' + formatCurrency(data.baseSalary) + '</div>');
                parts.push('    </div>');
                parts.push('    <div class="detail-item">');
                parts.push('      <div class="detail-label">Payroll Allowance</div>');
                parts.push('      <div class="detail-value currency" style="color: var(--success-color);">+ ' + formatCurrency(data.allowance) + '</div>');
                parts.push('    </div>');
                parts.push('    <div class="detail-item">');
                parts.push('      <div class="detail-label">Payroll Bonus</div>');
                parts.push('      <div class="detail-value currency" style="color: var(--success-color);">+ ' + formatCurrency(data.bonus) + '</div>');
                parts.push('    </div>');
                parts.push('    <div class="detail-item">');
                parts.push('      <div class="detail-label">Payroll Deduction</div>');
                parts.push('      <div class="detail-value currency" style="color: var(--danger-color);">- ' + formatCurrency(data.deduction) + '</div>');
                parts.push('    </div>');
                parts.push('  </div>');
                parts.push('</div>');

                parts.push('<div class="detail-section">');
                parts.push('  <div class="detail-section-title"><i class="fas fa-wallet"></i> Net Salary</div>');
                parts.push('  <div style="background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); padding: 24px; border-radius: 12px; text-align: center;">');
                parts.push('    <div class="detail-label" style="color: rgba(255,255,255,0.9); margin-bottom: 12px;">Total Net Salary</div>');
                parts.push('    <div class="detail-value currency" style="color: white; font-size: 2rem; margin: 0;">' + formatCurrency(data.netSalary) + '</div>');
                parts.push('  </div>');
                parts.push('</div>');

                if (audit && Object.keys(audit).length > 0) {
                    parts.push('<div class="detail-section">');
                    parts.push('  <div class="detail-section-title"><i class="fas fa-clipboard-list"></i> Payroll Audit</div>');
                    parts.push('  <div class="detail-grid" style="grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));">');

                    const auditCurrencyFields = [
                        { label: 'Audit Base Salary', key: 'baseSalary' },
                        { label: 'Audit Allowance', key: 'allowance' },
                        { label: 'Audit Net Salary', key: 'netSalary' },
                        { label: 'Actual Base Salary', key: 'actualBaseSalary' },
                        { label: 'OT Salary', key: 'otSalary' },
                        { label: 'BHXH', key: 'bhxh' },
                        { label: 'BHYT', key: 'bhyt' },
                        { label: 'BHTN', key: 'bhtn' },
                        { label: 'Taxable Income', key: 'taxableIncome' },
                        { label: 'Personal Tax', key: 'personalTax' },
                        { label: 'Absent Penalty', key: 'absentPenalty' },
                        { label: 'Other Deduction', key: 'otherDeduction' },
                        { label: 'Total Deduction', key: 'totalDeduction' }
                    ];

                    const auditNumberFields = [
                        { label: 'Actual Working Days', key: 'actualWorkingDays' },
                        { label: 'Paid Leave Days', key: 'paidLeaveDays' },
                        { label: 'Unpaid Leave Days', key: 'unpaidLeaveDays' },
                        { label: 'Overtime Hours', key: 'overtimeHours' }
                    ];

                    auditCurrencyFields.forEach(field => {
                        const value = audit[field.key];
                        if (value !== undefined && value !== null) {
                            parts.push('    <div class="detail-item">');
                            parts.push('      <div class="detail-label">' + field.label + '</div>');
                            parts.push('      <div class="detail-value">' + formatCurrency(value) + '</div>');
                            parts.push('    </div>');
                        }
                    });

                    auditNumberFields.forEach(field => {
                        const value = audit[field.key];
                        if (value !== undefined && value !== null) {
                            parts.push('    <div class="detail-item">');
                            parts.push('      <div class="detail-label">' + field.label + '</div>');
                            parts.push('      <div class="detail-value">' + formatNumber(value) + '</div>');
                            parts.push('    </div>');
                        }
                    });

                    if (audit.status) {
                        parts.push('    <div class="detail-item">');
                        parts.push('      <div class="detail-label">Audit Status</div>');
                        parts.push('      <div class="detail-value"><span class="status-badge ' + getStatusClass(audit.status) + '">' + audit.status + '</span></div>');
                        parts.push('    </div>');
                    }

                    if (audit.calculatedAt) {
                        parts.push('    <div class="detail-item">');
                        parts.push('      <div class="detail-label">Calculated At</div>');
                        parts.push('      <div class="detail-value">' + formatDateTime(audit.calculatedAt) + '</div>');
                        parts.push('    </div>');
                    }

                    if (audit.calculatedByUsername || audit.calculatedBy) {
                        parts.push('    <div class="detail-item">');
                        parts.push('      <div class="detail-label">Calculated By</div>');
                        const calcBy = audit.calculatedByUsername || ('User ID: ' + audit.calculatedBy);
                        parts.push('      <div class="detail-value">' + calcBy + '</div>');
                        parts.push('    </div>');
                    }

                    if (audit.notes) {
                        parts.push('    <div class="detail-item" style="grid-column: 1 / -1;">');
                        parts.push('      <div class="detail-label">Notes</div>');
                        parts.push('      <div class="detail-value" style="white-space: pre-wrap;">' + audit.notes + '</div>');
                        parts.push('    </div>');
                    }

                    parts.push('  </div>');
                    parts.push('</div>');
                } else {
                    parts.push('<div class="detail-section">');
                    parts.push('  <div class="detail-section-title"><i class="fas fa-clipboard-list"></i> Payroll Audit</div>');
                    parts.push('  <div style="padding:16px; border:1px dashed var(--border-color); border-radius:12px; color: var(--muted-color);">');
                    parts.push('    No audit details available for this payroll.');
                    parts.push('  </div>');
                    parts.push('</div>');
                }

                content.innerHTML = parts.join('');
            };

            window.closePayrollModal = function() {
                document.getElementById('payrollDetailModal').classList.remove('active');
            };

            window.approvePayroll = function(payrollId) {
                if (confirm('Are you sure you want to approve this payroll?')) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = appContext + '/hr/payroll-approval';

                    const { status, employee, payPeriod, page, pageSize } = getCurrentFilters();
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'approve';
                    form.appendChild(actionInput);
                    
                    const payrollIdInput = document.createElement('input');
                    payrollIdInput.type = 'hidden';
                    payrollIdInput.name = 'payrollId';
                    payrollIdInput.value = payrollId;
                    form.appendChild(payrollIdInput);
                    
                    if (status) {
                        const statusInput = document.createElement('input');
                        statusInput.type = 'hidden';
                        statusInput.name = 'status';
                        statusInput.value = status;
                        form.appendChild(statusInput);
                    }
                    if (employee) {
                        const empInput = document.createElement('input');
                        empInput.type = 'hidden';
                        empInput.name = 'employeeFilter';
                        empInput.value = employee;
                        form.appendChild(empInput);
                    }
                    if (payPeriod) {
                        const periodInput = document.createElement('input');
                        periodInput.type = 'hidden';
                        periodInput.name = 'payPeriod';
                        periodInput.value = payPeriod;
                        form.appendChild(periodInput);
                    }
                    if (page) {
                        const pageInput = document.createElement('input');
                        pageInput.type = 'hidden';
                        pageInput.name = 'page';
                        pageInput.value = page;
                        form.appendChild(pageInput);
                    }
                    if (pageSize) {
                        const sizeInput = document.createElement('input');
                        sizeInput.type = 'hidden';
                        sizeInput.name = 'pageSize';
                        sizeInput.value = pageSize;
                        form.appendChild(sizeInput);
                    }
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            };

            window.rejectPayroll = function(payrollId) {
                if (confirm('Are you sure you want to reject this payroll?')) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = appContext + '/hr/payroll-approval';

                    const { status, employee, payPeriod, page, pageSize } = getCurrentFilters();
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'reject';
                    form.appendChild(actionInput);
                    
                    const payrollIdInput = document.createElement('input');
                    payrollIdInput.type = 'hidden';
                    payrollIdInput.name = 'payrollId';
                    payrollIdInput.value = payrollId;
                    form.appendChild(payrollIdInput);
                    
                    if (status) {
                        const statusInput = document.createElement('input');
                        statusInput.type = 'hidden';
                        statusInput.name = 'status';
                        statusInput.value = status;
                        form.appendChild(statusInput);
                    }
                    if (employee) {
                        const empInput = document.createElement('input');
                        empInput.type = 'hidden';
                        empInput.name = 'employeeFilter';
                        empInput.value = employee;
                        form.appendChild(empInput);
                    }
                    if (payPeriod) {
                        const periodInput = document.createElement('input');
                        periodInput.type = 'hidden';
                        periodInput.name = 'payPeriod';
                        periodInput.value = payPeriod;
                        form.appendChild(periodInput);
                    }
                    if (page) {
                        const pageInput = document.createElement('input');
                        pageInput.type = 'hidden';
                        pageInput.name = 'page';
                        pageInput.value = page;
                        form.appendChild(pageInput);
                    }
                    if (pageSize) {
                        const sizeInput = document.createElement('input');
                        sizeInput.type = 'hidden';
                        sizeInput.name = 'pageSize';
                        sizeInput.value = pageSize;
                        form.appendChild(sizeInput);
                    }
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            };

            window.formatCurrency = function(amount) {
                return new Intl.NumberFormat('en-US').format(amount);
            };

            window.changePayrollPageSize = function(newSize) {
                const { status, employee, payPeriod } = getCurrentFilters();
                const params = new URLSearchParams();
                if (status) {
                    params.append('status', status);
                }
                if (employee) {
                    params.append('employeeFilter', employee);
                }
                if (payPeriod) {
                    params.append('payPeriod', payPeriod);
                }
                if (newSize) {
                    params.append('pageSize', newSize);
                }
                params.append('page', '1');
                window.location.href = appContext + '/hr/payroll-approval' + (params.toString() ? ('?' + params.toString()) : '');
            };

            // Close modal when clicking outside
            document.getElementById('payrollDetailModal').addEventListener('click', function(e) {
                if (e.target === this) {
                    closePayrollModal();
                }
            });

            // Close modal with ESC key
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    const modal = document.getElementById('payrollDetailModal');
                    if (modal && modal.classList.contains('active')) {
                        closePayrollModal();
                    }
                }
            });
        </script>
    </body>
</html>

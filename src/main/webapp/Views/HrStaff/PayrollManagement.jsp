<%-- 
    Document   : PayrollManagement
    Created on : Nov 5, 2025
    Author     : admin
    Description: Payroll Management for HR Staff - Manage Allowances, Deductions, and Payroll
    FIXED: Enhanced JavaScript error handling and form submission flows
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.math.BigDecimal, com.hrm.model.entity.Employee" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Payroll Management - HR Staff</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"/>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/Admin/css/pagination.css"/>
        <style>
            :root {
                --primary:#5b5bd6;
                --secondary:#8b5bd6;
                --bg:#f3f4f6;
                --card:#ffffff;
                --border:#e5e7eb;
                --text:#111827;
                --muted:#6b7280;
                --success:#10b981;
                --error:#ef4444;
                --warning:#f59e0b;
            }

            body {
                background: var(--bg);
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                margin: 0;
                padding: 0;
            }

            .topbar {
                height:64px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                padding:0 20px;
                background: linear-gradient(90deg, var(--primary), var(--secondary));
                color:#fff;
                box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            }

            .brand {
                display:flex;
                align-items:center;
                gap:10px;
                font-weight:700;
                font-size:22px;
            }

            .brand .logo {
                width:28px;
                height:28px;
                background:#fff;
                color:var(--primary);
                border-radius:8px;
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:800;
            }

            .top-actions {
                display:flex;
                align-items:center;
                gap:12px;
            }

            .search {
                display:flex;
                align-items:center;
                gap:8px;
                background:rgba(255,255,255,0.2);
                padding:6px 10px;
                border-radius:999px;
            }

            .search input {
                border:none;
                outline:none;
                background:transparent;
                color:#fff;
                width:280px;
            }

            .btn {
                display:inline-block;
                padding:10px 14px;
                border-radius:8px;
                text-decoration:none;
                color:#fff;
                background:#2563eb;
                border: none;
                cursor: pointer;
                font-size: 14px;
                transition: all 0.2s;
            }

            .btn:hover {
                background: #1d4ed8;
                transform: translateY(-1px);
            }

            .btn.secondary {
                background: var(--success);
            }

            .btn.secondary:hover {
                background: #059669;
            }

            .container {
                width:100%;
                max-width:none;
                margin:0;
                padding: 20px;
                display:grid;
                grid-template-columns: 280px 1fr;
                gap:20px;
                align-items:start;
            }

            .sidebar {
                background: var(--card);
                border:1px solid var(--border);
                border-radius:12px;
                padding:14px;
                position:sticky;
                top:20px;
                height: fit-content;
            }

            .side-group {
                padding:12px 8px;
                border-top:1px solid var(--border);
            }

            .side-group:first-of-type {
                border-top:none;
            }

            .side-title {
                font-weight:700;
                color: var(--muted);
                font-size:13px;
                letter-spacing:.5px;
                text-transform:uppercase;
                margin-bottom:10px;
            }

            .side-link {
                display:flex;
                align-items:center;
                gap:10px;
                padding:12px 10px;
                margin-bottom:8px;
                border-radius:10px;
                color:#111;
                text-decoration:none;
                background:#eef2ff;
                transition: all 0.2s;
            }

            .side-link:hover {
                background: #dbeafe;
            }

            .side-link.neutral {
                background:#fff;
                border:1px solid var(--border);
            }

            .side-link.active {
                background: var(--primary);
                color: #fff;
            }

            .content {
                display:flex;
                flex-direction:column;
                gap:16px;
            }

            .hero {
                background: linear-gradient(90deg, var(--primary), var(--secondary));
                color:#fff;
                border-radius:14px;
                padding:22px;
            }

            .hero h2 {
                margin:0 0 6px 0;
            }

            .hero .muted {
                color: rgba(255,255,255,0.9);
            }

            .card {
                border:1px solid var(--border);
                border-radius:12px;
                background:var(--card);
                padding:20px;
            }

            .muted {
                color: var(--muted);
                font-size:14px;
            }

            /* Tabs */
            .tabs {
                display:flex;
                gap:8px;
                border-bottom:2px solid var(--border);
                margin-bottom:20px;
            }

            .tab-btn {
                padding:12px 24px;
                background:none;
                border:none;
                border-bottom:3px solid transparent;
                cursor:pointer;
                font-size:14px;
                font-weight:600;
                color:var(--muted);
                transition:all 0.2s;
                text-decoration:none;
                display:inline-block;
            }

            .tab-btn:hover {
                color:var(--primary);
                text-decoration:none;
            }

            .tab-btn.active {
                color:var(--primary);
                border-bottom-color:var(--primary);
            }
            
            .tab-btn.active:hover {
                color:var(--primary);
            }

            .tab-content {
                display:none;
            }

            .tab-content.active {
                display:block;
            }

            /* Forms */
            .form-group {
                margin-bottom:20px;
            }

            .form-group label {
                display:block;
                margin-bottom:8px;
                font-weight:600;
                color:var(--text);
            }

            .form-group input,
            .form-group select,
            .form-group textarea {
                width:100%;
                padding:10px 12px;
                border:1px solid var(--border);
                border-radius:8px;
                font-size:14px;
                transition:border-color 0.2s;
            }

            .form-group input:focus,
            .form-group select:focus,
            .form-group textarea:focus {
                outline:none;
                border-color:var(--primary);
            }

            .form-row {
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:16px;
            }

            .required {
                color:var(--error);
            }

            /* Tables */
            table {
                width:100%;
                border-collapse:collapse;
                margin-top:16px;
            }

            th, td {
                padding:12px;
                border-bottom:1px solid var(--border);
                text-align:left;
            }

            th {
                background:#f9fafb;
                font-weight:600;
                color:var(--text);
            }

            tr:hover {
                background:#f9fafb;
            }

            /* Status badges */
            .status-badge {
                padding:4px 12px;
                border-radius:12px;
                font-size:12px;
                font-weight:600;
                display:inline-block;
            }

            .status-Draft {
                background:#e5e7eb;
                color:#374151;
            }

            .status-Pending {
                background:#fef3c7;
                color:#92400e;
            }

            .status-Approved {
                background:#d1fae5;
                color:#065f46;
            }

            .status-Rejected {
                background:#fee2e2;
                color:#991b1b;
            }

            .status-Paid {
                background:#dbeafe;
                color:#1e40af;
            }

            /* Action buttons */
            .action-btns {
                display:flex;
                gap:8px;
            }

            .btn-small {
                padding:6px 12px;
                font-size:12px;
            }

            .btn-danger {
                background:var(--error);
            }

            .btn-danger:hover {
                background:#dc2626;
            }

            .btn-warning {
                background:var(--warning);
            }

            .btn-warning:hover {
                background:#d97706;
            }

            /* Summary cards */
            .summary-grid {
                display:grid;
                grid-template-columns:repeat(4, 1fr);
                gap:16px;
                margin:20px 0;
            }

            .summary-card {
                background:var(--card);
                border:1px solid var(--border);
                border-radius:8px;
                padding:16px;
                border-left:4px solid var(--primary);
            }

            .summary-card h4 {
                margin:0 0 8px 0;
                font-size:12px;
                color:var(--muted);
                text-transform:uppercase;
            }

            .summary-card .value {
                font-size:24px;
                font-weight:700;
                color:var(--text);
            }

            .empty {
                color:var(--muted);
                padding:40px;
                text-align:center;
            }

            /* Modal */
            .modal {
                display:none;
                position:fixed;
                top:0;
                left:0;
                width:100%;
                height:100%;
                background:rgba(0,0,0,0.5);
                z-index:1000;
                align-items:center;
                justify-content:center;
            }

            .modal.active {
                display:flex;
            }

            .modal-content {
                background:var(--card);
                border-radius:12px;
                padding:24px;
                max-width:600px;
                width:90%;
                max-height:90vh;
                overflow-y:auto;
            }

            .modal-header {
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:20px;
            }

            .modal-header h3 {
                margin:0;
            }

            .close-btn {
                background:none;
                border:none;
                font-size:24px;
                cursor:pointer;
                color:var(--muted);
            }

            .close-btn:hover {
                color:var(--text);
            }

            @media (max-width: 1024px) {
                .container {
                    grid-template-columns: 1fr;
                }
                .sidebar {
                    position:relative;
                    top:auto;
                }
                .form-row {
                    grid-template-columns: 1fr;
                }
                .summary-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
            }
            
            /* Pagination styles */
            .pagination-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 1rem;
                background-color: #fff;
                border-radius: 4px;
                margin-top: 1rem;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            }
            
            .pagination-info {
                color: #666;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 20px;
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
                color: #0066cc;
                text-decoration: none;
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
            
            .pagination-controls span.ellipsis {
                border: none;
                padding: 0 4px;
            }
            
            .page-size-selector {
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }
            
            .page-size-selector label {
                font-size: 14px;
                color: #666;
            }
            
            .page-size-selector select {
                padding: 4px 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }
            
            /* Sortable table headers */
            table thead th[style*="cursor:pointer"] {
                user-select: none;
                transition: background-color 0.2s;
            }
            
            table thead th[style*="cursor:pointer"]:hover {
                background-color: #f8f9fa;
            }
        </style>
    </head>
    <body>
        <!-- Top Navigation Bar -->
        <div class="topbar">
            <div class="brand">
                <div class="logo">HR</div>
                <div>HR Dashboard</div>
            </div>
            <div class="top-actions">
                <div class="search">
                    <span>🔍</span>
                    <input type="text" placeholder="Search employees, payroll..."/>
                </div>
                <a class="btn secondary" href="<%=request.getContextPath()%>/homepage">Homepage</a>
            </div>
        </div>

        <div class="container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <div class="side-group">
                    <div class="side-title">Main</div>
                    <a class="side-link" href="<%=request.getContextPath()%>/hrstaff">🏠 HR Home</a>
                </div>
                <div class="side-group">
                    <div class="side-title">Requests & Approvals</div>
                    <a class="side-link neutral" href="#">✅ Requests & Recommendations</a>
                </div>
                <div class="side-group">
                    <div class="side-title">Salary & Contracts</div>
                    <a class="side-link active" href="<%=request.getContextPath()%>/hrstaff/payroll">💰 Payroll</a>
                    <a class="side-link neutral" href="<%=request.getContextPath()%>/hrstaff/contracts/create">📝 Create Contract</a>
                    <a class="side-link neutral" href="<%=request.getContextPath()%>/hrstaff/contracts">📄 Contracts List</a>
                </div>
                <div class="side-group">
                    <div class="side-title">Recruitment</div>
                    <a class="side-link neutral" href="${pageContext.request.contextPath}/postRecruitments">📢 Post Recruitment</a>
                    <a class="side-link neutral" href="${pageContext.request.contextPath}/candidates">👀 View Candidates</a>
                    <a class="side-link neutral" href="#">➕ Create Employee</a>
                </div>
            </aside>

            <!-- Content Area -->
            <main class="content">
                <section class="hero">
                    <h2>Payroll Management</h2>
                    <div class="muted">Manage allowances, deductions, and payroll calculations</div>
                </section>

                <%-- Display success/error messages from session --%>
                <%
                    String successMessage = (String) request.getSession().getAttribute("success");
                    String errorMessage = (String) request.getSession().getAttribute("error");
                    if (successMessage != null) {
                        request.getSession().removeAttribute("success");
                %>
                <div style="background:#d4edda; border:1px solid #c3e6cb; border-radius:6px; padding:12px; margin-bottom:20px; color:#155724;">
                    <strong>✓ Success:</strong> <%= successMessage %>
                </div>
                <%
                    }
                    if (errorMessage != null) {
                        request.getSession().removeAttribute("error");
                %>
                <div style="background:#f8d7da; border:1px solid #f5c6cb; border-radius:6px; padding:12px; margin-bottom:20px; color:#721c24;">
                    <strong>✗ Error:</strong> <%= errorMessage %>
                </div>
                <%
                    }
                %>

                <!-- Tabs -->
                <div class="card">
                    <div class="tabs">
                        <%
                            String currentTab = (String) request.getAttribute("currentTab");
                            if (currentTab == null) currentTab = "allowance";
                        %>
                        <a href="<%=request.getContextPath()%>/hrstaff/payroll?tab=allowance" 
                           class="tab-btn <%= "allowance".equals(currentTab) ? "active" : "" %>">💰 Allowances</a>
                        <a href="<%=request.getContextPath()%>/hrstaff/payroll?tab=deduction" 
                           class="tab-btn <%= "deduction".equals(currentTab) ? "active" : "" %>">➖ Deductions</a>
                        <a href="<%=request.getContextPath()%>/hrstaff/payroll?tab=attendance" 
                           class="tab-btn <%= "attendance".equals(currentTab) ? "active" : "" %>">📅 Attendance</a>
                        <a href="<%=request.getContextPath()%>/hrstaff/payroll?tab=payroll" 
                           class="tab-btn <%= "payroll".equals(currentTab) ? "active" : "" %>">📊 Payroll</a>
                    </div>

                    <!-- Allowance Tab -->
                    <div id="allowance" class="tab-content <%= "allowance".equals(currentTab) ? "active" : "" %>">
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                            <h3 style="margin:0;">Employee Allowances</h3>
                            <button class="btn" onclick="openAllowanceModal()">+ Add Allowance</button>
                        </div>

                        <!-- Filter -->
                        <div class="form-row" style="margin-bottom:20px;">
                            <div class="form-group">
                                <label>Employee</label>
                                <select id="allowanceEmployeeFilter" onchange="filterAllowances()">
                                    <option value="">All Employees</option>
                                    <%
                                        List<Employee> employees = (List<Employee>) request.getAttribute("employees");
                                        String employeeFilter = (String) request.getAttribute("employeeFilter");
                                        if (employees != null) {
                                            for (Employee emp : employees) {
                                                String selected = (employeeFilter != null && employeeFilter.equals(String.valueOf(emp.getEmployeeId()))) ? "selected" : "";
                                    %>
                                    <option value="<%= emp.getEmployeeId() %>" <%= selected %>><%= emp.getFullName() %> (ID: <%= emp.getEmployeeId() %>)</option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Month</label>
                                <input type="month" id="allowanceMonthFilter" onchange="filterAllowances()" value="<%= request.getAttribute("allowanceMonth") != null ? request.getAttribute("allowanceMonth") : "" %>"/>
                            </div>
                        </div>

                        <!-- Allowance List -->
                        <table id="allowanceTable">
                            <thead>
                                <tr>
                                    <th>Employee</th>
                                    <th>Allowance Type</th>
                                    <th>Amount</th>
                                    <th>Month</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="allowanceTableBody">
                                <%
                                    List<Map<String, Object>> allowances = (List<Map<String, Object>>) request.getAttribute("allowances");
                                    if (allowances == null || allowances.isEmpty()) {
                                %>
                                <tr>
                                    <td colspan="5" class="empty">No allowances found. Click "Add Allowance" to add one.</td>
                                </tr>
                                <%
                                    } else {
                                        for (Map<String, Object> allowance : allowances) {
                                %>
                                <tr>
                                    <td><%= allowance.get("employeeName") %></td>
                                    <td><%= allowance.get("allowanceName") %></td>
                                    <td><%= String.format("%,d VNĐ", ((java.math.BigDecimal) allowance.get("amount")).intValue()) %></td>
                                    <td><%= allowance.get("month") %></td>
                                    <td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="btn btn-small" onclick="editAllowance(<%= allowance.get("id") %>)">Edit</button>
                                            <button class="btn btn-small btn-danger" onclick="deleteAllowance(<%= allowance.get("id") %>)">Delete</button>
                                        </div>
                                    </td>
                                    </td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Deduction Tab -->
                    <div id="deduction" class="tab-content <%= "deduction".equals(currentTab) ? "active" : "" %>">
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                            <h3 style="margin:0;">Employee Deductions</h3>
                            <button class="btn" onclick="openDeductionModal()">+ Add Deduction</button>
                        </div>

                        <!-- Filter -->
                        <div class="form-row" style="margin-bottom:20px;">
                            <div class="form-group">
                                <label>Employee</label>
                                <select id="deductionEmployeeFilter" onchange="filterDeductions()">
                                    <option value="">All Employees</option>
                                    <%
                                        if (employees != null) {
                                            for (Employee emp : employees) {
                                                String selected = (employeeFilter != null && employeeFilter.equals(String.valueOf(emp.getEmployeeId()))) ? "selected" : "";
                                    %>
                                    <option value="<%= emp.getEmployeeId() %>" <%= selected %>><%= emp.getFullName() %> (ID: <%= emp.getEmployeeId() %>)</option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Month</label>
                                <input type="month" id="deductionMonthFilter" onchange="filterDeductions()" value="<%= request.getAttribute("deductionMonth") != null ? request.getAttribute("deductionMonth") : "" %>"/>
                            </div>
                        </div>

                        <!-- Deduction List -->
                        <table id="deductionTable">
                            <thead>
                                <tr>
                                    <th>Employee</th>
                                    <th>Deduction Type</th>
                                    <th>Amount</th>
                                    <th>Month</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="deductionTableBody">
                                <%
                                    List<Map<String, Object>> deductions = (List<Map<String, Object>>) request.getAttribute("deductions");
                                    if (deductions == null || deductions.isEmpty()) {
                                %>
                                <tr>
                                    <td colspan="5" class="empty">No deductions found. Click "Add Deduction" to add one.</td>
                                </tr>
                                <%
                                    } else {
                                        for (Map<String, Object> deduction : deductions) {
                                %>
                                <tr>
                                    <td><%= deduction.get("employeeName") %></td>
                                    <td><%= deduction.get("deductionName") %></td>
                                    <td><%= String.format("%,d VNĐ", ((java.math.BigDecimal) deduction.get("amount")).intValue()) %></td>
                                    <td><%= deduction.get("month") %></td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="btn btn-small" onclick="editDeduction(<%= deduction.get("id") %>)">Edit</button>
                                            <button class="btn btn-small btn-danger" onclick="deleteDeduction(<%= deduction.get("id") %>)">Delete</button>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Attendance Tab -->
                    <div id="attendance" class="tab-content <%= "attendance".equals(currentTab) ? "active" : "" %>">
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                            <h3 style="margin:0;">Attendance Statistics</h3>
                            <div class="muted">View attendance data for payroll calculation</div>
                        </div>

                        <!-- Filter -->
                        <div class="form-row" style="margin-bottom:20px;">
                            <div class="form-group">
                                <label>Employee</label>
                                <select id="attendanceEmployeeFilter" onchange="filterAttendance()">
                                    <option value="">Select Employee</option>
                                    <%
                                        String attendanceEmployeeFilter = request.getParameter("employeeFilter");
                                        if (employees != null) {
                                            for (Employee emp : employees) {
                                                String selected = (attendanceEmployeeFilter != null && attendanceEmployeeFilter.equals(String.valueOf(emp.getEmployeeId()))) ? "selected" : "";
                                    %>
                                    <option value="<%= emp.getEmployeeId() %>" <%= selected %>><%= emp.getFullName() %> (ID: <%= emp.getEmployeeId() %>)</option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Month</label>
                                <input type="month" id="attendanceMonthFilter" onchange="filterAttendance()" value="<%= request.getAttribute("attendanceMonth") != null ? request.getAttribute("attendanceMonth") : "" %>"/>
                            </div>
                        </div>

                        <!-- Attendance Statistics -->
                        <div id="attendanceStats" style="display:none;">
                            <div class="summary-grid" style="grid-template-columns: repeat(3, 1fr); margin-bottom:20px;">
                                <div class="summary-card">
                                    <h4>Actual Work Days</h4>
                                    <div class="value" id="statWorkDays">0 days</div>
                                    <div class="muted" style="margin-top:4px;" id="statPaidLeaveInfo">0 paid leave days</div>
                                </div>
                                <div class="summary-card" style="border-left-color:var(--error);">
                                    <h4>Unpaid Leave</h4>
                                    <div class="value" id="statUnpaidLeave" style="color:var(--error);">0 days</div>
                                    <div class="muted" style="margin-top:4px;" id="statUnpaidLeaveAmount">0 VNĐ</div>
                                </div>
                                <div class="summary-card" style="border-left-color:var(--warning);">
                                    <h4>Late Arrivals</h4>
                                    <div class="value" id="statLateCount" style="color:var(--warning);">0 times</div>
                                    <div class="muted" style="margin-top:4px;" id="statLatePenalty">0 VNĐ</div>
                                </div>
                            </div>
                            <div class="summary-grid" style="grid-template-columns: repeat(2, 1fr); margin-bottom:20px;">
                                <div class="summary-card" style="border-left-color:var(--warning);">
                                    <h4>Early Leave</h4>
                                    <div class="value" id="statEarlyLeave">0 times</div>
                                </div>
                                <div class="summary-card" style="border-left-color:var(--success);">
                                    <h4>Overtime Hours</h4>
                                    <div class="value" id="statOvertimeHours" style="color:var(--success);">0.0 hours</div>
                                    <div class="muted" style="margin-top:4px;" id="statOvertimeAmount">0 VNĐ</div>
                                </div>
                            </div>
                            <div style="background:#f0f9ff; border:1px solid #bae6fd; border-radius:8px; padding:16px; margin-top:20px;">
                                <h4 style="margin:0 0 12px 0; color:#0369a1;">💡 Quick Actions</h4>
                                <div style="display:flex; gap:8px; flex-wrap:wrap;">
                                    <button class="btn btn-small" onclick="applyAttendanceDeductions()">Apply Deductions from Attendance</button>
                                    <button class="btn btn-small secondary" onclick="applyAttendanceAllowances()">Apply Allowances from Attendance</button>
                                </div>
                                <div class="muted" style="margin-top:8px; font-size:12px;">
                                    This will automatically create deduction entries for unpaid leave and late penalties, 
                                    and allowance entries for overtime work.
                                </div>
                            </div>
                        </div>
                        <div id="attendanceEmpty" class="empty" style="display:none;">
                            Please select an employee and month to view attendance statistics.
                        </div>
                    </div>

                    <!-- Payroll Tab -->
                    <div id="payroll" class="tab-content <%= "payroll".equals(currentTab) ? "active" : "" %>">
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                            <h3 style="margin:0;">Payroll Calculation</h3>
                            <div style="display:flex; gap:8px;">
                                <button class="btn btn-small" onclick="generatePayrollForAll()" style="background:var(--warning);" title="Generate payroll for all active employees using stored procedure">
                                    ⚡ Generate All (SP)
                                </button>
                                <button class="btn" onclick="openPayrollModal()">+ Create Payroll</button>
                            </div>
                        </div>
                        
                        <div style="background:#f0f9ff; border:1px solid #bae6fd; border-radius:8px; padding:16px; margin-bottom:20px;">
                            <h4 style="margin:0 0 8px 0; color:#0369a1;">💡 Payroll Calculation Method</h4>
                            <div style="font-size:13px; color:var(--muted);">
                                <strong>Automatic Calculation:</strong> System automatically calculates payroll using stored procedure <code>sp_GeneratePayrollImproved</code>:
                                <ul style="margin:8px 0 0 20px; padding:0;">
                                    <li><strong>Actual Working Days:</strong> Calculated from Attendance records (WorkingHours / 8)</li>
                                    <li><strong>Paid Leave Days:</strong> Calculated from approved leave requests (Annual, Sick, Maternity)</li>
                                    <li><strong>Actual Base Salary:</strong> (ActualWorkingDays + PaidLeaveDays) × (BaseSalary / 26)</li>
                                    <li><strong>Overtime Salary:</strong> OvertimeHours × (BaseSalary / 208) × 1.5</li>
                                    <li><strong>Insurance:</strong> BHXH (8%), BHYT (1.5%), BHTN (1%) from BaseSalary</li>
                                    <li><strong>Tax (TNCN):</strong> Calculated from TaxableIncome after relief (11,000,000 + 4,400,000 × dependents)</li>
                                    <li><strong>Net Salary:</strong> ActualBaseSalary + OTSalary + Allowance - TotalDeduction</li>
                                </ul>
                            </div>
                        </div>

                        <!-- Filter -->
                        <div class="form-row" style="margin-bottom:20px;">
                            <div class="form-group">
                                <label>Employee</label>
                                <select id="payrollEmployeeFilter" onchange="filterPayrolls()">
                                    <option value="">All Employees</option>
                                    <%
                                        if (employees != null) {
                                            for (Employee emp : employees) {
                                                String selected = (employeeFilter != null && employeeFilter.equals(String.valueOf(emp.getEmployeeId()))) ? "selected" : "";
                                    %>
                                    <option value="<%= emp.getEmployeeId() %>" <%= selected %>><%= emp.getFullName() %> (ID: <%= emp.getEmployeeId() %>)</option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Status</label>
                                <select id="payrollStatusFilter" onchange="filterPayrolls()">
                                    <option value="">All Status</option>
                                    <%
                                        String statusFilter = (String) request.getAttribute("statusFilter");
                                        String[] statuses = {"Draft", "Pending", "Approved", "Rejected", "Paid"};
                                        for (String status : statuses) {
                                            String selected = (statusFilter != null && statusFilter.equals(status)) ? "selected" : "";
                                    %>
                                    <option value="<%= status %>" <%= selected %>><%= status %></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                        </div>

                        <!-- Payroll List -->
                        <table id="payrollTable">
                            <thead>
                                <tr>
                                    <%
                                        String sortBy = (String) request.getAttribute("sortBy");
                                        String sortOrder = (String) request.getAttribute("sortOrder");
                                        if (sortBy == null) sortBy = "PayPeriod";
                                        if (sortOrder == null) sortOrder = "DESC";
                                    %>
                                    <th style="cursor:pointer;" onclick="sortPayrollTable('FullName')">
                                        Employee<%
                                            if ("FullName".equals(sortBy)) {
                                                out.print(sortOrder.equals("ASC") ? " ▲" : " ▼");
                                            }
                                        %>
                                    </th>
                                    <th style="cursor:pointer;" onclick="sortPayrollTable('PayPeriod')">
                                        Pay Period<%
                                            if ("PayPeriod".equals(sortBy)) {
                                                out.print(sortOrder.equals("ASC") ? " ▲" : " ▼");
                                            }
                                        %>
                                    </th>
                                    <th style="cursor:pointer;" onclick="sortPayrollTable('BaseSalary')">
                                        Actual Base Salary<%
                                            if ("BaseSalary".equals(sortBy)) {
                                                out.print(sortOrder.equals("ASC") ? " ▲" : " ▼");
                                            }
                                        %>
                                    </th>
                                    <th style="cursor:pointer;" onclick="sortPayrollTable('Bonus')">
                                        OT Salary<%
                                            if ("Bonus".equals(sortBy)) {
                                                out.print(sortOrder.equals("ASC") ? " ▲" : " ▼");
                                            }
                                        %>
                                    </th>
                                    <th style="cursor:pointer;" onclick="sortPayrollTable('Allowance')">
                                        Allowance<%
                                            if ("Allowance".equals(sortBy)) {
                                                out.print(sortOrder.equals("ASC") ? " ▲" : " ▼");
                                            }
                                        %>
                                    </th>
                                    <th style="cursor:pointer;" onclick="sortPayrollTable('Deduction')">
                                        Deduction<%
                                            if ("Deduction".equals(sortBy)) {
                                                out.print(sortOrder.equals("ASC") ? " ▲" : " ▼");
                                            }
                                        %>
                                    </th>
                                    <th style="cursor:pointer;" onclick="sortPayrollTable('NetSalary')">
                                        Net Salary<%
                                            if ("NetSalary".equals(sortBy)) {
                                                out.print(sortOrder.equals("ASC") ? " ▲" : " ▼");
                                            }
                                        %>
                                    </th>
                                    <th style="cursor:pointer;" onclick="sortPayrollTable('Status')">
                                        Status<%
                                            if ("Status".equals(sortBy)) {
                                                out.print(sortOrder.equals("ASC") ? " ▲" : " ▼");
                                            }
                                        %>
                                    </th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="payrollTableBody">
                                <%
                                    List<Map<String, Object>> payrolls = (List<Map<String, Object>>) request.getAttribute("payrolls");
                                    if (payrolls == null || payrolls.isEmpty()) {
                                %>
                                <tr>
                                    <td colspan="9" class="empty">No payroll found. Click "Create Payroll" to create one.</td>
                                </tr>
                                <%
                                    } else {
                                        for (Map<String, Object> payroll : payrolls) {
                                            String status = (String) payroll.get("status");
                                %>
                                <tr>
                                    <td><%= payroll.get("employeeName") %></td>
                                    <td><%= payroll.get("payPeriod") %></td>
                                    <td><%= String.format("%,d VNĐ", ((java.math.BigDecimal) payroll.get("baseSalary")).intValue()) %></td>
                                    <td><%= String.format("%,d VNĐ", ((java.math.BigDecimal) payroll.get("bonus")).intValue()) %></td>
                                    <td><%= String.format("%,d VNĐ", ((java.math.BigDecimal) payroll.get("allowance")).intValue()) %></td>
                                    <td><%= String.format("%,d VNĐ", ((java.math.BigDecimal) payroll.get("deduction")).intValue()) %></td>
                                    <td><strong><%= String.format("%,d VNĐ", ((java.math.BigDecimal) payroll.get("netSalary")).intValue()) %></strong></td>
                                    <td>
                                        <span class="status-badge status-<%= status %>"><%= status %></span>
                                    </td>
                                    <td>
                                        <div class="action-btns">
                                            <%
                                                if ("Draft".equals(status)) {
                                            %>
                                            <button class="btn btn-small" onclick="editPayroll(<%= payroll.get("payrollId") %>)">Edit</button>
                                            <button class="btn btn-small secondary" onclick="submitPayroll(<%= payroll.get("payrollId") %>)">Submit</button>
                                            <button class="btn btn-small btn-danger" onclick="deletePayroll(<%= payroll.get("payrollId") %>)">Delete</button>
                                            <%
                                                } else {
                                            %>
                                            <button class="btn btn-small" onclick="viewPayrollDetails(<%= payroll.get("payrollId") %>)">View Details</button>
                                            <%
                                                }
                                            %>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                        
                        <%-- Pagination Bar (only show for payroll tab) --%>
                        <c:if test="${currentTab == 'payroll'}">
                            <div class="pagination-bar">
                                <div class="pagination-info">
                                    <c:set var="total" value="${total != null ? total : 0}" />
                                    <c:set var="page" value="${page != null ? page : 1}" />
                                    <c:set var="pageSize" value="${pageSize != null ? pageSize : 10}" />
                                    <c:set var="totalPages" value="${totalPages != null ? totalPages : 1}" />
                                    
                                    <%-- Calculate display range --%>
                                    <c:set var="start" value="${total > 0 ? (page - 1) * pageSize + 1 : 0}" />
                                    <c:set var="end" value="${page * pageSize}" />
                                    <c:if test="${end > total}">
                                        <c:set var="end" value="${total}" />
                                    </c:if>
                                    <span>Showing ${start} - ${end} of ${total}</span>
                                    
                                    <div class="page-size-selector" style="margin-left: 20px; display: inline-block;">
                                        <label for="pageSizeSelect" style="margin-right: 8px;">Items per page:</label>
                                        <select id="pageSizeSelect" onchange="changePayrollPageSize(this.value)" style="padding: 4px 8px; border: 1px solid #ddd; border-radius: 4px;">
                                            <option value="5" <c:if test="${pageSize == 5}">selected</c:if>>5</option>
                                            <option value="10" <c:if test="${pageSize == 10}">selected</c:if>>10</option>
                                            <option value="20" <c:if test="${pageSize == 20}">selected</c:if>>20</option>
                                            <option value="50" <c:if test="${pageSize == 50}">selected</c:if>>50</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="pagination-controls">
                                    <%-- Base URL --%>
                                    <c:url var="baseUrl" value="/hrstaff/payroll">
                                        <c:param name="tab" value="payroll" />
                                        <c:param name="pageSize" value="${pageSize}" />
                                        <c:param name="employeeFilter" value="${employeeFilter != null ? employeeFilter : ''}" />
                                        <c:param name="statusFilter" value="${statusFilter != null ? statusFilter : ''}" />
                                        <c:param name="sortBy" value="${sortBy != null ? sortBy : 'PayPeriod'}" />
                                        <c:param name="sortOrder" value="${sortOrder != null ? sortOrder : 'DESC'}" />
                                    </c:url>

                                    <%-- Previous button --%>
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

                                    <%-- Page numbers --%>
                                    <c:set var="range" value="2" />
                                    <c:set var="start_page" value="${page - range > 1 ? page - range : 1}" />
                                    <c:set var="end_page" value="${page + range < totalPages ? page + range : totalPages}" />

                                    <c:if test="${start_page > 1}">
                                        <c:url var="firstPageUrl" value="${baseUrl}">
                                            <c:param name="page" value="1" />
                                        </c:url>
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
                                                <c:url var="pageUrl" value="${baseUrl}">
                                                    <c:param name="page" value="${i}" />
                                                </c:url>
                                                <a href="${pageUrl}" class="btn-pagination">${i}</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>

                                    <c:if test="${end_page < totalPages}">
                                        <c:if test="${end_page < totalPages - 1}">
                                            <span class="ellipsis">...</span>
                                        </c:if>
                                        <c:url var="lastPageUrl" value="${baseUrl}">
                                            <c:param name="page" value="${totalPages}" />
                                        </c:url>
                                        <a href="${lastPageUrl}" class="btn-pagination">${totalPages}</a>
                                    </c:if>

                                    <%-- Next button --%>
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
                        </c:if>
                    </div>
                </div>
            </main>
        </div>

        <!-- Allowance Modal -->
        <div id="allowanceModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="allowanceModalTitle">Add Allowance</h3>
                    <button class="close-btn" onclick="closeAllowanceModal()">&times;</button>
                </div>
                <form id="allowanceForm" method="POST" action="<%=request.getContextPath()%>/hrstaff/payroll/allowance">
                    <input type="hidden" id="allowanceId" name="allowanceId"/>
                    <div class="form-group">
                        <label>Employee <span class="required">*</span></label>
                        <select id="allowanceEmployee" name="employeeId" required>
                            <option value="">Select Employee</option>
                            <%
                                if (employees != null) {
                                    for (Employee emp : employees) {
                            %>
                            <option value="<%= emp.getEmployeeId() %>"><%= emp.getFullName() %> (ID: <%= emp.getEmployeeId() %>)</option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Allowance Type <span class="required">*</span></label>
                        <select id="allowanceType" name="allowanceTypeId" required>
                            <option value="">Select Allowance Type</option>
                            <%
                                List<Map<String, Object>> allowanceTypes = (List<Map<String, Object>>) request.getAttribute("allowanceTypes");
                                if (allowanceTypes != null) {
                                    for (Map<String, Object> type : allowanceTypes) {
                            %>
                            <option value="<%= type.get("allowanceTypeId") %>"><%= type.get("allowanceName") %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Amount (VNĐ) <span class="required">*</span></label>
                            <input type="number" id="allowanceAmount" name="amount" min="0" step="1000" required/>
                        </div>
                        <div class="form-group">
                            <label>Month <span class="required">*</span></label>
                            <input type="month" id="allowanceMonth" name="month" required/>
                        </div>
                    </div>
                    <div style="display:flex; gap:8px; justify-content:flex-end; margin-top:20px;">
                        <button type="button" class="btn btn-small" onclick="closeAllowanceModal()">Cancel</button>
                        <button type="submit" class="btn btn-small">Save</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Deduction Modal -->
        <div id="deductionModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="deductionModalTitle">Add Deduction</h3>
                    <button class="close-btn" onclick="closeDeductionModal()">&times;</button>
                </div>
                <form id="deductionForm" method="POST" action="<%=request.getContextPath()%>/hrstaff/payroll/deduction">
                    <input type="hidden" id="deductionId" name="deductionId"/>
                    <div class="form-group">
                        <label>Employee <span class="required">*</span></label>
                        <select id="deductionEmployee" name="employeeId" required>
                            <option value="">Select Employee</option>
                            <%
                                if (employees != null) {
                                    for (Employee emp : employees) {
                            %>
                            <option value="<%= emp.getEmployeeId() %>"><%= emp.getFullName() %> (ID: <%= emp.getEmployeeId() %>)</option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Deduction Type <span class="required">*</span></label>
                        <select id="deductionType" name="deductionTypeId" required>
                            <option value="">Select Deduction Type</option>
                            <%
                                List<Map<String, Object>> deductionTypes = (List<Map<String, Object>>) request.getAttribute("deductionTypes");
                                if (deductionTypes != null) {
                                    for (Map<String, Object> type : deductionTypes) {
                            %>
                            <option value="<%= type.get("deductionTypeId") %>"><%= type.get("deductionName") %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Amount (VNĐ) <span class="required">*</span></label>
                            <input type="number" id="deductionAmount" name="amount" min="0" step="1000" required/>
                        </div>
                        <div class="form-group">
                            <label>Month <span class="required">*</span></label>
                            <input type="month" id="deductionMonth" name="month" required/>
                        </div>
                    </div>
                    <div style="display:flex; gap:8px; justify-content:flex-end; margin-top:20px;">
                        <button type="button" class="btn btn-small" onclick="closeDeductionModal()">Cancel</button>
                        <button type="submit" class="btn btn-small">Save</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Payroll Details Modal -->
        <div id="payrollDetailsModal" class="modal">
            <div class="modal-content" style="max-width:900px;">
                <div class="modal-header">
                    <h3>Payroll Details</h3>
                    <button class="close-btn" onclick="closePayrollDetailsModal()">&times;</button>
                </div>
                <div id="payrollDetailsContent">
                    <!-- Content will be loaded dynamically -->
                </div>
            </div>
        </div>

        <!-- Payroll Modal -->
        <div id="payrollModal" class="modal">
            <div class="modal-content" style="max-width:800px;">
                <div class="modal-header">
                    <h3>Create/Edit Payroll</h3>
                    <button class="close-btn" onclick="closePayrollModal()">&times;</button>
                </div>
                <form id="payrollForm" method="POST" action="<%=request.getContextPath()%>/hrstaff/payroll">
                    <input type="hidden" id="payrollId" name="payrollId"/>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Employee <span class="required">*</span></label>
                            <select id="payrollEmployee" name="employeeId" required onchange="loadEmployeePayrollData()">
                                <option value="">Select Employee</option>
                                <%
                                    if (employees != null) {
                                        for (Employee emp : employees) {
                                %>
                                <option value="<%= emp.getEmployeeId() %>"><%= emp.getFullName() %> (ID: <%= emp.getEmployeeId() %>)</option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Pay Period (Month) <span class="required">*</span></label>
                            <input type="month" id="payrollPeriod" name="payPeriod" required onchange="loadEmployeePayrollData()"/>
                        </div>
                    </div>

                    <!-- Attendance Info Section -->
                    <div id="attendanceInfoSection" style="display:none; background:#f0f9ff; border:1px solid #bae6fd; border-radius:8px; padding:16px; margin-bottom:20px;">
                        <div style="margin-bottom:12px;">
                            <h4 style="margin:0; color:#0369a1;">📅 Attendance Summary</h4>
                            <div class="muted" style="font-size:12px; margin-top:4px;">Attendance data is automatically calculated and applied to payroll</div>
                        </div>
                        <div class="summary-grid" style="grid-template-columns: repeat(4, 1fr); gap:12px; margin:0;">
                            <div style="background:white; padding:12px; border-radius:6px;">
                                <div style="font-size:11px; color:var(--muted); margin-bottom:4px;">Actual Work Days</div>
                                <div style="font-weight:600; font-size:16px;" id="attWorkDays">0 days</div>
                                <div style="font-size:10px; color:var(--muted); margin-top:2px;" id="attPaidLeaveInfo">0 paid leave days</div>
                            </div>
                            <div style="background:white; padding:12px; border-radius:6px; border-left:3px solid var(--error);">
                                <div style="font-size:11px; color:var(--muted); margin-bottom:4px;">Unpaid Leave</div>
                                <div style="font-weight:600; font-size:16px; color:var(--error);" id="attUnpaidLeave">0 days</div>
                                <div style="font-size:11px; color:var(--muted);" id="attUnpaidLeaveAmt">0 VNĐ</div>
                            </div>
                            <div style="background:white; padding:12px; border-radius:6px; border-left:3px solid var(--warning);">
                                <div style="font-size:11px; color:var(--muted); margin-bottom:4px;">Late Arrivals</div>
                                <div style="font-weight:600; font-size:16px; color:var(--warning);" id="attLateCount">0 times</div>
                                <div style="font-size:11px; color:var(--muted);" id="attLatePenalty">0 VNĐ</div>
                            </div>
                            <div style="background:white; padding:12px; border-radius:6px; border-left:3px solid var(--success);">
                                <div style="font-size:11px; color:var(--muted); margin-bottom:4px;">Overtime</div>
                                <div style="font-weight:600; font-size:16px; color:var(--success);" id="attOvertimeHours">0.0h</div>
                                <div style="font-size:11px; color:var(--muted);" id="attOvertimeAmt">0 VNĐ</div>
                            </div>
                        </div>
                    </div>

                    <!-- Insurance & Tax Info Section -->
                    <div id="insuranceTaxSection" style="display:none; background:#fef3c7; border:1px solid #fcd34d; border-radius:8px; padding:16px; margin-bottom:20px;">
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
                            <h4 style="margin:0; color:#92400e;">💰 Insurance & Tax Calculation</h4>
                        </div>
                        <div id="insuranceWarning" style="display:none; background:#fee2e2; border:1px solid #fca5a5; border-radius:6px; padding:12px; margin-bottom:12px; color:#991b1b; font-size:13px;">
                            <strong>⚠️ Lưu ý:</strong> Nhân viên này chưa có <strong>Base Salary</strong> (chưa có Contract hoặc Contract chưa có lương cơ bản). 
                            Vui lòng tạo/ cập nhật Contract trước khi tính bảo hiểm và thuế.
                            <br/><br/>
                            <strong>Hướng dẫn:</strong>
                            <ul style="margin:8px 0 0 20px; padding:0;">
                                <li>Kiểm tra xem nhân viên có Contract chưa</li>
                                <li>Đảm bảo Contract có BaseSalary > 0</li>
                                <li>Đảm bảo Contract có StartDate <= ngày cuối tháng tính lương</li>
                                <li>Đảm bảo Contract có EndDate >= ngày đầu tháng tính lương (hoặc EndDate IS NULL)</li>
                            </ul>
                        </div>
                        <div id="baseSalaryWarning" style="display:none; background:#fef3c7; border:1px solid #fcd34d; border-radius:6px; padding:12px; margin-bottom:12px; color:#92400e; font-size:13px;">
                            <strong>ℹ️ Thông tin:</strong> Base Salary từ Contract: <strong id="displayBaseSalary">0 VNĐ</strong>
                        </div>
                        <div class="summary-grid" style="grid-template-columns: repeat(4, 1fr); gap:12px; margin:0;">
                            <div style="background:white; padding:12px; border-radius:6px; border-left:3px solid #3b82f6;">
                                <div style="font-size:11px; color:var(--muted); margin-bottom:4px;">BHXH (8%)</div>
                                <div style="font-weight:600; font-size:16px; color:#3b82f6;" id="insBHXH">0 VNĐ</div>
                            </div>
                            <div style="background:white; padding:12px; border-radius:6px; border-left:3px solid #10b981;">
                                <div style="font-size:11px; color:var(--muted); margin-bottom:4px;">BHYT (1.5%)</div>
                                <div style="font-weight:600; font-size:16px; color:#10b981;" id="insBHYT">0 VNĐ</div>
                            </div>
                            <div style="background:white; padding:12px; border-radius:6px; border-left:3px solid #8b5cf6;">
                                <div style="font-size:11px; color:var(--muted); margin-bottom:4px;">BHTN (1%)</div>
                                <div style="font-weight:600; font-size:16px; color:#8b5cf6;" id="insBHTN">0 VNĐ</div>
                            </div>
                            <div style="background:white; padding:12px; border-radius:6px; border-left:3px solid var(--error);">
                                <div style="font-size:11px; color:var(--muted); margin-bottom:4px;">Tax (TNCN)</div>
                                <div style="font-weight:600; font-size:16px; color:var(--error);" id="insTax">0 VNĐ</div>
                            </div>
                        </div>
                        <div style="margin-top:12px; padding-top:12px; border-top:1px solid #fcd34d; display:flex; justify-content:space-between; font-size:12px;">
                            <div>
                                <span style="color:var(--muted);">Taxable Income:</span>
                                <strong id="insTaxableIncome">0 VNĐ</strong>
                            </div>
                            <div>
                                <span style="color:var(--muted);">Dependents:</span>
                                <strong id="insDependents">0</strong>
                            </div>
                            <div>
                                <span style="color:var(--muted);">Total Insurance:</span>
                                <strong id="insTotal">0 VNĐ</strong>
                            </div>
                        </div>
                    </div>

                    <!-- Summary Cards -->
                    <div class="summary-grid" id="payrollSummary" style="display:none; grid-template-columns: repeat(5, 1fr);">
                        <div class="summary-card">
                            <h4>Base Salary</h4>
                            <div class="value" id="summaryBaseSalary" style="font-size:18px;">0 VNĐ</div>
                            <div class="muted" style="margin-top:4px; font-size:11px;">Contract base</div>
                        </div>
                        <div class="summary-card">
                            <h4>Actual Base Salary</h4>
                            <div class="value" id="summaryActualBaseSalary" style="font-size:18px;">0 VNĐ</div>
                            <div class="muted" style="margin-top:4px; font-size:11px;" id="summaryActualBaseSalaryDesc">Based on attendance</div>
                        </div>
                        <div class="summary-card">
                            <h4>OT Salary</h4>
                            <div class="value" id="summaryOTSalary" style="font-size:18px; color:var(--success);">0 VNĐ</div>
                            <div class="muted" style="margin-top:4px; font-size:11px;" id="summaryOTHours">0 hours</div>
                        </div>
                        <div class="summary-card">
                            <h4>Total Allowance</h4>
                            <div class="value" id="summaryAllowance" style="font-size:18px;">0 VNĐ</div>
                        </div>
                        <div class="summary-card">
                            <h4>Total Deduction</h4>
                            <div class="value" id="summaryDeduction" style="font-size:18px; color:var(--error);">0 VNĐ</div>
                            <div class="muted" style="margin-top:4px; font-size:11px;" id="deductionBreakdown">Insurance & tax</div>
                        </div>
                    </div>
                    
                    <div class="summary-card" id="summaryNetSalaryCard" style="display:none; margin-top:16px; border-left:4px solid var(--success);">
                        <h4>Net Salary</h4>
                        <div class="value" id="summaryNetSalary" style="color:var(--success); font-size:28px;">0 VNĐ</div>
                        <div class="muted" style="margin-top:4px; font-size:12px;">Actual Base Salary + OT Salary + Allowance - Total Deduction</div>
                    </div>

                    <input type="hidden" id="payrollBaseSalary" name="baseSalary"/>
                    <input type="hidden" id="payrollActualBaseSalary" name="actualBaseSalary"/>
                    <input type="hidden" id="payrollOTSalary" name="otSalary"/>
                    <input type="hidden" id="payrollAllowance" name="allowance"/>
                    <input type="hidden" id="payrollDeduction" name="deduction"/>
                    <input type="hidden" id="payrollNetSalary" name="netSalary"/>

                    <div style="display:flex; gap:8px; justify-content:flex-end; margin-top:20px;">
                        <button type="button" class="btn btn-small" onclick="closePayrollModal()">Cancel</button>
                        <button type="submit" class="btn btn-small" name="action" value="save">Save Draft</button>
                        <button type="submit" class="btn btn-small secondary" name="action" value="submit">Submit for Approval</button>
                    </div>
                </form>
            </div>
        </div>

        <script>

            // Tab switching is now handled by URL parameters and backend rendering
            // No need for showTab function anymore

            function openAllowanceModal() {
                const modal = document.getElementById('allowanceModal');
                if (modal) {
                    modal.classList.add('active');
                    document.getElementById('allowanceModalTitle').textContent = 'Add Allowance';
                    document.getElementById('allowanceForm').reset();
                    document.getElementById('allowanceId').value = '';
                }
            }

            function closeAllowanceModal() {
                const modal = document.getElementById('allowanceModal');
                if (modal) {
                    modal.classList.remove('active');
                }
            }

            function openDeductionModal() {
                const modal = document.getElementById('deductionModal');
                if (modal) {
                    modal.classList.add('active');
                    document.getElementById('deductionModalTitle').textContent = 'Add Deduction';
                    document.getElementById('deductionForm').reset();
                    document.getElementById('deductionId').value = '';
                }
            }

            function closeDeductionModal() {
                const modal = document.getElementById('deductionModal');
                if (modal) {
                    modal.classList.remove('active');
                }
            }

            function openPayrollModal() {
                const modal = document.getElementById('payrollModal');
                if (modal) {
                    modal.classList.add('active');
                    document.getElementById('payrollForm').reset();
                    document.getElementById('payrollId').value = '';
                    document.getElementById('payrollSummary').style.display = 'none';
                    document.getElementById('attendanceInfoSection').style.display = 'none';
                    document.getElementById('insuranceTaxSection').style.display = 'none';
                    
                    // Set default month to current month if empty
                    const payrollPeriod = document.getElementById('payrollPeriod');
                    if (payrollPeriod && !payrollPeriod.value) {
                        const now = new Date();
                        const year = now.getFullYear();
                        const month = String(now.getMonth() + 1).padStart(2, '0');
                        payrollPeriod.value = `${year}-${month}`;
                    }
                }
            }

            function closePayrollModal() {
                const modal = document.getElementById('payrollModal');
                if (modal) {
                    modal.classList.remove('active');
                }
            }

            function editAllowance(id) {
                if (!id) {
                    console.error('Invalid allowance ID');
                    return;
                }
                fetch('<%=request.getContextPath()%>/api/allowance/' + id)
                        .then(r => r.json())
                        .then(data => {
                            document.getElementById('allowanceId').value = data.id;
                            document.getElementById('allowanceEmployee').value = data.employeeId;
                            document.getElementById('allowanceType').value = data.allowanceTypeId;
                            document.getElementById('allowanceAmount').value = data.amount;
                            document.getElementById('allowanceMonth').value = data.month;
                            document.getElementById('allowanceModalTitle').textContent = 'Edit Allowance';
                            openAllowanceModal();
                        })
                        .catch(err => console.error('Error loading allowance:', err));
            }

            function editDeduction(id) {
                if (!id) {
                    console.error('Invalid deduction ID');
                    return;
                }
                fetch('<%=request.getContextPath()%>/api/deduction/' + id)
                        .then(r => r.json())
                        .then(data => {
                            document.getElementById('deductionId').value = data.id;
                            document.getElementById('deductionEmployee').value = data.employeeId;
                            document.getElementById('deductionType').value = data.deductionTypeId;
                            document.getElementById('deductionAmount').value = data.amount;
                            document.getElementById('deductionMonth').value = data.month;
                            document.getElementById('deductionModalTitle').textContent = 'Edit Deduction';
                            openDeductionModal();
                        })
                        .catch(err => console.error('Error loading deduction:', err));
            }

            function editPayroll(id) {
                if (!id) {
                    console.error('Invalid payroll ID');
                    return;
                }
                console.log('Loading payroll data for ID:', id);
                
                fetch('<%=request.getContextPath()%>/api/payroll?payrollId=' + id)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network error: ' + response.status);
                        }
                        return response.json();
                    })
                    .then(data => {
                        console.log('Payroll data loaded:', data);
                        
                        // Populate form fields
                        document.getElementById('payrollId').value = data.payrollId;
                        document.getElementById('payrollEmployee').value = data.employeeId;
                        document.getElementById('payrollPeriod').value = data.payPeriod;
                        
                        // Set base salary (from Payroll table - this is actual base salary)
                        const actualBaseSalary = parseFloat(data.baseSalary) || 0;
                        const otSalary = parseFloat(data.bonus) || 0; // Bonus field stores OT Salary
                        const allowance = parseFloat(data.allowance) || 0;
                        const deduction = parseFloat(data.deduction) || 0;
                        const netSalary = parseFloat(data.netSalary) || 0;
                        
                        // Set hidden fields
                        document.getElementById('payrollBaseSalary').value = actualBaseSalary;
                        document.getElementById('payrollActualBaseSalary').value = actualBaseSalary;
                        document.getElementById('payrollOTSalary').value = otSalary;
                        document.getElementById('payrollAllowance').value = allowance;
                        document.getElementById('payrollDeduction').value = deduction;
                        document.getElementById('payrollNetSalary').value = netSalary;
                        
                        // Update summary display
                        updatePayrollSummary({
                            baseSalary: actualBaseSalary,
                            actualBaseSalary: actualBaseSalary,
                            otSalary: otSalary,
                            totalAllowance: allowance,
                            totalDeduction: deduction,
                            netSalary: netSalary
                        });
                        
                        // Load employee payroll data to get attendance and insurance info
                        loadEmployeePayrollData();
                        
                        // Open modal
                        openPayrollModal();
                    })
                    .catch(err => {
                        console.error('Error loading payroll:', err);
                        alert('Error loading payroll data: ' + err.message);
                    });
            }

            function deleteAllowance(id) {
                if (confirm('Are you sure you want to delete this allowance?')) {
                    window.location.href = '<%=request.getContextPath()%>/hrstaff/payroll/allowance/delete?allowanceId=' + id;
                }
            }

            function deleteDeduction(id) {
                if (confirm('Are you sure you want to delete this deduction?')) {
                    window.location.href = '<%=request.getContextPath()%>/hrstaff/payroll/deduction/delete?deductionId=' + id;
                }
            }

            function deletePayroll(id) {
                if (confirm('Are you sure you want to delete this payroll?')) {
                    const urlParams = new URLSearchParams(window.location.search);
                    let url = '<%=request.getContextPath()%>/hrstaff/payroll/delete?payrollId=' + id;
                    // Preserve pagination parameters
                    if (urlParams.get('page')) url += '&page=' + urlParams.get('page');
                    if (urlParams.get('pageSize')) url += '&pageSize=' + urlParams.get('pageSize');
                    if (urlParams.get('sortBy')) url += '&sortBy=' + urlParams.get('sortBy');
                    if (urlParams.get('sortOrder')) url += '&sortOrder=' + urlParams.get('sortOrder');
                    if (urlParams.get('employeeFilter')) url += '&employeeFilter=' + urlParams.get('employeeFilter');
                    if (urlParams.get('statusFilter')) url += '&statusFilter=' + urlParams.get('statusFilter');
                    window.location.href = url;
                }
            }

            function submitPayroll(id) {
                if (confirm('Are you sure you want to submit this payroll for approval?')) {
                    const urlParams = new URLSearchParams(window.location.search);
                    let url = '<%=request.getContextPath()%>/hrstaff/payroll/submit?payrollId=' + id;
                    // Preserve pagination parameters
                    if (urlParams.get('page')) url += '&page=' + urlParams.get('page');
                    if (urlParams.get('pageSize')) url += '&pageSize=' + urlParams.get('pageSize');
                    if (urlParams.get('sortBy')) url += '&sortBy=' + urlParams.get('sortBy');
                    if (urlParams.get('sortOrder')) url += '&sortOrder=' + urlParams.get('sortOrder');
                    if (urlParams.get('employeeFilter')) url += '&employeeFilter=' + urlParams.get('employeeFilter');
                    if (urlParams.get('statusFilter')) url += '&statusFilter=' + urlParams.get('statusFilter');
                    window.location.href = url;
                }
            }

            function viewPayrollDetails(id) {
                if (!id) {
                    console.error('Invalid payroll ID');
                    return;
                }
                
                const modal = document.getElementById('payrollDetailsModal');
                const content = document.getElementById('payrollDetailsContent');
                
                // Show loading state
                content.innerHTML = '<div style="text-align:center; padding:40px;"><div class="muted">Loading payroll details...</div></div>';
                modal.classList.add('active');
                
                fetch('<%=request.getContextPath()%>/api/payroll?payrollId=' + id)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network error: ' + response.status);
                        }
                        return response.json();
                    })
                    .then(data => {
                        console.log('Payroll details loaded:', data);
                        renderPayrollDetails(data);
                    })
                    .catch(err => {
                        console.error('Error loading payroll details:', err);
                        content.innerHTML = '<div style="background:#fee2e2; border:1px solid #fca5a5; border-radius:6px; padding:16px; color:#991b1b;">' +
                            '<strong>Error:</strong> ' + err.message + '</div>';
                    });
            }
            
            function renderPayrollDetails(data) {
                const content = document.getElementById('payrollDetailsContent');
                const audit = data.audit || {};
                
                let html = '<div style="display:flex; flex-direction:column; gap:20px;">';
                
                // Basic Info Section
                html += '<div class="card" style="padding:16px;">';
                html += '<h4 style="margin:0 0 16px 0; color:var(--primary);">📋 Basic Information</h4>';
                html += '<div class="form-row">';
                html += '<div class="form-group"><label>Employee</label><div style="padding:8px 0; font-weight:600;">' + (data.employeeName || 'N/A') + '</div></div>';
                html += '<div class="form-group"><label>Pay Period</label><div style="padding:8px 0; font-weight:600;">' + (data.payPeriod || 'N/A') + '</div></div>';
                html += '</div>';
                html += '<div class="form-row">';
                html += '<div class="form-group"><label>Status</label><div style="padding:8px 0;"><span class="status-badge status-' + (data.status || 'Draft') + '">' + (data.status || 'Draft') + '</span></div></div>';
                if (data.approvedDate) {
                    html += '<div class="form-group"><label>Approved Date</label><div style="padding:8px 0;">' + data.approvedDate + '</div></div>';
                }
                html += '</div>';
                html += '</div>';
                
                // Salary Breakdown Section
                html += '<div class="card" style="padding:16px;">';
                html += '<h4 style="margin:0 0 16px 0; color:var(--primary);">💰 Salary Breakdown</h4>';
                html += '<div class="summary-grid" style="grid-template-columns: repeat(3, 1fr); gap:12px; margin:0;">';
                html += '<div style="background:#f0f9ff; padding:12px; border-radius:6px; border-left:3px solid #3b82f6;">';
                html += '<div style="font-size:11px; color:var(--muted); margin-bottom:4px;">Base Salary</div>';
                html += '<div style="font-weight:600; font-size:16px;">' + formatCurrency(parseFloat(data.baseSalary) || 0) + '</div>';
                if (audit.actualBaseSalary) {
                    html += '<div style="font-size:10px; color:var(--muted); margin-top:2px;">(Actual: ' + formatCurrency(parseFloat(audit.actualBaseSalary)) + ')</div>';
                }
                html += '</div>';
                html += '<div style="background:#f0fdf4; padding:12px; border-radius:6px; border-left:3px solid var(--success);">';
                html += '<div style="font-size:11px; color:var(--muted); margin-bottom:4px;">OT Salary</div>';
                html += '<div style="font-weight:600; font-size:16px; color:var(--success);">' + formatCurrency(parseFloat(data.bonus) || 0) + '</div>';
                if (audit.overtimeHours) {
                    html += '<div style="font-size:10px; color:var(--muted); margin-top:2px;">(' + parseFloat(audit.overtimeHours).toFixed(1) + ' hours)</div>';
                }
                html += '</div>';
                html += '<div style="background:#fef3c7; padding:12px; border-radius:6px; border-left:3px solid var(--warning);">';
                html += '<div style="font-size:11px; color:var(--muted); margin-bottom:4px;">Allowance</div>';
                html += '<div style="font-weight:600; font-size:16px;">' + formatCurrency(parseFloat(data.allowance) || 0) + '</div>';
                html += '</div>';
                html += '</div>';
                html += '</div>';
                
                // Attendance Details (if available)
                if (audit.actualWorkingDays !== undefined || audit.paidLeaveDays !== undefined) {
                    html += '<div class="card" style="padding:16px;">';
                    html += '<h4 style="margin:0 0 16px 0; color:var(--primary);">📅 Attendance Details</h4>';
                    html += '<div class="summary-grid" style="grid-template-columns: repeat(4, 1fr); gap:12px; margin:0;">';
                    if (audit.actualWorkingDays !== undefined) {
                        html += '<div style="background:#f0f9ff; padding:12px; border-radius:6px;">';
                        html += '<div style="font-size:11px; color:var(--muted); margin-bottom:4px;">Actual Work Days</div>';
                        html += '<div style="font-weight:600; font-size:16px;">' + parseFloat(audit.actualWorkingDays).toFixed(1) + ' days</div>';
                        html += '</div>';
                    }
                    if (audit.paidLeaveDays !== undefined) {
                        html += '<div style="background:#f0fdf4; padding:12px; border-radius:6px;">';
                        html += '<div style="font-size:11px; color:var(--muted); margin-bottom:4px;">Paid Leave Days</div>';
                        html += '<div style="font-weight:600; font-size:16px; color:var(--success);">' + parseFloat(audit.paidLeaveDays).toFixed(1) + ' days</div>';
                        html += '</div>';
                    }
                    if (audit.unpaidLeaveDays !== undefined) {
                        html += '<div style="background:#fee2e2; padding:12px; border-radius:6px;">';
                        html += '<div style="font-size:11px; color:var(--muted); margin-bottom:4px;">Unpaid Leave Days</div>';
                        html += '<div style="font-weight:600; font-size:16px; color:var(--error);">' + parseFloat(audit.unpaidLeaveDays).toFixed(1) + ' days</div>';
                        html += '</div>';
                    }
                    if (audit.overtimeHours !== undefined) {
                        html += '<div style="background:#f0fdf4; padding:12px; border-radius:6px;">';
                        html += '<div style="font-size:11px; color:var(--muted); margin-bottom:4px;">Overtime Hours</div>';
                        html += '<div style="font-weight:600; font-size:16px; color:var(--success);">' + parseFloat(audit.overtimeHours).toFixed(1) + ' hours</div>';
                        html += '</div>';
                    }
                    html += '</div>';
                    html += '</div>';
                }
                
                // Insurance & Tax Details (if available)
                if (audit.bhxh !== undefined || audit.personalTax !== undefined) {
                    html += '<div class="card" style="padding:16px;">';
                    html += '<h4 style="margin:0 0 16px 0; color:var(--primary);">💳 Insurance & Tax</h4>';
                    html += '<div class="summary-grid" style="grid-template-columns: repeat(4, 1fr); gap:12px; margin:0;">';
                    if (audit.bhxh !== undefined) {
                        html += '<div style="background:#f0f9ff; padding:12px; border-radius:6px; border-left:3px solid #3b82f6;">';
                        html += '<div style="font-size:11px; color:var(--muted); margin-bottom:4px;">BHXH (8%)</div>';
                        html += '<div style="font-weight:600; font-size:16px; color:#3b82f6;">' + formatCurrency(parseFloat(audit.bhxh) || 0) + '</div>';
                        html += '</div>';
                    }
                    if (audit.bhyt !== undefined) {
                        html += '<div style="background:#f0fdf4; padding:12px; border-radius:6px; border-left:3px solid #10b981;">';
                        html += '<div style="font-size:11px; color:var(--muted); margin-bottom:4px;">BHYT (1.5%)</div>';
                        html += '<div style="font-weight:600; font-size:16px; color:#10b981;">' + formatCurrency(parseFloat(audit.bhyt) || 0) + '</div>';
                        html += '</div>';
                    }
                    if (audit.bhtn !== undefined) {
                        html += '<div style="background:#f5f3ff; padding:12px; border-radius:6px; border-left:3px solid #8b5cf6;">';
                        html += '<div style="font-size:11px; color:var(--muted); margin-bottom:4px;">BHTN (1%)</div>';
                        html += '<div style="font-weight:600; font-size:16px; color:#8b5cf6;">' + formatCurrency(parseFloat(audit.bhtn) || 0) + '</div>';
                        html += '</div>';
                    }
                    if (audit.personalTax !== undefined) {
                        html += '<div style="background:#fee2e2; padding:12px; border-radius:6px; border-left:3px solid var(--error);">';
                        html += '<div style="font-size:11px; color:var(--muted); margin-bottom:4px;">Tax (TNCN)</div>';
                        html += '<div style="font-weight:600; font-size:16px; color:var(--error);">' + formatCurrency(parseFloat(audit.personalTax) || 0) + '</div>';
                        html += '</div>';
                    }
                    html += '</div>';
                    if (audit.taxableIncome !== undefined) {
                        html += '<div style="margin-top:12px; padding-top:12px; border-top:1px solid var(--border); font-size:12px;">';
                        html += '<span style="color:var(--muted);">Taxable Income:</span> ';
                        html += '<strong>' + formatCurrency(parseFloat(audit.taxableIncome) || 0) + '</strong>';
                        html += '</div>';
                    }
                    html += '</div>';
                }
                
                // Deductions Section
                html += '<div class="card" style="padding:16px;">';
                html += '<h4 style="margin:0 0 16px 0; color:var(--primary);">➖ Deductions</h4>';
                html += '<div style="display:flex; flex-direction:column; gap:8px;">';
                html += '<div style="display:flex; justify-content:space-between; padding:8px; background:#f9fafb; border-radius:6px;">';
                html += '<span>Total Deduction:</span>';
                html += '<strong style="color:var(--error);">' + formatCurrency(parseFloat(data.deduction) || 0) + '</strong>';
                html += '</div>';
                if (audit.totalDeduction !== undefined) {
                    html += '<div style="font-size:12px; color:var(--muted); padding-left:8px;">';
                    html += 'Includes: Insurance (' + formatCurrency((parseFloat(audit.bhxh) || 0) + (parseFloat(audit.bhyt) || 0) + (parseFloat(audit.bhtn) || 0)) + ')';
                    if (audit.personalTax) {
                        html += ' + Tax (' + formatCurrency(parseFloat(audit.personalTax)) + ')';
                    }
                    if (audit.otherDeduction) {
                        html += ' + Other (' + formatCurrency(parseFloat(audit.otherDeduction)) + ')';
                    }
                    html += ')';
                    html += '</div>';
                }
                html += '</div>';
                html += '</div>';
                
                // Net Salary
                html += '<div class="card" style="padding:16px; border-left:4px solid var(--success);">';
                html += '<div style="display:flex; justify-content:space-between; align-items:center;">';
                html += '<h4 style="margin:0; color:var(--success);">💵 Net Salary</h4>';
                html += '<div style="font-size:28px; font-weight:700; color:var(--success);">' + formatCurrency(parseFloat(data.netSalary) || 0) + '</div>';
                html += '</div>';
                html += '<div style="margin-top:8px; font-size:12px; color:var(--muted);">';
                html += 'Base Salary + OT Salary + Allowance - Total Deduction';
                html += '</div>';
                html += '</div>';
                
                // Notes (if available)
                if (audit.notes) {
                    html += '<div class="card" style="padding:16px;">';
                    html += '<h4 style="margin:0 0 8px 0; color:var(--primary);">📝 Notes</h4>';
                    html += '<div style="color:var(--muted);">' + audit.notes + '</div>';
                    html += '</div>';
                }
                
                html += '</div>';
                
                content.innerHTML = html;
            }
            
            function closePayrollDetailsModal() {
                const modal = document.getElementById('payrollDetailsModal');
                if (modal) {
                    modal.classList.remove('active');
                }
            }
            
            // Generate payroll for all employees using stored procedure
            function generatePayrollForAll() {
                const month = prompt('Enter pay period (YYYY-MM):', new Date().toISOString().slice(0, 7));
                if (!month) return;
                
                if (confirm(`Generate payroll for ALL active employees for period ${month}?\n\nThis will use stored procedure sp_GeneratePayrollImproved to automatically calculate:\n- Actual working days and paid leave days\n- Actual base salary\n- Overtime salary\n- Insurance (BHXH, BHYT, BHTN)\n- Personal income tax (TNCN)\n- Net salary\n\nThis will create/update PayrollAudit and Payroll records for all active employees.`)) {
                    window.location.href = '<%=request.getContextPath()%>/hrstaff/payroll/generate-all?period=' + month;
                }
            }

            function filterAllowances() {
                const employeeId = document.getElementById('allowanceEmployeeFilter').value;
                const month = document.getElementById('allowanceMonthFilter').value;
                const params = new URLSearchParams();
                if (employeeId)
                    params.append('employeeFilter', employeeId);
                if (month)
                    params.append('allowanceMonth', month);
                params.append('tab', 'allowance');
                window.location.href = '<%=request.getContextPath()%>/hrstaff/payroll?' + params.toString();
            }

            function filterDeductions() {
                const employeeId = document.getElementById('deductionEmployeeFilter').value;
                const month = document.getElementById('deductionMonthFilter').value;
                const params = new URLSearchParams();
                if (employeeId)
                    params.append('employeeFilter', employeeId);
                if (month)
                    params.append('deductionMonth', month);
                params.append('tab', 'deduction');
                window.location.href = '<%=request.getContextPath()%>/hrstaff/payroll?' + params.toString();
            }

            function filterPayrolls() {
                const employeeId = document.getElementById('payrollEmployeeFilter').value;
                const status = document.getElementById('payrollStatusFilter').value;
                const urlParams = new URLSearchParams(window.location.search);
                
                // Clear existing filters
                urlParams.delete('employeeFilter');
                urlParams.delete('statusFilter');
                
                // Set new filters
                if (employeeId) {
                    urlParams.set('employeeFilter', employeeId);
                }
                if (status) {
                    urlParams.set('statusFilter', status);
                }
                
                // Reset to page 1 when filtering
                urlParams.set('page', '1');
                urlParams.set('tab', 'payroll');
                
                // Preserve pagination settings
                if (!urlParams.get('pageSize')) {
                    urlParams.set('pageSize', '10');
                }
                if (!urlParams.get('sortBy')) {
                    urlParams.set('sortBy', 'PayPeriod');
                }
                if (!urlParams.get('sortOrder')) {
                    urlParams.set('sortOrder', 'DESC');
                }
                
                window.location.href = '<%=request.getContextPath()%>/hrstaff/payroll?' + urlParams.toString();
            }
            
            function changePayrollPageSize(newSize) {
                const urlParams = new URLSearchParams(window.location.search);
                urlParams.set('pageSize', newSize);
                urlParams.set('page', '1'); // Reset to first page when changing page size
                urlParams.set('tab', 'payroll');
                // Preserve existing filters and sort (they are already in URL)
                window.location.href = '<%=request.getContextPath()%>/hrstaff/payroll?' + urlParams.toString();
            }
            
            function sortPayrollTable(column) {
                const urlParams = new URLSearchParams(window.location.search);
                const currentSortBy = urlParams.get('sortBy') || 'PayPeriod';
                const currentSortOrder = urlParams.get('sortOrder') || 'DESC';
                let newSortOrder = 'DESC';
                
                if (currentSortBy === column) {
                    newSortOrder = (currentSortOrder === 'ASC') ? 'DESC' : 'ASC';
                }
                
                urlParams.set('page', '1'); // Reset to first page when sorting
                urlParams.set('sortBy', column);
                urlParams.set('sortOrder', newSortOrder);
                urlParams.set('tab', 'payroll');
                // Preserve existing filters and pageSize (they are already in URL)
                
                window.location.href = '<%=request.getContextPath()%>/hrstaff/payroll?' + urlParams.toString();
            }
            
            function filterAttendance() {
                const employeeId = document.getElementById('attendanceEmployeeFilter').value;
                const month = document.getElementById('attendanceMonthFilter').value;
                const params = new URLSearchParams();
                if (employeeId)
                    params.append('employeeFilter', employeeId);
                if (month)
                    params.append('attendanceMonth', month);
                params.append('tab', 'attendance');
                window.location.href = '<%=request.getContextPath()%>/hrstaff/payroll?' + params.toString();
            }

            function loadAttendanceData() {
                console.log('loadAttendanceData called');
                const employeeId = document.getElementById('attendanceEmployeeFilter')?.value;
                const monthInput = document.getElementById('attendanceMonthFilter');
                
                if (!monthInput) {
                    console.error('attendanceMonthFilter element not found');
                    return;
                }
                
                let month = monthInput.value || '';

                // Validate and fix month format
                if (!month || month === '-' || month === '' || !month.match(/^\d{4}-\d{2}$/)) {
                    console.warn('Invalid month format:', month, '- fixing...');
                    // Set default month
                    const now = new Date();
                    const year = now.getFullYear();
                    const monthNum = String(now.getMonth() + 1).padStart(2, '0');
                    month = year + '-' + monthNum; // Use string concatenation instead of template literal
                    
                    // Validate before setting
                    if (month && month.match(/^\d{4}-\d{2}$/)) {
                        monthInput.value = month;
                        console.log('Fixed month to:', month);
                    } else {
                        console.error('Failed to generate valid month format. year:', year, 'monthNum:', monthNum, 'result:', month);
                        alert('Error: Cannot set valid month format. Please select a month manually.');
                        return;
                    }
                }

                if (!employeeId || !month) {
                    console.warn('Missing employeeId or month:', {employeeId, month});
                    const statsEl = document.getElementById('attendanceStats');
                    const emptyEl = document.getElementById('attendanceEmpty');
                    if (statsEl) statsEl.style.display = 'none';
                    if (emptyEl) emptyEl.style.display = 'block';
                    return;
                }
                
                console.log('Loading attendance data for employee:', employeeId, 'month:', month);
                const url = '<%=request.getContextPath()%>/hrstaff/payroll/calculate?employeeId=' + employeeId + '&month=' + month;
                console.log('Fetching from:', url);
                
                fetch(url)
                        .then(response => {
                            console.log('Response status:', response.status);
                            if (!response.ok)
                                throw new Error('Network error: ' + response.status);
                            return response.text();
                        })
                        .then(text => {
                            console.log('Response text:', text);
                            try {
                                const data = JSON.parse(text);
                                console.log('Parsed data:', data);
                                if (data && data.attendance) {
                                    const att = data.attendance;
                                    console.log('Attendance stats:', att);
                                    
                                    const statWorkDays = document.getElementById('statWorkDays');
                                    const statPaidLeaveInfo = document.getElementById('statPaidLeaveInfo');
                                    const statUnpaidLeave = document.getElementById('statUnpaidLeave');
                                    const statUnpaidLeaveAmount = document.getElementById('statUnpaidLeaveAmount');
                                    const statLateCount = document.getElementById('statLateCount');
                                    const statLatePenalty = document.getElementById('statLatePenalty');
                                    const statEarlyLeave = document.getElementById('statEarlyLeave');
                                    const statOvertimeHours = document.getElementById('statOvertimeHours');
                                    const statOvertimeAmount = document.getElementById('statOvertimeAmount');
                                    
                                    const actualWorkingDays = parseFloat(att.actualWorkingDays) || 0;
                                    const paidLeaveDays = parseFloat(att.paidLeaveDays) || 0;
                                    const unpaidLeaveDays = parseFloat(att.unpaidLeaveDays) || 0;
                                    
                                    if (statWorkDays) statWorkDays.textContent = actualWorkingDays.toFixed(1) + ' days';
                                    if (statPaidLeaveInfo) statPaidLeaveInfo.textContent = paidLeaveDays.toFixed(1) + ' paid leave days';
                                    if (statUnpaidLeave) statUnpaidLeave.textContent = unpaidLeaveDays.toFixed(1) + ' days';
                                    if (statUnpaidLeaveAmount) statUnpaidLeaveAmount.textContent = formatCurrency(parseFloat(att.calculatedUnpaidLeaveAmount) || 0);
                                    if (statLateCount) statLateCount.textContent = (att.lateCount || 0) + ' times';
                                    if (statLatePenalty) statLatePenalty.textContent = formatCurrency(parseFloat(att.calculatedLatePenalty) || 0);
                                    if (statEarlyLeave) statEarlyLeave.textContent = (att.earlyLeaveCount || 0) + ' times';
                                    if (statOvertimeHours) statOvertimeHours.textContent = parseFloat(att.totalOvertimeHours || 0).toFixed(1) + ' hours';
                                    if (statOvertimeAmount) statOvertimeAmount.textContent = formatCurrency(parseFloat(att.calculatedOvertimeAmount) || 0);

                                    const statsEl = document.getElementById('attendanceStats');
                                    const emptyEl = document.getElementById('attendanceEmpty');
                                    if (statsEl) {
                                        statsEl.style.display = 'block';
                                        console.log('Attendance stats displayed');
                                    }
                                    if (emptyEl) emptyEl.style.display = 'none';
                                } else {
                                    console.warn('No attendance data in response:', data);
                                    const statsEl = document.getElementById('attendanceStats');
                                    const emptyEl = document.getElementById('attendanceEmpty');
                                    if (statsEl) statsEl.style.display = 'none';
                                    if (emptyEl) emptyEl.style.display = 'block';
                                }
                            } catch (e) {
                                console.error('Error parsing attendance data:', e);
                                console.error('Response text:', text);
                                alert('Error loading attendance data. Check console for details.');
                            }
                        })
                        .catch(err => {
                            console.error('Fetch error:', err);
                            alert('Error loading attendance data: ' + err.message);
                        });
            }

            function applyAttendanceDeductions() {
                alert('Feature: Auto-create deductions from attendance');
            }

            function applyAttendanceAllowances() {
                alert('Feature: Auto-create allowances from attendance');
            }


            function loadEmployeePayrollData() {
                const employeeId = document.getElementById('payrollEmployee').value;
                const month = document.getElementById('payrollPeriod').value;

                if (!employeeId || !month) {
                    document.getElementById('payrollSummary').style.display = 'none';
                    document.getElementById('attendanceInfoSection').style.display = 'none';
                    document.getElementById('insuranceTaxSection').style.display = 'none';
                    return;
                }

                const url = '<%=request.getContextPath()%>/hrstaff/payroll/calculate?employeeId=' + employeeId + '&month=' + month;
                fetch(url)
                        .then(response => {
                            if (!response.ok)
                                throw new Error('Network error: ' + response.status);
                            return response.text();
                        })
                        .then(text => {
                            try {
                                const data = JSON.parse(text);
                                console.log('Payroll data received:', data); // Debug log
                                
                                if (data) {
                                    const baseSalary = parseFloat(data.baseSalary) || 0;
                                    const actualBaseSalary = parseFloat(data.actualBaseSalary) || 0;
                                    const otSalary = parseFloat(data.otSalary) || 0;
                                    const totalAllowance = parseFloat(data.totalAllowance) || 0;
                                    const totalDeduction = parseFloat(data.totalDeduction) || 0;
                                    const netSalary = parseFloat(data.netSalary) || 0;

                                    console.log('Parsed values:', {baseSalary, actualBaseSalary, otSalary, totalAllowance, totalDeduction, netSalary}); // Debug log

                                    document.getElementById('payrollBaseSalary').value = baseSalary;
                                    document.getElementById('payrollActualBaseSalary').value = actualBaseSalary;
                                    document.getElementById('payrollOTSalary').value = otSalary;
                                    document.getElementById('payrollAllowance').value = totalAllowance;
                                    document.getElementById('payrollDeduction').value = totalDeduction;
                                    document.getElementById('payrollNetSalary').value = netSalary;

                                    // Check if baseSalary is 0 and show warning
                                    if (baseSalary === 0) {
                                        console.warn('PayrollCalculateController: BaseSalary is 0. Cannot calculate payroll properly.');
                                        alert('⚠️ Cảnh báo: Nhân viên này chưa có Base Salary từ Contract.\n\n' +
                                            'Vui lòng kiểm tra:\n' +
                                            '1. Nhân viên có Contract chưa?\n' +
                                            '2. Contract có BaseSalary > 0 chưa?\n' +
                                            '3. Contract có hiệu lực trong tháng tính lương chưa?\n' +
                                            '(StartDate <= ngày cuối tháng VÀ EndDate >= ngày đầu tháng hoặc EndDate IS NULL)\n\n' +
                                            'Không thể tính lương chính xác nếu không có BaseSalary.');
                                    }
                                    
                                    // Update Insurance & Tax info if available
                                    if (data.insurance) {
                                        console.log('Insurance data:', data.insurance); // Debug log
                                        updateInsuranceTaxInfo(data.insurance, baseSalary);
                                    } else {
                                        console.warn('No insurance data in response'); // Debug log
                                    }
                                    
                                    // Update Attendance info if available (this will store data in window.currentAttendanceData)
                                    if (data.attendance) {
                                        updateAttendanceInfo(data.attendance, baseSalary);
                                    }
                                    
                                    // Always show summary, even if values are 0
                                    updatePayrollSummary({
                                        baseSalary: baseSalary,
                                        actualBaseSalary: actualBaseSalary,
                                        otSalary: otSalary,
                                        totalAllowance: totalAllowance,
                                        totalDeduction: totalDeduction,
                                        netSalary: netSalary,
                                        attendance: data.attendance // Pass attendance data
                                    });
                                    
                                    console.log('Summary updated'); // Debug log
                                }
                            } catch (e) {
                                console.error('Error parsing payroll data:', e);
                                console.error('Response text:', text);
                                alert('Error parsing payroll data. Check console for details.');
                            }
                        })
                        .catch(err => {
                            console.error('Fetch error:', err);
                            alert('Error loading payroll data. Please try again.');
                        });
            }
            
            // Update Insurance & Tax info in Payroll modal
            function updateInsuranceTaxInfo(insurance, baseSalaryParam) {
                if (!insurance) {
                    console.warn('updateInsuranceTaxInfo: insurance is null or undefined');
                    return;
                }
                
                console.log('updateInsuranceTaxInfo called with:', insurance); // Debug log
                
                const bhxh = parseFloat(insurance.bhxh) || 0;
                const bhyt = parseFloat(insurance.bhyt) || 0;
                const bhtn = parseFloat(insurance.bhtn) || 0;
                const insuranceTotal = parseFloat(insurance.insuranceTotal) || 0;
                const tax = parseFloat(insurance.tax) || 0;
                const taxableIncome = parseFloat(insurance.taxableIncome) || 0;
                const dependents = insurance.dependents || 0;
                
                console.log('Parsed values:', {bhxh, bhyt, bhtn, insuranceTotal, tax, taxableIncome, dependents}); // Debug log
                
                // Check if baseSalary is 0 (no contract or no base salary)
                const baseSalary = baseSalaryParam !== undefined ? baseSalaryParam : 
                    (parseFloat(document.getElementById('payrollBaseSalary').value) || 0);
                const hasBaseSalary = baseSalary > 0;
                
                // Update display
                const bhxhEl = document.getElementById('insBHXH');
                const bhytEl = document.getElementById('insBHYT');
                const bhtnEl = document.getElementById('insBHTN');
                const taxEl = document.getElementById('insTax');
                const taxableIncomeEl = document.getElementById('insTaxableIncome');
                const dependentsEl = document.getElementById('insDependents');
                const totalEl = document.getElementById('insTotal');
                const warningEl = document.getElementById('insuranceWarning');
                const baseSalaryWarningEl = document.getElementById('baseSalaryWarning');
                const displayBaseSalaryEl = document.getElementById('displayBaseSalary');
                
                if (bhxhEl) {
                    bhxhEl.textContent = formatCurrency(bhxh);
                    console.log('Updated insBHXH:', formatCurrency(bhxh));
                } else {
                    console.error('Element insBHXH not found');
                }
                
                if (bhytEl) bhytEl.textContent = formatCurrency(bhyt);
                if (bhtnEl) bhtnEl.textContent = formatCurrency(bhtn);
                if (taxEl) taxEl.textContent = formatCurrency(tax);
                if (taxableIncomeEl) taxableIncomeEl.textContent = formatCurrency(taxableIncome);
                if (dependentsEl) dependentsEl.textContent = dependents;
                if (totalEl) totalEl.textContent = formatCurrency(insuranceTotal);
                
                // Show/hide warning if no base salary
                if (warningEl) {
                    if (!hasBaseSalary) {
                        warningEl.style.display = 'block';
                    } else {
                        warningEl.style.display = 'none';
                    }
                }
                
                // Show base salary info
                if (baseSalaryWarningEl && displayBaseSalaryEl) {
                    displayBaseSalaryEl.textContent = formatCurrency(baseSalary);
                    if (hasBaseSalary) {
                        baseSalaryWarningEl.style.display = 'block';
                        baseSalaryWarningEl.style.background = '#d1fae5';
                        baseSalaryWarningEl.style.borderColor = '#10b981';
                        baseSalaryWarningEl.style.color = '#065f46';
                    } else {
                        baseSalaryWarningEl.style.display = 'block';
                        baseSalaryWarningEl.style.background = '#fee2e2';
                        baseSalaryWarningEl.style.borderColor = '#fca5a5';
                        baseSalaryWarningEl.style.color = '#991b1b';
                    }
                }
                
                // Show insurance section (always show, even if values are 0)
                const section = document.getElementById('insuranceTaxSection');
                if (section) {
                    section.style.display = 'block';
                    console.log('Insurance section displayed');
                } else {
                    console.error('Element insuranceTaxSection not found');
                }
            }
            
            // Update Attendance info in Payroll modal
            function updateAttendanceInfo(attendance, baseSalary) {
                if (!attendance) return;
                
                const actualWorkingDays = parseFloat(attendance.actualWorkingDays) || 0;
                const paidLeaveDays = parseFloat(attendance.paidLeaveDays) || 0;
                const unpaidLeaveDays = parseFloat(attendance.unpaidLeaveDays) || 0;
                const workDays = attendance.workDays || 0;
                const lateCount = attendance.lateCount || 0;
                const earlyLeaveCount = attendance.earlyLeaveCount || 0;
                const totalOvertimeHours = parseFloat(attendance.totalOvertimeHours) || 0;
                const unpaidLeaveAmount = parseFloat(attendance.calculatedUnpaidLeaveAmount) || 0;
                const latePenalty = parseFloat(attendance.calculatedLatePenalty) || 0;
                const overtimeAmount = parseFloat(attendance.calculatedOvertimeAmount) || 0;
                
                // Update display
                const workDaysEl = document.getElementById('attWorkDays');
                const unpaidLeaveEl = document.getElementById('attUnpaidLeave');
                const unpaidLeaveAmtEl = document.getElementById('attUnpaidLeaveAmt');
                const lateCountEl = document.getElementById('attLateCount');
                const latePenaltyEl = document.getElementById('attLatePenalty');
                const earlyLeaveEl = document.getElementById('attEarlyLeave');
                const overtimeHoursEl = document.getElementById('attOvertimeHours');
                const overtimeAmtEl = document.getElementById('attOvertimeAmt');
                const otHoursEl = document.getElementById('summaryOTHours');
                
                // Update work days display with actual working days and paid leave days
                if (workDaysEl) {
                    workDaysEl.textContent = `${actualWorkingDays.toFixed(1)} days (${paidLeaveDays.toFixed(1)} paid leave)`;
                }
                if (unpaidLeaveEl) unpaidLeaveEl.textContent = `${unpaidLeaveDays.toFixed(1)} days`;
                if (unpaidLeaveAmtEl) unpaidLeaveAmtEl.textContent = formatCurrency(unpaidLeaveAmount);
                if (lateCountEl) lateCountEl.textContent = `${lateCount} times`;
                if (latePenaltyEl) latePenaltyEl.textContent = formatCurrency(latePenalty);
                if (earlyLeaveEl) earlyLeaveEl.textContent = `${earlyLeaveCount} times`;
                if (overtimeHoursEl) overtimeHoursEl.textContent = `${totalOvertimeHours.toFixed(1)}h`;
                if (overtimeAmtEl) overtimeAmtEl.textContent = formatCurrency(overtimeAmount);
                if (otHoursEl) otHoursEl.textContent = `${totalOvertimeHours.toFixed(1)} hours`;
                
                // Update actual base salary description
                const actualBaseSalaryDescEl = document.getElementById('summaryActualBaseSalaryDesc');
                if (actualBaseSalaryDescEl) {
                    actualBaseSalaryDescEl.textContent = `${actualWorkingDays.toFixed(1)} work + ${paidLeaveDays.toFixed(1)} paid leave days`;
                }
                
                // Show attendance section if there's any data
                const section = document.getElementById('attendanceInfoSection');
                if (section) {
                    section.style.display = 'block'; // Always show to display calculation details
                }
                
                // Store attendance data for later use
                window.currentAttendanceData = {
                    actualWorkingDays: actualWorkingDays,
                    paidLeaveDays: paidLeaveDays,
                    unpaidLeaveDays: unpaidLeaveDays,
                    unpaidLeaveAmount: unpaidLeaveAmount,
                    latePenalty: latePenalty,
                    overtimeAmount: overtimeAmount,
                    totalOvertimeHours: totalOvertimeHours,
                    month: document.getElementById('payrollPeriod').value,
                    employeeId: document.getElementById('payrollEmployee').value
                };
            }
            
            function updatePayrollSummary(data) {
                if (!data) {
                    console.warn('updatePayrollSummary: data is null or undefined');
                    return;
                }
                
                const baseSalary = data.baseSalary || 0;
                const actualBaseSalary = data.actualBaseSalary || 0;
                const otSalary = data.otSalary || 0;
                const totalAllowance = data.totalAllowance || 0;
                const totalDeduction = data.totalDeduction || 0;
                const netSalary = data.netSalary || 0;
                const attendance = data.attendance || window.currentAttendanceData;
                
                console.log('updatePayrollSummary called with:', {baseSalary, actualBaseSalary, otSalary, totalAllowance, totalDeduction, netSalary}); // Debug log
                
                const baseSalaryEl = document.getElementById('summaryBaseSalary');
                const actualBaseSalaryEl = document.getElementById('summaryActualBaseSalary');
                const otSalaryEl = document.getElementById('summaryOTSalary');
                const allowanceEl = document.getElementById('summaryAllowance');
                const deductionEl = document.getElementById('summaryDeduction');
                const netSalaryEl = document.getElementById('summaryNetSalary');
                const summaryEl = document.getElementById('payrollSummary');
                const netSalaryCardEl = document.getElementById('summaryNetSalaryCard');
                const otHoursEl = document.getElementById('summaryOTHours');
                
                if (baseSalaryEl) {
                    baseSalaryEl.textContent = formatCurrency(baseSalary);
                }
                
                if (actualBaseSalaryEl) {
                    actualBaseSalaryEl.textContent = formatCurrency(actualBaseSalary);
                }
                
                if (otSalaryEl) {
                    otSalaryEl.textContent = formatCurrency(otSalary);
                }
                
                if (allowanceEl) {
                    allowanceEl.textContent = formatCurrency(totalAllowance);
                }
                
                // Update OT hours in summary
                if (otHoursEl) {
                    let otHours = 0;
                    if (attendance && attendance.totalOvertimeHours !== undefined) {
                        otHours = parseFloat(attendance.totalOvertimeHours) || 0;
                    } else if (window.currentAttendanceData && window.currentAttendanceData.totalOvertimeHours !== undefined) {
                        otHours = parseFloat(window.currentAttendanceData.totalOvertimeHours) || 0;
                    }
                    otHoursEl.textContent = otHours.toFixed(1) + ' hours';
                }
                
                if (deductionEl) {
                    deductionEl.textContent = formatCurrency(totalDeduction);
                }
                
                if (netSalaryEl) {
                    netSalaryEl.textContent = formatCurrency(netSalary);
                }
                
                if (summaryEl) {
                    summaryEl.style.display = 'grid';
                }
                
                if (netSalaryCardEl) {
                    netSalaryCardEl.style.display = 'block';
                }
            }

            function formatCurrency(amount) {
                return new Intl.NumberFormat('vi-VN', {
                    style: 'currency',
                    currency: 'VND'
                }).format(amount);
            }

            document.addEventListener('DOMContentLoaded', function () {
                const now = new Date();
                const year = now.getFullYear();
                const month = String(now.getMonth() + 1).padStart(2, '0');
                // Use string concatenation to avoid JSP template literal parsing issues
                const currentMonth = year + '-' + month;
                
                console.log('DOMContentLoaded: year:', year, 'month:', month, 'currentMonth:', currentMonth);

                        // Set default month for all month inputs (but preserve URL parameter values)
                        ['allowanceMonthFilter', 'deductionMonthFilter', 'attendanceMonthFilter', 'allowanceMonth', 'deductionMonth', 'payrollPeriod'].forEach(id => {
                            const elem = document.getElementById(id);
                            if (elem) {
                                const currentValue = elem.value || '';
                                // Only set default if empty or invalid, AND not attendanceMonthFilter (which should preserve URL value)
                                if (id === 'attendanceMonthFilter') {
                                    // For attendanceMonthFilter, only set default if truly empty (not from URL)
                                    // The value should already be set from JSP if it exists in URL
                                    if (!currentValue || currentValue === '-' || currentValue === '') {
                                        if (currentMonth && currentMonth.match(/^\d{4}-\d{2}$/)) {
                                            elem.value = currentMonth;
                                            console.log('Set default month for', id, 'to:', currentMonth);
                                        }
                                    } else {
                                        console.log('Preserving attendanceMonthFilter value from URL:', currentValue);
                                    }
                                } else {
                                    // For other inputs, set default if empty or invalid
                                    if (currentMonth && currentMonth.match(/^\d{4}-\d{2}$/)) {
                                        if (!currentValue || currentValue === '-' || currentValue === '' || !currentValue.match(/^\d{4}-\d{2}$/)) {
                                            elem.value = currentMonth;
                                            console.log('Set default month for', id, 'to:', currentMonth);
                                        }
                                    } else {
                                        console.error('Invalid currentMonth format:', currentMonth);
                                    }
                                }
                            }
                        });

                        // Tab is now handled by backend via URL parameter and JSP rendering
                        // Load attendance data if on attendance tab and filters are set
                        const urlParams = new URLSearchParams(window.location.search);
                        const currentTab = urlParams.get('tab');
                        if (currentTab === 'attendance') {
                            // Wait a bit for DOM to be fully ready
                            setTimeout(() => {
                                const employeeId = document.getElementById('attendanceEmployeeFilter')?.value;
                                const monthInput = document.getElementById('attendanceMonthFilter');
                                
                                // Ensure month input has valid value
                                if (monthInput) {
                                    let month = monthInput.value || '';
                                    
                                    // Get month from URL parameter if input is empty
                                    const urlMonth = urlParams.get('attendanceMonth');
                                    if ((!month || month === '-' || month === '') && urlMonth) {
                                        month = urlMonth;
                                        monthInput.value = month;
                                        console.log('Set month from URL parameter:', month);
                                    }
                                    
                                    // Fix invalid month format only if still invalid after checking URL
                                    if (!month || month === '-' || month === '' || !month.match(/^\d{4}-\d{2}$/)) {
                                        const now = new Date();
                                        const year = now.getFullYear();
                                        const monthNum = String(now.getMonth() + 1).padStart(2, '0');
                                        // Use string concatenation to avoid JSP template literal parsing issues
                                        month = year + '-' + monthNum;
                                        
                                        // Validate before setting
                                        if (month && month.match(/^\d{4}-\d{2}$/)) {
                                            monthInput.value = month;
                                            console.log('Fixed month format to:', month);
                                        } else {
                                            console.error('Failed to generate valid month format. year:', year, 'monthNum:', monthNum, 'result:', month);
                                            return;
                                        }
                                    }
                                    
                                    // Load data if employee is selected
                                    if (employeeId && month && month.match(/^\d{4}-\d{2}$/)) {
                                        console.log('Loading attendance data for employee:', employeeId, 'month:', month);
                                        loadAttendanceData();
                                    } else {
                                        console.log('Waiting for employee selection. employeeId:', employeeId, 'month:', month);
                                    }
                                } else {
                                    console.error('attendanceMonthFilter element not found');
                                }
                            }, 300);
                        }
                    });

                    document.addEventListener('click', function (event) {
                        ['allowanceModal', 'deductionModal', 'payrollModal', 'payrollDetailsModal'].forEach(modalId => {
                            const modal = document.getElementById(modalId);
                            if (modal && event.target === modal) {
                                modal.classList.remove('active');
                            }
                        });
                    });
        </script>
    </body>
</html>

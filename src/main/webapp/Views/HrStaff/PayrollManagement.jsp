<%-- 
    Document   : PayrollManagement
    Created on : Nov 5, 2025
    Author     : admin
    Description: Payroll Management for HR Staff - Manage Allowances, Deductions, and Payroll
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
            }
            
            .tab-btn:hover { 
                color:var(--primary); 
            }
            
            .tab-btn.active { 
                color:var(--primary); 
                border-bottom-color:var(--primary); 
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

                <!-- Tabs -->
                <div class="card">
                    <div class="tabs">
                        <button class="tab-btn active" onclick="showTab('allowance', this)">💰 Allowances</button>
                        <button class="tab-btn" onclick="showTab('deduction', this)">➖ Deductions</button>
                        <button class="tab-btn" onclick="showTab('payroll', this)">📊 Payroll</button>
                    </div>

                    <!-- Allowance Tab -->
                    <div id="allowance" class="tab-content active">
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
                                        <div class="action-btns">
                                            <button class="btn btn-small" onclick="editAllowance(<%= allowance.get("id") %>)">Edit</button>
                                            <button class="btn btn-small btn-danger" onclick="deleteAllowance(<%= allowance.get("id") %>)">Delete</button>
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

                    <!-- Deduction Tab -->
                    <div id="deduction" class="tab-content">
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

                    <!-- Payroll Tab -->
                    <div id="payroll" class="tab-content">
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                            <h3 style="margin:0;">Payroll Calculation</h3>
                            <button class="btn" onclick="openPayrollModal()">+ Create Payroll</button>
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
                                    <th>Employee</th>
                                    <th>Pay Period</th>
                                    <th>Base Salary</th>
                                    <th>Allowance</th>
                                    <th>Bonus</th>
                                    <th>Deduction</th>
                                    <th>Net Salary</th>
                                    <th>Status</th>
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
                                    <td><%= String.format("%,d VNĐ", ((java.math.BigDecimal) payroll.get("allowance")).intValue()) %></td>
                                    <td><%= String.format("%,d VNĐ", ((java.math.BigDecimal) payroll.get("bonus")).intValue()) %></td>
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
                                            <button class="btn btn-small" onclick="viewPayroll(<%= payroll.get("payrollId") %>)">View</button>
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
                    </div>
                </div>
            </main>
        </div>

        <!-- Allowance Modal -->
        <div id="allowanceModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Add/Edit Allowance</h3>
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
                    <h3>Add/Edit Deduction</h3>
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

                    <!-- Summary Cards -->
                    <div class="summary-grid" id="payrollSummary" style="display:none;">
                        <div class="summary-card">
                            <h4>Base Salary</h4>
                            <div class="value" id="summaryBaseSalary">0 VNĐ</div>
                        </div>
                        <div class="summary-card">
                            <h4>Total Allowance</h4>
                            <div class="value" id="summaryAllowance">0 VNĐ</div>
                        </div>
                        <div class="summary-card">
                            <h4>Total Deduction</h4>
                            <div class="value" id="summaryDeduction">0 VNĐ</div>
                        </div>
                        <div class="summary-card">
                            <h4>Net Salary</h4>
                            <div class="value" id="summaryNetSalary" style="color:var(--success);">0 VNĐ</div>
                        </div>
                    </div>

                    <input type="hidden" id="payrollBaseSalary" name="baseSalary"/>
                    <input type="hidden" id="payrollAllowance" name="allowance"/>
                    <input type="hidden" id="payrollDeduction" name="deduction"/>
                    <input type="hidden" id="payrollNetSalary" name="netSalary"/>

                    <div class="form-group">
                        <label>Bonus (VNĐ)</label>
                        <input type="number" id="payrollBonus" name="bonus" min="0" step="1000" value="0" onchange="calculateNetSalary()"/>
                        <div class="muted" style="margin-top:4px;">Optional bonus amount</div>
                    </div>

                    <div style="display:flex; gap:8px; justify-content:flex-end; margin-top:20px;">
                        <button type="button" class="btn btn-small" onclick="closePayrollModal()">Cancel</button>
                        <button type="submit" class="btn btn-small" name="action" value="save">Save Draft</button>
                        <button type="submit" class="btn btn-small secondary" name="action" value="submit">Submit for Approval</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // Set current month as default and handle tab from URL
            document.addEventListener('DOMContentLoaded', function() {
                const now = new Date();
                const year = now.getFullYear();
                const month = String(now.getMonth() + 1).padStart(2, '0');
                const currentMonth = `${year}-${month}`;
                
                // Set default values for month inputs if not already set (from request or default)
                const allowanceMonthFilter = document.getElementById('allowanceMonthFilter');
                const deductionMonthFilter = document.getElementById('deductionMonthFilter');
                const allowanceMonth = document.getElementById('allowanceMonth');
                const deductionMonth = document.getElementById('deductionMonth');
                const payrollPeriod = document.getElementById('payrollPeriod');
                
                // Only set default if value is empty (not set from request parameter)
                if (allowanceMonthFilter && !allowanceMonthFilter.value) {
                    allowanceMonthFilter.value = currentMonth;
                }
                if (deductionMonthFilter && !deductionMonthFilter.value) {
                    deductionMonthFilter.value = currentMonth;
                }
                if (allowanceMonth && !allowanceMonth.value) {
                    allowanceMonth.value = currentMonth;
                }
                if (deductionMonth && !deductionMonth.value) {
                    deductionMonth.value = currentMonth;
                }
                if (payrollPeriod && !payrollPeriod.value) {
                    payrollPeriod.value = currentMonth;
                }
                
                // Handle tab from URL parameter
                const urlParams = new URLSearchParams(window.location.search);
                const tab = urlParams.get('tab');
                if (tab) {
                    const tabButton = document.querySelector(`.tab-btn[onclick*="${tab}"]`);
                    if (tabButton) {
                        showTab(tab, tabButton);
                    }
                }
                
                // Show success/error messages from session
                <%
                    String success = (String) session.getAttribute("success");
                    String error = (String) session.getAttribute("error");
                    if (success != null) {
                        session.removeAttribute("success");
                %>
                alert('<%= success %>');
                <%
                    }
                    if (error != null) {
                        session.removeAttribute("error");
                %>
                alert('<%= error %>');
                <%
                    }
                %>
            });

            // Tab switching
            function showTab(tabName, element) {
                // Hide all tabs
                document.querySelectorAll('.tab-content').forEach(tab => {
                    tab.classList.remove('active');
                });
                document.querySelectorAll('.tab-btn').forEach(btn => {
                    btn.classList.remove('active');
                });

                // Show selected tab
                document.getElementById(tabName).classList.add('active');
                if (element) {
                    element.classList.add('active');
                }
            }

            // Allowance Modal
            function openAllowanceModal() {
                document.getElementById('allowanceModal').classList.add('active');
            }

            function closeAllowanceModal() {
                document.getElementById('allowanceModal').classList.remove('active');
                document.getElementById('allowanceForm').reset();
                document.getElementById('allowanceId').value = '';
            }

            // Deduction Modal
            function openDeductionModal() {
                document.getElementById('deductionModal').classList.add('active');
            }

            function closeDeductionModal() {
                document.getElementById('deductionModal').classList.remove('active');
                document.getElementById('deductionForm').reset();
                document.getElementById('deductionId').value = '';
            }

            // Payroll Modal
            function openPayrollModal() {
                document.getElementById('payrollModal').classList.add('active');
                loadEmployeePayrollData();
            }

            function closePayrollModal() {
                document.getElementById('payrollModal').classList.remove('active');
                document.getElementById('payrollForm').reset();
                document.getElementById('payrollId').value = '';
                document.getElementById('payrollSummary').style.display = 'none';
            }

            // Load employee payroll data (BaseSalary, Allowances, Deductions)
            function loadEmployeePayrollData() {
                const employeeId = document.getElementById('payrollEmployee').value;
                const month = document.getElementById('payrollPeriod').value;

                if (!employeeId || !month) {
                    document.getElementById('payrollSummary').style.display = 'none';
                    return;
                }

                // Call API to load data
                fetch(`<%=request.getContextPath()%>/hrstaff/payroll/calculate?employeeId=${employeeId}&month=${month}`)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.text();
                    })
                    .then(text => {
                        try {
                            // Parse JSON response
                            const data = JSON.parse(text);
                            if (data) {
                                const baseSalary = parseFloat(data.baseSalary) || 0;
                                const totalAllowance = parseFloat(data.totalAllowance) || 0;
                                const totalDeduction = parseFloat(data.totalDeduction) || 0;
                                
                                document.getElementById('payrollBaseSalary').value = baseSalary;
                                document.getElementById('payrollAllowance').value = totalAllowance;
                                document.getElementById('payrollDeduction').value = totalDeduction;
                                
                                updatePayrollSummary({
                                    baseSalary: baseSalary,
                                    totalAllowance: totalAllowance,
                                    totalDeduction: totalDeduction
                                });
                                calculateNetSalary();
                            }
                        } catch (e) {
                            console.error('Error parsing JSON:', e);
                            console.error('Response text:', text);
                        }
                    })
                    .catch(error => {
                        console.error('Error loading payroll data:', error);
                        alert('Error loading payroll data. Please try again.');
                    });
            }

            function updatePayrollSummary(data) {
                document.getElementById('summaryBaseSalary').textContent = formatCurrency(data.baseSalary || 0);
                document.getElementById('summaryAllowance').textContent = formatCurrency(data.totalAllowance || 0);
                document.getElementById('summaryDeduction').textContent = formatCurrency(data.totalDeduction || 0);
                document.getElementById('payrollSummary').style.display = 'grid';
            }

            function calculateNetSalary() {
                const baseSalary = parseFloat(document.getElementById('payrollBaseSalary').value) || 0;
                const allowance = parseFloat(document.getElementById('payrollAllowance').value) || 0;
                const bonus = parseFloat(document.getElementById('payrollBonus').value) || 0;
                const deduction = parseFloat(document.getElementById('payrollDeduction').value) || 0;

                const netSalary = baseSalary + allowance + bonus - deduction;
                
                document.getElementById('payrollNetSalary').value = netSalary;
                document.getElementById('summaryNetSalary').textContent = formatCurrency(netSalary);
            }

            function formatCurrency(amount) {
                return new Intl.NumberFormat('vi-VN', {
                    style: 'currency',
                    currency: 'VND'
                }).format(amount);
            }

            // Filter functions
            function filterAllowances() {
                const employeeId = document.getElementById('allowanceEmployeeFilter').value;
                const month = document.getElementById('allowanceMonthFilter').value;
                const params = new URLSearchParams();
                if (employeeId) params.append('employeeFilter', employeeId);
                if (month) params.append('allowanceMonth', month);
                params.append('tab', 'allowance');
                window.location.href = '<%=request.getContextPath()%>/hrstaff/payroll?' + params.toString();
            }

            function filterDeductions() {
                const employeeId = document.getElementById('deductionEmployeeFilter').value;
                const month = document.getElementById('deductionMonthFilter').value;
                const params = new URLSearchParams();
                if (employeeId) params.append('employeeFilter', employeeId);
                if (month) params.append('deductionMonth', month);
                params.append('tab', 'deduction');
                window.location.href = '<%=request.getContextPath()%>/hrstaff/payroll?' + params.toString();
            }

            function filterPayrolls() {
                const employeeId = document.getElementById('payrollEmployeeFilter').value;
                const status = document.getElementById('payrollStatusFilter').value;
                const params = new URLSearchParams();
                if (employeeId) params.append('employeeFilter', employeeId);
                if (status) params.append('statusFilter', status);
                params.append('tab', 'payroll');
                window.location.href = '<%=request.getContextPath()%>/hrstaff/payroll?' + params.toString();
            }

            // Edit functions
            function editAllowance(id) {
                // TODO: Load allowance data and open modal
                console.log('Edit allowance:', id);
            }

            function editDeduction(id) {
                // TODO: Load deduction data and open modal
                console.log('Edit deduction:', id);
            }

            function editPayroll(id) {
                // TODO: Load payroll data and open modal
                console.log('Edit payroll:', id);
            }

            // Delete functions
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
                    window.location.href = '<%=request.getContextPath()%>/hrstaff/payroll/delete?payrollId=' + id;
                }
            }

            function submitPayroll(id) {
                if (confirm('Are you sure you want to submit this payroll for approval?')) {
                    window.location.href = '<%=request.getContextPath()%>/hrstaff/payroll/submit?payrollId=' + id;
                }
            }

            function viewPayroll(id) {
                // TODO: Implement view payroll details
                alert('View payroll details for ID: ' + id);
            }

            // Close modal when clicking outside
            window.onclick = function(event) {
                const modals = ['allowanceModal', 'deductionModal', 'payrollModal'];
                modals.forEach(modalId => {
                    const modal = document.getElementById(modalId);
                    if (event.target === modal) {
                        modal.classList.remove('active');
                    }
                });
            }
        </script>
    </body>
</html>


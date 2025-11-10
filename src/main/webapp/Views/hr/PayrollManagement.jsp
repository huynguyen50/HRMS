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

            .btn-success {
                background: var(--success);
            }

            .btn-success:hover {
                background: #059669;
            }

            .btn-danger {
                background: var(--error);
            }

            .btn-danger:hover {
                background: #dc2626;
            }

            .container {
                width:100%;
                max-width:none;
                margin:0;
                padding: 20px;
            }

            .hero {
                background: linear-gradient(90deg, var(--primary), var(--secondary));
                color:#fff;
                border-radius:14px;
                padding:22px;
                margin-bottom:20px;
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
                margin-bottom:20px;
            }

            /* Status tabs */
            .status-tabs {
                display:flex;
                gap:8px;
                border-bottom:2px solid var(--border);
                margin-bottom:20px;
            }

            .status-tab-btn {
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

            .status-tab-btn:hover {
                color:var(--primary);
            }

            .status-tab-btn.active {
                color:var(--primary);
                border-bottom-color:var(--primary);
            }

            /* Filters */
            .filters {
                display:grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap:16px;
                margin-bottom:20px;
            }

            .form-group {
                margin-bottom:0;
            }

            .form-group label {
                display:block;
                margin-bottom:8px;
                font-weight:600;
                color:var(--text);
                font-size:14px;
            }

            .form-group select,
            .form-group input {
                width:100%;
                padding:10px 12px;
                border:1px solid var(--border);
                border-radius:8px;
                font-size:14px;
                transition:border-color 0.2s;
            }

            .form-group select:focus,
            .form-group input:focus {
                outline:none;
                border-color:var(--primary);
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

            /* Messages */
            .message {
                padding:12px 16px;
                border-radius:8px;
                margin-bottom:20px;
            }

            .message-success {
                background:#d4edda;
                border:1px solid #c3e6cb;
                color:#155724;
            }

            .message-error {
                background:#f8d7da;
                border:1px solid #f5c6cb;
                color:#721c24;
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

            .detail-row {
                display:flex;
                justify-content:space-between;
                padding:12px 0;
                border-bottom:1px solid var(--border);
            }

            .detail-row:last-child {
                border-bottom:none;
            }

            .detail-label {
                font-weight:600;
                color:var(--muted);
            }

            .detail-value {
                color:var(--text);
            }

            .currency {
                font-weight:600;
                color:var(--primary);
            }
        </style>
    </head>
    <body>
        <!-- Top Navigation Bar -->
        <div class="topbar">
            <div class="brand">
                <div class="logo">HR</div>
                <div>Payroll Approval - HR Manager</div>
            </div>
            <div class="top-actions">
                <a class="btn" href="<%=request.getContextPath()%>/HrHomeController">🏠 HR Home</a>
                <a class="btn" href="<%=request.getContextPath()%>/homepage">Homepage</a>
            </div>
        </div>

        <div class="container">
            <section class="hero">
                <h2>Payroll Approval Management</h2>
                <div class="muted">Review and approve/reject payrolls submitted by HR Staff</div>
            </section>

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

            <div class="card">
                <!-- Status Tabs -->
                <div class="status-tabs">
                    <button class="status-tab-btn ${statusFilter == 'Pending' ? 'active' : ''}" 
                            onclick="loadPayrollsByStatus('Pending')">Pending Approval</button>
                    <button class="status-tab-btn ${statusFilter == 'Approved' ? 'active' : ''}" 
                            onclick="loadPayrollsByStatus('Approved')">Approved</button>
                    <button class="status-tab-btn ${statusFilter == 'Rejected' ? 'active' : ''}" 
                            onclick="loadPayrollsByStatus('Rejected')">Rejected</button>
                    <button class="status-tab-btn ${statusFilter == null || statusFilter == '' ? 'active' : ''}" 
                            onclick="loadPayrollsByStatus('')">All</button>
                </div>

                <!-- Filters -->
                <form method="GET" action="<%=request.getContextPath()%>/hr/payroll-approval" style="margin-bottom:20px;">
                    <input type="hidden" name="status" value="${statusFilter}"/>
                    <div class="filters">
                        <div class="form-group">
                            <label>Employee</label>
                            <select name="employeeFilter" onchange="this.form.submit()">
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
                            <label>Pay Period</label>
                            <input type="month" name="payPeriod" value="${payPeriodFilter}" 
                                   onchange="this.form.submit()"/>
                        </div>
                        <div class="form-group">
                            <label>&nbsp;</label>
                            <button type="submit" class="btn">Apply Filters</button>
                        </div>
                    </div>
                </form>

                <!-- Payroll Table -->
                <table>
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
                    <tbody>
                        <c:choose>
                            <c:when test="${empty payrolls}">
                                <tr>
                                    <td colspan="9" class="empty">No payrolls found.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="payroll" items="${payrolls}">
                                    <tr>
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
                                        <td class="currency" style="font-weight:700; color:var(--primary);">
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
                                                <button class="btn btn-small view-payroll-btn" data-payroll-id="${payroll.payrollId}">
                                                    View
                                                </button>
                                                <c:if test="${payroll.status == 'Pending'}">
                                                    <button class="btn btn-small btn-success approve-payroll-btn" 
                                                            data-payroll-id="${payroll.payrollId}">
                                                        Approve
                                                    </button>
                                                    <button class="btn btn-small btn-danger reject-payroll-btn" 
                                                            data-payroll-id="${payroll.payrollId}">
                                                        Reject
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

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination-bar">
                        <div class="pagination-info">
                            Showing ${(currentPage - 1) * pageSize + 1} to ${currentPage * pageSize > totalCount ? totalCount : currentPage * pageSize} of ${totalCount} payrolls
                        </div>
                        <div class="pagination-controls">
                            <c:if test="${currentPage > 1}">
                                <a href="?status=${statusFilter}&employeeFilter=${employeeFilter}&payPeriod=${payPeriodFilter}&page=${currentPage - 1}">« Previous</a>
                            </c:if>
                            <c:if test="${currentPage <= 1}">
                                <span class="disabled">« Previous</span>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="active">${i}</span>
                                    </c:when>
                                    <c:when test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                        <a href="?status=${statusFilter}&employeeFilter=${employeeFilter}&payPeriod=${payPeriodFilter}&page=${i}">${i}</a>
                                    </c:when>
                                    <c:when test="${i == currentPage - 3 || i == currentPage + 3}">
                                        <span class="ellipsis">...</span>
                                    </c:when>
                                </c:choose>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <a href="?status=${statusFilter}&employeeFilter=${employeeFilter}&payPeriod=${payPeriodFilter}&page=${currentPage + 1}">Next »</a>
                            </c:if>
                            <c:if test="${currentPage >= totalPages}">
                                <span class="disabled">Next »</span>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Payroll Details Modal -->
        <div id="payrollDetailModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Payroll Details</h3>
                    <button class="close-btn" onclick="closePayrollModal()">&times;</button>
                </div>
                <div id="payrollDetailContent">
                    <!-- Content will be loaded via AJAX -->
                </div>
            </div>
        </div>

        <script>
            function loadPayrollsByStatus(status) {
                const url = new URL(window.location.href);
                if (status) {
                    url.searchParams.set('status', status);
                } else {
                    url.searchParams.delete('status');
                }
                url.searchParams.delete('page'); // Reset to page 1
                window.location.href = url.toString();
            }

            // Event listeners for action buttons
            document.addEventListener('DOMContentLoaded', function() {
                // View payroll details
                document.querySelectorAll('.view-payroll-btn').forEach(btn => {
                    btn.addEventListener('click', function() {
                        const payrollId = this.getAttribute('data-payroll-id');
                        viewPayrollDetails(payrollId);
                    });
                });
                
                // Approve payroll
                document.querySelectorAll('.approve-payroll-btn').forEach(btn => {
                    btn.addEventListener('click', function() {
                        const payrollId = this.getAttribute('data-payroll-id');
                        approvePayroll(payrollId);
                    });
                });
                
                // Reject payroll
                document.querySelectorAll('.reject-payroll-btn').forEach(btn => {
                    btn.addEventListener('click', function() {
                        const payrollId = this.getAttribute('data-payroll-id');
                        rejectPayroll(payrollId);
                    });
                });
            });

            function viewPayrollDetails(payrollId) {
                // For now, just show an alert with basic info
                // This can be enhanced later with a proper API endpoint
                alert('Payroll Details for ID: ' + payrollId + '\n\nAll payroll information is displayed in the table above.');
            }

            function closePayrollModal() {
                document.getElementById('payrollDetailModal').classList.remove('active');
            }

            function approvePayroll(payrollId) {
                if (confirm('Are you sure you want to approve this payroll?')) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '<%=request.getContextPath()%>/hr/payroll-approval';
                    
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
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            }

            function rejectPayroll(payrollId) {
                if (confirm('Are you sure you want to reject this payroll?')) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '<%=request.getContextPath()%>/hr/payroll-approval';
                    
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
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            }

            function formatCurrency(amount) {
                return new Intl.NumberFormat('en-US').format(amount);
            }

            // Close modal when clicking outside
            document.getElementById('payrollDetailModal').addEventListener('click', function(e) {
                if (e.target === this) {
                    closePayrollModal();
                }
            });
        </script>
    </body>
</html>

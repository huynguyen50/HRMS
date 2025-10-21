<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Approve Payroll - HRMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
        }
        body { 
            background-color: #f8fafc; 
            font-family: 'Inter', sans-serif; 
        }
        .main-container { 
            min-height: 100vh; 
            padding: 2rem 0; 
        }
        .approval-card { 
            box-shadow: 0 10px 25px rgba(0,0,0,0.1); 
            border: none; 
            border-radius: 12px; 
            margin-bottom: 2rem;
        }
        .approval-header { 
            background: linear-gradient(135deg, var(--primary-color), #3b82f6); 
            color: white; 
            padding: 1.5rem; 
            border-radius: 12px 12px 0 0; 
        }
        .payroll-table { margin-bottom: 0; }
        .payroll-table th { 
            background-color: #f8fafc; 
            border-bottom: 2px solid #e5e7eb; 
            font-weight: 600;
            position: sticky;
            top: 0;
            z-index: 10;
        }
        .payroll-table td { vertical-align: middle; }
        .salary-amount { 
            font-weight: 700; 
            font-size: 1rem; 
        }
        .status-badge { 
            font-size: 0.75rem; 
            padding: 0.375rem 0.75rem; 
            border-radius: 6px;
        }
        .status-pending { background-color: var(--warning-color); color: white; }
        .status-approved { background-color: var(--success-color); color: white; }
        .status-rejected { background-color: var(--danger-color); color: white; }
        .bulk-actions {
            background-color: #f8fafc;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        .stats-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); 
            gap: 1.5rem; 
            margin-bottom: 2rem; 
        }
        .stat-card { 
            background: white; 
            border-radius: 12px; 
            padding: 1.5rem; 
            text-align: center; 
            box-shadow: 0 4px 6px rgba(0,0,0,0.05); 
        }
        .stat-number { 
            font-size: 1.8rem; 
            font-weight: 700; 
            margin-bottom: 0.5rem; 
        }
        .stat-label { 
            color: #6b7280; 
            font-size: 0.875rem; 
            text-transform: uppercase; 
            letter-spacing: 0.05em; 
        }
        .approval-notes {
            background-color: #fffbeb;
            border: 1px solid #fed7aa;
            border-radius: 6px;
            padding: 0.75rem;
            margin-top: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid main-container">
        <!-- Header Navigation -->
        <div class="row mb-4">
            <div class="col-12">
                <nav class="d-flex justify-content-between align-items-center">
                    <div>
                        <a href="${pageContext.request.contextPath}/homepage" class="btn btn-outline-primary">
                            <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                        </a>
                    </div>
                    <div class="text-muted">
                        <i class="fas fa-stamp me-2"></i>
                        Payroll Approval - ${sessionScope.employee.firstName} ${sessionScope.employee.lastName}
                    </div>
                </nav>
            </div>
        </div>

        <!-- Statistics -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number text-warning">
                    <fmt:formatNumber value="${pendingCount}" type="number"/>
                </div>
                <div class="stat-label">Pending Approval</div>
            </div>
            <div class="stat-card">
                <div class="stat-number text-primary">
                    <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="₫"/>
                </div>
                <div class="stat-label">Total Amount</div>
            </div>
            <div class="stat-card">
                <div class="stat-number text-success">
                    <fmt:formatNumber value="${approvedToday}" type="number"/>
                </div>
                <div class="stat-label">Approved Today</div>
            </div>
            <div class="stat-card">
                <div class="stat-number text-info">
                    <fmt:formatNumber value="${avgSalary}" type="currency" currencySymbol="₫"/>
                </div>
                <div class="stat-label">Average Salary</div>
            </div>
        </div>

        <!-- Messages -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Filter and Bulk Actions -->
        <div class="card approval-card">
            <div class="card-body">
                <form method="get" class="row align-items-end mb-3">
                    <div class="col-md-3 mb-2">
                        <label for="monthFilter" class="form-label">Payroll Month</label>
                        <input type="month" class="form-control" id="monthFilter" name="month" 
                               value="${selectedMonth}" onchange="this.form.submit()">
                    </div>
                    <div class="col-md-3 mb-2">
                        <label for="departmentFilter" class="form-label">Department</label>
                        <select class="form-select" id="departmentFilter" name="departmentId" onchange="this.form.submit()">
                            <option value="">All Departments</option>
                            <c:forEach var="dept" items="${departments}">
                                <option value="${dept.departmentId}" ${param.departmentId == dept.departmentId ? 'selected' : ''}>
                                    ${dept.departmentName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3 mb-2">
                        <label for="statusFilter" class="form-label">Status</label>
                        <select class="form-select" id="statusFilter" name="status" onchange="this.form.submit()">
                            <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                            <option value="ALL" ${param.status == 'ALL' ? 'selected' : ''}>All Status</option>
                            <option value="APPROVED" ${param.status == 'APPROVED' ? 'selected' : ''}>Approved</option>
                            <option value="REJECTED" ${param.status == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                        </select>
                    </div>
                    <div class="col-md-3 mb-2">
                        <button type="button" class="btn btn-outline-secondary w-100" onclick="location.reload()">
                            <i class="fas fa-sync-alt me-2"></i>Refresh
                        </button>
                    </div>
                </form>

                <!-- Bulk Actions -->
                <c:if test="${not empty pendingPayrolls}">
                    <div class="bulk-actions">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="selectAll" 
                                           onchange="toggleAllCheckboxes(this)">
                                    <label class="form-check-label" for="selectAll">
                                        Select All (<span id="selectedCount">0</span> selected)
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-4 text-end">
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-success btn-sm" 
                                            onclick="bulkApprove()" id="bulkApproveBtn" disabled>
                                        <i class="fas fa-check-double me-1"></i>Approve Selected
                                    </button>
                                    <button type="button" class="btn btn-danger btn-sm" 
                                            onclick="bulkReject()" id="bulkRejectBtn" disabled>
                                        <i class="fas fa-times me-1"></i>Reject Selected
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Payroll Records Table -->
        <div class="card approval-card">
            <div class="approval-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-0">
                            <i class="fas fa-stamp me-2"></i>
                            Payroll Records for Approval
                        </h3>
                        <p class="mb-0 mt-2 opacity-75">
                            Review and approve payroll calculations for 
                            <fmt:formatDate value="${selectedMonthDate}" pattern="MMMM yyyy"/>
                        </p>
                    </div>
                    <div>
                        <button class="btn btn-light btn-sm" onclick="exportToExcel()">
                            <i class="fas fa-file-excel me-2"></i>Export
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${empty pendingPayrolls && empty approvedPayrolls}">
                        <div class="text-center py-5">
                            <i class="fas fa-receipt fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No Payroll Records</h5>
                            <p class="text-muted">No payroll records found for the selected criteria.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover payroll-table">
                                <thead>
                                    <tr>
                                        <th width="5%">
                                            <c:if test="${not empty pendingPayrolls}">
                                                <input type="checkbox" class="form-check-input" id="headerCheckbox" 
                                                       onchange="toggleAllCheckboxes(this)">
                                            </c:if>
                                        </th>
                                        <th width="20%">Employee</th>
                                        <th width="15%">Department</th>
                                        <th width="12%">Base Salary</th>
                                        <th width="12%">Net Salary</th>
                                        <th width="8%">Work Days</th>
                                        <th width="10%">Status</th>
                                        <th width="18%">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Pending Payrolls -->
                                    <c:forEach var="payroll" items="${pendingPayrolls}">
                                        <tr class="payroll-row" data-payroll-id="${payroll.payrollId}">
                                            <td>
                                                <input type="checkbox" class="form-check-input payroll-checkbox" 
                                                       value="${payroll.payrollId}" onchange="updateBulkActions()">
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-primary rounded-circle d-flex align-items-center justify-content-center me-2" 
                                                         style="width: 35px; height: 35px;">
                                                        <span class="text-white fw-bold small">
                                                            ${payroll.employee.firstName.charAt(0)}${payroll.employee.lastName.charAt(0)}
                                                        </span>
                                                    </div>
                                                    <div>
                                                        <strong>${payroll.employee.firstName} ${payroll.employee.lastName}</strong>
                                                        <br>
                                                        <small class="text-muted">ID: ${payroll.employee.employeeId}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${payroll.employee.department.departmentName}</td>
                                            <td class="salary-amount text-primary">
                                                <fmt:formatNumber value="${payroll.baseSalary}" type="currency" currencySymbol="₫"/>
                                            </td>
                                            <td class="salary-amount text-success">
                                                <fmt:formatNumber value="${payroll.netSalary}" type="currency" currencySymbol="₫"/>
                                            </td>
                                            <td>
                                                <span class="badge bg-info">${payroll.workDays}/22</span>
                                                <c:if test="${payroll.workDays < 22}">
                                                    <br><small class="text-warning">Partial Month</small>
                                                </c:if>
                                            </td>
                                            <td>
                                                <span class="badge status-badge status-pending">
                                                    <i class="fas fa-clock me-1"></i>Pending
                                                </span>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <button type="button" class="btn btn-outline-primary btn-sm" 
                                                            onclick="viewPayrollDetails(${payroll.payrollId})"
                                                            title="View Details">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-success btn-sm" 
                                                            onclick="approvePayroll(${payroll.payrollId})"
                                                            title="Approve">
                                                        <i class="fas fa-check"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-danger btn-sm" 
                                                            onclick="rejectPayroll(${payroll.payrollId})"
                                                            title="Reject">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <!-- Approved/Rejected Payrolls (if showing all) -->
                                    <c:if test="${param.status == 'ALL' || param.status == 'APPROVED' || param.status == 'REJECTED'}">
                                        <c:forEach var="payroll" items="${approvedPayrolls}">
                                            <tr class="payroll-row">
                                                <td></td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="bg-secondary rounded-circle d-flex align-items-center justify-content-center me-2" 
                                                             style="width: 35px; height: 35px;">
                                                            <span class="text-white fw-bold small">
                                                                ${payroll.employee.firstName.charAt(0)}${payroll.employee.lastName.charAt(0)}
                                                            </span>
                                                        </div>
                                                        <div>
                                                            <strong>${payroll.employee.firstName} ${payroll.employee.lastName}</strong>
                                                            <br>
                                                            <small class="text-muted">ID: ${payroll.employee.employeeId}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>${payroll.employee.department.departmentName}</td>
                                                <td class="salary-amount">
                                                    <fmt:formatNumber value="${payroll.baseSalary}" type="currency" currencySymbol="₫"/>
                                                </td>
                                                <td class="salary-amount">
                                                    <fmt:formatNumber value="${payroll.netSalary}" type="currency" currencySymbol="₫"/>
                                                </td>
                                                <td><span class="badge bg-info">${payroll.workDays}/22</span></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${payroll.status == 'APPROVED'}">
                                                            <span class="badge status-badge status-approved">
                                                                <i class="fas fa-check me-1"></i>Approved
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge status-badge status-rejected">
                                                                <i class="fas fa-times me-1"></i>Rejected
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <c:if test="${not empty payroll.approverComments}">
                                                        <div class="approval-notes">
                                                            <small>${payroll.approverComments}</small>
                                                        </div>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <button type="button" class="btn btn-outline-secondary btn-sm" 
                                                            onclick="viewPayrollDetails(${payroll.payrollId})">
                                                        <i class="fas fa-eye me-1"></i>View
                                                    </button>
                                                    <c:if test="${payroll.status == 'APPROVED'}">
                                                        <br>
                                                        <small class="text-muted">
                                                            <fmt:formatDate value="${payroll.approvedDate}" pattern="MMM dd"/>
                                                        </small>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:if>
                                </tbody>
                                <tfoot>
                                    <tr class="table-secondary">
                                        <th colspan="3" class="text-end">Totals:</th>
                                        <th class="salary-amount text-primary">
                                            <fmt:formatNumber value="${totalBaseSalary}" type="currency" currencySymbol="₫"/>
                                        </th>
                                        <th class="salary-amount text-success">
                                            <fmt:formatNumber value="${totalNetSalary}" type="currency" currencySymbol="₫"/>
                                        </th>
                                        <th colspan="3"></th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Payroll pagination" class="mt-4">
                <ul class="pagination justify-content-center">
                    <c:if test="${currentPage > 0}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage - 1}&month=${param.month}&departmentId=${param.departmentId}&status=${param.status}">Previous</a>
                        </li>
                    </c:if>
                    
                    <c:forEach begin="0" end="${totalPages - 1}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}&month=${param.month}&departmentId=${param.departmentId}&status=${param.status}">${i + 1}</a>
                        </li>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages - 1}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage + 1}&month=${param.month}&departmentId=${param.departmentId}&status=${param.status}">Next</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </div>

    <!-- Payroll Details Modal -->
    <div class="modal fade" id="payrollDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-receipt me-2"></i>Payroll Details
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="payrollDetailsContent">
                    <!-- Content will be loaded dynamically -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-success" id="modalApproveBtn" onclick="approveFromModal()">
                        <i class="fas fa-check me-2"></i>Approve
                    </button>
                    <button type="button" class="btn btn-danger" id="modalRejectBtn" onclick="rejectFromModal()">
                        <i class="fas fa-times me-2"></i>Reject
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Approval/Rejection Modal -->
    <div class="modal fade" id="actionModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="actionModalTitle">Confirm Action</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="actionForm" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="actionPayrollIds" name="payrollIds">
                        <input type="hidden" id="actionType" name="action">
                        
                        <div class="mb-3">
                            <label for="approverComments" class="form-label">Comments</label>
                            <textarea class="form-control" id="approverComments" name="approverComments" 
                                      rows="3" placeholder="Optional comments about the approval/rejection..."></textarea>
                        </div>
                        
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            <span id="actionWarning">This action will affect the selected payroll records.</span>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn" id="actionSubmitBtn">Confirm</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/validation.js"></script>
    <script>
        const payrollDetailsModal = new bootstrap.Modal(document.getElementById('payrollDetailsModal'));
        const actionModal = new bootstrap.Modal(document.getElementById('actionModal'));
        let currentPayrollId = null;

        // Validation rules for approval actions
        const approvalValidationRules = {
            approverComments: {
                required: false, // Set dynamically based on action
                minLength: 5,
                maxLength: 1000,
                customValidator: (value) => {
                    if (value && HRMSValidator.hasDangerousChars(value)) {
                        return { isValid: false, message: 'Comments contain invalid characters' };
                    }
                    return { isValid: true };
                }
            }
        };

        document.addEventListener('DOMContentLoaded', function() {
            // Setup real-time validation
            HRMSValidator.setupRealTimeValidation('approverComments', approvalValidationRules.approverComments);

            // Validate approval form
            const actionForm = document.getElementById('actionForm');
            if (actionForm) {
                actionForm.addEventListener('submit', function(e) {
                    let isValid = true;
                    const actionType = document.getElementById('actionType').value;
                    const comments = document.getElementById('approverComments').value;

                    // Clear previous errors
                    HRMSValidator.clearError('approverComments');

                    // Validate comments for rejection
                    if (actionType === 'reject') {
                        if (!comments || comments.trim().length < 5) {
                            HRMSValidator.showError('approverComments', 'Comments are required for rejection (minimum 5 characters)');
                            isValid = false;
                        } else if (HRMSValidator.hasDangerousChars(comments)) {
                            HRMSValidator.showError('approverComments', 'Comments contain invalid characters');
                            isValid = false;
                        }
                    }

                    // Validate payroll selection
                    const payrollIds = document.getElementById('actionPayrollIds').value;
                    if (!payrollIds || payrollIds.trim().length === 0) {
                        alert('No payroll records selected');
                        isValid = false;
                    }

                    if (!isValid) {
                        e.preventDefault();
                        const firstError = document.querySelector('.is-invalid');
                        if (firstError) {
                            firstError.focus();
                        }
                        return false;
                    }

                    // Show loading state
                    const submitBtn = document.getElementById('actionSubmitBtn');
                    submitBtn.disabled = true;
                    const originalText = submitBtn.innerHTML;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Processing...';
                    
                    // Re-enable button after delay in case of error
                    setTimeout(() => {
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = originalText;
                    }, 10000);
                });
            }

            // Initialize bulk action buttons
            updateBulkActions();
        });

        // Enhanced functions with validation
        function viewPayrollDetails(payrollId) {
            // Validate payroll ID
            if (!payrollId || isNaN(payrollId) || payrollId <= 0) {
                alert('Invalid payroll ID');
                return;
            }

            currentPayrollId = payrollId;
            
            // Show loading state
            document.getElementById('payrollDetailsContent').innerHTML = `
                <div class="text-center py-4">
                    <i class="fas fa-spinner fa-spin fa-2x text-primary mb-2"></i>
                    <p>Loading payroll details...</p>
                </div>
            `;
            payrollDetailsModal.show();

            fetch(`${pageContext.request.contextPath}/approve-payroll?action=view&payrollId=${payrollId}`)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.error) {
                        throw new Error(data.error);
                    }
                    
                    document.getElementById('payrollDetailsContent').innerHTML = `
                        <div class="row">
                            <div class="col-md-6">
                                <h6 class="text-primary">Employee Information</h6>
                                <table class="table table-sm table-bordered">
                                    <tr><td><strong>Name:</strong></td><td>${data.employee.firstName} ${data.employee.lastName}</td></tr>
                                    <tr><td><strong>ID:</strong></td><td>${data.employee.employeeId}</td></tr>
                                    <tr><td><strong>Department:</strong></td><td>${data.employee.department}</td></tr>
                                    <tr><td><strong>Position:</strong></td><td>${data.employee.position}</td></tr>
                                </table>
                                
                                <h6 class="text-primary mt-4">Attendance Summary</h6>
                                <table class="table table-sm table-bordered">
                                    <tr><td><strong>Working Days:</strong></td><td>${data.workingDays}</td></tr>
                                    <tr><td><strong>Attendance Days:</strong></td><td>${data.attendanceDays}</td></tr>
                                    <tr><td><strong>Overtime Hours:</strong></td><td>${data.overtimeHours}</td></tr>
                                    <tr><td><strong>Late Days:</strong></td><td>${data.lateDays || 0}</td></tr>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <h6 class="text-primary">Salary Breakdown</h6>
                                <table class="table table-sm table-bordered">
                                    <tr><td><strong>Base Salary:</strong></td><td class="text-end">${formatCurrency(data.baseSalary)}</td></tr>
                                    <tr><td><strong>Overtime Pay:</strong></td><td class="text-end">${formatCurrency(data.overtimePay)}</td></tr>
                                    <tr><td><strong>Bonus:</strong></td><td class="text-end">${formatCurrency(data.bonus)}</td></tr>
                                    <tr><td><strong>Allowances:</strong></td><td class="text-end">${formatCurrency(data.allowances)}</td></tr>
                                    <tr class="table-warning"><td><strong>Gross Salary:</strong></td><td class="text-end"><strong>${formatCurrency(data.grossSalary)}</strong></td></tr>
                                </table>
                                
                                <h6 class="text-primary mt-4">Deductions</h6>
                                <table class="table table-sm table-bordered">
                                    <tr><td><strong>Tax:</strong></td><td class="text-end">${formatCurrency(data.tax)}</td></tr>
                                    <tr><td><strong>Insurance:</strong></td><td class="text-end">${formatCurrency(data.insurance)}</td></tr>
                                    <tr><td><strong>Other Deductions:</strong></td><td class="text-end">${formatCurrency(data.otherDeductions)}</td></tr>
                                    <tr class="table-success"><td><strong>Net Salary:</strong></td><td class="text-end"><strong>${formatCurrency(data.netSalary)}</strong></td></tr>
                                </table>
                            </div>
                        </div>
                        
                        ${data.calculationNotes ? `
                            <div class="mt-3">
                                <h6 class="text-primary">Calculation Notes</h6>
                                <div class="alert alert-info">
                                    <small>${data.calculationNotes}</small>
                                </div>
                            </div>
                        ` : ''}
                    `;
                })
                .catch(error => {
                    console.error('Error loading payroll details:', error);
                    document.getElementById('payrollDetailsContent').innerHTML = `
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Error loading payroll details: ${error.message}
                        </div>
                    `;
                });
        }

        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            }).format(amount || 0);
        }

        function approvePayroll(payrollId) {
            if (!payrollId || isNaN(payrollId)) {
                alert('Invalid payroll ID');
                return;
            }
            
            showActionModal('approve', [payrollId], 'Approve Payroll', 
                `Are you sure you want to approve this payroll? This action cannot be undone.`);
        }

        function rejectPayroll(payrollId) {
            if (!payrollId || isNaN(payrollId)) {
                alert('Invalid payroll ID');
                return;
            }
            
            showActionModal('reject', [payrollId], 'Reject Payroll', 
                `Please provide a reason for rejecting this payroll. The employee will be notified.`);
        }

        function approveFromModal() {
            payrollDetailsModal.hide();
            approvePayroll(currentPayrollId);
        }

        function rejectFromModal() {
            payrollDetailsModal.hide();
            rejectPayroll(currentPayrollId);
        }

        function showActionModal(action, payrollIds, title, warning) {
            // Validate parameters
            if (!action || !Array.isArray(payrollIds) || payrollIds.length === 0) {
                alert('Invalid action parameters');
                return;
            }

            document.getElementById('actionModalTitle').textContent = title;
            document.getElementById('actionPayrollIds').value = payrollIds.join(',');
            document.getElementById('actionType').value = action;
            document.getElementById('actionWarning').textContent = warning;
            document.getElementById('actionForm').action = '${pageContext.request.contextPath}/approve-payroll';
            
            const submitBtn = document.getElementById('actionSubmitBtn');
            const commentsField = document.getElementById('approverComments');
            
            // Clear previous comments and errors
            commentsField.value = '';
            HRMSValidator.clearError('approverComments');
            
            if (action === 'approve') {
                submitBtn.className = 'btn btn-success';
                submitBtn.innerHTML = '<i class="fas fa-check me-2"></i>Approve';
                commentsField.required = false;
                commentsField.placeholder = 'Optional approval comments...';
            } else {
                submitBtn.className = 'btn btn-danger';  
                submitBtn.innerHTML = '<i class="fas fa-times me-2"></i>Reject';
                commentsField.required = true;
                commentsField.placeholder = 'Please provide reason for rejection (required)...';
            }
            
            actionModal.show();
            
            // Focus on comments field
            setTimeout(() => {
                commentsField.focus();
            }, 500);
        }

        function toggleAllCheckboxes(source) {
            const checkboxes = document.querySelectorAll('.payroll-checkbox');
            let count = 0;
            
            checkboxes.forEach(checkbox => {
                if (!checkbox.disabled) {
                    checkbox.checked = source.checked;
                    count++;
                }
            });
            
            if (count === 0 && source.checked) {
                alert('No payroll records available for selection');
                source.checked = false;
            }
            
            updateBulkActions();
        }

        function updateBulkActions() {
            const checkedBoxes = document.querySelectorAll('.payroll-checkbox:checked');
            const selectedCount = checkedBoxes.length;
            
            document.getElementById('selectedCount').textContent = selectedCount;
            
            const bulkApproveBtn = document.getElementById('bulkApproveBtn');
            const bulkRejectBtn = document.getElementById('bulkRejectBtn');
            
            if (bulkApproveBtn) bulkApproveBtn.disabled = selectedCount === 0;
            if (bulkRejectBtn) bulkRejectBtn.disabled = selectedCount === 0;
            
            // Update bulk action text
            const bulkActionText = document.getElementById('bulkActionText');
            if (bulkActionText) {
                if (selectedCount === 0) {
                    bulkActionText.textContent = 'No records selected';
                } else {
                    bulkActionText.textContent = `${selectedCount} record${selectedCount > 1 ? 's' : ''} selected`;
                }
            }
        }

        function bulkApprove() {
            const selectedIds = Array.from(document.querySelectorAll('.payroll-checkbox:checked'))
                .map(cb => parseInt(cb.value))
                .filter(id => !isNaN(id) && id > 0);
            
            if (selectedIds.length === 0) {
                alert('Please select at least one payroll record to approve');
                return;
            }
            
            showActionModal('approve', selectedIds, 'Bulk Approve Payrolls', 
                `Are you sure you want to approve ${selectedIds.length} payroll record${selectedIds.length > 1 ? 's' : ''}? This action cannot be undone.`);
        }

        function bulkReject() {
            const selectedIds = Array.from(document.querySelectorAll('.payroll-checkbox:checked'))
                .map(cb => parseInt(cb.value))
                .filter(id => !isNaN(id) && id > 0);
            
            if (selectedIds.length === 0) {
                alert('Please select at least one payroll record to reject');
                return;
            }
            
            showActionModal('reject', selectedIds, 'Bulk Reject Payrolls', 
                `Please provide a reason for rejecting ${selectedIds.length} payroll record${selectedIds.length > 1 ? 's' : ''}. All affected employees will be notified.`);
        }

        // Enhanced filter function with validation
        function filterPayrolls() {
            const monthFilter = document.getElementById('monthFilter').value;
            const departmentFilter = document.getElementById('departmentFilter').value;
            const statusFilter = document.getElementById('statusFilter').value;
            const searchTerm = document.getElementById('employeeSearch').value.toLowerCase();

            const rows = document.querySelectorAll('.payroll-row');
            let visibleCount = 0;

            rows.forEach(row => {
                const month = row.dataset.month || '';
                const department = row.dataset.department || '';
                const status = row.dataset.status || '';
                const employeeName = row.dataset.employeeName || '';

                const matchesMonth = !monthFilter || month === monthFilter;
                const matchesDepartment = !departmentFilter || department === departmentFilter;
                const matchesStatus = !statusFilter || status === statusFilter;
                const matchesSearch = !searchTerm || employeeName.toLowerCase().includes(searchTerm);

                if (matchesMonth && matchesDepartment && matchesStatus && matchesSearch) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                    
                    // Uncheck hidden rows
                    const checkbox = row.querySelector('.payroll-checkbox');
                    if (checkbox) checkbox.checked = false;
                }
            });

            // Update result count
            const resultCount = document.getElementById('resultCount');
            if (resultCount) {
                resultCount.textContent = `${visibleCount} record${visibleCount !== 1 ? 's' : ''} found`;
            }

            // Update bulk actions
            updateBulkActions();
        }

        // Add event listeners for filters
        document.addEventListener('DOMContentLoaded', function() {
            ['monthFilter', 'departmentFilter', 'statusFilter', 'employeeSearch'].forEach(id => {
                const element = document.getElementById(id);
                if (element) {
                    if (element.tagName === 'INPUT') {
                        element.addEventListener('input', filterPayrolls);
                    } else {
                        element.addEventListener('change', filterPayrolls);
                    }
                }
            });

            // Add change event to all payroll checkboxes
            document.querySelectorAll('.payroll-checkbox').forEach(checkbox => {
                checkbox.addEventListener('change', updateBulkActions);
            });
        });

        // Export functions (if needed)
        function exportToExcel() {
            const selectedIds = Array.from(document.querySelectorAll('.payroll-checkbox:checked'))
                .map(cb => cb.value);
            
            if (selectedIds.length === 0) {
                alert('Please select at least one payroll record to export');
                return;
            }
            
            const url = `${pageContext.request.contextPath}/approve-payroll?action=export&format=excel&payrollIds=${selectedIds.join(',')}`;
            window.open(url, '_blank');
        }

        function printReport() {
            const selectedIds = Array.from(document.querySelectorAll('.payroll-checkbox:checked'))
                .map(cb => cb.value);
            
            if (selectedIds.length === 0) {
                alert('Please select at least one payroll record to print');
                return;
            }
            
            const url = `${pageContext.request.contextPath}/approve-payroll?action=report&payrollIds=${selectedIds.join(',')}`;
            window.open(url, '_blank');
        }
    </script>
</body>
</html>

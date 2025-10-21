<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payroll Management - HRMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
            --info-color: #06b6d4;
        }
        body { 
            background-color: #f8fafc; 
            font-family: 'Inter', sans-serif; 
        }
        .main-container { 
            min-height: 100vh; 
            padding: 2rem 0; 
        }
        .payroll-card { 
            box-shadow: 0 10px 25px rgba(0,0,0,0.1); 
            border: none; 
            border-radius: 12px; 
            margin-bottom: 2rem;
        }
        .payroll-header { 
            background: linear-gradient(135deg, var(--primary-color), #3b82f6); 
            color: white; 
            padding: 1.5rem; 
            border-radius: 12px 12px 0 0; 
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
            border-left: 4px solid var(--primary-color);
        }
        .stat-number { 
            font-size: 2rem; 
            font-weight: 700; 
            margin-bottom: 0.5rem; 
        }
        .stat-label { 
            color: #6b7280; 
            font-size: 0.875rem; 
            text-transform: uppercase; 
            letter-spacing: 0.05em; 
        }
        .payroll-table { margin-bottom: 0; }
        .payroll-table th { 
            background-color: #f8fafc; 
            border-bottom: 2px solid #e5e7eb; 
            font-weight: 600;
        }
        .payroll-table td { vertical-align: middle; }
        .salary-amount { 
            font-weight: 700; 
            font-size: 1.1rem; 
        }
        .status-badge { 
            font-size: 0.75rem; 
            padding: 0.375rem 0.75rem; 
            border-radius: 6px;
        }
        .status-calculated { background-color: var(--info-color); color: white; }
        .status-pending { background-color: var(--warning-color); color: white; }
        .status-approved { background-color: var(--success-color); color: white; }
        .status-rejected { background-color: var(--danger-color); color: white; }
        .action-buttons .btn { margin: 0 2px; }
        .calculation-form { 
            background: #f8fafc; 
            border-radius: 8px; 
            padding: 1.5rem; 
            margin-bottom: 2rem; 
        }
        .form-control:focus { 
            border-color: var(--primary-color); 
            box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.25); 
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
                        <i class="fas fa-calculator me-2"></i>
                        HR Payroll Management
                    </div>
                </nav>
            </div>
        </div>

        <!-- Statistics -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number text-primary">
                    <fmt:formatNumber value="${totalEmployees}" type="number"/>
                </div>
                <div class="stat-label">Total Employees</div>
            </div>
            <div class="stat-card">
                <div class="stat-number text-warning">
                    <fmt:formatNumber value="${pendingPayrolls}" type="number"/>
                </div>
                <div class="stat-label">Pending Payrolls</div>
            </div>
            <div class="stat-card">
                <div class="stat-number text-success">
                    <fmt:formatNumber value="${totalPayrollAmount}" type="currency" currencySymbol="₫"/>
                </div>
                <div class="stat-label">Total This Month</div>
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

        <!-- Payroll Calculation Form -->
        <div class="card payroll-card">
            <div class="payroll-header">
                <h4 class="mb-0">
                    <i class="fas fa-calculator me-2"></i>
                    Payroll Calculation
                </h4>
                <p class="mb-0 mt-2 opacity-75">
                    Calculate payroll for employees based on attendance and performance
                </p>
            </div>
            
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/payroll" method="post" class="calculation-form" id="payrollForm">
                    <input type="hidden" name="action" value="calculate">
                    
                    <div class="row">
                        <div class="col-md-3 mb-3">
                            <label for="payrollMonth" class="form-label">
                                <i class="fas fa-calendar me-1"></i>Payroll Month *
                            </label>
                            <input type="month" class="form-control" id="payrollMonth" name="payrollMonth" 
                                   value="${currentMonth}" required>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label for="departmentFilter" class="form-label">
                                <i class="fas fa-building me-1"></i>Department
                            </label>
                            <select class="form-select" id="departmentFilter" name="departmentId">
                                <option value="">All Departments</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.departmentId}">${dept.departmentName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label for="employeeFilter" class="form-label">
                                <i class="fas fa-user me-1"></i>Specific Employee
                            </label>
                            <select class="form-select" id="employeeFilter" name="employeeId">
                                <option value="">All Employees</option>
                                <c:forEach var="emp" items="${employees}">
                                    <option value="${emp.employeeId}">
                                        ${emp.firstName} ${emp.lastName} (${emp.department.departmentName})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3 mb-3 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-play me-2"></i>Calculate Payroll
                            </button>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-12">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="recalculate" name="recalculate">
                                <label class="form-check-label" for="recalculate">
                                    Recalculate existing payroll records (overwrites current data)
                                </label>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Payroll Records Table -->
        <div class="card payroll-card">
            <div class="payroll-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="mb-0">
                            <i class="fas fa-table me-2"></i>
                            Payroll Records
                        </h4>
                        <p class="mb-0 mt-2 opacity-75">
                            Current month payroll status and details
                        </p>
                    </div>
                    <div>
                        <button class="btn btn-light btn-sm me-2" onclick="exportToExcel()">
                            <i class="fas fa-file-excel me-2"></i>Export Excel
                        </button>
                        <button class="btn btn-light btn-sm" onclick="location.reload()">
                            <i class="fas fa-sync-alt me-2"></i>Refresh
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${empty payrollRecords}">
                        <div class="text-center py-5">
                            <i class="fas fa-receipt fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No Payroll Records</h5>
                            <p class="text-muted">Calculate payroll to generate records for this month.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover payroll-table">
                                <thead>
                                    <tr>
                                        <th>Employee</th>
                                        <th>Department</th>
                                        <th>Base Salary</th>
                                        <th>Allowances</th>
                                        <th>Deductions</th>
                                        <th>Net Salary</th>
                                        <th>Work Days</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="payroll" items="${payrollRecords}">
                                        <tr>
                                            <td>
                                                <div>
                                                    <strong>${payroll.employee.firstName} ${payroll.employee.lastName}</strong>
                                                    <br>
                                                    <small class="text-muted">ID: ${payroll.employee.employeeId}</small>
                                                </div>
                                            </td>
                                            <td>${payroll.employee.department.departmentName}</td>
                                            <td class="salary-amount text-primary">
                                                <fmt:formatNumber value="${payroll.baseSalary}" type="currency" currencySymbol="₫"/>
                                            </td>
                                            <td class="text-success">
                                                <fmt:formatNumber value="${payroll.allowances}" type="currency" currencySymbol="₫"/>
                                            </td>
                                            <td class="text-danger">
                                                <fmt:formatNumber value="${payroll.deductions}" type="currency" currencySymbol="₫"/>
                                            </td>
                                            <td class="salary-amount text-dark">
                                                <fmt:formatNumber value="${payroll.netSalary}" type="currency" currencySymbol="₫"/>
                                            </td>
                                            <td>
                                                <span class="badge bg-info">${payroll.workDays}/22</span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${payroll.status == 'CALCULATED'}">
                                                        <span class="badge status-badge status-calculated">
                                                            <i class="fas fa-calculator me-1"></i>Calculated
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${payroll.status == 'PENDING'}">
                                                        <span class="badge status-badge status-pending">
                                                            <i class="fas fa-clock me-1"></i>Pending
                                                        </span>
                                                    </c:when>
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
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button type="button" class="btn btn-outline-primary btn-sm" 
                                                            onclick="viewPayrollDetails(${payroll.payrollId})"
                                                            title="View Details">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <c:if test="${payroll.status == 'CALCULATED'}">
                                                        <button type="button" class="btn btn-outline-warning btn-sm" 
                                                                onclick="editPayroll(${payroll.payrollId})"
                                                                title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                        <form method="post" style="display: inline-block;">
                                                            <input type="hidden" name="action" value="submit">
                                                            <input type="hidden" name="payrollId" value="${payroll.payrollId}">
                                                            <button type="submit" class="btn btn-success btn-sm" 
                                                                    title="Submit for Approval">
                                                                <i class="fas fa-paper-plane"></i>
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${payroll.status != 'APPROVED'}">
                                                        <button type="button" class="btn btn-outline-danger btn-sm" 
                                                                onclick="deletePayroll(${payroll.payrollId})"
                                                                title="Delete">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr class="table-secondary">
                                        <th colspan="5" class="text-end">Totals:</th>
                                        <th class="salary-amount text-primary">
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

        <!-- Batch Actions -->
        <c:if test="${not empty payrollRecords}">
            <div class="card payroll-card">
                <div class="card-body">
                    <h5 class="mb-3">
                        <i class="fas fa-tasks me-2"></i>Batch Actions
                    </h5>
                    <div class="row">
                        <div class="col-md-4 mb-2">
                            <form method="post" style="display: inline-block;">
                                <input type="hidden" name="action" value="submitAll">
                                <input type="hidden" name="month" value="${currentMonth}">
                                <button type="submit" class="btn btn-success w-100" 
                                        onclick="return confirm('Submit all calculated payrolls for approval?')">
                                    <i class="fas fa-paper-plane me-2"></i>Submit All for Approval
                                </button>
                            </form>
                        </div>
                        <div class="col-md-4 mb-2">
                            <button type="button" class="btn btn-info w-100" onclick="generateReports()">
                                <i class="fas fa-chart-bar me-2"></i>Generate Reports
                            </button>
                        </div>
                        <div class="col-md-4 mb-2">
                            <button type="button" class="btn btn-warning w-100" onclick="sendNotifications()">
                                <i class="fas fa-bell me-2"></i>Send Notifications
                            </button>
                        </div>
                    </div>
                </div>
            </div>
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
                    <button type="button" class="btn btn-primary" onclick="printPayslip()">
                        <i class="fas fa-print me-2"></i>Print Payslip
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/validation.js"></script>
    <script>
        const payrollDetailsModal = new bootstrap.Modal(document.getElementById('payrollDetailsModal'));

        // Payroll form validation rules
        const payrollValidationRules = {
            payrollMonth: {
                required: true,
                requiredMessage: 'Please select a payroll month'
            },
            employeeSelect: {
                required: false // Optional for bulk calculation
            },
            overtimeHours: {
                required: false,
                customValidator: (value) => {
                    if (value && (isNaN(value) || parseFloat(value) < 0 || parseFloat(value) > 200)) {
                        return { isValid: false, message: 'Overtime hours must be between 0 and 200' };
                    }
                    return { isValid: true };
                }
            },
            bonus: {
                required: false,
                customValidator: (value) => {
                    if (value && (isNaN(value) || parseFloat(value) < 0 || parseFloat(value) > 100000000)) {
                        return { isValid: false, message: 'Bonus must be between 0 and 100,000,000 VND' };
                    }
                    return { isValid: true };
                }
            },
            deductions: {
                required: false,
                customValidator: (value) => {
                    if (value && (isNaN(value) || parseFloat(value) < 0 || parseFloat(value) > 50000000)) {
                        return { isValid: false, message: 'Deductions must be between 0 and 50,000,000 VND' };
                    }
                    return { isValid: true };
                }
            }
        };

        document.addEventListener('DOMContentLoaded', function() {
            // Setup real-time validation
            Object.keys(payrollValidationRules).forEach(fieldId => {
                const field = document.getElementById(fieldId);
                if (field) {
                    HRMSValidator.setupRealTimeValidation(fieldId, payrollValidationRules[fieldId]);
                }
            });

            // Validate payroll calculation form
            const payrollForm = document.getElementById('payrollForm');
            if (payrollForm) {
                payrollForm.addEventListener('submit', function(e) {
                    let isValid = true;

                    // Validate form fields
                    if (!HRMSValidator.validateForm('payrollForm', payrollValidationRules)) {
                        isValid = false;
                    }

                    // Additional business logic validation
                    const payrollMonth = document.getElementById('payrollMonth').value;
                    const selectedMonth = new Date(payrollMonth + '-01');
                    const currentDate = new Date();
                    
                    // Check if calculating for future months
                    if (selectedMonth > currentDate) {
                        if (!confirm('You are calculating payroll for a future month. Continue?')) {
                            isValid = false;
                        }
                    }

                    // Check if calculating for more than 12 months ago
                    const twelveMonthsAgo = new Date();
                    twelveMonthsAgo.setFullYear(currentDate.getFullYear() - 1);
                    
                    if (selectedMonth < twelveMonthsAgo) {
                        HRMSValidator.showError('payrollMonth', 'Cannot calculate payroll for more than 12 months ago');
                        isValid = false;
                    }

                    if (!isValid) {
                        e.preventDefault();
                        
                        // Scroll to first error
                        const firstError = document.querySelector('.is-invalid');
                        if (firstError) {
                            firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        }
                        
                        return false;
                    }

                    // Show loading state
                    const submitBtn = this.querySelector('button[type="submit"]');
                    if (submitBtn) {
                        submitBtn.disabled = true;
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Calculating...';
                    }
                });
            }

            // Validate individual payroll edit forms
            document.addEventListener('submit', function(e) {
                const form = e.target;
                if (form.classList.contains('payroll-edit-form')) {
                    let isValid = true;

                    // Get form fields
                    const overtimeHours = form.querySelector('[name="overtimeHours"]');
                    const bonus = form.querySelector('[name="bonus"]');
                    const deductions = form.querySelector('[name="deductions"]');

                    // Validate overtime hours
                    if (overtimeHours && overtimeHours.value) {
                        const hours = parseFloat(overtimeHours.value);
                        if (isNaN(hours) || hours < 0 || hours > 200) {
                            HRMSValidator.showError('overtimeHours', 'Overtime hours must be between 0 and 200');
                            isValid = false;
                        }
                    }

                    // Validate bonus
                    if (bonus && bonus.value) {
                        const bonusAmount = parseFloat(bonus.value);
                        if (isNaN(bonusAmount) || bonusAmount < 0) {
                            HRMSValidator.showError('bonus', 'Bonus must be a positive number');
                            isValid = false;
                        }
                    }

                    // Validate deductions
                    if (deductions && deductions.value) {
                        const deductionAmount = parseFloat(deductions.value);
                        if (isNaN(deductionAmount) || deductionAmount < 0) {
                            HRMSValidator.showError('deductions', 'Deductions must be a positive number');
                            isValid = false;
                        }
                    }

                    if (!isValid) {
                        e.preventDefault();
                        return false;
                    }
                }
            });
        });

        function viewPayrollDetails(payrollId) {
            // Validate payrollId parameter
            if (!payrollId || isNaN(payrollId)) {
                alert('Invalid payroll ID');
                return;
            }

            // Load payroll details via AJAX
            fetch(`${pageContext.request.contextPath}/payroll?action=view&payrollId=${payrollId}`)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Failed to load payroll details');
                    }
                    return response.json();
                })
                .then(data => {
                    // ...existing code...
                })
                .catch(error => {
                    console.error('Error loading payroll details:', error);
                    alert('Failed to load payroll details. Please try again.');
                });
        }

        // Enhanced calculatePayroll with validation
        function calculatePayroll() {
            const form = document.getElementById('payrollForm');
            if (!form) return;

            // Validate form before submission
            const isValid = HRMSValidator.validateForm('payrollForm', payrollValidationRules);
            if (!isValid) {
                const firstError = document.querySelector('.is-invalid');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
                return;
            }

            // Show confirmation dialog
            const month = document.getElementById('payrollMonth').value;
            const employeeSelect = document.getElementById('employeeSelect');
            const selectedEmployees = employeeSelect ? Array.from(employeeSelect.selectedOptions).length : 0;
            
            const message = selectedEmployees > 0 
                ? `Calculate payroll for ${selectedEmployees} selected employees for ${month}?`
                : `Calculate payroll for all employees for ${month}?`;
                
            if (confirm(message)) {
                form.submit();
            }
        }

        // Enhanced bulk operations with validation
        function bulkApprovePayroll() {
            const checkedBoxes = document.querySelectorAll('input[name="selectedPayrolls"]:checked');
            if (checkedBoxes.length === 0) {
                alert('Please select at least one payroll record to approve');
                return;
            }

            if (confirm(`Approve ${checkedBoxes.length} selected payroll records?`)) {
                const payrollIds = Array.from(checkedBoxes).map(cb => cb.value);
                
                fetch('${pageContext.request.contextPath}/payroll', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `action=bulkApprove&payrollIds=${payrollIds.join(',')}`
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert('Error approving payrolls: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while approving payrolls');
                });
            }
        }

        function sendNotifications() {
            const checkedBoxes = document.querySelectorAll('input[name="selectedPayrolls"]:checked');
            if (checkedBoxes.length === 0) {
                alert('Please select at least one payroll record to send notifications');
                return;
            }

            if (confirm(`Send payroll notifications to ${checkedBoxes.length} employees?`)) {
                const payrollIds = Array.from(checkedBoxes).map(cb => cb.value);
                
                fetch('${pageContext.request.contextPath}/payroll', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `action=sendNotifications&payrollIds=${payrollIds.join(',')}`
                })
                .then(response => response.json())
                .then(data => {
                    alert(data.success ? 'Notifications sent successfully' : 'Error sending notifications: ' + data.message);
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while sending notifications');
                });
            }
        }

        function printPayslip() {
            window.print();
        }

        // Auto-calculate when filters change
        document.getElementById('departmentFilter').addEventListener('change', function() {
            const departmentId = this.value;
            const employeeSelect = document.getElementById('employeeFilter');
            
            // Update employee options based on department
            if (departmentId) {
                fetch(`${pageContext.request.contextPath}/payroll?action=getEmployees&departmentId=${departmentId}`)
                    .then(response => response.json())
                    .then(employees => {
                        employeeSelect.innerHTML = '<option value="">All Employees</option>';
                        employees.forEach(emp => {
                            employeeSelect.innerHTML += `<option value="${emp.employeeId}">${emp.firstName} ${emp.lastName}</option>`;
                        });
                    });
            }
        });
    </script>
</body>
</html>

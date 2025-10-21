<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Payslip - HRMS</title>
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
        .payslip-card { 
            box-shadow: 0 15px 35px rgba(0,0,0,0.1); 
            border: none; 
            border-radius: 12px; 
            margin-bottom: 2rem;
            background: white;
        }
        .payslip-header { 
            background: linear-gradient(135deg, var(--primary-color), #3b82f6); 
            color: white; 
            padding: 2rem; 
            border-radius: 12px 12px 0 0; 
            position: relative;
        }
        .payslip-header::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 0;
            height: 0;
            border-left: 20px solid transparent;
            border-right: 20px solid transparent;
            border-top: 10px solid var(--primary-color);
        }
        .company-logo {
            width: 60px;
            height: 60px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-color);
            font-weight: 700;
            font-size: 1.5rem;
        }
        .payslip-table {
            margin-bottom: 0;
        }
        .payslip-table th {
            background-color: #f8fafc;
            font-weight: 600;
            border: none;
            padding: 1rem;
        }
        .payslip-table td {
            border: none;
            padding: 1rem;
            vertical-align: middle;
        }
        .salary-row {
            background-color: #eff6ff;
            font-weight: 600;
            font-size: 1.1rem;
        }
        .total-row {
            background-color: var(--primary-color);
            color: white;
            font-weight: 700;
            font-size: 1.2rem;
        }
        .status-badge {
            font-size: 0.875rem;
            padding: 0.5rem 1rem;
            border-radius: 20px;
        }
        .status-pending { background-color: var(--warning-color); color: white; }
        .status-approved { background-color: var(--success-color); color: white; }
        .status-acknowledged { background-color: #6b7280; color: white; }
        .print-section {
            background: #f8fafc;
            border-radius: 8px;
            padding: 1.5rem;
            margin-top: 2rem;
        }
        .breakdown-section {
            background: #fafbfc;
            border-left: 4px solid var(--primary-color);
            padding: 1.5rem;
            margin: 1.5rem 0;
        }
        @media print {
            body { background: white; }
            .no-print { display: none !important; }
            .payslip-card { box-shadow: none; border: 1px solid #ddd; }
            .main-container { padding: 0; }
        }
        .watermark {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-45deg);
            font-size: 4rem;
            color: rgba(0,0,0,0.05);
            font-weight: bold;
            z-index: 1;
            pointer-events: none;
        }
    </style>
</head>
<body>
    <div class="container-fluid main-container">
        <!-- Header Navigation -->
        <div class="row mb-4 no-print">
            <div class="col-12">
                <nav class="d-flex justify-content-between align-items-center">
                    <div>
                        <a href="${pageContext.request.contextPath}/homepage" class="btn btn-outline-primary">
                            <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                        </a>
                    </div>
                    <div class="text-muted">
                        <i class="fas fa-receipt me-2"></i>
                        Payslip for ${payslip.employee.firstName} ${payslip.employee.lastName}
                    </div>
                </nav>
            </div>
        </div>

        <!-- Messages -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show no-print" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show no-print" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Payslip Month Selector -->
        <div class="row mb-4 no-print">
            <div class="col-lg-6 mx-auto">
                <div class="card">
                    <div class="card-body">
                        <form method="get" class="row align-items-end">
                            <div class="col-md-8 mb-2">
                                <label for="month" class="form-label">Select Month</label>
                                <input type="month" class="form-control" id="month" name="month" 
                                       value="${selectedMonth}" onchange="this.form.submit()">
                            </div>
                            <div class="col-md-4 mb-2">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-search me-2"></i>View Payslip
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Payslip -->
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <c:choose>
                    <c:when test="${empty payslip}">
                        <div class="card payslip-card">
                            <div class="card-body text-center py-5">
                                <i class="fas fa-receipt fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No Payslip Available</h5>
                                <p class="text-muted">
                                    Payslip for the selected month is not available or has not been generated yet.
                                </p>
                                <a href="${pageContext.request.contextPath}/homepage" class="btn btn-primary">
                                    <i class="fas fa-home me-2"></i>Back to Dashboard
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="card payslip-card position-relative">
                            <!-- Watermark for draft/pending status -->
                            <c:if test="${payslip.status != 'APPROVED'}">
                                <div class="watermark">${payslip.status}</div>
                            </c:if>

                            <!-- Payslip Header -->
                            <div class="payslip-header">
                                <div class="row align-items-center">
                                    <div class="col-md-2">
                                        <div class="company-logo">
                                            <i class="fas fa-building"></i>
                                        </div>
                                    </div>
                                    <div class="col-md-7">
                                        <h3 class="mb-1">HRMS Company</h3>
                                        <p class="mb-0 opacity-75">Human Resource Management System</p>
                                        <small class="opacity-75">123 Business Street, Ho Chi Minh City, Vietnam</small>
                                    </div>
                                    <div class="col-md-3 text-end">
                                        <h4 class="mb-1">PAYSLIP</h4>
                                        <p class="mb-0">
                                            <fmt:formatDate value="${payslip.payrollMonth}" pattern="MMMM yyyy"/>
                                        </p>
                                        <small class="opacity-75">Generated: <fmt:formatDate value="${payslip.generatedDate}" pattern="dd/MM/yyyy"/></small>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Employee Information -->
                            <div class="card-body">
                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <h6 class="text-primary mb-3">
                                            <i class="fas fa-user me-2"></i>Employee Information
                                        </h6>
                                        <table class="table table-sm table-borderless">
                                            <tr>
                                                <td class="text-muted">Name:</td>
                                                <td><strong>${payslip.employee.firstName} ${payslip.employee.lastName}</strong></td>
                                            </tr>
                                            <tr>
                                                <td class="text-muted">Employee ID:</td>
                                                <td>${payslip.employee.employeeId}</td>
                                            </tr>
                                            <tr>
                                                <td class="text-muted">Department:</td>
                                                <td>${payslip.employee.department.departmentName}</td>
                                            </tr>
                                            <tr>
                                                <td class="text-muted">Position:</td>
                                                <td>${payslip.employee.position}</td>
                                            </tr>
                                            <tr>
                                                <td class="text-muted">Join Date:</td>
                                                <td><fmt:formatDate value="${payslip.employee.startDate}" pattern="dd/MM/yyyy"/></td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div class="col-md-6">
                                        <h6 class="text-primary mb-3">
                                            <i class="fas fa-calendar me-2"></i>Payroll Period
                                        </h6>
                                        <table class="table table-sm table-borderless">
                                            <tr>
                                                <td class="text-muted">Pay Period:</td>
                                                <td><fmt:formatDate value="${payslip.payrollMonth}" pattern="MMMM yyyy"/></td>
                                            </tr>
                                            <tr>
                                                <td class="text-muted">Work Days:</td>
                                                <td>${payslip.workDays} / 22</td>
                                            </tr>
                                            <tr>
                                                <td class="text-muted">Overtime Hours:</td>
                                                <td>${payslip.overtimeHours} hours</td>
                                            </tr>
                                            <tr>
                                                <td class="text-muted">Status:</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${payslip.status == 'PENDING'}">
                                                            <span class="badge status-badge status-pending">
                                                                <i class="fas fa-clock me-1"></i>Pending Approval
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${payslip.status == 'APPROVED'}">
                                                            <span class="badge status-badge status-approved">
                                                                <i class="fas fa-check me-1"></i>Approved
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${payslip.status == 'ACKNOWLEDGED'}">
                                                            <span class="badge status-badge status-acknowledged">
                                                                <i class="fas fa-eye me-1"></i>Acknowledged
                                                            </span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="text-muted">Payslip ID:</td>
                                                <td>#${payslip.payrollId}</td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>

                                <!-- Salary Breakdown -->
                                <div class="breakdown-section">
                                    <h6 class="text-primary mb-3">
                                        <i class="fas fa-calculator me-2"></i>Salary Breakdown
                                    </h6>
                                    
                                    <table class="table payslip-table">
                                        <thead>
                                            <tr>
                                                <th width="60%">Description</th>
                                                <th width="40%" class="text-end">Amount (VND)</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!-- Earnings -->
                                            <tr class="table-light">
                                                <td colspan="2"><strong>EARNINGS</strong></td>
                                            </tr>
                                            <tr>
                                                <td>Base Salary</td>
                                                <td class="text-end">
                                                    <fmt:formatNumber value="${payslip.baseSalary}" type="number" groupingUsed="true"/>
                                                </td>
                                            </tr>
                                            <c:if test="${payslip.allowances > 0}">
                                                <tr>
                                                    <td>Allowances</td>
                                                    <td class="text-end text-success">
                                                        +<fmt:formatNumber value="${payslip.allowances}" type="number" groupingUsed="true"/>
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <c:if test="${payslip.overtimePay > 0}">
                                                <tr>
                                                    <td>Overtime Pay (${payslip.overtimeHours} hours)</td>
                                                    <td class="text-end text-success">
                                                        +<fmt:formatNumber value="${payslip.overtimePay}" type="number" groupingUsed="true"/>
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <c:if test="${payslip.bonus > 0}">
                                                <tr>
                                                    <td>Performance Bonus</td>
                                                    <td class="text-end text-success">
                                                        +<fmt:formatNumber value="${payslip.bonus}" type="number" groupingUsed="true"/>
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <tr class="salary-row">
                                                <td><strong>GROSS SALARY</strong></td>
                                                <td class="text-end">
                                                    <strong><fmt:formatNumber value="${payslip.grossSalary}" type="number" groupingUsed="true"/></strong>
                                                </td>
                                            </tr>

                                            <!-- Deductions -->
                                            <tr class="table-light">
                                                <td colspan="2"><strong>DEDUCTIONS</strong></td>
                                            </tr>
                                            <c:if test="${payslip.taxDeduction > 0}">
                                                <tr>
                                                    <td>Personal Income Tax</td>
                                                    <td class="text-end text-danger">
                                                        -<fmt:formatNumber value="${payslip.taxDeduction}" type="number" groupingUsed="true"/>
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <c:if test="${payslip.insuranceDeduction > 0}">
                                                <tr>
                                                    <td>Social Insurance (8%)</td>
                                                    <td class="text-end text-danger">
                                                        -<fmt:formatNumber value="${payslip.insuranceDeduction}" type="number" groupingUsed="true"/>
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <c:if test="${payslip.otherDeductions > 0}">
                                                <tr>
                                                    <td>Other Deductions</td>
                                                    <td class="text-end text-danger">
                                                        -<fmt:formatNumber value="${payslip.otherDeductions}" type="number" groupingUsed="true"/>
                                                    </td>
                                                </tr>
                                            </c:if>

                                            <!-- Net Salary -->
                                            <tr class="total-row">
                                                <td><strong>NET SALARY</strong></td>
                                                <td class="text-end">
                                                    <strong><fmt:formatNumber value="${payslip.netSalary}" type="number" groupingUsed="true"/> VND</strong>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Additional Information -->
                                <c:if test="${not empty payslip.notes}">
                                    <div class="breakdown-section">
                                        <h6 class="text-primary mb-3">
                                            <i class="fas fa-sticky-note me-2"></i>Additional Notes
                                        </h6>
                                        <p class="text-muted">${payslip.notes}</p>
                                    </div>
                                </c:if>

                                <!-- Approval Information -->
                                <c:if test="${payslip.status == 'APPROVED'}">
                                    <div class="row mt-4">
                                        <div class="col-md-6">
                                            <div class="text-center">
                                                <hr style="border-top: 1px solid #000; width: 200px; margin: 2rem auto 0.5rem;">
                                                <small class="text-muted">Employee Signature</small>
                                                <p class="mb-0 mt-2">${payslip.employee.firstName} ${payslip.employee.lastName}</p>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="text-center">
                                                <hr style="border-top: 1px solid #000; width: 200px; margin: 2rem auto 0.5rem;">
                                                <small class="text-muted">HR Manager</small>
                                                <p class="mb-0 mt-2">
                                                    <c:if test="${not empty payslip.approvedBy}">
                                                        ${payslip.approvedBy.firstName} ${payslip.approvedBy.lastName}
                                                    </c:if>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Footer -->
                                <div class="text-center mt-4 pt-3 border-top">
                                    <small class="text-muted">
                                        This is a computer-generated payslip and does not require a signature.<br>
                                        For inquiries, please contact HR at hr@hrms.com or ext. 2100
                                    </small>
                                </div>
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="print-section no-print">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h6 class="mb-2">
                                        <i class="fas fa-download me-2"></i>Download & Actions
                                    </h6>
                                    <p class="text-muted mb-0">
                                        Keep a copy of your payslip for your records. 
                                        <c:if test="${payslip.status == 'APPROVED' && !payslip.acknowledged}">
                                            Please acknowledge receipt after reviewing.
                                        </c:if>
                                    </p>
                                </div>
                                <div class="col-md-4 text-end">
                                    <div class="btn-group" role="group">
                                        <button type="button" class="btn btn-outline-primary" onclick="window.print()">
                                            <i class="fas fa-print me-2"></i>Print
                                        </button>
                                        <a href="${pageContext.request.contextPath}/view-payslip?action=download&month=${selectedMonth}" 
                                           class="btn btn-outline-success">
                                            <i class="fas fa-download me-2"></i>PDF
                                        </a>
                                        <c:if test="${payslip.status == 'APPROVED' && !payslip.acknowledged}">
                                            <form method="post" style="display: inline-block;">
                                                <input type="hidden" name="action" value="acknowledge">
                                                <input type="hidden" name="payrollId" value="${payslip.payrollId}">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fas fa-check me-2"></i>Acknowledge
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Historical Payslips -->
                        <c:if test="${not empty historicalPayslips}">
                            <div class="card mt-4 no-print">
                                <div class="card-header">
                                    <h6 class="mb-0">
                                        <i class="fas fa-history me-2"></i>Recent Payslips
                                    </h6>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Month</th>
                                                    <th>Net Salary</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="historical" items="${historicalPayslips}">
                                                    <tr>
                                                        <td>
                                                            <fmt:formatDate value="${historical.payrollMonth}" pattern="MMMM yyyy"/>
                                                        </td>
                                                        <td>
                                                            <fmt:formatNumber value="${historical.netSalary}" type="number" groupingUsed="true"/> VND
                                                        </td>
                                                        <td>
                                                            <span class="badge status-badge status-${historical.status.toLowerCase()}">
                                                                ${historical.status}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <a href="?month=<fmt:formatDate value='${historical.payrollMonth}' pattern='yyyy-MM'/>" 
                                                               class="btn btn-outline-primary btn-sm">
                                                                <i class="fas fa-eye me-1"></i>View
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-acknowledge after viewing (if required by business rules)
        <c:if test="${payslip.status == 'APPROVED' && !payslip.acknowledged && autoAcknowledge}">
            setTimeout(function() {
                if (confirm('Mark this payslip as acknowledged?')) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.innerHTML = `
                        <input type="hidden" name="action" value="acknowledge">
                        <input type="hidden" name="payrollId" value="${payslip.payrollId}">
                    `;
                    document.body.appendChild(form);
                    form.submit();
                }
            }, 5000); // Auto-prompt after 5 seconds
        </c:if>

        // Print functionality
        window.addEventListener('beforeprint', function() {
            document.title = 'Payslip_${payslip.employee.employeeId}_<fmt:formatDate value="${payslip.payrollMonth}" pattern="yyyy_MM"/>';
        });

        // Download PDF
        function downloadPDF() {
            window.location.href = '${pageContext.request.contextPath}/view-payslip?action=download&month=${selectedMonth}';
        }
    </script>
</body>
</html>

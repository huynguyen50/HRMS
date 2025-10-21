<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Mail Request - HRMS</title>
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
        .form-card { 
            box-shadow: 0 10px 25px rgba(0,0,0,0.1); 
            border: none; 
            border-radius: 12px; 
        }
        .form-header { 
            background: linear-gradient(135deg, var(--primary-color), #3b82f6); 
            color: white; 
            padding: 1.5rem; 
            border-radius: 12px 12px 0 0; 
        }
        .btn-primary { 
            background: var(--primary-color); 
            border: none; 
            padding: 0.75rem 2rem; 
        }
        .btn-secondary { 
            background: #6b7280; 
            border: none; 
            padding: 0.75rem 2rem; 
        }
        .form-control:focus { 
            border-color: var(--primary-color); 
            box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.25); 
        }
        .alert { 
            border-radius: 8px; 
            margin-bottom: 1.5rem; 
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
                        <i class="fas fa-user me-2"></i>
                        Welcome, ${sessionScope.employee.firstName} ${sessionScope.employee.lastName}
                    </div>
                </nav>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8 col-xl-6">
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

                <!-- Main Form Card -->
                <div class="card form-card">
                    <div class="form-header">
                        <h3 class="mb-0">
                            <i class="fas fa-envelope-open-text me-2"></i>
                            Submit Mail Request
                        </h3>
                        <p class="mb-0 mt-2 opacity-75">
                            Create a new request for management approval
                        </p>
                    </div>
                    
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/mail-request-submit" method="post" id="mailRequestForm">
                            <div class="row">
                                <!-- Employee Information (Read-only) -->
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Employee ID</label>
                                    <input type="text" class="form-control" value="${sessionScope.employee.employeeId}" readonly>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Department</label>
                                    <input type="text" class="form-control" value="${sessionScope.employee.department.departmentName}" readonly>
                                </div>
                            </div>

                            <!-- Request Type -->
                            <div class="mb-3">
                                <label for="requestType" class="form-label">
                                    <i class="fas fa-tag me-1"></i>Request Type *
                                </label>
                                <select class="form-select" id="requestType" name="requestType" required>
                                    <option value="">Select request type...</option>
                                    <option value="LEAVE">Leave Request</option>
                                    <option value="OVERTIME">Overtime Request</option>
                                    <option value="TRAVEL">Travel Request</option>
                                    <option value="EXPENSE">Expense Reimbursement</option>
                                    <option value="EQUIPMENT">Equipment Request</option>
                                    <option value="TRAINING">Training Request</option>
                                    <option value="OTHER">Other</option>
                                </select>
                            </div>

                            <!-- Subject -->
                            <div class="mb-3">
                                <label for="subject" class="form-label">
                                    <i class="fas fa-heading me-1"></i>Subject *
                                </label>
                                <input type="text" class="form-control" id="subject" name="subject" 
                                       placeholder="Brief summary of your request" required maxlength="200">
                            </div>

                            <!-- Priority -->
                            <div class="mb-3">
                                <label for="priority" class="form-label">
                                    <i class="fas fa-exclamation-circle me-1"></i>Priority
                                </label>
                                <select class="form-select" id="priority" name="priority">
                                    <option value="LOW">Low</option>
                                    <option value="MEDIUM" selected>Medium</option>
                                    <option value="HIGH">High</option>
                                    <option value="URGENT">Urgent</option>
                                </select>
                            </div>

                            <!-- Date Range (for applicable request types) -->
                            <div class="row" id="dateRange" style="display: none;">
                                <div class="col-md-6 mb-3">
                                    <label for="startDate" class="form-label">
                                        <i class="fas fa-calendar-alt me-1"></i>Start Date
                                    </label>
                                    <input type="date" class="form-control" id="startDate" name="startDate">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="endDate" class="form-label">
                                        <i class="fas fa-calendar-alt me-1"></i>End Date
                                    </label>
                                    <input type="date" class="form-control" id="endDate" name="endDate">
                                </div>
                            </div>

                            <!-- Amount (for financial requests) -->
                            <div class="mb-3" id="amountField" style="display: none;">
                                <label for="amount" class="form-label">
                                    <i class="fas fa-dollar-sign me-1"></i>Amount (VND)
                                </label>
                                <input type="number" class="form-control" id="amount" name="amount" 
                                       min="0" step="1000" placeholder="0">
                            </div>

                            <!-- Content -->
                            <div class="mb-3">
                                <label for="content" class="form-label">
                                    <i class="fas fa-align-left me-1"></i>Detailed Description *
                                </label>
                                <textarea class="form-control" id="content" name="content" rows="6" 
                                          placeholder="Please provide detailed information about your request..." 
                                          required maxlength="2000"></textarea>
                                <div class="form-text">
                                    <span id="contentCounter">0</span>/2000 characters
                                </div>
                            </div>

                            <!-- Attachments Info -->
                            <div class="mb-4">
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    <strong>Supporting Documents:</strong> If you have supporting documents, 
                                    please prepare them to submit separately or mention them in your description.
                                </div>
                            </div>

                            <!-- Form Actions -->
                            <div class="d-flex justify-content-between">
                                <button type="button" class="btn btn-secondary" onclick="window.history.back();">
                                    <i class="fas fa-times me-2"></i>Cancel
                                </button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-paper-plane me-2"></i>Submit Request
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Guidelines Card -->
                <div class="card mt-4">
                    <div class="card-header bg-light">
                        <h6 class="mb-0">
                            <i class="fas fa-lightbulb me-2"></i>Submission Guidelines
                        </h6>
                    </div>
                    <div class="card-body">
                        <ul class="mb-0">
                            <li>Ensure all required fields are completed accurately</li>
                            <li>Provide clear and detailed descriptions to avoid delays</li>
                            <li>Submit requests at least 48 hours in advance when possible</li>
                            <li>You will receive email notifications about the approval status</li>
                            <li>Contact HR for urgent matters or clarifications</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/validation.js"></script>
    <script>
        // Form validation rules
        const validationRules = {
            requestType: {
                required: true,
                requiredMessage: 'Please select a request type'
            },
            subject: {
                required: true,
                minLength: 5,
                maxLength: 200,
                requiredMessage: 'Subject is required',
                customValidator: (value) => {
                    if (HRMSValidator.hasDangerousChars(value)) {
                        return { isValid: false, message: 'Subject contains invalid characters' };
                    }
                    return { isValid: true };
                }
            },
            content: {
                required: true,
                minLength: 10,
                maxLength: 2000,
                requiredMessage: 'Detailed description is required',
                customValidator: (value) => {
                    if (HRMSValidator.hasDangerousChars(value)) {
                        return { isValid: false, message: 'Content contains invalid characters' };
                    }
                    return { isValid: true };
                }
            },
            amount: {
                required: false, // Set dynamically
                customValidator: (value) => {
                    if (value && !HRMSValidator.validatePositiveNumber(value).isValid) {
                        return { isValid: false, message: 'Amount must be a positive number' };
                    }
                    return { isValid: true };
                }
            }
        };

        document.addEventListener('DOMContentLoaded', function() {
            // Setup real-time validation
            Object.keys(validationRules).forEach(fieldId => {
                HRMSValidator.setupRealTimeValidation(fieldId, validationRules[fieldId]);
            });

            // Dynamic form fields based on request type
            document.getElementById('requestType').addEventListener('change', function() {
                const type = this.value;
                const dateRange = document.getElementById('dateRange');
                const amountField = document.getElementById('amountField');
                const startDate = document.getElementById('startDate');
                const endDate = document.getElementById('endDate');
                const amount = document.getElementById('amount');
                
                // Reset visibility and validation
                dateRange.style.display = 'none';
                amountField.style.display = 'none';
                startDate.required = false;
                endDate.required = false;
                amount.required = false;
                HRMSValidator.clearError('startDate');
                HRMSValidator.clearError('endDate');
                HRMSValidator.clearError('amount');
                
                // Show relevant fields and set validation
                if (type === 'LEAVE' || type === 'TRAVEL' || type === 'TRAINING') {
                    dateRange.style.display = 'block';
                    startDate.required = true;
                    endDate.required = true;
                    
                    // Setup date validation
                    HRMSValidator.setupRealTimeValidation('startDate', {
                        required: true,
                        requiredMessage: 'Start date is required'
                    });
                    HRMSValidator.setupRealTimeValidation('endDate', {
                        required: true,
                        requiredMessage: 'End date is required'
                    });
                }
                
                if (type === 'EXPENSE' || type === 'EQUIPMENT') {
                    amountField.style.display = 'block';
                    amount.required = true;
                    validationRules.amount.required = true;
                    
                    HRMSValidator.setupRealTimeValidation('amount', {
                        required: true,
                        requiredMessage: 'Amount is required',
                        customValidator: (value) => {
                            const result = HRMSValidator.validatePositiveNumber(value);
                            if (!result.isValid) {
                                return { isValid: false, message: 'Please enter a valid amount (positive number)' };
                            }
                            if (parseFloat(value) > 100000000) { // 100M VND limit
                                return { isValid: false, message: 'Amount cannot exceed 100,000,000 VND' };
                            }
                            return { isValid: true };
                        }
                    });
                }
            });

            // Form submission validation
            document.getElementById('mailRequestForm').addEventListener('submit', function(e) {
                let isValid = true;
                
                // Validate all required fields
                if (!HRMSValidator.validateForm('mailRequestForm', validationRules)) {
                    isValid = false;
                }
                
                // Additional date range validation
                const startDate = document.getElementById('startDate');
                const endDate = document.getElementById('endDate');
                
                if (startDate.required && endDate.required && startDate.value && endDate.value) {
                    const dateValidation = HRMSValidator.validateDateRange(startDate.value, endDate.value);
                    if (!dateValidation.isValid) {
                        HRMSValidator.showError('endDate', dateValidation.message);
                        isValid = false;
                    }
                }
                
                // Prevent submission if validation fails
                if (!isValid) {
                    e.preventDefault();
                    
                    // Scroll to first error
                    const firstError = document.querySelector('.is-invalid');
                    if (firstError) {
                        firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        firstError.focus();
                    }
                    
                    // Show global error message
                    const alertDiv = document.createElement('div');
                    alertDiv.className = 'alert alert-danger alert-dismissible fade show mt-3';
                    alertDiv.innerHTML = `
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Please correct the errors above before submitting.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    `;
                    
                    const form = document.getElementById('mailRequestForm');
                    form.parentNode.insertBefore(alertDiv, form);
                    
                    return false;
                }
                
                // Show loading state
                const submitBtn = document.querySelector('button[type="submit"]');
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Submitting...';
            });
        });
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Tasks - HRMS</title>
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
        .assign-card { 
            box-shadow: 0 10px 25px rgba(0,0,0,0.1); 
            border: none; 
            border-radius: 12px; 
            margin-bottom: 2rem;
        }
        .assign-header { 
            background: linear-gradient(135deg, var(--primary-color), #3b82f6); 
            color: white; 
            padding: 1.5rem; 
            border-radius: 12px 12px 0 0; 
        }
        .form-control:focus { 
            border-color: var(--primary-color); 
            box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.25); 
        }
        .employee-card {
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .employee-card:hover {
            border-color: var(--primary-color);
            background-color: #f8fafc;
        }
        .employee-card.selected {
            border-color: var(--primary-color);
            background-color: #eff6ff;
        }
        .workload-indicator {
            width: 100%;
            height: 6px;
            background-color: #e5e7eb;
            border-radius: 3px;
            overflow: hidden;
        }
        .workload-bar {
            height: 100%;
            border-radius: 3px;
            transition: width 0.3s ease;
        }
        .workload-low { background-color: var(--success-color); }
        .workload-medium { background-color: var(--warning-color); }
        .workload-high { background-color: var(--danger-color); }
        .task-preview {
            background-color: #f8fafc;
            border-radius: 8px;
            padding: 1.5rem;
            margin-top: 1rem;
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
                        <i class="fas fa-user-plus me-2"></i>
                        Task Assignment - ${sessionScope.employee.firstName} ${sessionScope.employee.lastName}
                    </div>
                </nav>
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

        <div class="row">
            <!-- Task Assignment Form -->
            <div class="col-lg-8">
                <div class="card assign-card">
                    <div class="assign-header">
                        <h3 class="mb-0">
                            <i class="fas fa-plus-circle me-2"></i>
                            Assign New Task
                        </h3>
                        <p class="mb-0 mt-2 opacity-75">
                            Create and assign tasks to your team members
                        </p>
                    </div>
                    
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/assign-task" method="post" id="assignTaskForm">
                            <!-- Task Details -->
                            <div class="row">
                                <div class="col-md-8 mb-3">
                                    <label for="taskName" class="form-label">
                                        <i class="fas fa-tag me-1"></i>Task Name *
                                    </label>
                                    <input type="text" class="form-control" id="taskName" name="taskName" 
                                           placeholder="Enter descriptive task name" required maxlength="200">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="priority" class="form-label">
                                        <i class="fas fa-exclamation-circle me-1"></i>Priority
                                    </label>
                                    <select class="form-select" id="priority" name="priority" required>
                                        <option value="LOW">Low</option>
                                        <option value="MEDIUM" selected>Medium</option>
                                        <option value="HIGH">High</option>
                                        <option value="URGENT">Urgent</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label">
                                    <i class="fas fa-align-left me-1"></i>Task Description *
                                </label>
                                <textarea class="form-control" id="description" name="description" rows="4" 
                                          placeholder="Provide detailed description of the task, objectives, and expected outcomes..." 
                                          required maxlength="1000"></textarea>
                                <div class="form-text">
                                    <span id="descriptionCounter">0</span>/1000 characters
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="assignedDate" class="form-label">
                                        <i class="fas fa-calendar-plus me-1"></i>Start Date
                                    </label>
                                    <input type="date" class="form-control" id="assignedDate" name="assignedDate" 
                                           value="${today}" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="dueDate" class="form-label">
                                        <i class="fas fa-calendar-check me-1"></i>Due Date *
                                    </label>
                                    <input type="date" class="form-control" id="dueDate" name="dueDate" required>
                                </div>
                            </div>

                            <!-- Additional Notes -->
                            <div class="mb-3">
                                <label for="note" class="form-label">
                                    <i class="fas fa-sticky-note me-1"></i>Additional Notes
                                </label>
                                <textarea class="form-control" id="note" name="note" rows="2" 
                                          placeholder="Any additional instructions, requirements, or context..."></textarea>
                            </div>

                            <!-- Assignee Selection -->
                            <div class="mb-4">
                                <label class="form-label">
                                    <i class="fas fa-user-check me-1"></i>Assign To *
                                </label>
                                <input type="hidden" id="selectedEmployeeId" name="assigneeId" required>
                                
                                <!-- Employee Filter -->
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <input type="text" class="form-control" id="employeeSearch" 
                                               placeholder="Search employees by name...">
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select" id="positionFilter">
                                            <option value="">All Positions</option>
                                            <c:forEach var="position" items="${positions}">
                                                <option value="${position}">${position}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select" id="workloadFilter">
                                            <option value="">All Workloads</option>
                                            <option value="LOW">Low Workload</option>
                                            <option value="MEDIUM">Medium Workload</option>
                                            <option value="HIGH">High Workload</option>
                                        </select>
                                    </div>
                                </div>

                                <!-- Employee List -->
                                <div id="employeeList" class="row">
                                    <c:forEach var="employee" items="${departmentEmployees}">
                                        <div class="col-md-6 col-lg-4 employee-item" 
                                             data-name="${employee.firstName} ${employee.lastName}"
                                             data-position="${employee.position}"
                                             data-workload="${employee.workloadLevel}">
                                            <div class="employee-card" onclick="selectEmployee(${employee.employeeId}, this)">
                                                <div class="d-flex align-items-center mb-2">
                                                    <div class="me-3">
                                                        <div class="bg-primary rounded-circle d-flex align-items-center justify-content-center" 
                                                             style="width: 40px; height: 40px;">
                                                            <span class="text-white fw-bold">
                                                                ${employee.firstName.charAt(0)}${employee.lastName.charAt(0)}
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="flex-grow-1">
                                                        <h6 class="mb-0">${employee.firstName} ${employee.lastName}</h6>
                                                        <small class="text-muted">${employee.position}</small>
                                                    </div>
                                                    <div class="text-end">
                                                        <small class="text-muted">ID: ${employee.employeeId}</small>
                                                    </div>
                                                </div>
                                                
                                                <div class="mb-2">
                                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                                        <small class="text-muted">Current Workload</small>
                                                        <small class="text-muted">${employee.currentTasks} tasks</small>
                                                    </div>
                                                    <div class="workload-indicator">
                                                        <div class="workload-bar workload-${employee.workloadLevel.toLowerCase()}" 
                                                             style="width: ${employee.workloadPercentage}%"></div>
                                                    </div>
                                                </div>
                                                
                                                <div class="row text-center">
                                                    <div class="col-4">
                                                        <small class="text-muted d-block">Pending</small>
                                                        <strong class="text-warning">${employee.pendingTasks}</strong>
                                                    </div>
                                                    <div class="col-4">
                                                        <small class="text-muted d-block">Progress</small>
                                                        <strong class="text-info">${employee.inProgressTasks}</strong>
                                                    </div>
                                                    <div class="col-4">
                                                        <small class="text-muted d-block">Completed</small>
                                                        <strong class="text-success">${employee.completedTasks}</strong>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Task Preview -->
                            <div class="task-preview" id="taskPreview" style="display: none;">
                                <h6 class="text-primary mb-3">
                                    <i class="fas fa-eye me-2"></i>Task Preview
                                </h6>
                                <div id="previewContent">
                                    <!-- Dynamic content -->
                                </div>
                            </div>

                            <!-- Form Actions -->
                            <div class="d-flex justify-content-between">
                                <button type="button" class="btn btn-secondary" onclick="resetForm()">
                                    <i class="fas fa-undo me-2"></i>Reset Form
                                </button>
                                <div>
                                    <button type="button" class="btn btn-outline-primary me-2" onclick="previewTask()">
                                        <i class="fas fa-eye me-2"></i>Preview
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-paper-plane me-2"></i>Assign Task
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Quick Stats & Recent Tasks -->
            <div class="col-lg-4">
                <!-- Department Stats -->
                <div class="card assign-card">
                    <div class="card-header bg-primary text-white">
                        <h6 class="mb-0">
                            <i class="fas fa-chart-pie me-2"></i>Department Overview
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-6 mb-3">
                                <h4 class="text-primary">${totalDepartmentEmployees}</h4>
                                <small class="text-muted">Team Members</small>
                            </div>
                            <div class="col-6 mb-3">
                                <h4 class="text-warning">${totalActiveTasks}</h4>
                                <small class="text-muted">Active Tasks</small>
                            </div>
                            <div class="col-6">
                                <h4 class="text-success">${completionRate}%</h4>
                                <small class="text-muted">Completion Rate</small>
                            </div>
                            <div class="col-6">
                                <h4 class="text-info">${avgTaskDuration}</h4>
                                <small class="text-muted">Avg. Duration (days)</small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Assignments -->
                <div class="card assign-card">
                    <div class="card-header bg-info text-white">
                        <h6 class="mb-0">
                            <i class="fas fa-history me-2"></i>Recent Assignments
                        </h6>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty recentTasks}">
                                <div class="text-center py-4">
                                    <i class="fas fa-inbox fa-2x text-muted mb-2"></i>
                                    <p class="text-muted mb-0">No recent assignments</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="list-group list-group-flush">
                                    <c:forEach var="task" items="${recentTasks}" varStatus="status">
                                        <div class="list-group-item">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <h6 class="mb-1">${task.taskName}</h6>
                                                    <p class="mb-1 text-muted small">
                                                        Assigned to: ${task.assignee.firstName} ${task.assignee.lastName}
                                                    </p>
                                                    <small class="text-muted">
                                                        <i class="fas fa-calendar me-1"></i>
                                                        <fmt:formatDate value="${task.assignedDate}" pattern="MMM dd, yyyy"/>
                                                    </small>
                                                </div>
                                                <div class="text-end">
                                                    <span class="badge bg-${task.priority == 'URGENT' ? 'danger' : task.priority == 'HIGH' ? 'warning' : task.priority == 'MEDIUM' ? 'info' : 'success'} badge-sm">
                                                        ${task.priority}
                                                    </span>
                                                    <br>
                                                    <small class="text-muted">#${task.taskId}</small>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="card assign-card">
                    <div class="card-header bg-secondary text-white">
                        <h6 class="mb-0">
                            <i class="fas fa-bolt me-2"></i>Quick Actions
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/approve-task-result" class="btn btn-outline-primary btn-sm">
                                <i class="fas fa-check-double me-2"></i>Review Completed Tasks
                            </a>
                            <a href="${pageContext.request.contextPath}/task-management" class="btn btn-outline-info btn-sm">
                                <i class="fas fa-tasks me-2"></i>View All Tasks
                            </a>
                            <button type="button" class="btn btn-outline-success btn-sm" onclick="generateTaskReport()">
                                <i class="fas fa-chart-bar me-2"></i>Generate Report
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/validation.js"></script>
    <script>
        let selectedEmployee = null;

        // Character counter for description
        document.getElementById('description').addEventListener('input', function() {
            const counter = document.getElementById('descriptionCounter');
            counter.textContent = this.value.length;
            
            if (this.value.length > 900) {
                counter.classList.add('text-warning');
            } else {
                counter.classList.remove('text-warning');
            }
        });

        // Employee selection
        function selectEmployee(employeeId, element) {
            // Remove previous selection
            document.querySelectorAll('.employee-card').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Add selection to clicked card
            element.classList.add('selected');
            document.getElementById('selectedEmployeeId').value = employeeId;
            selectedEmployee = employeeId;
            
            // Update preview if visible
            if (document.getElementById('taskPreview').style.display !== 'none') {
                previewTask();
            }
        }

        // Employee search and filter
        document.getElementById('employeeSearch').addEventListener('input', filterEmployees);
        document.getElementById('positionFilter').addEventListener('change', filterEmployees);
        document.getElementById('workloadFilter').addEventListener('change', filterEmployees);

        function filterEmployees() {
            const searchTerm = document.getElementById('employeeSearch').value.toLowerCase();
            const positionFilter = document.getElementById('positionFilter').value;
            const workloadFilter = document.getElementById('workloadFilter').value;
            
            document.querySelectorAll('.employee-item').forEach(item => {
                const name = item.dataset.name.toLowerCase();
                const position = item.dataset.position;
                const workload = item.dataset.workload;
                
                const matchesSearch = name.includes(searchTerm);
                const matchesPosition = !positionFilter || position === positionFilter;
                const matchesWorkload = !workloadFilter || workload === workloadFilter;
                
                if (matchesSearch && matchesPosition && matchesWorkload) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        }

        // Task preview
        function previewTask() {
            if (!selectedEmployee) {
                alert('Please select an employee first');
                return;
            }
            
            const taskName = document.getElementById('taskName').value;
            const description = document.getElementById('description').value;
            const priority = document.getElementById('priority').value;
            const dueDate = document.getElementById('dueDate').value;
            const note = document.getElementById('note').value;
            
            if (!taskName || !description || !dueDate) {
                alert('Please fill in required fields first');
                return;
            }
            
            const selectedCard = document.querySelector('.employee-card.selected');
            const employeeName = selectedCard.querySelector('h6').textContent;
            
            document.getElementById('previewContent').innerHTML = `
                <div class="row">
                    <div class="col-md-6">
                        <strong>Task:</strong> ${taskName}<br>
                        <strong>Priority:</strong> <span class="badge bg-${priority.toLowerCase() === 'urgent' ? 'danger' : priority.toLowerCase() === 'high' ? 'warning' : priority.toLowerCase() === 'medium' ? 'info' : 'success'}">${priority}</span><br>
                        <strong>Due Date:</strong> ${new Date(dueDate).toLocaleDateString()}<br>
                        <strong>Assigned To:</strong> ${employeeName}
                    </div>
                    <div class="col-md-6">
                        <strong>Description:</strong><br>
                        <p class="text-muted small">${description}</p>
                        ${note ? `<strong>Notes:</strong><br><p class="text-muted small">${note}</p>` : ''}
                    </div>
                </div>
            `;
            
            document.getElementById('taskPreview').style.display = 'block';
        }        // Comprehensive Form validation with HRMSValidator
        const assignTaskValidationRules = {
            taskName: {
                required: true,
                minLength: 5,
                maxLength: 200,
                requiredMessage: 'Task name is required',
                customValidator: (value) => {
                    if (HRMSValidator.hasDangerousChars(value)) {
                        return { isValid: false, message: 'Task name contains invalid characters' };
                    }
                    if (!/[a-zA-Z]/.test(value)) {
                        return { isValid: false, message: 'Task name must contain letters' };
                    }
                    return { isValid: true };
                }
            },
            description: {
                required: true,
                minLength: 10,
                maxLength: 1000,
                requiredMessage: 'Task description is required',
                customValidator: (value) => {
                    if (HRMSValidator.hasDangerousChars(value)) {
                        return { isValid: false, message: 'Description contains invalid characters' };
                    }
                    return { isValid: true };
                }
            },
            priority: {
                required: true,
                requiredMessage: 'Please select a priority level'
            },
            assignedDate: {
                required: true,
                requiredMessage: 'Assigned date is required'
            },
            dueDate: {
                required: true,
                requiredMessage: 'Due date is required'
            },
            note: {
                required: false,
                maxLength: 500,
                customValidator: (value) => {
                    if (value && HRMSValidator.hasDangerousChars(value)) {
                        return { isValid: false, message: 'Notes contain invalid characters' };
                    }
                    return { isValid: true };
                }
            }
        };

        document.addEventListener('DOMContentLoaded', function() {
            Object.keys(assignTaskValidationRules).forEach(fieldId => {
                HRMSValidator.setupRealTimeValidation(fieldId, assignTaskValidationRules[fieldId]);
            });
        });

        document.getElementById('assignTaskForm').addEventListener('submit', function(e) {
            let isValid = true;
            
            // Validate all fields
            if (!HRMSValidator.validateForm('assignTaskForm', assignTaskValidationRules)) {
                isValid = false;
            }
            
            // Validate employee selection
            if (!selectedEmployee) {
                isValid = false;
                const employeeSection = document.querySelector('.employee-grid, #employeeList').parentElement;
                const errorDiv = document.createElement('div');
                errorDiv.className = 'alert alert-danger mt-2';
                errorDiv.innerHTML = '<i class="fas fa-exclamation-triangle me-2"></i>Please select an employee to assign this task';
                employeeSection.appendChild(errorDiv);
                setTimeout(() => errorDiv.remove(), 5000);
            }
            
            // Validate date range
            const dueDate = new Date(document.getElementById('dueDate').value);
            const assignedDate = new Date(document.getElementById('assignedDate').value);
            
            if (dueDate <= assignedDate) {
                HRMSValidator.showError('dueDate', 'Due date must be after assigned date');
                isValid = false;
            }
            
            if (!isValid) {
                e.preventDefault();
                const firstError = document.querySelector('.is-invalid, .alert-danger');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
                return false;
            }
            
            // Show loading state
            const submitBtn = document.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Assigning Task...';
            }
        });

        // Reset form
        function resetForm() {
            if (confirm('Are you sure you want to reset the form? All entered data will be lost.')) {
                document.getElementById('assignTaskForm').reset();
                document.querySelectorAll('.employee-card').forEach(card => {
                    card.classList.remove('selected');
                });
                document.getElementById('selectedEmployeeId').value = '';
                document.getElementById('taskPreview').style.display = 'none';
                selectedEmployee = null;
            }
        }

        // Set minimum due date to tomorrow
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        document.getElementById('dueDate').min = tomorrow.toISOString().split('T')[0];

        // Quick actions
        function generateTaskReport() {
            window.open('${pageContext.request.contextPath}/task-report?departmentId=${sessionScope.employee.department.departmentId}', '_blank');
        }
    </script>
</body>
</html>

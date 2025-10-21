<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Task Status - HRMS</title>
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
        .task-card { 
            box-shadow: 0 10px 25px rgba(0,0,0,0.1); 
            border: none; 
            border-radius: 12px; 
            margin-bottom: 1.5rem;
            transition: transform 0.2s ease;
        }
        .task-card:hover { 
            transform: translateY(-2px); 
        }
        .task-header { 
            background: linear-gradient(135deg, var(--primary-color), #3b82f6); 
            color: white; 
            padding: 1.5rem; 
            border-radius: 12px 12px 0 0; 
        }
        .priority-indicator {
            width: 4px;
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            border-radius: 12px 0 0 12px;
        }
        .priority-low { background-color: var(--success-color); }
        .priority-medium { background-color: var(--warning-color); }
        .priority-high { background-color: var(--danger-color); }
        .priority-urgent { background-color: #dc2626; }
        .status-badge { 
            font-size: 0.75rem; 
            padding: 0.375rem 0.75rem; 
            border-radius: 6px;
        }
        .status-pending { background-color: #6b7280; color: white; }
        .status-in-progress { background-color: var(--info-color); color: white; }
        .status-completed { background-color: var(--success-color); color: white; }
        .status-overdue { background-color: var(--danger-color); color: white; }
        .progress-bar-container {
            background-color: #e5e7eb;
            border-radius: 6px;
            height: 8px;
            overflow: hidden;
        }
        .progress-bar {
            height: 100%;
            border-radius: 6px;
            transition: width 0.3s ease;
        }
        .form-control:focus { 
            border-color: var(--primary-color); 
            box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.25); 
        }
        .task-meta {
            background-color: #f8fafc;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        .attachment-item {
            background-color: white;
            border: 1px solid #e5e7eb;
            border-radius: 6px;
            padding: 0.75rem;
            margin-bottom: 0.5rem;
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
                        <i class="fas fa-tasks me-2"></i>
                        My Tasks - ${sessionScope.employee.firstName} ${sessionScope.employee.lastName}
                    </div>
                </nav>
            </div>
        </div>

        <!-- Task Summary -->
        <div class="row mb-4">
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="card text-center border-0 shadow-sm">
                    <div class="card-body">
                        <h3 class="text-primary">${totalTasks}</h3>
                        <p class="text-muted mb-0">Total Tasks</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="card text-center border-0 shadow-sm">
                    <div class="card-body">
                        <h3 class="text-warning">${pendingTasks}</h3>
                        <p class="text-muted mb-0">Pending</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="card text-center border-0 shadow-sm">
                    <div class="card-body">
                        <h3 class="text-info">${inProgressTasks}</h3>
                        <p class="text-muted mb-0">In Progress</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="card text-center border-0 shadow-sm">
                    <div class="card-body">
                        <h3 class="text-success">${completedTasks}</h3>
                        <p class="text-muted mb-0">Completed</p>
                    </div>
                </div>
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

        <!-- Filter and Sort -->
        <div class="card mb-4">
            <div class="card-body">
                <form method="get" class="row align-items-end">
                    <div class="col-md-3 mb-2">
                        <label for="statusFilter" class="form-label">Status</label>
                        <select class="form-select" id="statusFilter" name="status">
                            <option value="">All Status</option>
                            <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                            <option value="IN_PROGRESS" ${param.status == 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                            <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                        </select>
                    </div>
                    <div class="col-md-3 mb-2">
                        <label for="priorityFilter" class="form-label">Priority</label>
                        <select class="form-select" id="priorityFilter" name="priority">
                            <option value="">All Priorities</option>
                            <option value="LOW" ${param.priority == 'LOW' ? 'selected' : ''}>Low</option>
                            <option value="MEDIUM" ${param.priority == 'MEDIUM' ? 'selected' : ''}>Medium</option>
                            <option value="HIGH" ${param.priority == 'HIGH' ? 'selected' : ''}>High</option>
                            <option value="URGENT" ${param.priority == 'URGENT' ? 'selected' : ''}>Urgent</option>
                        </select>
                    </div>
                    <div class="col-md-3 mb-2">
                        <label for="sortBy" class="form-label">Sort By</label>
                        <select class="form-select" id="sortBy" name="sortBy">
                            <option value="dueDate" ${param.sortBy == 'dueDate' ? 'selected' : ''}>Due Date</option>
                            <option value="priority" ${param.sortBy == 'priority' ? 'selected' : ''}>Priority</option>
                            <option value="assignedDate" ${param.sortBy == 'assignedDate' ? 'selected' : ''}>Assigned Date</option>
                        </select>
                    </div>
                    <div class="col-md-3 mb-2">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-filter me-2"></i>Apply Filters
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Tasks List -->
        <div class="row">
            <c:choose>
                <c:when test="${empty tasks}">
                    <div class="col-12">
                        <div class="text-center py-5">
                            <i class="fas fa-tasks fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No Tasks Found</h5>
                            <p class="text-muted">You don't have any tasks assigned or they've been filtered out.</p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="task" items="${tasks}">
                        <div class="col-lg-6 col-xl-4">
                            <div class="card task-card position-relative">
                                <!-- Priority Indicator -->
                                <div class="priority-indicator priority-${task.priority.toLowerCase()}"></div>
                                
                                <div class="card-header bg-transparent border-0 pb-0">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <h6 class="card-title mb-1">${task.taskName}</h6>
                                        <c:choose>
                                            <c:when test="${task.status == 'PENDING'}">
                                                <span class="badge status-badge status-pending">
                                                    <i class="fas fa-clock me-1"></i>Pending
                                                </span>
                                            </c:when>
                                            <c:when test="${task.status == 'IN_PROGRESS'}">
                                                <span class="badge status-badge status-in-progress">
                                                    <i class="fas fa-play me-1"></i>In Progress
                                                </span>
                                            </c:when>
                                            <c:when test="${task.status == 'COMPLETED'}">
                                                <span class="badge status-badge status-completed">
                                                    <i class="fas fa-check me-1"></i>Completed
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                    
                                    <!-- Progress Bar -->
                                    <div class="mt-2">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <small class="text-muted">Progress</small>
                                            <small class="text-muted">${task.progress}%</small>
                                        </div>
                                        <div class="progress-bar-container">
                                            <div class="progress-bar bg-primary" style="width: ${task.progress}%"></div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="card-body pt-2">
                                    <p class="card-text text-muted small mb-3">
                                        ${task.description}
                                    </p>
                                    
                                    <!-- Task Meta Information -->
                                    <div class="task-meta">
                                        <div class="row text-sm">
                                            <div class="col-6">
                                                <small class="text-muted">
                                                    <i class="fas fa-user me-1"></i>
                                                    ${task.assignedBy.firstName} ${task.assignedBy.lastName}
                                                </small>
                                            </div>
                                            <div class="col-6 text-end">
                                                <small class="text-muted">
                                                    <i class="fas fa-calendar me-1"></i>
                                                    <fmt:formatDate value="${task.dueDate}" pattern="MMM dd"/>
                                                </small>
                                            </div>
                                        </div>
                                        <c:if test="${not empty task.note}">
                                            <hr class="my-2">
                                            <small class="text-muted">
                                                <i class="fas fa-sticky-note me-1"></i>
                                                <strong>Note:</strong> ${task.note}
                                            </small>
                                        </c:if>
                                    </div>
                                    
                                    <!-- Due Date Warning -->
                                    <c:set var="daysUntilDue" value="${(task.dueDate.time - now.time) / (1000*60*60*24)}" />
                                    <c:if test="${daysUntilDue < 2 && task.status != 'COMPLETED'}">
                                        <div class="alert alert-warning alert-sm py-2 mb-3">
                                            <i class="fas fa-exclamation-triangle me-1"></i>
                                            <c:choose>
                                                <c:when test="${daysUntilDue < 0}">
                                                    <small>Overdue by <fmt:formatNumber value="${-daysUntilDue}" maxFractionDigits="0"/> days</small>
                                                </c:when>
                                                <c:otherwise>
                                                    <small>Due in <fmt:formatNumber value="${daysUntilDue}" maxFractionDigits="0"/> days</small>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:if>
                                    
                                    <!-- Action Buttons -->
                                    <div class="d-grid gap-2">
                                        <c:if test="${task.status != 'COMPLETED'}">
                                            <button type="button" class="btn btn-primary btn-sm" 
                                                    onclick="updateTaskStatus(${task.taskId})">
                                                <i class="fas fa-edit me-2"></i>Update Status
                                            </button>
                                        </c:if>
                                        <button type="button" class="btn btn-outline-secondary btn-sm" 
                                                onclick="viewTaskDetails(${task.taskId})">
                                            <i class="fas fa-eye me-2"></i>View Details
                                        </button>
                                    </div>
                                </div>
                                
                                <div class="card-footer bg-transparent border-0 pt-0">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <small class="text-muted">
                                            Priority: 
                                            <span class="badge bg-${task.priority == 'URGENT' ? 'danger' : task.priority == 'HIGH' ? 'warning' : task.priority == 'MEDIUM' ? 'info' : 'success'} badge-sm">
                                                ${task.priority}
                                            </span>
                                        </small>
                                        <small class="text-muted">
                                            ID: #${task.taskId}
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Task pagination" class="mt-4">
                <ul class="pagination justify-content-center">
                    <c:if test="${currentPage > 0}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage - 1}&status=${param.status}&priority=${param.priority}&sortBy=${param.sortBy}">Previous</a>
                        </li>
                    </c:if>
                    
                    <c:forEach begin="0" end="${totalPages - 1}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}&status=${param.status}&priority=${param.priority}&sortBy=${param.sortBy}">${i + 1}</a>
                        </li>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages - 1}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage + 1}&status=${param.status}&priority=${param.priority}&sortBy=${param.sortBy}">Next</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </div>

    <!-- Update Task Status Modal -->
    <div class="modal fade" id="updateTaskModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-edit me-2"></i>Update Task Status
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form id="updateTaskForm" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="updateTaskId" name="taskId">
                        
                        <div class="mb-3">
                            <label for="taskStatus" class="form-label">Status</label>
                            <select class="form-select" id="taskStatus" name="status" required>
                                <option value="PENDING">Pending</option>
                                <option value="IN_PROGRESS">In Progress</option>
                                <option value="COMPLETED">Completed</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="taskProgress" class="form-label">
                                Progress: <span id="progressValue">0</span>%
                            </label>
                            <input type="range" class="form-range" id="taskProgress" name="progress" 
                                   min="0" max="100" value="0" oninput="updateProgressValue(this.value)">
                        </div>
                        
                        <div class="mb-3">
                            <label for="progressReport" class="form-label">Progress Report</label>
                            <textarea class="form-control" id="progressReport" name="progressReport" 
                                      rows="4" placeholder="Describe what you've accomplished and any challenges..."></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="attachments" class="form-label">Attachments (Optional)</label>
                            <input type="file" class="form-control" id="attachments" name="attachments" multiple>
                            <div class="form-text">
                                Upload supporting documents, screenshots, or other relevant files
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Update Task
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Task Details Modal -->
    <div class="modal fade" id="taskDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-info-circle me-2"></i>Task Details
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="taskDetailsContent">
                    <!-- Content will be loaded dynamically -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const updateTaskModal = new bootstrap.Modal(document.getElementById('updateTaskModal'));
        const taskDetailsModal = new bootstrap.Modal(document.getElementById('taskDetailsModal'));

        function updateTaskStatus(taskId) {
            document.getElementById('updateTaskId').value = taskId;
            document.getElementById('updateTaskForm').action = '${pageContext.request.contextPath}/update-task-status';
            
            // Load current task data
            fetch(`${pageContext.request.contextPath}/update-task-status?action=get&taskId=${taskId}`)
                .then(response => response.json())
                .then(task => {
                    document.getElementById('taskStatus').value = task.status;
                    document.getElementById('taskProgress').value = task.progress || 0;
                    document.getElementById('progressReport').value = task.progressReport || '';
                    updateProgressValue(task.progress || 0);
                })
                .catch(error => console.error('Error loading task data:', error));
                
            updateTaskModal.show();
        }

        function viewTaskDetails(taskId) {
            fetch(`${pageContext.request.contextPath}/update-task-status?action=view&taskId=${taskId}`)
                .then(response => response.json())
                .then(task => {
                    document.getElementById('taskDetailsContent').innerHTML = `
                        <div class="row">
                            <div class="col-md-6">
                                <h6>Task Information</h6>
                                <table class="table table-sm">
                                    <tr><td>Task Name:</td><td><strong>${task.taskName}</strong></td></tr>
                                    <tr><td>Assigned By:</td><td>${task.assignedBy.firstName} ${task.assignedBy.lastName}</td></tr>
                                    <tr><td>Assigned Date:</td><td>${new Date(task.assignedDate).toLocaleDateString()}</td></tr>
                                    <tr><td>Due Date:</td><td>${new Date(task.dueDate).toLocaleDateString()}</td></tr>
                                    <tr><td>Priority:</td><td><span class="badge bg-info">${task.priority}</span></td></tr>
                                    <tr><td>Status:</td><td><span class="badge bg-primary">${task.status}</span></td></tr>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <h6>Progress</h6>
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between">
                                        <span>Completion:</span>
                                        <span><strong>${task.progress}%</strong></span>
                                    </div>
                                    <div class="progress">
                                        <div class="progress-bar" style="width: ${task.progress}%"></div>
                                    </div>
                                </div>
                                ${task.progressReport ? `
                                    <h6>Latest Progress Report</h6>
                                    <p class="text-muted">${task.progressReport}</p>
                                ` : ''}
                            </div>
                        </div>
                        <hr>
                        <div>
                            <h6>Description</h6>
                            <p>${task.description}</p>
                        </div>
                        ${task.note ? `
                            <div>
                                <h6>Additional Notes</h6>
                                <p class="text-muted">${task.note}</p>
                            </div>
                        ` : ''}
                        ${task.attachments ? `
                            <div>
                                <h6>Attachments</h6>
                                <div class="attachment-list">
                                    ${task.attachments.split(',').map(file => `
                                        <div class="attachment-item">
                                            <i class="fas fa-file me-2"></i>
                                            <a href="${pageContext.request.contextPath}/uploads/${file}" target="_blank">${file}</a>
                                        </div>
                                    `).join('')}
                                </div>
                            </div>
                        ` : ''}
                    `;
                    taskDetailsModal.show();
                })
                .catch(error => {
                    console.error('Error loading task details:', error);
                    alert('Error loading task details');
                });
        }

        function updateProgressValue(value) {
            document.getElementById('progressValue').textContent = value;
            
            // Auto-update status based on progress
            const statusSelect = document.getElementById('taskStatus');
            if (value == 0) {
                statusSelect.value = 'PENDING';
            } else if (value == 100) {
                statusSelect.value = 'COMPLETED';
            } else if (value > 0) {
                statusSelect.value = 'IN_PROGRESS';
            }
        }        // Auto-update progress when status changes
        document.getElementById('taskStatus').addEventListener('change', function() {
            const progressSlider = document.getElementById('taskProgress');
            if (this.value === 'PENDING') {
                progressSlider.value = 0;
            } else if (this.value === 'COMPLETED') {
                progressSlider.value = 100;
            }
            updateProgressValue(progressSlider.value);
        });

        // Form validation for task update
        const taskUpdateValidationRules = {
            taskProgress: {
                required: true,
                customValidator: (value) => {
                    const progress = parseInt(value);
                    if (progress < 0 || progress > 100) {
                        return { isValid: false, message: 'Progress must be between 0 and 100%' };
                    }
                    return { isValid: true };
                }
            },
            completionNotes: {
                required: false,
                maxLength: 1000,
                customValidator: (value) => {
                    if (value && HRMSValidator.hasDangerousChars(value)) {
                        return { isValid: false, message: 'Notes contain invalid characters' };
                    }
                    if (value && value.trim().length < 5) {
                        return { isValid: false, message: 'Notes must be at least 5 characters long' };
                    }
                    return { isValid: true };
                }
            }
        };

        // Setup validation when document is ready
        document.addEventListener('DOMContentLoaded', function() {
            // Setup real-time validation for completion notes
            HRMSValidator.setupRealTimeValidation('completionNotes', taskUpdateValidationRules.completionNotes);

            // Validate form on submission
            document.addEventListener('submit', function(e) {
                const form = e.target;
                if (form.classList.contains('task-update-form')) {
                    let isValid = true;

                    // Get form elements
                    const progress = form.querySelector('[name="progress"]');
                    const status = form.querySelector('[name="status"]');
                    const notes = form.querySelector('[name="completionNotes"]');

                    // Validate progress
                    if (progress) {
                        const progressValue = parseInt(progress.value);
                        if (progressValue < 0 || progressValue > 100) {
                            HRMSValidator.showError('taskProgress', 'Progress must be between 0 and 100%');
                            isValid = false;
                        }
                    }

                    // Validate completion notes for completed tasks
                    if (status && status.value === 'COMPLETED' && notes) {
                        if (!notes.value || notes.value.trim().length < 5) {
                            HRMSValidator.showError('completionNotes', 'Completion notes are required when marking task as completed (min 5 characters)');
                            isValid = false;
                        } else if (HRMSValidator.hasDangerousChars(notes.value)) {
                            HRMSValidator.showError('completionNotes', 'Completion notes contain invalid characters');
                            isValid = false;
                        }
                    }

                    // Validate file uploads
                    const fileInput = form.querySelector('input[type="file"]');
                    if (fileInput && fileInput.files.length > 0) {
                        const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
                        const maxSize = 10 * 1024 * 1024; // 10MB

                        for (let file of fileInput.files) {
                            // Check file type
                            if (!allowedTypes.includes(file.type)) {
                                alert('Invalid file type: ' + file.name + '. Only JPG, PNG, GIF, PDF, and DOC files are allowed.');
                                isValid = false;
                                break;
                            }

                            // Check file size
                            if (file.size > maxSize) {
                                alert('File too large: ' + file.name + '. Maximum size is 10MB.');
                                isValid = false;
                                break;
                            }

                            // Check filename for dangerous characters
                            if (HRMSValidator.hasDangerousChars(file.name)) {
                                alert('Invalid characters in filename: ' + file.name);
                                isValid = false;
                                break;
                            }
                        }
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
                    const submitBtn = form.querySelector('button[type="submit"]');
                    if (submitBtn) {
                        submitBtn.disabled = true;
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Updating...';
                    }
                }
            });
        });
    </script>
    <script src="${pageContext.request.contextPath}/js/validation.js"></script>
</body>
</html>

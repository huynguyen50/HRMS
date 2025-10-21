<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Approve Task Results - HRMS</title>
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
        .approval-card { 
            box-shadow: 0 10px 25px rgba(0,0,0,0.1); 
            border: none; 
            border-radius: 12px; 
            margin-bottom: 1.5rem;
            transition: transform 0.2s ease;
        }
        .approval-card:hover { 
            transform: translateY(-2px); 
        }
        .approval-header { 
            background: linear-gradient(135deg, var(--primary-color), #3b82f6); 
            color: white; 
            padding: 1.5rem; 
            border-radius: 12px 12px 0 0; 
        }
        .task-card { 
            border: 1px solid #e5e7eb; 
            border-radius: 8px; 
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
        }
        .task-card:hover { 
            box-shadow: 0 4px 12px rgba(0,0,0,0.1); 
        }
        .task-header {
            background-color: #f8fafc;
            padding: 1rem;
            border-bottom: 1px solid #e5e7eb;
            border-radius: 8px 8px 0 0;
        }
        .priority-indicator {
            width: 4px;
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            border-radius: 8px 0 0 8px;
        }
        .priority-low { background-color: var(--success-color); }
        .priority-medium { background-color: var(--warning-color); }
        .priority-high { background-color: var(--danger-color); }
        .priority-urgent { background-color: #dc2626; }
        .progress-circle {
            position: relative;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: conic-gradient(var(--primary-color) 0deg, var(--primary-color) var(--progress), #e5e7eb var(--progress), #e5e7eb 360deg);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .progress-circle::before {
            content: '';
            position: absolute;
            width: 46px;
            height: 46px;
            border-radius: 50%;
            background: white;
        }
        .progress-text {
            position: relative;
            font-weight: 700;
            font-size: 0.875rem;
            color: var(--primary-color);
        }
        .attachment-preview {
            display: inline-block;
            background: #f8fafc;
            border: 1px solid #e5e7eb;
            border-radius: 6px;
            padding: 0.5rem;
            margin: 0.25rem;
            text-decoration: none;
            color: var(--text-color);
            transition: background-color 0.2s ease;
        }
        .attachment-preview:hover {
            background: #e5e7eb;
            color: var(--primary-color);
        }
        .stats-row { margin-bottom: 2rem; }
        .stat-card { 
            background: white; 
            border-radius: 12px; 
            box-shadow: 0 4px 6px rgba(0,0,0,0.05); 
            padding: 1.5rem; 
            text-align: center; 
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
        .approval-actions {
            background-color: #f8fafc;
            border-radius: 8px;
            padding: 1rem;
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
                        <i class="fas fa-check-double me-2"></i>
                        Task Approval - ${sessionScope.employee.firstName} ${sessionScope.employee.lastName}
                    </div>
                </nav>
            </div>
        </div>

        <!-- Statistics Row -->
        <div class="row stats-row">
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="stat-card">
                    <div class="stat-number text-warning">${pendingApproval}</div>
                    <div class="stat-label">Pending Approval</div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="stat-card">
                    <div class="stat-number text-success">${approvedToday}</div>
                    <div class="stat-label">Approved Today</div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="stat-card">
                    <div class="stat-number text-info">${avgReviewTime}</div>
                    <div class="stat-label">Avg Review Time (hrs)</div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="stat-card">
                    <div class="stat-number text-primary">${teamProductivity}%</div>
                    <div class="stat-label">Team Productivity</div>
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

        <!-- Filter Section -->
        <div class="card approval-card">
            <div class="card-body">
                <form method="get" class="row align-items-end">
                    <div class="col-md-3 mb-2">
                        <label for="priorityFilter" class="form-label">Priority</label>
                        <select class="form-select" id="priorityFilter" name="priority">
                            <option value="">All Priorities</option>
                            <option value="URGENT" ${param.priority == 'URGENT' ? 'selected' : ''}>Urgent</option>
                            <option value="HIGH" ${param.priority == 'HIGH' ? 'selected' : ''}>High</option>
                            <option value="MEDIUM" ${param.priority == 'MEDIUM' ? 'selected' : ''}>Medium</option>
                            <option value="LOW" ${param.priority == 'LOW' ? 'selected' : ''}>Low</option>
                        </select>
                    </div>
                    <div class="col-md-3 mb-2">
                        <label for="employeeFilter" class="form-label">Employee</label>
                        <select class="form-select" id="employeeFilter" name="employeeId">
                            <option value="">All Employees</option>
                            <c:forEach var="emp" items="${departmentEmployees}">
                                <option value="${emp.employeeId}" ${param.employeeId == emp.employeeId ? 'selected' : ''}>
                                    ${emp.firstName} ${emp.lastName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3 mb-2">
                        <label for="dateFilter" class="form-label">Completed Date</label>
                        <input type="date" class="form-control" id="dateFilter" name="completedDate" value="${param.completedDate}">
                    </div>
                    <div class="col-md-3 mb-2">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-filter me-2"></i>Apply Filters
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Tasks Pending Approval -->
        <div class="row">
            <div class="col-12">
                <div class="card approval-card">
                    <div class="approval-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h3 class="mb-0">
                                    <i class="fas fa-clipboard-check me-2"></i>
                                    Tasks Pending Approval
                                </h3>
                                <p class="mb-0 mt-2 opacity-75">
                                    Review and approve completed tasks from your team
                                </p>
                            </div>
                            <div>
                                <button class="btn btn-light btn-sm me-2" onclick="approveAllVisible()">
                                    <i class="fas fa-check-double me-2"></i>Approve All
                                </button>
                                <button class="btn btn-light btn-sm" onclick="location.reload()">
                                    <i class="fas fa-sync-alt me-2"></i>Refresh
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty completedTasks}">
                                <div class="text-center py-5">
                                    <i class="fas fa-tasks fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">No Tasks Pending Approval</h5>
                                    <p class="text-muted">All completed tasks have been reviewed.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="p-4">
                                    <c:forEach var="task" items="${completedTasks}">
                                        <div class="task-card position-relative">
                                            <!-- Priority Indicator -->
                                            <div class="priority-indicator priority-${task.priority.toLowerCase()}"></div>
                                            
                                            <div class="task-header">
                                                <div class="row align-items-center">
                                                    <div class="col-md-8">
                                                        <h5 class="mb-1">${task.taskName}</h5>
                                                        <div class="text-muted">
                                                            <i class="fas fa-user me-1"></i>
                                                            ${task.assignee.firstName} ${task.assignee.lastName}
                                                            <span class="mx-2">•</span>
                                                            <i class="fas fa-calendar me-1"></i>
                                                            Completed: <fmt:formatDate value="${task.completedDate}" pattern="MMM dd, yyyy"/>
                                                            <span class="mx-2">•</span>
                                                            <span class="badge bg-${task.priority == 'URGENT' ? 'danger' : task.priority == 'HIGH' ? 'warning' : task.priority == 'MEDIUM' ? 'info' : 'success'} badge-sm">
                                                                ${task.priority}
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4 text-end">
                                                        <div class="progress-circle" style="--progress: ${task.progress * 3.6}deg;">
                                                            <div class="progress-text">${task.progress}%</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="card-body">
                                                <!-- Task Details -->
                                                <div class="row mb-3">
                                                    <div class="col-md-6">
                                                        <h6 class="text-primary mb-2">Task Description</h6>
                                                        <p class="text-muted">${task.description}</p>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <h6 class="text-primary mb-2">Timeline</h6>
                                                        <table class="table table-sm table-borderless">
                                                            <tr>
                                                                <td class="text-muted">Assigned:</td>
                                                                <td><fmt:formatDate value="${task.assignedDate}" pattern="MMM dd, yyyy"/></td>
                                                            </tr>
                                                            <tr>
                                                                <td class="text-muted">Due Date:</td>
                                                                <td>
                                                                    <fmt:formatDate value="${task.dueDate}" pattern="MMM dd, yyyy"/>
                                                                    <c:set var="daysOverdue" value="${(task.completedDate.time - task.dueDate.time) / (1000*60*60*24)}" />
                                                                    <c:if test="${daysOverdue > 0}">
                                                                        <span class="badge bg-warning ms-2">
                                                                            <fmt:formatNumber value="${daysOverdue}" maxFractionDigits="0"/> days late
                                                                        </span>
                                                                    </c:if>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="text-muted">Completed:</td>
                                                                <td><fmt:formatDate value="${task.completedDate}" pattern="MMM dd, yyyy HH:mm"/></td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </div>

                                                <!-- Progress Report -->
                                                <c:if test="${not empty task.progressReport}">
                                                    <div class="mb-3">
                                                        <h6 class="text-primary mb-2">
                                                            <i class="fas fa-file-alt me-1"></i>Final Report
                                                        </h6>
                                                        <div class="bg-light rounded p-3">
                                                            <p class="mb-0" style="white-space: pre-wrap;">${task.progressReport}</p>
                                                        </div>
                                                    </div>
                                                </c:if>

                                                <!-- Attachments -->
                                                <c:if test="${not empty task.attachments}">
                                                    <div class="mb-3">
                                                        <h6 class="text-primary mb-2">
                                                            <i class="fas fa-paperclip me-1"></i>Attachments
                                                        </h6>
                                                        <div>
                                                            <c:forEach var="attachment" items="${task.attachmentList}">
                                                                <a href="${pageContext.request.contextPath}/uploads/${attachment}" 
                                                                   target="_blank" class="attachment-preview">
                                                                    <i class="fas fa-file me-1"></i>
                                                                    ${attachment}
                                                                </a>
                                                            </c:forEach>
                                                        </div>
                                                    </div>
                                                </c:if>

                                                <!-- Quality Assessment -->
                                                <div class="mb-3">
                                                    <h6 class="text-primary mb-2">
                                                        <i class="fas fa-star me-1"></i>Quality Assessment
                                                    </h6>
                                                    <div class="row">
                                                        <div class="col-md-4">
                                                            <small class="text-muted">Completion Rate</small>
                                                            <div class="progress mb-2" style="height: 8px;">
                                                                <div class="progress-bar bg-success" style="width: ${task.progress}%"></div>
                                                            </div>
                                                            <small class="text-success">${task.progress}% Complete</small>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <small class="text-muted">On-Time Delivery</small>
                                                            <div class="progress mb-2" style="height: 8px;">
                                                                <div class="progress-bar ${daysOverdue <= 0 ? 'bg-success' : 'bg-warning'}" 
                                                                     style="width: ${daysOverdue <= 0 ? '100' : '60'}%"></div>
                                                            </div>
                                                            <small class="${daysOverdue <= 0 ? 'text-success' : 'text-warning'}">
                                                                ${daysOverdue <= 0 ? 'On Time' : 'Late Delivery'}
                                                            </small>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <small class="text-muted">Overall Quality</small>
                                                            <div class="progress mb-2" style="height: 8px;">
                                                                <div class="progress-bar bg-info" style="width: 85%"></div>
                                                            </div>
                                                            <small class="text-info">Good Quality</small>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Approval Actions -->
                                                <div class="approval-actions">
                                                    <div class="row align-items-center">
                                                        <div class="col-md-8">
                                                            <div class="mb-2">
                                                                <label for="approverComment${task.taskId}" class="form-label small">
                                                                    Manager Comments (Optional)
                                                                </label>
                                                                <textarea class="form-control form-control-sm" 
                                                                          id="approverComment${task.taskId}" 
                                                                          rows="2" 
                                                                          placeholder="Add feedback or comments about the task completion..."></textarea>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4 text-end">
                                                            <div class="btn-group" role="group">
                                                                <button type="button" class="btn btn-outline-info btn-sm" 
                                                                        onclick="viewTaskHistory(${task.taskId})"
                                                                        title="View History">
                                                                    <i class="fas fa-history"></i>
                                                                </button>
                                                                <button type="button" class="btn btn-success btn-sm" 
                                                                        onclick="approveTask(${task.taskId})"
                                                                        title="Approve Task">
                                                                    <i class="fas fa-check me-1"></i>Approve
                                                                </button>
                                                                <button type="button" class="btn btn-danger btn-sm" 
                                                                        onclick="rejectTask(${task.taskId})"
                                                                        title="Reject Task">
                                                                    <i class="fas fa-times me-1"></i>Reject
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Task pagination" class="mt-4">
                <ul class="pagination justify-content-center">
                    <c:if test="${currentPage > 0}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage - 1}&priority=${param.priority}&employeeId=${param.employeeId}&completedDate=${param.completedDate}">Previous</a>
                        </li>
                    </c:if>
                    
                    <c:forEach begin="0" end="${totalPages - 1}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}&priority=${param.priority}&employeeId=${param.employeeId}&completedDate=${param.completedDate}">${i + 1}</a>
                        </li>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages - 1}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage + 1}&priority=${param.priority}&employeeId=${param.employeeId}&completedDate=${param.completedDate}">Next</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </div>

    <!-- Task History Modal -->
    <div class="modal fade" id="taskHistoryModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-history me-2"></i>Task History
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="taskHistoryContent">
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
        const taskHistoryModal = new bootstrap.Modal(document.getElementById('taskHistoryModal'));

        function approveTask(taskId) {
            const comment = document.getElementById(`approverComment${taskId}`).value;
            
            if (confirm('Are you sure you want to approve this task?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/approve-task-result';
                form.innerHTML = `
                    <input type="hidden" name="action" value="approve">
                    <input type="hidden" name="taskId" value="${taskId}">
                    <input type="hidden" name="approverComment" value="${comment}">
                `;
                document.body.appendChild(form);
                form.submit();
            }
        }

        function rejectTask(taskId) {
            const comment = document.getElementById(`approverComment${taskId}`).value;
            
            if (!comment.trim()) {
                alert('Please provide a comment explaining why the task is being rejected.');
                document.getElementById(`approverComment${taskId}`).focus();
                return;
            }
            
            if (confirm('Are you sure you want to reject this task? The employee will need to revise and resubmit.')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/approve-task-result';
                form.innerHTML = `
                    <input type="hidden" name="action" value="reject">
                    <input type="hidden" name="taskId" value="${taskId}">
                    <input type="hidden" name="approverComment" value="${comment}">
                `;
                document.body.appendChild(form);
                form.submit();
            }
        }

        function viewTaskHistory(taskId) {
            fetch(`${pageContext.request.contextPath}/approve-task-result?action=history&taskId=${taskId}`)
                .then(response => response.json())
                .then(history => {
                    let content = `
                        <div class="timeline">
                            <h6>Task Progress Timeline</h6>
                    `;
                    
                    history.forEach((item, index) => {
                        content += `
                            <div class="timeline-item mb-3">
                                <div class="row">
                                    <div class="col-md-3">
                                        <small class="text-muted">${new Date(item.date).toLocaleString()}</small>
                                    </div>
                                    <div class="col-md-9">
                                        <strong>${item.action}</strong><br>
                                        <span class="text-muted">${item.description}</span>
                                        ${item.comment ? `<br><em>"${item.comment}"</em>` : ''}
                                    </div>
                                </div>
                                ${index < history.length - 1 ? '<hr>' : ''}
                            </div>
                        `;
                    });
                    
                    content += '</div>';
                    document.getElementById('taskHistoryContent').innerHTML = content;
                    taskHistoryModal.show();
                })
                .catch(error => {
                    console.error('Error loading task history:', error);
                    document.getElementById('taskHistoryContent').innerHTML = `
                        <div class="text-center py-4">
                            <i class="fas fa-exclamation-triangle fa-2x text-warning mb-3"></i>
                            <p>Unable to load task history at this time.</p>
                        </div>
                    `;
                    taskHistoryModal.show();
                });
        }

        function approveAllVisible() {
            const visibleTasks = document.querySelectorAll('.task-card');
            
            if (visibleTasks.length === 0) {
                alert('No tasks to approve.');
                return;
            }
            
            if (confirm(`Are you sure you want to approve all ${visibleTasks.length} visible tasks?`)) {
                const taskIds = [];
                visibleTasks.forEach(card => {
                    const approveBtn = card.querySelector('button[onclick*="approveTask"]');
                    if (approveBtn) {
                        const onclick = approveBtn.getAttribute('onclick');
                        const taskId = onclick.match(/approveTask\((\d+)\)/)[1];
                        taskIds.push(taskId);
                    }
                });
                
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/approve-task-result';
                form.innerHTML = `
                    <input type="hidden" name="action" value="batchApprove">
                    <input type="hidden" name="taskIds" value="${taskIds.join(',')}">
                `;
                document.body.appendChild(form);
                form.submit();
            }
        }

        // Auto-refresh every 5 minutes for real-time updates
        setInterval(() => {
            const lastRefresh = sessionStorage.getItem('lastRefresh');
            const now = Date.now();
            
            if (!lastRefresh || (now - parseInt(lastRefresh)) > 300000) { // 5 minutes
                sessionStorage.setItem('lastRefresh', now.toString());
                location.reload();
            }
        }, 300000);

        // Mark last refresh time
        sessionStorage.setItem('lastRefresh', Date.now().toString());
    </script>
</body>
</html>

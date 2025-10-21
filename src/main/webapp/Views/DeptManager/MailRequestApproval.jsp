<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Approve Mail Requests - HRMS</title>
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
        .table-card { 
            box-shadow: 0 10px 25px rgba(0,0,0,0.1); 
            border: none; 
            border-radius: 12px; 
        }
        .table-header { 
            background: linear-gradient(135deg, var(--primary-color), #3b82f6); 
            color: white; 
            padding: 1.5rem; 
            border-radius: 12px 12px 0 0; 
        }
        .priority-badge {
            font-size: 0.75rem;
            padding: 0.375rem 0.75rem;
        }
        .priority-low { background-color: #10b981; }
        .priority-medium { background-color: #3b82f6; }
        .priority-high { background-color: #f59e0b; }
        .priority-urgent { background-color: #ef4444; }
        .btn-sm { padding: 0.375rem 0.75rem; font-size: 0.875rem; }
        .modal-header { background: var(--primary-color); color: white; }
        .table { margin-bottom: 0; }
        .table th { background-color: #f8fafc; border-bottom: 2px solid #e5e7eb; }
        .table td { vertical-align: middle; }
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
                        <i class="fas fa-user-tie me-2"></i>
                        HR Manager: ${sessionScope.employee.firstName} ${sessionScope.employee.lastName}
                    </div>
                </nav>
            </div>
        </div>

        <!-- Statistics Row -->
        <div class="row stats-row">
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="stat-card">
                    <div class="stat-number text-primary">${totalPending}</div>
                    <div class="stat-label">Pending Requests</div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="stat-card">
                    <div class="stat-number text-warning">${urgentCount}</div>
                    <div class="stat-label">Urgent Requests</div>
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
                    <div class="stat-number text-info">${avgProcessingTime}</div>
                    <div class="stat-label">Avg. Processing (hrs)</div>
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

        <!-- Main Table Card -->
        <div class="row">
            <div class="col-12">
                <div class="card table-card">
                    <div class="table-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h3 class="mb-0">
                                    <i class="fas fa-clipboard-check me-2"></i>
                                    Pending Mail Requests
                                </h3>
                                <p class="mb-0 mt-2 opacity-75">
                                    Review and approve employee requests
                                </p>
                            </div>
                            <div>
                                <button class="btn btn-light btn-sm" onclick="location.reload()">
                                    <i class="fas fa-sync-alt me-2"></i>Refresh
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty pendingRequests}">
                                <div class="text-center py-5">
                                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">No Pending Requests</h5>
                                    <p class="text-muted">All requests have been processed.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Request ID</th>
                                                <th>Employee</th>
                                                <th>Type</th>
                                                <th>Subject</th>
                                                <th>Priority</th>
                                                <th>Submit Date</th>
                                                <th>Days Pending</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="request" items="${pendingRequests}">
                                                <tr>
                                                    <td class="fw-bold text-primary">#${request.requestId}</td>
                                                    <td>
                                                        <div>
                                                            <strong>${request.employee.firstName} ${request.employee.lastName}</strong>
                                                            <br>
                                                            <small class="text-muted">${request.employee.department.departmentName}</small>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-secondary">${request.requestType}</span>
                                                    </td>
                                                    <td>
                                                        <div style="max-width: 200px;">
                                                            <div class="text-truncate">${request.subject}</div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${request.priority == 'URGENT'}">
                                                                <span class="badge priority-badge priority-urgent">
                                                                    <i class="fas fa-exclamation-triangle me-1"></i>URGENT
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${request.priority == 'HIGH'}">
                                                                <span class="badge priority-badge priority-high">
                                                                    <i class="fas fa-arrow-up me-1"></i>HIGH
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${request.priority == 'MEDIUM'}">
                                                                <span class="badge priority-badge priority-medium">
                                                                    <i class="fas fa-minus me-1"></i>MEDIUM
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge priority-badge priority-low">
                                                                    <i class="fas fa-arrow-down me-1"></i>LOW
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${request.submitDate}" pattern="yyyy-MM-dd"/>
                                                        <br>
                                                        <small class="text-muted">
                                                            <fmt:formatDate value="${request.submitDate}" pattern="HH:mm"/>
                                                        </small>
                                                    </td>
                                                    <td>
                                                        <c:set var="daysPending" value="${(now.time - request.submitDate.time) / (1000*60*60*24)}" />
                                                        <fmt:formatNumber value="${daysPending}" maxFractionDigits="0"/> days
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <button type="button" class="btn btn-outline-primary btn-sm" 
                                                                    onclick="viewRequest(${request.requestId})"
                                                                    title="View Details">
                                                                <i class="fas fa-eye"></i>
                                                            </button>
                                                            <button type="button" class="btn btn-success btn-sm" 
                                                                    onclick="approveRequest(${request.requestId})"
                                                                    title="Approve">
                                                                <i class="fas fa-check"></i>
                                                            </button>
                                                            <button type="button" class="btn btn-danger btn-sm" 
                                                                    onclick="rejectRequest(${request.requestId})"
                                                                    title="Reject">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Request pagination" class="mt-4">
                <ul class="pagination justify-content-center">
                    <c:if test="${currentPage > 0}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage - 1}">Previous</a>
                        </li>
                    </c:if>
                    
                    <c:forEach begin="0" end="${totalPages - 1}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}">${i + 1}</a>
                        </li>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages - 1}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage + 1}">Next</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </div>

    <!-- View Request Modal -->
    <div class="modal fade" id="viewRequestModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-eye me-2"></i>Request Details
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="requestDetails">
                    <!-- Content will be loaded dynamically -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-success" onclick="approveFromModal()">
                        <i class="fas fa-check me-2"></i>Approve
                    </button>
                    <button type="button" class="btn btn-danger" onclick="rejectFromModal()">
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
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form id="actionForm" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="actionRequestId" name="requestId">
                        <input type="hidden" id="actionType" name="action">
                        
                        <div class="mb-3">
                            <label for="adminComments" class="form-label">Comments</label>
                            <textarea class="form-control" id="adminComments" name="adminComments" 
                                      rows="3" placeholder="Optional comments for the employee..."></textarea>
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
    <script>
        let currentRequestId = null;
        const viewModal = new bootstrap.Modal(document.getElementById('viewRequestModal'));
        const actionModal = new bootstrap.Modal(document.getElementById('actionModal'));

        function viewRequest(requestId) {
            currentRequestId = requestId;
            
            // Load request details via AJAX
            fetch(`${pageContext.request.contextPath}/mail-request-approval?action=view&requestId=${requestId}`)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('requestDetails').innerHTML = `
                        <div class="row">
                            <div class="col-md-6">
                                <strong>Request ID:</strong> #${data.requestId}<br>
                                <strong>Employee:</strong> ${data.employee.firstName} ${data.employee.lastName}<br>
                                <strong>Department:</strong> ${data.employee.department.departmentName}<br>
                                <strong>Type:</strong> ${data.requestType}<br>
                                <strong>Priority:</strong> ${data.priority}
                            </div>
                            <div class="col-md-6">
                                <strong>Submit Date:</strong> ${new Date(data.submitDate).toLocaleString()}<br>
                                <strong>Start Date:</strong> ${data.startDate ? new Date(data.startDate).toLocaleDateString() : 'N/A'}<br>
                                <strong>End Date:</strong> ${data.endDate ? new Date(data.endDate).toLocaleDateString() : 'N/A'}<br>
                                <strong>Amount:</strong> ${data.amount ? data.amount.toLocaleString() + ' VND' : 'N/A'}
                            </div>
                        </div>
                        <hr>
                        <div>
                            <strong>Subject:</strong><br>
                            <p>${data.subject}</p>
                        </div>
                        <div>
                            <strong>Content:</strong><br>
                            <p style="white-space: pre-wrap;">${data.content}</p>
                        </div>
                    `;
                    viewModal.show();
                })
                .catch(error => {
                    console.error('Error loading request details:', error);
                    alert('Error loading request details');
                });
        }

        function approveRequest(requestId) {
            currentRequestId = requestId;
            document.getElementById('actionModalTitle').textContent = 'Approve Request';
            document.getElementById('actionRequestId').value = requestId;
            document.getElementById('actionType').value = 'approve';
            document.getElementById('actionSubmitBtn').className = 'btn btn-success';
            document.getElementById('actionSubmitBtn').innerHTML = '<i class="fas fa-check me-2"></i>Approve';
            document.getElementById('actionForm').action = '${pageContext.request.contextPath}/mail-request-approval';
            actionModal.show();
        }

        function rejectRequest(requestId) {
            currentRequestId = requestId;
            document.getElementById('actionModalTitle').textContent = 'Reject Request';
            document.getElementById('actionRequestId').value = requestId;
            document.getElementById('actionType').value = 'reject';
            document.getElementById('actionSubmitBtn').className = 'btn btn-danger';
            document.getElementById('actionSubmitBtn').innerHTML = '<i class="fas fa-times me-2"></i>Reject';
            document.getElementById('actionForm').action = '${pageContext.request.contextPath}/mail-request-approval';
            actionModal.show();
        }

        function approveFromModal() {
            viewModal.hide();
            approveRequest(currentRequestId);
        }

        function rejectFromModal() {
            viewModal.hide();
            rejectRequest(currentRequestId);
        }

        // Auto-refresh for urgent requests
        setInterval(() => {
            const urgentBadges = document.querySelectorAll('.priority-urgent');
            if (urgentBadges.length > 0) {
                urgentBadges.forEach(badge => {
                    badge.style.animation = 'pulse 1s infinite';
                });
            }
        }, 5000);
    </script>

    <style>
        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.7; }
            100% { opacity: 1; }
        }
    </style>
</body>
</html>

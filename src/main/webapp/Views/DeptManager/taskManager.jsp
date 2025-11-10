<%-- 
    Document   : taskManager
    Created on : Nov 6, 2025, 5:03:53 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Task Manager</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3">Task Manager</h1>
                <a href="${pageContext.request.contextPath}/postTask" class="btn btn-success">
                    <i class="fas fa-plus-circle me-1"></i> Create New Task
                </a>
            </div>

            <div class="card mb-4">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/taskManager" method="GET" class="row g-3 align-items-end">
                        <div class="col-md-3">
                            <label class="form-label">Search by Title</label>
                            <input type="text" class="form-control" name="searchByTitle" placeholder="Enter title..." value="${param.searchByTitle}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Status</label>
                            <select class="form-select" name="filterStatus">
                                <option value="all" ${param.filterStatus == 'all' ? 'selected' : ''}>All</option>
                                <option value="Pending" ${param.filterStatus == 'Pending' ? 'selected' : ''}>Pending</option>
                                <option value="In Progress" ${param.filterStatus == 'In Progress' ? 'selected' : ''}>In Progress</option>
                                <option value="Completed" ${param.filterStatus == 'Completed' ? 'selected' : ''}>Completed</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Start</label>
                            <input type="date" class="form-control" name="startDate" value="${param.startDate}">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">End</label>
                            <input type="date" class="form-control" name="endDate" value="${param.endDate}">
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-search me-1"></i> Filter
                            </button>
                        </div>
                        <div class="col-md-2">
                            <a href="${pageContext.request.contextPath}/taskManager" class="btn btn-secondary w-100">
                                <i class="fas fa-eraser me-1"></i> Clear
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Description</th>
                                    <th>Start Date</th>
                                    <th>Due Date</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty tasks}">
                                        <c:forEach var="task" items="${tasks}">
                                            <tr>
                                                <td>${task.title}</td>
                                                <td>${task.description}</td>
                                                <td>${task.startDate}</td>
                                                <td>${task.dueDate}</td>
                                                <td>
                                                    <span class="badge ${task.status == 'Completed' ? 'bg-success' : (task.status == 'In Progress' ? 'bg-warning text-dark' : 'bg-secondary')}">
                                                        ${task.status}
                                                    </span>
                                                </td>
                                                <td class="text-end">
                                                    <div class="btn-group">
                                                        <a href="${pageContext.request.contextPath}/viewTask?action=view&id=${task.taskId}" class="btn btn-sm btn-outline-primary">View</a>
                                                        <a href="${pageContext.request.contextPath}/taskManager?action=viewAssignees&id=${task.taskId}" class="btn btn-sm btn-outline-primary" 
                                                           data-bs-toggle="modal" data-bs-target="#assigneesModal" 
                                                           onclick="loadAssignees(${task.taskId})">
                                                            <i class="fas fa-users me-1"></i> View participating member
                                                        </a>
                                                        <c:if test="${task.status ne 'Rejected'}">
                                                            <a href="${pageContext.request.contextPath}/taskManager?action=reject&id=${task.taskId}" 
                                                               class="action-btn-custom btn btn-sm btn-outline-success ms-2"
                                                               onclick="return confirm('Do you want to send this task? This action cannot be undone.');">
                                                                <i class="fas fa-paper-plane me-1"></i> Send
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/taskManager?action=send&id=${task.taskId}"
                                                               class="action-btn-custom btn btn-sm btn-outline-danger ms-2"
                                                               onclick="return confirm('Do you want to delete this task? This action cannot be undone.');">
                                                                <i class="fas fa-times me-1"></i> Delete
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${empty tasks}">
                        <div class="alert alert-warning text-center" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i> No task found.
                        </div>
                    </c:if>

                    <c:if test="${not empty mess}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>${mess}</span>
                        </div>
                    </c:if>

                    <c:if test="${totalPages > 1}">
                        <nav>
                            <ul class="pagination justify-content-center">
                                <!-- Previous -->
                                <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/taskManager?page=${currentPage - 1}&searchByTitle=${fn:escapeXml(param.searchByTitle)}&filterStatus=${param.filterStatus}&startDate=${param.startDate}&endDate=${param.endDate}">Previous</a>
                                </li>

                                <!-- Numbered pages -->
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/taskManager?page=${i}&searchByTitle=${fn:escapeXml(param.searchByTitle)}&filterStatus=${param.filterStatus}&startDate=${param.startDate}&endDate=${param.endDate}">${i}</a>
                                    </li>
                                </c:forEach>

                                <!-- Next -->
                                <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/taskManager?page=${currentPage + 1}&searchByTitle=${fn:escapeXml(param.searchByTitle)}&filterStatus=${param.filterStatus}&startDate=${param.startDate}&endDate=${param.endDate}">Next</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Modal for viewing assignees -->
        <div class="modal fade" id="assigneesModal" tabindex="-1" aria-labelledby="assigneesModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="assigneesModalLabel">Participating Members</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div id="assigneesList">
                            <div class="text-center">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                                   function loadAssignees(taskId) {
                                                                       document.getElementById('assigneesList').innerHTML = `
                    <div class="text-center">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                    </div>
                `;

                                                                       fetch('${pageContext.request.contextPath}/taskManager?action=viewAssignees&id=' + taskId)
                                                                               .then(response => response.text())
                                                                               .then(html => {
                                                                                   // Extract just the employee names from the response
                                                                                   const parser = new DOMParser();
                                                                                   const doc = parser.parseFromString(html, 'text/html');
                                                                                   const employeeElements = doc.querySelectorAll('.employee-name');

                                                                                   let namesHtml = '';
                                                                                   if (employeeElements.length > 0) {
                                                                                       employeeElements.forEach(el => {
                                                                                           namesHtml += '<div class="mb-2"><i class="fas fa-user me-2"></i>' + el.textContent + '</div>';
                                                                                       });
                                                                                   } else {
                                                                                       namesHtml = '<div class="alert alert-info">No employees assigned to this task.</div>';
                                                                                   }

                                                                                   document.getElementById('assigneesList').innerHTML = namesHtml;
                                                                               })
                                                                               .catch(error => {
                                                                                   console.error('Error:', error);
                                                                                   document.getElementById('assigneesList').innerHTML = '<div class="alert alert-danger">Error loading assignees.</div>';
                                                                               });
                                                                   }
        </script>
    </body>
</html>
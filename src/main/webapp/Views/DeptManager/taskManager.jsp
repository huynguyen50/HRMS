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
                                    <th>Assigned By</th>
                                    <th>Assign To</th>
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
                                                <td>${task.assignedBy}</td>
                                                <td>${task.assignTo}</td>
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
                                                        <a href="${pageContext.request.contextPath}/taskManager?action=reject&id=${task.taskId}" class="btn btn-sm btn-outline-primary">Reject</a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8" class="text-center text-muted">No tasks found</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

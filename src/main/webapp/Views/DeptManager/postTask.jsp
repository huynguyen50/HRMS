<%-- 
    Document   : postTask
    Created on : Nov 6, 2025, 6:42:46 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create New Task</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .form-label {
                font-weight: 600;
            }
            .message {
                padding: 10px;
                margin-bottom: 20px;
                border-radius: 5px;
            }
            .success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
            .employee-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 10px;
                max-height: 300px;
                overflow-y: auto;
                padding: 10px;
                border: 1px solid #dee2e6;
                border-radius: 5px;
            }
            .employee-item {
                padding: 8px;
                border: 1px solid #dee2e6;
                border-radius: 4px;
                background-color: white;
            }
            .employee-item:hover {
                background-color: #e9ecef;
            }
        </style>
    </head>
    <body>
        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3">Create New Task</h1>
                <a href="${pageContext.request.contextPath}/taskManager" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-1"></i> Back to Tasks
                </a>
            </div>

            <c:if test="${not empty param.mess}">
                <div class="message success">
                    <i class="fas fa-check-circle me-2"></i>
                    ${param.mess}
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="message error">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    ${param.error}
                </div>
            </c:if>

            <div class="card">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/postTask" method="post">
                        <div class="mb-3">
                            <label for="title" class="form-label">Title</label>
                            <input type="text" class="form-control" id="title" name="title" required maxlength="50">
                        </div>
                        
                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="4" required maxlength="1000"></textarea>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="startDate" class="form-label">Start Date</label>
                                <input type="datetime-local" class="form-control" id="startDate" name="startDate" required>
                            </div>
                            <div class="col-md-6">
                                <label for="dueDate" class="form-label">Due Date</label>
                                <input type="datetime-local" class="form-control" id="dueDate" name="dueDate" required>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Assign To</label>
                            <div class="employee-grid">
                                <c:forEach var="emp" items="${employeeList}">
                                    <div class="form-check employee-item">
                                        <input class="form-check-input" type="checkbox" name="assignTo" value="${emp.employeeId}" id="emp${emp.employeeId}">
                                        <label class="form-check-label" for="emp${emp.employeeId}">
                                            <i class="fas fa-user me-2"></i>${emp.fullName}
                                        </label>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-end">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-1"></i> Create Task
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidates - HR Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <header class="header">
            <div class="header-content">
                <h1><i class="fas fa-users"></i> HR Management System</h1>
                <nav>
                    <a href="${pageContext.request.contextPath}/" class="nav-link">Home</a>
                    <a href="${pageContext.request.contextPath}/employees/" class="nav-link">Employees</a>
                    <a href="${pageContext.request.contextPath}/department/" class="nav-link">Departments</a>
                    <a href="${pageContext.request.contextPath}/guests/list" class="nav-link active">Candidates</a>
                </nav>
            </div>
        </header>

        <main class="main-content">
            <div class="list-container">
                <div class="list-header">
                    <h2><i class="fas fa-user-tie"></i> Candidates List</h2>
                    <div class="header-actions">
                        <div class="filter-group">
                            <label for="statusFilter">Filter by Status:</label>
                            <select id="statusFilter" onchange="filterCandidates()">
                                <option value="">All Status</option>
                                <option value="Applied">Applied</option>
                                <option value="Interview">Interview</option>
                                <option value="Rejected">Rejected</option>
                                <option value="Hired">Hired</option>
                            </select>
                        </div>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty guests}">
                        <div class="candidates-grid">
                            <c:forEach items="${guests}" var="guest">
                                <div class="candidate-card" data-status="${guest.status}">
                                    <div class="candidate-header">
                                        <div class="candidate-avatar">
                                            <i class="fas fa-user"></i>
                                        </div>
                                        <div class="candidate-info">
                                            <h3>${guest.fullName}</h3>
                                            <span class="candidate-status status-${guest.status.toLowerCase()}">${guest.status}</span>
                                        </div>
                                    </div>
                                    
                                    <div class="candidate-details">
                                        <div class="detail-item">
                                            <i class="fas fa-envelope"></i>
                                            <a href="mailto:${guest.email}">${guest.email}</a>
                                        </div>
                                        <div class="detail-item">
                                            <i class="fas fa-phone"></i>
                                            <a href="tel:${guest.phone}">${guest.phone}</a>
                                        </div>
                                        <c:if test="${not empty guest.jobTitle}">
                                            <div class="detail-item">
                                                <i class="fas fa-briefcase"></i>
                                                <span>${guest.jobTitle}</span>
                                            </div>
                                        </c:if>
                                        <div class="detail-item">
                                            <i class="fas fa-calendar"></i>
                                            <span><fmt:formatDate value="${guest.appliedDate}" pattern="dd/MM/yyyy" /></span>
                                        </div>
                                    </div>
                                    
                                    <div class="candidate-actions">
                                        <a href="${pageContext.request.contextPath}/guests/view?id=${guest.guestId}" 
                                           class="btn btn-primary btn-sm">
                                            <i class="fas fa-eye"></i> View Details
                                        </a>
                                        <c:if test="${not empty guest.cv}">
                                            <a href="${guest.cv}" target="_blank" class="btn btn-secondary btn-sm">
                                                <i class="fas fa-file-pdf"></i> CV
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-data">
                            <i class="fas fa-user-tie"></i>
                            <p>No candidates found.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>

        <footer class="footer">
            <p>&copy; 2025 HR Management System. All rights reserved.</p>
        </footer>
    </div>

    <script>
        function filterCandidates() {
            const statusFilter = document.getElementById('statusFilter').value;
            const candidateCards = document.querySelectorAll('.candidate-card');
            
            candidateCards.forEach(card => {
                if (statusFilter === '' || card.dataset.status === statusFilter) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>
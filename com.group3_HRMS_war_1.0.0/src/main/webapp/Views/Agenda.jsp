<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agenda - HRM System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.css" rel="stylesheet">
</head>
<body>
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-0"><i class="fas fa-calendar-alt me-2 text-primary"></i>Agenda</h2>
            <small class="text-muted">Today's items and upcoming schedule</small>
        </div>
    </div>

    <!-- Calendar View -->
    <div class="card mb-4">
        <div class="card-body">
            <div id="calendar"></div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-6">
            <div class="card h-100">
                <div class="card-header bg-white">
                    <strong><i class="fas fa-sun me-2 text-warning"></i>Today</strong>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Assignee</th>
                                    <th>Due</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty tasksToday}">
                                        <c:forEach items="${tasksToday}" var="task">
                                            <tr>
                                                <td>${task.title}</td>
                                                <td>${empty task.assignToName ? '-' : task.assignToName}</td>
                                                <td>
                                                    <c:if test="${not empty task.dueDate}">
                                                        <fmt:formatDate value="${task.dueDate}" pattern="dd/MM/yyyy"/>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <span class="badge bg-${task.status == 'Completed' ? 'success' : (task.status == 'In Progress' ? 'warning' : 'secondary')}">${task.status}</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="text-muted">No items for today.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card h-100">
                <div class="card-header bg-white">
                    <strong><i class="fas fa-forward me-2 text-primary"></i>Upcoming</strong>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Assignee</th>
                                    <th>Start</th>
                                    <th>Due</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty tasksUpcoming}">
                                        <c:forEach items="${tasksUpcoming}" var="task">
                                            <tr>
                                                <td>${task.title}</td>
                                                <td>${empty task.assignToName ? '-' : task.assignToName}</td>
                                                <td>
                                                    <c:if test="${not empty task.startDate}">
                                                        <fmt:formatDate value="${task.startDate}" pattern="dd/MM/yyyy"/>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty task.dueDate}">
                                                        <fmt:formatDate value="${task.dueDate}" pattern="dd/MM/yyyy"/>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <span class="badge bg-${task.status == 'Completed' ? 'success' : (task.status == 'In Progress' ? 'warning' : 'secondary')}">${task.status}</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="text-muted">No upcoming items.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
<script>
    (function() {
        // Build events from server-provided lists
        const events = [];

        // Helper to push event if has dates
        function pushEvent(title, assignee, startStr, endStr, status) {
            if (!startStr && !endStr) return;
            const displayTitle = assignee && assignee.trim().length > 0
                ? `${title} — ${assignee}`
                : title;
            const colorMap = {
                'Completed': '#28a745',
                'In Progress': '#ffc107',
                'Pending': '#6c757d'
            };
            events.push({
                title: displayTitle,
                start: startStr || endStr,
                end: endStr || undefined,
                allDay: true,
                backgroundColor: colorMap[status] || '#667eea',
                borderColor: colorMap[status] || '#667eea'
            });
        }

        // Safely inject from JSP collections
        // Today
        // eslint-disable-next-line no-undef
        <%-- Today tasks --%>
        <c:if test="${not empty tasksToday}">
            <c:forEach items="${tasksToday}" var="task">
                pushEvent(
                    "${fn:escapeXml(task.title)}",
                    "${fn:escapeXml(empty task.assignToName ? '' : task.assignToName)}",
                    "<fmt:formatDate value='${task.startDate}' pattern='yyyy-MM-dd'/>",
                    "<fmt:formatDate value='${task.dueDate}' pattern='yyyy-MM-dd'/>",
                    "${fn:escapeXml(empty task.status ? '' : task.status)}"
                );
            </c:forEach>
        </c:if>

        <%-- Upcoming tasks --%>
        <c:if test="${not empty tasksUpcoming}">
            <c:forEach items="${tasksUpcoming}" var="task">
                pushEvent(
                    "${fn:escapeXml(task.title)}",
                    "${fn:escapeXml(empty task.assignToName ? '' : task.assignToName)}",
                    "<fmt:formatDate value='${task.startDate}' pattern='yyyy-MM-dd'/>",
                    "<fmt:formatDate value='${task.dueDate}' pattern='yyyy-MM-dd'/>",
                    "${fn:escapeXml(empty task.status ? '' : task.status)}"
                );
            </c:forEach>
        </c:if>

        // Initialize calendar
        const calendarEl = document.getElementById('calendar');
        if (calendarEl) {
            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
                },
                height: 'auto',
                firstDay: 1, // Monday
                navLinks: true,
                selectable: false,
                events
            });
            calendar.render();
        }
    })();
</script>
</body>
</html>



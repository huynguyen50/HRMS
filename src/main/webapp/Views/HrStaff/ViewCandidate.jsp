<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HR Staff - Candidate List</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"/>
        <style>
            :root {
                --primary:#5b5bd6;
                --secondary:#8b5bd6;
                --bg:#f3f4f6;
                --card:#ffffff;
                --border:#e5e7eb;
                --text:#111827;
                --muted:#6b7280;
                --success:#10b981;
                --danger:#ef4444;
                --accent:#2563eb;
            }

            * {
                box-sizing: border-box;
            }

            body {
                margin: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: var(--bg);
                color: var(--text);
            }

            .topbar {
                height: 64px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 20px;
                background: linear-gradient(90deg, var(--primary), var(--secondary));
                color: #fff;
                box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            }

            .brand {
                display: flex;
                align-items: center;
                gap: 10px;
                font-weight: 700;
                font-size: 22px;
            }

            .brand .logo {
                width: 30px;
                height: 30px;
                border-radius: 10px;
                background: #fff;
                color: var(--primary);
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 800;
            }

            .top-actions {
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 10px 16px;
                border-radius: 10px;
                border: none;
                cursor: pointer;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.2s ease;
                background: rgba(255,255,255,0.15);
                color: #fff;
            }

            .btn:hover {
                background: rgba(255,255,255,0.25);
                transform: translateY(-1px);
            }

            .layout {
                display: grid;
                grid-template-columns: 280px 1fr;
                gap: 20px;
                padding: 24px;
                max-width: 1400px;
                margin: 0 auto;
            }

            .sidebar {
                background: var(--card);
                border: 1px solid var(--border);
                border-radius: 14px;
                padding: 20px 18px;
                position: sticky;
                top: 24px;
                height: fit-content;
            }

            .nav-group + .nav-group {
                margin-top: 20px;
                padding-top: 18px;
                border-top: 1px solid var(--border);
            }

            .nav-title {
                font-size: 12px;
                text-transform: uppercase;
                letter-spacing: .5px;
                color: var(--muted);
                font-weight: 600;
                margin-bottom: 10px;
            }

            .side-link {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 12px 12px;
                border-radius: 10px;
                color: var(--text);
                text-decoration: none;
                transition: all 0.2s;
                font-weight: 500;
            }

            .side-link:hover {
                background: #eef2ff;
                color: var(--primary);
            }

            .side-link.active {
                background: linear-gradient(120deg, var(--primary), var(--secondary));
                color: #fff;
                box-shadow: 0 6px 18px rgba(91, 91, 214, 0.25);
            }

            .content {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                gap: 16px;
                flex-wrap: wrap;
            }

            .page-title {
                margin: 0;
                font-size: 28px;
                font-weight: 700;
            }

            .muted {
                color: var(--muted);
                font-size: 14px;
            }

            .card {
                background: var(--card);
                border: 1px solid var(--border);
                border-radius: 14px;
                padding: 20px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            }

            .filters {
                display: grid;
                grid-template-columns: repeat(12, 1fr);
                gap: 14px;
            }

            .filter-field {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }

            .filter-field label {
                font-size: 12px;
                font-weight: 600;
                color: var(--muted);
                text-transform: uppercase;
                letter-spacing: 0.4px;
            }

            .filter-field input,
            .filter-field select {
                border: 1px solid var(--border);
                border-radius: 10px;
                padding: 10px 12px;
                font-size: 14px;
                transition: border 0.2s;
                background: #fff;
            }

            .filter-field input:focus,
            .filter-field select:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(91,91,214,0.12);
            }

            .actions {
                display: flex;
                gap: 10px;
                align-items: flex-end;
            }

            .btn-primary {
                background: var(--accent);
                color: #fff;
            }

            .btn-secondary {
                background: #e5e7eb;
                color: var(--text);
            }

            .btn-primary:hover {
                background: #1d4ed8;
            }

            .btn-secondary:hover {
                background: #d1d5db;
            }

            .table-card {
                padding: 0;
                overflow: hidden;
            }

            .table-header {
                padding: 20px;
                border-bottom: 1px solid var(--border);
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 12px;
            }

            .table-wrapper {
                width: 100%;
                overflow-x: auto;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                min-width: 720px;
            }

            thead {
                background: #f9fafb;
                text-transform: uppercase;
                font-size: 12px;
                letter-spacing: 0.5px;
            }

            th, td {
                padding: 14px 20px;
                text-align: left;
                border-bottom: 1px solid var(--border);
                font-size: 14px;
            }

            tbody tr:hover {
                background: #f8fafc;
            }

            .status {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 6px 12px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
            }

            .status-processing { background: #eef2ff; color: #4338ca; }
            .status-hired { background: #dcfce7; color: #166534; }
            .status-rejected { background: #fee2e2; color: #b91c1c; }
            .status-default { background: #f3f4f6; color: #374151; }

            .empty-state {
                padding: 40px 20px;
                text-align: center;
                color: var(--muted);
            }

            .message {
                padding: 16px;
                margin: 20px;
                border-radius: 12px;
                background: #fee2e2;
                color: #991b1b;
                font-weight: 600;
            }

            .pagination {
                display: flex;
                gap: 10px;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }

            .page-item {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 36px;
                height: 36px;
                padding: 0 12px;
                border-radius: 8px;
                border: 1px solid var(--border);
                color: var(--text);
                text-decoration: none;
                font-weight: 600;
                transition: all 0.2s;
            }

            .page-item:hover {
                border-color: var(--primary);
                color: var(--primary);
            }

            .page-item.active {
                background: var(--primary);
                border-color: var(--primary);
                color: #fff;
                cursor: default;
            }

            .page-item.disabled {
                opacity: 0.4;
                pointer-events: none;
            }

            @media (max-width: 1024px) {
                .layout {
                    grid-template-columns: 1fr;
                }
                .sidebar {
                    position: relative;
                    top: auto;
                }
            }

            @media (max-width: 768px) {
                .topbar {
                    flex-direction: column;
                    gap: 12px;
                    height: auto;
                    padding: 16px;
                }
                .filters {
                    grid-template-columns: 1fr;
                }
                .actions {
                    justify-content: flex-start;
                }
                table {
                    min-width: 600px;
                }
            }
        </style>
    </head>
    <body>
        <div class="topbar">
            <div class="brand">
                <div class="logo">HR</div>
                <div>Candidate Management</div>
            </div>
            <div class="top-actions">
                <a class="btn" href="<%=request.getContextPath()%>/hrstaff">🏠 HR Staff Home</a>
                <a class="btn" href="<%=request.getContextPath()%>/homepage">🌐 Homepage</a>
            </div>
        </div>

        <div class="layout">
            <aside class="sidebar">
                <div class="nav-group">
                    <div class="nav-title">Main</div>
                    <a class="side-link" href="<%=request.getContextPath()%>/hrstaff">🏠 HR Staff Home</a>
                </div>
                <div class="nav-group">
                    <div class="nav-title">Salary & Contracts</div>
                    <a class="side-link" href="<%=request.getContextPath()%>/hrstaff/payroll">💰 Payroll</a>
                    <a class="side-link" href="<%=request.getContextPath()%>/hrstaff/contracts/create">📝 Create Contract</a>
                    <a class="side-link" href="<%=request.getContextPath()%>/hrstaff/contracts">📄 Contracts List</a>
                </div>
                <div class="nav-group">
                    <div class="nav-title">Recruitment</div>
                    <a class="side-link" href="${pageContext.request.contextPath}/postRecruitments">📢 Post Recruitment</a>
                    <a class="side-link active" href="${pageContext.request.contextPath}/candidates">👀 View Candidates</a>
                    
                </div>
            </aside>

            <main class="content">
                <section class="card">
                    <div class="page-header">
                        <div>
                            <h1 class="page-title">Candidate List</h1>
                            <p class="muted">Track and manage the applicants who submitted recruitment forms</p>
                        </div>
                    </div>
                </section>

                <section class="card">
                    <form action="${pageContext.request.contextPath}/candidates" method="GET">
                        <div class="filters">
                            <div class="filter-field" style="grid-column: span 4;">
                                <label>Search by Name</label>
                                <input type="text" name="searchByName" placeholder="Enter candidate name..." value="${fn:escapeXml(param.searchByName)}">
                            </div>
                            <div class="filter-field" style="grid-column: span 3;">
                                <label>Status</label>
                                <select name="filterStatus">
                                    <option value="">All</option>
                                    <option value="processing" <c:if test="${param.filterStatus eq 'processing'}">selected</c:if>>Processing</option>
                                    <option value="hired" <c:if test="${param.filterStatus eq 'hired'}">selected</c:if>>Hired</option>
                                    <option value="rejected" <c:if test="${param.filterStatus eq 'rejected'}">selected</c:if>>Rejected</option>
                                </select>
                            </div>
                            <div class="filter-field" style="grid-column: span 2;">
                                <label>Start Date</label>
                                <input type="date" name="startDate" value="${param.startDate}">
                            </div>
                            <div class="filter-field" style="grid-column: span 2;">
                                <label>End Date</label>
                                <input type="date" name="endDate" value="${param.endDate}">
                            </div>
                            <div class="filter-field actions" style="grid-column: span 12;">
                                <button type="submit" class="btn btn-primary">🔍 Apply Filter</button>
                                <a href="${pageContext.request.contextPath}/candidates" class="btn btn-secondary">✖ Clear</a>
                            </div>
                        </div>
                    </form>
                </section>

                <section class="card table-card">
                    <div class="table-header">
                        <h2 style="margin:0;">Candidate List</h2>
                        <span class="muted">Showing ${guest != null ? fn:length(guest) : 0} candidates on this page</span>
                    </div>
                    <div class="table-wrapper">
                        <c:choose>
                            <c:when test="${empty guest}">
                                <div class="empty-state">
                                    <div style="font-size:42px;">🗃️</div>
                                    <p>No candidates match the current filters.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Full Name</th>
                                            <th>Email</th>
                                            <th>Phone</th>
                                            <th>CV</th>
                                            <th>Applied at</th>
                                            <th>Status</th>
                                            <th>Recruitment</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="g" items="${guest}">
                                            <tr>
                                                <td>#${g.guestId}</td>
                                                <td>${g.fullName}</td>
                                                <td>${g.email}</td>
                                                <td>${g.phone}</td>
                                                <td><a href="${pageContext.request.contextPath}/viewCV?guestId=${g.guestId}" style="color:var(--accent);font-weight:600;text-decoration:none;">View</a></td>
                                                <td>${g.appliedDate}</td>
                                                <td>
                                                    <c:set var="statusKey" value="${fn:toLowerCase(g.status)}"/>
                                                    <span class="status status-${statusKey != null ? statusKey : 'default'}">${g.status}</span>
                                                </td>
                                                <td>${g.recruitmentId}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:if test="${not empty mess}">
                        <div class="message">${mess}</div>
                    </c:if>

                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a class="page-item" href="${pageContext.request.contextPath}/candidates?page=${currentPage - 1}&searchByName=${param.searchByName}&filterStatus=${param.filterStatus}&startDate=${param.startDate}&endDate=${param.endDate}">«</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-item disabled">«</span>
                                </c:otherwise>
                            </c:choose>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${currentPage == i}">
                                        <span class="page-item active">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="page-item" href="${pageContext.request.contextPath}/candidates?page=${i}&searchByName=${param.searchByName}&filterStatus=${param.filterStatus}&startDate=${param.startDate}&endDate=${param.endDate}">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a class="page-item" href="${pageContext.request.contextPath}/candidates?page=${currentPage + 1}&searchByName=${param.searchByName}&filterStatus=${param.filterStatus}&startDate=${param.startDate}&endDate=${param.endDate}">»</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-item disabled">»</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </section>
            </main>
        </div>
    </body>
</html>


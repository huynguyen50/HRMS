<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Post Recruitment</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"/>
        <style>
            :root {
                --primary:#5b5bd6;
                --secondary:#8b5bd6;
                --bg:#f3f4f6;
                --card:#ffffff;
                --border:#e5e7eb;
                --text:#000000;
                --muted:#6b7280;
                --success:#10b981;
                --warning:#f59e0b;
                --danger:#ef4444;
                --accent:#2563eb;
            }

            * { box-sizing: border-box; }

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
                background: linear-gradient(100deg, var(--primary), var(--secondary));
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
            }

            .btn.primary { background: #fff; color: var(--primary); }
            .btn.secondary { background: rgba(255,255,255,0.18); color: #fff; }
            .btn.success { background: var(--success); color: #fff; }
            .btn.warning { background: var(--warning); color: #fff; }
            .btn.danger { background: var(--danger); color: #fff; }

            .btn:hover {
                transform: translateY(-1px);
                box-shadow: 0 6px 16px rgba(37,99,235,0.2);
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

            .side-link, .side-link:visited {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 12px 12px;
                border-radius: 10px;
                color: var(--text) !important;
                text-decoration: none;
                transition: all 0.2s;
                font-weight: 500;
                font-size: 15px;
                white-space: nowrap;
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

            .card {
                background: var(--card);
                border: 1px solid var(--border);
                border-radius: 14px;
                padding: 22px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.08);
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

            .muted { color: var(--muted); font-size: 14px; }

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

            .filter-actions {
                display: flex;
                gap: 10px;
                align-items: flex-end;
            }

            .message {
                padding: 16px;
                border-radius: 12px;
                margin-top: 12px;
                font-weight: 600;
            }

            .message.success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
            .message.error { background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca; }

            .recruitment-list {
                display: flex;
                flex-direction: column;
                gap: 16px;
            }

            .recruitment-card {
                border: 1px solid var(--border);
                border-radius: 14px;
                padding: 20px;
                display: grid;
                grid-template-columns: 1fr auto;
                gap: 20px;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .recruitment-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 24px rgba(15, 23, 42, 0.12);
            }

            .status-pill {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 6px 12px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
            }

            .status-New { background: #e0e7ff; color: #3730a3; }
            .status-Waiting { background: #dbeafe; color: #1d4ed8; }
            .status-Rejected { background: #fee2e2; color: #b91c1c; }
            .status-Applied { background: #dcfce7; color: #15803d; }
            .status-Deleted { background: #f3f4f6; color: #4b5563; }

            .metrics {
                display: flex;
                gap: 16px;
                flex-wrap: wrap;
                font-size: 14px;
                color: var(--muted);
            }

            .card-actions {
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .empty-state {
                padding: 48px 20px;
                text-align: center;
                color: var(--muted);
            }

            .pagination {
                display: flex;
                gap: 10px;
                align-items: center;
                justify-content: center;
                padding-top: 20px;
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
                .layout { grid-template-columns: 1fr; }
                .sidebar { position: relative; top: auto; }
                .recruitment-card { grid-template-columns: 1fr; }
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
                .filter-actions {
                    justify-content: flex-start;
                }
            }
        </style>
    </head>
    <body>
        <div class="topbar">
            <div class="brand">
                <div class="logo">HR</div>
                <div>Recruitment Management</div>
            </div>
            <div class="top-actions">
                <a class="btn secondary" href="<%=request.getContextPath()%>/hrstaff">🏠 HR Staff Home</a>
                <a class="btn success" href="${pageContext.request.contextPath}/detailRecruitmentCreate">➕ Create New</a>
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
                    <a class="side-link active" href="${pageContext.request.contextPath}/postRecruitments">📢 Post Recruitment</a>
                    <a class="side-link" href="${pageContext.request.contextPath}/candidates">👀 View Candidates</a>
                  
                </div>
            </aside>

            <main class="content">
                <section class="card">
                    <div class="page-header">
                        <div>
                            <h1 class="page-title">Quản lý tin tuyển dụng</h1>
                            <p class="muted">Tạo, gửi duyệt và theo dõi trạng thái các tin tuyển dụng</p>
                        </div>
                    </div>
                    <c:if test="${not empty mess}">
                        <div class="message success">${mess}</div>
                    </c:if>
                </section>

                <section class="card">
                    <form action="${pageContext.request.contextPath}/postRecruitments" method="GET">
                        <div class="filters">
                            <div class="filter-field" style="grid-column: span 4;">
                                <label>Search by Title</label>
                                <input type="text" name="searchByTitle" placeholder="Nhập tiêu đề..." value="${fn:escapeXml(param.searchByTitle)}">
                            </div>
                            <div class="filter-field" style="grid-column: span 3;">
                                <label>Status</label>
                                <select name="filterStatus">
                                    <option value="">All</option>
                                    <option value="New" <c:if test="${param.filterStatus eq 'New'}">selected</c:if>>New</option>
                                    <option value="Waiting" <c:if test="${param.filterStatus eq 'Waiting'}">selected</c:if>>Waiting</option>
                                    <option value="Rejected" <c:if test="${param.filterStatus eq 'Rejected'}">selected</c:if>>Rejected</option>
                                    <option value="Applied" <c:if test="${param.filterStatus eq 'Applied'}">selected</c:if>>Applied</option>
                                    <option value="Deleted" <c:if test="${param.filterStatus eq 'Deleted'}">selected</c:if>>Deleted</option>
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
                            <div class="filter-field filter-actions" style="grid-column: span 12;">
                                <button type="submit" class="btn primary">🔍 Apply Filter</button>
                                <a href="${pageContext.request.contextPath}/postRecruitments" class="btn secondary">✖ Clear</a>
                            </div>
                        </div>
                    </form>
                </section>

                <section class="card">
                    <c:choose>
                        <c:when test="${empty recruitment}">
                            <div class="empty-state">
                                <div style="font-size:48px;">📭</div>
                                <p>Không có tin tuyển dụng nào phù hợp với bộ lọc hiện tại.</p>
                                <a class="btn success" href="${pageContext.request.contextPath}/detailRecruitmentCreate">Tạo tin mới</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="recruitment-list">
                                <c:forEach var="rec" items="${recruitment}">
                                    <div class="recruitment-card">
                                        <div>
                                            <h3 style="margin:0 0 10px 0;">${rec.title}</h3>
                                            <div class="metrics">
                                                <span>🗓️ Posted on: <strong>${rec.postedDate}</strong></span>
                                                <span>👥 Applicants: <strong>${rec.applicant}</strong></span>
                                                <span>
                                                    <span class="status-pill status-${rec.status}">
                                                        ${rec.status}
                                                    </span>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="card-actions">
                                            <a class="btn secondary" href="${pageContext.request.contextPath}/detailRecruitment?id=${rec.recruitmentId}">👁️ View</a>
                                            <c:if test="${rec.status ne 'Deleted' and rec.status ne 'Waiting' and rec.status ne 'Applied'}">
                                                <a class="btn success" href="${pageContext.request.contextPath}/postRecruitments?action=send&id=${rec.recruitmentId}" onclick="return confirm('Bạn có chắc chắn muốn gửi tin tuyển dụng này?');">📨 Send</a>
                                                <a class="btn danger" href="${pageContext.request.contextPath}/postRecruitments?action=delete&id=${rec.recruitmentId}" onclick="return confirm('Bạn có chắc chắn muốn xóa tin tuyển dụng này?');">🗑️ Delete</a>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a class="page-item" href="${pageContext.request.contextPath}/postRecruitments?page=${currentPage - 1}&searchByTitle=${param.searchByTitle}&filterStatus=${param.filterStatus}&startDate=${param.startDate}&endDate=${param.endDate}">«</a>
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
                                        <a class="page-item" href="${pageContext.request.contextPath}/postRecruitments?page=${i}&searchByTitle=${param.searchByTitle}&filterStatus=${param.filterStatus}&startDate=${param.startDate}&endDate=${param.endDate}">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a class="page-item" href="${pageContext.request.contextPath}/postRecruitments?page=${currentPage + 1}&searchByTitle=${param.searchByTitle}&filterStatus=${param.filterStatus}&startDate=${param.startDate}&endDate=${param.endDate}">»</a>
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


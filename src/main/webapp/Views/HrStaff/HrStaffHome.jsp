<%-- 
    Document   : HrStaffHome
    Created on : Nov 4, 2025, 9:47:22 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>HR Staff Dashboard</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"/>
        <style>
            :root { --primary:#5b5bd6; --secondary:#8b5bd6; --bg:#f3f4f6; --card:#ffffff; --border:#e5e7eb; --text:#111827; --muted:#6b7280; --success:#10b981; }
            body { background: var(--bg); }
            .topbar { height:64px; display:flex; align-items:center; justify-content:space-between; padding:0 20px; background: linear-gradient(90deg, var(--primary), var(--secondary)); color:#fff; box-shadow: 0 2px 6px rgba(0,0,0,0.08); }
            .brand { display:flex; align-items:center; gap:10px; font-weight:700; font-size:22px; }
            .brand .logo { width:28px; height:28px; background:#fff; color:var(--primary); border-radius:8px; display:flex; align-items:center; justify-content:center; font-weight:800; }
            .top-actions { display:flex; align-items:center; gap:12px; }
            .search { display:flex; align-items:center; gap:8px; background:rgba(234, 236, 239, 0.91); padding:6px 10px; border-radius:999px; }
            .search input { border:none; outline:none; background:transparent; color:#fff; width:280px; }
            .btn { display:inline-block; padding:10px 14px; border-radius:8px; text-decoration:none; color:#fff; background:#2563eb; }
            .btn.secondary { background: var(--success); }

            .container { width:100%; max-width:none; margin:0; padding: 20px; display:grid; grid-template-columns: 280px 1fr; gap:20px; align-items:start; }
            .sidebar { background: var(--card); border:1px solid var(--border); border-radius:12px; padding:14px; position:sticky; top:20px; }
            .side-group { padding:12px 8px; border-top:1px solid var(--border); }
            .side-group:first-of-type { border-top:none; }
            .side-title { font-weight:700; color: var(--muted); font-size:13px; letter-spacing:.5px; text-transform:uppercase; margin-bottom:10px; }
            .side-link { display:flex; align-items:center; gap:10px; padding:12px 10px; margin-bottom:8px; border-radius:10px; color:#111; text-decoration:none; background:#eef2ff; }
            .side-link.neutral { background:#fff; border:1px solid var(--border); }

            .content { display:flex; flex-direction:column; gap:16px; }
            .hero { background: linear-gradient(90deg, var(--primary), var(--secondary)); color:#fff; border-radius:14px; padding:22px; }
            .hero h2 { margin:0 0 6px 0; }
            .hero .muted { color: rgba(255,255,255,0.9); }
            .card { border:1px solid var(--border); border-radius:12px; background:var(--card); padding:16px; }
            .muted { color: var(--muted); font-size:14px; }
            .grid-3 { display:grid; grid-template-columns: repeat(3, 1fr); gap:16px; }
            .metric { border-left:4px solid #6366f1; }
            .metric .value { font-size:38px; font-weight:800; margin:10px 0 6px 0; }
            .metric .caption { color: var(--muted); }
            .filter { display:flex; gap:8px; align-items:center; }
            .input { padding:8px 10px; border:1px solid #d1d5db; border-radius:6px; min-width:100px; background:#fff; }
            table { width: 100%; border-collapse: collapse; }
            th, td { padding: 10px 12px; border-bottom: 1px solid var(--border); text-align: left; }
            th { background: #f9fafb; }
            .empty { color: var(--muted); padding: 12px 0; }
            @media (max-width: 1024px) { .container { grid-template-columns: 1fr; } .sidebar { position:relative; top:auto; } .grid-3 { grid-template-columns: 1fr; } .search input { width: 160px; } }
        </style>
    </head>
    <body>
        <!-- Top Navigation Bar -->
        <div class="topbar">
            <div class="brand">
                <div class="logo">HR</div>
                <div>HR Staff Dashboard</div>
            </div>
            <div class="top-actions">
                <div class="search">
                    <span>🔍</span>
                    <input type="text" placeholder="Search employees, departments..."/>
                </div>
                <a class="btn secondary" href="<%=request.getContextPath()%>/homepage">Homepage</a>
            </div>
        </div>

        <div class="container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <div class="side-group">
                    <div class="side-title">Main</div>
                    <a class="side-link" href="<%=request.getContextPath()%>/hrstaff">🏠 HR Staff Home</a>
                </div>
                <div class="side-group">
                    <div class="side-title">Requests & Approvals</div>
                    <a class="side-link neutral" href="#">✅ Requests & Recommendations</a>
                </div>
                <div class="side-group">
                    <div class="side-title">Salary & Contracts</div>
                    <a class="side-link neutral" href="#">💰 Payroll</a>
                    <a class="side-link neutral" href="<%=request.getContextPath()%>/hrstaff/contracts/create">📝 Create Contract</a>
                    <a class="side-link neutral" href="<%=request.getContextPath()%>/hrstaff/contracts">📄 Contracts List</a>
                </div>
                <div class="side-group">
                    <div class="side-title">Recruitment</div>
                    <a class="side-link neutral" href="${pageContext.request.contextPath}/postRecruitments">📢 Post Recruitment</a>
                    <a class="side-link neutral" href="${pageContext.request.contextPath}/candidates">👀 View Candidates</a>
                    <a class="side-link neutral" href="#">➕ Create Employee</a>
                </div>
            </aside>

            <!-- Content Area -->
            <main class="content">
                <section class="hero">
                    <h2>HR Staff Home</h2>
                    <div class="muted">Welcome to the Human Resource Management System</div>
                </section>

                <section class="grid-3">
                    <div class="card metric">
                        <div class="muted">Total Employees</div>
                        <div class="value"><%= request.getAttribute("totalEmployees") != null ? request.getAttribute("totalEmployees") : 0 %></div>
                        <div class="caption">Active employees in system</div>
                    </div>
                    <div class="card metric" style="border-left-color:#3b82f6;">
                        <div class="muted">Contracts Pending Approval</div>
                        <div class="value"><%= request.getAttribute("pendingContractsCount") != null ? request.getAttribute("pendingContractsCount") : 0 %></div>
                        <div class="caption">Awaiting approval</div>
                    </div>
                    <div class="card metric" style="border-left-color:#22c55e;">
                        <div class="muted">Approved Contracts</div>
                        <div class="value"><%= request.getAttribute("approvedContractsCount") != null ? request.getAttribute("approvedContractsCount") : 0 %></div>
                        <div class="caption">Approved and active</div>
                    </div>
                </section>

                <section class="card">
                    <div style="display:flex; align-items:center; justify-content: space-between; gap:12px; flex-wrap:wrap;">
                        <h3 style="margin:0;">Contracts Expiring Soon</h3>
                        <form class="filter" method="get" action="<%=request.getContextPath()%>/hrstaff">
                            <label for="days" class="muted">In</label>
                            <input class="input" type="number" id="days" name="days" value="<%= request.getAttribute("expiringDays") != null ? request.getAttribute("expiringDays") : 30 %>" min="1"/>
                            <span class="muted">days</span>
                            <button class="btn" type="submit" style="padding:8px 12px;">Filter</button>
                        </form>
                    </div>
                    <div style="margin-top:10px;">
                        <%
                            List expiringContracts = (List) request.getAttribute("expiringContracts");
                            if (expiringContracts == null || expiringContracts.isEmpty()) {
                        %>
                        <div class="empty">No contracts expiring soon.</div>
                        <%
                            } else {
                        %>
                        <table>
                            <thead>
                                <tr>
                                    <th>Employee</th>
                                    <th>Contract Type</th>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Object rowObj : expiringContracts) {
                                        Map row = (Map) rowObj;
                                %>
                                <tr>
                                    <td><%= row.get("employeeName") %></td>
                                    <td><%= row.get("contractType") %></td>
                                    <td><%= row.get("startDate") %></td>
                                    <td><%= row.get("endDate") %></td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                        <%
                            }
                        %>
                    </div>
                </section>
            </main>
        </div>
    </body>
</html>

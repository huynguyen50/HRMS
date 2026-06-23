<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Kiểm tra phiên đăng nhập - trang này dành cho role Dept Manager.
    com.hrm.model.entity.SystemUser currentUser = (com.hrm.model.entity.SystemUser) session.getAttribute("systemUser");
    if (currentUser == null
            || (currentUser.getRoleId() != com.hrm.util.PermissionUtil.ROLE_ADMIN
            && currentUser.getRoleId() != com.hrm.util.PermissionUtil.ROLE_DEPT_MANAGER)) {
        response.sendRedirect(request.getContextPath() + "/Views/Login.jsp");
        return;
    }

    String userName = currentUser.getUsername();
    String userPosition = "Trưởng phòng";
    if (currentUser.getEmployeeId() != null) {
        try {
            com.hrm.dao.EmployeeDAO employeeDAO = new com.hrm.dao.EmployeeDAO();
            com.hrm.model.entity.Employee employee = employeeDAO.getById(currentUser.getEmployeeId());
            if (employee != null) {
                if (employee.getFullName() != null) {
                    userName = employee.getFullName();
                }
                if (employee.getPosition() != null) {
                    userPosition = employee.getPosition();
                }
            }
        } catch (Exception e) {
            // Dùng thông tin tài khoản nếu chưa có hồ sơ nhân viên.
        }
    }
    request.setAttribute("userName", userName);
    request.setAttribute("userPosition", userPosition);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BetterHR - Tổng quan phòng ban</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        :root {
            --bh-primary: #00482f;
            --bh-primary-strong: #006241;
            --bh-secondary: #00754a;
            --bh-soft-green: #dff6ea;
            --bh-mint: #97f6c0;
            --bh-gold: #cba258;
            --bh-error: #c82014;
            --bh-error-soft: #fdebea;
            --bh-canvas: #edebe9;
            --bh-surface: #fbf9f4;
            --bh-card: #ffffff;
            --bh-border: #d8d1c7;
            --bh-border-soft: #e7e1d8;
            --bh-text: #1b1c19;
            --bh-muted: #647068;
            --bh-shadow: 0 1px 2px rgba(0, 0, 0, 0.08), 0 14px 30px rgba(30, 57, 50, 0.08);
        }

        * {
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: Inter, "Segoe UI", Arial, sans-serif;
            background: var(--bh-canvas);
            color: var(--bh-text);
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        button,
        input,
        select {
            font-family: inherit;
        }

        .dept-shell {
            min-height: 100vh;
            display: grid;
            grid-template-columns: 270px minmax(0, 1fr);
        }

        .sidebar {
            position: sticky;
            top: 0;
            height: 100vh;
            display: flex;
            flex-direction: column;
            padding: 24px 18px;
            background: var(--bh-primary);
            color: #ffffff;
            z-index: 20;
        }

        .brand {
            padding: 2px 4px 28px;
        }

        .brand strong {
            display: block;
            font-size: 20px;
            font-weight: 800;
        }

        .brand span {
            display: block;
            margin-top: 6px;
            color: rgba(255, 255, 255, 0.68);
            font-size: 12px;
            font-weight: 600;
        }

        .nav {
            display: grid;
            gap: 8px;
        }

        .nav-link {
            min-height: 46px;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 11px 13px;
            border-radius: 10px;
            color: rgba(255, 255, 255, 0.78);
            font-size: 14px;
            font-weight: 700;
            transition: background 0.18s ease, color 0.18s ease, transform 0.18s ease;
        }

        .nav-link i {
            width: 18px;
            text-align: center;
        }

        .nav-link:hover {
            background: rgba(255, 255, 255, 0.10);
            color: #ffffff;
            transform: translateX(2px);
        }

        .nav-link.active {
            background: var(--bh-mint);
            color: var(--bh-primary);
        }

        .manager-card {
            margin-top: auto;
            padding-top: 22px;
            border-top: 1px solid rgba(255, 255, 255, 0.12);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .manager-avatar {
            width: 42px;
            height: 42px;
            display: grid;
            place-items: center;
            border-radius: 999px;
            background: var(--bh-mint);
            color: var(--bh-primary);
            font-size: 18px;
        }

        .manager-card strong {
            display: block;
            font-size: 13px;
            line-height: 1.35;
        }

        .manager-card span {
            display: block;
            max-width: 158px;
            margin-top: 2px;
            color: rgba(255, 255, 255, 0.64);
            font-size: 12px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .main {
            min-width: 0;
            display: flex;
            flex-direction: column;
            background: var(--bh-canvas);
        }

        .topbar {
            position: sticky;
            top: 0;
            min-height: 72px;
            z-index: 10;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            padding: 14px 32px;
            background: rgba(251, 249, 244, 0.94);
            border-bottom: 1px solid var(--bh-border-soft);
            backdrop-filter: blur(18px);
        }

        .topbar-title h1 {
            margin: 0;
            color: var(--bh-primary);
            font-size: 18px;
            font-weight: 800;
        }

        .topbar-title p {
            margin: 4px 0 0;
            color: var(--bh-muted);
            font-size: 13px;
            font-weight: 600;
        }

        .topbar-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .search-box {
            width: min(330px, 35vw);
            min-height: 42px;
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 0 14px;
            border: 1px solid var(--bh-border-soft);
            border-radius: 999px;
            background: #f7f4ee;
            color: var(--bh-muted);
        }

        .search-box input {
            width: 100%;
            border: 0;
            outline: 0;
            background: transparent;
            color: var(--bh-text);
            font-size: 14px;
        }

        .primary-button,
        .icon-button {
            border: 0;
            cursor: pointer;
        }

        .primary-button {
            min-height: 42px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            padding: 0 18px;
            border-radius: 999px;
            background: var(--bh-primary);
            color: #ffffff;
            font-size: 14px;
            font-weight: 800;
            box-shadow: 0 12px 22px rgba(0, 72, 47, 0.20);
        }

        .icon-button {
            position: relative;
            width: 42px;
            height: 42px;
            display: grid;
            place-items: center;
            border: 1px solid var(--bh-border-soft);
            border-radius: 999px;
            background: #ffffff;
            color: var(--bh-primary);
        }

        .icon-button .dot {
            position: absolute;
            top: 8px;
            right: 9px;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--bh-error);
        }

        .header-avatar {
            width: 42px;
            height: 42px;
            display: grid;
            place-items: center;
            border-radius: 999px;
            background: var(--bh-soft-green);
            color: var(--bh-primary);
            font-weight: 800;
        }

        .content {
            width: min(100%, 1280px);
            margin: 0 auto;
            padding: 24px 32px 34px;
        }

        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(6, minmax(0, 1fr));
            gap: 14px;
            margin-bottom: 20px;
        }

        .kpi-card {
            min-height: 126px;
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 18px;
            border: 1px solid var(--bh-border);
            border-radius: 12px;
            background: var(--bh-card);
            box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
        }

        .kpi-icon {
            width: 42px;
            height: 42px;
            flex: 0 0 auto;
            display: grid;
            place-items: center;
            border-radius: 11px;
            background: var(--bh-soft-green);
            color: var(--bh-primary);
        }

        .kpi-icon.gold {
            background: rgba(203, 162, 88, 0.14);
            color: var(--bh-gold);
        }

        .kpi-icon.red {
            background: var(--bh-error-soft);
            color: var(--bh-error);
        }

        .kpi-icon.dark {
            background: var(--bh-primary);
            color: #ffffff;
        }

        .kpi-card span {
            display: block;
            color: var(--bh-muted);
            font-size: 12px;
            line-height: 1.45;
            font-weight: 700;
        }

        .kpi-card strong {
            display: block;
            margin-top: 4px;
            color: var(--bh-primary);
            font-size: 23px;
            line-height: 1;
            font-weight: 800;
        }

        .kpi-card strong.red {
            color: var(--bh-error);
        }

        .kpi-card strong.gold {
            color: var(--bh-gold);
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 320px;
            gap: 22px;
            align-items: start;
        }

        .main-column,
        .side-column {
            display: grid;
            gap: 20px;
        }

        .panel {
            border: 1px solid var(--bh-border);
            border-radius: 12px;
            background: var(--bh-card);
            box-shadow: var(--bh-shadow);
            overflow: hidden;
        }

        .panel-inner {
            padding: 22px;
        }

        .panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 18px;
        }

        .panel-title {
            margin: 0;
            color: var(--bh-primary);
            font-size: 18px;
            font-weight: 800;
        }

        .panel-action {
            min-height: 34px;
            padding: 0 12px;
            border: 1px solid var(--bh-border-soft);
            border-radius: 999px;
            background: #f7f4ee;
            color: var(--bh-muted);
            font-size: 12px;
            font-weight: 800;
        }

        .bar-chart {
            height: 250px;
            display: grid;
            grid-template-columns: repeat(5, minmax(0, 1fr));
            align-items: end;
            gap: 18px;
            padding: 18px 10px 0;
            border-radius: 10px;
            background:
                linear-gradient(to top, rgba(0, 0, 0, 0.06) 1px, transparent 1px) 0 0 / 100% 25%,
                #ffffff;
        }

        .bar-item {
            display: grid;
            gap: 10px;
            align-items: end;
            height: 100%;
            text-align: center;
            color: var(--bh-muted);
            font-size: 12px;
            font-weight: 700;
        }

        .bar {
            width: 100%;
            min-height: 24px;
            border-radius: 10px 10px 3px 3px;
            background: var(--bh-primary);
            box-shadow: inset 0 8px 18px rgba(255, 255, 255, 0.12);
        }

        .staff-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .staff-table th,
        .staff-table td {
            padding: 13px 12px;
            border-bottom: 1px solid var(--bh-border-soft);
            text-align: left;
        }

        .staff-table th {
            background: #f2f0eb;
            color: var(--bh-primary);
            font-size: 12px;
            font-weight: 800;
        }

        .staff-table td {
            color: var(--bh-text);
        }

        .mini-progress {
            width: 84px;
            height: 7px;
            border-radius: 999px;
            background: #cfd8d1;
            overflow: hidden;
        }

        .mini-progress span {
            display: block;
            height: 100%;
            border-radius: inherit;
            background: var(--bh-primary);
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 28px;
            padding: 0 10px;
            border-radius: 999px;
            background: var(--bh-soft-green);
            color: var(--bh-secondary);
            font-size: 12px;
            font-weight: 800;
        }

        .status-pill.gold {
            background: rgba(203, 162, 88, 0.18);
            color: #8b6422;
        }

        .donut-wrap {
            display: grid;
            place-items: center;
            padding: 4px 0 16px;
        }

        .donut {
            position: relative;
            width: 174px;
            height: 174px;
            border-radius: 50%;
            background: conic-gradient(var(--bh-primary) 0 78%, var(--bh-gold) 78% 92%, var(--bh-error) 92% 100%);
        }

        .donut::after {
            content: "";
            position: absolute;
            inset: 26px;
            border-radius: inherit;
            background: var(--bh-card);
        }

        .donut-center {
            position: absolute;
            inset: 0;
            z-index: 1;
            display: grid;
            place-items: center;
            text-align: center;
            color: var(--bh-muted);
            font-size: 12px;
            font-weight: 700;
        }

        .donut-center strong {
            display: block;
            color: var(--bh-primary);
            font-size: 24px;
            font-weight: 800;
        }

        .legend {
            display: grid;
            gap: 12px;
        }

        .legend-row {
            display: flex;
            justify-content: space-between;
            gap: 16px;
            font-size: 13px;
            font-weight: 700;
        }

        .legend-label {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--bh-muted);
        }

        .legend-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: var(--bh-primary);
        }

        .legend-dot.gold {
            background: var(--bh-gold);
        }

        .legend-dot.red {
            background: var(--bh-error);
        }

        .meeting-list,
        .approval-list,
        .kanban-grid {
            display: grid;
            gap: 12px;
        }

        .meeting-item {
            display: grid;
            grid-template-columns: 58px minmax(0, 1fr);
            gap: 12px;
            padding: 12px;
            border-radius: 10px;
            background: #f7f4ee;
        }

        .meeting-time {
            display: grid;
            place-items: center;
            min-height: 50px;
            border-radius: 9px;
            background: var(--bh-soft-green);
            color: var(--bh-primary);
            font-size: 12px;
            font-weight: 800;
        }

        .meeting-item strong,
        .approval-item strong,
        .task-card strong {
            display: block;
            color: var(--bh-primary);
            font-size: 13px;
            line-height: 1.4;
        }

        .meeting-item span,
        .approval-item span,
        .task-card span {
            display: block;
            margin-top: 4px;
            color: var(--bh-muted);
            font-size: 12px;
            line-height: 1.4;
        }

        .kanban-grid {
            grid-template-columns: repeat(4, minmax(0, 1fr));
        }

        .kanban-column {
            min-height: 180px;
            padding: 14px;
            border-radius: 12px;
            background: #f7f4ee;
        }

        .kanban-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            color: var(--bh-muted);
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .task-card {
            padding: 14px;
            border: 1px solid var(--bh-border-soft);
            border-radius: 10px;
            background: #ffffff;
        }

        .task-label {
            display: inline-flex;
            margin-bottom: 10px;
            padding: 3px 8px;
            border-radius: 999px;
            background: var(--bh-error-soft);
            color: var(--bh-error);
            font-size: 10px;
            font-weight: 800;
        }

        .task-label.medium {
            background: var(--bh-soft-green);
            color: var(--bh-secondary);
        }

        .task-label.low {
            background: rgba(203, 162, 88, 0.16);
            color: #8b6422;
        }

        .approval-item {
            display: grid;
            grid-template-columns: 42px minmax(0, 1fr) auto;
            gap: 12px;
            align-items: center;
            padding: 13px;
            border: 1px solid var(--bh-border-soft);
            border-radius: 10px;
            background: #ffffff;
        }

        .approval-avatar {
            width: 40px;
            height: 40px;
            display: grid;
            place-items: center;
            border-radius: 999px;
            background: var(--bh-soft-green);
            color: var(--bh-primary);
        }

        .approval-actions {
            display: flex;
            gap: 8px;
        }

        .circle-action {
            width: 32px;
            height: 32px;
            display: grid;
            place-items: center;
            border: 0;
            border-radius: 999px;
            background: var(--bh-soft-green);
            color: var(--bh-secondary);
            cursor: pointer;
        }

        .circle-action.reject {
            background: var(--bh-error-soft);
            color: var(--bh-error);
        }

        .radar-box {
            min-height: 260px;
            display: grid;
            place-items: center;
            border-radius: 12px;
            background: #f7f4ee;
        }

        .radar-box svg {
            width: min(280px, 100%);
            height: auto;
        }

        .footer-space {
            height: 18px;
        }

        @media (max-width: 1180px) {
            .dept-shell {
                grid-template-columns: 1fr;
            }

            .sidebar {
                position: static;
                height: auto;
            }

            .nav {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }

            .manager-card {
                margin-top: 20px;
            }

            .kpi-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }

            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 820px) {
            .topbar {
                align-items: stretch;
                flex-direction: column;
            }

            .topbar-actions {
                flex-wrap: wrap;
            }

            .search-box {
                width: 100%;
            }

            .kpi-grid,
            .kanban-grid,
            .nav {
                grid-template-columns: 1fr;
            }

            .content,
            .topbar {
                padding-inline: 18px;
            }
        }
    </style>
</head>
<body>
    <div class="dept-shell">
        <aside class="sidebar">
            <a class="brand" href="${pageContext.request.contextPath}/homepage">
                <strong>BetterHR</strong>
                <span>Hệ thống HRM nội bộ</span>
            </a>

            <nav class="nav" aria-label="Điều hướng trưởng phòng">
                <a class="nav-link active" href="${pageContext.request.contextPath}/dept?action=dashboard">
                    <i class="fa-solid fa-users-gear"></i>
                    <span>Tổng quan nhóm</span>
                </a>
                <a class="nav-link" href="#staff">
                    <i class="fa-solid fa-id-badge"></i>
                    <span>Nhân viên phòng ban</span>
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/taskManager">
                    <i class="fa-solid fa-list-check"></i>
                    <span>Quản lý công việc</span>
                </a>
                <a class="nav-link" href="#meetings">
                    <i class="fa-solid fa-calendar-days"></i>
                    <span>Lịch nhóm</span>
                </a>
                <a class="nav-link" href="#approvals">
                    <i class="fa-solid fa-calendar-xmark"></i>
                    <span>Yêu cầu nghỉ phép</span>
                </a>
                <a class="nav-link" href="#performance">
                    <i class="fa-solid fa-chart-line"></i>
                    <span>Đánh giá hiệu suất</span>
                </a>
                <a class="nav-link" href="#report">
                    <i class="fa-solid fa-square-poll-vertical"></i>
                    <span>Báo cáo phòng ban</span>
                </a>
            </nav>

            <div class="manager-card">
                <div class="manager-avatar">
                    <i class="fa-solid fa-user-tie"></i>
                </div>
                <div>
                    <strong>${userName}</strong>
                    <span>${userPosition}</span>
                </div>
            </div>
        </aside>

        <main class="main">
            <header class="topbar">
                <div class="topbar-title">
                    <h1>Chào mừng, ${userName}</h1>
                    <p>${departmentName != null ? departmentName : 'Phòng ban'} · Không gian quản lý đội nhóm</p>
                </div>

                <div class="topbar-actions">
                    <label class="search-box">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="search" placeholder="Tìm kiếm nhanh..." aria-label="Tìm kiếm nhanh">
                    </label>
                    <a class="primary-button" href="${pageContext.request.contextPath}/postTask">
                        <i class="fa-solid fa-plus"></i>
                        <span>Tạo công việc mới</span>
                    </a>
                    <button class="icon-button" type="button" aria-label="Thông báo">
                        <i class="fa-solid fa-bell"></i>
                        <span class="dot"></span>
                    </button>
                    <a class="icon-button" href="${pageContext.request.contextPath}/logout" aria-label="Đăng xuất">
                        <i class="fa-solid fa-right-from-bracket"></i>
                    </a>
                    <div class="header-avatar" title="${userName}">
                        <i class="fa-solid fa-user"></i>
                    </div>
                </div>
            </header>

            <section class="content">
                <div class="kpi-grid">
                    <article class="kpi-card">
                        <div class="kpi-icon"><i class="fa-solid fa-people-group"></i></div>
                        <div>
                            <span>Tổng nhân viên</span>
                            <strong>${totalEmployees != null ? totalEmployees : 0}</strong>
                        </div>
                    </article>
                    <article class="kpi-card">
                        <div class="kpi-icon"><i class="fa-solid fa-clipboard-check"></i></div>
                        <div>
                            <span>Đang thực hiện</span>
                            <strong>12</strong>
                        </div>
                    </article>
                    <article class="kpi-card">
                        <div class="kpi-icon red"><i class="fa-solid fa-triangle-exclamation"></i></div>
                        <div>
                            <span>Quá hạn</span>
                            <strong class="red">2</strong>
                        </div>
                    </article>
                    <article class="kpi-card">
                        <div class="kpi-icon gold"><i class="fa-solid fa-file-circle-question"></i></div>
                        <div>
                            <span>Chờ duyệt phép</span>
                            <strong class="gold">3</strong>
                        </div>
                    </article>
                    <article class="kpi-card">
                        <div class="kpi-icon"><i class="fa-solid fa-calendar-day"></i></div>
                        <div>
                            <span>Họp hôm nay</span>
                            <strong>4</strong>
                        </div>
                    </article>
                    <article class="kpi-card">
                        <div class="kpi-icon dark"><i class="fa-solid fa-arrow-trend-up"></i></div>
                        <div>
                            <span>Hiệu suất</span>
                            <strong>95%</strong>
                        </div>
                    </article>
                </div>

                <div class="dashboard-grid">
                    <div class="main-column">
                        <section class="panel" id="report">
                            <div class="panel-inner">
                                <div class="panel-header">
                                    <h2 class="panel-title">Tiến độ hoàn thành công việc</h2>
                                    <select class="panel-action" aria-label="Khoảng thời gian">
                                        <option>Tuần này</option>
                                        <option>Tháng này</option>
                                    </select>
                                </div>
                                <div class="bar-chart" aria-label="Biểu đồ tiến độ công việc">
                                    <div class="bar-item">
                                        <div class="bar" style="height: 42%;"></div>
                                        <span>Thứ 2</span>
                                    </div>
                                    <div class="bar-item">
                                        <div class="bar" style="height: 58%;"></div>
                                        <span>Thứ 3</span>
                                    </div>
                                    <div class="bar-item">
                                        <div class="bar" style="height: 88%;"></div>
                                        <span>Thứ 4</span>
                                    </div>
                                    <div class="bar-item">
                                        <div class="bar" style="height: 72%;"></div>
                                        <span>Thứ 5</span>
                                    </div>
                                    <div class="bar-item">
                                        <div class="bar" style="height: 52%;"></div>
                                        <span>Thứ 6</span>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section class="panel" id="staff">
                            <div class="panel-inner">
                                <div class="panel-header">
                                    <h2 class="panel-title">Nhân viên phòng ban</h2>
                                    <a class="panel-action" href="${pageContext.request.contextPath}/taskManager">Xem công việc</a>
                                </div>
                                <div style="overflow-x:auto;">
                                    <table class="staff-table">
                                        <thead>
                                            <tr>
                                                <th>Mã NV</th>
                                                <th>Họ tên</th>
                                                <th>Chức vụ</th>
                                                <th>Hiệu suất</th>
                                                <th>Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>NV001</td>
                                                <td>Lê Thị Mai</td>
                                                <td>UI Designer</td>
                                                <td><div class="mini-progress"><span style="width: 85%"></span></div></td>
                                                <td><span class="status-pill">Đang làm</span></td>
                                            </tr>
                                            <tr>
                                                <td>NV002</td>
                                                <td>Trần Hoàng Nam</td>
                                                <td>DevOps Engineer</td>
                                                <td><div class="mini-progress"><span style="width: 92%"></span></div></td>
                                                <td><span class="status-pill">Đang làm</span></td>
                                            </tr>
                                            <tr>
                                                <td>NV005</td>
                                                <td>Phạm Anh Tuấn</td>
                                                <td>QA Tester</td>
                                                <td><div class="mini-progress"><span style="width: 45%"></span></div></td>
                                                <td><span class="status-pill gold">Nghỉ phép</span></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </section>

                        <section class="panel">
                            <div class="panel-inner">
                                <div class="panel-header">
                                    <h2 class="panel-title">Quản lý công việc</h2>
                                    <a class="panel-action" href="${pageContext.request.contextPath}/taskManager">Mở danh sách</a>
                                </div>
                                <div class="kanban-grid">
                                    <div class="kanban-column">
                                        <div class="kanban-title"><span>Cần làm</span><span>4</span></div>
                                        <article class="task-card">
                                            <span class="task-label">Cao</span>
                                            <strong>Thiết kế UI cho module nghỉ phép</strong>
                                            <span>Hạn: 25/08</span>
                                        </article>
                                    </div>
                                    <div class="kanban-column">
                                        <div class="kanban-title"><span>Đang làm</span><span>3</span></div>
                                        <article class="task-card">
                                            <span class="task-label medium">Trung bình</span>
                                            <strong>Sửa lỗi hiệu suất trang chủ</strong>
                                            <span>Tiến độ: 65%</span>
                                        </article>
                                    </div>
                                    <div class="kanban-column">
                                        <div class="kanban-title"><span>Chờ duyệt</span><span>2</span></div>
                                        <article class="task-card">
                                            <span class="task-label low">Thấp</span>
                                            <strong>Cập nhật tài liệu API v2.0</strong>
                                            <span>Hạn: hôm nay</span>
                                        </article>
                                    </div>
                                    <div class="kanban-column">
                                        <div class="kanban-title"><span>Hoàn thành</span><span>8</span></div>
                                        <article class="task-card">
                                            <span class="task-label medium">Xong</span>
                                            <strong>Họp định hướng quý</strong>
                                            <span>Đã nghiệm thu</span>
                                        </article>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section class="panel" id="performance">
                            <div class="panel-inner">
                                <h2 class="panel-title">Đánh giá năng lực phòng ban</h2>
                                <div class="radar-box" style="margin-top: 18px;">
                                    <svg viewBox="0 0 220 220" role="img" aria-label="Biểu đồ năng lực phòng ban">
                                        <polygon points="110,18 196,80 164,190 56,190 24,80" fill="none" stroke="#d8d1c7" stroke-width="1.5"></polygon>
                                        <polygon points="110,58 158,94 140,154 80,154 62,94" fill="none" stroke="#d8d1c7" stroke-width="1.5"></polygon>
                                        <line x1="110" y1="110" x2="110" y2="18" stroke="#d8d1c7"></line>
                                        <line x1="110" y1="110" x2="196" y2="80" stroke="#d8d1c7"></line>
                                        <line x1="110" y1="110" x2="164" y2="190" stroke="#d8d1c7"></line>
                                        <line x1="110" y1="110" x2="56" y2="190" stroke="#d8d1c7"></line>
                                        <line x1="110" y1="110" x2="24" y2="80" stroke="#d8d1c7"></line>
                                        <polygon points="110,42 174,88 146,172 68,160 44,84" fill="rgba(0, 72, 47, 0.18)" stroke="#00482f" stroke-width="3"></polygon>
                                        <text x="110" y="12" text-anchor="middle" font-size="10" fill="#647068" font-weight="800">Kỹ thuật</text>
                                        <text x="208" y="82" text-anchor="start" font-size="10" fill="#647068" font-weight="800">Thái độ</text>
                                        <text x="166" y="208" text-anchor="middle" font-size="10" fill="#647068" font-weight="800">Quy trình</text>
                                        <text x="54" y="208" text-anchor="middle" font-size="10" fill="#647068" font-weight="800">Sáng tạo</text>
                                        <text x="12" y="82" text-anchor="end" font-size="10" fill="#647068" font-weight="800">Tiến độ</text>
                                    </svg>
                                </div>
                            </div>
                        </section>
                    </div>

                    <aside class="side-column">
                        <section class="panel">
                            <div class="panel-inner">
                                <h2 class="panel-title">Trạng thái nhân viên</h2>
                                <div class="donut-wrap">
                                    <div class="donut">
                                        <div class="donut-center">
                                            <div>
                                                <strong>${totalEmployees != null ? totalEmployees : 0}</strong>
                                                Tổng số
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="legend">
                                    <div class="legend-row">
                                        <span class="legend-label"><i class="legend-dot"></i>Đang làm việc</span>
                                        <strong>${activeEmployees != null ? activeEmployees : 0}</strong>
                                    </div>
                                    <div class="legend-row">
                                        <span class="legend-label"><i class="legend-dot gold"></i>Nghỉ phép</span>
                                        <strong>2</strong>
                                    </div>
                                    <div class="legend-row">
                                        <span class="legend-label"><i class="legend-dot red"></i>Vắng mặt</span>
                                        <strong>1</strong>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section class="panel" id="meetings">
                            <div class="panel-inner">
                                <div class="panel-header">
                                    <h2 class="panel-title">Cuộc họp sắp tới</h2>
                                    <button class="panel-action" type="button">...</button>
                                </div>
                                <div class="meeting-list">
                                    <article class="meeting-item">
                                        <div class="meeting-time">14:00</div>
                                        <div>
                                            <strong>Họp nhanh hằng ngày</strong>
                                            <span>Phòng họp Alpha</span>
                                        </div>
                                    </article>
                                    <article class="meeting-item">
                                        <div class="meeting-time">16:30</div>
                                        <div>
                                            <strong>Đánh giá Sprint 24</strong>
                                            <span>Google Meet</span>
                                        </div>
                                    </article>
                                </div>
                            </div>
                        </section>

                        <section class="panel" id="approvals">
                            <div class="panel-inner">
                                <h2 class="panel-title">Đơn nghỉ phép chờ duyệt</h2>
                                <div class="approval-list" style="margin-top: 16px;">
                                    <article class="approval-item">
                                        <div class="approval-avatar"><i class="fa-solid fa-user"></i></div>
                                        <div>
                                            <strong>Nguyễn Thùy Linh</strong>
                                            <span>Nghỉ ốm · 23/08 - 24/08</span>
                                        </div>
                                        <div class="approval-actions">
                                            <button class="circle-action reject" type="button"><i class="fa-solid fa-xmark"></i></button>
                                            <button class="circle-action" type="button"><i class="fa-solid fa-check"></i></button>
                                        </div>
                                    </article>
                                    <article class="approval-item">
                                        <div class="approval-avatar"><i class="fa-solid fa-user"></i></div>
                                        <div>
                                            <strong>Đặng Văn Khoa</strong>
                                            <span>Việc cá nhân · hôm nay</span>
                                        </div>
                                        <div class="approval-actions">
                                            <button class="circle-action reject" type="button"><i class="fa-solid fa-xmark"></i></button>
                                            <button class="circle-action" type="button"><i class="fa-solid fa-check"></i></button>
                                        </div>
                                    </article>
                                </div>
                            </div>
                        </section>
                    </aside>
                </div>

                <div class="footer-space"></div>
            </section>
        </main>
    </div>
</body>
</html>

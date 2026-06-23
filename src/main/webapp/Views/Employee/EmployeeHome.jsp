<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BetterHR - Bảng điều khiển nhân viên</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        :root {
            --bh-primary: #006241;
            --bh-primary-dark: #00482f;
            --bh-primary-soft: #dff6ea;
            --bh-accent: #00754a;
            --bh-gold: #cba258;
            --bh-canvas: #f2f0eb;
            --bh-surface: #fbf9f4;
            --bh-card: #ffffff;
            --bh-border: #d8d1c7;
            --bh-muted-border: #e7e1d8;
            --bh-text: #1b1c19;
            --bh-muted: #637067;
            --bh-danger: #c82014;
            --bh-danger-soft: #fdebea;
            --bh-shadow: 0 1px 2px rgba(0, 0, 0, 0.08), 0 14px 32px rgba(30, 57, 50, 0.08);
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
        input {
            font-family: inherit;
        }

        .employee-shell {
            min-height: 100vh;
            display: grid;
            grid-template-columns: 276px minmax(0, 1fr);
        }

        .employee-sidebar {
            position: sticky;
            top: 0;
            height: 100vh;
            display: flex;
            flex-direction: column;
            gap: 26px;
            padding: 22px 18px;
            background: var(--bh-primary-dark);
            color: #ffffff;
            box-shadow: 8px 0 28px rgba(0, 72, 47, 0.16);
            z-index: 20;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 4px 4px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.12);
        }

        .brand-mark {
            width: 44px;
            height: 44px;
            display: grid;
            place-items: center;
            border-radius: 12px;
            background: rgba(162, 243, 200, 0.16);
            color: #a2f3c8;
            font-weight: 800;
            font-size: 18px;
        }

        .brand strong {
            display: block;
            font-size: 20px;
            line-height: 1.1;
        }

        .brand span {
            display: block;
            margin-top: 3px;
            color: rgba(255, 255, 255, 0.68);
            font-size: 12px;
        }

        .side-nav {
            display: grid;
            gap: 7px;
        }

        .nav-section-label {
            margin: 22px 12px 8px;
            color: rgba(255, 255, 255, 0.54);
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            min-height: 44px;
            padding: 11px 13px;
            border-radius: 12px;
            color: rgba(255, 255, 255, 0.78);
            font-size: 14px;
            font-weight: 700;
            transition: background 0.18s ease, color 0.18s ease, transform 0.18s ease;
        }

        .nav-item i {
            width: 18px;
            text-align: center;
        }

        .nav-item:hover {
            background: rgba(255, 255, 255, 0.10);
            color: #ffffff;
            transform: translateX(2px);
        }

        .nav-item.active {
            background: #d8f5e3;
            color: var(--bh-primary-dark);
        }

        .sidebar-bottom {
            margin-top: auto;
            display: grid;
            gap: 7px;
            padding-top: 18px;
            border-top: 1px solid rgba(255, 255, 255, 0.12);
        }

        .employee-main {
            min-width: 0;
            display: flex;
            flex-direction: column;
            background:
                radial-gradient(circle at 88% 8%, rgba(162, 243, 200, 0.22), transparent 34%),
                var(--bh-surface);
        }

        .topbar {
            position: sticky;
            top: 0;
            z-index: 10;
            min-height: 74px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            padding: 14px clamp(20px, 4vw, 44px);
            background: rgba(251, 249, 244, 0.92);
            border-bottom: 1px solid var(--bh-muted-border);
            backdrop-filter: blur(18px);
        }

        .search-box {
            width: min(390px, 42vw);
            display: flex;
            align-items: center;
            gap: 10px;
            min-height: 46px;
            padding: 0 16px;
            border: 1px solid var(--bh-muted-border);
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

        .topbar-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .icon-button {
            position: relative;
            width: 44px;
            height: 44px;
            display: grid;
            place-items: center;
            border: 1px solid var(--bh-muted-border);
            border-radius: 999px;
            background: #ffffff;
            color: var(--bh-primary-dark);
            box-shadow: 0 8px 20px rgba(30, 57, 50, 0.06);
        }

        .icon-button .badge {
            position: absolute;
            top: -6px;
            right: -4px;
            min-width: 18px;
            height: 18px;
            padding: 0 5px;
            display: grid;
            place-items: center;
            border-radius: 999px;
            background: var(--bh-danger);
            color: #ffffff;
            font-size: 11px;
            font-weight: 800;
        }

        .user-chip {
            display: flex;
            align-items: center;
            gap: 10px;
            min-height: 48px;
            padding: 6px 12px 6px 7px;
            border: 1px solid var(--bh-border);
            border-radius: 999px;
            background: #ffffff;
            box-shadow: 0 8px 20px rgba(30, 57, 50, 0.06);
        }

        .avatar {
            width: 36px;
            height: 36px;
            display: grid;
            place-items: center;
            overflow: hidden;
            border-radius: 999px;
            background: var(--bh-primary-soft);
            color: var(--bh-primary);
            font-weight: 800;
        }

        .avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .home-pill {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            min-height: 46px;
            padding: 0 18px;
            border: 1px solid var(--bh-border);
            border-radius: 999px;
            background: #ffffff;
            color: var(--bh-primary-dark);
            font-weight: 800;
            box-shadow: 0 8px 20px rgba(30, 57, 50, 0.06);
        }

        .content {
            width: min(100%, 1360px);
            margin: 0 auto;
            padding: 34px clamp(20px, 4vw, 44px) 28px;
        }

        .welcome-row {
            display: flex;
            align-items: end;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 22px;
        }

        .eyebrow {
            margin: 0 0 6px;
            color: var(--bh-muted);
            font-size: 13px;
            font-weight: 700;
        }

        .welcome-title {
            margin: 0;
            color: var(--bh-primary-dark);
            font-size: clamp(28px, 4vw, 42px);
            line-height: 1.08;
            font-weight: 800;
        }

        .welcome-note {
            margin: 10px 0 0;
            color: var(--bh-muted);
            font-size: 15px;
        }

        .primary-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            min-height: 46px;
            padding: 0 20px;
            border: 0;
            border-radius: 999px;
            background: var(--bh-accent);
            color: #ffffff;
            font-weight: 800;
            cursor: pointer;
            box-shadow: 0 12px 22px rgba(0, 117, 74, 0.22);
        }

        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(5, minmax(0, 1fr));
            gap: 14px;
            margin-bottom: 26px;
        }

        .kpi-card {
            min-height: 126px;
            padding: 18px;
            border: 1px solid var(--bh-border);
            border-radius: 14px;
            background: var(--bh-card);
            box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
        }

        .kpi-card.dark {
            background: var(--bh-primary-dark);
            color: #ffffff;
            border-color: var(--bh-primary-dark);
        }

        .kpi-label {
            min-height: 34px;
            margin: 0 0 12px;
            color: var(--bh-muted);
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.06em;
            text-transform: uppercase;
        }

        .kpi-card.dark .kpi-label {
            color: rgba(255, 255, 255, 0.72);
        }

        .kpi-value {
            display: flex;
            align-items: end;
            justify-content: space-between;
            gap: 8px;
        }

        .kpi-value strong {
            color: var(--bh-primary-dark);
            font-size: 30px;
            line-height: 1;
            font-weight: 800;
        }

        .kpi-card.dark .kpi-value strong {
            color: #ffffff;
            font-size: 24px;
        }

        .kpi-value span {
            color: var(--bh-muted);
            font-size: 12px;
            font-weight: 700;
        }

        .trend-up {
            color: var(--bh-accent) !important;
        }

        .urgent-tag {
            padding: 4px 8px;
            border-radius: 999px;
            background: var(--bh-danger-soft);
            color: var(--bh-danger) !important;
            font-size: 10px !important;
            font-weight: 800 !important;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 320px;
            gap: 24px;
            align-items: start;
        }

        .main-column,
        .side-column {
            display: grid;
            gap: 22px;
        }

        .two-column {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 22px;
        }

        .panel {
            border: 1px solid var(--bh-border);
            border-radius: 16px;
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
            gap: 14px;
            margin-bottom: 18px;
        }

        .panel-title {
            margin: 0;
            color: var(--bh-primary-dark);
            font-size: 20px;
            font-weight: 800;
        }

        .panel-link {
            border: 0;
            background: transparent;
            color: var(--bh-accent);
            font-size: 13px;
            font-weight: 800;
            cursor: pointer;
        }

        .task-list {
            display: grid;
            gap: 12px;
        }

        .task-item {
            display: grid;
            grid-template-columns: 44px minmax(0, 1fr) 118px 28px;
            gap: 14px;
            align-items: center;
            padding: 14px;
            border: 1px solid transparent;
            border-radius: 14px;
            background: #f7f4ee;
        }

        .task-item:hover {
            border-color: #bfe7d0;
        }

        .task-icon {
            width: 42px;
            height: 42px;
            display: grid;
            place-items: center;
            border-radius: 12px;
            background: rgba(0, 98, 65, 0.10);
            color: var(--bh-primary);
        }

        .task-icon.danger {
            background: var(--bh-danger-soft);
            color: var(--bh-danger);
        }

        .task-name {
            margin: 0 0 5px;
            font-weight: 800;
        }

        .task-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            color: var(--bh-muted);
            font-size: 12px;
        }

        .priority {
            padding: 2px 7px;
            border-radius: 999px;
            background: #e3f5eb;
            color: var(--bh-accent);
            font-weight: 800;
        }

        .priority.high {
            background: var(--bh-danger-soft);
            color: var(--bh-danger);
        }

        .progress {
            height: 7px;
            border-radius: 999px;
            background: #e3ded5;
            overflow: hidden;
        }

        .progress span {
            display: block;
            height: 100%;
            border-radius: inherit;
            background: var(--bh-accent);
        }

        .progress.danger span {
            background: var(--bh-danger);
        }

        .clock-card {
            padding: 18px;
            border-radius: 14px;
            background: #f2f0eb;
            text-align: center;
        }

        .clock-card span {
            display: block;
            margin-bottom: 6px;
            color: var(--bh-muted);
            font-size: 13px;
            font-weight: 700;
        }

        .clock-card strong {
            color: var(--bh-primary-dark);
            font-size: 32px;
            line-height: 1;
            font-weight: 800;
            font-variant-numeric: tabular-nums;
        }

        .check-buttons {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 10px;
            margin: 16px 0;
        }

        .check-button {
            min-height: 64px;
            display: grid;
            place-items: center;
            gap: 5px;
            border: 1px solid var(--bh-muted-border);
            border-radius: 12px;
            background: #f7f4ee;
            color: var(--bh-primary-dark);
            font-weight: 800;
            cursor: pointer;
        }

        .check-button.primary {
            background: var(--bh-primary);
            color: #ffffff;
            border-color: var(--bh-primary);
        }

        .metric-row,
        .pay-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 10px 0;
            border-bottom: 1px solid var(--bh-muted-border);
            color: var(--bh-muted);
            font-size: 13px;
        }

        .metric-row:last-child,
        .pay-row:last-child {
            border-bottom: 0;
        }

        .metric-row strong,
        .pay-row strong {
            color: var(--bh-primary-dark);
        }

        .pay-total {
            margin-top: 10px;
            padding-top: 12px;
            border-top: 1px dashed var(--bh-border);
        }

        .pay-total strong {
            color: var(--bh-primary);
            font-size: 18px;
        }

        .download-button {
            width: 100%;
            min-height: 44px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 16px;
            border: 1px solid #9dddbb;
            border-radius: 12px;
            background: #effaf4;
            color: var(--bh-primary);
            font-weight: 800;
        }

        .quick-panel {
            padding: 20px;
            border-radius: 16px;
            background: var(--bh-primary-dark);
            color: #ffffff;
            box-shadow: var(--bh-shadow);
        }

        .quick-panel h3 {
            margin: 0 0 14px;
            color: rgba(255, 255, 255, 0.70);
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .quick-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 10px;
        }

        .quick-link {
            min-height: 86px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            gap: 10px;
            padding: 14px;
            border-radius: 14px;
            background: rgba(255, 255, 255, 0.10);
            color: #ffffff;
            font-weight: 800;
            transition: background 0.18s ease, transform 0.18s ease;
        }

        .quick-link:hover {
            background: rgba(255, 255, 255, 0.16);
            transform: translateY(-2px);
        }

        .event-list,
        .notice-list {
            display: grid;
            gap: 12px;
        }

        .event-item {
            display: grid;
            grid-template-columns: 48px minmax(0, 1fr);
            gap: 12px;
            padding: 12px;
            border-left: 4px solid var(--bh-accent);
            border-radius: 12px;
            background: #f7f4ee;
        }

        .event-item.gold {
            border-left-color: var(--bh-gold);
        }

        .event-date {
            text-align: center;
        }

        .event-date span {
            display: block;
            color: var(--bh-muted);
            font-size: 11px;
            font-weight: 800;
        }

        .event-date strong {
            display: block;
            color: var(--bh-primary-dark);
            font-size: 22px;
        }

        .event-item p,
        .notice-item p {
            margin: 0;
            font-weight: 800;
        }

        .event-item small,
        .notice-item small {
            display: block;
            margin-top: 4px;
            color: var(--bh-muted);
            font-size: 12px;
        }

        .notice-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .new-badge {
            padding: 4px 8px;
            border-radius: 999px;
            background: var(--bh-danger);
            color: #ffffff;
            font-size: 10px;
            font-weight: 800;
        }

        .notice-item {
            display: grid;
            grid-template-columns: 34px minmax(0, 1fr);
            gap: 10px;
        }

        .notice-icon {
            width: 32px;
            height: 32px;
            display: grid;
            place-items: center;
            border-radius: 999px;
            background: #e3f5eb;
            color: var(--bh-primary);
        }

        .profile-card {
            position: relative;
            padding: 22px;
        }

        .profile-card::after {
            content: "";
            position: absolute;
            top: -48px;
            right: -48px;
            width: 130px;
            height: 130px;
            border-radius: 999px;
            background: rgba(0, 98, 65, 0.06);
        }

        .profile-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .profile-photo {
            width: 112px;
            height: 112px;
            flex: 0 0 auto;
            display: grid;
            place-items: center;
            overflow: hidden;
            border: 4px solid #f2f0eb;
            border-radius: 22px;
            background: var(--bh-primary-soft);
            color: var(--bh-primary);
            font-size: 38px;
        }

        .profile-photo img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-info h3 {
            margin: 0;
            color: var(--bh-primary-dark);
            font-size: 20px;
        }

        .profile-info p {
            margin: 6px 0 12px;
            color: var(--bh-muted);
            font-size: 13px;
        }

        .skill-row {
            display: flex;
            flex-wrap: wrap;
            gap: 7px;
            margin-bottom: 14px;
        }

        .skill {
            padding: 5px 10px;
            border-radius: 999px;
            background: #f2f0eb;
            color: var(--bh-muted);
            font-size: 12px;
            font-weight: 700;
        }

        .outline-button {
            min-height: 38px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 0 14px;
            border: 1px solid var(--bh-border);
            border-radius: 999px;
            background: #ffffff;
            color: var(--bh-primary-dark);
            font-size: 13px;
            font-weight: 800;
        }

        .footer {
            padding: 24px clamp(20px, 4vw, 44px);
            border-top: 1px solid var(--bh-muted-border);
            color: var(--bh-muted);
            font-size: 12px;
        }

        @media (max-width: 1180px) {
            .employee-shell {
                grid-template-columns: 1fr;
            }

            .employee-sidebar {
                position: static;
                height: auto;
                border-radius: 0 0 20px 20px;
            }

            .side-nav {
                grid-template-columns: repeat(4, minmax(0, 1fr));
            }

            .sidebar-bottom {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .kpi-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }

            .dashboard-grid {
                grid-template-columns: 1fr;
            }

            .side-column {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 820px) {
            .topbar {
                align-items: stretch;
                flex-direction: column;
            }

            .search-box {
                width: 100%;
            }

            .topbar-actions {
                flex-wrap: wrap;
            }

            .welcome-row {
                align-items: flex-start;
                flex-direction: column;
            }

            .kpi-grid,
            .two-column,
            .side-column,
            .side-nav {
                grid-template-columns: 1fr;
            }

            .task-item {
                grid-template-columns: 44px minmax(0, 1fr) 28px;
            }

            .task-item .progress {
                grid-column: 2 / -1;
                width: 100%;
            }

            .profile-content {
                align-items: flex-start;
                flex-direction: column;
            }
        }

        @media (max-width: 520px) {
            .content {
                padding-inline: 14px;
            }

            .employee-sidebar {
                padding: 18px 14px;
            }

            .topbar {
                padding-inline: 14px;
            }

            .kpi-card,
            .panel-inner,
            .quick-panel,
            .profile-card {
                padding: 16px;
            }
        }
    </style>
</head>
<body>
    <c:set var="currentUser" value="${sessionScope.systemUser}" />
    <c:set var="currentEmployee" value="${currentUser.employee}" />
    <c:set var="displayName" value="Nhân viên" />
    <c:if test="${not empty currentUser.username}">
        <c:set var="displayName" value="${currentUser.username}" />
    </c:if>
    <c:if test="${not empty currentEmployee.fullName}">
        <c:set var="displayName" value="${currentEmployee.fullName}" />
    </c:if>
    <c:set var="positionName" value="Nhân viên" />
    <c:if test="${not empty currentEmployee.position}">
        <c:set var="positionName" value="${currentEmployee.position}" />
    </c:if>
    <c:set var="departmentName" value="BetterHR" />
    <c:if test="${not empty currentEmployee.departmentName}">
        <c:set var="departmentName" value="${currentEmployee.departmentName}" />
    </c:if>
    <c:set var="avatarUrl" value="${pageContext.request.contextPath}/image/logo/1.png" />
    <c:if test="${not empty currentUser.avatarUrl}">
        <c:set var="avatarUrl" value="${currentUser.avatarUrl}" />
    </c:if>

    <div class="employee-shell">
        <aside class="employee-sidebar">
            <a class="brand" href="${pageContext.request.contextPath}/homepage" aria-label="BetterHR">
                <div class="brand-mark">B</div>
                <div>
                    <strong>BetterHR</strong>
                    <span>Cổng thông tin nhân viên</span>
                </div>
            </a>

            <nav class="side-nav" aria-label="Điều hướng nhân viên">
                <a class="nav-item active" href="${pageContext.request.contextPath}/Views/Employee/EmployeeHome.jsp">
                    <i class="fa-solid fa-table-columns"></i>
                    <span>Bảng điều khiển</span>
                </a>
                <a class="nav-item" href="${pageContext.request.contextPath}/Views/Employee/EmployeeProfile.jsp">
                    <i class="fa-solid fa-user"></i>
                    <span>Hồ sơ cá nhân</span>
                </a>
                <a class="nav-item" href="#attendance">
                    <i class="fa-solid fa-fingerprint"></i>
                    <span>Chấm công</span>
                </a>
                <a class="nav-item" href="${pageContext.request.contextPath}/Views/Employee/LeaveManagement.jsp">
                    <i class="fa-solid fa-calendar-check"></i>
                    <span>Đơn nghỉ phép</span>
                </a>
                <a class="nav-item" href="${pageContext.request.contextPath}/Views/Employee/ViewPayroll.jsp">
                    <i class="fa-solid fa-money-bill-wave"></i>
                    <span>Bảng lương</span>
                </a>
                <a class="nav-item" href="#tasks">
                    <i class="fa-solid fa-list-check"></i>
                    <span>Công việc của tôi</span>
                </a>

                <div class="nav-section-label">Tài nguyên</div>
                <a class="nav-item" href="${pageContext.request.contextPath}/Views/Employee/ViewContract.jsp">
                    <i class="fa-solid fa-file-signature"></i>
                    <span>Hợp đồng</span>
                </a>
                <a class="nav-item" href="#events">
                    <i class="fa-solid fa-calendar-days"></i>
                    <span>Lịch làm việc</span>
                </a>
            </nav>

            <div class="sidebar-bottom">
                <a class="nav-item" href="#notices">
                    <i class="fa-solid fa-bell"></i>
                    <span>Thông báo</span>
                </a>
                <a class="nav-item" href="${pageContext.request.contextPath}/logout">
                    <i class="fa-solid fa-right-from-bracket"></i>
                    <span>Đăng xuất</span>
                </a>
            </div>
        </aside>

        <main class="employee-main">
            <header class="topbar">
                <label class="search-box">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="search" placeholder="Tìm kiếm nhanh..." aria-label="Tìm kiếm nhanh">
                </label>

                <div class="topbar-actions">
                    <a class="icon-button" href="#notices" aria-label="Thông báo">
                        <i class="fa-solid fa-bell"></i>
                        <span class="badge">3</span>
                    </a>
                    <a class="user-chip" href="${pageContext.request.contextPath}/Views/Employee/EmployeeProfile.jsp">
                        <span class="avatar">
                            <img src="${avatarUrl}" alt="${displayName}">
                        </span>
                        <span>${displayName}</span>
                        <i class="fa-solid fa-chevron-down"></i>
                    </a>
                    <a class="home-pill" href="${pageContext.request.contextPath}/homepage">
                        <i class="fa-solid fa-house"></i>
                        <span>Trang chủ</span>
                    </a>
                </div>
            </header>

            <div class="content">
                <section class="welcome-row">
                    <div>
                        <p class="eyebrow">${departmentName}</p>
                        <h1 class="welcome-title">Xin chào, ${displayName}</h1>
                        <p class="welcome-note">Sẵn sàng cho một ngày làm việc hiệu quả cùng BetterHR.</p>
                    </div>
                    <a class="primary-action" href="#attendance">
                        <i class="fa-solid fa-fingerprint"></i>
                        <span>Điểm danh</span>
                    </a>
                </section>

                <section class="kpi-grid" aria-label="Chỉ số nhanh">
                    <article class="kpi-card">
                        <p class="kpi-label">Tỷ lệ chuyên cần</p>
                        <div class="kpi-value">
                            <strong>98%</strong>
                            <span class="trend-up"><i class="fa-solid fa-arrow-trend-up"></i> +2%</span>
                        </div>
                    </article>
                    <article class="kpi-card">
                        <p class="kpi-label">Ngày phép còn lại</p>
                        <div class="kpi-value">
                            <strong>12</strong>
                            <span>ngày</span>
                        </div>
                    </article>
                    <article class="kpi-card">
                        <p class="kpi-label">Công việc đang chạy</p>
                        <div class="kpi-value">
                            <strong>05</strong>
                            <span class="urgent-tag">2 gấp</span>
                        </div>
                    </article>
                    <article class="kpi-card">
                        <p class="kpi-label">Lịch họp hôm nay</p>
                        <div class="kpi-value">
                            <strong>02</strong>
                            <span>cuộc họp</span>
                        </div>
                    </article>
                    <article class="kpi-card dark">
                        <p class="kpi-label">Lương tạm tính</p>
                        <div class="kpi-value">
                            <strong>24.500.000</strong>
                            <span>VNĐ</span>
                        </div>
                    </article>
                </section>

                <div class="dashboard-grid">
                    <div class="main-column">
                        <section class="panel" id="tasks">
                            <div class="panel-inner">
                                <div class="panel-header">
                                    <h2 class="panel-title">Công việc của tôi</h2>
                                    <a class="panel-link" href="#tasks">Xem tất cả</a>
                                </div>

                                <div class="task-list">
                                    <article class="task-item">
                                        <div class="task-icon">
                                            <i class="fa-solid fa-code"></i>
                                        </div>
                                        <div>
                                            <p class="task-name">Cập nhật API cho module bảng lương</p>
                                            <div class="task-meta">
                                                <span>Hạn chót: 25/10</span>
                                                <span class="priority">Trung bình</span>
                                            </div>
                                        </div>
                                        <div class="progress" aria-label="75%">
                                            <span style="width: 75%"></span>
                                        </div>
                                        <i class="fa-solid fa-ellipsis-vertical" aria-hidden="true"></i>
                                    </article>

                                    <article class="task-item">
                                        <div class="task-icon danger">
                                            <i class="fa-solid fa-bug"></i>
                                        </div>
                                        <div>
                                            <p class="task-name">Sửa giao diện bảng điều khiển di động</p>
                                            <div class="task-meta">
                                                <span>Hạn chót: hôm nay</span>
                                                <span class="priority high">Khẩn cấp</span>
                                            </div>
                                        </div>
                                        <div class="progress danger" aria-label="25%">
                                            <span style="width: 25%"></span>
                                        </div>
                                        <i class="fa-solid fa-ellipsis-vertical" aria-hidden="true"></i>
                                    </article>
                                </div>
                            </div>
                        </section>

                        <div class="two-column">
                            <section class="panel" id="attendance">
                                <div class="panel-inner">
                                    <h2 class="panel-title">Chấm công</h2>
                                    <div class="clock-card">
                                        <span>Giờ làm hôm nay</span>
                                        <strong id="liveClock">00:00:00</strong>
                                    </div>
                                    <div class="check-buttons">
                                        <button class="check-button primary" type="button">
                                            <i class="fa-solid fa-right-to-bracket"></i>
                                            <span>Vào ca</span>
                                        </button>
                                        <button class="check-button" type="button">
                                            <i class="fa-solid fa-right-from-bracket"></i>
                                            <span>Ra ca</span>
                                        </button>
                                    </div>
                                    <div class="metric-row">
                                        <span>Tổng giờ tháng này</span>
                                        <strong>164.5h</strong>
                                    </div>
                                    <div class="metric-row">
                                        <span>Đi muộn / về sớm</span>
                                        <strong style="color: var(--bh-danger)">02 lần</strong>
                                    </div>
                                </div>
                            </section>

                            <section class="panel">
                                <div class="panel-inner">
                                    <div class="panel-header">
                                        <h2 class="panel-title">Phiếu lương</h2>
                                        <a class="panel-link" href="${pageContext.request.contextPath}/Views/Employee/ViewPayroll.jsp">
                                            <i class="fa-solid fa-eye"></i>
                                        </a>
                                    </div>
                                    <div class="pay-row">
                                        <span>Lương cơ bản</span>
                                        <strong>20.000.000</strong>
                                    </div>
                                    <div class="pay-row">
                                        <span>Phụ cấp</span>
                                        <strong style="color: var(--bh-accent)">+5.500.000</strong>
                                    </div>
                                    <div class="pay-row">
                                        <span>Khấu trừ & thuế</span>
                                        <strong style="color: var(--bh-danger)">-1.000.000</strong>
                                    </div>
                                    <div class="pay-row pay-total">
                                        <span>Thực nhận</span>
                                        <strong>24.500.000</strong>
                                    </div>
                                    <a class="download-button" href="${pageContext.request.contextPath}/Views/Employee/ViewPayroll.jsp">
                                        <i class="fa-solid fa-download"></i>
                                        <span>Tải phiếu lương</span>
                                    </a>
                                </div>
                            </section>
                        </div>

                        <section class="panel">
                            <div class="profile-card">
                                <div class="profile-content">
                                    <div class="profile-photo">
                                        <img src="${avatarUrl}" alt="${displayName}">
                                    </div>
                                    <div class="profile-info">
                                        <h3>${displayName}</h3>
                                        <p>
                                            Mã nhân viên:
                                            <c:choose>
                                                <c:when test="${not empty currentUser.employeeId}">NV-${currentUser.employeeId}</c:when>
                                                <c:otherwise>Đang cập nhật</c:otherwise>
                                            </c:choose>
                                            · ${positionName}
                                        </p>
                                        <div class="skill-row">
                                            <span class="skill">${departmentName}</span>
                                            <span class="skill">${positionName}</span>
                                            <span class="skill">BetterHR</span>
                                            <span class="skill">Đang hoạt động</span>
                                        </div>
                                        <a class="outline-button" href="${pageContext.request.contextPath}/Views/Employee/EmployeeProfile.jsp">
                                            <i class="fa-solid fa-user-pen"></i>
                                            <span>Cập nhật hồ sơ</span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </section>
                    </div>

                    <aside class="side-column">
                        <section class="quick-panel">
                            <h3>Thao tác nhanh</h3>
                            <div class="quick-grid">
                                <a class="quick-link" href="${pageContext.request.contextPath}/Views/Employee/LeaveManagement.jsp">
                                    <i class="fa-solid fa-circle-plus"></i>
                                    <span>Xin nghỉ phép</span>
                                </a>
                                <a class="quick-link" href="${pageContext.request.contextPath}/Views/Employee/ViewPayroll.jsp">
                                    <i class="fa-solid fa-receipt"></i>
                                    <span>Xem bảng lương</span>
                                </a>
                                <a class="quick-link" href="${pageContext.request.contextPath}/Views/Employee/EmployeeProfile.jsp">
                                    <i class="fa-solid fa-id-card"></i>
                                    <span>Cập nhật hồ sơ</span>
                                </a>
                                <a class="quick-link" href="${pageContext.request.contextPath}/Views/Employee/ViewContract.jsp">
                                    <i class="fa-solid fa-file-contract"></i>
                                    <span>Xem hợp đồng</span>
                                </a>
                            </div>
                        </section>

                        <section class="panel" id="events">
                            <div class="panel-inner">
                                <h2 class="panel-title">Sự kiện sắp tới</h2>
                                <div class="event-list">
                                    <article class="event-item">
                                        <div class="event-date">
                                            <span>T2</span>
                                            <strong>23</strong>
                                        </div>
                                        <div>
                                            <p>Họp Sprint Review</p>
                                            <small><i class="fa-regular fa-clock"></i> 14:00 - 15:30</small>
                                        </div>
                                    </article>
                                    <article class="event-item gold">
                                        <div class="event-date">
                                            <span>T4</span>
                                            <strong>25</strong>
                                        </div>
                                        <div>
                                            <p>Đào tạo an toàn thông tin</p>
                                            <small><i class="fa-solid fa-graduation-cap"></i> 09:00 - 11:00</small>
                                        </div>
                                    </article>
                                </div>
                            </div>
                        </section>

                        <section class="panel" id="notices">
                            <div class="panel-inner">
                                <div class="notice-header">
                                    <h2 class="panel-title">Thông báo</h2>
                                    <span class="new-badge">3 mới</span>
                                </div>
                                <div class="notice-list" style="margin-top: 16px;">
                                    <article class="notice-item">
                                        <div class="notice-icon">
                                            <i class="fa-solid fa-bullhorn"></i>
                                        </div>
                                        <div>
                                            <p>Chính sách nghỉ phép được cập nhật</p>
                                            <small>2 giờ trước</small>
                                        </div>
                                    </article>
                                    <article class="notice-item">
                                        <div class="notice-icon">
                                            <i class="fa-regular fa-newspaper"></i>
                                        </div>
                                        <div>
                                            <p>Workshop cân bằng cuộc sống</p>
                                            <small>Hôm qua</small>
                                        </div>
                                    </article>
                                </div>
                            </div>
                        </section>
                    </aside>
                </div>
            </div>

            <footer class="footer">
                © 2026 BetterHR System. Nền tảng quản trị nhân sự hiện đại.
            </footer>
        </main>
    </div>

    <script>
        function updateClock() {
            const now = new Date();
            const h = String(now.getHours()).padStart(2, "0");
            const m = String(now.getMinutes()).padStart(2, "0");
            const s = String(now.getSeconds()).padStart(2, "0");
            const clock = document.getElementById("liveClock");
            if (clock) {
                clock.textContent = h + ":" + m + ":" + s;
            }
        }

        updateClock();
        setInterval(updateClock, 1000);
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BetterHR - Nâng tầm sự nghiệp của bạn</title>
    <link href="https://fonts.googleapis.com/css2?family=Hanken+Grotesk:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <style>
        :root {
            --text-secondary: rgba(0, 0, 0, 0.58);
            --text-primary: rgba(0, 0, 0, 0.87);
            --background: #fbf9f4;
            --canvas-warm: #f2f0eb;
            --surface-low: #f5f3ee;
            --surface-white: #ffffff;
            --surface-container: #f0eee9;
            --surface-container-high: #eae8e3;
            --primary: #00482f;
            --primary-container: #006241;
            --secondary: #006c44;
            --secondary-container: #97f6c0;
            --secondary-fixed: #97f6c0;
            --on-primary: #ffffff;
            --on-secondary: #ffffff;
            --outline: #6f7a72;
            --outline-variant: #bec9c0;
            --house-green: #1E3932;
            --accent-gold: #cba258;
            --error-red: #c82014;
            --radius-card: 12px;
            --radius-pill: 9999px;
            --shadow-whisper: 0 0 0.5px rgba(0,0,0,0.14), 0 1px 1px rgba(0,0,0,0.24);
            --shadow-lift: 0 10px 26px rgba(0, 0, 0, 0.12);
            --gutter: 40px;
        }

        * {
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            margin: 0;
            font-family: "Hanken Grotesk", "Helvetica Neue", Arial, sans-serif;
            color: var(--text-primary);
            background: var(--canvas-warm);
            -webkit-font-smoothing: antialiased;
            letter-spacing: 0;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        button,
        input {
            font: inherit;
        }

        .material-symbols-outlined {
            font-variation-settings: "FILL" 0, "wght" 500, "GRAD" 0, "opsz" 24;
            line-height: 1;
        }

        .site-header {
            position: fixed;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            z-index: 50;
            width: min(1280px, 100%);
            height: 72px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            padding: 0 var(--gutter);
            background: var(--surface-white);
            box-shadow: 0 1px 3px rgba(0,0,0,0.10), 0 2px 2px rgba(0,0,0,0.06), 0 0 2px rgba(0,0,0,0.07);
        }

        .brand-row,
        .nav-links,
        .header-actions {
            display: flex;
            align-items: center;
        }

        .brand-row {
            gap: 40px;
        }

        .brand {
            color: var(--primary-container);
            font-size: 24px;
            line-height: 36px;
            font-weight: 800;
            letter-spacing: 0;
            white-space: nowrap;
        }

        .nav-links {
            gap: 24px;
        }

        .nav-link {
            color: var(--text-secondary);
            font-size: 16px;
            line-height: 1.5;
            font-weight: 600;
            transition: color 0.2s ease;
        }

        .nav-link.active {
            color: var(--primary);
            border-bottom: 2px solid var(--primary);
            padding-bottom: 4px;
            font-weight: 800;
        }

        .nav-link:hover {
            color: var(--secondary);
        }

        .header-actions {
            gap: 16px;
            position: relative;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            border-radius: var(--radius-pill);
            border: 1px solid transparent;
            padding: 9px 18px;
            min-height: 40px;
            font-size: 14px;
            font-weight: 800;
            line-height: 1.5;
            cursor: pointer;
            transition: transform 0.2s ease, background 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease;
            white-space: nowrap;
        }

        .btn:active,
        .active-scale:active {
            transform: scale(0.95);
        }

        .btn-primary {
            background: var(--primary);
            color: var(--on-primary);
            border-color: var(--primary);
        }

        .btn-primary:hover {
            background: var(--secondary);
            border-color: var(--secondary);
            box-shadow: 0 8px 20px rgba(0, 98, 65, 0.22);
        }

        .btn-outline {
            background: transparent;
            color: var(--primary);
            border-color: var(--outline);
        }

        .btn-outline:hover {
            border-color: var(--primary);
            background: rgba(0, 98, 65, 0.06);
        }

        .dashboard-wrap,
        .profile-wrap {
            position: relative;
        }

        .dashboard-menu,
        .profile-menu {
            position: absolute;
            top: calc(100% + 12px);
            right: 0;
            min-width: 260px;
            display: none;
            flex-direction: column;
            gap: 8px;
            padding: 10px;
            border: 1px solid rgba(0, 0, 0, 0.12);
            border-radius: var(--radius-card);
            background: var(--surface-white);
            box-shadow: var(--shadow-lift);
        }

        .dashboard-menu.show,
        .profile-menu.show {
            display: flex;
        }

        .menu-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 11px 12px;
            border-radius: 8px;
            color: var(--text-primary);
            border: 1px solid rgba(0, 0, 0, 0.08);
            background: #ffffff;
            transition: background 0.2s ease, color 0.2s ease, transform 0.2s ease;
        }

        .menu-item:hover {
            background: var(--canvas-warm);
            color: var(--primary-container);
            transform: translateY(-1px);
        }

        .menu-item small {
            display: block;
            color: var(--text-secondary);
            font-size: 12px;
            font-weight: 500;
            margin-top: 2px;
        }

        .menu-item.admin {
            border-left: 4px solid var(--error-red);
        }

        .menu-item.hr {
            border-left: 4px solid var(--secondary);
        }

        .menu-item.employee {
            border-left: 4px solid var(--primary-container);
        }

        .menu-item.guest {
            border-left: 4px solid var(--outline);
        }

        .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 1px solid rgba(0, 0, 0, 0.10);
            background: var(--secondary);
            color: #ffffff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: var(--shadow-whisper);
        }

        .floating-apply {
            position: fixed;
            right: 40px;
            bottom: 40px;
            z-index: 45;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 16px 20px;
            border-radius: var(--radius-pill);
            background: var(--secondary);
            color: var(--on-secondary);
            font-size: 14px;
            font-weight: 800;
            box-shadow: 0 0 6px rgba(0,0,0,0.24), 0 8px 12px rgba(0,0,0,0.14);
            transition: transform 0.2s ease, background 0.2s ease;
        }

        .floating-apply:hover {
            transform: scale(1.06);
            background: var(--primary-container);
        }

        main {
            padding-top: 72px;
        }

        .hero {
            position: relative;
            min-height: 760px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            padding: 64px var(--gutter);
            text-align: center;
        }

        .hero-content {
            position: relative;
            z-index: 1;
            max-width: 900px;
        }

        .hero h1 {
            margin: 0 0 24px;
            color: var(--primary-container);
            font-size: clamp(42px, 7vw, 76px);
            line-height: 1.08;
            font-weight: 800;
            letter-spacing: 0;
        }

        .hero h1 span {
            color: var(--secondary);
        }

        .hero p {
            max-width: 720px;
            margin: 0 auto 56px;
            color: var(--text-secondary);
            font-size: 19px;
            line-height: 1.75;
            font-weight: 500;
        }

        .hero-actions {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 16px;
            flex-wrap: wrap;
        }

        .hero-actions .btn {
            min-height: 58px;
            padding: 14px 34px;
            font-size: 15px;
        }

        .blur-one,
        .blur-two {
            position: absolute;
            border-radius: 50%;
            filter: blur(64px);
            pointer-events: none;
        }

        .blur-one {
            top: 40%;
            left: -80px;
            width: 260px;
            height: 260px;
            background: rgba(162, 243, 200, 0.38);
        }

        .blur-two {
            right: -96px;
            bottom: -60px;
            width: 380px;
            height: 380px;
            background: rgba(151, 246, 192, 0.30);
        }

        .feature-band {
            background: var(--house-green);
            color: #ffffff;
            padding: 64px var(--gutter);
        }

        .feature-grid {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 64px;
        }

        .feature-card-lite {
            display: grid;
            gap: 16px;
        }

        .feature-card-lite .material-symbols-outlined {
            color: var(--secondary-fixed);
            font-size: 44px;
            font-variation-settings: "FILL" 1, "wght" 500, "GRAD" 0, "opsz" 24;
        }

        .feature-card-lite h2 {
            margin: 0;
            color: #ffffff;
            font-size: 24px;
            line-height: 36px;
            font-weight: 800;
        }

        .feature-card-lite p {
            margin: 0;
            color: rgba(255, 255, 255, 0.80);
            font-size: 16px;
            line-height: 1.55;
        }

        .jobs-section,
        .cta-section {
            max-width: 1200px;
            margin: 0 auto;
            padding: 64px var(--gutter);
        }

        .section-header {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 24px;
            margin-bottom: 36px;
        }

        .section-header h2 {
            margin: 0 0 4px;
            color: var(--primary);
            font-size: 24px;
            line-height: 36px;
            font-weight: 800;
        }

        .section-header p {
            margin: 0;
            color: var(--text-secondary);
            font-size: 16px;
        }

        .section-link {
            color: var(--secondary);
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 14px;
            font-weight: 800;
        }

        .section-link:hover {
            text-decoration: underline;
        }

        .job-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 24px;
        }

        .job-card {
            min-height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 24px;
            border: 1px solid transparent;
            border-radius: var(--radius-card);
            background: var(--surface-white);
            box-shadow: var(--shadow-whisper);
            transition: transform 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .job-card:hover {
            transform: translateY(-4px);
            border-color: var(--secondary);
            box-shadow: var(--shadow-lift);
        }

        .job-top {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 16px;
        }

        .company-mark {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: var(--surface-container);
            color: var(--primary-container);
        }

        .company-mark .material-symbols-outlined {
            font-size: 28px;
        }

        .job-tag {
            padding: 5px 10px;
            border-radius: var(--radius-pill);
            background: #a2f3c8;
            color: #005235;
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
        }

        .job-tag.hybrid {
            background: var(--secondary-container);
            color: #005232;
        }

        .job-card h3 {
            margin: 0 0 6px;
            color: var(--primary);
            font-size: 19px;
            line-height: 1.35;
            font-weight: 800;
            transition: color 0.2s ease;
        }

        .job-card:hover h3 {
            color: var(--secondary);
        }

        .job-card p {
            margin: 0 0 24px;
            color: var(--text-secondary);
            font-size: 16px;
            line-height: 1.5;
        }

        .job-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding-top: 16px;
            border-top: 1px solid var(--surface-container);
        }

        .salary {
            color: var(--secondary);
            font-size: 14px;
            font-weight: 800;
        }

        .job-footer .btn {
            padding: 8px 16px;
            min-height: 36px;
        }

        .cta-card {
            position: relative;
            overflow: hidden;
            max-width: 980px;
            margin: 0 auto;
            padding: 64px;
            border: 2px solid rgba(162, 243, 200, 0.55);
            border-radius: 28px;
            background: var(--surface-white);
            box-shadow: var(--shadow-whisper);
            text-align: center;
        }

        .cta-card h2 {
            position: relative;
            z-index: 1;
            margin: 0 0 16px;
            color: var(--primary);
            font-size: 28px;
            line-height: 1.25;
            font-weight: 800;
        }

        .cta-card p {
            position: relative;
            z-index: 1;
            max-width: 620px;
            margin: 0 auto 36px;
            color: var(--text-secondary);
            font-size: 16px;
            line-height: 1.6;
        }

        .cta-card .btn {
            position: relative;
            z-index: 1;
            min-height: 52px;
            padding: 12px 32px;
        }

        .cta-bg {
            position: absolute;
            top: -80px;
            right: -80px;
            width: 260px;
            height: 260px;
            border-radius: 50%;
            background: rgba(0, 72, 47, 0.05);
        }

        .site-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            padding: 48px var(--gutter);
            background: var(--primary);
            color: var(--on-primary);
        }

        .footer-brand h2 {
            margin: 0 0 8px;
            font-size: 24px;
            line-height: 36px;
            font-weight: 600;
        }

        .footer-brand p,
        .footer-links a {
            color: rgba(162, 243, 200, 0.82);
            font-size: 14px;
            font-weight: 700;
        }

        .footer-links,
        .footer-icons {
            display: flex;
            align-items: center;
            gap: 24px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .footer-links a:hover,
        .footer-icons span:hover {
            color: #ffffff;
        }

        @media (max-width: 900px) {
            :root {
                --gutter: 20px;
            }

            .site-header {
                padding: 0 16px;
            }

            .nav-links {
                display: none;
            }

            .feature-grid,
            .job-grid {
                grid-template-columns: 1fr;
                gap: 24px;
            }

            .section-header,
            .site-footer {
                align-items: flex-start;
                flex-direction: column;
            }

            .hero {
                min-height: 680px;
            }

            .hero-actions {
                flex-direction: column;
            }

            .hero-actions .btn,
            .cta-card .btn {
                width: 100%;
            }

            .cta-card {
                padding: 40px 24px;
            }

            .floating-apply {
                right: 18px;
                bottom: 18px;
                padding: 14px;
            }

            .floating-apply span:last-child {
                display: none;
            }
        }

        @media (max-width: 560px) {
            .header-actions .btn-outline,
            .dashboard-trigger span:last-child {
                display: none;
            }

            .dashboard-menu,
            .profile-menu {
                right: -12px;
                min-width: 238px;
            }
        }
    </style>
</head>
<body>
    <header class="site-header">
        <div class="brand-row">
            <a class="brand" href="${pageContext.request.contextPath}/homepage">BetterHR</a>
            <nav class="nav-links" aria-label="Điều hướng chính">
                <a class="nav-link" href="${pageContext.request.contextPath}/RecruitmentController">Việc làm</a>
                <a class="nav-link" href="#features">Về chúng tôi</a>
            </nav>
        </div>

        <div class="header-actions">
            <c:if test="${not empty sessionScope.systemUser}">
                <div class="dashboard-wrap">
                    <button type="button" class="btn btn-outline dashboard-trigger" onclick="toggleDashboardDropdown()">
                        <span class="material-symbols-outlined">dashboard</span>
                        <span>Dashboard</span>
                    </button>
                    <div class="dashboard-menu" id="dashboardDropdown">
                        <c:if test="${dashboardAccess.canAccessAdmin}">
                            <a href="${pageContext.request.contextPath}${dashboardAccess.adminUrl}" class="menu-item admin">
                                <span class="material-symbols-outlined">admin_panel_settings</span>
                                <span>Admin<small>Quản trị hệ thống</small></span>
                            </a>
                        </c:if>
                        <c:if test="${dashboardAccess.canAccessHR}">
                            <a href="${pageContext.request.contextPath}${dashboardAccess.hrUrl}" class="menu-item hr">
                                <span class="material-symbols-outlined">groups</span>
                                <span>HR Manager<small>Quản lý nhân sự</small></span>
                            </a>
                        </c:if>
                        <c:if test="${dashboardAccess.canAccessHrStaff}">
                            <a href="${pageContext.request.contextPath}${dashboardAccess.hrStaffUrl}" class="menu-item hr">
                                <span class="material-symbols-outlined">badge</span>
                                <span>HR Staff<small>Nghiệp vụ nhân sự</small></span>
                            </a>
                        </c:if>
                        <c:if test="${dashboardAccess.canAccessEmployee}">
                            <a href="${pageContext.request.contextPath}${dashboardAccess.employeeUrl}" class="menu-item employee">
                                <span class="material-symbols-outlined">person</span>
                                <span>Employee<small>Cổng nhân viên</small></span>
                            </a>
                        </c:if>
                        <c:if test="${dashboardAccess.canAccessGuest}">
                            <a href="${pageContext.request.contextPath}${dashboardAccess.guestUrl}" class="menu-item guest">
                                <span class="material-symbols-outlined">home</span>
                                <span>Guest<small>Trang công khai</small></span>
                            </a>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <c:if test="${empty sessionScope.systemUser}">
                <a class="btn btn-outline" href="${pageContext.request.contextPath}/register">Đăng ký</a>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
            </c:if>

            <c:if test="${not empty sessionScope.systemUser}">
                <div class="profile-wrap">
                    <button type="button" class="avatar" onclick="toggleProfileDropdown()" title="Tài khoản">
                        <span class="material-symbols-outlined">person</span>
                    </button>
                    <div class="profile-menu" id="profileDropdown">
                        <a href="${pageContext.request.contextPath}/profilepage" class="menu-item">
                            <span class="material-symbols-outlined">account_circle</span>
                            <span>Hồ sơ<small>${currentUser.username}</small></span>
                        </a>
                        <a href="${pageContext.request.contextPath}/Views/ChangePassword.jsp" class="menu-item">
                            <span class="material-symbols-outlined">lock_reset</span>
                            <span>Đổi mật khẩu<small>Bảo mật tài khoản</small></span>
                        </a>
                        <a href="javascript:void(0)" onclick="handleLogout()" class="menu-item">
                            <span class="material-symbols-outlined">logout</span>
                            <span>Đăng xuất<small>Kết thúc phiên làm việc</small></span>
                        </a>
                    </div>
                </div>
            </c:if>
        </div>
    </header>

    <a class="floating-apply active-scale" href="${pageContext.request.contextPath}/RecruitmentController">
        <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">bolt</span>
        <span>Ứng tuyển ngay</span>
    </a>

    <main>
        <section class="hero" id="home">
            <div class="hero-content">
                <h1>Cơ hội nghề nghiệp tốt hơn,<br><span>bắt đầu từ hôm nay.</span></h1>
                <p>BetterHR kết nối những tài năng xuất sắc với các doanh nghiệp hàng đầu Việt Nam. Khám phá các cơ hội việc làm được chọn lọc kỹ lưỡng.</p>
                <div class="hero-actions">
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/RecruitmentController">Khám phá việc làm</a>
                    <a class="btn btn-outline" href="#features">Tìm hiểu thêm</a>
                </div>
            </div>
            <div class="blur-one"></div>
            <div class="blur-two"></div>
        </section>

        <section class="feature-band" id="features">
            <div class="feature-grid">
                <article class="feature-card-lite">
                    <span class="material-symbols-outlined">verified</span>
                    <h2>Đối tác tin cậy</h2>
                    <p>Hợp tác với các doanh nghiệp chất lượng, bảo đảm thông tin tuyển dụng rõ ràng và đáng tin cậy.</p>
                </article>
                <article class="feature-card-lite">
                    <span class="material-symbols-outlined">trending_up</span>
                    <h2>Lộ trình thăng tiến</h2>
                    <p>Cung cấp định hướng nghề nghiệp và các điểm chạm nhân sự giúp bạn phát triển bền vững hơn.</p>
                </article>
                <article class="feature-card-lite">
                    <span class="material-symbols-outlined">speed</span>
                    <h2>Ứng tuyển nhanh chóng</h2>
                    <p>Quy trình nộp hồ sơ gọn gàng, dễ theo dõi và phù hợp với trải nghiệm tuyển dụng hiện đại.</p>
                </article>
            </div>
        </section>

        <section class="jobs-section" id="jobs">
            <div class="section-header">
                <div>
                    <h2>Việc làm mới nhất</h2>
                    <p>Những vị trí đang được quan tâm tại BetterHR</p>
                </div>
                <a class="section-link" href="${pageContext.request.contextPath}/RecruitmentController">
                    Xem tất cả công việc <span class="material-symbols-outlined">arrow_forward</span>
                </a>
            </div>

            <div class="job-grid">
                <article class="job-card">
                    <div>
                        <div class="job-top">
                            <span class="company-mark"><span class="material-symbols-outlined">design_services</span></span>
                            <span class="job-tag">Toàn thời gian</span>
                        </div>
                        <h3>Senior UI/UX Designer</h3>
                        <p>TechNova Solutions · Quận 1, TP.HCM</p>
                    </div>
                    <div class="job-footer">
                        <span class="salary">25 - 35 Triệu</span>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/RecruitmentController">Ứng tuyển</a>
                    </div>
                </article>

                <article class="job-card">
                    <div>
                        <div class="job-top">
                            <span class="company-mark"><span class="material-symbols-outlined">analytics</span></span>
                            <span class="job-tag hybrid">Hybrid</span>
                        </div>
                        <h3>Data Analyst Specialist</h3>
                        <p>FinVantage Capital · Cầu Giấy, Hà Nội</p>
                    </div>
                    <div class="job-footer">
                        <span class="salary">Thỏa thuận</span>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/RecruitmentController">Ứng tuyển</a>
                    </div>
                </article>

                <article class="job-card">
                    <div>
                        <div class="job-top">
                            <span class="company-mark"><span class="material-symbols-outlined">campaign</span></span>
                            <span class="job-tag">Toàn thời gian</span>
                        </div>
                        <h3>Product Marketing Lead</h3>
                        <p>GreenEco Corp · Quận 7, TP.HCM</p>
                    </div>
                    <div class="job-footer">
                        <span class="salary">30 - 45 Triệu</span>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/RecruitmentController">Ứng tuyển</a>
                    </div>
                </article>
            </div>
        </section>

        <section class="cta-section">
            <div class="cta-card">
                <div class="cta-bg"></div>
                <h2>Sẵn sàng cho bước tiếp theo trong sự nghiệp?</h2>
                <p>Tạo hồ sơ chuyên nghiệp trên BetterHR ngay hôm nay và tiếp cận các cơ hội tuyển dụng phù hợp với năng lực của bạn.</p>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/RecruitmentController">Tạo hồ sơ ngay miễn phí</a>
            </div>
        </section>
    </main>

    <footer class="site-footer">
        <div class="footer-brand">
            <h2>BetterHR</h2>
            <p>© 2026 BetterHR. Bảo lưu mọi quyền.</p>
        </div>
        <nav class="footer-links" aria-label="Liên kết cuối trang">
            <a href="#">Điều khoản</a>
            <a href="#">Bảo mật</a>
            <a href="#">Liên hệ</a>
            <a href="${pageContext.request.contextPath}/RecruitmentController">Tuyển dụng</a>
        </nav>
        <div class="footer-icons">
            <span class="material-symbols-outlined">face</span>
            <span class="material-symbols-outlined">brand_awareness</span>
        </div>
    </footer>

    <script>
        function toggleDashboardDropdown() {
            const dropdown = document.getElementById('dashboardDropdown');
            if (dropdown) {
                dropdown.classList.toggle('show');
            }
        }

        function toggleProfileDropdown() {
            const dropdown = document.getElementById('profileDropdown');
            if (dropdown) {
                dropdown.classList.toggle('show');
            }
        }

        document.addEventListener('click', function(event) {
            const profileDropdown = document.getElementById('profileDropdown');
            const profileButton = document.querySelector('.avatar');
            const dashboardDropdown = document.getElementById('dashboardDropdown');
            const dashboardButton = document.querySelector('.dashboard-trigger');

            if (profileDropdown && profileButton && !profileButton.contains(event.target) && !profileDropdown.contains(event.target)) {
                profileDropdown.classList.remove('show');
            }

            if (dashboardDropdown && dashboardButton && !dashboardButton.contains(event.target) && !dashboardDropdown.contains(event.target)) {
                dashboardDropdown.classList.remove('show');
            }
        });

        function handleLogout() {
            if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                window.location.href = '${pageContext.request.contextPath}/logout';
            }
        }

        const header = document.querySelector('.site-header');
        window.addEventListener('scroll', function() {
            if (window.scrollY > 50) {
                header.style.boxShadow = '0 4px 16px rgba(0,0,0,0.12)';
            } else {
                header.style.boxShadow = '0 1px 3px rgba(0,0,0,0.10), 0 2px 2px rgba(0,0,0,0.06), 0 0 2px rgba(0,0,0,0.07)';
            }
        });
    </script>
</body>
</html>

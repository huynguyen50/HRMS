<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BetterHR | Hồ sơ ứng viên</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Hanken+Grotesk:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/guest.css" rel="stylesheet">
</head>
<body>
<div class="candidate-shell">
    <aside class="candidate-sidebar">
        <div class="candidate-brand">
            <strong>Better Jobs</strong>
            <span>Cổng ứng viên BetterHR</span>
        </div>

        <nav class="candidate-nav">
            <a href="${pageContext.request.contextPath}/guest/dashboard"><i class="fa-solid fa-table-columns"></i> Bảng điều khiển</a>
            <a href="${pageContext.request.contextPath}/RecruitmentController"><i class="fa-solid fa-briefcase"></i> Việc làm hiện có</a>
            <a href="${pageContext.request.contextPath}/guest/applications"><i class="fa-solid fa-list-check"></i> Đơn ứng tuyển</a>
            <a class="active" href="${pageContext.request.contextPath}/guest/profile"><i class="fa-solid fa-user"></i> Hồ sơ của tôi</a>
            <a href="${pageContext.request.contextPath}/Views/ChangePassword.jsp"><i class="fa-solid fa-shield-halved"></i> Đổi mật khẩu</a>
            <a href="${pageContext.request.contextPath}/homepage"><i class="fa-solid fa-house"></i> Trang chủ</a>
            <a href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
        </nav>

        <div class="candidate-sidebar-footer">
            <div class="candidate-support-card">
                <p>Cần hỗ trợ hồ sơ?</p>
                <a href="${pageContext.request.contextPath}/homepage">Liên hệ HR</a>
            </div>
        </div>
    </aside>

    <main class="candidate-main">
        <header class="candidate-topbar">
            <div class="candidate-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" placeholder="Tìm kiếm công việc...">
            </div>
            <div class="candidate-topbar-user">
                <div class="candidate-greeting">
                    <strong>${guestProfile.fullName}</strong>
                    <span>${currentUser.email}</span>
                </div>
                <a class="candidate-avatar" href="${pageContext.request.contextPath}/guest/profile">
                    <c:choose>
                        <c:when test="${not empty guestProfile.avatar}">
                            <img src="${guestProfile.avatar}" alt="Ảnh đại diện">
                        </c:when>
                        <c:otherwise>B</c:otherwise>
                    </c:choose>
                </a>
            </div>
        </header>

        <section class="candidate-canvas">
            <section class="candidate-hero">
                <div class="candidate-hero-content">
                    <h1>Hồ sơ của tôi</h1>
                    <p>Cập nhật thông tin cá nhân để HR có thể liên hệ và đánh giá hồ sơ của bạn thuận tiện hơn.</p>
                    <div class="candidate-actions">
                        <a class="candidate-btn secondary" href="${pageContext.request.contextPath}/guest/dashboard">Về bảng điều khiển</a>
                        <a class="candidate-btn" href="${pageContext.request.contextPath}/guest/applications">Xem đơn ứng tuyển</a>
                    </div>
                </div>
            </section>

            <div class="candidate-grid">
                <section class="candidate-card">
                    <div class="candidate-card-header">
                        <div>
                            <h2>Thông tin ứng viên</h2>
                            <p>Email đăng nhập được lấy từ tài khoản BetterHR.</p>
                        </div>
                    </div>
                    <div class="candidate-card-body">
                        <c:if test="${not empty success}">
                            <div class="candidate-alert">${success}</div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="candidate-alert error">${error}</div>
                        </c:if>

                        <form class="candidate-form" action="${pageContext.request.contextPath}/guest/profile" method="post">
                            <div class="candidate-form-grid">
                                <div class="candidate-field">
                                    <label for="fullName">Họ và tên</label>
                                    <input class="candidate-input" id="fullName" name="fullName" required value="${guestProfile.fullName}" placeholder="Nhập họ và tên">
                                </div>
                                <div class="candidate-field">
                                    <label for="email">Email</label>
                                    <input class="candidate-input" id="email" value="${currentUser.email}" readonly>
                                </div>
                                <div class="candidate-field">
                                    <label for="phone">Số điện thoại</label>
                                    <input class="candidate-input" id="phone" name="phone" value="${guestProfile.phone}" placeholder="Nhập số điện thoại">
                                </div>
                                <div class="candidate-field">
                                    <label for="gender">Giới tính</label>
                                    <select class="candidate-select" id="gender" name="gender">
                                        <option value="">Chọn giới tính</option>
                                        <option value="Nam" ${guestProfile.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                        <option value="Nữ" ${guestProfile.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                        <option value="Khác" ${guestProfile.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>
                                <div class="candidate-field">
                                    <label for="dateOfBirth">Ngày sinh</label>
                                    <input class="candidate-input" id="dateOfBirth" name="dateOfBirth" type="date" value="${guestProfile.dateOfBirth}">
                                </div>
                                <div class="candidate-field">
                                    <label for="avatar">Liên kết ảnh đại diện</label>
                                    <input class="candidate-input" id="avatar" name="avatar" value="${guestProfile.avatar}" placeholder="https://...">
                                </div>
                            </div>

                            <div class="candidate-field">
                                <label for="address">Địa chỉ</label>
                                <textarea class="candidate-textarea" id="address" name="address" placeholder="Nhập địa chỉ hiện tại">${guestProfile.address}</textarea>
                            </div>

                            <div class="candidate-actions">
                                <button class="candidate-btn" type="submit"><i class="fa-solid fa-floppy-disk"></i> Lưu hồ sơ</button>
                                <a class="candidate-btn outline" href="${pageContext.request.contextPath}/guest/applications">Xem đơn ứng tuyển</a>
                            </div>
                        </form>
                    </div>
                </section>

                <aside class="candidate-right">
                    <section class="candidate-card">
                        <div class="candidate-card-body candidate-profile-card">
                            <div class="candidate-avatar">
                                <c:choose>
                                    <c:when test="${not empty guestProfile.avatar}">
                                        <img src="${guestProfile.avatar}" alt="Ảnh đại diện">
                                    </c:when>
                                    <c:otherwise>B</c:otherwise>
                                </c:choose>
                            </div>
                            <h2>${guestProfile.fullName}</h2>
                            <p>${currentUser.email}</p>
                            <span class="candidate-status candidate-profile-badge">Tài khoản ứng viên</span>

                            <div class="candidate-profile-meta">
                                <p><strong>Điện thoại</strong><span>${empty guestProfile.phone ? 'Chưa cập nhật' : guestProfile.phone}</span></p>
                                <p><strong>Giới tính</strong><span>${empty guestProfile.gender ? 'Chưa cập nhật' : guestProfile.gender}</span></p>
                                <p><strong>Ngày sinh</strong><span>${empty guestProfile.dateOfBirth ? 'Chưa cập nhật' : guestProfile.dateOfBirth}</span></p>
                                <p><strong>Địa chỉ</strong><span>${empty guestProfile.address ? 'Chưa cập nhật' : guestProfile.address}</span></p>
                            </div>
                        </div>
                    </section>

                    <section class="candidate-card">
                        <div class="candidate-card-body">
                            <h3 class="candidate-profile-section-title">Tiến độ hồ sơ</h3>
                            <div class="candidate-progress">
                                <div class="candidate-progress-ring"><span>85%</span></div>
                                <div>
                                    <strong>Sắp hoàn thành!</strong>
                                    <p class="candidate-muted candidate-tight-text">Bổ sung đầy đủ thông tin giúp HR xử lý nhanh hơn.</p>
                                </div>
                            </div>
                        </div>
                    </section>
                </aside>
            </div>
        </section>
    </main>
</div>
</body>
</html>

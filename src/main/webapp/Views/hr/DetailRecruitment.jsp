<%-- 
    Document   : DetailRecruitment
    Created on : Oct 30, 2025, 11:54:21 AM
    Author     : DELL
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HRM - Edit Recruitment</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/flag-icon-css/7.2.3/css/flag-icons.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <style>
            /* Sao chép toàn bộ style từ trang mẫu để giữ giao diện nhất quán */
            :root {
                --primary-color: #2563eb;
                --secondary-color: #1e40af;
                --accent-color: #3b82f6;
                --success-color: #10b981;
                --warning-color: #f59e0b;
                --danger-color: #ef4444;
                --dark-color: #1f2937;
                --light-color: #f8fafc;
                --text-color: #374151;
                --text-muted: #6b7280;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                line-height: 1.6;
                color: var(--text-color);
                background-color: var(--light-color);
            }

            /* Top Functional Bar */
            .top-bar {
                background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
                color: white;
                padding: 0.75rem 0;
                font-size: 0.875rem;
                border-bottom: 1px solid rgba(255,255,255,0.1);
                position: relative;
                z-index: 1000;
            }

            .top-bar::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: linear-gradient(90deg, transparent 0%, rgba(255,255,255,0.05) 50%, transparent 100%);
                pointer-events: none;
            }

            .top-bar .container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                position: relative;
                z-index: 1;
            }

            .top-nav {
                display: flex;
                align-items: center;
                gap: 2.5rem;
            }

            .top-nav a {
                color: rgba(255, 255, 255, 0.85);
                text-decoration: none;
                font-weight: 500;
                font-size: 0.9rem;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                display: flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.5rem 1rem;
                border-radius: 8px;
                position: relative;
            }

            .top-nav a::before {
                content: '';
                position: absolute;
                bottom: -2px;
                left: 50%;
                width: 0;
                height: 2px;
                background: linear-gradient(90deg, #3b82f6, #8b5cf6);
                transition: all 0.3s ease;
                transform: translateX(-50%);
            }

            .top-nav a:hover {
                color: white;
                background: rgba(255, 255, 255, 0.1);
                transform: translateY(-1px);
            }

            .top-nav a:hover::before {
                width: 80%;
            }

            .social-icons {
                display: flex;
                align-items: center;
                gap: 1.25rem;
            }

            .social-icons a {
                color: rgba(255, 255, 255, 0.75);
                font-size: 1.1rem;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                text-decoration: none;
                padding: 0.5rem;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                width: 36px;
                height: 36px;
            }

            .social-icons a:hover {
                color: white;
                background: rgba(255, 255, 255, 0.15);
                transform: translateY(-2px) scale(1.1);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            }

            .search-container {
                display: flex;
                align-items: center;
                background: rgba(255, 255, 255, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 30px;
                padding: 0.5rem 1.25rem;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                backdrop-filter: blur(10px);
                position: relative;
                overflow: hidden;
            }

            .search-container::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
                transition: left 0.5s ease;
            }

            .search-container:hover {
                background: rgba(255, 255, 255, 0.15);
                border-color: rgba(255, 255, 255, 0.3);
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }

            .search-container:hover::before {
                left: 100%;
            }

            .search-container input {
                background: transparent;
                border: none;
                color: white;
                outline: none;
                width: 220px;
                padding: 0.25rem 0.75rem;
                font-size: 0.9rem;
                font-weight: 400;
            }

            .search-container input::placeholder {
                color: rgba(255, 255, 255, 0.6);
                font-weight: 400;
            }

            .search-container button {
                background: none;
                border: none;
                color: rgba(255, 255, 255, 0.8);
                cursor: pointer;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                padding: 0.25rem;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                width: 32px;
                height: 32px;
            }

            .search-container button:hover {
                color: white;
                background: rgba(255, 255, 255, 0.1);
                transform: scale(1.1);
            }

            /* Header */
            .header {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                color: white;
                padding: 1rem 0;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .navbar-brand {
                font-size: 1.5rem;
                font-weight: 700;
                color: white !important;
            }

            .nav-link {
                color: rgba(255, 255, 255, 0.9) !important;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .nav-link:hover {
                color: white !important;
                transform: translateY(-1px);
            }

            /* Profile Dropdown Styles */
            .profile-dropdown {
                position: relative;
                display: inline-block;
            }

            .profile-avatar {
                width: 35px;
                height: 35px;
                border-radius: 50%;
                background: linear-gradient(135deg, #3b82f6, #1d4ed8);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
                border: 2px solid rgba(255, 255, 255, 0.2);
            }

            .profile-avatar:hover {
                transform: scale(1.1);
                box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
            }

            .profile-dropdown-menu {
                position: absolute;
                top: 100%;
                right: 0;
                background: white;
                border-radius: 12px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
                min-width: 200px;
                z-index: 1000;
                opacity: 0;
                visibility: hidden;
                transform: translateY(-10px);
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                border: 1px solid rgba(0, 0, 0, 0.1);
            }

            .profile-dropdown-menu.show {
                opacity: 1;
                visibility: visible;
                transform: translateY(0);
            }

            .profile-dropdown-item {
                display: flex;
                align-items: center;
                padding: 12px 16px;
                color: #374151;
                text-decoration: none;
                transition: all 0.2s ease;
                border-bottom: 1px solid #f3f4f6;
            }

            .profile-dropdown-item:last-child {
                border-bottom: none;
            }

            .profile-dropdown-item:hover {
                background: #f8fafc;
                color: #1f2937;
                text-decoration: none;
            }

            .profile-dropdown-item i {
                margin-right: 10px;
                width: 16px;
                text-align: center;
            }

            .profile-dropdown-item.logout {
                color: #dc2626;
            }

            .profile-dropdown-item.logout:hover {
                background: #fef2f2;
                color: #b91c1c;
            }

            /* Footer */
            .footer {
                background: var(--dark-color);
                color: white;
                padding: 40px 0 20px;
                margin-top: 40px;
            }

            .footer-title {
                font-size: 1.5rem;
                font-weight: 700;
                margin-bottom: 1rem;
            }

            .footer-link {
                color: rgba(255, 255, 255, 0.8);
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .footer-link:hover {
                color: white;
            }

            /* Custom style for the main content area */
            .main-content-area {
                min-height: 60vh;
                padding: 40px 0;
            }
        </style>
    </head>
    <body>
        <!-- Top Functional Bar (Giữ nguyên từ trang mẫu) -->
        <div class="top-bar">
            <div class="container">
                <nav class="top-nav" role="navigation" aria-label="Top navigation">
                    <a href="${pageContext.request.contextPath}/home.jsp" aria-label="Go to Home section">
                        <i class="fas fa-home" aria-hidden="true"></i>
                        <span>Home</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/candidates" aria-label="Go to Candidate List">
                        <i class="fas fa-users" aria-hidden="true"></i>
                        <span>ViewCandidate</span>
                    </a>
                </nav>
                <aside class="social-icons" aria-label="Social media links">
                    <a href="https://www.facebook.com/ucvan.254010" target="_blank" rel="noopener noreferrer" title="Follow us on Facebook" aria-label="Facebook">
                        <i class="fab fa-facebook-f" aria-hidden="true"></i>
                    </a>
                    <a href="https://www.linkedin.com/in/%C4%91%E1%BB%A9c-v%C4%83n-46045537b/" target="_blank" rel="noopener noreferrer" title="Connect with us on LinkedIn" aria-label="LinkedIn">
                        <i class="fab fa-linkedin-in" aria-hidden="true"></i>
                    </a>
                    <a href="https://www.instagram.com/ducvan04/" target="_blank" rel="noopener noreferrer" title="Follow us on Instagram" aria-label="Instagram">
                        <i class="fab fa-instagram" aria-hidden="true"></i>
                    </a>
                </aside>
                <div class="search-container" role="search" aria-label="Search the website">
                    <label for="searchInput" class="sr-only">Search the website</label>
                    <input type="text" id="searchInput" placeholder="Search..." aria-label="Search the website" autocomplete="off" spellcheck="false">
                    <button type="button" onclick="performSearch()" aria-label="Search" title="Search">
                        <i class="fas fa-search" aria-hidden="true"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- Header (Giữ nguyên từ trang mẫu) -->
        <header class="header">
            <nav class="navbar navbar-expand-lg" aria-label="Main navigation">
                <div class="container">
                    <a class="navbar-brand" href="#">
                        <i class="fas fa-users-cog me-2"></i>Human Resources Management
                    </a>
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <ul class="navbar-nav ms-auto">
                            <li class="nav-item">
                                <a class="nav-link" href="mailto:ducnvhe180815@gmail.com">
                                    <i class="fas fa-envelope me-1"></i>ducnvhe180815@gmail.com
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="tel:0123456789">
                                    <i class="fas fa-phone me-1"></i>0818886875
                                </a>
                            </li>
                            <li class="nav-item">
                                <c:if test="${not empty sessionScope.systemUser}">
                                    <div class="profile-dropdown">
                                        <div class="profile-avatar" onclick="toggleProfileDropdown()" title="Profile Menu">
                                            <i class="fas fa-user"></i>
                                        </div>
                                        <div class="profile-dropdown-menu" id="profileDropdown">
                                            <a href="${pageContext.request.contextPath}/profilepage" class="profile-dropdown-item">
                                                <i class="fas fa-user"></i> Profile
                                            </a>
                                            <a href="${pageContext.request.contextPath}/Admin/AdminHome.jsp" class="profile-dropdown-item">
                                                <i class="fas fa-tachometer-alt"></i> Dashboard
                                            </a>
                                            <a href="${pageContext.request.contextPath}/Views/ChangePassword.jsp" class="profile-dropdown-item">
                                                <i class="fas fa-key"></i> Change Password
                                            </a>
                                            <a href="javascript:void(0)" onclick="handleLogout()" class="profile-dropdown-item logout">
                                                <i class="fas fa-sign-out-alt"></i> Logout
                                            </a>
                                        </div>
                                    </div>
                                </c:if>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
        </header>

        <!-- MAIN CONTENT AREA -->
        <main class="main-content-area">
            <div class="container">
                <!-- Nút Back và Tiêu đề trang -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1 class="h2">Edit Recruitment Details</h1>
                    <a href="${pageContext.request.contextPath}/postRecruitments" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-1"></i> Back to List
                    </a>
                </div>

                <!-- FORM CHỈNH SỬA -->
                <div class="card">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/detailRecruitment" method="post">
                            <input type="hidden" name="id" value="${rec.recruitmentId}">
                            <input type="hidden" name="status" value="${rec.status}"

                                   <div class="mb-3">
                            <label for="titleInput" class="form-label">Title</label>
                            <input type="text" class="form-control" id="titleInput" name="Title" value="${rec.title}" placeholder="Enter recruitment title" maxlength="50" required>
                            </div>

                            <div class="mb-3">
                                <label for="descriptionInput" class="form-label">Description</label>
                                <textarea class="form-control" id="descriptionInput" name="Description" placeholder="Enter detailed description" maxlength="1000" rows="5" required>${rec.description}</textarea>
                            </div>

                            <div class="mb-3">
                                <label for="requirementInput" class="form-label">Requirement</label>
                                <input type="text" class="form-control" id="requirementInput" name="Requirement" value="${rec.requirement}" placeholder="Enter key requirements" maxlength="50" required>
                            </div>

                            <div class="mb-3">
                                <label for="locationInput" class="form-label">Location</label>
                                <input type="text" class="form-control" id="locationInput" name="Location" value="${rec.location}" placeholder="Enter job location" maxlength="50" required>
                            </div>

                            <div class="mb-3">
                                <label for="locationInput" class="form-label">Applicant</label>
                                <input type="number" class="form-control" id="applicantInput" name="Applicant" value="${rec.applicant}" placeholder="Enter job applicant" step="1" required>
                            </div>

                            <div class="mb-3">
                                <label for="salaryInput" class="form-label">Salary</label>
                                <div class="input-group">
                                    <input type="number" class="form-control" id="salaryInput" name="Salary" value="${rec.salary}" placeholder="Enter salary" required>
                                    <span class="input-group-text">đ</span>
                                </div>
                            </div>
                            <c:if test="${not empty mess}">
                                <p style="color: red; font-size: 20px;">${mess}</p>
                            </c:if>            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <c:if test="${rec.status ne 'Deleted'}">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-1"></i> Save Changes
                                    </button>
                                </c:if>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer (Giữ nguyên từ trang mẫu) -->
        <footer class="footer">
            <div class="container">
                <div class="row">
                    <div class="col-lg-4">
                        <h5 class="footer-title">Human Resources Management</h5>
                        <p>We are committed to providing the best solutions for customers with professional team and extensive experience.</p>
                    </div>
                    <div class="col-lg-2">
                        <h6>Quick Links</h6>
                        <ul class="list-unstyled">
                            <li><a href="#about" class="footer-link">About Us</a></li>
                            <li><a href="#contact" class="footer-link">Contact</a></li>
                        </ul>
                    </div>
                    <div class="col-lg-3">
                        <h6>Contact Information</h6>
                        <ul class="list-unstyled">
                            <li><i class="fas fa-phone me-2"></i>0818886875</li>
                            <li><i class="fas fa-envelope me-2"></i>ducnvhe180815@gmail.com</li>
                            <li><i class="fas fa-map-marker-alt me-2"></i>Hà Nội</li>
                        </ul>
                    </div>
                </div>
                <hr class="my-4" style="border-color: rgba(255,255,255,0.1);">
                <div class="row">
                    <div class="col-12 text-center">
                        <p>&copy; 2024 Human Resources Management. All rights reserved.</p>
                    </div>
                </div>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                // Copy các hàm JS cần thiết từ trang mẫu
                                                function handleLogout() {
                                                    if (confirm('Are you sure you want to logout?')) {
                                                        window.location.href = '${pageContext.request.contextPath}/logout';
                                                    }
                                                }
                                                function toggleProfileDropdown() {
                                                    const dropdown = document.getElementById('profileDropdown');
                                                    if (dropdown) {
                                                        dropdown.classList.toggle('show');
                                                    }
                                                }
                                                document.addEventListener('click', function (event) {
                                                    const profileDropdown = document.getElementById('profileDropdown');
                                                    const profileAvatar = document.querySelector('.profile-avatar');
                                                    if (profileDropdown && profileAvatar && !profileAvatar.contains(event.target) && !profileDropdown.contains(event.target)) {
                                                        profileDropdown.classList.remove('show');
                                                    }
                                                });
        </script>
    </body>
</html>
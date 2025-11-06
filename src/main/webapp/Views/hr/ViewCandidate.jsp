<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HRM - Candidate List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/flag-icon-css/7.2.3/css/flag-icons.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <style>
            /* HR Dashboard Styles - Đồng bộ với các trang HR khác */
            :root {
                --primary-color: #667eea;
                --secondary-color: #764ba2;
                --accent-color: #3b82f6;
                --success-color: #10b981;
                --warning-color: #f59e0b;
                --danger-color: #ef4444;
                --dark-color: #1f2937;
                --light-color: #f8f9fa;
                --text-color: #374151;
                --text-muted: #6b7280;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                line-height: 1.6;
                color: var(--text-color);
                background-color: var(--light-color);
            }
            
            /* HR Dashboard Container */
            .hr-dashboard-container {
                min-height: 100vh;
                background-color: var(--light-color);
            }
            
            /* Header */
            .hr-header {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                color: white;
                padding: 1rem 0;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            
            .header-content {
                max-width: 1400px;
                margin: 0 auto;
                padding: 0 2rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .logo-section {
                display: flex;
                align-items: center;
                gap: 1rem;
            }
            
            .logo-section i {
                font-size: 2rem;
            }
            
            .logo-section h1 {
                font-size: 1.8rem;
                font-weight: 600;
                margin: 0;
            }
            
            .header-actions {
                display: flex;
                align-items: center;
                gap: 1rem;
            }
            
            .search-box {
                display: flex;
                align-items: center;
                background: rgba(255,255,255,0.2);
                border-radius: 25px;
                padding: 0.5rem 1rem;
                gap: 0.5rem;
            }
            
            .search-box input {
                background: transparent;
                border: none;
                color: white;
                outline: none;
                font-size: 0.9rem;
                width: 200px;
            }
            
            .search-box input::placeholder {
                color: rgba(255, 255, 255, 0.7);
            }
            
            .notification-bell {
                position: relative;
                background: rgba(255,255,255,0.2);
                border-radius: 50%;
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s ease;
            }
            
            .notification-bell:hover {
                background: rgba(255,255,255,0.3);
            }
            
            .notification-count {
                position: absolute;
                top: -5px;
                right: -5px;
                background: var(--danger-color);
                color: white;
                border-radius: 50%;
                width: 20px;
                height: 20px;
                font-size: 0.7rem;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 600;
            }
            
            .user-profile {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                background: rgba(255,255,255,0.2);
                padding: 0.5rem 1rem;
                border-radius: 25px;
                cursor: pointer;
                transition: all 0.3s ease;
            }
            
            .user-profile:hover {
                background: rgba(255,255,255,0.3);
            }
            
            .user-profile img {
                width: 32px;
                height: 32px;
                border-radius: 50%;
            }
            
            .btn-homepage {
                background: rgba(255,255,255,0.2);
                color: white;
                padding: 0.5rem 1rem;
                border-radius: 25px;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                transition: all 0.3s ease;
                border: 1px solid rgba(255,255,255,0.3);
            }
            
            .btn-homepage:hover {
                background: rgba(255,255,255,0.3);
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
                color: white;
            }
            
            /* Main Content Layout */
            .hr-main-content {
                display: flex;
                max-width: 1400px;
                margin: 0 auto;
                padding: 2rem;
                gap: 2rem;
            }
            
            /* Sidebar */
            .hr-sidebar {
                width: 280px;
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                padding: 1.5rem;
                height: fit-content;
            }
            
            .nav-section {
                margin-bottom: 2rem;
            }
            
            .nav-section h3 {
                font-size: 0.8rem;
                font-weight: 600;
                color: var(--text-muted);
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 1rem;
            }
            
            .nav-item {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                padding: 0.75rem 1rem;
                border-radius: 8px;
                text-decoration: none;
                color: var(--text-muted);
                transition: all 0.3s ease;
                font-weight: 500;
                margin-bottom: 0.5rem;
            }
            
            .nav-item:hover {
                background: #f1f5f9;
                color: var(--primary-color);
                transform: translateX(4px);
                text-decoration: none;
            }
            
            .nav-item.active {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                color: white;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            }
            
            .nav-item i {
                font-size: 1.1rem;
                width: 20px;
                text-align: center;
            }
            
            /* Content Area */
            .hr-content-area {
                flex: 1;
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                padding: 2rem;
                min-height: 600px;
            }
            
            .table-actions a {
                text-decoration: none;
                margin-right: 10px;
            }
            
            .table-actions .material-icons {
                vertical-align: middle;
            }
            
            /* Responsive Design */
            @media (max-width: 768px) {
                .hr-main-content {
                    flex-direction: column;
                    padding: 1rem;
                }
                
                .hr-sidebar {
                    width: 100%;
                    margin-bottom: 1rem;
                }
                
                .header-content {
                    flex-direction: column;
                    gap: 1rem;
                    padding: 0 1rem;
                }
                
                .header-actions {
                    flex-wrap: wrap;
                    justify-content: center;
                }
                
                .search-box input {
                    width: 150px;
                }
            }
        </style>
    </head>
    <body>
        <div class="hr-dashboard-container">
            <!-- Header -->
            <header class="hr-header">
                <div class="header-content">
                    <div class="logo-section">
                        <i class="fas fa-users-cog"></i>
                        <h1>Candidate List</h1>
                    </div>
                    <div class="header-actions">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" placeholder="Search candidates...">
                        </div>
                        <div class="notification-bell">
                            <i class="fas fa-bell"></i>
                            <span class="notification-count">3</span>
                        </div>
                        <div class="user-profile">
                            <img src="https://i.pravatar.cc/40" alt="HR User">
                            <span>HR Manager</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <a href="${pageContext.request.contextPath}/Views/hr/HrHome.jsp" class="btn-homepage" title="Back to HR Dashboard">
                            <i class="fas fa-home"></i>
                            <span>HR Dashboard</span>
                        </a>
                    </div>
                </div>
            </header>

            <!-- Main Content -->
            <main class="hr-main-content">
                <!-- Sidebar -->
                <aside class="hr-sidebar">
                    <nav class="hr-nav">
                        <div class="nav-section">
                            <h3>Navigation</h3>
                            <a href="${pageContext.request.contextPath}/Views/hr/HrHome.jsp" class="nav-item">
                                <i class="fas fa-home"></i>
                                <span>HR Dashboard</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/ProfileManagementController" class="nav-item">
                                <i class="fas fa-user-edit"></i>
                                <span>Profile Management</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/hr/employee-list" class="nav-item">
                                <i class="fas fa-users"></i>
                                <span>Employee List</span>
                            </a>
                        </div>
                        
                        <div class="nav-section">
                            <h3>Recruitment</h3>
                            <a href="${pageContext.request.contextPath}/postRecruitments" class="nav-item">
                                <i class="fas fa-bullhorn"></i>
                                <span>Post Recruitment</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/viewRecruitment" class="nav-item">
                                <i class="fas fa-eye"></i>
                                <span>View Recruitment</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/candidates" class="nav-item active">
                                <i class="fas fa-user-plus"></i>
                                <span>View Candidates</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/hr/create-employee" class="nav-item">
                                <i class="fas fa-user-plus"></i>
                                <span>Create Employee</span>
                            </a>
                        </div>
                    </nav>
                </aside>

                <!-- Content Area -->
                <div class="hr-content-area">

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1 class="h2">Candidate List</h1>
                </div>
                <!-- ===== BỘT LỌC VÀ TÌM KIẾM MỚI ===== -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/candidates" method="GET" class="row g-3 align-items-end">
                            <!-- Cột tìm kiếm theo tên -->
                            <div class="col-md-3">
                                <label class="form-label">Search by Name</label>
                                <input type="text" class="form-control" name="searchByName" placeholder="Enter..." value="${param.searchByName}">
                            </div>

                            <!-- Cột lọc theo trạng thái -->
                            <div class="col-md-2">
                                <label class="form-label">Status</label>
                                <select class="form-select" id="filterStatus" name="filterStatus">
                                    <option value="">All</option>
                                    <option value="processing" <c:if test="${param.filterStatus eq 'processing'}">selected</c:if>>Processing</option>
                                    <option value="hired" <c:if test="${param.filterStatus eq 'hired'}">selected</c:if>>Hired</option>
                                    <option value="rejected" <c:if test="${param.filterStatus eq 'rejected'}">selected</c:if>>Rejected</option>
                                    </select>
                                </div>

                                <!-- Cột ngày bắt đầu -->
                                <div class="col-md-2">
                                    <label class="form-label">Start Date</label>
                                    <input type="date" class="form-control" id="startDate" name="startDate" value="${param.startDate}">
                            </div>

                            <!-- Cột ngày kết thúc -->
                            <div class="col-md-2">
                                <label class="form-label">End Date</label>
                                <input type="date" class="form-control" id="endDate" name="endDate" value="${param.endDate}">
                            </div>

                            <!-- Cột nút Apply -->
                            <div class="col-md-auto d-flex gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-filter me-1"></i> Apply Filter
                                </button>
                                <!-- Nút Clear dùng thẻ a -->
                                <a href="${pageContext.request.contextPath}/candidates" class="btn btn-secondary">
                                    <i class="fas fa-times me-1"></i> Clear
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
                <!-- ===== KẾT THÚC BỘ LỌC ===== -->
                <!-- BẢNG DỮ LIỆU ỨNG VIÊN -->
                <div class="table-responsive">
                    <table class="table table-striped table-sm">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>CV</th>
                                <th>Applied at</th>
                                <th>Status</th>
                                <th>ID Recruitment</th>
<!--                                <th>Action</th>-->
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="g" items="${guest}">
                                <tr>
                                    <td>${g.guestId}</td>
                                    <td>${g.fullName}</td>
                                    <td>${g.email}</td>
                                    <td>${g.phone}</td>
                                    <td> <a href="${pageContext.request.contextPath}/viewCV?guestId=${g.guestId}">View️</a></td>
                                    <td>${g.appliedDate}</td>
                                    <td>${g.status}</td>
                                    <td>${g.recruitmentId}</td>
<!--                                    <td class="table-actions">
                                        <c:if test="${g.status eq 'Processing'}">
                                            <form action="${pageContext.request.contextPath}/candidates" method="post" style="display: inline;">
                                                <input name="action" value="apply" type="hidden">
                                                <input name="guestId" value="${g.guestId}" type="hidden">
                                                <button type="submit" class="btn btn-sm btn-success" title="Apply">
                                                    Apply
                                                </button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/candidates" method="post" style="display: inline;">
                                                <input name="action" value="reject" type="hidden">
                                                <input name="guestId" value="${g.guestId}" type="hidden">
                                                <button type="submit" class="btn btn-sm btn-danger" title="Reject">
                                                    Reject
                                                </button>
                                            </form>
                                        </c:if>
                                    </td>-->
                                </tr>
                            </c:forEach>
                            <c:if test="${not empty mess}">
                                <tr>
                                    <td colspan="8" class="text-center">
                                        <p style="color: red; font-size: 20px;">${mess}</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!--Phân trang-->
                <!--Phân trang-->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation candidate list" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <!-- Nút Previous -->
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/candidates?page=${currentPage - 1}&searchByName=${param.searchByName}&filterStatus=${param.filterStatus}&startDate=${param.startDate}&endDate=${param.endDate}" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                            </c:if>

                            <!-- Các số trang -->
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${currentPage == i}">
                                        <li class="page-item active" aria-current="page">
                                            <span class="page-link">${i}</span>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="page-item">
                                            <a class="page-link" href="${pageContext.request.contextPath}/candidates?page=${i}&searchByName=${param.searchByName}&filterStatus=${param.filterStatus}&startDate=${param.startDate}&endDate=${param.endDate}">${i}</a>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <!-- Nút Next -->
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/candidates?page=${currentPage + 1}&searchByName=${param.searchByName}&filterStatus=${param.filterStatus}&startDate=${param.startDate}&endDate=${param.endDate}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
                </div>
            </main>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function performSearch() {
                const searchInput = document.getElementById('searchInput');
                if (searchInput) {
                    alert('Search functionality for "' + searchInput.value + '" is not yet implemented.');
                }
            }
        </script>
    </body>
</html>

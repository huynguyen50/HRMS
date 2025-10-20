<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HRM - Form nhân viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
        }
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            min-height: 100vh;
            color: white;
        }
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 12px 20px;
            margin: 5px 10px;
            border-radius: 10px;
            transition: all 0.3s;
        }
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
        }
        .main-content {
            padding: 20px;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 d-md-block sidebar collapse">
            <div class="position-sticky pt-3">
                <div class="text-center mb-4">
                    <h4><i class="fas fa-users-cog me-2"></i>HRM System</h4>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/Views/Home.jsp">
                            <i class="fas fa-home me-2"></i> Trang chủ
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/Views/Dashboard.jsp">
                            <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/employee-list">
                            <i class="fas fa-users me-2"></i> Danh sách nhân viên
                        </a>
                    </li>
                     <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/employee-form">
                            <i class="fas fa-user-plus me-2"></i> Thêm nhân viên
                        </a>
                    </li>
                </ul>
                <hr class="text-white-50">
                 <div class="user-info p-3 d-flex align-items-center">
                    <div class="user-avatar me-2">
                       <i class="fas fa-user-circle fa-2x"></i>
                    </div>
                    <div>
                        <div class="fw-bold">${sessionScope.systemUser.username}</div>
                    </div>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/profile">
                            <i class="fas fa-user me-2"></i> Hồ sơ
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/change-password">
                            <i class="fas fa-key me-2"></i> Đổi mật khẩu
                        </a>
                    </li>
                    <li class="nav-item">
                         <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
            <h1 class="h2">${employee != null ? "Sửa thông tin nhân viên" : "Thêm nhân viên mới"}</h1>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success" role="alert">${success}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/employees" method="post" enctype="multipart/form-data" novalidate>
                <input type="hidden" name="id" value="${employee.employeeId}" />

                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header bg-white">
                                <strong>Thông tin cá nhân</strong>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label for="fullName" class="form-label">Họ và tên</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" value="${employee.fullName}" required>
                                    <div class="form-text">Nhập họ và tên đầy đủ.</div>
                                </div>
                                <div class="mb-3">
                                    <label for="gender" class="form-label">Giới tính</label>
                                    <select class="form-select" id="gender" name="gender" required>
                                        <option value="Male" ${employee.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                        <option value="Female" ${employee.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="dob" class="form-label">Ngày sinh</label>
                                    <input type="date" class="form-control" id="dob" name="dob" value="<fmt:formatDate value='${employee.dob}' pattern='yyyy-MM-dd'/>" required>
                                </div>
                                <div class="mb-3">
                                    <label for="address" class="form-label">Địa chỉ</label>
                                    <input type="text" class="form-control" id="address" name="address" value="${employee.address}" required>
                                </div>
                                <div class="mb-3">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="text" class="form-control" id="phone" name="phone" value="${employee.phone}" required pattern="[0-9]{10}" placeholder="VD: 0912345678">
                                    <div class="form-text">10 chữ số.</div>
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" value="${employee.email}" required>
                                </div>
                                <div class="mb-3">
                                    <label for="avatar" class="form-label">Ảnh đại diện (tùy chọn)</label>
                                    <input class="form-control" type="file" id="avatar" name="avatar" accept="image/*">
                                    <c:if test="${not empty employee.avatarPath}">
                                        <div class="mt-2">
                                            <img src="${employee.avatarPath}" alt="Avatar" class="img-thumbnail" style="max-height: 120px;">
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header bg-white">
                                <strong>Thông tin công việc</strong>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label for="departmentId" class="form-label">Phòng ban</label>
                                    <select class="form-select" id="departmentId" name="departmentId" required>
                                        <option value="" ${empty employee.departmentId ? 'selected' : ''} disabled>-- Chọn phòng ban --</option>
                                        <c:forEach var="dept" items="${departments}">
                                            <option value="${dept.departmentId}" ${employee.departmentId == dept.departmentId ? 'selected' : ''}>${dept.deptName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="position" class="form-label">Chức vụ</label>
                                    <input type="text" class="form-control" id="position" name="position" value="${employee.position}" required>
                                </div>
                                <div class="mb-3">
                                    <label for="hireDate" class="form-label">Ngày vào làm</label>
                                    <input type="date" class="form-control" id="hireDate" name="hireDate" value="<fmt:formatDate value='${employee.hireDate}' pattern='yyyy-MM-dd'/>" required>
                                </div>
                                <div class="mb-3">
                                    <label for="salary" class="form-label">Lương</label>
                                    <input type="number" class="form-control" id="salary" name="salary" value="${employee.salary}" required min="0" step="0.01">
                                </div>
                                <div class="form-check mb-3">
                                    <input class="form-check-input" type="checkbox" id="active" name="active" value="true" ${employee.active ? "checked" : ""}>
                                    <label class="form-check-label" for="active">Hoạt động</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mt-4 d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> Lưu
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/employees" class="btn btn-secondary">Hủy</a>
                </div>
            </form>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

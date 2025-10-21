<%-- 
    Document   : PostRecruitment
    Created on : Oct 20, 2025, 11:44:30 AM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    request.setAttribute("pageTitle", "Đăng tin tuyển dụng - HRMS");
%>

<!DOCTYPE html>
<html lang="vi">
    <%@ include file="/includes/header.jsp" %>
    <body>
        <div class="container">
            <div class="page-header">
                <h1><i class="fas fa-user-plus"></i> Đăng tin tuyển dụng</h1>
                <p>Tạo và đăng tin tuyển dụng mới</p>
            </div>
            
            <div class="recruitment-form-container">
                <form class="recruitment-form" method="post" action="PostRecruitmentController">
                    <div class="form-group">
                        <label for="title"><i class="fas fa-heading"></i> Tiêu đề:</label>
                        <input type="text" id="title" name="title" class="form-input" placeholder="VD: Senior Java Developer" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="description"><i class="fas fa-align-left"></i> Mô tả công việc:</label>
                        <textarea id="description" name="description" class="form-textarea" placeholder="Mô tả chi tiết về công việc..." required></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="requirement"><i class="fas fa-list-check"></i> Yêu cầu ứng viên:</label>
                        <textarea id="requirement" name="requirement" class="form-textarea" placeholder="Các yêu cầu về kỹ năng, kinh nghiệm..." required></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="location"><i class="fas fa-map-marker-alt"></i> Địa điểm:</label>
                            <input type="text" id="location" name="location" class="form-input" placeholder="VD: Hà Nội" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="salary"><i class="fas fa-money-bill-wave"></i> Mức lương:</label>
                            <input type="text" id="salary" name="salary" class="form-input" placeholder="VD: 20,000,000 - 30,000,000 VNĐ" required>
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn-secondary" onclick="history.back()">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </button>
                        <button type="submit" class="btn-primary">
                            <i class="fas fa-save"></i> Đăng tin
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <%@ include file="/includes/footer.jsp" %>
    </body>
</html>

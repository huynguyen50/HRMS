<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Xem CV Ứng viên</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f0f2f5;
            }
            .cv-container {
                margin-top: 50px;
                padding: 20px;
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                text-align: center;
            }
            .cv-image {
                max-width: 100%;
                height: auto;
                border: 1px solid #ddd;
                border-radius: 4px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="cv-container">
                <h2>CV's ${g.fullName}</h2>
                <hr>
                <img src="${g.cv}" alt="CV Image" class="cv-image">
                Name: <p>${g.fullName}</p>
                Email: <p>${g.email}</p>
                Phone: <p>${g.phone}</p>
                Status: <p>${g.status}</p>
                Applied at: <p>${g.appliedDate}</p>
                <c:if test="${g.status eq 'processing'}">
                    <form action="${pageContext.request.contextPath}/candidates" method="post" style="display: inline;">
                        <input name="action" value="apply" type="hidden">
                        <input nam  e="guestId" value="${g.guestId}" type="hidden">
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
                <hr>
                <a href="javascript:history.back()" class="btn btn-secondary">Back</a>
            </div>
        </div>
    </body>
</html>

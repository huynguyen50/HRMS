<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.hrm.model.entity.Contract" %>
<%
    Contract c = (Contract) request.getAttribute("contract");
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thông tin hợp đồng</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f4f7fc;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 600px;
            margin: 50px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            padding: 30px 40px;
        }
        h2 {
            text-align: center;
            color: #1e3a8a;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #cbd5e1;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #eff6ff;
            color: #1e3a8a;
        }
        a.button, button {
            display: inline-block;
            text-decoration: none;
            text-align: center;
            background-color: #2563eb;
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 6px;
            font-size: 15px;
            cursor: pointer;
            margin-top: 20px;
        }
        a.button:hover, button:hover {
            background-color: #1e40af;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>📄 Hợp đồng lao động</h2>

    <% if (c != null) { %>
        <table>
            <tr><th>Mã hợp đồng</th><td><%= c.getContractId() %></td></tr>
            <tr><th>Ngày bắt đầu</th><td><%= c.getStartDate() %></td></tr>
            <tr><th>Ngày kết thúc</th><td><%= c.getEndDate() %></td></tr>
            <tr><th>Lương cơ bản</th><td><%= c.getBaseSalary() %></td></tr>
            <tr><th>Phụ cấp</th><td><%= c.getAllowance() %></td></tr>
            <tr><th>Loại hợp đồng</th><td><%= c.getContractType() %></td></tr>
            <tr><th>Ghi chú</th><td><%= c.getNotes() %></td></tr>
        </table>
    <% } else { %>
        <p style="color:red;">Không tìm thấy hợp đồng cho nhân viên này.</p>
    <% } %>

    <div style="text-align:center;">
        <a class="button" href="<%= request.getContextPath() %>/viewPayroll">Xem bảng lương</a>
        <a class="button" href="<%= request.getContextPath() %>/EmployeeHome.jsp">⬅ Back</a>
    </div>
</div>
</body>
</html>

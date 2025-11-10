<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, com.hrm.model.entity.Payroll" %>
<%
    List<Payroll> payrolls = (List<Payroll>) request.getAttribute("payrolls");
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bảng lương nhân viên</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f4f7fc;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 700px;
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
    <h2>💰 Bảng lương của tôi</h2>

    <% if (payrolls != null && !payrolls.isEmpty()) { %>
        <table>
            <tr>
                <th>Kỳ trả lương</th>
                <th>Lương cơ bản</th>
                <th>Phụ cấp</th>
                <th>Thưởng</th>
                <th>Khấu trừ</th>
                <th>Lương thực nhận</th>
                <th>Ngày duyệt</th>
            </tr>
            <% for (Payroll p : payrolls) { %>
            <tr>
                <td><%= p.getPayPeriod() %></td>
                <td><%= p.getBaseSalary() %></td>
                <td><%= p.getAllowance() %></td>
                <td><%= p.getBonus() %></td>
                <td><%= p.getDeduction() %></td>
                <td><%= p.getNetSalary() %></td>
                <td><%= p.getApprovedDate() %></td>
            </tr>
            <% } %>
        </table>
    <% } else { %>
        <p style="color:red;">Không có dữ liệu bảng lương.</p>
    <% } %>

    <div style="text-align:center;">
        <a class="button" href="<%= request.getContextPath() %>/viewContract">⬅ Quay lại hợp đồng</a>
        <a class="button" href="<%= request.getContextPath() %>/EmployeeHome.jsp">⬅ Back</a>
    </div>
</div>
</body>
</html>

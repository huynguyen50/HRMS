
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Profile</title>
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
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            margin-top: 10px;
            font-weight: 600;
            color: #374151;
        }
        input, select, textarea {
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 15px;
        }
        input[readonly] {
            background-color: #f3f4f6;
            color: #6b7280;
        }
        button {
            margin-top: 20px;
            background-color: #2563eb;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
background-color: #1e40af;
        }
    </style>
    <script>
        function validateForm() {
            let phone = document.getElementById("phone").value.trim();
            let email = document.getElementById("email").value.trim();
            let department = document.getElementById("department").value.trim();

            const phoneRegex = /^[0-9]{10}$/;
            const emailRegex = /^[a-zA-Z0-9._%+-]+@gmail\.com$/;
            const depRegex = /^[1-9]$/;

            if (!phoneRegex.test(phone)) {
                alert("Số điện thoại phải có đúng 10 chữ số.");
                return false;
            }
            if (!emailRegex.test(email)) {
                alert("Email phải có dạng hợp lệ và kết thúc bằng @gmail.com.");
                return false;
            }
            if (!depRegex.test(department)) {
                alert("Department ID chỉ được chứa một chữ số từ 1 đến 9.");
                return false;
            }

            alert("Cập nhật thành công!");
            window.location.href = "EmployeeHome.jsp";
            return false;
        }
    </script>
</head>
<body>
<div class="container">
    <h2>Employee Profile</h2>
    <form onsubmit="return validateForm()">
        <label>Employee ID</label>
        <input type="text" id="empid" value="E001" readonly>

        <label>Full Name</label>
        <input type="text" id="fullname" value="Nguyễn Tất Đăng Huy" maxlength="150" readonly>

        <label>Gender</label>
        <select id="gender">
            <option value="Male" selected>Male</option>
            <option value="Female">Female</option>
        </select>

        <label>Date of Birth</label>
        <input type="date" id="dob">

        <label>Address</label>
        <textarea id="address" rows="3"></textarea>

        <label>Phone</label>
        <input type="text" id="phone" placeholder="Nhập 10 chữ số">

        <label>Email</label>
        <input type="email" id="email" placeholder="example@gmail.com">

        <label>Employment Period</label>
        <input type="text" id="period" placeholder="Nhập thời gian làm việc">

        <label>Department ID</label>
        <input type="text" id="department" placeholder="1-9">

        <label>Status</label>
        <select id="status">
            <option value="Active" selected>Active</option>
            <option value="Resigned">Resigned</option>
            <option value="Probation">Probation</option>
            <option value="Intern">Intern</option>
        </select>

        <label>Position</label>
        <input type="text" id="position" value="Employee" readonly>

        <button type="submit">Save</button>
    </form>
</div>
</body>
</html>

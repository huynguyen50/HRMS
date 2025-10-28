
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Leave Management</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
background-color: #f9fafb;
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
        button {
            margin-top: 20px;
            background-color: #16a34a;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background-color: #15803d;
        }
    </style>
    <script>
        function validateLeaveForm() {
            const empID = document.getElementById("empid").value.trim();
            const fullname = document.getElementById("fullname").value.trim();
            const address = document.getElementById("address").value.trim();
            const email = document.getElementById("email").value.trim();
            const startDate = document.getElementById("start").value;
            const endDate = document.getElementById("end").value;
            const contact = document.getElementById("contact").value.trim();

            const nameRegex = /^[A-Za-zÀ-ỹ\s]+$/;
            const addressRegex = /^[A-Za-zÀ-ỹ0-9\s,.-]+$/;
            const emailRegex = /^[a-zA-Z0-9._%+-]+@gmail\.com$/;
            const contactRegex = /^[0-9]{10}$/;

            if (empID === "") {
                alert("Vui lòng nhập Employee ID.");
                return false;
            }
            if (!nameRegex.test(fullname)) {
                alert("Full Name chỉ được chứa chữ cái.");
                return false;
            }
            if (!addressRegex.test(address)) {
                alert("Address chỉ được chứa chữ, số, dấu phẩy hoặc chấm.");
                return false;
            }
            if (!emailRegex.test(email)) {
                alert("Email phải đúng định dạng và kết thúc bằng @gmail.com.");
                return false;
            }
            if (!startDate || !endDate) {
                alert("Vui lòng nhập đầy đủ Start Date và End Date.");
                return false;
            }
            if (new Date(startDate) >= new Date(endDate)) {
                alert("Start Date phải nhỏ hơn End Date.");
                return false;
            }
if (!contactRegex.test(contact)) {
                alert("Số liên hệ trong kỳ nghỉ phải gồm đúng 10 chữ số.");
                return false;
            }

            alert("Gửi đơn nghỉ phép thành công!");
            window.location.href = "EmployeeHome.jsp";
            return false;
        }
    </script>
</head>
<body>
<div class="container">
    <h2>Leave Application Form</h2>
    <form onsubmit="return validateLeaveForm()">
        <label>Employee ID</label>
        <input type="text" id="empid" placeholder="Nhập mã nhân viên">

        <label>Full Name</label>
        <input type="text" id="fullname" placeholder="Chỉ được chứa chữ cái">

        <label>Department</label>
        <select id="department">
            <option value="HR">HR</option>
            <option value="IT">IT</option>
            <option value="Marketing">Marketing</option>
        </select>

        <label>Address</label>
        <input type="text" id="address" placeholder="Nhập địa chỉ">

        <label>Email</label>
        <input type="email" id="email" placeholder="example@gmail.com">

        <label>Leave Type</label>
        <select id="leaveType">
            <option value="Sick Leave">Sick Leave</option>
            <option value="Annual Leave">Annual Leave</option>
            <option value="Other Leave">Other Leave</option>
        </select>

        <label>Start Date</label>
        <input type="datetime-local" id="start">

        <label>End Date</label>
        <input type="datetime-local" id="end">

        <label>Reason</label>
        <textarea id="reason" rows="3" placeholder="Nhập lý do nghỉ phép"></textarea>

        <label>Contact During Leave</label>
        <input type="text" id="contact" placeholder="10 chữ số">

        <button type="submit">Submit</button>
    </form>
</div>
</body>
</html>
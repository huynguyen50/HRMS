
CREATE DATABASE IF NOT EXISTS hrm_db_pro
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE hrm_db_pro;

-- =====================================================
-- 1. ROLE (Bảng vai trò)
-- =====================================================
CREATE TABLE Role (
    RoleID INT AUTO_INCREMENT PRIMARY KEY,
    RoleName VARCHAR(100) NOT NULL
);

-- =====================================================
-- 2. DEPARTMENT (Bảng phòng ban)
-- =====================================================
CREATE TABLE Department (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    DeptName VARCHAR(100) NOT NULL UNIQUE,
    DeptManagerID INT NULL
);

-- =====================================================
-- 3. EMPLOYEE (Bảng nhân viên)
-- =====================================================
CREATE TABLE Employee (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(150) NOT NULL,
    Gender ENUM('Male','Female','Other') DEFAULT 'Other',
    DOB DATE,
    Address TEXT,
    Phone VARCHAR(50),
    Email VARCHAR(150) UNIQUE,
    EmploymentPeriod VARCHAR(50),
    DepartmentID INT NULL,
    Status ENUM('Active','Resigned','Probation','Intern') DEFAULT 'Active',
    Position VARCHAR(100),
    CONSTRAINT fk_employee_department FOREIGN KEY (DepartmentID)
        REFERENCES Department(DepartmentID)
        ON DELETE SET NULL
);

-- Thêm ràng buộc khóa ngoại cho Department sau khi bảng Employee đã tồn tại
ALTER TABLE Department
ADD CONSTRAINT fk_dept_manager FOREIGN KEY (DeptManagerID)
REFERENCES Employee(EmployeeID)
ON DELETE SET NULL;

-- =====================================================
-- 4. CONTRACT (Bảng hợp đồng)
-- =====================================================
CREATE TABLE Contract (
    ContractID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE,
    BaseSalary DECIMAL(12,2) NOT NULL,
    Allowance DECIMAL(12,2) DEFAULT 0,
    ContractType VARCHAR(30) DEFAULT 'Full-time',
    Notes VARCHAR(255),
    CreatedAt DATE DEFAULT (CURRENT_DATE),
    Status ENUM('Draft', 'Pending_Approval', 'Approved', 'Rejected', 'Active', 'Expired') NOT NULL DEFAULT 'Draft' COMMENT 'Contract status: Draft, Pending_Approval, Approved, Rejected, Active, Expired',
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =====================================================
-- 5. MAIL REQUEST (Bảng yêu cầu mail)
-- =====================================================
CREATE TABLE MailRequest (
    RequestID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    RequestType ENUM('Leave','Resignation','Petition') NOT NULL,
    StartDate DATE,
    EndDate DATE,
    Reason TEXT,
    Status ENUM('Pending','Approved','Rejected') DEFAULT 'Pending',
    ApprovedBy INT NULL,
    CONSTRAINT fk_mailrequest_employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID)
        ON DELETE CASCADE,
    CONSTRAINT fk_mailrequest_approver FOREIGN KEY (ApprovedBy)
        REFERENCES Employee(EmployeeID)
        ON DELETE SET NULL
);

-- =====================================================
-- 6. TASK (Bảng công việc)
-- =====================================================
CREATE TABLE Task (
    TaskID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Description TEXT,
    AssignedBy INT NOT NULL,
    StartDate DATE,
    DueDate DATE,
    Status ENUM('Waiting','In Progress','Completed','Rejected') DEFAULT 'Waiting',
    CONSTRAINT fk_task_assignedby FOREIGN KEY (AssignedBy)
        REFERENCES Employee(EmployeeID)
        ON DELETE CASCADE
);

-- =====================================================
-- 7. RECRUITMENT (Bảng tuyển dụng)
-- =====================================================
CREATE TABLE Recruitment (
    RecruitmentID INT AUTO_INCREMENT PRIMARY KEY,
    JobTitle VARCHAR(200) NOT NULL,
    JobDescription TEXT,
    Requirement VARCHAR(200) NOT NULL,
    Location VARCHAR(200) NOT NULL,
    Salary DOUBLE NOT NULL,
    Status ENUM('Waiting','New','Rejected','Applied','Deleted') DEFAULT 'New',
    PostedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Applicant INT NOT NULL DEFAULT 1
);

-- =====================================================
-- 8. GUEST (Bảng ứng viên)
-- =====================================================
CREATE TABLE Guest (
    GuestID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(150) NOT NULL,
    Email VARCHAR(150),
    Phone VARCHAR(50),
    CV TEXT,
    Status ENUM('Rejected','Hired','Processing') DEFAULT 'Processing',
    RecruitmentID INT NULL,
    AppliedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_guest_recruitment FOREIGN KEY (RecruitmentID)
        REFERENCES Recruitment(RecruitmentID)
        ON DELETE SET NULL
);

-- =====================================================
-- 9. PAYROLL (Bảng bảng lương) - đã thêm Status
-- =====================================================
CREATE TABLE Payroll (
    PayrollID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    PayPeriod VARCHAR(7) NOT NULL,
    BaseSalary DECIMAL(12,2) DEFAULT 0,
    Allowance DECIMAL(12,2) DEFAULT 0,
    Bonus DECIMAL(12,2) DEFAULT 0,
    Deduction DECIMAL(12,2) DEFAULT 0,
    NetSalary DECIMAL(12,2) DEFAULT 0,
    Status ENUM('Draft','Pending','Approved','Rejected','Paid') DEFAULT 'Draft',
    ApprovedBy INT NULL,
    ApprovedDate DATE,
    CONSTRAINT fk_payroll_employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID)
        ON DELETE CASCADE,
    CONSTRAINT fk_payroll_approver FOREIGN KEY (ApprovedBy)
        REFERENCES Employee(EmployeeID)
        ON DELETE SET NULL
);

-- =====================================================
-- 10. SYSTEM USER (Bảng người dùng hệ thống)
-- =====================================================
CREATE TABLE SystemUser (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    RoleID INT NOT NULL,
    LastLogin DATETIME,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    EmployeeID INT UNIQUE,
    CONSTRAINT fk_systemuser_role FOREIGN KEY (RoleID)
        REFERENCES Role(RoleID)
        ON DELETE CASCADE,
    CONSTRAINT fk_systemuser_employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID)
        ON DELETE SET NULL
);

-- =====================================================
-- 11. SYSTEM LOG (Bảng log hệ thống)
-- =====================================================
CREATE TABLE SystemLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    Action VARCHAR(200) NOT NULL,
    ObjectType VARCHAR(100),
    OldValue TEXT,
    NewValue TEXT,
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_systemlog_user FOREIGN KEY (UserID)
        REFERENCES SystemUser(UserID)
        ON DELETE CASCADE
);

-- =====================================================
-- 12. ATTENDANCE (Bảng chấm công)
-- =====================================================
CREATE TABLE Attendance (
    AttendanceID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    Date DATE NOT NULL,
    CheckIn TIME,
    CheckOut TIME,
    WorkingHours DECIMAL(5,2),
    OvertimeHours DECIMAL(5,2),
    CONSTRAINT fk_attendance_employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID)
        ON DELETE CASCADE,
    UNIQUE KEY uq_attendance_employee_date (EmployeeID, Date)
);

-- =====================================================
-- 13. ASSIGNLIST (Bảng giao việc - Nhiều-Nhiều)
-- =====================================================
CREATE TABLE assignList (
    id INT AUTO_INCREMENT PRIMARY KEY,
    TaskId INT NOT NULL,
    EmpId INT NOT NULL,
    UNIQUE KEY unique_task_employee (TaskId, EmpId),
    
    CONSTRAINT fk_assignlist_task
        FOREIGN KEY (TaskId)
        REFERENCES Task(TaskID)
        ON DELETE CASCADE,
        
    CONSTRAINT fk_assignlist_employee
        FOREIGN KEY (EmpId)
        REFERENCES Employee(EmployeeID)
        ON DELETE CASCADE
);

-- =====================================================
-- 14. ALLOWANCE TYPE & EMPLOYEE ALLOWANCE (MỞ RỘNG)
-- =====================================================
CREATE TABLE AllowanceType (
    AllowanceTypeID INT AUTO_INCREMENT PRIMARY KEY,
    AllowanceName VARCHAR(100) NOT NULL,
    Description TEXT
);

CREATE TABLE EmployeeAllowance (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    AllowanceTypeID INT NOT NULL,
    Amount DECIMAL(12,2) NOT NULL,
    Month VARCHAR(7) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
        ON DELETE CASCADE,
    FOREIGN KEY (AllowanceTypeID) REFERENCES AllowanceType(AllowanceTypeID)
        ON DELETE CASCADE
);

-- =====================================================
-- 15. DEDUCTION TYPE & EMPLOYEE DEDUCTION (MỞ RỘNG)
-- =====================================================
CREATE TABLE DeductionType (
    DeductionTypeID INT AUTO_INCREMENT PRIMARY KEY,
    DeductionName VARCHAR(100) NOT NULL,
    Description TEXT
);

CREATE TABLE EmployeeDeduction (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    DeductionTypeID INT NOT NULL,
    Amount DECIMAL(12,2) NOT NULL,
    Month VARCHAR(7) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
        ON DELETE CASCADE,
    FOREIGN KEY (DeductionTypeID) REFERENCES DeductionType(DeductionTypeID)
        ON DELETE CASCADE
);

-- =====================================================
-- KẾT THÚC TẠO BẢNG
-- =====================================================

-- =====================================================
-- BẮT ĐẦU CHÈN DỮ LIỆU MẪU (từ file DB (1).txt)
-- =====================================================

-- ===== ROLE =====
INSERT INTO Role (RoleName) VALUES
('Admin'),
('HR Manager'),
('Dept Manager'),
('HR Staff'),
('Employee');

-- ===== DEPARTMENT =====
INSERT INTO Department (DeptName) VALUES
('Human Resources'),
('Finance'),
('IT Department'),
('Marketing'),
('Operations');

-- ===== EMPLOYEE =====
INSERT INTO Employee (FullName, Gender, DOB, Address, Phone, Email, EmploymentPeriod, DepartmentID, Status, Position)
VALUES
('Tran Duy Hien', 'Male', '2005-10-02', 'Hanoi', '0964796942', 'hiendev2005@gmail.com', '2015-2025', 1, 'Active', 'HR Manager'),
('Tran Duy Thanh', 'Male', '1992-07-23', 'Hanoi', '0902222222', 'zzzzzzhienne@gmail.com', '2018-2025', 1, 'Active', 'HR Staff'),
('Nguyen Tat Dang Huy', 'Male', '1988-03-05', 'HCM City', '0903333333', 'huyntdhe190142@gmail.com', '2014-2025', 2, 'Active', 'Finance Manager'),
('Pham Thi D', 'Female', '1995-09-10', 'HCM City', '0904444444', 'd@company.com', '2020-2025', 2, 'Active', 'Accountant'),
('Do Van E', 'Male', '1993-01-02', 'Da Nang', '0905555555', 'e@company.com', '2019-2025', 3, 'Active', 'IT Manager'),
('Bui Thi F', 'Female', '1997-12-15', 'Da Nang', '0906666666', 'f@company.com', '2021-2025', 3, 'Active', 'Developer'),
('Hoang Van G', 'Male', '1994-10-20', 'Can Tho', '0907777777', 'g@company.com', '2018-2025', 4, 'Active', 'Marketing Manager'),
('Ngo Thi H', 'Female', '1999-06-30', 'Can Tho', '0908888888', 'h@company.com', '2023-2025', 4, 'Probation', 'Designer'),
('Dang Van I', 'Male', '1989-04-19', 'Hue', '0909999999', 'i@company.com', '2017-2025', 5, 'Active', 'Operations Manager'),
('Vo Thi J', 'Female', '1996-11-25', 'Hue', '0910000000', 'j@company.com', '2022-2025', 5, 'Active', 'Operator');

-- DEPARTMENT MANAGER
UPDATE Department SET DeptManagerID = 1 WHERE DepartmentID = 1;
UPDATE Department SET DeptManagerID = 3 WHERE DepartmentID = 2;
UPDATE Department SET DeptManagerID = 5 WHERE DepartmentID = 3;
UPDATE Department SET DeptManagerID = 7 WHERE DepartmentID = 4;
UPDATE Department SET DeptManagerID = 9 WHERE DepartmentID = 5;

-- ===== CONTRACT =====
INSERT INTO Contract (EmployeeID, StartDate, EndDate, BaseSalary, Allowance, ContractType, Notes)
VALUES
(1, '2020-01-01', '2025-01-01', 25000000, 3000000, 'Full-time', 'Permanent contract'),
(2, '2021-06-01', NULL, 15000000, 2000000, 'Full-time', 'Ongoing contract'),
(3, '2019-01-01', '2025-12-31', 30000000, 5000000, 'Full-time', 'Senior position'),
(4, '2022-03-01', NULL, 12000000, 1500000, 'Part-time', 'Flexible hours'),
(5, '2020-01-01', '2025-01-01', 28000000, 4000000, 'Full-time', 'Department head'),
(6, '2023-01-01', NULL, 16000000, 2000000, 'Full-time', 'New staff'),
(7, '2018-08-01', '2024-08-01', 22000000, 3500000, 'Full-time', 'Long-term employee'),
(8, '2024-06-01', NULL, 10000000, 1000000, 'Probation', 'Trial period'),
(9, '2019-01-01', '2025-01-01', 26000000, 4000000, 'Full-time', 'Stable performance'),
(10,'2022-02-01', NULL, 12000000, 1000000, 'Intern', 'Internship program');

-- ===== SYSTEM USER (ĐÃ SỬA PASSWORD) =====
INSERT INTO SystemUser (Username, Password, RoleID, EmployeeID)
VALUES
('admin123456', '12345678', 1, 1),
('hrb123456', '12345678', 2, 2),
('financec123', '12345678', 3, 3),
('it_f', '12345678', 4, 5),
('dev_f', '12345678', 5, 6),
('market_h', '12345678', 5, 8);

-- ===== TASK (ĐÃ SỬA, LOẠI BỎ AssignTo) =====
INSERT INTO Task (Title, Description, AssignedBy, StartDate, DueDate, Status)
VALUES
('Prepare monthly HR report', 'Compile staff attendance & leave data', 1, '2025-09-01', '2025-09-05', 'Completed'),
('Create salary forecast', 'Estimate next quarter salary expenses', 3, '2025-09-10', '2025-09-30', 'In Progress'),
('Fix system bug', 'Resolve payroll calculation error', 5, '2025-09-12', '2025-09-15', 'Waiting'),
('Design brochure', 'Design marketing brochure for new campaign', 7, '2025-09-01', '2025-09-10', 'Completed'),
('Inventory check', 'Verify all warehouse items', 9, '2025-09-15', '2025-09-20', 'Waiting');

-- ===== ASSIGNLIST (THÊM MỚI) =====
INSERT INTO assignList (TaskId, EmpId) VALUES
(1, 2),
(2, 4),
(3, 6),
(4, 8),
(5, 10);

-- ===== MAIL REQUEST =====
INSERT INTO MailRequest (EmployeeID, RequestType, StartDate, EndDate, Reason, Status, ApprovedBy)
VALUES
(2, 'Leave', '2025-09-15', '2025-09-17', 'Personal reasons', 'Approved', 1),
(4, 'Leave', '2025-09-20', '2025-09-22', 'Family event', 'Pending', 3),
(6, 'Petition', NULL, NULL, 'Request better equipment', 'Approved', 5),
(8, 'Resignation', NULL, NULL, 'Switching company', 'Pending', 7);

-- ===== RECRUITMENT =====
INSERT INTO Recruitment (JobTitle, JobDescription, Requirement, Location, Salary, Status, Applicant) VALUES
('Software Developer', 'Develop and maintain web applications', 'Java, Spring Boot, MySQL', 'Hanoi', 25000000, 'New',1);

-- ===== GUEST =====
INSERT INTO Guest (FullName, Email, Phone, CV, Status, RecruitmentID)
VALUES
('Nguyen Tien Khanh', 'khanh@example.com', '0981111111', 'link_cv_k.pdf', 'Processing', 1),
('Le Thi Lanh', 'lanh@example.com', '0982222222', 'link_cv_l.pdf', 'Processing', 1),
('Pham Van Manh', 'manh@example.com', '0983333333', 'link_cv_m.pdf', 'Processing', 1),
('Do Thi Ngoc', 'ngoc@example.com', '0984444444', 'link_cv_n.pdf', 'Processing', 1);

-- ===== PAYROLL =====
INSERT INTO Payroll (EmployeeID, PayPeriod, BaseSalary, Allowance, Bonus, Deduction, NetSalary, Status, ApprovedBy, ApprovedDate)
VALUES
(1, '2025-09', 25000000, 3000000, 2000000, 500000, 29500000, 'Approved', 3, '2025-09-30'),
(2, '2025-09', 15000000, 2000000, 1000000, 0, 18000000, 'Approved', 1, '2025-09-30'),
(3, '2025-09', 30000000, 5000000, 2000000, 0, 37000000, 'Approved', 1, '2025-09-30'),
(5, '2025-09', 28000000, 4000000, 2500000, 1000000, 33500000, 'Approved', 3, '2025-09-30');

-- ===== ATTENDANCE =====
INSERT INTO Attendance (EmployeeID, Date, CheckIn, CheckOut, WorkingHours, OvertimeHours)
VALUES
(2, '2025-09-01', '08:00:00', '17:00:00', 8.0, 0.0),
(2, '2025-09-02', '08:10:00', '17:05:00', 8.0, 0.2),
(6, '2025-09-01', '08:00:00', '17:30:00', 8.0, 0.5),
(8, '2025-09-01', '08:00:00', '16:30:00', 7.5, 0.0);

-- ===== SYSTEM LOG =====
INSERT INTO SystemLog (UserID, Action, ObjectType, OldValue, NewValue)
VALUES
(1, 'LOGIN', 'SystemUser', NULL, 'User admin logged in'),
(1, 'APPROVE', 'MailRequest', 'Pending', 'Approved'),
(3, 'CREATE', 'Recruitment', NULL, 'Created new job posting: Accountant'),
(5, 'UPDATE', 'Task', 'Pending', 'In Progress');

COMMIT;

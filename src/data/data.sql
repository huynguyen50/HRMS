-- =====================================================
-- SCRIPT TẠO VÀ KHỞI TẠO DATABASE HOÀN CHỈNH
-- Đã hợp nhất và cập nhật theo yêu cầu
-- =====================================================

-- Tạo database mới với charset UTF-8 để hỗ trợ tiếng Việt
CREATE DATABASE IF NOT EXISTS hrm_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- Chọn database vừa tạo để làm việc
USE hrm_db;

-- =====================================================
-- PHẦN I: XÓA CÁC BẢNG CŨ (NẾU CÓ) - XÓA BẢNG CON TRƯỚC
-- =====================================================
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS UserPermission;
DROP TABLE IF EXISTS RolePermission;
DROP TABLE IF EXISTS Permission;
DROP TABLE IF EXISTS SystemLog;
DROP TABLE IF EXISTS Attendance;
DROP TABLE IF EXISTS Payroll;
DROP TABLE IF EXISTS Guest;
DROP TABLE IF EXISTS Recruitment;
DROP TABLE IF EXISTS MailRequest;
DROP TABLE IF EXISTS Task;
DROP TABLE IF EXISTS SystemUser;
DROP TABLE IF EXISTS Contract;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Role;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- PHẦN II: TẠO CÁC BẢNG (TABLE CREATION)
-- =====================================================

-- 1. ROLE (Bảng vai trò)
CREATE TABLE Role (
    RoleID INT AUTO_INCREMENT PRIMARY KEY,
    RoleName VARCHAR(100) NOT NULL
);

-- 2. DEPARTMENT (Bảng phòng ban)
CREATE TABLE Department (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    DeptName VARCHAR(100) NOT NULL UNIQUE,
    DeptManagerID INT NULL
    -- GHI CHÚ: Ràng buộc fk_dept_manager sẽ được thêm sau khi bảng Employee tồn tại
);

-- 3. EMPLOYEE (Bảng nhân viên)
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
    -- GHI CHÚ: Nên cân nhắc thêm trường ReportingManagerID để quản lý cấp trên trực tiếp
    CONSTRAINT fk_employee_department FOREIGN KEY (DepartmentID)
        REFERENCES Department(DepartmentID)
        ON DELETE SET NULL
);

-- Thêm ràng buộc khóa ngoại cho Department sau khi bảng Employee đã tồn tại
ALTER TABLE Department
ADD CONSTRAINT fk_dept_manager FOREIGN KEY (DeptManagerID)
REFERENCES Employee(EmployeeID)
ON DELETE SET NULL;

-- 4. CONTRACT (Bảng hợp đồng - ĐÃ CẬP NHẬT)
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
    -- ĐÃ TÍCH HỢP TỪ MIGRATION SCRIPT
    Status ENUM('Draft', 'Pending_Approval', 'Approved', 'Rejected', 'Active', 'Expired') NOT NULL DEFAULT 'Draft' COMMENT 'Contract status: Draft, Pending_Approval, Approved, Rejected, Active, Expired',
    -- GHI CHÚ: Nên cân nhắc thêm các trường ApprovedBy, ApprovedDate để theo dõi luồng phê duyệt
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 5. MAIL REQUEST (Bảng yêu cầu mail)
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

-- 6. TASK (Bảng công việc)
CREATE TABLE Task (
    TaskID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Description TEXT,
    AssignedBy INT NOT NULL,
    AssignTo INT NOT NULL,
    StartDate DATE,
    DueDate DATE,
    Status ENUM('Pending','In Progress','Completed','Rejected') DEFAULT 'Pending',
    CONSTRAINT fk_task_assignedby FOREIGN KEY (AssignedBy)
        REFERENCES Employee(EmployeeID)
        ON DELETE CASCADE,
    CONSTRAINT fk_task_assignto FOREIGN KEY (AssignTo)
        REFERENCES Employee(EmployeeID)
        ON DELETE CASCADE
);

-- 7. RECRUITMENT (Bảng tuyển dụng)
CREATE TABLE Recruitment (
    RecruitmentID INT AUTO_INCREMENT PRIMARY KEY,
    JobTitle VARCHAR(200) NOT NULL,
    JobDescription TEXT,
    Requirement VARCHAR(200) NOT NULL,
    Location VARCHAR(200) NOT NULL,
    Salary DOUBLE NOT NULL,
    Status ENUM('Waiting','New','Close','Applied','Deleted') DEFAULT 'New',
    PostedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Applicant INT NOT NULL DEFAULT 1
    -- GHI CHÚ: Trường 'Applicant' có vẻ thừa thãi vì mối quan hệ đã được thiết lập qua bảng Guest
);

-- 8. GUEST (Bảng ứng viên)
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

-- 9. PAYROLL (Bảng bảng lương)
CREATE TABLE Payroll (
    PayrollID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    PayPeriod VARCHAR(7) NOT NULL,
    BaseSalary DECIMAL(12,2) DEFAULT 0,
    Allowance DECIMAL(12,2) DEFAULT 0,
    Bonus DECIMAL(12,2) DEFAULT 0,
    Deduction DECIMAL(12,2) DEFAULT 0,
    NetSalary DECIMAL(12,2) DEFAULT 0,
    ApprovedBy INT NULL,
    ApprovedDate DATE,
    CONSTRAINT fk_payroll_employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID)
        ON DELETE CASCADE,
    CONSTRAINT fk_payroll_approver FOREIGN KEY (ApprovedBy)
        REFERENCES Employee(EmployeeID)
        ON DELETE SET NULL
);

-- 10. SYSTEM USER (Bảng người dùng hệ thống)
-- GHI CHÚ: Thiết kế này là one-to-many (một user một role). 
-- Nếu muốn một user có nhiều role, cần tạo bảng trung gian UserRole như đã thảo luận.
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

-- 11. SYSTEM LOG (Bảng log hệ thống)
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

-- 12. ATTENDANCE (Bảng chấm công)
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

-- 13. PERMISSION (Bảng quyền)
CREATE TABLE Permission (
    PermissionID INT AUTO_INCREMENT PRIMARY KEY,
    PermissionCode VARCHAR(100) NOT NULL UNIQUE,
    PermissionName VARCHAR(200) NOT NULL,
    Description TEXT,
    Category VARCHAR(50),
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 14. ROLE_PERMISSION (Bảng gán quyền mặc định cho vai trò)
CREATE TABLE RolePermission (
    RolePermissionID INT AUTO_INCREMENT PRIMARY KEY,
    RoleID INT NOT NULL,
    PermissionID INT NOT NULL,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rolepermission_role FOREIGN KEY (RoleID)
        REFERENCES Role(RoleID)
        ON DELETE CASCADE,
    CONSTRAINT fk_rolepermission_permission FOREIGN KEY (PermissionID)
        REFERENCES Permission(PermissionID)
        ON DELETE CASCADE,
    UNIQUE KEY uq_role_permission (RoleID, PermissionID)
);

-- 15. USER_PERMISSION (Bảng ma trận phân quyền người dùng - cốt lõi)
CREATE TABLE UserPermission (
    UserPermissionID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    PermissionID INT NOT NULL,
    IsGranted BOOLEAN DEFAULT TRUE COMMENT 'TRUE = Cấp quyền, FALSE = Thu hồi quyền',
    Scope VARCHAR(50) DEFAULT 'ALL' COMMENT 'ALL, DEPARTMENT, SELF - Phạm vi áp dụng quyền',
    ScopeValue INT NULL COMMENT 'Giá trị phạm vi (ví dụ: DepartmentID nếu Scope = DEPARTMENT)',
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedDate DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CreatedBy INT NULL COMMENT 'UserID của người tạo/cập nhật',
    CONSTRAINT fk_userpermission_user FOREIGN KEY (UserID)
        REFERENCES SystemUser(UserID)
        ON DELETE CASCADE,
    CONSTRAINT fk_userpermission_permission FOREIGN KEY (PermissionID)
        REFERENCES Permission(PermissionID)
        ON DELETE CASCADE,
    CONSTRAINT fk_userpermission_createdby FOREIGN KEY (CreatedBy)
        REFERENCES SystemUser(UserID)
        ON DELETE SET NULL,
    UNIQUE KEY uq_user_permission (UserID, PermissionID, Scope, ScopeValue)
);


-- =====================================================
-- PHẦN III: CHÈN DỮ LIỆU MẪU (DATA INSERTION)
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

-- ===== CONTRACT (ĐÃ CẬP NHẬT VỚI TRẠNG THÁI) =====
INSERT INTO Contract (EmployeeID, StartDate, EndDate, BaseSalary, Allowance, ContractType, Notes, Status)
VALUES
(1, '2020-01-01', '2025-01-01', 25000000, 3000000, 'Full-time', 'Permanent contract', 'Active'),
(2, '2021-06-01', NULL, 15000000, 2000000, 'Full-time', 'Ongoing contract', 'Active'),
(3, '2019-01-01', '2025-12-31', 30000000, 5000000, 'Full-time', 'Senior position', 'Active'),
(4, '2022-03-01', NULL, 12000000, 1500000, 'Part-time', 'Flexible hours', 'Active'),
(5, '2020-01-01', '2025-01-01', 28000000, 4000000, 'Full-time', 'Department head', 'Active'),
(6, '2023-01-01', NULL, 16000000, 2000000, 'Full-time', 'New staff', 'Active'),
(7, '2018-08-01', '2024-08-01', 22000000, 3500000, 'Full-time', 'Long-term employee', 'Expired'),
(8, '2024-06-01', NULL, 10000000, 1000000, 'Probation', 'Trial period', 'Active'),
(9, '2019-01-01', '2025-01-01', 26000000, 4000000, 'Full-time', 'Stable performance', 'Active'),
(10,'2022-02-01', NULL, 12000000, 1000000, 'Intern', 'Internship program', 'Active');

-- ===== SYSTEM USER =====
-- ===== SYSTEM USER =====
INSERT INTO SystemUser (Username, Password, RoleID, EmployeeID)
VALUES
('admin123', 'admin1234', 1, 1),
('ducvan2004', '12345678', 2, 2),
('finance_c', '12345678', 3, 3),
('hien1234', '12345678', 4, 5),
('devf123', '12345678', 5, 6),
('market_h', '12345678', 5, 8);

-- ===== TASK =====
INSERT INTO Task (Title, Description, AssignedBy, AssignTo, StartDate, DueDate, Status)
VALUES
('Prepare monthly HR report', 'Compile staff attendance & leave data', 1, 2, '2025-09-01', '2025-09-05', 'Completed'),
('Create salary forecast', 'Estimate next quarter salary expenses', 3, 4, '2025-09-10', '2025-09-30', 'In Progress'),
('Fix system bug', 'Resolve payroll calculation error', 5, 6, '2025-09-12', '2025-09-15', 'Pending'),
('Design brochure', 'Design marketing brochure for new campaign', 7, 8, '2025-09-01', '2025-09-10', 'Completed'),
('Inventory check', 'Verify all warehouse items', 9, 10, '2025-09-15', '2025-09-20', 'Pending');

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
INSERT INTO Payroll (EmployeeID, PayPeriod, BaseSalary, Allowance, Bonus, Deduction, NetSalary, ApprovedBy, ApprovedDate)
VALUES
(1, '2025-09', 25000000, 3000000, 2000000, 500000, 29500000, 3, '2025-09-30'),
(2, '2025-09', 15000000, 2000000, 1000000, 0, 18000000, 1, '2025-09-30'),
(3, '2025-09', 30000000, 5000000, 2000000, 0, 37000000, 1, '2025-09-30'),
(5, '2025-09', 28000000, 4000000, 2500000, 1000000, 33500000, 3, '2025-09-30');

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

-- ===== PERMISSION (Bảng quyền) =====
INSERT INTO Permission (PermissionCode, PermissionName, Description, Category) VALUES
-- Employee Management
('VIEW_EMPLOYEES', 'View Employees', 'Xem danh sách nhân viên', 'Employee'),
('CREATE_EMPLOYEE', 'Create Employee', 'Tạo nhân viên mới', 'Employee'),
('EDIT_EMPLOYEE', 'Edit Employee', 'Chỉnh sửa thông tin nhân viên', 'Employee'),
('DELETE_EMPLOYEE', 'Delete Employee', 'Xóa nhân viên', 'Employee'),
('VIEW_EMPLOYEE_DETAIL', 'View Employee Detail', 'Xem chi tiết nhân viên', 'Employee'),
('MANAGE_DEPT_EMPLOYEES', 'Manage Department Employees', 'Quản lý nhân viên trong phòng ban', 'Employee'),

-- Department Management
('VIEW_DEPARTMENTS', 'View Departments', 'Xem danh sách phòng ban', 'Department'),
('CREATE_DEPARTMENT', 'Create Department', 'Tạo phòng ban mới', 'Department'),
('EDIT_DEPARTMENT', 'Edit Department', 'Chỉnh sửa phòng ban', 'Department'),
('DELETE_DEPARTMENT', 'Delete Department', 'Xóa phòng ban', 'Department'),

-- Contract Management
('VIEW_CONTRACTS', 'View Contracts', 'Xem hợp đồng', 'Contract'),
('CREATE_CONTRACT', 'Create Contract', 'Tạo hợp đồng mới', 'Contract'),
('EDIT_CONTRACT', 'Edit Contract', 'Chỉnh sửa hợp đồng', 'Contract'),
('APPROVE_CONTRACT', 'Approve Contract', 'Phê duyệt hợp đồng', 'Contract'),
('REJECT_CONTRACT', 'Reject Contract', 'Từ chối hợp đồng', 'Contract'),

-- Recruitment Management
('VIEW_RECRUITMENT', 'View Recruitment', 'Xem tin tuyển dụng', 'Recruitment'),
('CREATE_RECRUITMENT', 'Create Recruitment', 'Tạo tin tuyển dụng', 'Recruitment'),
('EDIT_RECRUITMENT', 'Edit Recruitment', 'Chỉnh sửa tin tuyển dụng', 'Recruitment'),
('DELETE_RECRUITMENT', 'Delete Recruitment', 'Xóa tin tuyển dụng', 'Recruitment'),
('MANAGE_APPLICANTS', 'Manage Applicants', 'Quản lý ứng viên', 'Recruitment'),

-- Payroll Management
('VIEW_PAYROLLS', 'View Payrolls', 'Xem bảng lương', 'Payroll'),
('VIEW_ALL_PAYROLLS', 'View All Payrolls', 'Xem tất cả bảng lương', 'Payroll'),
('CREATE_PAYROLL', 'Create Payroll', 'Tạo bảng lương', 'Payroll'),
('EDIT_PAYROLL', 'Edit Payroll', 'Chỉnh sửa bảng lương', 'Payroll'),
('APPROVE_PAYROLL', 'Approve Payroll', 'Phê duyệt bảng lương', 'Payroll'),

-- User Management
('VIEW_USERS', 'View Users', 'Xem danh sách người dùng', 'User'),
('CREATE_USER', 'Create User', 'Tạo người dùng mới', 'User'),
('EDIT_USER', 'Edit User', 'Chỉnh sửa người dùng', 'User'),
('DELETE_USER', 'Delete User', 'Xóa người dùng', 'User'),
('MANAGE_USER_PERMISSIONS', 'Manage User Permissions', 'Quản lý phân quyền người dùng', 'User'),

-- Role Management
('VIEW_ROLES', 'View Roles', 'Xem vai trò', 'Role'),
('CREATE_ROLE', 'Create Role', 'Tạo vai trò mới', 'Role'),
('EDIT_ROLE', 'Edit Role', 'Chỉnh sửa vai trò', 'Role'),
('DELETE_ROLE', 'Delete Role', 'Xóa vai trò', 'Role'),
('MANAGE_ROLE_PERMISSIONS', 'Manage Role Permissions', 'Quản lý quyền của vai trò', 'Role'),

-- Leave Management
('VIEW_LEAVES', 'View Leaves', 'Xem đơn nghỉ phép', 'Leave'),
('CREATE_LEAVE', 'Create Leave', 'Tạo đơn nghỉ phép', 'Leave'),
('APPROVE_LEAVE', 'Approve Leave', 'Phê duyệt đơn nghỉ phép', 'Leave'),
('REJECT_LEAVE', 'Reject Leave', 'Từ chối đơn nghỉ phép', 'Leave'),

-- Dashboard & Reports
('VIEW_DASHBOARD', 'View Dashboard', 'Xem dashboard', 'Dashboard'),
('VIEW_HR_DASHBOARD', 'View HR Dashboard', 'Xem HR dashboard', 'Dashboard'),
('VIEW_REPORTS', 'View Reports', 'Xem báo cáo', 'Report'),

-- Audit & System
('VIEW_AUDIT_LOG', 'View Audit Log', 'Xem nhật ký hệ thống', 'System'),
('MANAGE_SYSTEM', 'Manage System', 'Quản lý hệ thống', 'System');

-- ===== ROLE_PERMISSION (Gán quyền mặc định cho vai trò) =====
-- Admin: Tất cả quyền
INSERT INTO RolePermission (RoleID, PermissionID)
SELECT 1, PermissionID FROM Permission;

-- HR Manager: Quản lý nhân sự, hợp đồng, tuyển dụng
INSERT INTO RolePermission (RoleID, PermissionID)
SELECT 2, PermissionID FROM Permission 
WHERE PermissionCode IN (
    'VIEW_EMPLOYEES', 'CREATE_EMPLOYEE', 'EDIT_EMPLOYEE', 'VIEW_EMPLOYEE_DETAIL',
    'VIEW_CONTRACTS', 'CREATE_CONTRACT', 'EDIT_CONTRACT', 'APPROVE_CONTRACT',
    'VIEW_RECRUITMENT', 'CREATE_RECRUITMENT', 'EDIT_RECRUITMENT', 'MANAGE_APPLICANTS',
    'VIEW_LEAVES', 'APPROVE_LEAVE', 'REJECT_LEAVE',
    'VIEW_DEPARTMENTS', 'VIEW_DASHBOARD', 'VIEW_HR_DASHBOARD', 'VIEW_PAYROLLS', 'VIEW_ALL_PAYROLLS'
);

-- Dept Manager: Quản lý nhân viên trong phòng ban, phê duyệt leave
INSERT INTO RolePermission (RoleID, PermissionID)
SELECT 3, PermissionID FROM Permission 
WHERE PermissionCode IN (
    'VIEW_EMPLOYEES', 'VIEW_EMPLOYEE_DETAIL', 'MANAGE_DEPT_EMPLOYEES',
    'VIEW_DEPARTMENTS', 'VIEW_LEAVES', 'APPROVE_LEAVE', 'REJECT_LEAVE',
    'VIEW_DASHBOARD'
);

-- HR Staff: Quản lý hợp đồng, tuyển dụng
INSERT INTO RolePermission (RoleID, PermissionID)
SELECT 4, PermissionID FROM Permission 
WHERE PermissionCode IN (
    'VIEW_EMPLOYEES', 'VIEW_EMPLOYEE_DETAIL',
    'VIEW_CONTRACTS', 'CREATE_CONTRACT', 'EDIT_CONTRACT',
    'VIEW_RECRUITMENT', 'MANAGE_APPLICANTS',
    'VIEW_DASHBOARD'
);

-- Employee: Xem thông tin cá nhân, tạo đơn nghỉ phép
INSERT INTO RolePermission (RoleID, PermissionID)
SELECT 5, PermissionID FROM Permission 
WHERE PermissionCode IN (
    'VIEW_EMPLOYEE_DETAIL', 'VIEW_LEAVES', 'CREATE_LEAVE', 'VIEW_DASHBOARD', 'VIEW_CONTRACTS', 'VIEW_PAYROLLS'
);

-- ===== USER_PERMISSION (Phân quyền động cho từng user - Ma trận phân quyền) =====
-- Ghi chú: UserPermission cho phép Admin cấp/thu hồi quyền cụ thể cho từng user,
-- có thể kèm theo phạm vi (Scope: ALL, DEPARTMENT, SELF) và giá trị phạm vi (ScopeValue)

-- Ví dụ 1: Cấp thêm quyền quản lý phân quyền cho HR Manager (UserID=2) với scope ALL
INSERT INTO UserPermission (UserID, PermissionID, IsGranted, Scope, ScopeValue, CreatedBy)
SELECT 2, PermissionID, TRUE, 'ALL', NULL, 1
FROM Permission 
WHERE PermissionCode = 'MANAGE_USER_PERMISSIONS';

-- Ví dụ 2: Cấp quyền xem tất cả employees cho Dept Manager Finance (UserID=3) với scope DEPARTMENT (chỉ phòng ban Finance - DeptID=2)
INSERT INTO UserPermission (UserID, PermissionID, IsGranted, Scope, ScopeValue, CreatedBy)
SELECT 3, PermissionID, TRUE, 'DEPARTMENT', 2, 1
FROM Permission 
WHERE PermissionCode = 'VIEW_EMPLOYEES';

-- Ví dụ 3: Thu hồi quyền xóa employee từ HR Staff (UserID=4) - Override quyền mặc định của role
INSERT INTO UserPermission (UserID, PermissionID, IsGranted, Scope, ScopeValue, CreatedBy)
SELECT 4, PermissionID, FALSE, 'ALL', NULL, 1
FROM Permission 
WHERE PermissionCode = 'DELETE_EMPLOYEE';

-- Ví dụ 4: Cấp quyền approve contract cho HR Staff (UserID=4) chỉ trong phòng ban HR (DeptID=1)
INSERT INTO UserPermission (UserID, PermissionID, IsGranted, Scope, ScopeValue, CreatedBy)
SELECT 4, PermissionID, TRUE, 'DEPARTMENT', 1, 1
FROM Permission 
WHERE PermissionCode = 'APPROVE_CONTRACT';

-- Ví dụ 5: Cấp quyền xem payroll cho Employee (UserID=5) chỉ cho chính họ (SELF)
INSERT INTO UserPermission (UserID, PermissionID, IsGranted, Scope, ScopeValue, CreatedBy)
SELECT 5, PermissionID, TRUE, 'SELF', NULL, 1
FROM Permission 
WHERE PermissionCode = 'VIEW_PAYROLLS';

-- Ví dụ 6: Cấp quyền xem tất cả payrolls cho HR Manager (UserID=2) với scope ALL
INSERT INTO UserPermission (UserID, PermissionID, IsGranted, Scope, ScopeValue, CreatedBy)
SELECT 2, PermissionID, TRUE, 'ALL', NULL, 1
FROM Permission 
WHERE PermissionCode = 'VIEW_ALL_PAYROLLS';

-- Ví dụ 7: Cấp quyền quản lý recruitment cho HR Staff (UserID=4) trong phòng ban IT (DeptID=3)
INSERT INTO UserPermission (UserID, PermissionID, IsGranted, Scope, ScopeValue, CreatedBy)
SELECT 4, PermissionID, TRUE, 'DEPARTMENT', 3, 1
FROM Permission 
WHERE PermissionCode IN ('VIEW_RECRUITMENT', 'CREATE_RECRUITMENT', 'EDIT_RECRUITMENT');

-- Ví dụ 8: Thu hồi quyền xóa department từ Dept Manager (UserID=3) - Bảo vệ an toàn
INSERT INTO UserPermission (UserID, PermissionID, IsGranted, Scope, ScopeValue, CreatedBy)
SELECT 3, PermissionID, FALSE, 'ALL', NULL, 1
FROM Permission 
WHERE PermissionCode = 'DELETE_DEPARTMENT';

-- Ví dụ 9: Cấp quyền xem audit log cho HR Manager (UserID=2) với scope ALL
INSERT INTO UserPermission (UserID, PermissionID, IsGranted, Scope, ScopeValue, CreatedBy)
SELECT 2, PermissionID, TRUE, 'ALL', NULL, 1
FROM Permission 
WHERE PermissionCode = 'VIEW_AUDIT_LOG';

-- Ví dụ 10: Cấp quyền approve leave cho HR Staff (UserID=4) trong phòng ban HR (DeptID=1)
INSERT INTO UserPermission (UserID, PermissionID, IsGranted, Scope, ScopeValue, CreatedBy)
SELECT 4, PermissionID, TRUE, 'DEPARTMENT', 1, 1
FROM Permission 
WHERE PermissionCode = 'APPROVE_LEAVE';

-- Ví dụ 11: Cấp quyền quản lý users cho HR Manager (UserID=2) với scope ALL
INSERT INTO UserPermission (UserID, PermissionID, IsGranted, Scope, ScopeValue, CreatedBy)
SELECT 2, PermissionID, TRUE, 'ALL', NULL, 1
FROM Permission 
WHERE PermissionCode IN ('VIEW_USERS', 'CREATE_USER', 'EDIT_USER', 'MANAGE_USER_PERMISSIONS');

-- Ví dụ 12: Cấp quyền xem contracts cho Employee (UserID=5) chỉ cho contract của chính họ (SELF)
INSERT INTO UserPermission (UserID, PermissionID, IsGranted, Scope, ScopeValue, CreatedBy)
SELECT 5, PermissionID, TRUE, 'SELF', NULL, 1
FROM Permission 
WHERE PermissionCode = 'VIEW_CONTRACTS';

-- Ví dụ 13: Cấp quyền xem tất cả departments cho Dept Manager IT (UserID=3) với scope ALL
INSERT INTO UserPermission (UserID, PermissionID, IsGranted, Scope, ScopeValue, CreatedBy)
SELECT 3, PermissionID, TRUE, 'ALL', NULL, 1
FROM Permission 
WHERE PermissionCode = 'VIEW_DEPARTMENTS';

COMMIT;
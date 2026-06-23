# Feature: Guest Phase 2 implementation
Status: Approved
Actor: Guest Candidate, HR, HR Staff, Admin
Priority: High
Related Data: `Guest`, `Application`, `Interview`, `Offer`, `Notification`
Related Code To Create: `Application`, `Interview`, `Offer`, `Notification` models and DAO classes

## Muc tieu
Chuyen Guest portal tu luong Phase 1 dua tren `Guest.RecruitmentID` sang workflow Phase 2 day du.

Sau Phase 2:
- `Guest` chi la profile ung vien.
- `Application` la moi lan ung vien nop ho so vao job.
- `Interview` la lich/vong phong van cua application.
- `Offer` la thu moi nhan viec.
- `Notification` la module thong bao dung chung cho moi actor, gan theo `SystemUser.UserID`.

## Dieu kien truoc khi code
- `src/data/data.sql` da co schema cho 4 bang Phase 2.
- Migration `src/data/migrations/2026-06-22_guest_phase2_workflow.sql` tao 4 bang moi.
- Seed `src/data/migrations/2026-06-22_guest_phase2_seed.sql` tao du lieu mau cho dashboard Guest.
- Khong drop cot `Guest.RecruitmentID` trong giai do nay de tranh pha code cu.

## Model can tao
Tao cac model Java theo dung cot database, khong bo cot:
- `Application`
- `Interview`
- `Offer`
- `Notification`

Model `Guest` can tiep tuc giu cac field Phase 1:
- `UserID`
- `Avatar`
- `Gender`
- `DateOfBirth`
- `Address`
- `UpdatedDate`

## DAO can tao hoac cap nhat
### ApplicationDAO
Method toi thieu:
- `findById(int applicationId)`
- `findByGuestId(int guestId)`
- `findByUserId(int userId)`
- `existsByGuestAndRecruitment(int guestId, int recruitmentId)`
- `create(Application application)`
- `updateStatus(int applicationId, String status, String currentStep)`
- `countByUserId(int userId)`
- `countActiveByUserId(int userId)`

### InterviewDAO
Method toi thieu:
- `findByApplicationId(int applicationId)`
- `findUpcomingByUserId(int userId, int limit)`
- `create(Interview interview)`
- `updateSchedule(Interview interview)`
- `updateResult(int interviewId, String status, String result, String note)`

### OfferDAO
Method toi thieu:
- `findByApplicationId(int applicationId)`
- `findPendingByUserId(int userId)`
- `create(Offer offer)`
- `sendOffer(int offerId)`
- `respondOffer(int offerId, int userId, String status)`
- `expireOverdueOffers()`

### NotificationDAO
Notification la module dung chung, khong dat rieng trong GuestDAO.

Method toi thieu:
- `findByUserId(int userId, int limit)`
- `countUnreadByUserId(int userId)`
- `create(Notification notification)`
- `markRead(int notificationId, int userId)`
- `markAllRead(int userId)`

### GuestDAO
Cap nhat them method:
- `findByUserId(int userId)`
- `findOrCreateProfileForUser(SystemUser user)`
- `updateProfile(Guest guest)`
- `findByEmail(String email)`

## Controller route can co
### GuestPortalController
Routes:
- `GET /guest/dashboard`
- `GET /guest/applications`
- `GET /guest/profile`
- `POST /guest/profile`
- `POST /guest/offer/respond`
- `POST /guest/notification/read`

Rule:
- Chi role `Guest` moi truy cap du lieu cua chinh minh.
- Admin duoc truy cap de kiem soat neu filter hien tai cho phep Admin override.
- Moi truy van phai loc theo `SystemUser.UserID` dang nam trong session.

### RecruitmentController
Cap nhat action submit application:
1. Kiem tra user da dang nhap.
2. Lay hoac tao `Guest` profile theo `SystemUser.UserID`.
3. Kiem tra job ton tai va dang duoc ung tuyen.
4. Kiem tra chua co `Application` voi `GuestID + RecruitmentID`.
5. Tao `Application`:
   - `Status = Applied`
   - `CurrentStep = Applied`
   - `AppliedDate = NOW()`
   - `CV` lay tu file upload
   - `CoverLetter` neu form co nhap
   - `Source = Portal`
6. Tao notification loai `Application` cho user.
7. Redirect success page.

Khong tao ho so ung tuyen moi trong `Guest` nua. `Guest.RecruitmentID` chi la du lieu cu/deprecated.

### HR/HR Staff candidate workflow
Controller hien co cua HR/HR Staff can co hanh dong:
- Cap nhat `Application.Status` sang `Screening`, `Interview`, `Offered`, `Rejected`, `Hired`, `Withdrawn`.
- Tao/cap nhat `Interview`.
- Tao/gui `Offer`.
- Tao notification cho Guest khi trang thai thay doi.

Permission can dung:
- HR Manager va HR Staff duoc xu ly ung vien.
- Admin duoc truy cap tat ca de kiem soat.
- Guest khong duoc goi endpoint cap nhat trang thai noi bo.

## Rule chuyen Guest thanh Employee
Phase 2 chi cho tao Employee khi:
- `Offer.Status = Accepted`
- `Application.Status = Hired` hoac se duoc cap nhat thanh `Hired` trong cung transaction
- `Guest.UserID` neu ton tai se duoc cap nhat sang role `Employee` va gan `EmployeeID`

Khong chuyen Employee chi dua tren `Guest.Status`.

## Notification dung chung
`Notification` khong thuoc rieng Guest.

Moi notification gan voi:
- `UserID`: bat buoc, tham chieu `SystemUser.UserID`
- `ApplicationID`: optional, chi dung khi thong bao lien quan ung tuyen
- `Type`: `Application`, `Interview`, `Offer`, `System`

Cac actor co the dung chung:
- Guest: thong bao ho so, phong van, offer.
- Employee: thong bao task, payroll, leave neu sau nay mo rong.
- Dept Manager: thong bao task/team/leave.
- HR/HR Staff: thong bao candidate, contract, payroll.
- Admin: thong bao he thong/security.

## Acceptance Criteria
- [ ] Co du 4 model Java: `Application`, `Interview`, `Offer`, `Notification`.
- [ ] Co DAO doc/ghi cho 4 bang Phase 2.
- [ ] `/guest/dashboard` lay so lieu tu `Application`, `Interview`, `Offer`, `Notification`.
- [ ] `/guest/applications` hien danh sach application theo user dang login.
- [ ] `/guest/profile` doc/cap nhat `Guest` profile theo `SystemUser.UserID`.
- [ ] Submit ung tuyen tao record trong `Application`, khong tao application moi trong `Guest`.
- [ ] Khong cho nop trung cung job theo `GuestID + RecruitmentID`.
- [ ] HR/HR Staff cap nhat duoc application/interview/offer theo permission.
- [ ] Offer accepted moi cho phep chuyen Guest thanh Employee.
- [ ] Notification duoc dung chung theo `SystemUser.UserID`, khong hardcode rieng cho Guest.

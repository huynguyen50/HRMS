# Module Spec: Guest Candidate Portal
Status: Approved
Actor: Guest Candidate
Priority: High
Related Code: `RegisterController`, `GoogleAuthController`, `HomepageController`, `RecruitmentController`, `GuestDAO`, `RecruitmentDAO`, `Views/Homepage.jsp`, `Views/Recruitment.jsp`, `Views/ApplyForm.jsp`, `Views/Success.jsp`

## Muc tieu
Guest Candidate la tai khoan ung vien/chua phai nhan vien trong BetterHR. Actor nay dung he thong de xem tin tuyen dung, nop ho so, theo doi trang thai ho so va cap nhat thong tin ca nhan.

Day khong phai website tuyen dung kieu TopCV. Guest portal la phan cong khai va ban-cong-khai cua HRMS noi bo, phuc vu ung vien da co tai khoan.

## Trang thai code hien tai
- Register local tao `SystemUser` role `Guest`, `EmployeeID = NULL`.
- Google Login tao/cap nhat `SystemUser` role `Guest`, `EmployeeID = NULL`.
- Homepage public da co route `/homepage`.
- Danh sach viec lam dang dung `GET /RecruitmentController`.
- Apply dang dung `GET /RecruitmentController?action=apply&recruitmentId={id}`.
- Submit apply dang dung `POST /RecruitmentController` voi `action=submitApplication`.
- Code hien tai chua dung bang `Application`, `Interview`, `Offer`, `Notification` trong Java/JSP.
- Phase 2 da co spec, schema trong `data.sql`, migration va seed data rieng cho `Application`, `Interview`, `Offer`, `Notification`.
- Bang `Guest` hien tai dang dong vai tro vua la ung vien vua la ho so ung tuyen.

## Quyet dinh thiet ke
Lam Guest theo 2 pha de khong pha code dang chay.

### Phase 1 - Guest portal tren schema hien co
- Mo rong bang `Guest` bang cac cot thong tin ca nhan can thiet.
- Giu `Guest.RecruitmentID` de code apply hien tai van chay.
- Chua tach bang `Application`.
- Guest xem duoc homepage, job list, form apply, success page.
- Guest da login xem duoc ho so da nop dua tren email/UserID.
- HR van co the chuyen ung vien `Hired` thanh Employee theo luong hien tai.

### Phase 2 - Tach workflow tuyen dung day du
- Tao bang `Application` de luu moi lan ung tuyen.
- Tao bang `Interview` de luu nhieu vong phong van.
- Tao bang `Offer` de quan ly thu moi nhan viec.
- Dung bang `Notification` nhu module thong bao chung theo `SystemUser.UserID`.
- Sau khi migrate du lieu, moi xem xet bo/deprecate `Guest.RecruitmentID`.

Trang thai Phase 2 hien tai:
- Da chuan bi spec, `data.sql`, migration va seed data.
- Database Phase 2 da san sang de code workflow moi.
- Java model/DAO/controller/JSP van can duoc implement theo `feature-guest-phase2-implementation.spec.md`.
- Trong khi chua implement Java Phase 2, code cu van co the tiep tuc dung `Guest.RecruitmentID`.
- Khong drop `Guest.RecruitmentID` trong giai do chuyen doi.

## Database Phase 1
Bang `Guest` can bo sung:
- `UserID INT NULL`: lien ket den `SystemUser.UserID`, dung de xac dinh ung vien dang login.
- `Avatar VARCHAR(500) NULL`: anh dai dien ung vien.
- `Gender VARCHAR(20) NULL`: gioi tinh.
- `DateOfBirth DATE NULL`: ngay sinh.
- `Address VARCHAR(255) NULL`: dia chi.
- `UpdatedDate DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`: thoi diem cap nhat profile.

Khong them trong Phase 1:
- `Application`
- `Interview`
- `Offer`
- `CandidateProfile`
- `CandidateCV`
- `CandidateSkill`
- `CandidateEducation`
- `SavedJob`

## Route muc tieu
- `GET /homepage`
- `GET /RecruitmentController`
- `GET /RecruitmentController?action=apply&recruitmentId={recruitmentId}`
- `POST /RecruitmentController`
- `GET /guest/dashboard` hoac route Guest dashboard se tao khi implement portal rieng
- `GET /guest/applications` cho danh sach ho so da nop
- `GET /guest/profile` cho thong tin ca nhan
- `POST /guest/profile` cap nhat thong tin ca nhan

## Feature files
- `feature-guest-homepage.spec.md`
- `feature-guest-job-list.spec.md`
- `feature-guest-job-application.spec.md`
- `feature-guest-application-success.spec.md`
- `feature-guest-dashboard.spec.md`
- `feature-guest-my-applications.spec.md`
- `feature-guest-profile.spec.md`
- `database-guest-phase1.spec.md`
- `database-guest-phase2.spec.md`
- `feature-guest-application-workflow.spec.md`
- `feature-guest-interview.spec.md`
- `feature-guest-offer.spec.md`
- `feature-guest-notification.spec.md`
- `feature-guest-phase2-implementation.spec.md`
- `../_Common/notification.spec.md`

## Nguyen tac phan quyen
- Guest chua login duoc xem homepage public va job list.
- Guest chua login bam ung tuyen phai redirect `/login?error=login_required`.
- Guest da login duoc nop ho so ung tuyen.
- Guest chi xem duoc ho so cua chinh minh.
- Admin co the truy cap tat ca module de kiem soat.
- HR/HR Staff xu ly ung vien theo module tuyen dung noi bo.

## Chuyen doi sang Employee
1. Register local hoac Google Login tao `SystemUser` role `Guest`, `EmployeeID = NULL`.
2. Guest nop ho so ung tuyen.
3. HR xu ly ho so va cap nhat trang thai.
4. Phase 1: khi ung vien `Hired`, HR tao Employee tu candidate da duyet.
5. Neu email da co account Guest, he thong cap nhat account do sang role `Employee` va gan `EmployeeID`.
6. Neu email chua co account, he thong tao `SystemUser` moi role `Employee` va gan `EmployeeID`.
7. Phase 2: chi tao Employee sau khi Offer duoc `Accepted`.

## Acceptance Criteria
- [ ] Guest xem duoc homepage public.
- [ ] Guest xem duoc danh sach job dang tuyen.
- [ ] Guest chua login bam ung tuyen bi yeu cau dang nhap.
- [ ] Guest da login mo duoc form apply.
- [ ] Phase 1: submit application hop le tao record trong bang `Guest`.
- [ ] Phase 2: submit application hop le tao record trong bang `Application`, khong tao ho so ung tuyen moi trong `Guest`.
- [ ] Submit thanh cong sang success page.
- [ ] Guest xem duoc danh sach ho so da nop cua chinh minh.
- [ ] Guest cap nhat duoc profile ca nhan.
- [ ] Account Guest khong co `EmployeeID` truoc khi HR chuyen thanh Employee.
- [ ] Phase 2 chi chuyen Guest thanh Employee sau khi `Offer.Status = Accepted`.

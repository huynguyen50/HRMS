# Database Spec: Guest Phase 2 Workflow
Status: Approved
Actor: Guest Candidate, HR, HR Staff, Admin
Priority: High
Related Files: `src/data/data.sql`, `src/data/migrations/2026-06-22_guest_phase2_workflow.sql`

## Pham vi hien tai
Phase 2 database la nen tang cho workflow Guest moi.

Da co:
- Schema trong `src/data/data.sql`.
- Migration `src/data/migrations/2026-06-22_guest_phase2_workflow.sql`.
- Seed data `src/data/migrations/2026-06-22_guest_phase2_seed.sql`.

Java model/DAO/controller/JSP se duoc implement theo `feature-guest-phase2-implementation.spec.md`.

## Muc tieu
Tach quy trinh ung tuyen ra khoi bang `Guest`.

Trong Phase 1, bang `Guest` dang dong 2 vai tro:
- Thong tin ung vien.
- Ho so ung tuyen vao mot tin tuyen dung.

Trong Phase 2:
- `Guest` giu vai tro profile ung vien.
- `Application` luu moi lan ung tuyen.
- `Interview` luu lich/vong phong van.
- `Offer` luu thu moi nhan viec.
- `Notification` luu thong bao chung cho moi actor theo `SystemUser.UserID`.

## Bang moi

### Application
Luu moi lan ung vien nop ho so vao mot tin tuyen dung.

Cot chinh:
- `ApplicationID`
- `GuestID`
- `RecruitmentID`
- `AppliedDate`
- `Status`
- `CurrentStep`
- `CV`
- `CoverLetter`
- `Source`
- `CreatedDate`
- `UpdatedDate`

Rang buoc:
- `GuestID` tham chieu `Guest.GuestID`.
- `RecruitmentID` tham chieu `Recruitment.RecruitmentID`.
- Unique `GuestID + RecruitmentID` de chan mot ung vien nop trung cung mot job.

Trang thai:
- `Applied`
- `Screening`
- `Interview`
- `Offered`
- `Rejected`
- `Withdrawn`
- `Hired`

### Interview
Luu lich phong van theo tung application.

Cot chinh:
- `InterviewID`
- `ApplicationID`
- `RoundNo`
- `ScheduledAt`
- `Location`
- `MeetingLink`
- `InterviewerEmployeeID`
- `Status`
- `Result`
- `Note`
- `CreatedDate`
- `UpdatedDate`

Trang thai:
- `Scheduled`
- `Completed`
- `Cancelled`
- `NoShow`
- `Rescheduled`

Ket qua:
- `Pending`
- `Passed`
- `Failed`

### Offer
Luu thu moi nhan viec cho application da qua phong van.

Cot chinh:
- `OfferID`
- `ApplicationID`
- `Position`
- `OfferedSalary`
- `StartDate`
- `ExpiredAt`
- `Status`
- `SentAt`
- `RespondedAt`
- `Note`
- `CreatedDate`
- `UpdatedDate`

Trang thai:
- `Draft`
- `Sent`
- `Accepted`
- `Rejected`
- `Expired`
- `Cancelled`

Rang buoc:
- Phase 2 gioi han 1 offer hien hanh cho 1 application bang unique `ApplicationID`.

### Notification
Luu thong bao chung cho account dang nhap. Bang nay khong thuoc rieng Guest.

Cot chinh:
- `NotificationID`
- `UserID`
- `ApplicationID`
- `Title`
- `Message`
- `Type`
- `IsRead`
- `CreatedDate`
- `ReadDate`

Loai thong bao:
- `Application`
- `Interview`
- `Offer`
- `System`

Quy tac dung chung:
- `UserID` bat buoc, tham chieu `SystemUser.UserID`.
- `ApplicationID` optional, chi dung khi thong bao lien quan den application.
- Cac actor khac co the dung cung bang `Notification` neu su kien gan duoc voi `SystemUser.UserID`.
- Chi tiet module thong bao xem `../_Common/notification.spec.md`.

## Backfill du lieu Phase 1
Migration Phase 2 co buoc backfill:

1. Lay cac record `Guest` co `RecruitmentID IS NOT NULL`.
2. Tao record `Application` tu:
   - `Guest.GuestID`
   - `Guest.RecruitmentID`
   - `Guest.AppliedDate`
   - `Guest.CV`
   - `Guest.Status`
3. Map status:
   - `Processing` -> `Applied`
   - `Hired` -> `Hired`
   - `Rejected` -> `Rejected`
4. Khong xoa `Guest.RecruitmentID` trong buoc nay.

## Migration rule
- Chi tao bang moi.
- Khong drop bang/cu cot.
- Khong doi enum `Guest.Status`.
- Khong doi code dang chay.
- Co the chay lai migration ma khong tao trung application da backfill.

## Acceptance Criteria
- [ ] `data.sql` co schema cho `Application`, `Interview`, `Offer`, `Notification`.
- [ ] Migration Phase 2 tao du 4 bang moi.
- [ ] Migration Phase 2 backfill du lieu tu `Guest` sang `Application`.
- [ ] Khong xoa hoac thay doi bang `Guest` trong Phase 2 preparation.
- [ ] Seed Phase 2 co du lieu mau cho `Application`, `Interview`, `Offer`, `Notification`.
- [ ] Java/JSP Phase 2 se dung cac bang moi theo spec implementation rieng.

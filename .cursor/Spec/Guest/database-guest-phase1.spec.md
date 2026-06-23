# Database Spec: Guest Phase 1
Status: Approved
Actor: Guest Candidate, HR, Admin
Priority: High
Related Files: `src/data/migrations/2026-06-22_guest_phase1_profile.sql`

## Schema hien tai da kiem tra
Database: `hrm_db`

Bang `Guest` hien co:
- `GuestID`
- `FullName`
- `Email`
- `Phone`
- `CV`
- `Status`
- `RecruitmentID`
- `AppliedDate`

Bang `Recruitment` hien co:
- `RecruitmentID`
- `JobTitle`
- `JobDescription`
- `Requirement`
- `Location`
- `Salary`
- `Status`
- `PostedDate`
- `Applicant`

Bang khong bat buoc cho Phase 1:
- `Application`
- `Interview`
- `Offer`
- `Notification`

## Cot can them cho Phase 1
Them vao `Guest`:
- `UserID INT NULL`
- `Avatar VARCHAR(500) NULL`
- `Gender VARCHAR(20) NULL`
- `DateOfBirth DATE NULL`
- `Address VARCHAR(255) NULL`
- `UpdatedDate DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`

## Ly do them cot
- `UserID`: lien ket record Guest voi tai khoan dang login, tranh chi dua vao email.
- `Avatar`: phuc vu trang profile Guest.
- `Gender`: thong tin ca nhan co ban.
- `DateOfBirth`: thong tin ca nhan co ban.
- `Address`: thong tin lien he.
- `UpdatedDate`: theo doi lan cap nhat cuoi.

## Khong lam trong Phase 1
Phase 1 khong phu thuoc vao bang `Application`, `Interview`, `Offer`, `Notification`. Cac bang nay thuoc Phase 2 va da co spec/migration rieng de code workflow moi.

Ghi chu cap nhat:
- Phase 2 da co spec va SQL script rieng tai `database-guest-phase2.spec.md`.
- Phase 1 code van khong phu thuoc vao 4 bang Phase 2.
- Khi code Phase 2, khong xoa cac cot Phase 1 trong `Guest` de tranh pha luong cu.

## Code can cap nhat khi bat dau implement
- `Guest.java`: them field/getter/setter cho `userId`, `avatar`, `gender`, `dateOfBirth`, `address`, `updatedDate`.
- `GuestDAO`: map cac cot moi trong cac method get/list/search.
- `GuestDAO.insert`: khi user da login, set `UserID` de lien ket ho so voi account.
- `GuestDAO.update`: cho phep cap nhat profile ca nhan ma khong lam mat `RecruitmentID`.
- Controller Guest portal moi: uu tien truy van theo `UserID`, fallback theo email cho du lieu cu.

## Migration rule
- Chi them cot nullable de khong pha du lieu cu.
- Khong drop cot.
- Khong doi enum `Guest.Status` trong Phase 1.
- Khong xoa `Guest.RecruitmentID` trong Phase 1.
- Tao index cho `UserID`, `Email`, `RecruitmentID + Status` de ho tro truy van portal.

## Acceptance Criteria
- [ ] Migration chay duoc tren database hien tai.
- [ ] Code apply hien tai van insert duoc vao `Guest`.
- [ ] Du lieu cu trong `Guest` khong mat.
- [ ] Guest portal co du cot de lam profile va my applications Phase 1.

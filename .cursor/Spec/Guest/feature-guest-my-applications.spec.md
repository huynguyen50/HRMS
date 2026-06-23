# Feature: Guest xem ho so da nop
Status: Draft
Actor: Guest Candidate
Priority: High
Related Code: `GuestPortalController`, `ApplicationDAO`, `InterviewDAO`, `OfferDAO`, `RecruitmentDAO`

## Route muc tieu
- `GET /guest/applications`

## Phase 1 Data Source
Dung bang `Guest` hien co:
- `Guest.UserID` neu da co.
- Fallback tam thoi bang `Guest.Email = SystemUser.Email` neu du lieu cu chua co `UserID`.
- Join voi `Recruitment` qua `Guest.RecruitmentID`.

## Truong hien thi
- Vi tri ung tuyen.
- Dia diem.
- Muc luong.
- Ngay nop.
- Trang thai.
- CV da nop.

## Mapping status Phase 1
- `Processing` -> Dang xu ly
- `Hired` -> Da duyet
- `Rejected` -> Tu choi

## Timeline Phase 1
Do code Phase 1 chua dung bang `Application`, timeline chi hien 3 buoc:
1. Da nop ho so
2. Dang xu ly
3. Ket qua

## Timeline Phase 2
Khi chay migration va code sang bang `Application`, timeline day du:
1. Applied
2. Screening
3. Interview
4. Offer
5. Hired

## Phase 2 Data Source
Dung bang `Application` lam nguon chinh:
- Join `Application.GuestID -> Guest.GuestID`.
- Join `Application.RecruitmentID -> Recruitment.RecruitmentID`.
- Loc theo `Guest.UserID = session.systemUser.UserID`.
- Lay interview theo `Interview.ApplicationID`.
- Lay offer theo `Offer.ApplicationID`.

Khong dung `Guest.Status` lam trang thai ho so chinh trong Phase 2.

## Acceptance Criteria
- [ ] Guest da login xem duoc danh sach ho so da nop.
- [ ] Guest khong xem duoc ho so cua nguoi khac.
- [ ] Ho so moi nop hien dung job va ngay nop.
- [ ] Trang thai hien tieng Viet.
- [ ] Trang rong hien empty state than thien.
- [ ] Phase 2 hien timeline tu `Application.CurrentStep`, `Interview`, `Offer`.

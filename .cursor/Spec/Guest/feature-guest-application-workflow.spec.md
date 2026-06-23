# Feature: Guest application workflow Phase 2
Status: Draft
Actor: Guest Candidate, HR, HR Staff
Priority: High
Related Data: `Application`, `Guest`, `Recruitment`, `Interview`, `Offer`, `Notification`
Related Code: `RecruitmentController`, `GuestPortalController`, HR/HR Staff candidate controller, `ApplicationDAO`, `InterviewDAO`, `OfferDAO`, `NotificationDAO`

## Muc tieu
Tach moi lan ung tuyen thanh record rieng trong bang `Application`.

## Luong muc tieu
1. Guest dang nhap chon job dang mo.
2. He thong kiem tra Guest profile.
3. He thong kiem tra chua co `Application` voi cung `GuestID + RecruitmentID`.
4. He thong tao `Application` voi:
   - `Status = Applied`
   - `CurrentStep = Applied`
   - `AppliedDate = NOW()`
5. HR/HR Staff cap nhat trang thai qua cac buoc screening, interview, offer.
6. He thong tao notification khi application co thay doi quan trong.

## Rule chong nop trung
- Phase 1 dang can sua theo `UserID + RecruitmentID`.
- Phase 2 dung unique `GuestID + RecruitmentID`.
- Neu da co application cung job, UI hien thong bao tieng Viet va khong tao ban ghi moi.

## Mapping hien thi
- `Applied` -> Da nop ho so
- `Screening` -> Dang sang loc
- `Interview` -> Phong van
- `Offered` -> Da gui offer
- `Rejected` -> Tu choi
- `Withdrawn` -> Da rut ho so
- `Hired` -> Da tuyen

## Acceptance Criteria
- [ ] Moi lan apply tao record trong `Application`, khong tao application moi trong `Guest`.
- [ ] Khong cho nop trung cung job.
- [ ] Guest chi xem application cua chinh minh.
- [ ] HR/HR Staff xem duoc application theo phan quyen tuyen dung.
- [ ] HR/HR Staff cap nhat duoc status: `Screening`, `Interview`, `Offered`, `Rejected`, `Hired`, `Withdrawn`.
- [ ] Moi status update quan trong tao notification cho Guest neu Guest co `UserID`.
- [ ] Dashboard Guest lay so lieu tu `Application`.

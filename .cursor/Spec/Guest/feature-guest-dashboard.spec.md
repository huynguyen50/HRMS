# Feature: Guest dashboard
Status: Draft
Actor: Guest Candidate
Priority: Medium
Related Code: `GuestPortalController`, `ApplicationDAO`, `InterviewDAO`, `OfferDAO`, `NotificationDAO`

## Route muc tieu
- `GET /guest/dashboard`

## Muc tieu
Tao trang tong quan rieng cho Guest sau khi dang nhap. Trang nay khong dung giao dien Admin/HR/Employee.

## Sidebar
- Tong quan
- Viec lam
- Ho so da nop
- Lich phong van
- Thu moi nhan viec
- Thong bao
- Ho so ca nhan
- Doi mat khau
- Dang xuat

## Du lieu Phase 1
Vi code Phase 1 chua dung `Application`, dashboard Phase 1 lay thong tin tu bang `Guest`:
- Tong so ho so da nop: dem record `Guest` theo `UserID` hoac email.
- Dang xu ly: `Guest.Status = 'Processing'`.
- Da duyet/tuyen: `Guest.Status = 'Hired'`.
- Bi tu choi: `Guest.Status = 'Rejected'`.

## Du lieu Phase 2
Khi chay migration va code sang workflow Phase 2, dashboard se lay:
- Tong application.
- Application dang xu ly.
- Lich phong van sap toi.
- Offer dang cho phan hoi.
- Notification moi.

Nguon du lieu Phase 2:
- `ApplicationDAO.countByUserId(systemUser.UserID)`.
- `ApplicationDAO.countActiveByUserId(systemUser.UserID)`.
- `InterviewDAO.findUpcomingByUserId(systemUser.UserID, limit)`.
- `OfferDAO.findPendingByUserId(systemUser.UserID)`.
- `NotificationDAO.findByUserId(systemUser.UserID, limit)`.
- `NotificationDAO.countUnreadByUserId(systemUser.UserID)`.

## Acceptance Criteria
- [ ] Chi Guest da login moi vao duoc.
- [ ] Admin duoc phep truy cap de kiem soat neu co co che impersonate/preview.
- [ ] Guest khong xem duoc du lieu cua Guest khac.
- [ ] So lieu khong loi khi Guest chua nop ho so nao.
- [ ] UI dung BetterHR theme va tieng Viet.
- [ ] Phase 2 dashboard khong dem theo `Guest.Status` nua.

# Feature: Guest notification view Phase 2
Status: Draft
Actor: Guest Candidate
Priority: Medium
Related Data: `Notification`, `SystemUser`, `Application`
Related Common Spec: `../_Common/notification.spec.md`

## Muc tieu
Hien thi notification lien quan den Guest trong Guest portal.

`Notification` la module dung chung cho moi actor, khong thuoc rieng Guest. Spec nay chi mo ta cach Guest xem notification cua chinh minh.

## Su kien tao notification
- Application duoc tao thanh cong.
- Application chuyen trang thai.
- Interview duoc tao/doi lich/huy.
- Offer duoc gui.
- Offer sap het han.
- Offer da duoc HR cap nhat ket qua.

## Hien thi cho Guest
- Thong bao moi tren dashboard.
- Danh sach thong bao.
- Danh dau da doc.

## Data rule
- Loc theo `Notification.UserID = session.systemUser.UserID`.
- Neu notification co `ApplicationID`, chi hien khi application do thuoc Guest dang dang nhap.
- Guest khong duoc xem notification cua actor khac.
- Logic DAO dung chung tai `NotificationDAO`.

## Acceptance Criteria
- [ ] Notification gan voi `SystemUser.UserID`.
- [ ] Notification co the gan voi `ApplicationID` neu lien quan den ho so.
- [ ] Guest chi doc notification cua minh.
- [ ] Thong bao moi hien ro trang thai chua doc.
- [ ] Guest mark read chi cap nhat notification cua chinh minh.

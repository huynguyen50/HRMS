# Feature: Guest offer Phase 2
Status: Draft
Actor: Guest Candidate, HR, HR Staff
Priority: Medium
Related Data: `Offer`, `Application`

## Muc tieu
Quan ly thu moi nhan viec sau khi ung vien vuot qua vong phong van.

## Luong muc tieu
1. HR tao offer cho application da dat.
2. Offer co trang thai `Draft`.
3. Khi gui cho ung vien, status thanh `Sent`.
4. Guest xem offer va chon chap nhan hoac tu choi.
5. Neu `Accepted`, application chuyen sang `Hired`.
6. HR tao Employee tu Guest sau khi offer da accepted.
7. He thong tao notification khi offer duoc gui va khi guest phan hoi.

## Rule chuyen Employee
- Phase 1: HR co the tao Employee khi `Guest.Status = Hired`.
- Phase 2: chi tao Employee khi `Offer.Status = Accepted`.

## Acceptance Criteria
- [ ] Chi application hop le moi tao offer.
- [ ] Guest chi xem offer cua minh.
- [ ] Offer accepted moi cho phep chuyen thanh Employee.
- [ ] Offer qua han khong duoc chap nhan.
- [ ] Guest tu choi offer thi khong chuyen thanh Employee.
- [ ] Notification duoc tao khi offer duoc gui/accepted/rejected.

# Feature: Guest xem trang nop ho so thanh cong
Status: Approved
Actor: Guest Candidate
Priority: Medium
Related Code: `Views/Success.jsp`, `RecruitmentController`

## Route/JSP hien tai
- `/Views/Success.jsp`

## Luong chinh
1. Sau khi ho so duoc luu thanh cong, controller redirect den `/Views/Success.jsp`.
2. Trang success hien thi thong bao nop ho so thanh cong.
3. Ung vien co the quay lai danh sach viec lam hoac homepage.
4. Neu da login, ung vien co the vao trang ho so da nop khi Guest portal duoc implement.

## Noi dung bat buoc
- Thong bao nop ho so thanh cong.
- Huong dan ung vien kiem tra email/thong bao.
- Link quay lai danh sach viec lam.
- Link quay lai homepage.
- Link den `Ho so cua toi` khi co `/guest/applications`.

## Acceptance Criteria
- [ ] Success page chi duoc dung sau submit thanh cong.
- [ ] Noi dung hien thi bang tieng Viet.
- [ ] Co link quay lai danh sach viec lam.
- [ ] Co link quay lai homepage.
- [ ] Khong hien stack trace/loi ky thuat.

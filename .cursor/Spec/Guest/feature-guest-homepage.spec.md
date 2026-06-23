# Feature: Guest xem homepage public
Status: Approved
Actor: Guest Candidate
Priority: Medium
Related Code: `HomepageController`, `Views/Homepage.jsp`, `Views/Login.jsp`, `Views/Register.jsp`

## Route
- `GET /homepage`

## Luong chinh
1. Guest truy cap `/homepage`.
2. Neu chua login, `HomepageController` tao access public/Guest.
3. Controller forward den `/Views/Homepage.jsp`.
4. Guest xem noi dung public, job/link public va nut dieu huong dang nhap/dang ky.
5. Neu da login role Guest, homepage van duoc xem nhu trang cong khai.

## Dieu huong
- Logo `BetterHR` tro ve `/homepage`.
- Nut `Dang nhap` tro den `/login`.
- Nut `Dang ky` tro den `/register`, khong tro nham ve `/login`.
- Link viec lam tro den `/RecruitmentController`.
- Neu da login role Guest, menu role co the hien `Guest` va tro den `/homepage` trong Phase 1.
- Khi co Guest dashboard rieng, menu role Guest se tro den `/guest/dashboard`.

## Noi dung UI
- Giao dien theo BetterHR theme.
- Toan bo text hien thi bang tieng Viet.
- Logo giu ten `BetterHR`.
- Khong hien module noi bo cua HR/Admin neu user chua login.

## Acceptance Criteria
- [ ] Guest vao `/homepage` khong bi bat dang nhap.
- [ ] Homepage hien giao dien public dung BetterHR theme.
- [ ] Nut dang ky mo dung `/register`.
- [ ] Link viec lam mo dung danh sach tuyen dung.
- [ ] Guest chua login khong thay dashboard noi bo.
- [ ] Guest da login khong bi redirect sang dashboard Employee.

## Missing Work
- [ ] Khi tao `/guest/dashboard`, cap nhat `guestUrl` trong `HomepageController`.

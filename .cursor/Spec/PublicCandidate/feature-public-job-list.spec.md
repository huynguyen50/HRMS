# Feature: Ung vien xem danh sach viec lam
Status: Approved
Actor: Guest Candidate
Priority: Medium
Related Code: `RecruitmentController`, `Views/Recruitment.jsp`

## Route
- `GET /RecruitmentController`

## Luong chinh
1. Guest truy cap trang recruitment.
2. Controller lay danh sach recruitment dang mo.
3. Forward den `/Views/Recruitment.jsp`.
4. Guest xem title, dia diem, luong, so luong, mo ta, yeu cau.
5. Guest bam ung tuyen de sang form apply.

## Acceptance Criteria
- [ ] Guest khong can login van xem duoc job list.
- [ ] Chi hien thi job dang mo/available theo status code hien tai.
- [ ] Loi database khong lam lo stack trace ra UI.

## Missing Work
- [ ] Chuan hoa status job public: Available, Closed, Draft.
- [ ] Them search/filter job neu can.

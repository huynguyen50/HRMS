# Feature: Guest xem danh sach viec lam
Status: Approved
Actor: Guest Candidate
Priority: High
Related Code: `RecruitmentController`, `RecruitmentDAO`, `Views/Recruitment.jsp`

## Route hien tai
- `GET /RecruitmentController`

## Route muc tieu Phase 1
- Co the tiep tuc dung `GET /RecruitmentController`.
- Neu tao Guest portal rieng, route `/guest/recruitments` duoc phep goi lai DAO hien co.

## Luong chinh
1. Guest truy cap trang danh sach viec lam.
2. Controller lay danh sach recruitment dang mo.
3. Forward den `/Views/Recruitment.jsp` hoac view Guest portal tuong ung.
4. Guest xem ten vi tri, dia diem, luong, so luong tuyen, mo ta, yeu cau va ngay dang.
5. Guest bam `Ung tuyen ngay`.
6. Neu chua login, he thong redirect `/login?error=login_required`.
7. Neu da login, he thong mo form apply.

## Trang thai job
Theo code/database hien tai, job public dang duoc loc bang:
- `Recruitment.Status = 'Applied'`

Trong Phase 1, giu gia tri nay de khong pha code hien co.

Trong Phase 2, nen chuan hoa enum thanh:
- `Draft`
- `PendingApproval`
- `Open`
- `Closed`
- `Rejected`
- `Deleted`

## Search/Filter muc tieu
- Search theo ten vi tri/mo ta.
- Filter theo phong ban neu sau nay `Recruitment.DepartmentID` duoc them.
- Filter theo dia diem.
- Filter theo muc luong.
- Filter theo deadline neu sau nay co cot `Deadline`.

## Acceptance Criteria
- [ ] Guest khong can login van xem duoc job list.
- [ ] Chi hien thi job dang cho ung tuyen theo status code hien tai.
- [ ] Nut ung tuyen dung route `action=apply&recruitmentId={id}`.
- [ ] Guest chua login bam ung tuyen bi yeu cau dang nhap.
- [ ] Guest da login bam ung tuyen mo duoc form apply.
- [ ] Loi database khong lo stack trace ra UI.

## Missing Work
- [ ] Doi ten status UI sang tieng Viet de ung vien khong thay gia tri enum noi bo.
- [ ] Bo sung search/filter khi implement Guest portal rieng.
- [ ] Can nhac bo gioi han `LIMIT 3` cua `getLatestThree()` neu day la trang danh sach day du.

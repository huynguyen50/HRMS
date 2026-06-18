# Feature: Ung vien nop don ung tuyen
Status: Approved
Actor: Guest Candidate
Priority: High
Related Code: `RecruitmentController`, `GuestDAO`, `Views/ApplyForm.jsp`

## Route
- `GET /RecruitmentController?action=apply&id={recruitmentId}` hoac route apply theo code hien tai.
- `POST /RecruitmentController`

## Luong GET
1. Guest bam Apply Now o danh sach job.
2. Controller lay chi tiet recruitment theo id.
3. Forward den `/Views/ApplyForm.jsp`.

## Luong POST
1. Guest nhap ho ten, email, phone va cac thong tin apply.
2. Guest upload CV neu form yeu cau.
3. Controller validate du lieu.
4. Luu candidate/application qua DAO.
5. Thanh cong redirect `/Views/Success.jsp`.

## Validation
- Ho ten bat buoc.
- Email dung format.
- Phone dung format co ban.
- Recruitment id phai ton tai.
- CV neu upload phai dung dinh dang cho phep.

## Acceptance Criteria
- [ ] Ung vien submit du lieu hop le thanh cong.
- [ ] Thieu email/ho ten/phone hien loi.
- [ ] Recruitment id khong ton tai khong tao application.
- [ ] Submit thanh cong sang success page.

## Missing Work
- [ ] Gioi han kich thuoc upload CV.
- [ ] Chong nop trung email cho cung mot job neu business rule yeu cau.

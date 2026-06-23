# Feature: Guest nop ho so ung tuyen
Status: Approved
Actor: Guest Candidate
Priority: High
Related Code: `RecruitmentController`, `GuestDAO`, `Views/ApplyForm.jsp`

## Route hien tai
- `GET /RecruitmentController?action=apply&recruitmentId={recruitmentId}`
- `POST /RecruitmentController` voi `action=submitApplication`

## Luong chua dang nhap
1. Guest chua dang nhap bam `Ung tuyen ngay`.
2. He thong redirect sang `/login?error=login_required`.
3. Sau khi dang nhap thanh cong, auth hien tai dua user ve `/homepage`.
4. Phase sau co the bo sung `returnUrl` de quay lai job vua xem.

## Luong GET da dang nhap
1. Guest da dang nhap bam `Ung tuyen ngay`.
2. Controller kiem tra session `systemUser`.
3. Controller doc `recruitmentId`.
4. Controller lay chi tiet recruitment theo id.
5. Neu recruitment khong ton tai hoac khong o status public, hien loi va quay lai job list.
6. Neu hop le, forward den `/Views/ApplyForm.jsp`.

## Luong POST Phase 1
1. Guest nhap ho ten, email, phone.
2. Guest upload CV.
3. Controller validate du lieu.
4. Controller luu file CV vao thu muc upload.
5. Controller tao record trong bang `Guest`.
6. `Guest.Status` mac dinh `Processing`.
7. `Guest.RecruitmentID` luu job dang nop.
8. Thanh cong redirect `/Views/Success.jsp`.

## Luong POST Phase 2
Khi code sang bang `Application`:
1. `Guest` chi luu profile ung vien.
2. Controller lay hoac tao `Guest` profile theo `SystemUser.UserID`.
3. Controller kiem tra duplicate theo `GuestID + RecruitmentID`.
4. Moi lan apply hop le tao record trong `Application`.
5. `Application.Status` mac dinh `Applied`.
6. `Application.CurrentStep` mac dinh `Applied`.
7. `Guest.RecruitmentID` se khong con la nguon du lieu chinh.
8. Tao notification loai `Application` cho user dang nop ho so.

## Validation
- Ho ten bat buoc.
- Email dung format.
- Phone dung format co ban.
- Recruitment id phai ton tai.
- CV bat buoc trong Phase 1 theo form hien tai.
- CV chi chap nhan `.pdf`, `.doc`, `.docx`, `.txt`.
- CV toi da 5MB theo `@MultipartConfig` hien tai.

## Duplicate rule
Hien code dang:
- Chan trung phone trong bang `Guest`.
- Cho phep trung email.

Business rule de nghi cho Phase 1:
- Khong cho mot account Guest nop trung cung mot job.
- Neu chua co `UserID`, tam dung email + RecruitmentID de canh bao trung.
- Khi da co `UserID`, dung `UserID + RecruitmentID`.

## Acceptance Criteria
- [ ] Chua login khong mo duoc form apply.
- [ ] Dang login va recruitment hop le thi mo duoc form apply.
- [ ] Submit thieu ho ten/email/phone/CV hien loi tieng Viet.
- [ ] Recruitment id khong ton tai khong tao record.
- [ ] Submit hop le tao record bang `Guest` trong Phase 1.
- [ ] Submit hop le tao record bang `Application` trong Phase 2.
- [ ] Phase 2 khong tao duplicate application cung `GuestID + RecruitmentID`.
- [ ] Submit thanh cong sang success page.

## Missing Work
- [ ] Gan `Guest.UserID` khi submit application.
- [ ] Chuan hoa duplicate rule theo `UserID + RecruitmentID`.
- [ ] Phase 2 tao `Application` thay cho tao ho so ung tuyen moi trong `Guest`.
- [ ] Tao notification khi nop ho so thanh cong.
- [ ] Sua cac chu bi loi encoding trong JSP neu con.

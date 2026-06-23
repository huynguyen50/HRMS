# Feature: Guest cap nhat ho so ca nhan
Status: Draft
Actor: Guest Candidate
Priority: Medium
Related Code: To be implemented, `GuestDAO`, `SystemUserDAO`

## Route muc tieu
- `GET /guest/profile`
- `POST /guest/profile`

## Muc tieu
Cho phep Guest cap nhat thong tin ca nhan co ban. Thong tin nay giup HR xem ung vien ro rang hon va co the tu dong dien vao form apply.

## Database Phase 1
Can cac cot trong bang `Guest`:
- `UserID`
- `Avatar`
- `Gender`
- `DateOfBirth`
- `Address`
- `UpdatedDate`

## Truong duoc sua
- Anh dai dien.
- Ho va ten.
- Gioi tinh.
- Ngay sinh.
- So dien thoai.
- Dia chi.

## Truong chi doc
- GuestID.
- Email dang nhap neu lay tu `SystemUser.Email`.

## Validation
- Ho ten bat buoc.
- Email dung format neu cho phep hien thi/sua.
- Phone dung format co ban.
- DateOfBirth khong duoc lon hon ngay hien tai.
- Avatar chi chap nhan anh hop le neu upload file.

## Acceptance Criteria
- [ ] Guest da login xem duoc profile cua minh.
- [ ] Guest cap nhat thong tin hop le thanh cong.
- [ ] Guest khong cap nhat duoc profile cua nguoi khac.
- [ ] Thong tin profile co the tu dong dien vao form apply.
- [ ] Loi validate hien tieng Viet.

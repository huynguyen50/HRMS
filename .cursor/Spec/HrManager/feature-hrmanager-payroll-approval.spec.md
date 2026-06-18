# Feature: HR Manager duyet payroll
Status: Partial
Actor: HR Manager
Priority: High
Related Code: `PayrollApprovalController`, `PayrollDAO`, `Views/hr/PayrollManagement.jsp`

## Route
- Route do `PayrollApprovalController` khai bao.
- JSP lien quan: `/Views/hr/PayrollManagement.jsp`.

## Luong chinh
1. HR Manager vao man hinh payroll approval.
2. Controller lay danh sach payroll dang cho duyet.
3. HR Manager approve hoac reject payroll.
4. Neu approve, status chuyen sang Approved.
5. Neu reject, status quay ve trang thai can HR Staff sua theo rule.

## Acceptance Criteria
- [ ] HR Staff khong duoc approve payroll cuoi cung.
- [ ] HR Manager duyet payroll hop le thanh cong.
- [ ] Payroll khong ton tai hoac khong dung status bi tu choi.

## Missing Work
- [ ] Dinh nghia permission rieng nhu `APPROVE_PAYROLL`.
- [ ] Them ly do reject payroll.
- [ ] Them audit log cho phe duyet payroll.

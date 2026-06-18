# Feature: HR Manager duyet hop dong
Status: Partial
Actor: HR Manager
Priority: High
Related Code: `ApproveRejectContractController`, `ContractDAO`, `Views/hr/ApproveRejectContract.jsp`

## Route
- Route do `ApproveRejectContractController` khai bao.
- JSP: `/Views/hr/ApproveRejectContract.jsp`.

## Luong chinh
1. HR Manager vao man hinh duyet hop dong.
2. Controller lay danh sach contract cho duyet.
3. HR Manager approve hoac reject.
4. Controller cap nhat status contract.
5. Redirect ve danh sach kem thong bao.

## Acceptance Criteria
- [ ] Chi HR Manager co quyen moi duyet hop dong.
- [ ] Reject phai co ly do neu business rule yeu cau.
- [ ] Khong duyet contract khong ton tai.

## Missing Work
- [ ] Chuan hoa route trong spec sau khi doc/giu on dinh annotation controller.
- [ ] Them audit log approve/reject.

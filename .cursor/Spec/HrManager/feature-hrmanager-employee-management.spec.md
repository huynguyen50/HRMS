# Feature: HR Manager quan ly nhan vien
Status: Partial
Actor: HR Manager
Priority: High
Related Code: `EmployeeListController`, `CreateEmployeeController`, `Views/hr/EmployeeList.jsp`, `Views/hr/CreateEmployee.jsp`

## Route
- Cac route trong package `/hr/*`
- `GET/POST /hr/create-employee`

## Luong danh sach
1. HR Manager vao man hinh danh sach employee.
2. Controller lay danh sach nhan vien.
3. Forward den `/Views/hr/EmployeeList.jsp`.

## Luong tao employee
1. HR Manager vao `/hr/create-employee`.
2. Controller load du lieu form.
3. HR Manager nhap thong tin employee.
4. Controller validate va luu employee.
5. Redirect/forward theo ket qua.

## Acceptance Criteria
- [ ] HR Manager xem duoc danh sach employee.
- [ ] Tao employee thieu thong tin bat buoc bi tu choi.
- [ ] Email/phone neu co rule unique phai duoc validate.

## Missing Work
- [ ] Ghi ro route employee list trong spec sau khi chot controller.
- [ ] Them audit log khi tao employee.

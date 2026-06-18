# Feature: Gan permission cho role
Status: Approved
Actor: Admin
Priority: High
Related Code: `AdminController`, `RolePermissionServlet`, `RolePermissionDAO`, `PermissionDAO`, `Admin/RolePermissionManager.jsp`

## Route
- UI: `GET /admin?action=role-permissions`
- API: `GET /admin/role-permissions/api`
- API: `POST /admin/role-permissions/api`

## Luong UI
1. Admin vao `/admin?action=role-permissions`.
2. Controller kiem tra session.
3. Lay danh sach role va permission summary.
4. Group permission theo category, category null/blank thanh `Khác`.
5. Forward den `Admin/RolePermissionManager.jsp`.

## Luong API GET
1. Frontend goi `/admin/role-permissions/api`.
2. Neu co `roleId`, API tra permission va trang thai granted cua role do.
3. Response la JSON UTF-8.

## Luong API POST
1. Frontend gui JSON co `roleId`, `granted`, va `permissionIds` hoac `permissionId`.
2. Servlet parse body bang `request.getReader()`.
3. Neu granted = true thi gan permission.
4. Neu granted = false thi go permission.
5. Tra JSON status.

## Hien trang code
- API da ton tai.
- Body rong/sai hien tra JSON error message va HTTP 400, khong tra object rong.
- Permission filter yeu cau `MANAGE_ROLE_PERMISSIONS`.

## Acceptance Criteria
- [ ] GET API tra JSON UTF-8.
- [ ] Permission duoc group theo category.
- [ ] POST body thieu `roleId` hoac permission list bi tra 400.
- [ ] User thieu `MANAGE_ROLE_PERMISSIONS` bi chan.

## Missing Work
- [ ] Them test cho grant/revoke nhieu permission cung luc.
- [ ] Ghi audit log khi thay doi permission cua role.

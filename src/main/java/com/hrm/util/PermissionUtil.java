package com.hrm.util;

import com.hrm.dao.PermissionDAO;
import com.hrm.dao.RolePermissionDAO;
import com.hrm.dao.UserPermissionDAO;
import com.hrm.model.entity.SystemUser;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Utility class để kiểm tra quyền của user
 * Hỗ trợ kiểm tra quyền từ RolePermission và UserPermission
 */
public class PermissionUtil {
    
    private static final Logger logger = Logger.getLogger(PermissionUtil.class.getName());
    private static PermissionDAO permissionDAO = new PermissionDAO();
    private static RolePermissionDAO rolePermissionDAO = new RolePermissionDAO();
    private static UserPermissionDAO userPermissionDAO = new UserPermissionDAO();
    
    /**
     * Kiểm tra user có quyền thực hiện một action không
     * @param user User cần kiểm tra
     * @param permissionCode Mã quyền cần kiểm tra (ví dụ: "VIEW_EMPLOYEES")
     * @param scopeValue Giá trị scope (ví dụ: DepartmentID nếu scope là DEPARTMENT)
     * @return true nếu có quyền, false nếu không
     */
    public static boolean hasPermission(SystemUser user, String permissionCode, Integer scopeValue) {
        if (user == null) {
            return false;
        }
        
        try {
            // Admin luôn có tất cả quyền
            if (user.getRoleId() == 1) { // RoleID 1 = Admin
                return true;
            }
            
            // Lấy PermissionID từ permissionCode
            com.hrm.model.entity.Permission perm = permissionDAO.getPermissionByCode(permissionCode);
            if (perm == null) {
                logger.log(Level.WARNING, "Permission code not found: " + permissionCode);
                return false;
            }
            int permissionId = perm.getPermissionId();
            
            // Kiểm tra UserPermission trước (ưu tiên cao hơn RolePermission)
            Boolean userPermissionResult = checkUserPermission(user.getUserId(), permissionId, scopeValue);
            if (userPermissionResult != null) { // Nếu có UserPermission (granted hoặc revoked)
                return userPermissionResult;
            }
            
            // Kiểm tra RolePermission (quyền mặc định của role)
            return checkRolePermission(user.getRoleId(), permissionId);
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking permission: " + permissionCode, e);
            return false;
        }
    }
    
    /**
     * Kiểm tra user có quyền không (không cần scope)
     */
    public static boolean hasPermission(SystemUser user, String permissionCode) {
        return hasPermission(user, permissionCode, null);
    }
    
    /**
     * Kiểm tra UserPermission
     * @return true nếu granted, false nếu revoked, null nếu không có UserPermission
     */
    private static Boolean checkUserPermission(int userId, int permissionId, Integer scopeValue) throws SQLException {
        try {
            List<com.hrm.model.entity.UserPermission> userPermissions = userPermissionDAO.getUserPermissions(userId);
            Boolean result = null;
            
            for (com.hrm.model.entity.UserPermission up : userPermissions) {
                if (up.getPermissionId() == permissionId) {
                    String scope = up.getScope();
                    Integer upScopeValue = up.getScopeValue();
                    
                    // Kiểm tra scope
                    if ("ALL".equals(scope)) {
                        // ALL scope: áp dụng cho tất cả
                        result = up.isIsGranted();
                        break; // Ưu tiên cao nhất, dừng ngay
                    } else if ("DEPARTMENT".equals(scope)) {
                        // DEPARTMENT scope: chỉ áp dụng nếu scopeValue khớp
                        if (scopeValue != null && scopeValue.equals(upScopeValue)) {
                            result = up.isIsGranted();
                            break; // Tìm thấy match, dừng ngay
                        }
                        // Nếu không khớp, tiếp tục tìm
                    } else if ("SELF".equals(scope)) {
                        // SELF scope: user chỉ có quyền với dữ liệu của chính họ
                        // Logic này cần được xử lý ở controller level
                        result = up.isIsGranted();
                        // Không break, có thể có quyền ALL sau đó
                    }
                }
            }
            
            return result; // null nếu không có UserPermission phù hợp
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking user permission", e);
            throw e;
        }
    }
    
    /**
     * Kiểm tra RolePermission
     */
    private static boolean checkRolePermission(int roleId, int permissionId) throws SQLException {
        return rolePermissionDAO.hasRolePermission(roleId, permissionId);
    }
    
    /**
     * Kiểm tra user có quyền với scope DEPARTMENT không
     */
    public static boolean hasDepartmentPermission(SystemUser user, String permissionCode, int departmentId) {
        return hasPermission(user, permissionCode, departmentId);
    }
    
    /**
     * Kiểm tra user có quyền với scope SELF không (chỉ với dữ liệu của chính họ)
     */
    public static boolean hasSelfPermission(SystemUser user, String permissionCode, int resourceOwnerId) {
        if (user == null) {
            return false;
        }
        
        // Nếu user là chủ sở hữu resource, cho phép
        if (user.getEmployeeId() != null && user.getEmployeeId() == resourceOwnerId) {
            return hasPermission(user, permissionCode, null);
        }
        
        return false;
    }
    
    /**
     * Helper method để chuyển hướng đến trang AccessDenied
     */
    public static void redirectToAccessDenied(jakarta.servlet.http.HttpServletRequest request, 
                                             jakarta.servlet.http.HttpServletResponse response,
                                             String permissionCode) throws java.io.IOException {
        redirectToAccessDenied(request, response, permissionCode, null);
    }
    
    /**
     * Helper method để chuyển hướng đến trang AccessDenied với permission name
     */
    public static void redirectToAccessDenied(jakarta.servlet.http.HttpServletRequest request, 
                                             jakarta.servlet.http.HttpServletResponse response,
                                             String permissionCode, String permissionName) throws java.io.IOException {
        request.setAttribute("permissionCode", permissionCode);
        if (permissionName != null) {
            request.setAttribute("permissionName", permissionName);
        }
        try {
            request.getRequestDispatcher("/Views/AccessDenied.jsp").forward(request, response);
        } catch (jakarta.servlet.ServletException e) {
            logger.log(Level.SEVERE, "Error forwarding to AccessDenied page", e);
            response.sendRedirect(request.getContextPath() + "/Views/AccessDenied.jsp");
        }
    }
}


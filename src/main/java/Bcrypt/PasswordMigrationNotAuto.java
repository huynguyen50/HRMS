/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package Bcrypt;

import com.hrm.dao.DAO;
import com.hrm.model.entity.SystemUser;
import java.util.List;

public class PasswordMigrationNotAuto {
    public static void main(String[] args) {
        System.out.println("Bắt đầu quá trình mã hóa mật khẩu...");
        
        DAO dao = DAO.getInstance();
        List<SystemUser> users = dao.getAllSystemUsers();

        if (users == null || users.isEmpty()) {
            System.out.println("Không tìm thấy người dùng nào trong database.");
            return;
        }

        System.out.println("Tìm thấy " + users.size() + " người dùng. Bắt đầu mã hóa...");

        int successCount = 0;
        int failCount = 0;

        for (SystemUser user : users) {
            try {
                String plainPassword = user.getPassword(); // Lấy mật khẩu thô, ví dụ "12345678"
                String hashedPassword = dao.hashPassword(plainPassword); // Mã hóa nó
                
                // Cập nhật lại mật khẩu đã mã hóa vào database
                boolean success = dao.updateUserPassword(user.getUserId(), hashedPassword);
                
                if (success) {
                    successCount++;
                    System.out.println("✓ Đã mã hóa thành công cho user: " + user.getUsername());
                } else {
                    failCount++;
                    System.err.println("✗ Lỗi khi cập nhật cho user: " + user.getUsername());
                }
            } catch (Exception e) {
                failCount++;
                System.err.println("✗ Lỗi khi xử lý user " + user.getUsername() + ": " + e.getMessage());
            }
        }
        
        System.out.println("\n--- HOÀN TẤT ---");
        System.out.println("Thành công: " + successCount + " người dùng.");
        System.out.println("Thất bại: " + failCount + " người dùng.");
        System.out.println("Quá trình mã hóa mật khẩu đã kết thúc.");
    }
}
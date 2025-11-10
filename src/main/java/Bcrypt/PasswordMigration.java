/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Bcrypt;

import com.hrm.dao.DAO;
import com.hrm.model.entity.SystemUser;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.List;

@WebListener
public class PasswordMigration implements ServletContextListener{
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Phương thức này sẽ được gọi tự động khi ứng dụng web khởi động
        System.out.println("===============================================");
        System.out.println("Ứng dụng đang khởi động. Kiểm tra migration mật khẩu...");
        System.out.println("===============================================");
        
        try {
            DAO dao = DAO.getInstance();
            
            // Lấy một người dùng bất kỳ để kiểm tra
            List<SystemUser> users = dao.getAllSystemUsers();
            
            if (users == null || users.isEmpty()) {
                System.out.println("Không có người dùng nào trong database. Bỏ qua migration.");
                return;
            }
            
            // Lấy người dùng đầu tiên để kiểm tra định dạng mật khẩu
            SystemUser firstUser = users.get(0);
            String password = firstUser.getPassword();
            
            // Kiểm tra xem mật khẩu đã được mã hóa chưa
            // Mật khẩu BCrypt sẽ luôn bắt đầu bằng "$2a$" hoặc "$2b$"
            if (password != null && password.startsWith("$2")) {
                System.out.println("Mật khẩu đã được mã hóa. Không cần migration.");
                return;
            }
            
            // Nếu đến đây, tức là mật khẩu chưa được mã hóa
            System.out.println("Phát hiện mật khẩu chưa được mã hóa. Bắt đầu migration...");
            
            // Chạy migration
            int successCount = 0;
            int failCount = 0;
            
            for (SystemUser user : users) {
                try {
                    String plainPassword = user.getPassword();
                    String hashedPassword = dao.hashPassword(plainPassword);
                    
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
            
            System.out.println("\n--- MIGRATION HOÀN TẤT ---");
            System.out.println("Thành công: " + successCount + " người dùng.");
            System.out.println("Thất bại: " + failCount + " người dùng.");
            
        } catch (Exception e) {
            System.err.println("Lỗi nghiêm trọng trong quá trình migration: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("===============================================");
        System.out.println("Kiểm tra migration hoàn tất. Ứng dụng sẵn sàng.");
        System.out.println("===============================================");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Phương thức này được gọi khi ứng dụng web dừng
        System.out.println("Ứng dụng đang dừng...");
    }
}
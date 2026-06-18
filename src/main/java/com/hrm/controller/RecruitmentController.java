/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.hrm.controller;

import com.hrm.dao.RecruitmentDAO;
import com.hrm.dao.GuestDAO;
import com.hrm.model.entity.Recruitment;
import com.hrm.model.entity.Guest;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import jakarta.servlet.RequestDispatcher;

/**
 *
 * @author admin
 */
@WebServlet(name="RecruitmentController", urlPatterns={"/RecruitmentController"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 5,       // 5MB
    maxRequestSize = 1024 * 1024 * 10     // 10MB
)
public class RecruitmentController extends HttpServlet {
   
    private static final Logger LOGGER = Logger.getLogger(RecruitmentController.class.getName());
    private RecruitmentDAO recruitmentDAO = new RecruitmentDAO();
    private GuestDAO guestDAO = new GuestDAO();
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                showRecruitmentList(request, response);
                break;
            case "apply":
                showApplyForm(request, response);
                break;
            case "submitApplication":
                submitApplication(request, response);
                break;
            case "view":
                viewRecruitment(request, response);
                break;
            default:
                showRecruitmentList(request, response);
                break;
        }
    }
    
    private void showRecruitmentList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Chỉ lấy các tin tuyển dụng có status = 'Applied'
            // Các trạng thái New, Waiting, Close, Deleted sẽ không được hiển thị
            var recruitments = recruitmentDAO.getLatestThree();
            request.setAttribute("recruitments", recruitments);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Views/Recruitment.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Không tải được danh sách tuyển dụng", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void showApplyForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login?error=login_required");
            return;
        }

        try {
            String recruitmentIdStr = request.getParameter("recruitmentId");
            if (recruitmentIdStr != null) {
                int recruitmentId = Integer.parseInt(recruitmentIdStr);
                Recruitment recruitment = recruitmentDAO.getById(recruitmentId);
                
                // Check Status - only allow apply if status is Applied
                if (recruitment != null) {
                    String status = recruitment.getStatus();
                    if (status == null || !status.equals("Applied")) {
                        request.setAttribute("error", "Tin tuyển dụng này không còn nhận hồ sơ.");
                        showRecruitmentList(request, response);
                        return;
                    }
                    request.setAttribute("recruitment", recruitment);
                } else {
                    request.setAttribute("error", "Không tìm thấy tin tuyển dụng!");
                    showRecruitmentList(request, response);
                    return;
                }
            }
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Views/ApplyForm.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Không mở được form ứng tuyển", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void submitApplication(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login?error=login_required");
            return;
        }

        try {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String recruitmentIdStr = request.getParameter("recruitmentId");

            if (fullName != null && email != null && phone != null && recruitmentIdStr != null) {
                int recruitmentId = Integer.parseInt(recruitmentIdStr);
                
                // Check if phone number already exists
                if (guestDAO.isPhoneExists(phone)) {
                    request.setAttribute("error", "Số điện thoại này đã được dùng để ứng tuyển.");
                    // Keep recruitment information when forwarding back
                    Recruitment recruitment = recruitmentDAO.getById(recruitmentId);
                    if (recruitment != null) {
                        request.setAttribute("recruitment", recruitment);
                    }
                    showApplyForm(request, response);
                    return;
                }
                
                // EMAIL DUPLICATE CHECK REMOVED - Allow multiple applications with same email
                
                String cvFileName = null;
                Part cvFilePart = request.getPart("cvFile");
                // Lấy đường dẫn thực tế của webapp từ servlet context
                String uploadRelativePath = "/Upload/cvs";
                String uploadPath = getServletContext().getRealPath(uploadRelativePath);
                Path uploadDir = null;
                if (uploadPath != null) {
                    uploadDir = Paths.get(uploadPath);
                } else {
                    // Fallback khi chạy ở môi trường không hỗ trợ getRealPath (ví dụ: chạy jar)
                    uploadDir = Paths.get(System.getProperty("user.home"), "hrms", "Upload", "cvs");
                }

                if (cvFilePart != null && cvFilePart.getSize() > 0) {
                    String originalFileName = getFileName(cvFilePart);
                    if (originalFileName != null && !originalFileName.isEmpty()) {
                        String fileExtension = getFileExtension(originalFileName);
                        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

                        // Phần này giữ nguyên
                        if (!Files.exists(uploadDir)) {
                            Files.createDirectories(uploadDir);
                        }

                        Path filePath = uploadDir.resolve(uniqueFileName);
                        try (InputStream fileContent = cvFilePart.getInputStream()) {
                            Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
                            cvFileName = uniqueFileName; // Lưu tên file unique
                        } catch (IOException e) {
                            LOGGER.log(Level.WARNING, "Không lưu được file CV", e);
                        }
                    }
                }

                if (cvFileName == null) {
                    request.setAttribute("error", "Vui lòng chọn file CV hợp lệ.");
                    // Giữ lại thông tin recruitment khi forward lại
                    Recruitment recruitment = recruitmentDAO.getById(recruitmentId);
                    if (recruitment != null) {
                        request.setAttribute("recruitment", recruitment);
                    }
                    showApplyForm(request, response);
                    return;
                }
                
                Guest guest = new Guest();
                guest.setFullName(fullName);
                guest.setEmail(email);
                guest.setPhone(phone);
                guest.setCv(cvFileName); // Lưu tên file thay vì nội dung text
                guest.setStatus("Processing"); // Status phải là Processing, Hired, hoặc Rejected
                guest.setRecruitmentId(recruitmentId);
                guest.setAppliedDate(LocalDateTime.now());
                
                boolean insertResult = guestDAO.insert(guest);
                
                if (insertResult) {
                    response.sendRedirect(request.getContextPath() + "/Views/Success.jsp");
                } else {
                    request.setAttribute("error", "Không thể gửi hồ sơ. Vui lòng thử lại.");
                    // Giữ lại thông tin recruitment khi forward lại
                    Recruitment recruitment = recruitmentDAO.getById(recruitmentId);
                    if (recruitment != null) {
                        request.setAttribute("recruitment", recruitment);
                    }
                    showApplyForm(request, response);
                }
            } else {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc.");
                // Keep recruitment information if recruitmentId exists
                if (recruitmentIdStr != null) {
                    try {
                        int recruitmentId = Integer.parseInt(recruitmentIdStr);
                        Recruitment recruitment = recruitmentDAO.getById(recruitmentId);
                        if (recruitment != null) {
                            request.setAttribute("recruitment", recruitment);
                        }
                    } catch (NumberFormatException e) {
                        // Ignore
                    }
                }
                showApplyForm(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Không gửi được hồ sơ ứng tuyển", e);
            request.setAttribute("error", "Có lỗi xảy ra khi gửi hồ sơ. Vui lòng thử lại.");
            // Keep recruitment information if recruitmentId exists
            String recruitmentIdStr = request.getParameter("recruitmentId");
            if (recruitmentIdStr != null) {
                try {
                    int recruitmentId = Integer.parseInt(recruitmentIdStr);
                    Recruitment recruitment = recruitmentDAO.getById(recruitmentId);
                    if (recruitment != null) {
                        request.setAttribute("recruitment", recruitment);
                    }
                } catch (NumberFormatException ex) {
                    // Ignore
                }
            }
            showApplyForm(request, response);
        }
    }

    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("systemUser") != null;
    }
    
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            String[] tokens = contentDisposition.split(";");
            for (String token : tokens) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf("=") + 2, token.length() - 1);
                }
            }
        }
        return null;
    }
    
    private String getFileExtension(String fileName) {
        if (fileName != null && fileName.contains(".")) {
            return fileName.substring(fileName.lastIndexOf("."));
        }
        return "";
    }
    
    private void viewRecruitment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String recruitmentIdStr = request.getParameter("recruitmentId");
            if (recruitmentIdStr != null) {
                int recruitmentId = Integer.parseInt(recruitmentIdStr);
                Recruitment recruitment = recruitmentDAO.getById(recruitmentId);
                request.setAttribute("recruitment", recruitment);
                
                RequestDispatcher dispatcher = request.getRequestDispatcher("/Views/RecruitmentDetail.jsp");
                dispatcher.forward(request, response);
            } else {
                showRecruitmentList(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Không xem được chi tiết tuyển dụng", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
* Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Recruitment Controller";
    }// </editor-fold>

}

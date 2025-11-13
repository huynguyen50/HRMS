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
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
    
    private void showApplyForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String recruitmentIdStr = request.getParameter("recruitmentId");
            if (recruitmentIdStr != null) {
                int recruitmentId = Integer.parseInt(recruitmentIdStr);
                Recruitment recruitment = recruitmentDAO.getById(recruitmentId);
                
                // Kiểm tra Status - chỉ cho phép apply nếu status là Applied
                if (recruitment != null) {
                    String status = recruitment.getStatus();
                    if (status == null || !status.equals("Applied")) {
                        request.setAttribute("error", "Tin tuyển dụng này không khả dụng hoặc đã đóng!");
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
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
    
    private void submitApplication(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String coverLetter = request.getParameter("coverLetter");
            String recruitmentIdStr = request.getParameter("recruitmentId");
            
            System.out.println("=== DEBUG: Form submission data ===");
            System.out.println("Full Name: " + fullName);
            System.out.println("Email: " + email);
            System.out.println("Phone: " + phone);
            System.out.println("Recruitment ID: " + recruitmentIdStr);
            System.out.println("Cover Letter: " + (coverLetter != null ? coverLetter.substring(0, Math.min(50, coverLetter.length())) + "..." : "null"));
            
            if (fullName != null && email != null && phone != null && recruitmentIdStr != null) {
                int recruitmentId = Integer.parseInt(recruitmentIdStr);
                
                // Kiểm tra số điện thoại đã tồn tại chưa
                System.out.println("Checking if phone exists: " + phone);
                if (guestDAO.isPhoneExists(phone)) {
                    System.out.println("Phone already exists!");
                    request.setAttribute("error", "Số điện thoại này đã được sử dụng để nộp đơn trước đó!");
                    // Giữ lại thông tin recruitment khi forward lại
                    Recruitment recruitment = recruitmentDAO.getById(recruitmentId);
                    if (recruitment != null) {
                        request.setAttribute("recruitment", recruitment);
                    }
                    showApplyForm(request, response);
                    return;
                }
                
                System.out.println("Checking if email exists: " + email);
                if (guestDAO.isEmailExists(email)) {
                    System.out.println("Email already exists!");
                    request.setAttribute("error", "Email này đã được sử dụng để nộp đơn trước đó!");
                    // Giữ lại thông tin recruitment khi forward lại
                    Recruitment recruitment = recruitmentDAO.getById(recruitmentId);
                    if (recruitment != null) {
                        request.setAttribute("recruitment", recruitment);
                    }
                    showApplyForm(request, response);
                    return;
                }

                String cvFileName = null;
                Part cvFilePart = request.getPart("cvFile");
                System.out.println("CV File Part: " + (cvFilePart != null ? "Found" : "Not found"));
                String uploadPath = "C/Users/admin/OneDrive/Desktop/HRMS/src/main/java/src/main/webapp/Upload/cvs";
                System.out.println("Fixed Upload path: " + uploadPath);

                if (cvFilePart != null && cvFilePart.getSize() > 0) {
                    String originalFileName = getFileName(cvFilePart);
                    if (originalFileName != null && !originalFileName.isEmpty()) {
                        String fileExtension = getFileExtension(originalFileName);
                        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

                        // Phần này giữ nguyên
                        Path uploadDir = Paths.get(uploadPath);
                        if (!Files.exists(uploadDir)) {
                            Files.createDirectories(uploadDir);
                        }

                        Path filePath = uploadDir.resolve(uniqueFileName);
                        try (InputStream fileContent = cvFilePart.getInputStream()) {
                            Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
                            cvFileName = uniqueFileName; // Lưu tên file unique
                            System.out.println("File saved successfully: " + cvFileName);
                        } catch (IOException e) {
                            System.out.println("Error saving file: " + e.getMessage());
                        }
                    }
                }

                if (cvFileName == null) {
                    System.out.println("No CV file provided or file saving failed!");
                    request.setAttribute("error", "Vui lòng chọn file CV và đảm bảo file được lưu thành công!");
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
                
                System.out.println("Attempting to insert guest: " + guest.toString());
                boolean insertResult = guestDAO.insert(guest);
                System.out.println("Insert result: " + insertResult);
                
                if (insertResult) {
                    System.out.println("Redirecting to success page");
                    response.sendRedirect(request.getContextPath() + "/Views/Success.jsp");
                } else {
                    System.out.println("Insert failed!");
                    request.setAttribute("error", "Có lỗi xảy ra khi nộp đơn. Vui lòng thử lại!");
                    // Giữ lại thông tin recruitment khi forward lại
                    Recruitment recruitment = recruitmentDAO.getById(recruitmentId);
                    if (recruitment != null) {
                        request.setAttribute("recruitment", recruitment);
                    }
                    showApplyForm(request, response);
                }
            } else {
                System.out.println("Missing required fields!");
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
                // Giữ lại thông tin recruitment nếu có recruitmentId
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
            System.err.println("=== ERROR in submitApplication ===");
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            // Giữ lại thông tin recruitment nếu có recruitmentId
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
            e.printStackTrace();
            response.sendRedirect("error.jsp");
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

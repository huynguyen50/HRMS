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
            // Lấy 3 tin tuyển dụng mới nhất
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
                request.setAttribute("recruitment", recruitment);
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
                
                // Kiểm tra email đã tồn tại chưa
                System.out.println("Checking if email exists: " + email);
                if (guestDAO.isEmailExists(email)) {
                    System.out.println("Email already exists!");
                    request.setAttribute("error", "Email này đã được sử dụng để nộp đơn trước đó!");
                    showApplyForm(request, response);
                    return;
                }
                
                // Xử lý file upload
                String cvFileName = null;
                Part cvFilePart = request.getPart("cvFile");
                System.out.println("CV File Part: " + (cvFilePart != null ? "Found" : "Not found"));
if (cvFilePart != null && cvFilePart.getSize() > 0) {
                    System.out.println("File size: " + cvFilePart.getSize() + " bytes");
                    String originalFileName = getFileName(cvFilePart);
                    System.out.println("Original filename: " + originalFileName);
                    
                    if (originalFileName != null && !originalFileName.isEmpty()) {
                        // Tạo tên file unique
                        String fileExtension = getFileExtension(originalFileName);
                        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                        System.out.println("Unique filename: " + uniqueFileName);
                        
                        // Tạo thư mục upload nếu chưa có
                        String uploadPath = request.getServletContext().getRealPath("/Upload/cvs");
                        System.out.println("Upload path: " + uploadPath);
                        Path uploadDir = Paths.get(uploadPath);
                        if (!Files.exists(uploadDir)) {
                            System.out.println("Creating upload directory: " + uploadDir);
                            Files.createDirectories(uploadDir);
                        }
                        
                        // Lưu file
                        Path filePath = uploadDir.resolve(uniqueFileName);
                        System.out.println("Saving file to: " + filePath);
                        try (InputStream fileContent = cvFilePart.getInputStream()) {
                            Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
                            cvFileName = uniqueFileName;
                            System.out.println("File saved successfully: " + cvFileName);
                        }
                    }
                }
                
                if (cvFileName == null) {
                    System.out.println("No CV file provided!");
                    request.setAttribute("error", "Vui lòng chọn file CV!");
                    showApplyForm(request, response);
                    return;
                }
                
                Guest guest = new Guest();
                guest.setFullName(fullName);
                guest.setEmail(email);
                guest.setPhone(phone);
                guest.setCv(cvFileName); // Lưu tên file thay vì nội dung text
                guest.setStatus("Applied");
                guest.setRecruitmentId(recruitmentId);
                guest.setAppliedDate(LocalDateTime.now());
                
                System.out.println("Attempting to insert guest: " + guest.toString());
                boolean insertResult = guestDAO.insert(guest);
                System.out.println("Insert result: " + insertResult);
                
                if (insertResult) {
                    System.out.println("Redirecting to success page");
response.sendRedirect("Views/Success.jsp");
                } else {
                    System.out.println("Insert failed!");
                    request.setAttribute("error", "Có lỗi xảy ra khi nộp đơn. Vui lòng thử lại!");
                    showApplyForm(request, response);
                }
            } else {
                System.out.println("Missing required fields!");
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
                showApplyForm(request, response);
            }
        } catch (Exception e) {
            System.err.println("=== ERROR in submitApplication ===");
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
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

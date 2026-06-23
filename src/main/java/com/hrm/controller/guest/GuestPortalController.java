package com.hrm.controller.guest;

import com.hrm.dao.GuestDAO;
import com.hrm.model.entity.Guest;
import com.hrm.model.entity.SystemUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet(name = "GuestPortalController", urlPatterns = {
        "/guest",
        "/guest/dashboard",
        "/guest/applications",
        "/guest/profile"
})
public class GuestPortalController extends HttpServlet {

    private final transient GuestDAO guestDAO = new GuestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SystemUser currentUser = getCurrentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=login_required");
            return;
        }

        String path = request.getServletPath();
        if ("/guest".equals(path)) {
            response.sendRedirect(request.getContextPath() + "/guest/dashboard");
            return;
        }

        loadBaseData(request, currentUser);

        switch (path) {
            case "/guest/applications" ->
                    request.getRequestDispatcher("/Views/Guest/Applications.jsp").forward(request, response);
            case "/guest/profile" -> {
                setProfileMessages(request);
                request.getRequestDispatcher("/Views/Guest/Profile.jsp").forward(request, response);
            }
            case "/guest/dashboard" ->
                    request.getRequestDispatcher("/Views/Guest/Dashboard.jsp").forward(request, response);
            default -> response.sendRedirect(request.getContextPath() + "/guest/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SystemUser currentUser = getCurrentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=login_required");
            return;
        }

        String path = request.getServletPath();
        if (!"/guest/profile".equals(path)) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        request.setCharacterEncoding("UTF-8");
        Guest profile;
        try {
            profile = buildProfileFromRequest(request, currentUser);
        } catch (DateTimeParseException ex) {
            response.sendRedirect(request.getContextPath() + "/guest/profile?error=invalid_date");
            return;
        }
        if (profile.getFullName() == null || profile.getFullName().isBlank()) {
            response.sendRedirect(request.getContextPath() + "/guest/profile?error=missing_name");
            return;
        }

        Guest existingProfile = guestDAO.findProfileByUserOrEmail(currentUser.getUserId(), currentUser.getEmail());
        if (existingProfile != null) {
            profile.setGuestId(existingProfile.getGuestId());
        }

        boolean saved = guestDAO.saveProfile(profile);
        response.sendRedirect(request.getContextPath() + "/guest/profile?" + (saved ? "saved=1" : "error=save"));
    }

    private void loadBaseData(HttpServletRequest request, SystemUser currentUser) {
        Guest profile = guestDAO.findProfileByUserOrEmail(currentUser.getUserId(), currentUser.getEmail());
        if (profile == null) {
            profile = defaultProfile(currentUser);
        }

        List<GuestDAO.GuestApplication> applications =
                guestDAO.getApplicationsByUserOrEmail(currentUser.getUserId(), currentUser.getEmail());

        request.setAttribute("currentUser", currentUser);
        request.setAttribute("guestProfile", profile);
        request.setAttribute("applications", applications);
        request.setAttribute("totalApplications",
                guestDAO.countApplicationsByUserOrEmail(currentUser.getUserId(), currentUser.getEmail()));
        request.setAttribute("processingApplications",
                guestDAO.countApplicationsByUserOrEmailAndStatus(currentUser.getUserId(), currentUser.getEmail(), "Processing"));
        request.setAttribute("hiredApplications",
                guestDAO.countApplicationsByUserOrEmailAndStatus(currentUser.getUserId(), currentUser.getEmail(), "Hired"));
        request.setAttribute("rejectedApplications",
                guestDAO.countApplicationsByUserOrEmailAndStatus(currentUser.getUserId(), currentUser.getEmail(), "Rejected"));
    }

    private void setProfileMessages(HttpServletRequest request) {
        if ("1".equals(request.getParameter("saved"))) {
            request.setAttribute("success", "Cập nhật hồ sơ thành công.");
        }
        String error = request.getParameter("error");
        if ("missing_name".equals(error)) {
            request.setAttribute("error", "Họ và tên là bắt buộc.");
        } else if ("invalid_date".equals(error)) {
            request.setAttribute("error", "Ngày sinh không hợp lệ.");
        } else if ("save".equals(error)) {
            request.setAttribute("error", "Không thể lưu hồ sơ. Vui lòng thử lại.");
        }
    }

    private Guest buildProfileFromRequest(HttpServletRequest request, SystemUser currentUser) {
        Guest profile = new Guest();
        profile.setUserId(currentUser.getUserId());
        profile.setFullName(trimToNull(request.getParameter("fullName")));
        profile.setEmail(currentUser.getEmail());
        profile.setPhone(trimToNull(request.getParameter("phone")));
        profile.setAvatar(trimToNull(request.getParameter("avatar")));
        profile.setGender(trimToNull(request.getParameter("gender")));
        profile.setAddress(trimToNull(request.getParameter("address")));
        profile.setStatus("Processing");

        String dateOfBirth = trimToNull(request.getParameter("dateOfBirth"));
        if (dateOfBirth != null) {
            try {
                LocalDate parsedDate = LocalDate.parse(dateOfBirth);
                if (parsedDate.isAfter(LocalDate.now())) {
                    throw new DateTimeParseException("future date", dateOfBirth, 0);
                }
                profile.setDateOfBirth(parsedDate);
            } catch (DateTimeParseException ex) {
                throw ex;
            }
        }
        return profile;
    }

    private Guest defaultProfile(SystemUser currentUser) {
        Guest profile = new Guest();
        profile.setUserId(currentUser.getUserId());
        profile.setFullName(firstNonBlank(currentUser.getUsername(), currentUser.getEmail(), "Ứng viên BetterHR"));
        profile.setEmail(currentUser.getEmail());
        profile.setAvatar(currentUser.getAvatarUrl());
        profile.setStatus("Processing");
        return profile;
    }

    private String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value;
            }
        }
        return "";
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private SystemUser getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object user = session != null ? session.getAttribute("systemUser") : null;
        return user instanceof SystemUser ? (SystemUser) user : null;
    }
}

package com.hrm.servlet.request;

import com.hrm.dao.LeaveDAO;
import com.hrm.model.entity.Leave;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.lang.reflect.Method;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.ZoneId;

/**
 * Servlet xử lý tạo/gửi đơn nghỉ phép.
 * Đã robust: không giả định account type, không gọi getId trực tiếp (dùng reflection),
 * cố gắng set các kiểu ngày phổ biến vào model bằng reflection.
 */
@WebServlet(name = "LeaveCreateServlet", urlPatterns = {"/request/leave/create"})
public class LeaveCreateServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Views/leave_create.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Object accountObj = session.getAttribute("account");
        if (accountObj == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // 1) Lấy employeeId từ session.account bằng reflection (thử nhiều tên getter)
        Integer employeeId = extractIdFromAccount(accountObj);
        if (employeeId == null) {
            // Không lấy được id -> redirect login (an toàn)
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String startStr = request.getParameter("start_date");
        String endStr = request.getParameter("end_date");
        String reason = request.getParameter("reason");

        Leave leave = new Leave(); // model instance — dự kiến tồn tại trong project

        // 2) set employeeId nếu model có setter phù hợp
        tryInvokeSetterPrimitive(leave, "setEmployeeId", employeeId);

        // 3) parse ngày từ input (expected yyyy-MM-dd)
        LocalDate startLocal = null;
        LocalDate endLocal = null;
        try {
            if (startStr != null && !startStr.isBlank()) startLocal = LocalDate.parse(startStr);
            if (endStr != null && !endStr.isBlank()) endLocal = LocalDate.parse(endStr);
        } catch (Exception ex) {
            // lỗi parse -> trả về message
            request.setAttribute("msg", "Định dạng ngày không đúng. Vui lòng kiểm tra (yyyy-MM-dd).");
            request.getRequestDispatcher("/views/request/leave_create.jsp").forward(request, response);
            return;
        }

        // Chuẩn bị các kiểu phổ biến
        java.sql.Date sqlStart = (startLocal == null) ? null : java.sql.Date.valueOf(startLocal);
        java.sql.Date sqlEnd = (endLocal == null) ? null : java.sql.Date.valueOf(endLocal);

        java.util.Date utilStart = (startLocal == null) ? null
                : java.util.Date.from(startLocal.atStartOfDay(ZoneId.systemDefault()).toInstant());
        java.util.Date utilEnd = (endLocal == null) ? null
                : java.util.Date.from(endLocal.atStartOfDay(ZoneId.systemDefault()).toInstant());

        Timestamp tsStart = (startLocal == null) ? null : Timestamp.valueOf(startLocal.atStartOfDay());
        Timestamp tsEnd = (endLocal == null) ? null : Timestamp.valueOf(endLocal.atStartOfDay());

        // 4) Thử set startDate và endDate bằng reflection với nhiều kiểu và tên phương thức
        boolean setStartOk = false;
        if (sqlStart != null) setStartOk = tryInvokeSetter(leave, "setStartDate", java.sql.Date.class, sqlStart);
        if (!setStartOk && utilStart != null)
            setStartOk = tryInvokeSetter(leave, "setStartDate", java.util.Date.class, utilStart);
        if (!setStartOk && startLocal != null) setStartOk = tryInvokeSetter(leave, "setStartDate", LocalDate.class, startLocal);
        if (!setStartOk && tsStart != null) setStartOk = tryInvokeSetter(leave, "setStartDate", Timestamp.class, tsStart);
        // Thử tên thay thế thường gặp
        if (!setStartOk && sqlStart != null) setStartOk = tryInvokeSetter(leave, "setFromDate", java.sql.Date.class, sqlStart);
        if (!setStartOk && sqlStart != null) setStartOk = tryInvokeSetter(leave, "setFrom", java.sql.Date.class, sqlStart);

        boolean setEndOk = false;
        if (sqlEnd != null) setEndOk = tryInvokeSetter(leave, "setEndDate", java.sql.Date.class, sqlEnd);
        if (!setEndOk && utilEnd != null)
            setEndOk = tryInvokeSetter(leave, "setEndDate", java.util.Date.class, utilEnd);
        if (!setEndOk && endLocal != null) setEndOk = tryInvokeSetter(leave, "setEndDate", LocalDate.class, endLocal);
        if (!setEndOk && tsEnd != null) setEndOk = tryInvokeSetter(leave, "setEndDate", Timestamp.class, tsEnd);
        // Thử tên thay thế
        if (!setEndOk && sqlEnd != null) setEndOk = tryInvokeSetter(leave, "setToDate", java.sql.Date.class, sqlEnd);
        if (!setEndOk && sqlEnd != null) setEndOk = tryInvokeSetter(leave, "setTo", java.sql.Date.class, sqlEnd);

        // Nếu model chỉ có setter nhận long epoch
        if (!setStartOk && sqlStart != null) tryInvokeSetterPrimitiveLong(leave, "setStartDate", sqlStart.getTime());
        if (!setEndOk && sqlEnd != null) tryInvokeSetterPrimitiveLong(leave, "setEndDate", sqlEnd.getTime());

        // 5) reason
        boolean setReasonOk = tryInvokeSetter(leave, "setReason", String.class, reason);
        if (!setReasonOk) tryInvokeSetter(leave, "setNote", String.class, reason);

        // 6) set default status nếu model có setter setStatus
        boolean setStatusOk = tryInvokeSetter(leave, "setStatus", String.class, "Pending");
        if (!setStatusOk) tryInvokeSetter(leave, "setState", String.class, "Pending");

        // 7) Gọi DAO để insert
        boolean inserted = false;
        try {
            LeaveDAO dao = new LeaveDAO();
            inserted = dao.insertLeave(leave);
        } catch (Exception e) {
            e.printStackTrace();
            inserted = false;
        }

        if (inserted) {
            request.setAttribute("msg", "Đơn nghỉ phép đã gửi thành công!");
        } else {
            request.setAttribute("msg", "Gửi đơn thất bại. Vui lòng thử lại.");
        }
        request.getRequestDispatcher("/views/request/leave_create.jsp").forward(request, response);
    }

    // ----------------- Helper reflection methods -----------------

    /**
     * Thử nhiều getter phổ biến trên đối tượng account để lấy id dưới dạng Integer.
     */
    private Integer extractIdFromAccount(Object accountObj) {
        if (accountObj == null) return null;
        // 1) Try methods: getId, getEmployeeId, getUserId
        String[] methodNames = {"getId", "getEmployeeId", "getUserId", "getAccountId", "getUid"};
        for (String mName : methodNames) {
            try {
                Method m = accountObj.getClass().getMethod(mName);
                Object val = m.invoke(accountObj);
                if (val == null) continue;
                if (val instanceof Number) return ((Number) val).intValue();
                if (val instanceof String) {
                    try {
                        return Integer.parseInt((String) val);
                    } catch (NumberFormatException nfe) {
                        continue;
                    }
                }
            } catch (NoSuchMethodException nsme) {
                // tiếp tục thử
            } catch (Exception ex) {
                // ignore other reflection issues and continue
            }
        }
        // 2) Nếu không có getter, thử lấy trường "id" thông qua phản chiếu (getDeclaredField) - nhẹ nhàng
        try {
            java.lang.reflect.Field f = accountObj.getClass().getDeclaredField("id");
            f.setAccessible(true);
            Object val = f.get(accountObj);
            if (val instanceof Number) return ((Number) val).intValue();
            if (val instanceof String) return Integer.parseInt((String) val);
        } catch (Exception ex) {
            // ignore
        }
        return null;
    }

    private boolean tryInvokeSetter(Object target, String methodName, Class<?> paramType, Object value) {
        try {
            Method m = target.getClass().getMethod(methodName, paramType);
            m.invoke(target, value);
            return true;
        } catch (NoSuchMethodException nsme) {
            return false;
        } catch (Exception ex) {
            // in case invocation throws, log and return false
            ex.printStackTrace();
            return false;
        }
    }

    private void tryInvokeSetterPrimitive(Object target, String methodName, int intValue) {
        try {
            Method m = target.getClass().getMethod(methodName, int.class);
            m.invoke(target, intValue);
            return;
        } catch (NoSuchMethodException nsme) {
            try {
                Method m2 = target.getClass().getMethod(methodName, Integer.class);
                m2.invoke(target, Integer.valueOf(intValue));
            } catch (Exception ex) {
                // ignore
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void tryInvokeSetterPrimitiveLong(Object target, String methodName, long longValue) {
        try {
            Method m = target.getClass().getMethod(methodName, long.class);
            m.invoke(target, longValue);
            return;
        } catch (NoSuchMethodException nsme) {
            try {
                Method m2 = target.getClass().getMethod(methodName, Long.class);
                m2.invoke(target, Long.valueOf(longValue));
            } catch (Exception ex) {
                // ignore
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}

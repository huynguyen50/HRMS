package com.hrm.service;

import com.hrm.dao.MailRequestDAO;
import com.hrm.model.entity.MailRequest;
import java.util.List;

public class MailRequestService {

    private final MailRequestDAO dao = new MailRequestDAO();

    public List<MailRequest> getByEmployee(int employeeId) {
        return dao.getByEmployee(employeeId);
    }

    public boolean submit(MailRequest request) {
        if (request == null || request.getEmployeeId() <= 0) return false;
        return dao.insert(request);
    }

    public boolean updateStatus(int requestId, String status, int approverId) {
        if (requestId <= 0 || status == null) return false;
        return dao.updateStatus(requestId, status, approverId);
    }
}

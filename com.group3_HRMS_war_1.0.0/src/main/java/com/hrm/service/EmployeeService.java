package com.hrm.service;

import com.hrm.dao.EmployeeDAO;
import com.hrm.model.entity.Employee;
import java.util.List;

public class EmployeeService {
    private final EmployeeDAO dao = new EmployeeDAO();

    public List<Employee> getAll() {
        return dao.getAll();
    }

    public Employee getById(int id) {
        return dao.getById(id);
    }

    public boolean save(Employee e) {
        if (e.getEmployeeId() > 0) {
            return dao.update(e);
        } else {
            return dao.insert(e);
        }
    }

    public boolean delete(int id) {
        return dao.delete(id);
    }
}

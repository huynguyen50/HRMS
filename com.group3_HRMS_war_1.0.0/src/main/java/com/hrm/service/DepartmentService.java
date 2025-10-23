/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.hrm.service;

import com.hrm.dao.DepartmentDAO;
import com.hrm.model.entity.Department;
import java.util.List;

/**
 *
 * @author Hask
 */

public class DepartmentService {
    private final DepartmentDAO dao = new DepartmentDAO();

    public List<Department> getAll() { return dao.getAll(); }
    public Department getById(int id) { return dao.getById(id); }
    public boolean save(Department d) {
        if (d.getDepartmentId() == 0) return dao.insert(d);
        return dao.update(d);
    }
    public boolean delete(int id) { return dao.delete(id); }
}

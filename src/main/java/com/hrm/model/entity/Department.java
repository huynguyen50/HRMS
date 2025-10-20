
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.hrm.model.entity;

import java.io.Serializable;

/**
 *
 * @author admin
 */
public class Department implements Serializable {

    private static final long serialVersionUID = 1L;

    private int departmentId;
    private String deptName;
    private Integer deptManagerId;
    private int employeeCount;

    public Department() {
    }

    public Department(int departmentId, String deptName, Integer deptManagerId) {
        this.departmentId = departmentId;
        this.deptName = deptName;
        this.deptManagerId = deptManagerId;
    }

    public int getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(int departmentId) {
        this.departmentId = departmentId;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public Integer getDeptManagerId() {
        return deptManagerId;
    }

    public void setDeptManagerId(Integer deptManagerId) {
        this.deptManagerId = deptManagerId;
    }

    public int getEmployeeCount() {
        return employeeCount;
    }

    public void setEmployeeCount(int employeeCount) {
        this.employeeCount = employeeCount;
    }

    @Override
    public String toString() {
        return "Department{" + "departmentId=" + departmentId + ", deptName=" + deptName + ", deptManagerId=" + deptManagerId + '}';
    }
}

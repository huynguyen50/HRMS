package com.hrm.model.dto;


public class DepartmentStats {
    private int departmentId;
    private String departmentName;
    private int count;

    public DepartmentStats() {
    }

    public DepartmentStats(int departmentId, String departmentName, int count) {
        this.departmentId = departmentId;
        this.departmentName = departmentName;
        this.count = count;
    }

    public int getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(int departmentId) {
        this.departmentId = departmentId;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }
}

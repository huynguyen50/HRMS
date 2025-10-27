package com.hrm.model.entity;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Recruitment entity – stores job postings for the HRMS system.
 * @author admin
 */
public class Recruitment implements Serializable {
    private static final long serialVersionUID = 1L;

    private int recruitmentId;
    private String Title;
    private String Description;
    private String Requirement;
    private String Locate;   
    private Double Salary;
    private String Status;
    private LocalDateTime postedDate;

    public Recruitment() {}

    public Recruitment(int recruitmentId, String Title, String Description, String Requirement, String Locate, Double Salary, String Status, LocalDateTime postedDate) {
        this.recruitmentId = recruitmentId;
        this.Title = Title;
        this.Description = Description;
        this.Requirement = Requirement;
        this.Locate = Locate;
        this.Salary = Salary;
        this.Status = Status;
        this.postedDate = postedDate;
    }

    public int getRecruitmentId() {
        return recruitmentId;
    }

    public void setRecruitmentId(int recruitmentId) {
        this.recruitmentId = recruitmentId;
    }

    public String getTitle() {
        return Title;
    }

    public void setTitle(String Title) {
        this.Title = Title;
    }

    public String getDescription() {
        return Description;
    }

    public void setDescription(String Description) {
        this.Description = Description;
    }

    public String getStatus() {
        return Status;
    }

    public void setStatus(String Status) {
        this.Status = Status;
    }

    public String getRequirement() {
        return Requirement;
    }

    public void setRequirement(String Requirement) {
        this.Requirement = Requirement;
    }

    public String getLocate() {
        return Locate;
    }

    public void setLocate(String Locate) {
        this.Locate = Locate;
    }

    public Double getSalary() {
        return Salary;
    }

    public void setSalary(Double Salary) {
        this.Salary = Salary;
    }

    public LocalDateTime getPostedDate() {
        return postedDate;
    }

    public void setPostedDate(LocalDateTime postedDate) {
        this.postedDate = postedDate;
    }

    @Override
    public String toString() {
        return "Recruitment{" + "recruitmentId=" + recruitmentId + ", Title=" + Title + ", Description=" + Description + ", Requirement=" + Requirement + ", Locate=" + Locate + ", Salary=" + Salary + ", Status=" + Status + ", postedDate=" + postedDate + '}';
    }

    
    
    
    
}
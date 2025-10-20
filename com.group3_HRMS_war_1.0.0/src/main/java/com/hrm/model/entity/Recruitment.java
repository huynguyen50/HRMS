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
    private String jobTitle;
    private String jobDescription;
    private String jobRequirement;
    private String jobLocation;
    private LocalDate postDate;
    private double salary;
    
    public Recruitment() {}

    public Recruitment(int recruitmentId, String jobTitle, String jobDescription, String jobRequirement, String jobLocation, LocalDate postDate, double salary) {
        this.recruitmentId = recruitmentId;
        this.jobTitle = jobTitle;
        this.jobDescription = jobDescription;
        this.jobRequirement = jobRequirement;
        this.jobLocation = jobLocation;
        this.postDate = postDate;
        this.salary = salary;
    }

    public int getRecruitmentId() {
        return recruitmentId;
    }

    public void setRecruitmentId(int recruitmentId) {
        this.recruitmentId = recruitmentId;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getJobDescription() {
        return jobDescription;
    }

    public void setJobDescription(String jobDescription) {
        this.jobDescription = jobDescription;
    }

    public String getJobRequirement() {
        return jobRequirement;
    }

    public void setJobRequirement(String jobRequirement) {
        this.jobRequirement = jobRequirement;
    }

    public String getJobLocation() {
        return jobLocation;
    }

    public void setJobLocation(String jobLocation) {
        this.jobLocation = jobLocation;
    }

    public LocalDate getPostDate() {
        return postDate;
    }

    public void setPostDate(LocalDate postDate) {
        this.postDate = postDate;
    }

    public double getSalary() {
        return salary;
    }

    public void setSalary(double salary) {
        this.salary = salary;
    }

    @Override
    public String toString() {
        return "Recruitment{" + "recruitmentId=" + recruitmentId + ", jobTitle=" + jobTitle + ", jobDescription=" + jobDescription + ", jobRequirement=" + jobRequirement + ", jobLocation=" + jobLocation + ", postDate=" + postDate + ", salary=" + salary + '}';
    }

    
}
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
    private LocalDate postDate;
    private String status;
    private Integer postedBy;
    private LocalDateTime postedDate;

    public Recruitment() {}

    public Recruitment(int recruitmentId, String jobTitle, String jobDescription, LocalDate postDate, String status, Integer postedBy, LocalDateTime postedDate) {
        this.recruitmentId = recruitmentId;
        this.jobTitle = jobTitle;
        this.jobDescription = jobDescription;
        this.postDate = postDate;
        this.status = status;
        this.postedBy = postedBy;
        this.postedDate = postedDate;
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

    public LocalDate getPostDate() {
        return postDate;
    }

    public void setPostDate(LocalDate postDate) {
        this.postDate = postDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getPostedBy() {
        return postedBy;
    }

    public void setPostedBy(Integer postedBy) {
        this.postedBy = postedBy;
    }

    public LocalDateTime getPostedDate() {
        return postedDate;
    }

    public void setPostedDate(LocalDateTime postedDate) {
        this.postedDate = postedDate;
    }

    // Compatibility methods for JSP
    public String getTitle() {
        return jobTitle;
    }

    public void setTitle(String title) {
        this.jobTitle = title;
    }

    public String getDescription() {
        return jobDescription;
    }

    public void setDescription(String description) {
        this.jobDescription = description;
    }

    public String getRequirement() {
        return ""; // Not in current DB schema
    }

    public void setRequirement(String requirement) {
        // Not in current DB schema
    }

    public String getLocate() {
        return "Hồ Chí Minh"; // Default location
    }

    public void setLocate(String locate) {
        // Not in current DB schema
    }

    public Double getSalary() {
        return 15000000.0; // Default salary
    }

    public void setSalary(Double salary) {
        // Not in current DB schema
    }

    @Override
    public String toString() {
        return "Recruitment{" + "recruitmentId=" + recruitmentId + ", jobTitle=" + jobTitle + ", jobDescription=" + jobDescription + ", postDate=" + postDate + ", status=" + status + ", postedBy=" + postedBy + ", postedDate=" + postedDate + '}';
    }
}
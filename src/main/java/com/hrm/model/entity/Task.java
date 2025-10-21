package com.hrm.model.entity;

import java.io.Serializable;
import java.time.LocalDate;

/**
 *
 * @author admin
 */
public class Task implements Serializable {

    private static final long serialVersionUID = 1L;

    private int taskId;
    private String title;
    private String description;
    private Integer assignedBy;
    private Integer assignTo;
    private LocalDate startDate;
    private LocalDate dueDate;
    private String status;
    private String progress;
    private String note;
    private String progressReport;
    private String attachments;
    private String approverComment;
    private Integer approvedBy;
    private LocalDate approvedDate;

    public Task() {
    }

    public Task(int taskId, String title, String description, Integer assignedBy,
            Integer assignTo, LocalDate startDate, LocalDate dueDate, String status) {
        this.taskId = taskId;
        this.title = title;
        this.description = description;
        this.assignedBy = assignedBy;
        this.assignTo = assignTo;
        this.startDate = startDate;
        this.dueDate = dueDate;
        this.status = status;
    }

    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getAssignedBy() {
        return assignedBy;
    }

    public void setAssignedBy(int assignedBy) {
        this.assignedBy = assignedBy;
    }

    public int getAssignTo() {
        return assignTo;
    }

    public void setAssignTo(int assignTo) {
        this.assignTo = assignTo;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getProgress() {
        return progress;
    }

    public void setProgress(String progress) {
        this.progress = progress;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getProgressReport() {
        return progressReport;
    }

    public void setProgressReport(String progressReport) {
        this.progressReport = progressReport;
    }

    public String getAttachments() {
        return attachments;
    }

    public void setAttachments(String attachments) {
        this.attachments = attachments;
    }

    public String getApproverComment() {
        return approverComment;
    }

    public void setApproverComment(String approverComment) {
        this.approverComment = approverComment;
    }

    public Integer getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }

    public LocalDate getApprovedDate() {
        return approvedDate;
    }

    public void setApprovedDate(LocalDate approvedDate) {
        this.approvedDate = approvedDate;
    }

    @Override
    public String toString() {
        return "Task{" + "taskId=" + taskId + ", title=" + title + ", description=" + description + ", assignedBy=" + assignedBy + ", assignTo=" + assignTo + ", startDate=" + startDate + ", dueDate=" + dueDate + ", status=" + status + ", progress=" + progress + ", note=" + note + ", progressReport=" + progressReport + ", attachments=" + attachments + ", approverComment=" + approverComment + ", approvedBy=" + approvedBy + ", approvedDate=" + approvedDate + '}';
    }
}

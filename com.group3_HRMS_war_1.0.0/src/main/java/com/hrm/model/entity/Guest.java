
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.hrm.model.entity;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 *
 * @author admin
 */
public class Guest implements Serializable {
    private static final long serialVersionUID = 1L;

    private int guestId;
    private String fullName;
    private String email;
    private String phone;
    private String cv;
    private String status;
    private Integer recruitmentId;
    private LocalDateTime appliedDate;

    public Guest() {}

    public Guest(int guestId, String fullName, String email, String phone, String cv,
                 String status, Integer recruitmentId, LocalDateTime appliedDate) {
        this.guestId = guestId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.cv = cv;
        this.status = status;
        this.recruitmentId = recruitmentId;
        this.appliedDate = appliedDate;
    }

    public int getGuestId() {
        return guestId;
    }

    public void setGuestId(int guestId) {
        this.guestId = guestId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCv() {
        return cv;
    }

    public void setCv(String cv) {
        this.cv = cv;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getRecruitmentId() {
        return recruitmentId;
    }

    public void setRecruitmentId(Integer recruitmentId) {
        this.recruitmentId = recruitmentId;
    }

    public LocalDateTime getAppliedDate() {
        return appliedDate;
    }

    public void setAppliedDate(LocalDateTime appliedDate) {
        this.appliedDate = appliedDate;
    }

    @Override
    public String toString() {
        return "Guest{" + "guestId=" + guestId + ", fullName=" + fullName + ", email=" + email + ", phone=" + phone + ", cv=" + cv + ", status=" + status + ", recruitmentId=" + recruitmentId + ", appliedDate=" + appliedDate + '}';
    }
}
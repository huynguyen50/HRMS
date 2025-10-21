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
public class SystemLog implements Serializable {

    private static final long serialVersionUID = 1L;

    private int logId;
    private Integer userId;
    private String action;
    private String objectType;
    private String oldValue;
    private String newValue;
    private LocalDateTime timestamp;

    public SystemLog() {
    }

    public SystemLog(int logId, Integer userId, String action, String objectType,
            String oldValue, String newValue, LocalDateTime timestamp) {
        this.logId = logId;
        this.userId = userId;
        this.action = action;
        this.objectType = objectType;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.timestamp = timestamp;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getObjectType() {
        return objectType;
    }

    public void setObjectType(String objectType) {
        this.objectType = objectType;
    }

    public String getOldValue() {
        return oldValue;
    }

    public void setOldValue(String oldValue) {
        this.oldValue = oldValue;
    }

    public String getNewValue() {
        return newValue;
    }

    public void setNewValue(String newValue) {
        this.newValue = newValue;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public String toString() {
        return "SystemLog{" + "logId=" + logId + ", userId=" + userId + ", action=" + action + ", objectType=" + objectType + ", oldValue=" + oldValue + ", newValue=" + newValue + ", timestamp=" + timestamp + '}';
    }
}


package com.hrm.model.entity;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 *
 * @author admin
 */
public class SystemUser implements Serializable {
    private static final long serialVersionUID = 1L;

    private int userId;
    private String username;
    private String password;
    private Integer roleId;
    private LocalDateTime lastLogin;
    private boolean isActive;
    private LocalDateTime createdDate;
    private Integer employeeId;
    
    private Role role;

    public SystemUser() {}

    public SystemUser(int userId, String username, String password, Integer roleId,
                      LocalDateTime lastLogin, boolean isActive, LocalDateTime createdDate, Integer employeeId) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.roleId = roleId;
        this.lastLogin = lastLogin;
        this.isActive = isActive;
        this.createdDate = createdDate;
        this.employeeId = employeeId;
    }


    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public LocalDateTime getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(LocalDateTime lastLogin) {
        this.lastLogin = lastLogin;
    }    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
    
    // Additional getter/setter for boolean field compatibility
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        this.isActive = active;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public Integer getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(Integer employeeId) {
        this.employeeId = employeeId;
    }

    @Override
    public String toString() {
        return "SystemUser{" + "userId=" + userId + ", username=" + username + ", password=" + password + ", roleId=" + roleId + ", lastLogin=" + lastLogin + ", isActive=" + isActive + ", createdDate=" + createdDate + ", employeeId=" + employeeId + '}';
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }
}
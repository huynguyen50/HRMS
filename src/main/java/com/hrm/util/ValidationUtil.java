package com.hrm.util;

import java.util.regex.Pattern;

public class ValidationUtil {
    
    // Email validation
    private static final String EMAIL_PATTERN = 
        "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    private static final Pattern emailPattern = Pattern.compile(EMAIL_PATTERN);
    
    // Phone validation 
    private static final String PHONE_PATTERN = "^[0-9]{10,11}$";
    private static final Pattern phonePattern = Pattern.compile(PHONE_PATTERN);
    
    // Password validation
    private static final String PASSWORD_PATTERN = 
        "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$";
    private static final Pattern passwordPattern = Pattern.compile(PASSWORD_PATTERN);
    
    public static boolean isValidEmail(String email) {
        return email != null && emailPattern.matcher(email).matches();
    }
    
    public static boolean isValidPhone(String phone) {
        return phone != null && phonePattern.matcher(phone).matches();
    }
    
    public static boolean isValidPassword(String password) {
        return password != null && passwordPattern.matcher(password).matches();
    }
    
    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }
    
    public static boolean isValidLength(String value, int minLength, int maxLength) {
        if (value == null) return false;
        int length = value.trim().length();
        return length >= minLength && length <= maxLength;
    }
    
    public static boolean containsOnlyNumbers(String value) {
        return value != null && value.matches("^[0-9]+$");
    }
    
    public static boolean containsOnlyLetters(String value) {
        return value != null && value.matches("^[a-zA-Z\\s]+$");
    }
    
    public static String sanitizeInput(String input) {
        if (input == null) return "";
        return input.trim()
                   .replaceAll("<", "&lt;")
                   .replaceAll(">", "&gt;")
                   .replaceAll("\"", "&quot;")
                   .replaceAll("'", "&#39;")
                   .replaceAll("&", "&amp;");
    }
    
    public static String validateAndSanitize(String input, int maxLength) {
        if (input == null) return "";
        String sanitized = sanitizeInput(input);
        if (sanitized.length() > maxLength) {
            sanitized = sanitized.substring(0, maxLength);
        }
        return sanitized;
    }
}
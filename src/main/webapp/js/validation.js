/**
 * HRMS Common Validation Functions
 * Author: GitHub Copilot
 * Version: 1.0.0
 */

// Validation Rules Configuration
const VALIDATION_RULES = {
    // Text field limits
    TEXT_MIN_LENGTH: 2,
    TEXT_MAX_LENGTH: 200,
    TEXTAREA_MAX_LENGTH: 2000,
    DESCRIPTION_MAX_LENGTH: 1000,
    SUBJECT_MAX_LENGTH: 200,
    
    // Special characters patterns
    SPECIAL_CHARS_PATTERN: /[<>\"'&]/,
    SQL_INJECTION_PATTERN: /(union|select|insert|delete|update|drop|create|alter|exec|script)/i,
    XSS_PATTERN: /<script|<\/script|javascript:|on\w+=/i,
    
    // Name patterns
    NAME_PATTERN: /^[a-zA-ZÀ-ỹ\s]{2,50}$/,
    EMAIL_PATTERN: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
    PHONE_PATTERN: /^(\+84|0)[0-9]{9,10}$/,
    
    // Number patterns
    POSITIVE_NUMBER_PATTERN: /^\d+(\.\d{1,2})?$/,
    PERCENTAGE_PATTERN: /^(100|[1-9]?\d)$/,
    
    // Date validation
    MIN_DATE_PAST_DAYS: 365,
    MAX_DATE_FUTURE_DAYS: 365
};

// Common Validation Functions
class HRMSValidator {
    
    /**
     * Validate if field is empty or blank
     */
    static isBlank(value) {
        return !value || value.toString().trim().length === 0;
    }
    
    /**
     * Validate text length
     */
    static validateLength(value, minLength = VALIDATION_RULES.TEXT_MIN_LENGTH, maxLength = VALIDATION_RULES.TEXT_MAX_LENGTH) {
        const trimmedValue = value.toString().trim();
        return {
            isValid: trimmedValue.length >= minLength && trimmedValue.length <= maxLength,
            message: `Field must be between ${minLength} and ${maxLength} characters`
        };
    }
    
    /**
     * Check for dangerous special characters
     */
    static hasDangerousChars(value) {
        return VALIDATION_RULES.SPECIAL_CHARS_PATTERN.test(value) ||
               VALIDATION_RULES.SQL_INJECTION_PATTERN.test(value) ||
               VALIDATION_RULES.XSS_PATTERN.test(value);
    }
    
    /**
     * Validate name format
     */
    static validateName(value) {
        const isValid = VALIDATION_RULES.NAME_PATTERN.test(value.trim());
        return {
            isValid: isValid,
            message: isValid ? '' : 'Name can only contain letters and spaces (2-50 characters)'
        };
    }
    
    /**
     * Validate email format
     */
    static validateEmail(value) {
        const isValid = VALIDATION_RULES.EMAIL_PATTERN.test(value.trim());
        return {
            isValid: isValid,
            message: isValid ? '' : 'Please enter a valid email address'
        };
    }
    
    /**
     * Validate phone number (Vietnamese format)
     */
    static validatePhone(value) {
        const isValid = VALIDATION_RULES.PHONE_PATTERN.test(value.replace(/\s/g, ''));
        return {
            isValid: isValid,
            message: isValid ? '' : 'Please enter a valid Vietnamese phone number'
        };
    }
    
    /**
     * Validate positive number
     */
    static validatePositiveNumber(value) {
        const isValid = VALIDATION_RULES.POSITIVE_NUMBER_PATTERN.test(value);
        return {
            isValid: isValid,
            message: isValid ? '' : 'Please enter a valid positive number'
        };
    }
    
    /**
     * Validate percentage (0-100)
     */
    static validatePercentage(value) {
        const isValid = VALIDATION_RULES.PERCENTAGE_PATTERN.test(value);
        return {
            isValid: isValid,
            message: isValid ? '' : 'Please enter a valid percentage (0-100)'
        };
    }
    
    /**
     * Validate date range
     */
    static validateDateRange(startDate, endDate) {
        const start = new Date(startDate);
        const end = new Date(endDate);
        const today = new Date();
        
        if (start > end) {
            return {
                isValid: false,
                message: 'Start date must be before end date'
            };
        }
        
        if (start < new Date(today.getTime() - VALIDATION_RULES.MIN_DATE_PAST_DAYS * 24 * 60 * 60 * 1000)) {
            return {
                isValid: false,
                message: 'Start date cannot be more than 1 year in the past'
            };
        }
        
        if (end > new Date(today.getTime() + VALIDATION_RULES.MAX_DATE_FUTURE_DAYS * 24 * 60 * 60 * 1000)) {
            return {
                isValid: false,
                message: 'End date cannot be more than 1 year in the future'
            };
        }
        
        return { isValid: true, message: '' };
    }
    
    /**
     * Show validation error
     */
    static showError(fieldId, message) {
        const field = document.getElementById(fieldId);
        if (!field) return;
        
        // Remove existing error
        this.clearError(fieldId);
        
        // Add error class
        field.classList.add('is-invalid');
        
        // Create error message element
        const errorDiv = document.createElement('div');
        errorDiv.className = 'invalid-feedback';
        errorDiv.id = fieldId + '-error';
        errorDiv.textContent = message;
        
        // Insert after field
        field.parentNode.insertBefore(errorDiv, field.nextSibling);
    }
    
    /**
     * Clear validation error
     */
    static clearError(fieldId) {
        const field = document.getElementById(fieldId);
        if (!field) return;
        
        field.classList.remove('is-invalid');
        
        const errorDiv = document.getElementById(fieldId + '-error');
        if (errorDiv) {
            errorDiv.remove();
        }
    }
    
    /**
     * Validate single field
     */
    static validateField(fieldId, rules = {}) {
        const field = document.getElementById(fieldId);
        if (!field) return true;
        
        const value = field.value;
        let isValid = true;
        let errorMessage = '';
        
        // Clear previous errors
        this.clearError(fieldId);
        
        // Required field validation
        if (rules.required && this.isBlank(value)) {
            isValid = false;
            errorMessage = rules.requiredMessage || 'This field is required';
        }
        
        // Skip other validations if field is empty and not required
        if (!rules.required && this.isBlank(value)) {
            return true;
        }
        
        // Length validation
        if (isValid && (rules.minLength || rules.maxLength)) {
            const lengthCheck = this.validateLength(value, rules.minLength, rules.maxLength);
            if (!lengthCheck.isValid) {
                isValid = false;
                errorMessage = lengthCheck.message;
            }
        }
        
        // Dangerous characters check
        if (isValid && this.hasDangerousChars(value)) {
            isValid = false;
            errorMessage = 'Field contains invalid characters';
        }
        
        // Custom pattern validation
        if (isValid && rules.pattern) {
            if (!rules.pattern.test(value)) {
                isValid = false;
                errorMessage = rules.patternMessage || 'Invalid format';
            }
        }
        
        // Custom validation function
        if (isValid && rules.customValidator) {
            const customResult = rules.customValidator(value);
            if (!customResult.isValid) {
                isValid = false;
                errorMessage = customResult.message;
            }
        }
        
        // Show error if validation failed
        if (!isValid) {
            this.showError(fieldId, errorMessage);
        }
        
        return isValid;
    }
    
    /**
     * Validate entire form
     */
    static validateForm(formId, fieldRules = {}) {
        let isFormValid = true;
        
        for (const [fieldId, rules] of Object.entries(fieldRules)) {
            const fieldValid = this.validateField(fieldId, rules);
            if (!fieldValid) {
                isFormValid = false;
            }
        }
        
        return isFormValid;
    }
    
    /**
     * Setup real-time validation for a field
     */
    static setupRealTimeValidation(fieldId, rules = {}) {
        const field = document.getElementById(fieldId);
        if (!field) return;
        
        // Validate on blur
        field.addEventListener('blur', () => {
            this.validateField(fieldId, rules);
        });
        
        // Clear error on focus
        field.addEventListener('focus', () => {
            this.clearError(fieldId);
        });
        
        // Character counter for text fields
        if (rules.maxLength && (field.type === 'text' || field.tagName === 'TEXTAREA')) {
            this.setupCharacterCounter(fieldId, rules.maxLength);
        }
    }
    
    /**
     * Setup character counter
     */
    static setupCharacterCounter(fieldId, maxLength) {
        const field = document.getElementById(fieldId);
        if (!field) return;
        
        // Create counter element
        const counterId = fieldId + '-counter';
        let counter = document.getElementById(counterId);
        
        if (!counter) {
            counter = document.createElement('div');
            counter.id = counterId;
            counter.className = 'form-text text-muted';
            field.parentNode.insertBefore(counter, field.nextSibling);
        }
        
        // Update counter
        const updateCounter = () => {
            const current = field.value.length;
            counter.textContent = `${current}/${maxLength} characters`;
            
            if (current > maxLength * 0.9) {
                counter.classList.add('text-warning');
                counter.classList.remove('text-muted');
            } else {
                counter.classList.add('text-muted');
                counter.classList.remove('text-warning');
            }
        };
        
        // Initial update
        updateCounter();
        
        // Update on input
        field.addEventListener('input', updateCounter);
    }
}

// Export for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = HRMSValidator;
}

// Initialize on DOM load
document.addEventListener('DOMContentLoaded', function() {
    // Add Bootstrap validation styles
    const style = document.createElement('style');
    style.textContent = `
        .is-invalid {
            border-color: #dc3545 !important;
        }
        .invalid-feedback {
            display: block;
            width: 100%;
            margin-top: 0.25rem;
            font-size: 0.875em;
            color: #dc3545;
        }
        .form-text.text-warning {
            color: #f59e0b !important;
        }
    `;
    document.head.appendChild(style);
});

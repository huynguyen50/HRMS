<%-- 
    Document   : CreateContract
    Created on : Nov 4, 2025, 11:01:15 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, com.hrm.model.entity.Employee" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Contract - HR Staff</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"/>
        <style>
            :root {
                --primary: #5b5bd6;
                --secondary: #8b5bd6;
                --bg: #f3f4f6;
                --card: #ffffff;
                --border: #e5e7eb;
                --text: #111827;
                --muted: #6b7280;
                --success: #10b981;
                --error: #ef4444;
            }

            body {
                background: var(--bg);
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                margin: 0;
                padding: 0;
            }

            .topbar {
                height: 64px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 20px;
                background: linear-gradient(90deg, var(--primary), var(--secondary));
                color: #fff;
                box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            }

            .brand {
                display: flex;
                align-items: center;
                gap: 10px;
                font-weight: 700;
                font-size: 22px;
            }

            .brand .logo {
                width: 28px;
                height: 28px;
                background: #fff;
                color: var(--primary);
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 800;
            }

            .top-actions {
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .btn {
                display: inline-block;
                padding: 10px 14px;
                border-radius: 8px;
                text-decoration: none;
                color: #fff;
                background: #2563eb;
                border: none;
                cursor: pointer;
                font-size: 14px;
                transition: background 0.2s;
            }

            .btn:hover {
                background: #1d4ed8;
            }

            .btn.secondary {
                background: var(--success);
            }

            .btn.secondary:hover {
                background: #059669;
            }

            .container {
                max-width: 900px;
                margin: 30px auto;
                padding: 0 20px;
            }

            .card {
                background: var(--card);
                border: 1px solid var(--border);
                border-radius: 12px;
                padding: 24px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }

            .card-header {
                margin-bottom: 24px;
                padding-bottom: 16px;
                border-bottom: 2px solid var(--border);
            }

            .card-header h2 {
                margin: 0;
                color: var(--text);
                font-size: 24px;
            }

            .card-header .subtitle {
                color: var(--muted);
                font-size: 14px;
                margin-top: 4px;
            }

            .alert {
                padding: 12px 16px;
                border-radius: 8px;
                margin-bottom: 20px;
                font-size: 14px;
            }

            .alert.error {
                background: #fee2e2;
                color: #991b1b;
                border: 1px solid #fecaca;
            }

            .alert.success {
                background: #d1fae5;
                color: #065f46;
                border: 1px solid #a7f3d0;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 6px;
                color: var(--text);
                font-weight: 500;
                font-size: 14px;
            }

            .form-group label .required {
                color: var(--error);
                margin-left: 2px;
            }

            .form-group input,
            .form-group select,
            .form-group textarea {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid var(--border);
                border-radius: 8px;
                font-size: 14px;
                transition: border-color 0.2s;
                box-sizing: border-box;
            }

            .form-group input:focus,
            .form-group select:focus,
            .form-group textarea:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(91, 91, 214, 0.1);
            }

            .form-group textarea {
                resize: vertical;
                min-height: 80px;
            }

            .form-group .help-text {
                font-size: 12px;
                color: var(--muted);
                margin-top: 4px;
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 16px;
            }

            @media (max-width: 768px) {
                .form-row {
                    grid-template-columns: 1fr;
                }
            }

            .form-actions {
                display: flex;
                gap: 12px;
                justify-content: flex-end;
                margin-top: 24px;
                padding-top: 20px;
                border-top: 1px solid var(--border);
            }

            .btn-cancel {
                background: #6b7280;
                color: #fff;
            }

            .btn-cancel:hover {
                background: #4b5563;
            }
        </style>
    </head>
    <body>
        <!-- Top Navigation Bar -->
        <div class="topbar">
            <div class="brand">
                <div class="logo">HR</div>
                <div>Create Contract</div>
            </div>
            <div class="top-actions">
                <a class="btn secondary" href="<%=request.getContextPath()%>/hrstaff">← Back</a>
            </div>
        </div>

        <div class="container">
            <div class="card">
                <div class="card-header">
                    <h2>📝 Create New Contract</h2>
               
                </div>

                <!-- Error/Success Messages -->
                <% if (request.getAttribute("error") != null) { %>
                <div class="alert error">
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>
                <% if (request.getAttribute("success") != null) { %>
                <div class="alert success">
                    <%= request.getAttribute("success") %>
                </div>
                <% } %>

                <!-- Form -->
                <form method="POST" action="<%=request.getContextPath()%>/hrstaff/contracts/create">
                    <!-- Employee Selection -->
                    <div class="form-group">
                        <label for="employeeId">
                            Employee <span class="required">*</span>
                        </label>
                        <select id="employeeId" name="employeeId" required>
                            <option value="">-- Select Employee --</option>
                            <%
                                List<Employee> employees = (List<Employee>) request.getAttribute("employees");
                                if (employees != null) {
                                    for (Employee emp : employees) {
                            %>
                            <option value="<%= emp.getEmployeeId() %>">
                                <%= emp.getFullName() %> 
                                (<%= emp.getEmployeeId() %>) 
                                <% if (emp.getDepartmentName() != null) { %>
                                    - <%= emp.getDepartmentName() %>
                                <% } %>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                        <div class="help-text">Select an employee to create a contract</div>
                    </div>

                    <!-- Contract Type -->
                    <div class="form-group">
                        <label for="contractType">
                            Contract Type <span class="required">*</span>
                        </label>
                        <select id="contractType" name="contractType" required>
                            <option value="">-- Select Contract Type --</option>
                            <option value="Full-time">Full-time</option>
                            <option value="Part-time">Part-time</option>
                            <option value="Probation">Probation</option>
                            <option value="Intern">Intern</option>
                            <option value="Contract">Contract</option>
                        </select>
                        <div class="help-text">Type of employment contract</div>
                    </div>

                    <!-- Date Range -->
                    <div class="form-row">
                        <div class="form-group">
                            <label for="startDate">
                                Start Date <span class="required">*</span>
                            </label>
                            <input type="date" id="startDate" name="startDate" required/>
                            <div class="help-text">Contract effective start date</div>
                        </div>

                        <div class="form-group">
                            <label for="endDate">
                                End Date
                            </label>
                            <input type="date" id="endDate" name="endDate"/>
                            <div class="help-text">Leave blank if contract has no expiration date</div>
                        </div>
                    </div>

                    <!-- Salary Information -->
                    <div class="form-row">
                        <div class="form-group">
                            <label for="baseSalary">
                                Base Salary <span class="required">*</span>
                            </label>
                            <input 
                                type="number" 
                                id="baseSalary" 
                                name="baseSalary" 
                                min="0" 
                                step="1000" 
                                required
                                placeholder="Example: 15000000"
                            />
                            <div class="help-text">Base salary (VND)</div>
                        </div>

                        <div class="form-group">
                            <label for="allowance">
                                Allowance
                            </label>
                            <input 
                                type="number" 
                                id="allowance" 
                                name="allowance" 
                                min="0" 
                                step="1000"
                                placeholder="Example: 2000000"
                            />
                            <div class="help-text">Allowance (VND), default: 0</div>
                        </div>
                    </div>

                    <!-- Status -->
                    <div class="form-group">
                        <label for="status">
                            Status <span class="required">*</span>
                        </label>
                        <select id="status" name="status" required>
                            <option value="Draft">Draft</option>
                            <option value="Pending_Approval">Pending Approval</option>
                        </select>
                        <div class="help-text">Contract status after creation</div>
                    </div>

                    <!-- Note -->
                    <div class="form-group">
                        <label for="note">
                            Notes
                        </label>
                        <textarea 
                            id="note" 
                            name="note" 
                            rows="4"
                            maxlength="1000"
                            placeholder="Enter contract notes (if any)..."
                        ></textarea>
                        <div class="help-text">Additional contract notes (optional)</div>
                    </div>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <a href="<%=request.getContextPath()%>/hrstaff" class="btn btn-cancel">
                            Cancel
                        </a>
                        <button type="submit" class="btn secondary">
                            ✓ Create Contract
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // Set minimum date to today for start date
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('startDate').setAttribute('min', today);
            
            // Validate end date is after start date
            const startDateInput = document.getElementById('startDate');
            const endDateInput = document.getElementById('endDate');
            
            startDateInput.addEventListener('change', function() {
                if (this.value) {
                    endDateInput.setAttribute('min', this.value);
                }
            });
            
            endDateInput.addEventListener('change', function() {
                if (startDateInput.value && this.value && this.value < startDateInput.value) {
                    alert('End date must be after start date!');
                    this.value = '';
                }
            });
        </script>
    </body>
</html>

/* Department Management Styles */

.dashboard-container {
    display: flex;
    height: 100vh;
    background-color: #f5f5f5;
}

.sidebar {
    width: 250px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 20px;
    overflow-y: auto;
    box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
}

.sidebar-header {
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.logo {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 18px;
    font-weight: bold;
}

.logo img {
    width: 32px;
    height: 32px;
}

.sidebar-nav {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.nav-item {
    padding: 12px 15px;
    border-radius: 8px;
    color: white;
    text-decoration: none;
    transition: all 0.3s ease;
    cursor: pointer;
    font-size: 14px;
}

.nav-item:hover {
    background-color: rgba(255, 255, 255, 0.2);
    transform: translateX(5px);
}

.nav-item.active {
    background-color: rgba(255, 255, 255, 0.3);
    font-weight: bold;
}

.main-content {
    flex: 1;
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.top-bar {
    background: white;
    padding: 15px 30px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    border-bottom: 1px solid #e0e0e0;
}

.search-box {
    display: flex;
    align-items: center;
    background: #f5f5f5;
    border-radius: 8px;
    padding: 8px 15px;
    flex: 1;
    max-width: 400px;
}

.search-icon {
    margin-right: 10px;
    font-size: 16px;
}

.search-box input {
    border: none;
    background: transparent;
    outline: none;
    width: 100%;
    font-size: 14px;
}
.top-bar-actions {
    display: flex;
    align-items: center;
    gap: 20px;
}

.notification-btn {
    position: relative;
    background: none;
    border: none;
    font-size: 20px;
    cursor: pointer;
    transition: transform 0.2s;
}

.notification-btn:hover {
    transform: scale(1.1);
}

.badge {
    position: absolute;
    top: -5px;
    right: -5px;
    background: #ff4757;
    color: white;
    border-radius: 50%;
    width: 20px;
    height: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
    font-weight: bold;
}

.user-menu {
    display: flex;
    align-items: center;
    gap: 10px;
    cursor: pointer;
}

.user-menu img {
    width: 32px;
    height: 32px;
    border-radius: 50%;
}

.dashboard-content {
    flex: 1;
    overflow-y: auto;
    padding: 30px;
}

.page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
}

.page-title {
    font-size: 28px;
    font-weight: bold;
    color: #333;
    margin: 0;
}

.page-subtitle {
    font-size: 14px;
    color: #666;
    margin: 5px 0 0 0;
}

.btn-primary {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 8px;
    cursor: pointer;
    font-size: 14px;
    font-weight: 600;
    transition: all 0.3s ease;
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
}

.btn-secondary {
    background: #e0e0e0;
    color: #333;
    border: none;
    padding: 10px 20px;
    border-radius: 8px;
    cursor: pointer;
    font-size: 14px;
    font-weight: 600;
    transition: all 0.3s ease;
}

.btn-secondary:hover {
    background: #d0d0d0;
}

.btn-danger {
    background: #ff4757;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 8px;
    cursor: pointer;
    font-size: 14px;
    font-weight: 600;
    transition: all 0.3s ease;
}

.btn-danger:hover {
    background: #ff3838;
    transform: translateY(-2px);
}

.btn-icon {
    background: none;
    border: none;
    font-size: 18px;
    cursor: pointer;
    padding: 5px 10px;
    border-radius: 5px;
    transition: all 0.2s;
}

.btn-edit {
    color: #667eea;
}

.btn-edit:hover {
    background: rgba(102, 126, 234, 0.1);
}

.btn-permissions {
    color: #ffa502;
}

.btn-permissions:hover {
    background: rgba(255, 165, 2, 0.1);
}

.btn-delete {
    color: #ff4757;
}

.btn-delete:hover {
    background: rgba(255, 71, 87, 0.1);
}

/* Alert Messages */
.alert {
    padding: 15px 20px;
    border-radius: 8px;
    margin-bottom: 20px;
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 10px;
}

.alert-success {
    background: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}

.alert-error {
    background: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}

/* Table Styles */
.table-section {
    background: white;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    overflow: hidden;
}

.departments-table {
    width: 100%;
    border-collapse: collapse;
}

.departments-table thead {
    background: #f8f9fa;
    border-bottom: 2px solid #e0e0e0;
}

.departments-table th {
    padding: 15px;
    text-align: center;
    font-weight: 600;
    color: #333;
    font-size: 13px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.departments-table td {
    padding: 15px;
    border-bottom: 1px solid #e0e0e0;
    font-size: 14px;
    color: #555;
    text-align: center;
}

.departments-table tbody tr:hover {
    background: #f8f9fa;
}

.dept-id {
    font-weight: 600;
    color: #667eea;
}

.dept-name {
    font-weight: 500;
    color: #333;
}

.dept-manager {
    color: #666;
}

.dept-count {
    text-align: center;
}

.dept-status {
    text-align: center;
}

.dept-actions {
    display: flex;
    gap: 8px;
    justify-content: center;
}

.badge-unassigned {
    background: #fff3cd;
    color: #856404;
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: 600;
}

.badge-count {
    background: #e7f3ff;
    color: #0066cc;
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: 600;
}

.badge-active {
    background: #d4edda;
    color: #155724;
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: 600;
}

/* Empty State */
.empty-state {
    padding: 60px 20px;
    text-align: center;
    color: #999;
}

.empty-state p {
    font-size: 18px;
    margin-bottom: 20px;
}

/* Modal Styles */
.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    align-items: center;
    justify-content: center;
}

.modal-content {
    background: white;
    border-radius: 12px;
    box-shadow: 0 5px 30px rgba(0, 0, 0, 0.3);
    width: 90%;
    max-width: 500px;
    animation: slideIn 0.3s ease;
}

.modal-large {
    max-width: 700px;
}

.modal-small {
    max-width: 400px;
}

@keyframes slideIn {
    from {
        transform: translateY(-50px);
        opacity: 0;
    }
    to {
        transform: translateY(0);
        opacity: 1;
    }
}

.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px;
    border-bottom: 1px solid #e0e0e0;
}

.modal-header h2 {
    margin: 0;
    font-size: 20px;
    color: #333;
}

.modal-close {
    background: none;
    border: none;
    font-size: 28px;
    cursor: pointer;
    color: #999;
    transition: color 0.2s;
}

.modal-close:hover {
    color: #333;
}

.modal-body {
    padding: 20px;
}

.modal-body p {
    margin: 10px 0;
    color: #555;
}

.warning-text {
    color: #ff4757;
    font-weight: 600;
}

/* Form Styles */
form {
    padding: 20px;
}

.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    font-weight: 600;
    color: #333;
    font-size: 14px;
}

.form-group input,
.form-group select {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 14px;
    transition: border-color 0.2s;
}

.form-group input:focus,
.form-group select:focus {
    outline: none;
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.form-actions {
    display: flex;
    gap: 10px;
    justify-content: flex-end;
    margin-top: 20px;
}

/* Permissions Grid */
.permissions-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
    padding: 20px;
}

.permission-section {
    background: #f8f9fa;
    padding: 15px;
    border-radius: 8px;
}

.permission-section h3 {
    margin: 0 0 15px 0;
    font-size: 14px;
    font-weight: 600;
    color: #333;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.permission-item {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 12px;
}

.permission-item input[type="checkbox"] {
    width: 18px;
    height: 18px;
    cursor: pointer;
}

.permission-item label {
    margin: 0;
    cursor: pointer;
    font-weight: normal;
    font-size: 13px;
}

/* Responsive Design */
@media (max-width: 768px) {
    .dashboard-container {
        flex-direction: column;
    }

    .sidebar {
        width: 100%;
        height: auto;
    }

    .sidebar-nav {
        flex-direction: row;
        flex-wrap: wrap;
    }

    .nav-item {
        flex: 1;
        min-width: 100px;
    }

    .page-header {
        flex-direction: column;
        gap: 15px;
    }

    .btn-primary {
        width: 100%;
    }

    .departments-table {
        font-size: 12px;
    }

    .departments-table th,
    .departments-table td {
        padding: 10px;
    }

    .dept-actions {
        flex-direction: column;
    }

    .modal-content {
        width: 95%;
        max-width: 100%;
    }

    .permissions-grid {
        grid-template-columns: 1fr;
    }
    /* Pagination Styles */
    .pagination-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 30px;
        padding: 20px;
        background-color: #f8f9fa;
        border-radius: 8px;
        border: 1px solid #dee2e6;
    }

    .pagination-info {
        font-size: 14px;
        color: #666;
        font-weight: 500;
    }

    .pagination-controls {
        display: flex;
        gap: 8px;
        align-items: center;
    }

    .page-btn,
    .page-num {
        padding: 8px 12px;
        border: 1px solid #dee2e6;
        background-color: white;
        color: #007bff;
        text-decoration: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 500;
        transition: all 0.3s ease;
    }

    .page-btn:hover:not(.disabled),
    .page-num:hover:not(.active) {
        background-color: #007bff;
        color: white;
        border-color: #007bff;
    }

    .page-num.active {
        background-color: #007bff;
        color: white;
        border-color: #007bff;
    }

    .page-btn.disabled {
        opacity: 0.5;
        cursor: not-allowed;
        color: #999;
    }

    .page-btn.disabled:hover {
        background-color: white;
        color: #999;
    }

    /* Table Styles */
    .table-section {
        background-color: white;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }

    .departments-table {
        width: 100%;
        border-collapse: collapse;
    }

    .departments-table thead {
        background-color: #f8f9fa;
        border-bottom: 2px solid #dee2e6;
    }

    .departments-table th {
        padding: 16px;
        text-align: left;
        font-weight: 600;
        color: #333;
        font-size: 14px;
    }

    .departments-table td {
        padding: 14px 16px;
        border-bottom: 1px solid #dee2e6;
        font-size: 14px;
        color: #555;
    }

    .departments-table tbody tr:hover {
        background-color: #f8f9fa;
    }

    .badge-active {
        display: inline-block;
        padding: 4px 12px;
        background-color: #d4edda;
        color: #155724;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
    }

    .badge-unassigned {
        display: inline-block;
        padding: 4px 12px;
        background-color: #f8d7da;
        color: #721c24;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
    }

    .badge-count {
        display: inline-block;
        padding: 4px 12px;
        background-color: #e7f3ff;
        color: #0066cc;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
    }

    .dept-actions {
        display: flex;
        gap: 8px;
    }

    .btn-icon {
        padding: 6px 10px;
        border: none;
        background-color: transparent;
        cursor: pointer;
        font-size: 16px;
        border-radius: 4px;
        transition: all 0.3s ease;
    }

    .btn-icon:hover {
        background-color: #f0f0f0;
    }

    .btn-edit:hover {
        background-color: #e3f2fd;
    }

    .btn-permissions:hover {
        background-color: #f3e5f5;
    }

    .btn-delete:hover {
        background-color: #ffebee;
    }

    /* Empty State */
    .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #999;
    }

    .empty-state p {
        font-size: 18px;
        margin-bottom: 20px;
    }

    /* Modal Styles */
    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        align-items: center;
        justify-content: center;
    }

    .modal-content {
        background-color: white;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        max-width: 500px;
        width: 90%;
    }

    .modal-large {
        max-width: 700px;
    }

    .modal-small {
        max-width: 400px;
    }

    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        border-bottom: 1px solid #dee2e6;
        padding-bottom: 15px;
    }

    .modal-header h2 {
        margin: 0;
        font-size: 20px;
        color: #333;
    }

    .modal-close {
        background: none;
        border: none;
        font-size: 28px;
        cursor: pointer;
        color: #999;
    }

    .modal-close:hover {
        color: #333;
    }

    .modal-body {
        margin-bottom: 20px;
    }

    .modal-body p {
        margin: 10px 0;
        color: #555;
    }

    .warning-text {
        color: #ff6b6b;
        font-weight: 600;
    }

    /* Form Styles */
    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: #333;
        font-size: 14px;
    }

    .form-group input,
    .form-group select {
        width: 100%;
        padding: 10px;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        font-size: 14px;
        font-family: inherit;
    }

    .form-group input:focus,
    .form-group select:focus {
        outline: none;
        border-color: #007bff;
        box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.25);
    }

    .form-actions {
        display: flex;
        gap: 10px;
        justify-content: flex-end;
        margin-top: 20px;
    }

    .btn-primary {
        padding: 10px 20px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.3s ease;
    }

    .btn-primary:hover {
        background-color: #0056b3;
    }

    .btn-secondary {
        padding: 10px 20px;
        background-color: #6c757d;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.3s ease;
    }

    .btn-secondary:hover {
        background-color: #5a6268;
    }

    .btn-danger {
        padding: 10px 20px;
        background-color: #dc3545;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.3s ease;
    }

    .btn-danger:hover {
        background-color: #c82333;
    }

    /* Permissions Grid */
    .permissions-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 20px;
    }

    .permission-section h3 {
        margin-top: 0;
        margin-bottom: 15px;
        font-size: 16px;
        color: #333;
        border-bottom: 2px solid #007bff;
        padding-bottom: 10px;
    }

    .permission-item {
        display: flex;
        align-items: center;
        margin-bottom: 12px;
    }

    .permission-item input[type="checkbox"] {
        width: auto;
        margin-right: 10px;
        cursor: pointer;
    }

    .permission-item label {
        margin: 0;
        cursor: pointer;
        font-weight: normal;
    }
    
}

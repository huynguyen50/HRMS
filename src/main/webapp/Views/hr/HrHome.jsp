<%-- 
    Document   : HrHome
    Created on : Oct 20, 2025, 2:11:22 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.sql.Date, java.text.SimpleDateFormat, java.math.BigDecimal, java.text.NumberFormat, java.util.Locale" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HR Dashboard - Human Resource Management System</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hr-dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hr-dashboard-backup.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        
        <!-- Fallback CSS - Inline styles to ensure HR Dashboard always looks good -->
        <style>
            /* Critical CSS Fallback */
            .hr-dashboard-container {
                min-height: 100vh !important;
                background-color: #f8f9fa !important;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
            }
            .hr-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
                color: white !important;
                padding: 1rem 0 !important;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1) !important;
            }
            .header-content {
                max-width: 1400px !important;
                margin: 0 auto !important;
                padding: 0 2rem !important;
                display: flex !important;
                justify-content: space-between !important;
                align-items: center !important;
            }
            .logo-section {
                display: flex !important;
                align-items: center !important;
                gap: 1rem !important;
            }
            .logo-section i {
                font-size: 2rem !important;
            }
            .logo-section h1 {
                font-size: 1.8rem !important;
                font-weight: 600 !important;
                margin: 0 !important;
            }
            .hr-main-content {
                display: flex !important;
                max-width: 1400px !important;
                margin: 0 auto !important;
                padding: 2rem !important;
                gap: 2rem !important;
            }
            .hr-sidebar {
                width: 280px !important;
                background: white !important;
                border-radius: 12px !important;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1) !important;
                padding: 1.5rem !important;
                height: fit-content !important;
            }
            .hr-content-area {
                flex: 1 !important;
                background: white !important;
                border-radius: 12px !important;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1) !important;
                padding: 2rem !important;
                min-height: 600px !important;
            }
            .content-section {
                display: none !important;
            }
            .content-section.active {
                display: block !important;
            }
            .nav-item {
                display: flex !important;
                align-items: center !important;
                gap: 0.75rem !important;
                padding: 0.75rem 1rem !important;
                border-radius: 8px !important;
                text-decoration: none !important;
                color: #64748b !important;
                transition: all 0.3s ease !important;
                font-weight: 500 !important;
                margin-bottom: 0.5rem !important;
            }
            .nav-item:hover {
                background: #f1f5f9 !important;
                color: #2563eb !important;
                transform: translateX(4px) !important;
            }
            .nav-item.active {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
                color: white !important;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4) !important;
            }
            .stats-grid {
                display: grid !important;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)) !important;
                gap: 1.5rem !important;
                margin-bottom: 2rem !important;
            }
            .stat-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
                color: white !important;
                padding: 1.5rem !important;
                border-radius: 12px !important;
                display: flex !important;
                align-items: center !important;
                gap: 1rem !important;
                box-shadow: 0 4px 20px rgba(102, 126, 234, 0.3) !important;
                transition: transform 0.3s ease !important;
            }
            .stat-card:hover {
                transform: translateY(-4px) !important;
            }
            
            /* HR Home Section Styles */
            .welcome-content {
                padding: 2rem 0 !important;
            }
            
            .welcome-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
                color: white !important;
                padding: 2rem !important;
                border-radius: 12px !important;
                display: flex !important;
                align-items: center !important;
                gap: 2rem !important;
                margin-bottom: 2rem !important;
                box-shadow: 0 4px 20px rgba(102, 126, 234, 0.3) !important;
            }
            
            .welcome-icon {
                width: 80px !important;
                height: 80px !important;
                background: rgba(255,255,255,0.2) !important;
                border-radius: 50% !important;
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
                flex-shrink: 0 !important;
            }
            
            .welcome-icon i {
                font-size: 2.5rem !important;
            }
            
            .welcome-text h3 {
                font-size: 1.8rem !important;
                margin: 0 0 1rem 0 !important;
                font-weight: 700 !important;
            }
            
            .welcome-text p {
                font-size: 1.1rem !important;
                margin: 0 !important;
                opacity: 0.9 !important;
                line-height: 1.6 !important;
            }
            
            .quick-actions {
                margin-bottom: 2rem !important;
            }
            
            .quick-actions h3 {
                font-size: 1.5rem !important;
                color: #1e293b !important;
                margin-bottom: 1.5rem !important;
                font-weight: 600 !important;
            }
            
            .action-grid {
                display: grid !important;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)) !important;
                gap: 1.5rem !important;
            }
            
            .action-card {
                background: white !important;
                border: 1px solid #e5e7eb !important;
                border-radius: 12px !important;
                padding: 1.5rem !important;
                text-decoration: none !important;
                color: inherit !important;
                transition: all 0.3s ease !important;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05) !important;
            }
            
            .action-card:hover {
                transform: translateY(-4px) !important;
                box-shadow: 0 8px 25px rgba(0,0,0,0.15) !important;
                border-color: #667eea !important;
            }
            
            .action-card i {
                font-size: 2rem !important;
                color: #667eea !important;
                margin-bottom: 1rem !important;
                display: block !important;
            }
            
            .action-card h4 {
                font-size: 1.2rem !important;
                margin: 0 0 0.5rem 0 !important;
                color: #1e293b !important;
                font-weight: 600 !important;
            }
            
            .action-card p {
                margin: 0 !important;
                color: #64748b !important;
                font-size: 0.9rem !important;
                line-height: 1.5 !important;
            }
            
            .system-info h3 {
                font-size: 1.5rem !important;
                color: #1e293b !important;
                margin-bottom: 1.5rem !important;
                font-weight: 600 !important;
            }
            
            .info-grid {
                display: grid !important;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)) !important;
                gap: 1rem !important;
            }
            
            .info-card {
                background: #f8fafc !important;
                border: 1px solid #e2e8f0 !important;
                border-radius: 8px !important;
                padding: 1.5rem !important;
                text-align: center !important;
                transition: all 0.3s ease !important;
            }
            
            .info-card:hover {
                background: #f1f5f9 !important;
                border-color: #cbd5e1 !important;
            }
            
            .info-card i {
                font-size: 1.5rem !important;
                color: #667eea !important;
                margin-bottom: 0.5rem !important;
                display: block !important;
            }
            
            .info-card h4 {
                font-size: 1rem !important;
                margin: 0 0 0.5rem 0 !important;
                color: #1e293b !important;
                font-weight: 600 !important;
            }
            
            .info-card p {
                margin: 0 !important;
                color: #64748b !important;
                font-size: 0.9rem !important;
            }
            
            /* HR Functions Section */
            .hr-functions {
                margin-bottom: 2rem !important;
            }
            
            .hr-functions h3 {
                font-size: 1.5rem !important;
                color: #1e293b !important;
                margin-bottom: 1.5rem !important;
                font-weight: 600 !important;
            }
            
            .function-grid {
                display: grid !important;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)) !important;
                gap: 1.5rem !important;
            }
            
            .function-card {
                background: white !important;
                border: 1px solid #e5e7eb !important;
                border-radius: 12px !important;
                padding: 1.5rem !important;
                transition: all 0.3s ease !important;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05) !important;
            }
            
            .function-card:hover {
                transform: translateY(-4px) !important;
                box-shadow: 0 8px 25px rgba(0,0,0,0.15) !important;
                border-color: #667eea !important;
            }
            
            .function-icon {
                width: 60px !important;
                height: 60px !important;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
                border-radius: 12px !important;
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
                margin-bottom: 1rem !important;
            }
            
            .function-icon i {
                font-size: 1.5rem !important;
                color: white !important;
            }
            
            .function-content h4 {
                font-size: 1.3rem !important;
                margin: 0 0 0.5rem 0 !important;
                color: #1e293b !important;
                font-weight: 600 !important;
            }
            
            .function-content p {
                margin: 0 0 1rem 0 !important;
                color: #64748b !important;
                font-size: 0.95rem !important;
                line-height: 1.6 !important;
            }
            
            .function-link {
                display: inline-flex !important;
                align-items: center !important;
                gap: 0.5rem !important;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
                color: white !important;
                padding: 0.5rem 1rem !important;
                border-radius: 6px !important;
                text-decoration: none !important;
                font-size: 0.9rem !important;
                font-weight: 500 !important;
                transition: all 0.3s ease !important;
            }
            
            .function-link:hover {
                transform: translateX(4px) !important;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3) !important;
            }
            
            /* System Overview Section */
            .system-overview h3 {
                font-size: 1.5rem !important;
                color: #1e293b !important;
                margin-bottom: 1.5rem !important;
                font-weight: 600 !important;
            }
            
            .overview-grid {
                display: grid !important;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)) !important;
                gap: 1rem !important;
            }
            
            .overview-card {
                background: #f8fafc !important;
                border: 1px solid #e2e8f0 !important;
                border-radius: 12px !important;
                padding: 1.5rem !important;
                text-align: center !important;
                transition: all 0.3s ease !important;
            }
            
            .overview-card:hover {
                background: #f1f5f9 !important;
                border-color: #667eea !important;
                transform: translateY(-2px) !important;
            }
            
            .overview-icon {
                width: 50px !important;
                height: 50px !important;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
                border-radius: 50% !important;
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
                margin: 0 auto 1rem auto !important;
            }
            
            .overview-icon i {
                font-size: 1.2rem !important;
                color: white !important;
            }
            
            .overview-info h4 {
                font-size: 1rem !important;
                margin: 0 0 0.5rem 0 !important;
                color: #1e293b !important;
                font-weight: 600 !important;
            }
            
            .overview-number {
                display: block !important;
                font-size: 2rem !important;
                font-weight: 700 !important;
                color: #667eea !important;
                margin-bottom: 0.5rem !important;
            }
            
            .overview-status {
                display: block !important;
                font-size: 1.2rem !important;
                font-weight: 600 !important;
                color: #10b981 !important;
                margin-bottom: 0.5rem !important;
            }
            
            .overview-info p {
                margin: 0 !important;
                color: #64748b !important;
                font-size: 0.85rem !important;
            }
            
            /* Comprehensive Overview Styles */
            .comprehensive-overview {
                padding: 2rem 0 !important;
            }
            
            .overview-welcome {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
                color: white !important;
                padding: 2rem !important;
                border-radius: 12px !important;
                display: flex !important;
                align-items: center !important;
                gap: 2rem !important;
                margin-bottom: 2rem !important;
                box-shadow: 0 4px 20px rgba(102, 126, 234, 0.3) !important;
            }
            
            .overview-welcome .welcome-icon {
                width: 80px !important;
                height: 80px !important;
                background: rgba(255,255,255,0.2) !important;
                border-radius: 50% !important;
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
                flex-shrink: 0 !important;
            }
            
            .overview-welcome .welcome-icon i {
                font-size: 2.5rem !important;
            }
            
            .overview-welcome .welcome-text h3 {
                font-size: 1.8rem !important;
                margin: 0 0 1rem 0 !important;
                font-weight: 700 !important;
            }
            
            .overview-welcome .welcome-text p {
                font-size: 1.1rem !important;
                margin: 0 !important;
                opacity: 0.9 !important;
                line-height: 1.6 !important;
            }
            
            /* Main Statistics Grid */
            .main-stats-grid {
                display: grid !important;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)) !important;
                gap: 1.5rem !important;
                margin-bottom: 2rem !important;
            }
            
            .main-stats-grid .stat-card {
                background: white !important;
                border-radius: 12px !important;
                padding: 1.5rem !important;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05) !important;
                transition: all 0.3s ease !important;
                border-left: 4px solid !important;
            }
            
            .main-stats-grid .stat-card:hover {
                transform: translateY(-4px) !important;
                box-shadow: 0 8px 25px rgba(0,0,0,0.15) !important;
            }
            
            .main-stats-grid .stat-card.primary {
                border-left-color: #667eea !important;
            }
            
            .main-stats-grid .stat-card.success {
                border-left-color: #10b981 !important;
            }
            
            .main-stats-grid .stat-card.warning {
                border-left-color: #f59e0b !important;
            }
            
            .main-stats-grid .stat-card.info {
                border-left-color: #3b82f6 !important;
            }
            
            .main-stats-grid .stat-card .stat-icon {
                width: 50px !important;
                height: 50px !important;
                border-radius: 50% !important;
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
                margin-bottom: 1rem !important;
            }
            
            .main-stats-grid .stat-card.primary .stat-icon {
                background: #667eea !important;
                color: white !important;
            }
            
            .main-stats-grid .stat-card.success .stat-icon {
                background: #10b981 !important;
                color: white !important;
            }
            
            .main-stats-grid .stat-card.warning .stat-icon {
                background: #f59e0b !important;
                color: white !important;
            }
            
            .main-stats-grid .stat-card.info .stat-icon {
                background: #3b82f6 !important;
                color: white !important;
            }
            
            .main-stats-grid .stat-card .stat-icon i {
                font-size: 1.2rem !important;
            }
            
            .main-stats-grid .stat-card h3 {
                font-size: 1rem !important;
                margin: 0 0 0.5rem 0 !important;
                color: #64748b !important;
                font-weight: 500 !important;
            }
            
            .main-stats-grid .stat-card .stat-number {
                display: block !important;
                font-size: 2.5rem !important;
                font-weight: 700 !important;
                color: #1e293b !important;
                margin-bottom: 0.5rem !important;
            }
            
            .main-stats-grid .stat-card p {
                margin: 0 !important;
                color: #94a3b8 !important;
                font-size: 0.9rem !important;
            }
            
            /* Quick Access */
            .quick-access {
                margin-bottom: 2rem !important;
            }
            
            .quick-access h3 {
                font-size: 1.5rem !important;
                color: #1e293b !important;
                margin-bottom: 1.5rem !important;
                font-weight: 600 !important;
            }
            
            .access-grid {
                display: grid !important;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)) !important;
                gap: 1rem !important;
            }
            
            /* Responsive grid for Quick Access */
            @media (min-width: 1200px) {
                .access-grid {
                    grid-template-columns: repeat(3, 1fr) !important;
                }
            }
            
            @media (max-width: 1199px) and (min-width: 768px) {
                .access-grid {
                    grid-template-columns: repeat(2, 1fr) !important;
                }
            }
            
            .access-card {
                background: white !important;
                border: 1px solid #e5e7eb !important;
                border-radius: 8px !important;
                padding: 1.5rem !important;
                text-decoration: none !important;
                color: inherit !important;
                transition: all 0.3s ease !important;
                text-align: center !important;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05) !important;
            }
            
            .access-card:hover {
                transform: translateY(-2px) !important;
                box-shadow: 0 8px 25px rgba(0,0,0,0.15) !important;
                border-color: #667eea !important;
            }
            
            .access-card i {
                font-size: 2rem !important;
                color: #667eea !important;
                margin-bottom: 1rem !important;
                display: block !important;
            }
            
            .access-card h4 {
                font-size: 1.1rem !important;
                margin: 0 0 0.5rem 0 !important;
                color: #1e293b !important;
                font-weight: 600 !important;
            }
            
            .access-card p {
                margin: 0 !important;
                color: #64748b !important;
                font-size: 0.85rem !important;
            }
            
            /* System Status */
            .system-status {
                display: grid !important;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)) !important;
                gap: 1rem !important;
            }
            
            .status-card {
                background: #f8fafc !important;
                border: 1px solid #e2e8f0 !important;
                border-radius: 8px !important;
                padding: 1.5rem !important;
                display: flex !important;
                align-items: center !important;
                gap: 1rem !important;
                transition: all 0.3s ease !important;
            }
            
            .status-card:hover {
                background: #f1f5f9 !important;
                border-color: #cbd5e1 !important;
            }
            
            .status-icon {
                width: 50px !important;
                height: 50px !important;
                border-radius: 50% !important;
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
                flex-shrink: 0 !important;
            }
            
            .status-icon.online {
                background: #10b981 !important;
                color: white !important;
            }
            
            .status-icon i {
                font-size: 1.2rem !important;
            }
            
            .status-info h4 {
                font-size: 1rem !important;
                margin: 0 0 0.5rem 0 !important;
                color: #1e293b !important;
                font-weight: 600 !important;
            }
            
            .status-text {
                display: block !important;
                font-size: 1.1rem !important;
                font-weight: 600 !important;
                color: #10b981 !important;
                margin-bottom: 0.25rem !important;
            }
            
            .status-info p {
                margin: 0 !important;
                color: #64748b !important;
                font-size: 0.85rem !important;
            }
            .btn-homepage {
                background: rgba(255,255,255,0.2) !important;
                color: white !important;
                padding: 0.5rem 1rem !important;
                border-radius: 25px !important;
                text-decoration: none !important;
                display: flex !important;
                align-items: center !important;
                gap: 0.5rem !important;
                transition: all 0.3s ease !important;
                border: 1px solid rgba(255,255,255,0.3) !important;
            }
            .btn-homepage:hover {
                background: rgba(255,255,255,0.3) !important;
                transform: translateY(-2px) !important;
                box-shadow: 0 4px 15px rgba(0,0,0,0.2) !important;
            }
            .btn-homepage i {
                font-size: 1rem !important;
            }
            .btn-homepage span {
                font-weight: 500 !important;
            }
            
            /* Payroll Approval Styles */
            .payroll-approval-section {
                padding: 1.5rem 0;
            }
            
            .approval-header {
                margin-bottom: 2rem;
            }
            
            .approval-header h3 {
                color: #1e293b;
                font-size: 1.5rem;
                margin-bottom: 0.5rem;
            }
            
            .approval-header p {
                color: #64748b;
                margin: 0;
            }
            
            .status-tabs-container {
                display: flex;
                gap: 0.5rem;
                margin-bottom: 1.5rem;
                flex-wrap: wrap;
            }
            
            .status-tab-btn {
                padding: 0.75rem 1.5rem;
                border-radius: 8px;
                border: 2px solid #e5e7eb;
                background: white;
                color: #64748b;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
            }
            
            .status-tab-btn:hover {
                background: #f1f5f9;
                border-color: #667eea;
                color: #667eea;
            }
            
            .status-tab-btn.active {
                background: #667eea;
                color: white;
                border-color: #667eea;
            }
            
            .status-tab-btn .badge {
                background: rgba(255,255,255,0.2);
                padding: 0.25rem 0.5rem;
                border-radius: 12px;
                font-size: 0.75rem;
            }
            
            .status-tab-btn.active .badge {
                background: rgba(255,255,255,0.3);
            }
            
            .approval-filters {
                display: flex;
                gap: 1rem;
                margin-bottom: 1.5rem;
            }
            
            .approval-filters select,
            .approval-filters input {
                padding: 0.75rem;
                border: 1px solid #e5e7eb;
                border-radius: 8px;
                font-size: 1rem;
            }
            
            .approval-filters select:focus,
            .approval-filters input:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }
            
            .payrolls-list {
                display: flex;
                flex-direction: column;
                gap: 1rem;
            }
            
            .payroll-card-item {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                border-left: 4px solid #f59e0b;
                transition: all 0.3s ease;
            }
            
            .payroll-card-item:hover {
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
                transform: translateY(-2px);
            }
            
            .payroll-card-item.status-approved {
                border-left-color: #10b981;
            }
            
            .payroll-card-item.status-rejected {
                border-left-color: #ef4444;
            }
            
            .payroll-card-item.status-paid {
                border-left-color: #3b82f6;
            }
            
            .payroll-card-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 1rem;
                padding-bottom: 1rem;
                border-bottom: 1px solid #e5e7eb;
            }
            
            .payroll-card-title h4 {
                margin: 0 0 0.5rem 0;
                color: #667eea;
                font-size: 1.1rem;
            }
            
            .payroll-card-title p {
                margin: 0;
                color: #64748b;
                font-size: 0.9rem;
            }
            
            .status-badge-item {
                display: inline-block;
                padding: 0.5rem 1rem;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 600;
                text-transform: uppercase;
            }
            
            .status-badge-item.Pending {
                background: #fef3c7;
                color: #92400e;
            }
            
            .status-badge-item.Approved {
                background: #d1fae5;
                color: #065f46;
            }
            
            .status-badge-item.Rejected {
                background: #fee2e2;
                color: #991b1b;
            }
            
            .status-badge-item.Paid {
                background: #dbeafe;
                color: #1e40af;
            }
            
            .payroll-card-details {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 1rem;
                margin-bottom: 1rem;
            }
            
            .detail-item-small {
                display: flex;
                flex-direction: column;
            }
            
            .detail-label-small {
                font-size: 0.85rem;
                color: #64748b;
                margin-bottom: 0.25rem;
            }
            
            .detail-value-small {
                font-size: 1rem;
                color: #1e293b;
                font-weight: 600;
            }
            
            .detail-value-small.amount {
                color: #10b981;
            }
            
            .payroll-card-actions {
                display: flex;
                gap: 0.75rem;
                justify-content: flex-end;
                padding-top: 1rem;
                border-top: 1px solid #e5e7eb;
            }
            
            .btn-small {
                padding: 0.5rem 1rem;
                border-radius: 6px;
                border: none;
                font-size: 0.9rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
            }
            
            .btn-approve-small {
                background: #10b981;
                color: white;
            }
            
            .btn-approve-small:hover {
                background: #059669;
                transform: translateY(-2px);
            }
            
            .btn-reject-small {
                background: #ef4444;
                color: white;
            }
            
            .btn-reject-small:hover {
                background: #dc2626;
                transform: translateY(-2px);
            }
            
            .btn-view-small {
                background: #667eea;
                color: white;
            }
            
            .btn-view-small:hover {
                background: #5568d3;
                transform: translateY(-2px);
            }
            
            .loading-state {
                text-align: center;
                padding: 3rem;
                color: #64748b;
            }
            
            .loading-state i {
                font-size: 2rem;
                margin-bottom: 1rem;
            }
            
            .empty-state {
                text-align: center;
                padding: 3rem;
                color: #64748b;
            }
            
            .empty-state i {
                font-size: 3rem;
                margin-bottom: 1rem;
                opacity: 0.5;
            }
            .payroll-cards {
                display: grid !important;
                grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)) !important;
                gap: 1.5rem !important;
            }
            .payroll-card {
                background: #ffffff !important;
                border: 1px solid #e2e8f0 !important;
                border-radius: 12px !important;
                box-shadow: 0 8px 20px rgba(15, 23, 42, 0.08) !important;
                padding: 1.5rem !important;
                display: flex !important;
                flex-direction: column !important;
                gap: 1.25rem !important;
                transition: transform 0.2s ease, box-shadow 0.2s ease !important;
            }
            .payroll-card:hover {
                transform: translateY(-4px) !important;
                box-shadow: 0 12px 24px rgba(15, 23, 42, 0.12) !important;
            }
            .payroll-card .payroll-header {
                display: flex !important;
                justify-content: space-between !important;
                align-items: flex-start !important;
                gap: 1rem !important;
            }
            .payroll-card .payroll-title {
                display: flex !important;
                flex-direction: column !important;
                gap: 0.25rem !important;
            }
            .payroll-card .employee-name {
                font-size: 1.1rem !important;
                font-weight: 600 !important;
                color: #1e293b !important;
            }
            .payroll-card .payroll-id {
                font-size: 0.85rem !important;
                color: #64748b !important;
            }
            .payroll-card .status-badge {
                border-radius: 999px !important;
                padding: 0.35rem 0.85rem !important;
                font-size: 0.75rem !important;
                font-weight: 600 !important;
                text-transform: uppercase !important;
                letter-spacing: 0.03em !important;
            }
            .payroll-card .status-badge.Pending {
                background: #fff7ed !important;
                color: #c2410c !important;
                border: 1px solid rgba(234, 88, 12, 0.3) !important;
            }
            .payroll-card .status-badge.Approved {
                background: #ecfdf5 !important;
                color: #047857 !important;
                border: 1px solid rgba(16, 185, 129, 0.3) !important;
            }
            .payroll-card .status-badge.Rejected {
                background: #fef2f2 !important;
                color: #b91c1c !important;
                border: 1px solid rgba(248, 113, 113, 0.3) !important;
            }
            .payroll-card .status-badge.Paid {
                background: #eef2ff !important;
                color: #4338ca !important;
                border: 1px solid rgba(99, 102, 241, 0.3) !important;
            }
            .payroll-card .payroll-details {
                display: grid !important;
                grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)) !important;
                gap: 1rem !important;
                border: 1px dashed #e2e8f0 !important;
                border-radius: 10px !important;
                padding: 1rem !important;
                background: #f8fafc !important;
            }
            .payroll-card .detail-item {
                display: flex !important;
                flex-direction: column !important;
                gap: 0.35rem !important;
            }
            .payroll-card .detail-label {
                font-size: 0.75rem !important;
                font-weight: 600 !important;
                color: #64748b !important;
                text-transform: uppercase !important;
                letter-spacing: 0.08em !important;
            }
            .payroll-card .detail-value {
                font-size: 1rem !important;
                color: #0f172a !important;
                font-weight: 600 !important;
            }
            .payroll-card .detail-value.amount {
                font-feature-settings: "tnum" 1, "lnum" 1 !important;
            }
            .payroll-card .detail-value.deduction {
                color: #dc2626 !important;
            }
            .payroll-card .detail-value.net-amount {
                font-size: 1.25rem !important;
                font-weight: 700 !important;
                color: #2563eb !important;
            }
            .payroll-card .payroll-actions {
                display: flex !important;
                flex-wrap: wrap !important;
                gap: 0.75rem !important;
            }
            .payroll-card .payroll-actions .btn {
                flex: 1 !important;
                min-width: 140px !important;
            }
            .hr-main-content {
                display: flex !important;
                max-width: 1400px !important;
                margin: 0 auto !important;
                padding: 2rem !important;
                gap: 2rem !important;
            }
            .hr-sidebar {
                width: 280px !important;
                background: white !important;
                border-radius: 12px !important;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1) !important;
                padding: 1.5rem !important;
                height: fit-content !important;
            }
        </style>
    </head>
    <body>
        <div class="hr-dashboard-container">
            <!-- Header -->
            <header class="hr-header">
                <div class="header-content">
                    <div class="logo-section">
                        <i class="fas fa-users-cog"></i>
                        <h1>HR Dashboard</h1>
                    </div>
                    <div class="header-actions">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" placeholder="Search employees, departments...">
                        </div>
                        <div class="notification-bell">
                            <i class="fas fa-bell"></i>
                            <span class="notification-count">5</span>
                        </div>
                        <div class="user-profile">
                            <img src="https://i.pravatar.cc/40" alt="HR User">
                            <span>HR Manager</span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <a href="${pageContext.request.contextPath}/homepage" class="btn-homepage" title="Back to Homepage">
                            <i class="fas fa-home"></i>
                            <span>Homepage</span>
                        </a>
                    </div>
                </div>
            </header>

            <!-- Main Content -->
            <main class="hr-main-content">
                <!-- Sidebar -->
                <aside class="hr-sidebar">
                    <nav class="hr-nav">
                        <div class="nav-section">
                            
                            <a href="#hr-home" class="nav-item active" data-section="hr-home">
                                <i class="fas fa-home"></i>
                                <span>HR Home</span>
                            </a>
                        </div>
                        
                        <div class="nav-section">
                            <h3>Requests & Approvals</h3>
                            <a href="#requests-approval" class="nav-item" data-section="requests-approval">
                                <i class="fas fa-clipboard-check"></i>
                                <span>Requests & Recommendations</span>
                            </a>
                        </div>
                        
                        <div class="nav-section">
                            <h3>Salary & Contracts</h3>
                            <a href="${pageContext.request.contextPath}/hr/payroll-approval" class="nav-item">
                                <i class="fas fa-money-bill-wave"></i>
                                <span>Payroll Approval</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/hr/approve-reject-contracts" class="nav-item">
                                <i class="fas fa-file-contract"></i>
                                <span>Pending Contracts Approval</span>
                            </a>
                        </div>
                        
                        <div class="nav-section">
                            <h3>Recruitment</h3>
                            <a href="${pageContext.request.contextPath}/viewRecruitment" class="nav-item">
                                <i class="fas fa-bullhorn"></i>
                                <span>View Recruitment</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/candidates" class="nav-item">
                                <i class="fas fa-users"></i>
                                <span>View Candidates</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/hr/create-employee" class="nav-item">
                                <i class="fas fa-user-plus"></i>
                                <span>Create Employee</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/hr/employee-list" class="nav-item">
                                <i class="fas fa-list"></i>
                                <span>Employee List</span>
                            </a>
                            <a href="#recruitment-system" class="nav-item" data-section="recruitment-system">
                                <i class="fas fa-clipboard-list"></i>
                                <span>Recruitment System</span>
                            </a>
                        </div>
                        
                        <div class="nav-section">
                            <h3>Reports</h3>
                            <a href="#reports-analytics" class="nav-item" data-section="reports-analytics">
                                <i class="fas fa-chart-bar"></i>
                                <span>Reports & Analytics</span>
                            </a>
                        </div>
                    </nav>
                </aside>

                <!-- Content Area -->
                <div class="hr-content-area">
                    <!-- HR Home Section -->
                    <section id="hr-home" class="content-section active">
                        <div class="section-header">
                            <h2>🏠 HR Home</h2>
                            <p>Welcome to the Human Resource Management System</p>
                        </div>
                        
                        <div class="comprehensive-overview">
                            <div class="overview-welcome">
                                <div class="welcome-icon">
                                    <i class="fas fa-users-cog"></i>
                                </div>
                                <div class="welcome-text">
                                    <h3>HR Management Dashboard</h3>
                                    <p>Comprehensive overview of your human resource management system</p>
                                </div>
                            </div>
                            
                            <!-- Main Statistics Grid -->
                            <div class="main-stats-grid">
                                <div class="stat-card primary">
                                <div class="stat-icon">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div class="stat-content">
                                        <h3>Total Employees</h3>
                                        <span class="stat-number">${not empty employees ? employees.size() : 0}</span>
                                        <p>Active employees in system</p>
                                </div>
                            </div>
                                
                                <div class="stat-card success">
                                <div class="stat-icon">
                                        <i class="fas fa-user-check"></i>
                                </div>
                                <div class="stat-content">
                                        <h3>Active Staff</h3>
                                        <span class="stat-number">${not empty employees ? employees.size() : 0}</span>
                                        <p>Currently working employees</p>
                                </div>
                            </div>
                                
                                <div class="stat-card warning">
                                <div class="stat-icon">
                                        <i class="fas fa-building"></i>
                                </div>
                                <div class="stat-content">
                                        <h3>Departments</h3>
                                        <span class="stat-number">${not empty departments ? departments.size() : 0}</span>
                                        <p>Organizational departments</p>
                                </div>
                            </div>
                            
                            <%
                                // Load pending contracts count
                                int pendingContractsCount = 0;
                                try {
                                    com.hrm.dao.ContractDAO contractDAO = new com.hrm.dao.ContractDAO();
                                    pendingContractsCount = contractDAO.countContractsByStatus("Pending_Approval");
                                } catch (Exception e) {
                                    // Ignore errors, just show 0
                                }
                                pageContext.setAttribute("pendingContractsCount", pendingContractsCount);
                            %>
                            <a href="${pageContext.request.contextPath}/hr/approve-reject-contracts" style="text-decoration: none; color: inherit;">
                                <div class="stat-card info" style="cursor: pointer;">
                                    <div class="stat-icon">
                                        <i class="fas fa-file-contract"></i>
                                    </div>
                                    <div class="stat-content">
                                        <h3>Pending Contracts</h3>
                                        <span class="stat-number">${pendingContractsCount}</span>
                                        <p>Contracts pending approval</p>
                                    </div>
                                </div>
                            </a>
                        </div>

                            <!-- Quick Access Functions -->
                            <div class="quick-access">
                                <h3>Quick Access</h3>
                                <div class="access-grid">
                                    <a href="${pageContext.request.contextPath}/ProfileManagementController" class="access-card">
                                    <i class="fas fa-user-edit"></i>
                                        <h4>Profile Management</h4>
                                        <p>Manage employee profiles</p>
                                    </a>
<!--                                    <a href="${pageContext.request.contextPath}/EmploymentStatusController" class="access-card">
                                        <i class="fas fa-user-check"></i>
                                        <h4>Employment Status</h4>
                                        <p>Update employment status</p>
                                    </a>-->
                                    <a href="${pageContext.request.contextPath}/viewRecruitment" class="access-card">
                                        <i class="fas fa-bullhorn"></i>
                                        <h4>Post Recruitment</h4>
                                        <p>Create job postings</p>
                                    </a>
                                    
                                    <a href="${pageContext.request.contextPath}/candidates" class="access-card">
                                        <i class="fas fa-users"></i>
                                        <h4>View Candidates</h4>
                                        <p>Review applications</p>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/hr/create-employee" class="access-card">
                                        <i class="fas fa-user-plus"></i>
                                        <h4>Create Employee</h4>
                                        <p>Convert candidates to employees</p>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/hr/employee-list" class="access-card">
                                        <i class="fas fa-list"></i>
                                        <h4>Employee List</h4>
                                        <p>View all employees</p>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/hr/approve-reject-contracts" class="access-card">
                                        <i class="fas fa-file-contract"></i>
                                        <h4>Approve Contracts</h4>
                                        <p>Review and approve contracts pending approval (${pendingContractsCount})</p>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/hr/payroll-approval?status=Pending" class="access-card">
                                        <i class="fas fa-money-bill-wave"></i>
                                        <h4>Payroll Approval</h4>
                                        <p>Review and approve payrolls submitted by HR Staff</p>
                                    </a>
                                </div>
                            </div>
                            
                            <!-- System Status -->
                            <div class="system-status">
                                <div class="status-card">
                                    <div class="status-icon online">
                                        <i class="fas fa-database"></i>
                                    </div>
                                    <div class="status-info">
                                        <h4>System Status</h4>
                                        <span class="status-text">Online</span>
                                        <p>All systems operational</p>
                                    </div>
                                </div>
                                <div class="status-card">
                                    <div class="status-icon online">
                                        <i class="fas fa-clock"></i>
                                    </div>
                                    <div class="status-info">
                                        <h4>Last Updated</h4>
                                        <span class="status-text" id="lastUpdatedTime"></span>
                                        <p>System refresh time</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                    

                    <!-- Profile Management Section -->
                    <section id="ProfileManagementController" class="content-section">
                        <div class="section-header">
                            <h2>Profile Management</h2>
                            <p>Approve or reject employee personal information update requests</p>
                        </div>
                        
                        <div class="management-tabs">
                            <button class="tab-btn active" data-tab="pending-profiles">Pending</button>
                            <button class="tab-btn" data-tab="approved-profiles">Approved</button>
                            <button class="tab-btn" data-tab="rejected-profiles">Rejected</button>
                        </div>
                        
                        <div class="tab-content">
                            <div id="pending-profiles" class="tab-panel active">
                                <div class="profile-requests">
                                    <c:choose>
                                        <c:when test="${not empty employees}">
                                            <c:forEach var="employee" items="${employees}" begin="0" end="4">
                                    <div class="request-card">
                                        <div class="request-header">
                                            <div class="employee-info">
                                                            <img src="https://i.pravatar.cc/50?img=${employee.employeeId}" alt="Employee">
                                                <div>
                                                                <h4>${employee.fullName}</h4>
                                                                <p>${employee.position} - ${employee.departmentName}</p>
                                                </div>
                                            </div>
                                            <div class="request-date">
                                                <i class="fas fa-clock"></i>
                                                            <span>${employee.employmentPeriod}</span>
                                            </div>
                                        </div>
                                        <div class="request-details">
                                                        <h5>Employee Information:</h5>
                                                        <ul>
                                                            <li><strong>Email:</strong> ${employee.email}</li>
                                                            <li><strong>Phone:</strong> ${employee.phone}</li>
                                                            <li><strong>Address:</strong> ${employee.address}</li>
                                                            <li><strong>Status:</strong> ${employee.status}</li>
                                            </ul>
                                        </div>
                                        <div class="request-actions">
                                            <button class="btn-approve">
                                                <i class="fas fa-check"></i>
                                                            Approve
                                            </button>
                                            <button class="btn-reject">
                                                <i class="fas fa-times"></i>
                                                            Reject
                                            </button>
                                            <button class="btn-view-details">
                                                <i class="fas fa-eye"></i>
                                                            View Details
                                            </button>
                                        </div>
                                    </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-data">
                                                <i class="fas fa-users-slash"></i>
                                                <h3>No employee profiles found</h3>
                                                <p>There are no employee profiles to display at the moment.</p>
                                                </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </section>

<!--                     Employment Status Management Section 
                    <section id="employment-status" class="content-section">
                        <div class="section-header">
                            <h2>Employment Status Management</h2>
                            <p>Update employee employment status</p>
                        </div>
                        
                        <div class="status-management">
                            <div class="status-filters">
                                <button class="filter-btn active" data-status="all">All</button>
                                <button class="filter-btn" data-status="active">Active</button>
                                <button class="filter-btn" data-status="intern">Intern</button>
                                <button class="filter-btn" data-status="probation">Probation</button>
                            </div>
                            
                            <div class="employee-status-list">
                                <c:choose>
                                    <c:when test="${not empty employees}">
                                        <c:forEach var="employee" items="${employees}" begin="0" end="5">
                                <div class="status-card">
                                    <div class="employee-basic-info">
                                                    <img src="https://i.pravatar.cc/50?img=${employee.employeeId}" alt="Employee">
                                        <div>
                                                        <h4>${employee.fullName}</h4>
                                                        <p>${employee.position} - ${employee.departmentName}</p>
                                                        <span class="current-status ${employee.status.toLowerCase()}">${employee.status}</span>
                                        </div>
                                    </div>
                                    <div class="status-actions">
                                                    <form method="POST" action="/HRMS/EmploymentStatusController" style="display: flex; gap: 10px; align-items: center;" onsubmit="return confirmStatusUpdate(this)">
                                                        <input type="hidden" name="action" value="updateStatus">
                                                        <input type="hidden" name="employeeId" value="${employee.employeeId}">
                                                        <select name="status" class="status-select">
                                                            <option value="Active" ${employee.status == 'Active' ? 'selected' : ''}>Active</option>
                                                            <option value="Probation" ${employee.status == 'Probation' ? 'selected' : ''}>Probation</option>
                                                            <option value="Intern" ${employee.status == 'Intern' ? 'selected' : ''}>Intern</option>
                                        </select>
                                                        <button type="submit" class="btn-update-status">
                                            <i class="fas fa-save"></i>
                                                            Update
                                        </button>
                                                    </form>
                                    </div>
                                </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-data">
                                            <i class="fas fa-users-slash"></i>
                                            <h3>No employees found</h3>
                                            <p>There are no employees to display at the moment.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </section>-->

                    <!-- Requests and Recommendations Section -->
                    <section id="requests-approval" class="content-section">
                        <div class="section-header">
                            <h2>Requests and Recommendations</h2>
                            <p>Review, approve or reject submitted requests</p>
                        </div>
                        
                        <div class="requests-tabs">
                            <button class="tab-btn active" data-tab="pending-requests">Pending</button>
                            <button class="tab-btn" data-tab="approved-requests">Approved</button>
                            <button class="tab-btn" data-tab="rejected-requests">Rejected</button>
                        </div>
                        
                        <div class="tab-content">
                            <div id="pending-requests" class="tab-panel active">
                                <div class="request-list">
                                    <div class="request-item">
                                        <div class="request-info">
                                            <h4>Leave Request</h4>
                                            <p><strong>Requester:</strong> Nguyen Van E - IT Department</p>
                                            <p><strong>Type:</strong> Personal Leave</p>
                                            <p><strong>Duration:</strong> 15/12/2024 - 20/12/2024</p>
                                            <p><strong>Reason:</strong> Family Leave</p>
                                        </div>
                                        <div class="request-actions">
                                            <button class="btn-approve">
                                                <i class="fas fa-check"></i>
                                                Approve
                                            </button>
                                            <button class="btn-reject">
                                                <i class="fas fa-times"></i>
                                                Reject
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <div class="request-item">
                                        <div class="request-info">
                                            <h4>Salary Increase Request</h4>
                                            <p><strong>Requester:</strong> Tran Thi F - Marketing Department</p>
                                            <p><strong>Type:</strong> Salary Increase Proposal</p>
                                            <p><strong>Proposed Increase:</strong> 15%</p>
                                            <p><strong>Reason:</strong> Successfully completed projects and made positive contributions</p>
                                        </div>
                                        <div class="request-actions">
                                            <button class="btn-approve">
                                                <i class="fas fa-check"></i>
                                                Approve
                                            </button>
                                            <button class="btn-reject">
                                                <i class="fas fa-times"></i>
                                                Reject
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- Payroll Management Section -->
                    <section id="payroll-management" class="content-section">
                        <div class="section-header">
                            <h2>Payroll Management</h2>
                            <p>Review and approve payrolls submitted by HR Staff, view payroll history</p>
                        </div>
                        
                        <div class="payroll-tabs">
                            <button class="tab-btn active" data-tab="payroll-approval">Payroll Approval</button>
                            <button class="tab-btn" data-tab="payroll-history">Payroll History</button>
                        </div>
                        
                        <div class="tab-content">
                            <!-- Payroll Approval Tab -->
                            <div id="payroll-approval" class="tab-panel active">
                                <div class="payroll-approval-section">
                                    <div class="approval-header">
                                        <h3><i class="fas fa-clipboard-check"></i> Payroll Approval</h3>
                                        <p>Review and approve or reject payrolls submitted by HR Staff</p>
                                    </div>
                                    
                                    <!-- Status Tabs -->
                                    <div class="status-tabs-container">
                                        <a class="status-tab-btn ${payrollStatus == 'Pending' ? 'active' : ''}" data-status="Pending" href="${pageContext.request.contextPath}/HrHomeController?section=payroll-management&payrollStatus=Pending">
                                            <i class="fas fa-clock"></i> Pending <span class="badge" id="pendingCount">${pendingCount != null ? pendingCount : 0}</span>
                                        </a>
                                        <a class="status-tab-btn ${payrollStatus == 'Approved' ? 'active' : ''}" data-status="Approved" href="${pageContext.request.contextPath}/HrHomeController?section=payroll-management&payrollStatus=Approved">
                                            <i class="fas fa-check-circle"></i> Approved <span class="badge" id="approvedCount">${approvedCount != null ? approvedCount : 0}</span>
                                        </a>
                                        <a class="status-tab-btn ${payrollStatus == 'Rejected' ? 'active' : ''}" data-status="Rejected" href="${pageContext.request.contextPath}/HrHomeController?section=payroll-management&payrollStatus=Rejected">
                                            <i class="fas fa-times-circle"></i> Rejected <span class="badge" id="rejectedCount">${rejectedCount != null ? rejectedCount : 0}</span>
                                        </a>
                                        <a class="status-tab-btn ${payrollStatus == 'Paid' ? 'active' : ''}" data-status="Paid" href="${pageContext.request.contextPath}/HrHomeController?section=payroll-management&payrollStatus=Paid">
                                            <i class="fas fa-money-bill-wave"></i> Paid <span class="badge" id="paidCount">${paidCount != null ? paidCount : 0}</span>
                                        </a>
                                    </div>
                                    
                                    <!-- Filter Section -->
                                    <form class="approval-filters" method="get" action="${pageContext.request.contextPath}/HrHomeController">
                                        <input type="hidden" name="section" value="payroll-management"/>
                                        <input type="hidden" name="payrollStatus" value="${payrollStatus != null ? payrollStatus : 'Pending'}"/>
                                        <select id="employeeFilter" name="employeeFilter" onchange="this.form.submit()">
                                            <option value="">All Employees</option>
                                            <c:forEach var="employee" items="${employees}">
                                                <option value="${employee.employeeId}" ${payrollEmployeeFilter == employee.employeeId ? 'selected' : ''}>${employee.fullName} (ID: ${employee.employeeId})</option>
                                            </c:forEach>
                                        </select>
                                        <input type="month" id="monthFilter" name="monthFilter" value="${payrollMonthFilter}" onchange="this.form.submit()"/>
                                        <button type="submit" class="btn btn-filter">Apply</button>
                                        <a class="btn btn-reset" href="${pageContext.request.contextPath}/HrHomeController?section=payroll-management">Reset</a>
                                    </form>
                                    
                                    <!-- Payrolls List -->
                                    <div id="payrollsList" class="payrolls-list">
                                        <c:choose>
                                            <c:when test="${not empty payrolls && payrolls.size() > 0}">
                                                <c:forEach var="payroll" items="${payrolls}">
                                                    <%
                                                        Map<String, Object> payrollMap = (Map<String, Object>) pageContext.getAttribute("payroll");
                                                        BigDecimal baseSalary = (BigDecimal) payrollMap.get("baseSalary");
                                                        BigDecimal allowance = (BigDecimal) payrollMap.get("allowance");
                                                        BigDecimal bonus = (BigDecimal) payrollMap.get("bonus");
                                                        BigDecimal deduction = (BigDecimal) payrollMap.get("deduction");
                                                        BigDecimal netSalary = (BigDecimal) payrollMap.get("netSalary");
                                                        String status = (String) payrollMap.get("status");
                                                        
                                                        NumberFormat nf = NumberFormat.getNumberInstance(Locale.US);
                                                    %>
                                                    <div class="payroll-card status-${fn:toLowerCase(status)}" data-payroll-id="${payroll.payrollId}">
                                                        <div class="payroll-header">
                                                            <div class="payroll-title">
                                                                <div class="employee-name">
                                                                    <i class="fas fa-user"></i> ${payroll.employeeName}
                                                                </div>
                                                                <div class="payroll-id">Payroll ID: #${payroll.payrollId} | Period: ${payroll.payPeriod}</div>
                                                            </div>
                                                            <span class="status-badge ${status}">${status}</span>
                                                        </div>

                                                        <div class="payroll-details">
                                                            <div class="detail-item">
                                                                <span class="detail-label">Base Salary</span>
                                                                <span class="detail-value amount"><%= nf.format(baseSalary != null ? baseSalary : BigDecimal.ZERO) %> VNĐ</span>
                                                            </div>
                                                            <div class="detail-item">
                                                                <span class="detail-label">OT Salary</span>
                                                                <span class="detail-value amount"><%= nf.format(bonus != null ? bonus : BigDecimal.ZERO) %> VNĐ</span>
                                                            </div>
                                                            <div class="detail-item">
                                                                <span class="detail-label">Allowance</span>
                                                                <span class="detail-value amount"><%= nf.format(allowance != null ? allowance : BigDecimal.ZERO) %> VNĐ</span>
                                                            </div>
                                                            <div class="detail-item">
                                                                <span class="detail-label">Deduction</span>
                                                                <span class="detail-value deduction"><%= nf.format(deduction != null ? deduction : BigDecimal.ZERO) %> VNĐ</span>
                                                            </div>
                                                            <div class="detail-item">
                                                                <span class="detail-label">Net Salary</span>
                                                                <span class="detail-value net-amount"><%= nf.format(netSalary != null ? netSalary : BigDecimal.ZERO) %> VNĐ</span>
                                                            </div>
                                                            <c:if test="${not empty payroll.approvedDate}">
                                                                <div class="detail-item">
                                                                    <span class="detail-label">Approved Date</span>
                                                                    <span class="detail-value">${payroll.approvedDate}</span>
                                                                </div>
                                                            </c:if>
                                                        </div>

                                                        <div class="payroll-actions">
                                                            <button type="button" class="btn btn-view" data-payroll-id="${payroll.payrollId}">
                                                                <i class="fas fa-eye"></i> View Details
                                                            </button>
                                                            <c:if test="${status == 'Pending'}">
                                                                <button type="button" class="btn btn-approve" data-payroll-id="${payroll.payrollId}" data-employee="${payroll.employeeName}" data-period="${payroll.payPeriod}">
                                                                    <i class="fas fa-check"></i> Approve
                                                                </button>
                                                                <button type="button" class="btn btn-reject" data-payroll-id="${payroll.payrollId}" data-employee="${payroll.employeeName}" data-period="${payroll.payPeriod}">
                                                                    <i class="fas fa-times"></i> Reject
                                                                </button>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="empty-state">
                                                    <i class="fas fa-inbox"></i>
                                                    <h3>No Payrolls Found</h3>
                                                    <p>There are no payrolls with status "${payrollStatus != null ? payrollStatus : 'Pending'}" matching your filters.</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Payroll History Tab -->
                            <div id="payroll-history" class="tab-panel">
                                <div class="payroll-history-section">
                                    <div class="history-header">
                                        <h3><i class="fas fa-history"></i> Payroll History</h3>
                                        <p>View all approved and paid payrolls</p>
                                    </div>
                                    
                                    <div class="history-filters">
                                        <select id="historyEmployeeFilter">
                                            <option value="">All Employees</option>
                                            <c:forEach var="employee" items="${employees}">
                                                <option value="${employee.employeeId}">${employee.fullName} (ID: ${employee.employeeId})</option>
                                            </c:forEach>
                                        </select>
                                        <input type="month" id="historyMonthFilter"/>
                                        <button class="btn-primary" onclick="loadPayrollHistory()">
                                            <i class="fas fa-search"></i> Search
                                        </button>
                                    </div>
                                    
                                    <div id="payrollHistoryList" class="payrolls-list">
                                        <div class="empty-state">
                                            <i class="fas fa-inbox"></i>
                                            <h3>No Payroll History</h3>
                                            <p>Use filters above to search for payroll history</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- Recruitment System Section -->
                    <section id="recruitment-system" class="content-section">
                        <div class="section-header">
                            <h2>Recruitment</h2>
                            <p>Create and post job openings, review and screen applications, schedule interviews</p>
                        </div>
                        
                        <div class="recruitment-tabs">
                            <button class="tab-btn active" data-tab="job-postings">Job Postings</button>
                            <button class="tab-btn" data-tab="candidate-screening">Candidate Screening</button>
                            <button class="tab-btn" data-tab="interview-scheduling">Interview Scheduling</button>
                        </div>
                        
                        <div class="tab-content">
                            <div id="job-postings" class="tab-panel active">
                                <div class="job-posting-management">
                                    <div class="section-actions">
                                        <button class="btn-primary" onclick="showJobPostingForm()">
                                            <i class="fas fa-plus"></i>
                                            Create New Job Posting
                                        </button>
                                    </div>
                                    
                                    <div class="job-postings-list">
                                        <div class="job-posting-card">
                                            <div class="job-header">
                                                <h4>Senior Java Developer</h4>
                                                <span class="job-status active">Hiring</span>
                                            </div>
                                            <div class="job-details">
                                                <p><strong>Department:</strong> IT Department</p>
                                                <p><strong>Salary:</strong> 20,000,000 - 30,000,000 VNĐ</p>
                                                <p><strong>Experience:</strong> 3-5 years</p>
                                                <p><strong>Posted Date:</strong> 10/12/2024</p>
                                                <p><strong>Applicants:</strong> 25</p>
                                            </div>
                                            <div class="job-actions">
                                                <button class="btn-secondary">
                                                    <i class="fas fa-edit"></i>
                                                    Edit
                                                </button>
                                                <button class="btn-secondary">
                                                    <i class="fas fa-eye"></i>
                                                    View Candidates
                                                </button>
                                                <button class="btn-danger">
                                                    <i class="fas fa-pause"></i>
                                                    Pause
                                                </button>
                                            </div>
                                        </div>
                                        
                                        <div class="job-posting-card">
                                            <div class="job-header">
                                                <h4>Marketing Specialist</h4>
                                                <span class="job-status active">Hiring</span>
                                            </div>
                                            <div class="job-details">
                                                <p><strong>Department:</strong> Marketing Department</p>
                                                <p><strong>Salary:</strong> 12,000,000 - 18,000,000 VNĐ</p>
                                                <p><strong>Experience:</strong> 2-3 years</p>
                                                <p><strong>Posted Date:</strong> 08/12/2024</p>
                                                <p><strong>Applicants:</strong> 18</p>
                                            </div>
                                            <div class="job-actions">
                                                <button class="btn-secondary">
                                                    <i class="fas fa-edit"></i>
                                                    Edit
                                                </button>
                                                <button class="btn-secondary">
                                                    <i class="fas fa-eye"></i>
                                                    View Candidates
                                                </button>
                                                <button class="btn-danger">
                                                    <i class="fas fa-pause"></i>
                                                    Pause
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div id="candidate-screening" class="tab-panel">
                                <div class="candidate-screening">
                                    <div class="screening-filters">
                                        <select class="form-select">
                                            <option>All Positions</option>
                                            <option>Senior Java Developer</option>
                                            <option>Marketing Specialist</option>
                                        </select>
                                        <select class="form-select">
                                            <option>All Status</option>
                                            <option>New Application</option>
                                            <option>Screened</option>
                                            <option>Interviewed</option>
                                            <option>Hired</option>
                                            <option>Rejected</option>
                                        </select>
                                    </div>
                                    
                                    <div class="candidates-list">
                                        <div class="candidate-card">
                                            <div class="candidate-info">
                                                <img src="https://i.pravatar.cc/50" alt="Candidate">
                                                <div>
                                                    <h4>Pham Van G</h4>
                                                    <p>Senior Java Developer</p>
                                                    <p><strong>Experience:</strong> 4 years</p>
                                                    <p><strong>Application Date:</strong> 12/12/2024</p>
                                                </div>
                                            </div>
                                            <div class="candidate-status">
                                                <span class="status-badge new">New Application</span>
                                            </div>
                                            <div class="candidate-actions">
                                                <button class="btn-primary">
                                                    <i class="fas fa-eye"></i>
                                                    View CV
                                                </button>
                                                <button class="btn-success">
                                                    <i class="fas fa-check"></i>
                                                    Select for Interview
                                                </button>
                                                <button class="btn-danger">
                                                    <i class="fas fa-times"></i>
                                                    Reject
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- Reports and Analytics Section -->
                    <section id="reports-analytics" class="content-section">
                        <div class="section-header">
                            <h2>Reports & Analytics</h2>
                            <p>Generate reports on personnel, departments and system performance</p>
                        </div>
                        
                        <div class="reports-tabs">
                            <button class="tab-btn active" data-tab="hr-reports">HR Reports</button>
                            <button class="tab-btn" data-tab="department-reports">Department Reports</button>
                            <button class="tab-btn" data-tab="system-analytics">System Analytics</button>
                        </div>
                        
                        <div class="tab-content">
                            <div id="hr-reports" class="tab-panel active">
                                <div class="reports-dashboard">
                                    <div class="report-filters">
                                        <div class="filter-group">
                                            <label>Time Period:</label>
                                            <select class="form-select">
                                                <option>This Month</option>
                                                <option>This Quarter</option>
                                                <option>This Year</option>
                                                <option>Custom</option>
                                            </select>
                                        </div>
                                        <div class="filter-group">
                                            <label>Department:</label>
                                            <select class="form-select">
                                                <option>All Departments</option>
                                                <option>IT Department</option>
                                                <option>Marketing Department</option>
                                                <option>HR Department</option>
                                            </select>
                                        </div>
                                        <button class="btn-primary">
                                            <i class="fas fa-download"></i>
                                            Export Report
                                        </button>
                                    </div>
                                    
                                    <div class="charts-grid">
                                        <div class="chart-container">
                                            <h4>Personnel Overview</h4>
                                            <canvas id="employeeOverviewChart"></canvas>
                                        </div>
                                        <div class="chart-container">
                                            <h4>Distribution by Department</h4>
                                            <canvas id="departmentDistributionChart"></canvas>
                                        </div>
                                        <div class="chart-container">
                                            <h4>Monthly Recruitment</h4>
                                            <canvas id="recruitmentChart"></canvas>
                                        </div>
                                        <div class="chart-container">
                                            <h4>Turnover Rate</h4>
                                            <canvas id="turnoverChart"></canvas>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </main>
        </div>

        <script>
            // Navigation function - Show specific section
            function showSection(sectionId) {
                // Hide all sections
                const sections = document.querySelectorAll('.content-section');
                sections.forEach(section => {
                    section.classList.remove('active');
                });

                // Show selected section
                const targetSection = document.getElementById(sectionId);
                if (targetSection) {
                    targetSection.classList.add('active');
                }

                // Update navigation
                const navItems = document.querySelectorAll('.nav-item');
                navItems.forEach(item => {
                    item.classList.remove('active');
                    if (item.getAttribute('data-section') === sectionId) {
                        item.classList.add('active');
                    }
                });

                // Scroll to top of content
                const contentArea = document.querySelector('.hr-content-area');
                if (contentArea) {
                    contentArea.scrollTop = 0;
                }
            }
            
            // Update URL without reloading page
            function updateURL(params) {
                const url = new URL(window.location);
                Object.keys(params).forEach(key => {
                    if (params[key]) {
                        url.searchParams.set(key, params[key]);
                    } else {
                        url.searchParams.delete(key);
                    }
                });
                window.history.pushState({}, '', url);
            }
            
            // Initialize navigation on page load
            document.addEventListener('DOMContentLoaded', function() {
                const appContext = '${pageContext.request.contextPath}';
                // Sidebar navigation
                const menuItems = document.querySelectorAll('.nav-item[data-section]');

                // Handle navigation items with data-section
                menuItems.forEach(item => {
                    item.addEventListener('click', function(e) {
                        e.preventDefault();
                        const sectionId = this.getAttribute('data-section');
                        showSection(sectionId);
                    });
                });
                
                // Handle access cards with data-section
                const accessCards = document.querySelectorAll('.access-card[data-section]');
                accessCards.forEach(card => {
                    card.addEventListener('click', function(e) {
                        e.preventDefault();
                        const sectionId = this.getAttribute('data-section');
                        showSection(sectionId);
                    });
                });
                
                // Handle tab buttons
                const tabButtons = document.querySelectorAll('.tab-btn');
                tabButtons.forEach(button => {
                    button.addEventListener('click', function() {
                        const tabId = this.getAttribute('data-tab');
                        const tabContainer = this.closest('.content-section');
                        if (tabContainer) {
                            // Remove active from all tab buttons in this container
                            tabContainer.querySelectorAll('.tab-btn').forEach(btn => {
                                btn.classList.remove('active');
                            });
                            // Add active to clicked button
                            this.classList.add('active');
                            
                            // Hide all tab panels in this container
                            tabContainer.querySelectorAll('.tab-panel').forEach(panel => {
                                panel.classList.remove('active');
                            });
                            
                            // Show selected tab panel
                            const targetPanel = tabContainer.querySelector('#' + tabId);
                            if (targetPanel) {
                                targetPanel.classList.add('active');
                            }
                        }
                    });
                });
            });
            
            // Confirm status update
            function confirmStatusUpdate(form) {
                const employeeName = form.closest('.status-card').querySelector('h4').textContent;
                const newStatus = form.querySelector('select[name="status"]').value;
                return confirm(`Are you sure you want to update ${employeeName}'s status to ${newStatus}?`);
            }
            
            // Handle form submissions with AJAX to avoid page reload
            document.addEventListener('DOMContentLoaded', function() {
                // Handle status update forms
                document.querySelectorAll('form[action*="EmploymentStatusController"]').forEach(form => {
                    form.addEventListener('submit', function(e) {
                        e.preventDefault();
                        const formData = new FormData(this);
                        
                        fetch('/HRMS/EmploymentStatusController', {
                            method: 'POST',
                            body: formData
                        })
                        .then(response => response.text())
                        .then(data => {
                            // Show success message
                            showMessage('Status updated successfully!', 'success');
                            // Update the UI
                            const statusSpan = this.closest('.status-card').querySelector('.current-status');
                            const newStatus = formData.get('status');
                            statusSpan.textContent = newStatus;
                            statusSpan.className = `current-status ${newStatus.toLowerCase()}`;
                        })
                        .catch(error => {
                            showMessage('Error updating status: ' + error.message, 'error');
                        });
                    });
                });
            });
            
            // Show message function
            function showMessage(message, type) {
                const messageDiv = document.createElement('div');
                messageDiv.className = 'message ' + type;
                messageDiv.innerHTML = 
                    '<i class="fas fa-' + (type === 'success' ? 'check-circle' : 'exclamation-triangle') + '"></i>' +
                    message;
                
                // Add to the top of the content area
                const contentArea = document.querySelector('.hr-content-area');
                contentArea.insertBefore(messageDiv, contentArea.firstChild);
                
                // Auto remove after 5 seconds
                setTimeout(function() {
                    messageDiv.remove();
                }, 5000);
            }
            
            // Set last updated time
            if (document.getElementById('lastUpdatedTime')) {
                document.getElementById('lastUpdatedTime').textContent = new Date().toLocaleString();
            }
            
            // Payroll Approval Functions
            let currentStatus = 'Pending';
            
            function getCurrentStatus() {
                const activeTab = document.querySelector('.status-tab-btn.active');
                return activeTab ? activeTab.getAttribute('data-status') : 'Pending';
            }
            
            function loadPayrollsByStatus(status) {
                const params = new URLSearchParams(window.location.search);
                params.set('section', 'payroll-management');
                params.set('payrollStatus', status);
                const employeeSelect = document.getElementById('employeeFilter');
                const monthInput = document.getElementById('monthFilter');
                if (employeeSelect && employeeSelect.value) {
                    params.set('employeeFilter', employeeSelect.value);
                } else {
                    params.delete('employeeFilter');
                }
                if (monthInput && monthInput.value) {
                    params.set('monthFilter', monthInput.value);
                } else {
                    params.delete('monthFilter');
                }
                window.location.href = appContext + '/HrHomeController?' + params.toString();
            }
            
            function updateCountsFromPage(doc) {
                // Try to get counts from status tabs
                const pendingBadge = doc.querySelector('#pendingCount');
                const approvedBadge = doc.querySelector('#approvedCount');
                const rejectedBadge = doc.querySelector('#rejectedCount');
                const paidBadge = doc.querySelector('#paidCount');
                
                if (pendingBadge && document.getElementById('pendingCount')) {
                    document.getElementById('pendingCount').textContent = pendingBadge.textContent;
                }
                if (approvedBadge && document.getElementById('approvedCount')) {
                    document.getElementById('approvedCount').textContent = approvedBadge.textContent;
                }
                if (rejectedBadge && document.getElementById('rejectedCount')) {
                    document.getElementById('rejectedCount').textContent = rejectedBadge.textContent;
                }
                if (paidBadge && document.getElementById('paidCount')) {
                    document.getElementById('paidCount').textContent = paidBadge.textContent;
                }
            }
            
            function attachPayrollEventListeners() {
                // Approve buttons
                document.querySelectorAll('.btn-approve').forEach(btn => {
                    btn.addEventListener('click', function() {
                        const payrollId = this.dataset.payrollId;
                        const employeeName = this.dataset.employee || this.closest('.payroll-card')?.querySelector('.employee-name')?.textContent?.trim() || 'Employee';
                        const payPeriod = this.dataset.period || this.closest('.payroll-card')?.querySelector('.payroll-id')?.textContent?.match(/Period: (.+)/)?.[1] || '';
                        if (payrollId) approvePayroll(payrollId, employeeName, payPeriod);
                    });
                });
                
                // Reject buttons
                document.querySelectorAll('.btn-reject').forEach(btn => {
                    btn.addEventListener('click', function() {
                        const payrollId = this.dataset.payrollId;
                        const employeeName = this.dataset.employee || this.closest('.payroll-card')?.querySelector('.employee-name')?.textContent?.trim() || 'Employee';
                        const payPeriod = this.dataset.period || this.closest('.payroll-card')?.querySelector('.payroll-id')?.textContent?.match(/Period: (.+)/)?.[1] || '';
                        if (payrollId) rejectPayroll(payrollId, employeeName, payPeriod);
                    });
                });
                
                // View details buttons
                document.querySelectorAll('.btn-view').forEach(btn => {
                    btn.addEventListener('click', function() {
                        const payrollId = this.dataset.payrollId || this.closest('.payroll-card')?.dataset.payrollId;
                        if (payrollId) viewPayrollDetails(payrollId);
                    });
                });
            }
            
            function approvePayroll(payrollId, employeeName, payPeriod) {
                if (confirm('Are you sure you want to approve this payroll?\n\nEmployee: ' + employeeName + '\nPeriod: ' + payPeriod)) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/hr/payroll-approval/approve';
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'approve';
                    form.appendChild(actionInput);
                    
                    const payrollIdInput = document.createElement('input');
                    payrollIdInput.type = 'hidden';
                    payrollIdInput.name = 'payrollId';
                    payrollIdInput.value = payrollId;
                    form.appendChild(payrollIdInput);
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            }
            
            function rejectPayroll(payrollId, employeeName, payPeriod) {
                const reason = prompt('Enter rejection reason (optional):');
                if (reason !== null) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/hr/payroll-approval/reject';
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'reject';
                    form.appendChild(actionInput);
                    
                    const payrollIdInput = document.createElement('input');
                    payrollIdInput.type = 'hidden';
                    payrollIdInput.name = 'payrollId';
                    payrollIdInput.value = payrollId;
                    form.appendChild(payrollIdInput);
                    
                    if (reason) {
                        const reasonInput = document.createElement('input');
                        reasonInput.type = 'hidden';
                        reasonInput.name = 'rejectReason';
                        reasonInput.value = reason;
                        form.appendChild(reasonInput);
                    }
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            }
            
            function viewPayrollDetails(payrollId) {
                window.open('${pageContext.request.contextPath}/hr/payroll-approval/details?payrollId=' + payrollId, '_blank');
            }
            
            function loadPayrollHistory() {
                const employeeId = document.getElementById('historyEmployeeFilter') ? document.getElementById('historyEmployeeFilter').value : '';
                const month = document.getElementById('historyMonthFilter') ? document.getElementById('historyMonthFilter').value : '';
                
                const historyList = document.getElementById('payrollHistoryList');
                if (!historyList) return;
                
                historyList.innerHTML = '<div class="loading-state"><i class="fas fa-spinner fa-spin"></i><p>Loading payroll history...</p></div>';
                
                // Build URL - show Approved and Paid payrolls
                let url = '${pageContext.request.contextPath}/hr/payroll-approval?status=Approved';
                if (employeeId) url += '&employeeFilter=' + employeeId;
                if (month) url += '&monthFilter=' + month;
                
                fetch(url)
                    .then(response => response.text())
                    .then(html => {
                        const parser = new DOMParser();
                        const doc = parser.parseFromString(html, 'text/html');
                        const payrollsSection = doc.querySelector('.payrolls-list') || doc.querySelector('#payrollsList');
                        
                        if (payrollsSection && payrollsSection.innerHTML.trim()) {
                            const cards = payrollsSection.querySelectorAll('.payroll-card');
                            if (cards.length > 0) {
                                let cardsHTML = '';
                                cards.forEach(card => {
                                    cardsHTML += card.outerHTML;
                                });
                                historyList.innerHTML = cardsHTML;
                                attachPayrollEventListeners();
                            } else {
                                historyList.innerHTML = '<div class="empty-state"><i class="fas fa-inbox"></i><h3>No Payroll History Found</h3><p>No approved payrolls match your filters.</p></div>';
                            }
                        } else {
                            historyList.innerHTML = '<div class="empty-state"><i class="fas fa-inbox"></i><h3>No Payroll History Found</h3><p>No approved payrolls match your filters.</p></div>';
                        }
                    })
                    .catch(err => {
                        console.error('Error loading payroll history:', err);
                        historyList.innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-circle"></i><h3>Error Loading History</h3><p>' + err.message + '</p></div>';
                    });
            }
            
            // Add URL restoration to existing DOMContentLoaded
            // This code will run after the first DOMContentLoaded
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', function() {
                    initURLState();
                });
            } else {
                // DOM already loaded
                initURLState();
            }
            
            function initURLState() {
                // Check URL parameters to restore state
                const urlParams = new URLSearchParams(window.location.search);
                const section = urlParams.get('section');
                const payrollStatus = urlParams.get('payrollStatus');
                
                // If section is payroll-management, show it
                if (section === 'payroll-management') {
                    setTimeout(() => {
                        showSection('payroll-management');
                        // Data is already loaded from backend, no need to reload
                    }, 100);
                } else if (section) {
                    // Show other sections from URL
                    setTimeout(() => {
                        showSection(section);
                    }, 100);
                }
                
                // Load initial data when payroll-approval tab is clicked (if not already loaded from backend)
                const payrollApprovalTab = document.querySelector('[data-tab="payroll-approval"]');
                if (payrollApprovalTab) {
                    payrollApprovalTab.addEventListener('click', function() {
                        setTimeout(() => {
                            const tabPanel = document.getElementById('payroll-approval');
                            if (tabPanel && tabPanel.classList.contains('active')) {
                                // Check if we have URL params - if not, load initial data
                                const urlParams = new URLSearchParams(window.location.search);
                                if (!urlParams.get('section') || urlParams.get('section') !== 'payroll-management') {
                                    loadPayrollsByStatus('Pending');
                                }
                            }
                        }, 100);
                    });
                }
                
                // Also handle when clicking on Payroll section from sidebar
                const payrollNavItem = document.querySelector('.nav-item[data-section="payroll-management"]');
                if (payrollNavItem) {
                    payrollNavItem.addEventListener('click', function(e) {
                        // Redirect to payroll approval page
                        e.preventDefault();
                        window.location.href = '${pageContext.request.contextPath}/hr/payroll-approval?status=Pending';
                    });
                }
            }
            
            // Update URL without reloading page (for non-payroll sections)
            function updateURL(params) {
                const url = new URL(window.location);
                Object.keys(params).forEach(key => {
                    if (params[key]) {
                        url.searchParams.set(key, params[key]);
                    } else {
                        url.searchParams.delete(key);
                    }
                });
                window.history.pushState({}, '', url);
            }
        </script>
    </body>
</html>

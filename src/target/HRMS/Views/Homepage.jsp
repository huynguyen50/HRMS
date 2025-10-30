<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HRMS - Human Resource Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/flag-icon-css/7.2.3/css/flag-icons.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #1e40af;
            --accent-color: #3b82f6;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --dark-color: #1f2937;
            --light-color: #f8fafc;
            --text-color: #374151;
            --text-muted: #6b7280;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            line-height: 1.6;
            color: var(--text-color);
            background-color: var(--light-color);
        }
        
        /* Top Functional Bar */
        .top-bar {
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            color: white;
            padding: 0.75rem 0;
            font-size: 0.875rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            position: relative;
            z-index: 1000;
        }
        
        .top-bar::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(90deg, transparent 0%, rgba(255,255,255,0.05) 50%, transparent 100%);
            pointer-events: none;
        }
        
        .top-bar .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
            z-index: 1;
        }
        
        .top-nav {
            display: flex;
            align-items: center;
            gap: 2.5rem;
        }
        
        .top-nav a {
            color: rgba(255, 255, 255, 0.85);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            position: relative;
        }
        
        .top-nav a::before {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 50%;
            width: 0;
            height: 2px;
            background: linear-gradient(90deg, #3b82f6, #8b5cf6);
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }
        
        .top-nav a:hover {
            color: white;
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-1px);
        }
        
        .top-nav a:hover::before {
            width: 80%;
        }
        
        .social-icons {
            display: flex;
            align-items: center;
            gap: 1.25rem;
        }
        
        .social-icons a {
            color: rgba(255, 255, 255, 0.75);
            font-size: 1.1rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            padding: 0.5rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
        }
        
        .social-icons a:hover {
            color: white;
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-2px) scale(1.1);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        
        .search-container {
            display: flex;
            align-items: center;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 30px;
            padding: 0.5rem 1.25rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            backdrop-filter: blur(10px);
            position: relative;
            overflow: hidden;
        }
        
        .search-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.5s ease;
        }
        
        .search-container:hover {
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(255, 255, 255, 0.3);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        
        .search-container:hover::before {
            left: 100%;
        }
        
        .search-container input {
            background: transparent;
            border: none;
            color: white;
            outline: none;
            width: 220px;
            padding: 0.25rem 0.75rem;
            font-size: 0.9rem;
            font-weight: 400;
        }
        
        .search-container input::placeholder {
            color: rgba(255, 255, 255, 0.6);
            font-weight: 400;
        }
        
        .search-container button {
            background: none;
            border: none;
            color: rgba(255, 255, 255, 0.8);
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            padding: 0.25rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
        }
        
        .search-container button:hover {
            color: white;
            background: rgba(255, 255, 255, 0.1);
            transform: scale(1.1);
        }
        
        /* Dashboard Dropdown Styles */
        .dashboard-dropdown {
            position: relative;
            display: inline-block;
        }
        
        .dashboard-dropdown-menu {
            position: absolute;
            top: 100%;
            left: 0;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            width: 100%; /* match Dashboard trigger width */
            min-width: unset;
            max-width: 240px; /* smaller */
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(0, 0, 0, 0.1);
            padding: 0.25rem; /* more compact */
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }
        
        .dashboard-dropdown-menu.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }
        
        .dashboard-dropdown-item {
            display: flex;
            align-items: center;
            padding: 6px 10px;
            color: #111827; /* darker for readability */
            text-decoration: none;
            transition: all 0.2s ease;
            border: 1px solid #e5e7eb; /* card style */
            border-radius: 8px;
            position: relative;
            background: #ffffff;
            height: 40px; /* smaller, consistent height */
        }
        
        .dashboard-dropdown-item:last-child { }
        
        .dashboard-dropdown-item:hover {
            background: #f8fafc;
            color: #111827;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.08);
        }
        
        .dashboard-dropdown-item i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
            font-size: 0.9rem;
            flex-shrink: 0;
        }
        
        .dashboard-dropdown-item span {
            font-weight: 600;
            font-size: 0.9rem;
            color: #111827; /* primary label darker */
        }
        
        .dashboard-dropdown-item small {
            display: block;
            color: #4b5563; /* slightly darker subtitle */
            font-size: 0.8rem;
            margin-top: 2px;
        }

        /* No special responsive needed; keep single column */
        
        /* Role-specific colors */
        .dashboard-dropdown-item.admin {
            border-left: 4px solid #dc2626;
        }
        
        .dashboard-dropdown-item.admin:hover {
            background: #fef2f2;
        }
        
        .dashboard-dropdown-item.admin i {
            color: #dc2626;
        }
        
        .dashboard-dropdown-item.hr {
            border-left: 4px solid #2563eb;
        }
        
        .dashboard-dropdown-item.hr:hover {
            background: #eff6ff;
        }
        
        .dashboard-dropdown-item.hr i {
            color: #2563eb;
        }
        
        .dashboard-dropdown-item.employee {
            border-left: 4px solid #059669;
        }
        
        .dashboard-dropdown-item.employee:hover {
            background: #ecfdf5;
        }
        
        .dashboard-dropdown-item.employee i {
            color: #059669;
        }
        
        .dashboard-dropdown-item.guest {
            border-left: 4px solid #6b7280;
        }
        
        .dashboard-dropdown-item.guest:hover {
            background: #f9fafb;
        }
        
        .dashboard-dropdown-item.guest i {
            color: #6b7280;
        }
        
        /* Profile Dropdown Styles */
        .profile-dropdown {
            position: relative;
            display: inline-block;
        }
        
        .profile-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid rgba(255, 255, 255, 0.2);
        }
        
        .profile-avatar:hover {
            transform: scale(1.1);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
        }
        
        .profile-dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            min-width: 200px;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(0, 0, 0, 0.1);
        }
        
        .profile-dropdown-menu.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }
        
        .profile-dropdown-item {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            color: #374151;
            text-decoration: none;
            transition: all 0.2s ease;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .profile-dropdown-item:last-child {
            border-bottom: none;
        }
        
        .profile-dropdown-item:hover {
            background: #f8fafc;
            color: #1f2937;
            text-decoration: none;
        }
        
        .profile-dropdown-item i {
            margin-right: 10px;
            width: 16px;
            text-align: center;
        }
        
        .profile-dropdown-item.logout {
            color: #dc2626;
        }
        
        .profile-dropdown-item.logout:hover {
            background: #fef2f2;
            color: #b91c1c;
        }
        
        .search-container button:active {
            transform: scale(0.95);
        }
        
        /* Search Highlights */
        .search-highlight {
            background-color: #fff59d !important;
            color: #333 !important;
            padding: 2px 4px;
            border-radius: 3px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .search-highlight:hover {
            background-color: #ffeb3b !important;
            transform: scale(1.05);
        }
        
        /* Search Message Animations */
        @keyframes slideInRight {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        @keyframes slideOutRight {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(100%);
                opacity: 0;
            }
        }
        
        /* Accessibility */
        .sr-only {
            position: absolute;
            width: 1px;
            height: 1px;
            padding: 0;
            margin: -1px;
            overflow: hidden;
            clip: rect(0, 0, 0, 0);
            white-space: nowrap;
            border: 0;
        }
        
        /* Focus styles for accessibility */
        .top-nav a:focus,
        .social-icons a:focus,
        .search-container input:focus,
        .search-container button:focus {
            outline: 2px solid #3b82f6;
            outline-offset: 2px;
        }
        
        /* Skip to content link */
        .skip-link {
            position: absolute;
            top: -40px;
            left: 6px;
            background: #000;
            color: #fff;
            padding: 8px;
            text-decoration: none;
            z-index: 10000;
            border-radius: 4px;
        }
        
        .skip-link:focus {
            top: 6px;
        }
        
        /* Header */
        .header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 1rem 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .navbar-brand {
            font-size: 1.5rem;
            font-weight: 700;
            color: white !important;
        }
        
        .nav-link {
            color: rgba(255, 255, 255, 0.9) !important;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .nav-link:hover {
            color: white !important;
            transform: translateY(-1px);
        }
        
        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 80px 0;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><polygon fill="rgba(255,255,255,0.05)" points="0,1000 1000,0 1000,1000"/></svg>');
            background-size: cover;
        }
        
        .hero-content {
            position: relative;
            z-index: 2;
        }
        
        .hero-title {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            line-height: 1.2;
        }
        
        .hero-subtitle {
            font-size: 1.25rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }
        
        .btn-hero {
            background: white;
            color: var(--primary-color);
            padding: 15px 30px;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            border: 2px solid white;
        }
        
        .btn-hero:hover {
            background: transparent;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }
        
        /* User Role Information */
        .user-role-info {
            margin: 1.5rem 0;
        }
        
        .role-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            padding: 0.75rem 1.25rem;
            border-radius: 25px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .role-badge:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .role-badge i {
            font-size: 1.2rem;
            color: #fbbf24;
        }
        
        .role-badge span {
            font-size: 1rem;
        }
        
        .role-badge small {
            display: block;
            font-size: 0.8rem;
            opacity: 0.8;
            margin-top: 2px;
        }
        
        /* Image Carousel */
        .hero-carousel {
            position: relative;
            width: 100%;
            height: 400px;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            margin: 0;
            padding: 0;
        }
        
        .carousel-container {
            position: relative;
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 0;
        }
        
        .carousel-slide {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            transform: translateX(100%);
            transition: all 1.2s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            margin: 0;
            padding: 0;
            border: none;
            will-change: transform, opacity;
        }
        
        .carousel-slide.active {
            opacity: 1;
            transform: translateX(0) scale(1);
            z-index: 3;
        }
        
        .carousel-slide.prev {
            transform: translateX(-100%) scale(0.95);
            opacity: 0.3;
            z-index: 1;
        }
        
        .carousel-slide.next {
            transform: translateX(100%) scale(0.95);
            opacity: 0.3;
            z-index: 1;
        }
        
        /* Smooth fade effect */
        .carousel-slide:not(.active):not(.prev):not(.next) {
            opacity: 0;
            transform: translateX(100%) scale(0.9);
            z-index: 0;
        }
        
        .carousel-indicators {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 8px;
            z-index: 10;
            flex-wrap: wrap;
            justify-content: center;
        }
        
        .carousel-indicator {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.4);
            border: 2px solid rgba(255, 255, 255, 0.6);
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            position: relative;
        }
        
        .carousel-indicator:hover {
            background: rgba(255, 255, 255, 0.7);
            transform: scale(1.1);
        }
        
        .carousel-indicator.active {
            background: white;
            transform: scale(1.3);
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
        }
        
        .carousel-nav {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(0, 0, 0, 0.3);
            color: white;
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            transition: all 0.3s ease;
            z-index: 10;
        }
        
        .carousel-nav:hover {
            background: rgba(0, 0, 0, 0.6);
            transform: translateY(-50%) scale(1.1);
        }
        
        .carousel-nav.prev {
            left: 15px;
        }
        
        .carousel-nav.next {
            right: 15px;
        }
        
        .carousel-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, rgba(37, 99, 235, 0.1), rgba(30, 64, 175, 0.1));
            z-index: 5;
        }
        
        /* Remove all margins and padding from carousel elements */
        .hero-carousel * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        /* Ensure images fill the entire carousel */
        .carousel-slide {
            background-size: cover !important;
            background-position: center !important;
            background-repeat: no-repeat !important;
        }
        
        /* Features Section */
        .features-section {
            padding: 80px 0;
            background: white;
        }
        
        .section-title {
            font-size: 2.5rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 1rem;
            color: var(--dark-color);
        }
        
        .section-subtitle {
            font-size: 1.1rem;
            text-align: center;
            color: var(--text-muted);
            margin-bottom: 4rem;
        }
        
        .feature-card {
            background: white;
            border-radius: 20px;
            padding: 2.5rem;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border: 1px solid #e5e7eb;
            height: 100%;
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        
        .feature-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            color: white;
            font-size: 2rem;
        }
        
        .feature-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--dark-color);
        }
        
        .feature-description {
            color: var(--text-muted);
            line-height: 1.6;
        }
        
        /* Stats Section */
        .stats-section {
            background: linear-gradient(135deg, var(--dark-color) 0%, #374151 100%);
            color: white;
            padding: 80px 0;
        }
        
        .stat-item {
            text-align: center;
            padding: 2rem 1rem;
        }
        
        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            color: var(--accent-color);
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        /* Quick Actions */
        .quick-actions {
            padding: 80px 0;
            background: #f8fafc;
        }
        
        .action-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            text-align: center;
            text-decoration: none;
            color: var(--text-color);
            transition: all 0.3s ease;
            border: 2px solid transparent;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .action-card:hover {
            transform: translateY(-5px);
            border-color: var(--primary-color);
            box-shadow: 0 15px 35px rgba(37, 99, 235, 0.15);
            color: var(--text-color);
            text-decoration: none;
        }
        
        .action-icon {
            width: 60px;
            height: 60px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.5rem;
            color: white;
        }
        
        .action-icon.primary { background: var(--primary-color); }
        .action-icon.success { background: var(--success-color); }
        .action-icon.warning { background: var(--warning-color); }
        .action-icon.danger { background: var(--danger-color); }
        .action-icon.info { background: var(--accent-color); }
        .action-icon.purple { background: #8b5cf6; }
        .action-icon.teal { background: #14b8a6; }
        
        .action-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .action-description {
            color: var(--text-muted);
            font-size: 0.9rem;
        }
        
        /* Footer */
        .footer {
            background: var(--dark-color);
            color: white;
            padding: 40px 0 20px;
        }
        
        .footer-title {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        
        .footer-link {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: color 0.3s ease;
        }
        
        .footer-link:hover {
            color: white;
        }
        
        /* Flag Images */
        .flag-img {
            width: 24px;
            height: 18px;
            display: inline-block;
            object-fit: cover;
            border-radius: 3px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
            border: 1px solid rgba(0,0,0,0.1);
        }
        
        .flag-icon {
            width: 20px;
            height: 15px;
            display: inline-block;
            background-size: cover;
            background-position: center;
            border-radius: 2px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.2);
        }
        
        .dropdown-item {
            display: flex;
            align-items: center;
            padding: 8px 16px;
        }
        
        .dropdown-item:hover {
            background-color: var(--primary-color);
            color: white;
        }
        
        .dropdown-item:hover .flag-icon {
            box-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
        
         /* Responsive */
         @media (max-width: 1200px) {
             .top-nav {
                 gap: 2rem;
             }
             
             .search-container input {
                 width: 180px;
             }
         }
         
         @media (max-width: 992px) {
             .top-bar .container {
                 flex-wrap: wrap;
                 gap: 1rem;
             }
             
             .top-nav {
                 gap: 1.5rem;
             }
             
             .search-container {
                 order: 3;
                 width: 100%;
                 max-width: 400px;
                 margin: 0 auto;
             }
             
             .search-container input {
                 width: 100%;
             }
         }
         
         @media (max-width: 768px) {
             .top-bar {
                 padding: 0.5rem 0;
             }
             
             .top-bar .container {
                 flex-direction: column;
                 gap: 1rem;
             }
             
             .top-nav {
                 gap: 1rem;
                 flex-wrap: wrap;
                 justify-content: center;
                 order: 2;
             }
             
             .top-nav a {
                 padding: 0.4rem 0.8rem;
                 font-size: 0.85rem;
             }
             
             .search-container {
                 order: 1;
                 width: 100%;
                 max-width: 350px;
                 margin: 0 auto;
             }
             
             .search-container input {
                 width: 100%;
                 font-size: 0.85rem;
             }
             
             .social-icons {
                 gap: 0.75rem;
                 order: 3;
             }
             
             .social-icons a {
                 width: 32px;
                 height: 32px;
                 font-size: 1rem;
             }
         }
         
         @media (max-width: 576px) {
             .top-nav {
                 gap: 0.75rem;
             }
             
             .top-nav a {
                 padding: 0.3rem 0.6rem;
                 font-size: 0.8rem;
             }
             
             .search-container {
                 max-width: 300px;
             }
             
             .social-icons a {
                 width: 30px;
                 height: 30px;
                 font-size: 0.9rem;
             }
         }
             
             .hero-title {
            font-size: 2.5rem;
             }
             
             .section-title {
                 font-size: 2rem;
             }
             
             .feature-card {
                 margin-bottom: 2rem;
             }
             
             .flag-icon {
                 width: 16px;
                 height: 12px;
             }
             
             .flag-img {
                 width: 20px;
                 height: 15px;
             }
             
             .hero-carousel {
                 height: 300px;
                 margin: 0;
                 padding: 0;
             }
             
             .carousel-container {
                 margin: 0;
                 padding: 0;
             }
             
             .carousel-slide {
                 margin: 0;
                 padding: 0;
             }
             
             .carousel-nav {
                 width: 35px;
                 height: 35px;
                 font-size: 16px;
             }
             
             .carousel-nav.prev {
                 left: 10px;
             }
             
             .carousel-nav.next {
                 right: 10px;
             }
             
             .carousel-indicators {
                 gap: 6px;
                 bottom: 15px;
             }
             
             .carousel-indicator {
                 width: 8px;
                 height: 8px;
             }
             
             .profile-avatar {
                 width: 30px;
                 height: 30px;
                 font-size: 12px;
             }
             
             .profile-dropdown-menu {
                 min-width: 180px;
                 right: -10px;
             }
             
             .dashboard-dropdown-menu {
                 min-width: 250px;
                 left: -50px;
             }
             
             .dashboard-dropdown-item {
                 padding: 10px 12px;
             }
             
             .dashboard-dropdown-item span {
                 font-size: 0.9rem;
             }
             
             .dashboard-dropdown-item small {
                 font-size: 0.75rem;
             }
        
    </style>
</head>
<body>
    <!-- Skip to content link for accessibility -->
    <a href="#home" class="skip-link">Skip to main content</a>
    
    <!-- Top Functional Bar -->
    <div class="top-bar">
        <div class="container">
                <nav class="top-nav" role="navigation" aria-label="Top navigation">
                    <a href="#home" aria-label="Go to Home section">
                        <i class="fas fa-home" aria-hidden="true"></i>
                        <span>Home</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/RecruitmentController" aria-label="Go to Recruitment page">
                        <i class="fas fa-briefcase" aria-hidden="true"></i>
                        <span>Recruitment</span>
                    </a>
                    <c:if test="${not empty sessionScope.systemUser}">
                        <div class="dashboard-dropdown">
                            <a href="#" onclick="toggleDashboardDropdown()" aria-label="Dashboard Menu">
                                <i class="fas fa-tachometer-alt" aria-hidden="true"></i>
                                <span>Dashboard</span>
                                <i class="fas fa-chevron-down" aria-hidden="true"></i>
                            </a>
                            <div class="dashboard-dropdown-menu" id="dashboardDropdown">
                                <c:if test="${dashboardAccess.canAccessAdmin}">
                                    <a href="${pageContext.request.contextPath}${dashboardAccess.adminUrl}" class="dashboard-dropdown-item admin">
                                        <i class="fas fa-crown"></i>
                                        <span>Admin Dashboard</span>
                                    </a>
                                </c:if>
                                <c:if test="${dashboardAccess.canAccessHR}">
                                    <a href="${pageContext.request.contextPath}${dashboardAccess.hrUrl}" class="dashboard-dropdown-item hr">
                                        <i class="fas fa-users-cog"></i>
                                        <span>HR Dashboard</span>
                                    </a>
                                </c:if>
                                <c:if test="${dashboardAccess.canAccessEmployee}">
                                    <a href="${pageContext.request.contextPath}${dashboardAccess.employeeUrl}" class="dashboard-dropdown-item employee">
                                        <i class="fas fa-user"></i>
                                        <span>Employee Dashboard</span>
                                    </a>
                                </c:if>
                                <c:if test="${dashboardAccess.canAccessGuest}">
                                    <a href="${pageContext.request.contextPath}${dashboardAccess.guestUrl}" class="dashboard-dropdown-item guest">
                                        <i class="fas fa-home"></i>
                                        <span>Guest View</span>
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
                </nav>
            
            <aside class="social-icons" aria-label="Social media links">
                <a href="https://www.facebook.com/ucvan.254010" target="_blank" rel="noopener noreferrer" title="Follow us on Facebook" aria-label="Facebook">
                    <i class="fab fa-facebook-f" aria-hidden="true"></i>
                </a>
                <a href="https://www.linkedin.com/in/%C4%91%E1%BB%A9c-v%C4%83n-46045537b/" target="_blank" rel="noopener noreferrer" title="Connect with us on LinkedIn" aria-label="LinkedIn">
                    <i class="fab fa-linkedin-in" aria-hidden="true"></i>
                </a>
                <a href="https://www.instagram.com/ducvan04/" target="_blank" rel="noopener noreferrer" title="Follow us on Instagram" aria-label="Instagram">
                    <i class="fab fa-instagram" aria-hidden="true"></i>
                </a>
            </aside>
            
            <div class="search-container" role="search" aria-label="Search the website">
                <label for="searchInput" class="sr-only">Search the website</label>
                <input type="text" 
                       id="searchInput" 
                       placeholder="Search..." 
                       aria-label="Search the website"
                       autocomplete="off"
                       spellcheck="false">
                <button type="button" 
                        onclick="performSearch()" 
                        aria-label="Search"
                        title="Search"
                        onkeydown="if(event.key==='Enter'||event.key===' '){performSearch();event.preventDefault();}">
                    <i class="fas fa-search" aria-hidden="true"></i>
                </button>
                    </div>
                    </div>
                </div>

    <!-- Header -->
    <header class="header">
        <nav class="navbar navbar-expand-lg" aria-label="Main navigation">
            <div class="container">
                <a class="navbar-brand" href="#">
                    <i class="fas fa-users-cog me-2"></i>Human Resources Management
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                            <a class="nav-link" href="mailto:ducnvhe180815@gmail.com">
                                <i class="fas fa-envelope me-1"></i>ducnvhe180815@gmail.com
                        </a>
                    </li>
                    <li class="nav-item">
                            <a class="nav-link" href="tel:0123456789">
                                <i class="fas fa-phone me-1"></i>0818886875
                        </a>
                    </li>
                        <li class="nav-item dropdown">
                            <button class="nav-link dropdown-toggle" type="button" id="languageDropdown" data-bs-toggle="dropdown" aria-expanded="false" style="background: none; border: none; color: inherit;">
                                <i class="fas fa-globe me-1"></i>Language
                            </button>
                            <ul class="dropdown-menu">
                                <li><button class="dropdown-item" type="button" onclick="switchLanguage('en-us')" style="background: none; border: none; width: 100%; text-align: left;">
                                    <img src="${pageContext.request.contextPath}/image/Language/co-anh-4.jpg" alt="UK Flag" class="flag-img me-2">English (US)
                                </button></li>
                                <li><button class="dropdown-item" type="button" onclick="switchLanguage('vi')" style="background: none; border: none; width: 100%; text-align: left;">
                                    <img src="${pageContext.request.contextPath}/image/Language/Co-Vietnam.png" alt="Vietnam Flag" class="flag-img me-2">Tiếng Việt
                                </button></li>
                </ul>
                    </li>
                    <li class="nav-item">
                        <!-- Show Login button when not logged in -->
                        <c:if test="${empty sessionScope.systemUser}">
                            <a class="nav-link" href="${pageContext.request.contextPath}/Views/Login.jsp">
                                <i class="fas fa-sign-in-alt me-1"></i>Login
                            </a>
                        </c:if>
                        
                        <!-- Show Profile dropdown when logged in -->
                        <c:if test="${not empty sessionScope.systemUser}">
                            <div class="profile-dropdown">
                                <div class="profile-avatar" onclick="toggleProfileDropdown()" title="Profile Menu">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div class="profile-dropdown-menu" id="profileDropdown">
                                    <a href="${pageContext.request.contextPath}/profilepage" class="profile-dropdown-item">
                                        <i class="fas fa-user"></i>
                                        Profile
                                    </a>
                                    <a href="${pageContext.request.contextPath}/Admin/AdminHome.jsp" class="profile-dropdown-item">
                                        <i class="fas fa-tachometer-alt"></i>
                                        Dashboard
                                    </a>
                                    <a href="${pageContext.request.contextPath}/Views/ChangePassword.jsp" class="profile-dropdown-item">
                                        <i class="fas fa-key"></i>
                                        Change Password
                                    </a>
                                    <a href="#" class="profile-dropdown-item">
                                        <i class="fas fa-cog"></i>
                                        Settings
                                    </a>
                                    <a href="javascript:void(0)" onclick="handleLogout()" class="profile-dropdown-item logout">
                                        <i class="fas fa-sign-out-alt"></i>
                                        Logout
                                    </a>
                                </div>
                            </div>
                        </c:if>
                    </li>
                </ul>
                </div>
            </div>
        </nav>
    </header>

     <!-- Hero Section -->
     <section id="home" class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <div class="hero-content">
                        <h1 class="hero-title">Welcome to Our Company</h1>
                        <p class="hero-subtitle">We are a professional company with years of experience in technology and services. We are committed to providing the best solutions for our customers.</p>
                        
                        <!-- User Role Information -->
                        <c:if test="${not empty sessionScope.systemUser}">
                            <div class="user-role-info">
                                <div class="role-badge">
                                    <i class="fas fa-user-circle"></i>
                                    <span>Welcome, ${currentUser.username}</span>
                                    <c:if test="${not empty userRole}">
                                        <small>Role: ${userRole.roleName}</small>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                        
                        <div class="hero-buttons">
                            <a href="#contact" class="btn-hero">
                                <i class="fas fa-phone me-2"></i>Contact Us
                            </a>
                            <a href="#about" class="btn-hero" style="background: transparent; color: white; border: 2px solid white; margin-left: 1rem;">
                                <i class="fas fa-info-circle me-2"></i>Learn More
                            </a>
            </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <!-- Image Carousel -->
                    <div class="hero-carousel">
                        <div class="carousel-container">
                            <div class="carousel-slide active" style="background-image: url('${pageContext.request.contextPath}/image/background/1.png');"></div>
                            <div class="carousel-slide" style="background-image: url('${pageContext.request.contextPath}/image/background/2.png');"></div>
                            <div class="carousel-slide" style="background-image: url('${pageContext.request.contextPath}/image/background/3.png');"></div>
                            <div class="carousel-slide" style="background-image: url('${pageContext.request.contextPath}/image/background/4.png');"></div>
                            <div class="carousel-slide" style="background-image: url('${pageContext.request.contextPath}/image/background/5.png');"></div>
                            <div class="carousel-overlay"></div>
            </div>
                        
                        <!-- Navigation arrows -->
                        <button class="carousel-nav prev" onclick="changeSlide(-1)">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <button class="carousel-nav next" onclick="changeSlide(1)">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                        
                        <!-- Indicators -->
                        <div class="carousel-indicators">
                            <span class="carousel-indicator active" onclick="currentSlide(1)"></span>
                            <span class="carousel-indicator" onclick="currentSlide(2)"></span>
                            <span class="carousel-indicator" onclick="currentSlide(3)"></span>
                            <span class="carousel-indicator" onclick="currentSlide(4)"></span>
                            <span class="carousel-indicator" onclick="currentSlide(5)"></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
     </section>

     <!-- News Section -->
     <section id="news" class="features-section" style="background: #f8fafc;">
         <div class="container">
             <h2 class="section-title">Latest News</h2>
             <p class="section-subtitle">Stay updated with our latest news and announcements</p>

            <div class="row">
                 <div class="col-lg-4 col-md-6 mb-4">
                     <div class="feature-card">
                         <div class="feature-icon" style="background: #10b981;">
                             <i class="fas fa-newspaper"></i>
                </div>
                         <h3 class="feature-title">Company Expansion</h3>
                         <p class="feature-description">We are excited to announce our expansion into new markets, bringing our services to more customers worldwide.</p>
                         <small class="text-muted">December 15, 2024</small>
                </div>
                </div>
                 <div class="col-lg-4 col-md-6 mb-4">
                     <div class="feature-card">
                         <div class="feature-icon" style="background: #3b82f6;">
                             <i class="fas fa-award"></i>
                </div>
                         <h3 class="feature-title">Industry Recognition</h3>
                         <p class="feature-description">Our company has been recognized as the best service provider in the technology sector for 2024.</p>
                         <small class="text-muted">December 10, 2024</small>
                </div>
                </div>
                 <div class="col-lg-4 col-md-6 mb-4">
                     <div class="feature-card">
                         <div class="feature-icon" style="background: #f59e0b;">
                             <i class="fas fa-users"></i>
                         </div>
                         <h3 class="feature-title">Team Growth</h3>
                         <p class="feature-description">We welcome 20 new talented professionals to our team, strengthening our capabilities.</p>
                         <small class="text-muted">December 5, 2024</small>
                     </div>
                 </div>
             </div>
         </div>
     </section>

     <!-- About Company Section -->
    <section id="about" class="features-section">
        <div class="container">
            <h2 class="section-title">About Our Company</h2>
            <p class="section-subtitle">We are proud to be one of the leading companies in our field</p>
            
            <!-- Company Image Section -->
            <div class="row mb-5">
                <div class="col-12 text-center">
                    <img src="${pageContext.request.contextPath}/image/background/6.png" 
                         alt="About Our Company" 
                         style="width: 100%; max-width: 800px; height: 300px; object-fit: cover; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                </div>
</div>

            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-award"></i>
            </div>
                        <h3 class="feature-title">Experience</h3>
                        <p class="feature-description">With over 10 years of experience in the field, we have served thousands of customers with the best service quality.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <h3 class="feature-title">Professional Team</h3>
                        <p class="feature-description">Our experienced team of professionals, deeply trained and always ready to support customers 24/7.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-handshake"></i>
                        </div>
                        <h3 class="feature-title">Quality Commitment</h3>
                        <p class="feature-description">We are committed to providing high-quality products and services that meet all customer needs.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-lightbulb"></i>
                        </div>
                        <h3 class="feature-title">Innovation</h3>
                        <p class="feature-description">Always updating and applying the latest technologies to bring the best experience to customers.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-heart"></i>
                        </div>
                        <h3 class="feature-title">Dedicated Service</h3>
                        <p class="feature-description">Customers are at the center of all activities. We always listen and serve with all our heart.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-globe"></i>
                        </div>
                        <h3 class="feature-title">Global Reach</h3>
                        <p class="feature-description">Operating in many countries and territories, bringing international quality services.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Company Stats Section -->
    <section class="stats-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-3 col-md-6">
                    <div class="stat-item">
                        <div class="stat-number">10+</div>
                        <div class="stat-label">Years Experience</div>
                            </div>
                            </div>
                <div class="col-lg-3 col-md-6">
                    <div class="stat-item">
                        <div class="stat-number">1000+</div>
                        <div class="stat-label">Satisfied Customers</div>
                        </div>
                    </div>
                <div class="col-lg-3 col-md-6">
                    <div class="stat-item">
                        <div class="stat-number">50+</div>
                        <div class="stat-label">Successful Projects</div>
                </div>
            </div>
                <div class="col-lg-3 col-md-6">
                    <div class="stat-item">
                        <div class="stat-number">24/7</div>
                        <div class="stat-label">Customer Support</div>
    </div>
</div>
                </div>
                </div>
    </section>

    <!-- Quick Actions Section -->
    <section class="quick-actions">
        <div class="container">
            <h2 class="section-title">Quick Actions</h2>
            <p class="section-subtitle">Access key HR functions quickly and efficiently</p>
            
            <div class="row">
                <div class="col-lg-3 col-md-6 mb-4">
                    <a href="${pageContext.request.contextPath}/RecruitmentController" class="action-card">
                        <div class="action-icon purple">
                            <i class="fas fa-briefcase"></i>
                        </div>
                        <h4 class="action-title">View Jobs</h4>
                        <p class="action-description">Browse available job opportunities and apply online</p>
                    </a>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <a href="${pageContext.request.contextPath}/Views/hr/ViewCandidate.jsp" class="action-card">
                        <div class="action-icon teal">
                            <i class="fas fa-users"></i>
                        </div>
                        <h4 class="action-title">View Candidates</h4>
                        <p class="action-description">Review and manage candidate applications and profiles</p>
                    </a>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <a href="${pageContext.request.contextPath}/Views/hr/HrHome.jsp" class="action-card">
                        <div class="action-icon primary">
                            <i class="fas fa-tachometer-alt"></i>
                        </div>
                        <h4 class="action-title">HR Dashboard</h4>
                        <p class="action-description">Access comprehensive HR management tools and reports</p>
                    </a>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <a href="${pageContext.request.contextPath}/Views/hr/EmploymentStatus.jsp" class="action-card">
                        <div class="action-icon success">
                            <i class="fas fa-user-check"></i>
                        </div>
                        <h4 class="action-title">Employment Status</h4>
                        <p class="action-description">Manage employee status and employment records</p>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Information Section -->
    <section id="contact" class="quick-actions">
        <div class="container">
            <h2 class="section-title">Contact Information</h2>
            <p class="section-subtitle">Contact us for the best consultation and support</p>
            
            <!-- Contact Image Section -->
            <div class="row mb-5">
                <div class="col-12 text-center">
                    <img src="${pageContext.request.contextPath}/image/background/7.png" 
                         alt="Contact Us" 
                         style="width: 100%; max-width: 800px; height: 300px; object-fit: cover; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                </div>
</div>

            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="action-card">
                        <div class="action-icon primary">
                            <i class="fas fa-phone"></i>
                        </div>
                        <h4 class="action-title">Phone</h4>
                        <p class="action-description">Hotline:0818886875 <br>Phone:081818886875</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="action-card">
                        <div class="action-icon success">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <h4 class="action-title">Email</h4>
                        <p class="action-description">ducnvhe180815@gmail.com<br>ducnvhe180815@gmail</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="action-card">
                        <div class="action-icon warning">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <h4 class="action-title">Address</h4>
                        <p class="action-description">FPT <br>Hà  Nội, Vietnam</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="action-card">
                        <div class="action-icon info">
                            <i class="fas fa-clock"></i>
                        </div>
                        <h4 class="action-title">Working Hours</h4>
                        <p class="action-description">Monday - Friday: 8:00 - 17:30<br>Saturday: 8:00 - 12:00</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="action-card">
                        <div class="action-icon primary">
                            <i class="fas fa-globe"></i>
                        </div>
                        <h4 class="action-title">Website</h4>
                        <p class="action-description">www.company.com<br>www.company.vn</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="action-card">
                        <div class="action-icon success">
                            <i class="fas fa-headset"></i>
                        </div>
                        <h4 class="action-title">24/7 Support</h4>
                        <p class="action-description">Hotline: 1900-1234<br>Email: ducnvhe180815@gmail</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Social Media Section -->
    <section class="features-section">
        <div class="container">
            <h2 class="section-title">Connect With Us</h2>
            <p class="section-subtitle">Follow us on social media for the latest updates</p>
            
            <div class="row">
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="feature-card text-center">
                        <div class="feature-icon" style="background: #1877f2;">
                            <i class="fab fa-facebook-f"></i>
                        </div>
                        <h3 class="feature-title">Facebook</h3>
                        <p class="feature-description">Follow us on Facebook for the latest news and events</p>
                        <a href="#" class="btn btn-primary">Follow</a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="feature-card text-center">
                        <div class="feature-icon" style="background: #1da1f2;">
                            <i class="fab fa-twitter"></i>
                        </div>
                        <h3 class="feature-title">Twitter</h3>
                        <p class="feature-description">Connect with us on Twitter to share opinions and discussions</p>
                        <a href="#" class="btn btn-info">Follow</a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="feature-card text-center">
                        <div class="feature-icon" style="background: #0077b5;">
                            <i class="fab fa-linkedin-in"></i>
                        </div>
                        <h3 class="feature-title">LinkedIn</h3>
                        <p class="feature-description">Professional networking with us on LinkedIn</p>
                        <a href="#" class="btn btn-primary">Connect</a>
                            </div>
                            </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="feature-card text-center">
                        <div class="feature-icon" style="background: #e4405f;">
                            <i class="fab fa-instagram"></i>
                        </div>
                        <h3 class="feature-title">Instagram</h3>
                        <p class="feature-description">Follow images and videos about company activities</p>
                        <a href="#" class="btn btn-danger">Follow</a>
                    </div>
                </div>
            </div>
            </div>
    </section>

    <!-- FAQ Section -->
    <section class="quick-actions">
        <div class="container">
            <h2 class="section-title">Frequently Asked Questions</h2>
            <p class="section-subtitle">Common questions and answers from us</p>
            
            <div class="row">
                <div class="col-lg-6 mb-4">
                    <div class="feature-card">
                        <h4 class="feature-title"><i class="fas fa-question-circle text-primary me-2"></i>What field does the company operate in?</h4>
                        <p class="feature-description">We specialize in information technology, software development and providing digital solutions for businesses.</p>
                    </div>
                </div>
                <div class="col-lg-6 mb-4">
                    <div class="feature-card">
                        <h4 class="feature-title"><i class="fas fa-question-circle text-primary me-2"></i>How to contact the company?</h4>
                        <p class="feature-description">You can contact us via hotline 0818886875, email ducnvhe180815@gmail.com or visit our office directly.</p>
                    </div>
                </div>
                <div class="col-lg-6 mb-4">
                    <div class="feature-card">
                        <h4 class="feature-title"><i class="fas fa-question-circle text-primary me-2"></i>What are the company's working hours?</h4>
                        <p class="feature-description">We work Monday to Friday (8:00-17:30) and Saturday (8:00-12:00). 24/7 customer support via hotline.</p>
                    </div>
                </div>
                <div class="col-lg-6 mb-4">
                    <div class="feature-card">
                        <h4 class="feature-title"><i class="fas fa-question-circle text-primary me-2"></i>Does the company provide customer support?</h4>
                        <p class="feature-description">Yes, we have a 24/7 customer support team via hotline 1900-1234 and email support@company.com.</p>
                    </div>
                </div>
                <div class="col-lg-6 mb-4">
                    <div class="feature-card">
                        <h4 class="feature-title"><i class="fas fa-question-circle text-primary me-2"></i>How to become a partner?</h4>
                        <p class="feature-description">You can send partnership proposals via email partnership@company.com or contact the business department directly.</p>
                    </div>
                            </div>
                <div class="col-lg-6 mb-4">
                    <div class="feature-card">
                        <h4 class="feature-title"><i class="fas fa-question-circle text-primary me-2"></i>Is the company hiring?</h4>
                        <p class="feature-description">Yes, we regularly recruit for IT, marketing, and business positions. Send your CV to hr@company.com.</p>
                            </div>
                        </div>
                    </div>
                </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-lg-4">
                    <h5 class="footer-title">Human Resources Management</h5>
                    <p>We are committed to providing the best solutions for customers with professional team and extensive experience.</p>
                    <div class="social-links mt-3">
                        <a href="#" class="me-3"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="me-3"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="me-3"><i class="fab fa-linkedin-in"></i></a>
                        <a href="#" class="me-3"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>
                <div class="col-lg-2">
                    <h6>Quick Links</h6>
                    <ul class="list-unstyled">
                        <li><a href="#about" class="footer-link">About Us</a></li>
                        <li><a href="#contact" class="footer-link">Contact</a></li>
                        <li><a href="#" class="footer-link">Services</a></li>
                        <li><a href="#" class="footer-link">News</a></li>
                    </ul>
                </div>
                <div class="col-lg-3">
                    <h6>Contact Information</h6>
                    <ul class="list-unstyled">
                        <li><i class="fas fa-phone me-2"></i>0818886875</li>
                        <li><i class="fas fa-envelope me-2"></i>ducnvhe180815@gmail.com</li>
                        <li><i class="fas fa-map-marker-alt me-2"></i>Hà Nội</li>
                        <li><i class="fas fa-clock me-2"></i>Mon-Fri: 8:00-17:30</li>
                    </ul>
                </div>
                <div class="col-lg-3">
                    <h6>Newsletter Subscription</h6>
                    <p>Get the latest information from us</p>
                    <div class="input-group">
                        <input type="email" class="form-control" placeholder="Your email">
                        <button class="btn btn-primary" type="button">Subscribe</button>
                    </div>
                </div>
            </div>
            <hr class="my-4" style="border-color: rgba(255,255,255,0.1);">
            <div class="row">
                <div class="col-12 text-center">
                    <p>&copy; 2024 Human Resources Management. All rights reserved.</p>
            </div>
    </div>
</div>
    </footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Language switching functionality
        function switchLanguage(lang) {
            if (lang === 'en-us') {
                // US English content
                document.querySelector('.hero-title').textContent = 'Welcome to Our Company';
                document.querySelector('.hero-subtitle').textContent = 'We are a professional company with years of experience in technology and services. We are committed to providing the best solutions for our customers.';
                document.querySelector('.hero-buttons .btn-hero:first-child').innerHTML = '<i class="fas fa-phone me-2"></i>Contact Us';
                document.querySelector('.hero-buttons .btn-hero:last-child').innerHTML = '<i class="fas fa-info-circle me-2"></i>Learn More';
                document.querySelector('.section-title').textContent = 'About Our Company';
                document.querySelector('.section-subtitle').textContent = 'We are proud to be one of the leading companies in our field';
                
                // Update contact information for US
                updateContactInfo('US');
                
            } else if (lang === 'vi') {
                // Vietnamese content
                document.querySelector('.hero-title').textContent = 'Chào mừng đến với Công ty chúng tôi';
                document.querySelector('.hero-subtitle').textContent = 'Chúng tôi là một công ty chuyên nghiệp với nhiều năm kinh nghiệm trong lĩnh vực công nghệ và dịch vụ. Chúng tôi cam kết mang đến những giải pháp tốt nhất cho khách hàng.';
                document.querySelector('.hero-buttons .btn-hero:first-child').innerHTML = '<i class="fas fa-phone me-2"></i>Liên hệ ngay';
                document.querySelector('.hero-buttons .btn-hero:last-child').innerHTML = '<i class="fas fa-info-circle me-2"></i>Tìm hiểu thêm';
                document.querySelector('.section-title').textContent = 'Về Công ty chúng tôi';
                document.querySelector('.section-subtitle').textContent = 'Chúng tôi tự hào là một trong những công ty hàng đầu trong lĩnh vực của mình';
                
                // Update contact information for Vietnam
                updateContactInfo('VN');
                
                // Update other sections to Vietnamese
                updateVietnameseContent();
            }
        }
        
        function updateVietnameseContent() {
            // Update stats section
            const statLabels = document.querySelectorAll('.stat-label');
            if (statLabels.length >= 4) {
                statLabels[0].textContent = 'Năm kinh nghiệm';
                statLabels[1].textContent = 'Khách hàng hài lòng';
                statLabels[2].textContent = 'Dự án thành công';
                statLabels[3].textContent = 'Hỗ trợ khách hàng';
            }
            
            // Update contact section title
            const contactSection = document.querySelector('#contact .section-title');
            if (contactSection) {
                contactSection.textContent = 'Thông tin liên hệ';
            }
            
            const contactSubtitle = document.querySelector('#contact .section-subtitle');
            if (contactSubtitle) {
                contactSubtitle.textContent = 'Liên hệ với chúng tôi để được tư vấn và hỗ trợ tốt nhất';
            }
            
            // Update social media section
            const socialSection = document.querySelector('.features-section .section-title');
            if (socialSection && socialSection.textContent.includes('Connect')) {
                socialSection.textContent = 'Kết nối với chúng tôi';
            }
            
            const socialSubtitle = document.querySelector('.features-section .section-subtitle');
            if (socialSubtitle && socialSubtitle.textContent.includes('Follow us')) {
                socialSubtitle.textContent = 'Theo dõi chúng tôi trên các mạng xã hội để cập nhật thông tin mới nhất';
            }
            
            // Update FAQ section
            const faqSection = document.querySelector('.quick-actions .section-title');
            if (faqSection && faqSection.textContent.includes('Frequently')) {
                faqSection.textContent = 'Câu hỏi thường gặp';
            }
            
            const faqSubtitle = document.querySelector('.quick-actions .section-subtitle');
            if (faqSubtitle && faqSubtitle.textContent.includes('Common questions')) {
                faqSubtitle.textContent = 'Những câu hỏi phổ biến và câu trả lời từ chúng tôi';
            }
        }
        
        function updateContactInfo(region) {
            const phoneLinks = document.querySelectorAll('a[href^="tel:"]');
            const emailLinks = document.querySelectorAll('a[href^="mailto:"]');
            
            if (region === 'US') {
                // US phone format
                phoneLinks.forEach(link => {
                    link.innerHTML = '<i class="fas fa-phone me-1"></i>0818886875';
                    link.href = 'tel:0818886875';
                });
                
                // US email
                emailLinks.forEach(link => {
                    link.innerHTML = '<i class="fas fa-envelope me-1"></i>ducnvhe180815@gmail.com';
                    link.href = 'mailto:info@company.com';
                });
                
                // Update address
                const addressElements = document.querySelectorAll('.action-description');
                addressElements.forEach(element => {
                    if (element.textContent.includes('FPT')) {
                        element.innerHTML = 'FPT, Hà Nội';
                    }
                });
                
            } else if (region === 'VN') {
                // Vietnam phone format
                phoneLinks.forEach(link => {
                    link.innerHTML = '<i class="fas fa-phone me-1"></i>0818886875';
                    link.href = 'tel:0818886875';
                });
                
                // Vietnam email
                emailLinks.forEach(link => {
                    link.innerHTML = '<i class="fas fa-envelope me-1"></i>ducnvhe180815@gmail.com';
                    link.href = 'mailto:ducnvhe180815@gmail.com';
                });
                
                // Update address
                const addressElements = document.querySelectorAll('.action-description');
                addressElements.forEach(element => {
                    if (element.textContent.includes('FPT')) {
                        element.innerHTML = 'FPT <br>Hà Nội, Vietnam';
                    }
                });
            }
        }
        
         // Enhanced Search functionality
         let searchResults = [];
         let currentHighlightIndex = 0;
         
         function performSearch() {
             const searchInput = document.getElementById('searchInput');
             const searchTerm = searchInput.value.trim();
             
             if (searchTerm === '') {
                 showSearchMessage('Please enter a search term', 'warning');
                 return;
             }
             
             // Clear previous highlights
             clearHighlights();
             
             // Find all text nodes
             const walker = document.createTreeWalker(
                 document.body,
                 NodeFilter.SHOW_TEXT,
                 null,
                 false
             );
             
             const textNodes = [];
             let node;
             while (node = walker.nextNode()) {
                 if (node.textContent.trim().length > 0) {
                     textNodes.push(node);
                 }
             }
             
             // Search in text nodes
             searchResults = [];
             const searchTermLower = searchTerm.toLowerCase();
             
             textNodes.forEach((textNode, index) => {
                 const text = textNode.textContent;
                 const textLower = text.toLowerCase();
                 
                 if (textLower.includes(searchTermLower)) {
                     const parent = textNode.parentElement;
                     if (parent && !parent.closest('.top-bar, .header, .footer')) {
                         searchResults.push({
                             element: parent,
                             text: text,
                             index: index
                         });
                     }
                 }
             });
             
             if (searchResults.length > 0) {
                 highlightSearchResults(searchTerm);
                 showSearchMessage('Found ' + searchResults.length + ' result(s) for "' + searchTerm + '"', 'success');
                 
                 // Scroll to first result
                 if (searchResults[0]) {
                     searchResults[0].element.scrollIntoView({ 
                         behavior: 'smooth', 
                         block: 'center' 
                     });
                 }
             } else {
                 showSearchMessage('No results found for "' + searchTerm + '"', 'error');
             }
         }
         
         function highlightSearchResults(searchTerm) {
             const regex = new RegExp('(' + searchTerm + ')', 'gi');
             
             searchResults.forEach((result, index) => {
                 const element = result.element;
                 const originalHTML = element.innerHTML;
                 
                 element.innerHTML = originalHTML.replace(regex, '<mark class="search-highlight" data-index="' + index + '">$1</mark>');
                 
                 // Add click handler to highlights
                 const highlights = element.querySelectorAll('.search-highlight');
                 highlights.forEach(highlight => {
                     highlight.addEventListener('click', () => {
                         highlightSearchResult(parseInt(highlight.dataset.index));
                     });
                 });
             });
         }
         
         function clearHighlights() {
             const highlights = document.querySelectorAll('.search-highlight');
             highlights.forEach(highlight => {
                 const parent = highlight.parentNode;
                 parent.replaceChild(document.createTextNode(highlight.textContent), highlight);
                 parent.normalize();
             });
             searchResults = [];
             currentHighlightIndex = 0;
         }
         
         function highlightSearchResult(index) {
             const highlights = document.querySelectorAll('.search-highlight');
             highlights.forEach((highlight, i) => {
                 highlight.style.backgroundColor = i === index ? '#ffeb3b' : '#fff59d';
                 highlight.style.fontWeight = i === index ? 'bold' : 'normal';
             });
             
             if (searchResults[index]) {
                 searchResults[index].element.scrollIntoView({ 
                     behavior: 'smooth', 
                     block: 'center' 
                 });
             }
         }
         
         function showSearchMessage(message, type) {
             // Remove existing message
             const existingMessage = document.querySelector('.search-message');
             if (existingMessage) {
                 existingMessage.remove();
             }
             
             // Create new message
             const messageDiv = document.createElement('div');
             messageDiv.className = 'search-message alert alert-' + (type === 'success' ? 'success' : type === 'warning' ? 'warning' : 'danger');
            messageDiv.style.cssText = 
                'position: fixed;' +
                'top: 20px;' +
                'right: 20px;' +
                'z-index: 9999;' +
                'padding: 12px 20px;' +
                'border-radius: 8px;' +
                'box-shadow: 0 4px 12px rgba(0,0,0,0.15);' +
                'font-size: 14px;' +
                'font-weight: 500;' +
                'max-width: 300px;' +
                'animation: slideInRight 0.3s ease;';
             messageDiv.textContent = message;
             
             document.body.appendChild(messageDiv);
             
             // Auto remove after 3 seconds
             setTimeout(() => {
                 if (messageDiv.parentNode) {
                     messageDiv.style.animation = 'slideOutRight 0.3s ease';
                     setTimeout(() => messageDiv.remove(), 300);
                 }
             }, 3000);
         }
         
         // Enhanced event listeners
         document.addEventListener('DOMContentLoaded', function() {
             const searchInput = document.getElementById('searchInput');
             
             // Search on Enter key
             searchInput.addEventListener('keypress', function(e) {
                 if (e.key === 'Enter') {
                     e.preventDefault();
                     performSearch();
                 }
             });
             
             // Clear search on Escape
             searchInput.addEventListener('keydown', function(e) {
                 if (e.key === 'Escape') {
                     clearHighlights();
                     this.value = '';
                     showSearchMessage('Search cleared', 'info');
                 }
             });
             
             // Real-time search suggestions (optional)
             let searchTimeout;
             searchInput.addEventListener('input', function() {
                 clearTimeout(searchTimeout);
                 searchTimeout = setTimeout(() => {
                     if (this.value.length > 2) {
                         // Could implement real-time suggestions here
                     }
                 }, 300);
             });
         });
         
         // Image Carousel functionality
         let currentSlideIndex = 0;
         const slides = document.querySelectorAll('.carousel-slide');
         const indicators = document.querySelectorAll('.carousel-indicator');
         let carouselInterval;
         let isTransitioning = false;
         
         function showSlide(index) {
             if (isTransitioning) return;
             isTransitioning = true;
             
             // Remove active class from all slides and indicators
             slides.forEach(slide => slide.classList.remove('active', 'prev', 'next'));
             indicators.forEach(indicator => indicator.classList.remove('active'));
             
             // Add active class to current slide and indicator
             slides[index].classList.add('active');
             indicators[index].classList.add('active');
             
             // Add prev/next classes for smooth transitions
             if (index > 0) {
                 slides[index - 1].classList.add('prev');
             }
             if (index < slides.length - 1) {
                 slides[index + 1].classList.add('next');
             }
             
             // Reset transition lock after animation completes
             setTimeout(() => {
                 isTransitioning = false;
             }, 1200);
         }
         
         function changeSlide(direction) {
             currentSlideIndex += direction;
             
             if (currentSlideIndex >= slides.length) {
                 currentSlideIndex = 0;
             } else if (currentSlideIndex < 0) {
                 currentSlideIndex = slides.length - 1;
             }
             
             showSlide(currentSlideIndex);
             resetCarouselInterval();
         }
         
         function currentSlide(index) {
             currentSlideIndex = index - 1;
             showSlide(currentSlideIndex);
             resetCarouselInterval();
         }
         
         function resetCarouselInterval() {
             clearInterval(carouselInterval);
             carouselInterval = setInterval(() => {
                 changeSlide(1);
             }, 4000); // Auto-advance every 4 seconds for smoother experience
         }
         
         // Touch/swipe support for mobile
         let startX = 0;
         let endX = 0;
         
         function handleTouchStart(e) {
             startX = e.touches[0].clientX;
         }
         
         function handleTouchEnd(e) {
             endX = e.changedTouches[0].clientX;
             handleSwipe();
         }
         
         function handleSwipe() {
             const threshold = 50;
             const diff = startX - endX;
             
             if (Math.abs(diff) > threshold) {
                 if (diff > 0) {
                     changeSlide(1); // Swipe left - next slide
                 } else {
                     changeSlide(-1); // Swipe right - previous slide
                 }
             }
         }
         
         // Set default language to US English
         document.addEventListener('DOMContentLoaded', function() {
             switchLanguage('en-us');
             
             // Initialize carousel
             if (slides.length > 0) {
                 showSlide(0);
                 resetCarouselInterval();
                 
                 // Add touch event listeners
                 const carousel = document.querySelector('.hero-carousel');
                 if (carousel) {
                     carousel.addEventListener('touchstart', handleTouchStart, false);
                     carousel.addEventListener('touchend', handleTouchEnd, false);
                 }
                 
                 // Pause carousel on hover
                 carousel.addEventListener('mouseenter', () => {
                     clearInterval(carouselInterval);
                 });
                 
                 carousel.addEventListener('mouseleave', () => {
                     resetCarouselInterval();
                 });
             }
         });
         
         // Dashboard dropdown functionality
         function toggleDashboardDropdown() {
             const dropdown = document.getElementById('dashboardDropdown');
             if (dropdown) {
                 dropdown.classList.toggle('show');
             }
         }
         
         // Profile dropdown functionality
         function toggleProfileDropdown() {
             const dropdown = document.getElementById('profileDropdown');
             if (dropdown) {
                 dropdown.classList.toggle('show');
             }
         }
         
         // Close dropdown when clicking outside
         document.addEventListener('click', function(event) {
             const profileDropdown = document.getElementById('profileDropdown');
             const profileAvatar = document.querySelector('.profile-avatar');
             const dashboardDropdown = document.getElementById('dashboardDropdown');
             const dashboardTrigger = document.querySelector('.dashboard-dropdown > a');
             
             // Close profile dropdown
             if (profileDropdown && profileAvatar && !profileAvatar.contains(event.target) && !profileDropdown.contains(event.target)) {
                 profileDropdown.classList.remove('show');
             }
             
             // Close dashboard dropdown
             if (dashboardDropdown && dashboardTrigger && !dashboardTrigger.contains(event.target) && !dashboardDropdown.contains(event.target)) {
                 dashboardDropdown.classList.remove('show');
             }
         });
         
         // Check login status and update UI
         function checkLoginStatus() {
             // This function can be called after login/logout to update the UI
             // For now, the JSP conditional rendering handles this
             console.log('Login status checked');
         }
         
         // Handle logout
        function handleLogout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '${pageContext.request.contextPath}/logout';
            }
        }
         
         // Show login required message
         function showLoginRequired() {
             alert('Please login first to access this feature.');
             window.location.href = '${pageContext.request.contextPath}/Views/Login.jsp';
         }
     </script>
</body>
</html>

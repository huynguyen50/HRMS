<%-- 
    Document   : Recruitment
    Created on : Oct 27, 2025, 1:45:23 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.hrm.model.entity.Recruitment"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recruitment - HRMS</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f8f9fa;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
        }

        .header-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .home-btn {
            background: rgba(239, 247, 247, 0.95);
            color: white;
            padding: 0.8rem 1.5rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .home-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
            color: white;
            text-decoration: none;
        }

        .header-text {
            text-align: center;
            flex: 1;
        }

        .header h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            font-weight: 700;
        }

        .header p {
            font-size: 1.2rem;
            opacity: 0.9;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .hero-section {
            background: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .hero-content {
            text-align: center;
        }

        .hero-content h2 {
            font-size: 2rem;
            color: #2c3e50;
            margin-bottom: 1rem;
        }

        .hero-content p {
            font-size: 1.1rem;
            color: #666;
            max-width: 600px;
            margin: 0 auto;
        }

        .jobs-section {
            padding: 2rem 0;
        }

        .section-title {
            text-align: center;
            margin-bottom: 3rem;
        }

        .section-title h2 {
            font-size: 2.2rem;
color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .section-title p {
            font-size: 1.1rem;
            color: #666;
        }

        .jobs-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .job-card {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: 1px solid #e9ecef;
        }

        .job-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .job-header {
            margin-bottom: 1.5rem;
        }

        .job-title {
            font-size: 1.4rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .job-location {
            color: #666;
            font-size: 0.95rem;
            margin-bottom: 0.5rem;
        }

        .job-salary {
            color: #27ae60;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .job-applicant {
            color: #667eea;
            font-weight: 600;
            font-size: 1rem;
            margin-top: 0.5rem;
        }

        .job-status {
            display: inline-block;
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-top: 0.5rem;
        }

        .status-new {
            background-color: #28a745;
            color: white;
        }

        .status-waiting {
            background-color: #ffc107;
            color: #333;
        }

        .status-applied {
            background-color: #17a2b8;
            color: white;
        }

        .status-close {
            background-color: #6c757d;
            color: white;
        }

        .status-deleted {
            background-color: #dc3545;
            color: white;
        }

        .job-description {
            color: #666;
            margin-bottom: 1.5rem;
            line-height: 1.6;
        }

        .job-requirements {
            margin-bottom: 1.5rem;
        }

        .job-requirements h4 {
            color: #2c3e50;
            margin-bottom: 0.5rem;
            font-size: 1rem;
        }

        .job-requirements ul {
            list-style: none;
            padding-left: 0;
        }

        .job-requirements li {
            color: #666;
            margin-bottom: 0.3rem;
            padding-left: 1rem;
            position: relative;
        }

        .job-requirements li:before {
            content: "•";
            color: #667eea;
            font-weight: bold;
            position: absolute;
            left: 0;
        }

        .job-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 1.5rem;
            padding-top: 1rem;
            border-top: 1px solid #e9ecef;
        }

        .job-date {
            color: #999;
            font-size: 0.9rem;
        }

        .apply-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 0.7rem 1.5rem;
            border: none;
            border-radius: 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .apply-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .company-info {
            background: white;
            padding: 3rem 0;
            margin-top: 3rem;
box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .company-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
            text-align: center;
        }

        .stat-item h3 {
            font-size: 2.5rem;
            color: #667eea;
            margin-bottom: 0.5rem;
        }

        .stat-item p {
            color: #666;
            font-weight: 500;
        }

        .contact-section {
            background: #2c3e50;
            color: white;
            padding: 3rem 0;
            text-align: center;
        }

        .contact-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .contact-item {
            padding: 1rem;
        }

        .contact-item i {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: #667eea;
        }

        .alert {
            padding: 1rem;
            margin: 1rem 0;
            border-radius: 8px;
            font-weight: 500;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        @media (max-width: 768px) {
            .header h1 {
                font-size: 2rem;
            }
            
            .jobs-grid {
                grid-template-columns: 1fr;
            }
            
            .job-card {
                padding: 1.5rem;
            }
        }
    </style>
    </head>
    <body>
    <div class="header">
        <div class="container">
            <div class="header-content">
                <a href="${pageContext.request.contextPath}/Views/Homepage.jsp" class="btn-homepage" title="Back to Homepage">
                            <i class="fas fa-home"></i>
                            <span>Homepage</span>
                        </a>
                <div class="header-text">
                    <h1><i class="fas fa-briefcase"></i> Recruitment</h1>
                    <p>Discover amazing career opportunities with us</p>
                </div>
            </div>
        </div>
    </div>

    <div class="hero-section">
        <div class="container">
            <div class="hero-content">
                <h2>🚀 Unlock Your Career Potential</h2>
                <p>The starting point of big dreams! We are looking for outstanding talents to grow and innovate together.</p>
            </div>
        </div>
    </div>

    <div class="jobs-section">
        <div class="container">
            <div class="section-title">
                <h2>Career Opportunities</h2>
                <p>Explore attractive job positions</p>
            </div>

            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
<i class="fas fa-check-circle"></i> <%= request.getAttribute("success") %>
                </div>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <div class="jobs-grid">
                <%
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                    List<Recruitment> recruitments = (List<Recruitment>) request.getAttribute("recruitments");
                    if (recruitments != null && !recruitments.isEmpty()) {
                        for (Recruitment recruitment : recruitments) {
                %>
                <div class="job-card">
                    <div class="job-header">
                        <h3 class="job-title"><%= recruitment.getTitle() %></h3>
                        <div class="job-location">
                            <i class="fas fa-map-marker-alt"></i> <%= recruitment.getLocation() %>
                        </div>
                        <% if (recruitment.getSalary() != null) { %>
                        <div class="job-salary">
                            <i class="fas fa-money-bill-wave"></i> <%= String.format("%,.0f", recruitment.getSalary()) %> VNĐ
                        </div>
                        <% } %>
                        <div class="job-applicant">
                            <i class="fas fa-users"></i> Number of vacancies: <%= recruitment.getApplicant() %> People
                        </div>
                        <% if (recruitment.getStatus() != null && "Applied".equals(recruitment.getStatus())) { %>
                        <div class="job-status status-applied">
                            <i class="fas fa-info-circle"></i> Available
                        </div>
                        <% } %>
                    </div>

                    <div class="job-description">
                        <%= recruitment.getDescription() %>
                    </div>

                    <% if (recruitment.getRequirement() != null && !recruitment.getRequirement().trim().isEmpty()) { %>
                    <div class="job-requirements">
                        <h4>Requirements:</h4>
                        <ul>
                            <% 
                                String[] requirements = recruitment.getRequirement().split("\n");
                                for (String req : requirements) {
                                    if (!req.trim().isEmpty()) {
                            %>
                            <li><%= req.trim() %></li>
                            <% 
                                    }
                                }
                            %>
                        </ul>
                    </div>
                    <% } %>

                    <div class="job-footer">
                        <div class="job-date">
                            <i class="fas fa-calendar"></i> 
                            <% if (recruitment.getPostedDate() != null) { %>
                                <%= recruitment.getPostedDate().format(formatter) %>
                            <% } %>
                        </div>
<<<<<<< HEAD
=======
                        <% 
                            // Chỉ hiển thị nút Apply vì chỉ có recruitment có Status = Applied mới được hiển thị
                            String status = recruitment.getStatus();
                            boolean canApply = status != null && status.equals("Applied");
                        %>
                        <% if (canApply) { %>
>>>>>>> main
                        <a href="${pageContext.request.contextPath}/RecruitmentController?action=apply&recruitmentId=<%= recruitment.getRecruitmentId() %>" 
                           class="apply-btn">
                            <i class="fas fa-paper-plane"></i> Apply Now
                        </a>
                        <% } else { %>
                        <span class="apply-btn" style="background: #6c757d; cursor: not-allowed; opacity: 0.7;">
                            <i class="fas fa-lock"></i> Đã đóng
                        </span>
                        <% } %>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="job-card" style="grid-column: 1 / -1; text-align: center;">
                    <h3>No job postings available at the moment</h3>
                    <p>Please check back later for new career opportunities.</p>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>

    <div class="company-info">
        <div class="container">
            <div class="section-title">
                <h2>Why Choose Us?</h2>
                <p>Professional work environment and unlimited development opportunities</p>
            </div>
            
            <div class="company-stats">
                <div class="stat-item">
                    <h3>500+</h3>
                    <p>Employees</p>
                </div>
                <div class="stat-item">
                    <h3>50+</h3>
                    <p>Projects</p>
                </div>
                <div class="stat-item">
                    <h3>15+</h3>
                    <p>Years Experience</p>
                </div>
                <div class="stat-item">
                    <h3>98%</h3>
                    <p>Satisfaction</p>
                </div>
            </div>
        </div>
    </div>

    <div class="contact-section">
        <div class="container">
            <h2>🥳 Connect With Us</h2>
            <p>We do not charge any fees to candidates during the recruitment process</p>
            
            <div class="contact-info">
                <div class="contact-item">
                    <i class="fas fa-envelope"></i>
                    <h4>Email</h4>
                    <p>ducnvhe180815@fpt.edu.vn</p>
                </div>
                <div class="contact-item">
                    <i class="fas fa-phone"></i>
                    <h4>Phone</h4>
                    <p>0818886875</p>
                </div>
                <div class="contact-item">
                    <i class="fas fa-map-marker-alt"></i>
                    <h4>Address</h4>
                    <p>Fpt Hà Nội</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Smooth scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });

        // Add animation to job cards on scroll
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function(entries) {
entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        document.querySelectorAll('.job-card').forEach(card => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            observer.observe(card);
        });
    </script>
    </body>
</html>
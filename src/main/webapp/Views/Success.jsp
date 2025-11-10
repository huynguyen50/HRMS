<%-- 
    Document   : Success
    Created on : Oct 27, 2025, 1:45:23 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Application Submitted - HRMS</title>
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .success-container {
            background: white;
            padding: 3rem;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 600px;
            width: 90%;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .success-icon {
            font-size: 4rem;
            color: #27ae60;
            margin-bottom: 1.5rem;
            animation: bounce 1s ease-in-out;
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-10px);
            }
            60% {
                transform: translateY(-5px);
            }
        }

        .success-title {
            font-size: 2.5rem;
            color: #2c3e50;
            margin-bottom: 1rem;
            font-weight: 700;
        }

        .success-message {
            font-size: 1.2rem;
            color: #666;
            margin-bottom: 2rem;
            line-height: 1.8;
        }

        .success-details {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            border-left: 4px solid #27ae60;
        }

        .success-details h3 {
            color: #2c3e50;
            margin-bottom: 1rem;
            font-size: 1.3rem;
        }

        .success-details p {
            color: #666;
            margin-bottom: 0.5rem;
        }

        .success-details p:last-child {
            margin-bottom: 0;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 1rem 2rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .contact-info {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #e9ecef;
        }

        .contact-info h4 {
            color: #2c3e50;
            margin-bottom: 1rem;
        }

        .contact-info p {
            color: #666;
            font-size: 0.95rem;
        }

        @media (max-width: 768px) {
            .success-container {
                padding: 2rem 1.5rem;
            }
            
            .success-title {
                font-size: 2rem;
            }
            
            .success-message {
                font-size: 1.1rem;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-icon">
            <i class="fas fa-check-circle"></i>
        </div>
        
        <h1 class="success-title">Application Submitted Successfully!</h1>
        
        <p class="success-message">
            Thank you for your interest in joining our team. Your application has been received and is being reviewed by our HR department.
        </p>
        
        <div class="success-details">
            <h3><i class="fas fa-info-circle"></i> What happens next?</h3>
            <p><i class="fas fa-clock"></i> We will review your application within 3-5 business days</p>
            <p><i class="fas fa-envelope"></i> You will receive an email notification about the next steps</p>
            <p><i class="fas fa-phone"></i> If selected, we will contact you for an interview</p>
        </div>
        
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/RecruitmentController" class="btn btn-primary">
                <i class="fas fa-briefcase"></i> View More Jobs
            </a>
            <a href="/homepage" class="btn btn-secondary">
                <i class="fas fa-home"></i> Back to Home
            </a>
        </div>
        
        <div class="contact-info">
            <h4><i class="fas fa-headset"></i> Need Help?</h4>
            <p>If you have any questions about your application, please contact us:</p>
            <p><strong>Email:</strong> ducnvhe180815@fpt.edu.vn | <strong>Phone:</strong> 0818886875</p>
        </div>
    </div>

    <script>
        // Add some interactive effects
        document.addEventListener('DOMContentLoaded', function() {
            // Add confetti effect (simple version)
            setTimeout(() => {
                const confetti = document.createElement('div');
                confetti.style.position = 'fixed';
                confetti.style.top = '0';
                confetti.style.left = '0';
                confetti.style.width = '100%';
                confetti.style.height = '100%';
                confetti.style.pointerEvents = 'none';
                confetti.style.zIndex = '1000';
                
                for (let i = 0; i < 50; i++) {
                    const particle = document.createElement('div');
                    particle.style.position = 'absolute';
                    particle.style.width = '10px';
                    particle.style.height = '10px';
                    particle.style.backgroundColor = ['#667eea', '#764ba2', '#27ae60', '#f39c12'][Math.floor(Math.random() * 4)];
                    particle.style.borderRadius = '50%';
                    particle.style.left = Math.random() * 100 + '%';
                    particle.style.top = '-10px';
                    particle.style.animation = `fall ${Math.random() * 3 + 2}s linear forwards`;
                    
                    confetti.appendChild(particle);
                }
                
                document.body.appendChild(confetti);
                
                setTimeout(() => {
                    confetti.remove();
                }, 5000);
            }, 500);
        });

        // Add CSS for confetti animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes fall {
                to {
                    transform: translateY(100vh) rotate(360deg);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>

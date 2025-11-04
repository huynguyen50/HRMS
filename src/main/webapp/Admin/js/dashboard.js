//import { Chart } from "@/components/ui/chart"

document.addEventListener("DOMContentLoaded", () => {
  initializeDashboard()
})

function initializeDashboard() {
  // Initialize charts with real data from server
  initializeEmployeeChart()
  initializeStatusChart()
  initializeActivityChart()

  // Initialize event listeners
  setupEventListeners()
}

function initializeEmployeeChart() {
  const ctx = document.getElementById("employeeChart")
  if (!ctx) return

  const data = window.dashboardData.employeeDistribution || {}
  const labels = Object.keys(data)
  const values = Object.values(data)

  new Chart(ctx, {
    type: "bar",
    data: {
      labels: labels,
      datasets: [
        {
          label: "Number of Employees",
          data: values,
          backgroundColor: ["#10b981", "#3b82f6", "#f59e0b", "#ef4444", "#8b5cf6", "#ec4899"],
          borderColor: "#1e40af",
          borderWidth: 1,
          borderRadius: 6,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      indexAxis: "x",
      plugins: {
        legend: {
          display: true,
          position: "top",
          labels: {
            padding: 15,
            font: {
              size: 12,
              weight: "500",
            },
          },
        },
      },
      scales: {
        y: {
          beginAtZero: true,
          grid: {
            color: "rgba(0, 0, 0, 0.05)",
          },
          ticks: {
            font: {
              size: 12,
            },
          },
        },
        x: {
          grid: {
            display: false,
          },
          ticks: {
            font: {
              size: 12,
            },
          },
        },
      },
    },
  })
}

function initializeStatusChart() {
  const ctx = document.getElementById("statusChart")
  if (!ctx) return

  const data = window.dashboardData.employeeStatus || {}
  const labels = Object.keys(data)
  const values = Object.values(data)

  new Chart(ctx, {
    type: "doughnut",
    data: {
      labels: labels,
      datasets: [
        {
          data: values,
          backgroundColor: ["#10b981", "#ef4444", "#f59e0b", "#3b82f6"],
          borderColor: "#fff",
          borderWidth: 2,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: {
          position: "bottom",
          labels: {
            padding: 15,
            font: {
              size: 12,
            },
          },
        },
      },
    },
  })
}

let activityChart = null;

function updateChartSummary(data) {
  const totalActivities = data.reduce((sum, item) => sum + item.count, 0);
  const avgActivities = (totalActivities / data.length).toFixed(1);
  const peakDay = data.reduce((max, item) => item.count > max.count ? item : max, data[0]);

  document.getElementById('totalActivities').textContent = totalActivities;
  document.getElementById('avgActivities').textContent = avgActivities;
  document.getElementById('peakDay').textContent = `${peakDay.date} (${peakDay.count})`;
}

function initializeActivityChart() {
  const ctx = document.getElementById("activityChart")
  if (!ctx) return

  const data = Array.isArray(window.dashboardData?.activityData) ? window.dashboardData.activityData : []
  // Generate sample data if no data available
  if (data.length === 0) {
    const today = new Date()
    for (let i = 6; i >= 0; i--) {
      const date = new Date(today)
      date.setDate(date.getDate() - i)
      data.push({
        date: date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }),
        count: Math.floor(Math.random() * 10)
      })
    }
  }

  updateChartSummary(data);

  const labels = data.map(item => item?.date || '')
  const values = data.map(item => item?.count || 0)

  // Create gradient
  const gradient = ctx.getContext('2d').createLinearGradient(0, 0, 0, 400)
  gradient.addColorStop(0, 'rgba(37, 99, 235, 0.2)')
  gradient.addColorStop(1, 'rgba(37, 99, 235, 0.0)')

  // Destroy existing chart if it exists
  if (activityChart) {
    activityChart.destroy();
  }

  activityChart = new Chart(ctx, {
    type: "line",
    data: {
      labels: labels,
      datasets: [
        {
          label: "System Activities",
          data: values,
          borderColor: "#2563eb",
          backgroundColor: gradient,
          borderWidth: 3,
          fill: true,
          tension: 0.4,
          pointRadius: 6,
          pointBackgroundColor: "#ffffff",
          pointBorderColor: "#2563eb",
          pointBorderWidth: 3,
          pointHoverRadius: 8,
          pointHoverBackgroundColor: "#2563eb",
          pointHoverBorderColor: "#ffffff",
          pointHoverBorderWidth: 4,
        },
      ],
    },
    options: {
      animation: {
        duration: 2000,
        easing: 'easeOutQuart'
      },
      interaction: {
        intersect: false,
        mode: 'index',
      },
      aspectRatio: 2.5,
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: {
          display: false
        },
        tooltip: {
          backgroundColor: 'rgba(17, 24, 39, 0.9)',
          titleColor: '#fff',
          bodyColor: '#fff',
          padding: 12,
          displayColors: false,
          callbacks: {
            title: function(context) {
              return context[0].label;
            },
            label: function(context) {
              return `${context.parsed.y} Activities`;
            }
          }
        }
      },
      scales: {
        y: {
          beginAtZero: true,
          min: 0,
          ticks: {
            stepSize: 1,
            precision: 0,
            font: {
              size: 12,
              weight: '500'
            },
            color: '#6b7280'
          },
          grid: {
            color: 'rgba(0, 0, 0, 0.05)',
            drawBorder: false,
            drawTicks: false
          }
        },
        x: {
          grid: {
            display: false,
            drawBorder: false,
            drawTicks: false
          },
          ticks: {
            font: {
              size: 12,
              weight: '500'
            },
            color: '#6b7280'
          }
        }
      }
    },
  })
}

// Add event listener for range selector
document.getElementById('activityChartRange')?.addEventListener('change', function(e) {
  const days = parseInt(e.target.value);
  // Here you would typically fetch new data from the server
  // For now, we'll generate sample data
  const today = new Date();
  const data = [];
  for (let i = days - 1; i >= 0; i--) {
    const date = new Date(today);
    date.setDate(date.getDate() - i);
    data.push({
      date: date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }),
      count: Math.floor(Math.random() * 15)
    });
  }
  window.dashboardData.activityData = data;
  initializeActivityChart();
});


function setupEventListeners() {
  // Search functionality
  const searchInputs = document.querySelectorAll(".search-input")
  searchInputs.forEach((input) => {
    input.addEventListener("input", (e) => {
      console.log("[v0] Search query:", e.target.value)
    })
  })

  // Time filter functionality
  const timeFilter = document.querySelector(".time-selector")
  if (timeFilter) {
    timeFilter.addEventListener("change", (e) => {
      console.log("[v0] Time filter changed:", e.target.value)
    })
  }

  // Notification button
  const notificationBtn = document.querySelector(".notification-btn")
  if (notificationBtn) {
    notificationBtn.addEventListener("click", () => {
      console.log("[v0] Notification clicked")
    })
  }

  // User profile menu
  const userMenu = document.querySelector(".user-menu")
  if (userMenu) {
    userMenu.addEventListener("click", () => {
      console.log("[v0] User profile clicked")
    })
  }
}

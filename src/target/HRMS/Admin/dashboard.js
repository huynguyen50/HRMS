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

function initializeActivityChart() {
  const ctx = document.getElementById("activityChart")
  if (!ctx) return

  const data = window.dashboardData.activityData || {}
  const labels = Object.keys(data)
  const values = Object.values(data)

  new Chart(ctx, {
    type: "line",
    data: {
      labels: labels,
      datasets: [
        {
          label: "System Activity",
          data: values,
          borderColor: "#3b82f6",
          backgroundColor: "rgba(59, 130, 246, 0.1)",
          borderWidth: 2,
          fill: true,
          tension: 0.4,
          pointRadius: 4,
          pointBackgroundColor: "#3b82f6",
          pointBorderColor: "#fff",
          pointBorderWidth: 2,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: {
          display: true,
          position: "top",
          labels: {
            padding: 15,
            font: {
              size: 12,
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

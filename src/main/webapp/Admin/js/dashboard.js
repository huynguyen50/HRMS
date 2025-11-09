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

// Global variable to store activity chart instance
let activityChartInstance = null;

function initializeActivityChart() {
  const ctx = document.getElementById("activityChart")
  if (!ctx) return

  // Get data from server (already loaded with correct days parameter)
  const data = window.dashboardData.activityData || []
  
  // Get selected days from dropdown (set by JSP based on URL parameter)
  const activityChartRange = document.getElementById("activityChartRange")
  const selectedDays = activityChartRange ? parseInt(activityChartRange.value) : 7
  
  // Use data from server (already filtered by backend)
  updateActivityChart(data)
  
  // Calculate and display statistics
  calculateActivityStatistics(data)
  
  console.log('[Activity] Initialized with', selectedDays, 'days of data from server')
}

function updateActivityChart(data) {
  const ctx = document.getElementById("activityChart")
  if (!ctx) return

  const labels = data.map(item => {
    // Parse date string (YYYY-MM-DD format) and format to readable format (e.g., "Jan 15")
    // Parse date safely to avoid timezone issues
    const dateParts = item.date.split('-')
    const year = parseInt(dateParts[0])
    const month = parseInt(dateParts[1]) - 1 // Month is 0-indexed in JavaScript
    const day = parseInt(dateParts[2])
    const date = new Date(year, month, day)
    
    const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    return `${monthNames[date.getMonth()]} ${date.getDate()}`
  })
  const values = data.map(item => item.count)

  // Destroy existing chart if it exists
  if (activityChartInstance) {
    activityChartInstance.destroy()
  }

  activityChartInstance = new Chart(ctx, {
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
        aspectRatio: 2.5,
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
          tooltip: {
            callbacks: {
              label: function(context) {
                return `Activities: ${context.parsed.y}`;
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
              precision: 0
            },
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

function calculateActivityStatistics(data) {
  if (!data || data.length === 0) {
    document.getElementById("totalActivities").textContent = "0"
    document.getElementById("avgActivities").textContent = "0"
    document.getElementById("peakDay").textContent = "-"
    return
  }

  // Calculate total activities
  const totalActivities = data.reduce((sum, item) => sum + item.count, 0)
  
  // Calculate average per day
  const avgActivities = data.length > 0 ? (totalActivities / data.length).toFixed(1) : 0
  
  // Find peak day (day with maximum activities)
  let peakDay = null
  let peakCount = 0
  data.forEach(item => {
    if (item.count > peakCount) {
      peakCount = item.count
      peakDay = item.date
    }
  })
  
  // Format peak day
  let peakDayFormatted = "-"
  if (peakDay) {
    // Parse date string (YYYY-MM-DD format) safely to avoid timezone issues
    const dateParts = peakDay.split('-')
    const year = parseInt(dateParts[0])
    const month = parseInt(dateParts[1]) - 1 // Month is 0-indexed in JavaScript
    const day = parseInt(dateParts[2])
    const date = new Date(year, month, day)
    
    const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    peakDayFormatted = `${monthNames[date.getMonth()]} ${date.getDate()}`
  }
  
  // Update UI
  document.getElementById("totalActivities").textContent = totalActivities.toString()
  document.getElementById("avgActivities").textContent = avgActivities.toString()
  document.getElementById("peakDay").textContent = peakDayFormatted
}

function loadActivityData(days) {
  // Use adminBaseUrl from JSP if available, otherwise construct from contextPath
  let url
  if (window.adminBaseUrl) {
    url = `${window.adminBaseUrl}?action=activity-data&days=${days}`
  } else {
    // Fallback: construct URL from contextPath
    const contextPath = window.contextPath || ''
    const adminPath = contextPath ? `${contextPath}/admin` : '/admin'
    url = `${adminPath}?action=activity-data&days=${days}`
  }
  
  console.log('[Activity] Loading activity data for', days, 'days from:', url)
  console.log('[Activity] Admin base URL:', window.adminBaseUrl)
  
  fetch(url)
    .then(response => {
      if (!response.ok) {
        throw new Error('Failed to fetch activity data: ' + response.status)
      }
      return response.json()
    })
    .then(data => {
      console.log('[Activity] Received data:', data)
      
      if (data.error) {
        console.error('Error loading activity data:', data.error)
        alert('Error loading activity data: ' + data.error)
        return
      }
      
      // Update chart
      if (data.activityData && Array.isArray(data.activityData)) {
        updateActivityChart(data.activityData)
        calculateActivityStatistics(data.activityData)
        
        // Update chart info text
        const activityChartCard = document.querySelector('#activityChart').closest('.chart-card')
        if (activityChartCard) {
          const chartInfo = activityChartCard.querySelector('.chart-info')
          if (chartInfo) {
            chartInfo.textContent = `Last ${days} days`
          }
        }
      } else {
        console.warn('[Activity] No activity data received')
        // Set empty data
        updateActivityChart([])
        calculateActivityStatistics([])
      }
    })
    .catch(error => {
      console.error('Error loading activity data:', error)
      alert('Error loading activity data. Please check the console for details.')
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

  // Activity chart range selector
  const activityChartRange = document.getElementById("activityChartRange")
  if (activityChartRange) {
    activityChartRange.addEventListener("change", (e) => {
      const days = parseInt(e.target.value)
      console.log("[Activity] Range changed to:", days, "days")
      
      // Update URL without reloading page
      const url = new URL(window.location)
      url.searchParams.set('days', days.toString())
      window.history.pushState({}, '', url)
      
      // Load new data
      loadActivityData(days)
    })
  }

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

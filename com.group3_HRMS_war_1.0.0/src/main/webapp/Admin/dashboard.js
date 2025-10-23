// dashboard.js
import { Chart } from "@/components/ui/chart"

// Stats data
const statsData = [
  { label: "Total Users", value: "124,583", change: "+12.5%", trend: "up" },
  { label: "Revenue", value: "$45,231", change: "+8.2%", trend: "up" },
  { label: "Active Sessions", value: "8,429", change: "-3.1%", trend: "down" },
  { label: "Conversion Rate", value: "3.24%", change: "+0.5%", trend: "up" },
]

// Activity data
const activityData = [
  { icon: "✅", type: "success", message: "New deployment successful to production", time: "2 minutes ago" },
  { icon: "ℹ️", type: "info", message: "Database backup completed", time: "15 minutes ago" },
  { icon: "⚠️", type: "warning", message: "High memory usage detected on server-2", time: "1 hour ago" },
  { icon: "✅", type: "success", message: "SSL certificate renewed successfully", time: "3 hours ago" },
  { icon: "ℹ️", type: "info", message: "New user registration: john.doe@example.com", time: "5 hours ago" },
]

// Render Stats
function initStatsCards() {
  const grid = document.getElementById("statsGrid")
  grid.innerHTML = statsData.map(stat => `
    <div class="stat-card">
      <div class="stat-header">
        <span class="stat-label">${stat.label}</span>
        <span class="stat-change ${stat.trend}">${stat.change}</span>
      </div>
      <div class="stat-value">${stat.value}</div>
    </div>
  `).join("")
}

// Render Activity
function initActivityList() {
  const list = document.getElementById("activityList")
  list.innerHTML = activityData.map(a => `
    <div class="activity-item">
      <div class="activity-icon ${a.type}">${a.icon}</div>
      <div class="activity-details">
        <div class="activity-message">${a.message}</div>
        <div class="activity-time">${a.time}</div>
      </div>
    </div>
  `).join("")
}

// Charts
function initEdgeRequestsChart() {
  const ctx = document.getElementById("edgeRequestsChart")
  if (!ctx) return
  new Chart(ctx, {
    type: "line",
    data: {
      labels: ["00:00","04:00","08:00","12:00","16:00","20:00","24:00"],
      datasets: [{
        label: "Requests",
        data: [12000,19000,15000,25000,22000,30000,28000],
        borderColor: "#2563eb",
        backgroundColor: "rgba(37,99,235,0.1)",
        tension: 0.4,
        fill: true
      }]
    },
    options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } } }
  })
}

function initDataTransferChart() {
  const ctx = document.getElementById("dataTransferChart")
  if (!ctx) return
  new Chart(ctx, {
    type: "bar",
    data: {
      labels: ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"],
      datasets: [{
        label: "GB Transferred",
        data: [45,52,48,65,58,42,38],
        backgroundColor: "#2563eb",
        borderRadius: 6
      }]
    },
    options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } } }
  })
}

function initDeviceChart() {
  const ctx = document.getElementById("deviceChart")
  if (!ctx) return
  new Chart(ctx, {
    type: "doughnut",
    data: {
      labels: ["Desktop", "Mobile", "Tablet"],
      datasets: [{ data: [55,35,10], backgroundColor: ["#2563eb","#3b82f6","#60a5fa"], borderWidth: 0 }]
    },
    options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: "bottom" } } }
  })
}

// Init all
document.addEventListener("DOMContentLoaded", () => {
  initStatsCards()
  initActivityList()
  initEdgeRequestsChart()
  initDataTransferChart()
  initDeviceChart()
})

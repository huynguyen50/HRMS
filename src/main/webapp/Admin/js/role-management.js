let currentPage = 1
let currentSearch = ""
let deleteRoleId = null
const pageSize = 10
const $ = window.$ // Declare the $ variable
const contextPath = window.contextPath // Declare the contextPath variable

$(document).ready(() => {
  // Initialize user menu dropdown
  $(".user-menu-trigger").click(function (e) {
    e.stopPropagation()
    $(this).siblings(".user-menu-dropdown").toggleClass("show")
  })

  // Close dropdown when clicking outside
  $(document).click(() => {
    $(".user-menu-dropdown").removeClass("show")
  })

  loadRoles(1)
})

function loadRoles(page = 1) {
  currentPage = page
  const search = $("#roleNameFilter").val() || ""
  currentSearch = search

  console.log("[v1] loadRoles called - page:", page, "search:", search)

  const params = new URLSearchParams({
    page: page,
    pageSize: pageSize,
    search: search,
  })

  const url = contextPath + "/admin/role?" + params.toString()

  console.log("[v1] Fetching from URL:", url)

  $.ajax({
    url: url,
    type: "GET",
    dataType: "json",
    success: function(data) {
      console.log("[v1] Response received:", data)
      displayRoles(data)
      displayPagination(data)
    },
    error: function(xhr, status, error) {
      console.log("[v1] Error:", xhr, status, error)
      alert("Error loading roles: " + (xhr.responseJSON?.message || "Unknown error"))
    }
  })
}

// Display roles in table
function displayRoles(data) {
  const tbody = $("#rolesTableBody")
  tbody.empty()

  // Ensure data is properly parsed if it's a string
  let parsedData = data;
  if (typeof data === 'string') {
    try {
      parsedData = JSON.parse(data);
    } catch (e) {
      console.error("Error parsing JSON data:", e);
    }
  }

  if (parsedData.roles && parsedData.roles.length > 0) {
    parsedData.roles.forEach((role) => {
      tbody.append(`
                <tr>
                    <td>${role.roleId}</td>
                    <td>${role.roleName}</td>
                    <td>
                        <div class="action-buttons">
                            <button class="btn-edit" onclick="editRole(${role.roleId})">Edit</button>
                            <button class="btn-delete" onclick="deleteRole(${role.roleId})">Delete</button>
                        </div>
                    </td>
                </tr>
            `)
    })
  } else {
    tbody.append(`
            <tr>
                <td colspan="3" style="text-align: center; padding: 20px; color: #9ca3af;">
                    No roles found
                </td>
            </tr>
        `)
  }
}

function displayPagination(data) {
  const pagination = $(".pagination-bar")
  pagination.empty()

  // Ensure data is properly parsed if it's a string
  let parsedData = data;
  if (typeof data === 'string') {
    try {
      parsedData = JSON.parse(data);
    } catch (e) {
      console.error("Error parsing JSON data:", e);
    }
  }

  const totalItems = parsedData.totalItems || 0;
  const totalPages = parsedData.totalPages || 1;
  const start = totalItems > 0 ? (currentPage - 1) * pageSize + 1 : 0;
  const end = Math.min(currentPage * pageSize, totalItems);

  console.log("[v2] Pagination - total:", totalItems, "pages:", totalPages, "current:", currentPage);

  // Add info text
  const infoDiv = $(`
        <div class="pagination-info">
            Showing ${start} - ${end} of ${totalItems}
        </div>
    `);
  pagination.append(infoDiv);

  // Add controls
  const controlsDiv = $('<div class="pagination-controls"></div>');

  if (totalPages > 1) {
    // Previous button
    if (currentPage > 1) {
      controlsDiv.append(`<a href="javascript:void(0)" onclick="loadRoles(1)">First</a>`);
      controlsDiv.append(`<a href="javascript:void(0)" onclick="loadRoles(${currentPage - 1})">Prev</a>`);
    } else {
      controlsDiv.append('<span class="disabled">First</span>');
      controlsDiv.append('<span class="disabled">Prev</span>');
    }

    // Page numbers
    const startPage = Math.max(1, currentPage - 2);
    const endPage = Math.min(totalPages, currentPage + 2);

    if (startPage > 1) {
      controlsDiv.append(`<a href="javascript:void(0)" onclick="loadRoles(1)">1</a>`);
      if (startPage > 2) {
        controlsDiv.append('<span class="ellipsis">...</span>');
      }
    }

    for (let i = startPage; i <= endPage; i++) {
      if (i === currentPage) {
        controlsDiv.append(`<span class="active">${i}</span>`);
      } else {
        controlsDiv.append(`<a href="javascript:void(0)" onclick="loadRoles(${i})">${i}</a>`);
      }
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        controlsDiv.append('<span class="ellipsis">...</span>');
      }
      controlsDiv.append(`<a href="javascript:void(0)" onclick="loadRoles(${totalPages})">${totalPages}</a>`);
    }

    // Next button
    if (currentPage < totalPages) {
      controlsDiv.append(`<a href="javascript:void(0)" onclick="loadRoles(${currentPage + 1})">Next</a>`);
      controlsDiv.append(`<a href="javascript:void(0)" onclick="loadRoles(${totalPages})">Last</a>`);
    } else {
      controlsDiv.append('<span class="disabled">Next</span>');
      controlsDiv.append('<span class="disabled">Last</span>');
    }
  }

  pagination.append(controlsDiv);
}

function openAddRoleModal() {
  document.getElementById("modalTitle").textContent = "Add New Role"
  document.getElementById("roleForm").reset()
  document.getElementById("roleModal").classList.add("show")
}

function closeRoleModal() {
  document.getElementById("roleModal").classList.remove("show")
}

function editRole(roleId) {
  fetch(contextPath + "/admin/role/" + roleId)
    .then((response) => response.json())
    .then((data) => {
      console.log("[v0] Edit role data:", data)
      document.getElementById("modalTitle").textContent = "Edit Role"
      document.getElementById("roleName").value = data.roleName
      document.getElementById("roleForm").dataset.roleId = roleId
      document.getElementById("roleModal").classList.add("show")
    })
    .catch((err) => {
      console.log("[v0] Error fetching role:", err)
      alert("Error loading role details")
    })
}

$(document).on("submit", "#roleForm", (e) => {
  e.preventDefault()
  const roleName = document.getElementById("roleName").value
  const roleIdAttr = document.getElementById("roleForm").dataset.roleId
  const isEdit = !!roleIdAttr

  console.log("[v0] Form submit - isEdit:", isEdit, "roleId:", roleIdAttr)

  const method = isEdit ? "PUT" : "POST"
  const url = isEdit ? contextPath + "/admin/role/" + roleIdAttr : contextPath + "/admin/role"

  $.ajax({
    url: url,
    method: method,
    contentType: "application/json",
    data: JSON.stringify({ roleName: roleName }),
  })
    .done(() => {
      console.log("[v0] Role saved successfully")
      closeRoleModal()
      loadRoles(1)
    })
    .fail((xhr) => {
      console.log("[v0] Error saving role:", xhr)
      alert("Error saving role: " + (xhr.responseJSON?.message || "Unknown error"))
    })
})

function deleteRole(roleId) {
  if (confirm("Are you sure you want to delete this role? This cannot be undone if the role is not in use.")) {
    console.log("[v0] Deleting role:", roleId)

    $.ajax({
      url: contextPath + "/admin/role/" + roleId,
      method: "DELETE",
    })
      .done(() => {
        console.log("[v0] Role deleted successfully")
        loadRoles(currentPage)
      })
      .fail((xhr) => {
        console.log("[v0] Error deleting role:", xhr)
        if (xhr.status === 409) {
          alert("This role cannot be deleted because it is currently assigned to users.")
        } else {
          alert("Error deleting role: " + (xhr.responseJSON?.message || "Unknown error"))
        }
      })
  }
}

$("#roleNameFilter").on("keyup", () => {
  console.log("[v0] Filter input changed")
  loadRoles(1)
})

// Close modal on outside click
$(window).on("click", (event) => {
  if ($(event.target).is("#roleModal")) {
    closeRoleModal()
  }
})

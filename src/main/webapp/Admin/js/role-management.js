let currentPage = 1;
let deleteRoleId = null;

// Load roles on page load
$(document).ready(function() {
    // Initialize user menu dropdown
    $('.user-menu-trigger').click(function(e) {
        e.stopPropagation();
        $(this).siblings('.user-menu-dropdown').toggleClass('show');
    });

    // Close dropdown when clicking outside
    $(document).click(function() {
        $('.user-menu-dropdown').removeClass('show');
    });

    loadRoles();
});

// Load roles with pagination and search
function loadRoles(page) {
    currentPage = page || 1;
    const search = $('#roleNameFilter').val();
    const url = contextPath + '/admin/role?' + $.param({
        page: currentPage,
        search: search
    });

    $.get(url)
        .done(function(data) {
            displayRoles(data);
            displayPagination(data);
        })
        .fail(function(xhr) {
            alert('Error loading roles: ' + xhr.responseJSON?.message || 'Unknown error');
        });
}

// Display roles in table
function displayRoles(data) {
    const tbody = $('#rolesTableBody');
    tbody.empty();

    if (data.roles && data.roles.length > 0) {
        data.roles.forEach(function(role) {
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
            `);
        });
    } else {
        tbody.append(`
            <tr>
                <td colspan="3" style="text-align: center; padding: 20px; color: #9ca3af;">
                    No roles found
                </td>
            </tr>
        `);
    }
}

// Display pagination
function displayPagination(data) {
    const pagination = $('.pagination-bar');
    pagination.empty();

    if (data.totalPages > 1) {
        // Previous button
        if (currentPage > 1) {
            pagination.append(`
                <a onclick="loadRoles(1)">First</a>
                <a onclick="loadRoles(${currentPage - 1})">Previous</a>
            `);
        }

        // Page numbers
        for (let i = 1; i <= data.totalPages; i++) {
            if (i === currentPage) {
                pagination.append(`<span class="active">${i}</span>`);
            } else {
                pagination.append(`<a onclick="loadRoles(${i})">${i}</a>`);
            }
        }

        // Next button
        if (currentPage < data.totalPages) {
            pagination.append(`
                <a onclick="loadRoles(${currentPage + 1})">Next</a>
                <a onclick="loadRoles(${data.totalPages})">Last</a>
            `);
        }
    }
}

function openAddRoleModal() {
    document.getElementById('modalTitle').textContent = 'Add New Role';
    document.getElementById('roleForm').reset();
    document.getElementById('roleModal').classList.add('show');
}

function closeRoleModal() {
    document.getElementById('roleModal').classList.remove('show');
}

function editRole(roleId) {
    // Fetch role data and populate form
    fetch(contextPath + '/admin/role/' + roleId)
        .then(response => response.json())
        .then(data => {
            document.getElementById('modalTitle').textContent = 'Edit Role';
            document.getElementById('roleName').value = data.roleName;
            document.getElementById('roleModal').classList.add('show');
        });
}

// Save or update role
$(document).on('submit', '#roleForm', function(e) {
    e.preventDefault();
    const roleName = document.getElementById('roleName').value;
    const isEdit = document.getElementById('modalTitle').textContent === 'Edit Role';
    
    const method = isEdit ? 'PUT' : 'POST';
    const url = isEdit ? 
        contextPath + '/admin/role/' + roleId :
        contextPath + '/admin/role';

    $.ajax({
        url: url,
        method: method,
        contentType: 'application/json',
        data: JSON.stringify({ roleName: roleName })
    })
        .done(function() {
            closeRoleModal();
            loadRoles(currentPage);
        })
        .fail(function(xhr) {
            alert('Error saving role: ' + xhr.responseJSON?.message || 'Unknown error');
        });
});

function deleteRole(roleId) {
    if (confirm('Are you sure you want to delete this role? This cannot be undone if the role is not in use.')) {
        $.ajax({
            url: contextPath + '/admin/role/' + roleId,
            method: 'DELETE'
        })
            .done(function() {
                loadRoles(currentPage);
            })
            .fail(function(xhr) {
                if (xhr.status === 409) {
                    alert('This role cannot be deleted because it is currently assigned to users.');
                } else {
                    alert('Error deleting role: ' + xhr.responseJSON?.message || 'Unknown error');
                }
            });
    }
}

// Filter roles on input change
$('#roleNameFilter').on('keyup', function() {
    loadRoles(1);
});

// Close modal on outside click
$(window).on('click', function(event) {
    if ($(event.target).is('#roleModal')) {
        closeRoleModal();
    }
});
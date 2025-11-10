// Permission Manager JavaScript

let permissionData = [];
let userPermissions = {};
let pendingChanges = {};

// Open permission manager modal
function openPermissionManager() {
    const modal = document.getElementById('permissionModal');
    modal.classList.add('active');
    loadInitialData();
}

// Close permission manager modal
function closePermissionManager() {
    const modal = document.getElementById('permissionModal');
    modal.classList.remove('active');
    // Reset form
    document.getElementById('userSelect').value = '';
    document.getElementById('categoryFilter').value = '';
    permissionData = [];
    userPermissions = {};
    pendingChanges = {};
    document.getElementById('permissionTableBody').innerHTML = 
        '<tr><td colspan="6" class="no-data">Vui lòng chọn user để xem phân quyền</td></tr>';
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('permissionModal');
    if (event.target === modal) {
        closePermissionManager();
    }
}

// Load initial data (users and permissions)
function loadInitialData() {
    // Data should already be loaded from server via JSP
    // This function can be used for additional async loading if needed
    console.log('Permission manager opened');
}

// Load permissions for selected user
function loadUserPermissions() {
    const userId = document.getElementById('userSelect').value;
    
    if (!userId) {
        document.getElementById('permissionTableBody').innerHTML = 
            '<tr><td colspan="6" class="no-data">Vui lòng chọn user để xem phân quyền</td></tr>';
        return;
    }

    // Show loading
    document.getElementById('permissionTableBody').innerHTML = 
        '<tr><td colspan="6" class="loading">Đang tải dữ liệu</td></tr>';

    // Fetch user permissions from server
    fetch(`${window.location.origin}${window.location.pathname.replace(/\/[^/]*$/, '')}/admin?action=get-user-permissions&userId=${userId}`)
        .then(response => response.json())
        .then(data => {
            userPermissions = data.userPermissions || {};
            permissionData = data.allPermissions || [];
            renderPermissionTable();
        })
        .catch(error => {
            console.error('Error loading permissions:', error);
            document.getElementById('permissionTableBody').innerHTML = 
                '<tr><td colspan="6" class="no-data" style="color: #ef4444;">Lỗi khi tải dữ liệu. Vui lòng thử lại.</td></tr>';
        });
}

// Render permission table
function renderPermissionTable() {
    const tbody = document.getElementById('permissionTableBody');
    const categoryFilter = document.getElementById('categoryFilter').value;
    
    // Filter permissions by category
    let filteredPermissions = permissionData;
    if (categoryFilter) {
        filteredPermissions = permissionData.filter(p => p.category === categoryFilter);
    }

    if (filteredPermissions.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="no-data">Không có permission nào</td></tr>';
        return;
    }

    const userId = document.getElementById('userSelect').value;
    let html = '';

    filteredPermissions.forEach(permission => {
        const userPerm = userPermissions[permission.permissionId] || null;
        const isGranted = userPerm ? userPerm.isGranted : null;
        const scope = userPerm ? userPerm.scope : 'ALL';
        const scopeValue = userPerm ? userPerm.scopeValue : null;
        
        // Determine status
        let statusClass = 'not-set';
        let statusText = 'Chưa thiết lập';
        if (userPerm !== null) {
            statusClass = isGranted ? 'granted' : 'revoked';
            statusText = isGranted ? 'Đã cấp' : 'Đã thu hồi';
        }

        html += `
            <tr data-permission-id="${permission.permissionId}">
                <td>
                    <strong>${permission.permissionName}</strong><br>
                    <small style="color: #9ca3af;">${permission.permissionCode}</small>
                </td>
                <td><span class="scope-badge">${permission.category || 'N/A'}</span></td>
                <td>
                    <span class="permission-status ${statusClass}">${statusText}</span>
                </td>
                <td>
                    <select class="scope-select" 
                            data-permission-id="${permission.permissionId}"
                            onchange="updateScope(${permission.permissionId}, this.value)">
                        <option value="ALL" ${scope === 'ALL' ? 'selected' : ''}>ALL</option>
                        <option value="DEPARTMENT" ${scope === 'DEPARTMENT' ? 'selected' : ''}>DEPARTMENT</option>
                        <option value="SELF" ${scope === 'SELF' ? 'selected' : ''}>SELF</option>
                    </select>
                </td>
                <td>
                    <input type="number" 
                           class="scope-value-input" 
                           data-permission-id="${permission.permissionId}"
                           value="${scopeValue || ''}" 
                           placeholder="Dept ID"
                           onchange="updateScopeValue(${permission.permissionId}, this.value)"
                           ${scope !== 'DEPARTMENT' ? 'disabled' : ''}>
                </td>
                <td>
                    <div class="permission-actions">
                        <label class="permission-toggle">
                            <input type="checkbox" 
                                   ${isGranted === true ? 'checked' : ''}
                                   onchange="togglePermission(${permission.permissionId}, this.checked)"
                                   data-permission-id="${permission.permissionId}">
                            <span class="permission-toggle-slider"></span>
                        </label>
                        <button class="btn-action edit" 
                                onclick="editPermission(${permission.permissionId})"
                                title="Chỉnh sửa">
                            ✏️
                        </button>
                    </div>
                </td>
            </tr>
        `;
    });

    tbody.innerHTML = html;
}

// Filter permissions by category
function filterPermissions() {
    renderPermissionTable();
}

// Toggle permission (grant/revoke)
function togglePermission(permissionId, isGranted) {
    const userId = document.getElementById('userSelect').value;
    if (!userId) {
        alert('Vui lòng chọn user trước');
        return;
    }

    // Update local state
    if (!userPermissions[permissionId]) {
        userPermissions[permissionId] = {
            userId: parseInt(userId),
            permissionId: permissionId,
            isGranted: isGranted,
            scope: 'ALL',
            scopeValue: null
        };
    } else {
        userPermissions[permissionId].isGranted = isGranted;
    }

    // Track change
    pendingChanges[permissionId] = {
        userId: parseInt(userId),
        permissionId: permissionId,
        isGranted: isGranted,
        scope: userPermissions[permissionId].scope,
        scopeValue: userPermissions[permissionId].scopeValue
    };

    // Update UI
    const row = document.querySelector(`tr[data-permission-id="${permissionId}"]`);
    const statusCell = row.querySelector('.permission-status');
    if (isGranted) {
        statusCell.className = 'permission-status granted';
        statusCell.textContent = 'Đã cấp';
    } else {
        statusCell.className = 'permission-status revoked';
        statusCell.textContent = 'Đã thu hồi';
    }
}

// Update scope
function updateScope(permissionId, scope) {
    const userId = document.getElementById('userSelect').value;
    if (!userId) {
        return;
    }

    if (!userPermissions[permissionId]) {
        userPermissions[permissionId] = {
            userId: parseInt(userId),
            permissionId: permissionId,
            isGranted: true,
            scope: scope,
            scopeValue: null
        };
    } else {
        userPermissions[permissionId].scope = scope;
    }

    // Enable/disable scope value input
    const scopeValueInput = document.querySelector(`.scope-value-input[data-permission-id="${permissionId}"]`);
    if (scope === 'DEPARTMENT') {
        scopeValueInput.disabled = false;
    } else {
        scopeValueInput.disabled = true;
        userPermissions[permissionId].scopeValue = null;
        scopeValueInput.value = '';
    }

    // Track change
    pendingChanges[permissionId] = {
        userId: parseInt(userId),
        permissionId: permissionId,
        isGranted: userPermissions[permissionId].isGranted,
        scope: scope,
        scopeValue: userPermissions[permissionId].scopeValue
    };
}

// Update scope value
function updateScopeValue(permissionId, scopeValue) {
    const userId = document.getElementById('userSelect').value;
    if (!userId) {
        return;
    }

    if (!userPermissions[permissionId]) {
        userPermissions[permissionId] = {
            userId: parseInt(userId),
            permissionId: permissionId,
            isGranted: true,
            scope: 'DEPARTMENT',
            scopeValue: scopeValue ? parseInt(scopeValue) : null
        };
    } else {
        userPermissions[permissionId].scopeValue = scopeValue ? parseInt(scopeValue) : null;
    }

    // Track change
    pendingChanges[permissionId] = {
        userId: parseInt(userId),
        permissionId: permissionId,
        isGranted: userPermissions[permissionId].isGranted,
        scope: userPermissions[permissionId].scope,
        scopeValue: scopeValue ? parseInt(scopeValue) : null
    };
}

// Edit permission (open detailed edit modal if needed)
function editPermission(permissionId) {
    // For now, just focus on the row
    const row = document.querySelector(`tr[data-permission-id="${permissionId}"]`);
    row.scrollIntoView({ behavior: 'smooth', block: 'center' });
    row.style.backgroundColor = '#fef3c7';
    setTimeout(() => {
        row.style.backgroundColor = '';
    }, 2000);
}

// Save all pending changes
function saveAllPermissions() {
    const userId = document.getElementById('userSelect').value;
    if (!userId) {
        alert('Vui lòng chọn user trước');
        return;
    }

    if (Object.keys(pendingChanges).length === 0) {
        alert('Không có thay đổi nào để lưu');
        return;
    }

    if (!confirm(`Bạn có chắc chắn muốn lưu ${Object.keys(pendingChanges).length} thay đổi?`)) {
        return;
    }

    // Prepare data
    const changes = Object.values(pendingChanges).map(change => ({
        userId: change.userId,
        permissionId: change.permissionId,
        isGranted: change.isGranted,
        scope: change.scope,
        scopeValue: change.scopeValue
    }));

    // Send to server
    fetch(`${window.location.origin}${window.location.pathname.replace(/\/[^/]*$/, '')}/admin?action=save-user-permissions`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ changes: changes })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('Lưu thành công!');
            pendingChanges = {};
            // Reload permissions
            loadUserPermissions();
        } else {
            alert('Lỗi: ' + (data.message || 'Không thể lưu thay đổi'));
        }
    })
    .catch(error => {
        console.error('Error saving permissions:', error);
        alert('Lỗi khi lưu thay đổi. Vui lòng thử lại.');
    });
}



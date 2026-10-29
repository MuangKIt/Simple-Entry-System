// public/admin/js/staff-management.js

let usersData = [];
let filteredUsers = [];
let currentUsersPage = 1;
const PAGE_SIZE = 10;

document.addEventListener("DOMContentLoaded", function() {
    loadUsers();

    // ตัวกรองและค้นหา
    const searchInput = document.querySelector('input[placeholder*="ค้นหารหัสพนักงาน"]');
    const roleSelect = document.querySelectorAll('.card-header select')[0];
    const statusSelect = document.querySelectorAll('.card-header select')[1];

    if (searchInput) searchInput.addEventListener('input', filterAndRenderUsers);
    if (roleSelect) roleSelect.addEventListener('change', filterAndRenderUsers);
    if (statusSelect) statusSelect.addEventListener('change', filterAndRenderUsers);

    // ปุ่มบันทึกใน Modal
    const saveBtn = document.querySelector('#userModal .btn-primary-custom');
    if (saveBtn) {
        saveBtn.addEventListener('click', handleSaveUser);
    }

    // จัดการปุ่มออกจากระบบ
    document.querySelectorAll('a[href*="index.html"]').forEach(link => {
        link.addEventListener('click', async (e) => {
            e.preventDefault();
            await fetch('/api/auth/logout', { method: 'POST' }).catch(() => {});
            localStorage.clear();
            window.location.href = '/index.html';
        });
    });
});

async function loadUsers() {
    try {
        const res = await fetch('/api/users');
        if (!res.ok) return;

        const result = await res.json();
        if (result.success && result.data) {
            usersData = result.data;
            renderSummaryCards(result.summary);
            filterAndRenderUsers();
        }
    } catch (err) {
        console.error('Error loading users:', err);
    }
}

function renderSummaryCards(summary) {
    if (!summary) return;
    const cards = document.querySelectorAll('.dashboard-card .fs-5.text-dark');
    if (cards.length >= 3) {
        cards[0].innerHTML = `${summary.totalUsers} <span class="fw-normal text-muted fs-6">คน</span>`;
        cards[1].innerHTML = `${summary.activeUsers} <span class="fw-normal text-muted fs-6">คน</span>`;
        cards[2].innerHTML = `${summary.inactiveUsers} <span class="fw-normal text-muted fs-6">คน</span>`;
    }
}

function filterAndRenderUsers() {
    const searchInput = document.querySelector('input[placeholder*="ค้นหารหัสพนักงาน"]');
    const roleSelect = document.querySelectorAll('.card-header select')[0];
    const statusSelect = document.querySelectorAll('.card-header select')[1];

    const q = searchInput ? searchInput.value.trim().toLowerCase() : '';
    const role = roleSelect ? roleSelect.value.trim().toLowerCase() : '';
    const status = statusSelect ? statusSelect.value.trim().toLowerCase() : '';

    filteredUsers = usersData.filter(u => {
        const matchesQ = !q || u.empId.toLowerCase().includes(q) || u.name.toLowerCase().includes(q) || u.username.toLowerCase().includes(q);
        const matchesRole = !role || u.role.toLowerCase() === role;
        const matchesStatus = !status || u.status.toLowerCase() === status;
        return matchesQ && matchesRole && matchesStatus;
    });

    currentUsersPage = 1; // รีเซ็ตกลับไปหน้า 1 เมื่อค้นหาหรือกรอง
    renderUsersTable();
}

function renderUsersTable() {
    const tbody = document.querySelector('.master-data-table tbody');
    if (!tbody) return;

    tbody.innerHTML = '';

    const totalItems = filteredUsers.length;
    const totalPages = Math.max(1, Math.ceil(totalItems / PAGE_SIZE));
    if (currentUsersPage > totalPages) {
        currentUsersPage = totalPages;
    }

    if (totalItems === 0) {
        tbody.innerHTML = `<tr><td colspan="8" class="text-center py-4 text-muted">ไม่พบข้อมูลผู้ใช้งานที่ค้นหา</td></tr>`;
        renderPaginationControls({
            paginationEl: '#staffPagination',
            footerTextEl: '#staffFooterText',
            totalItems: 0,
            currentPage: 1,
            pageSize: PAGE_SIZE,
            onPageChange: (newPage) => {
                currentUsersPage = newPage;
                renderUsersTable();
            }
        });
        return;
    }

    const startIndex = (currentUsersPage - 1) * PAGE_SIZE;
    const endIndex = Math.min(startIndex + PAGE_SIZE, totalItems);
    const pageItems = filteredUsers.slice(startIndex, endIndex);

    pageItems.forEach(u => {
        const isAdmin = u.role === 'admin';
        const isActive = u.status === 'active';
        const lastLoginText = u.lastLogin ? new Date(u.lastLogin).toLocaleString('th-TH', { dateStyle: 'short', timeStyle: 'short' }) + ' น.' : 'ยังไม่เคยเข้าใช้';

        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
            <td class="fw-bold text-dark">${u.empId}</td>
            <td>
                <div class="fw-semibold ${isActive ? '' : 'text-muted'}">${u.name}</div>
                <div class="text-muted" style="font-size: 0.7rem;">${u.email}</div>
            </td>
            <td class="${isActive ? '' : 'text-muted'}">${u.username}</td>
            <td class="text-center">
                <span class="badge ${isAdmin ? 'role-admin' : 'role-staff'} ${isActive ? '' : 'opacity-50'}">${isAdmin ? 'Admin' : 'Staff'}</span>
            </td>
            <td class="text-muted">${lastLoginText}</td>
            <td class="text-center">
                <span class="status-badge ${isActive ? 'status-normal' : 'status-out'}">${isActive ? 'Active' : 'Inactive'}</span>
            </td>
            <td class="text-center pe-3">
                <button class="btn btn-sm btn-icon text-primary" title="แก้ไขข้อมูล" onclick="prepareEditUserForm('${u.empId}')" data-bs-toggle="modal" data-bs-target="#userModal">
                    <i class="bi bi-pencil-square"></i>
                </button>
                <button class="btn btn-sm btn-icon ${isActive ? 'text-danger' : 'text-success'}" title="${isActive ? 'ระงับบัญชี' : 'เปิดใช้งานบัญชี'}" onclick="toggleStatus('${u.empId}')">
                    <i class="bi ${isActive ? 'bi-person-slash' : 'bi-person-check'}"></i>
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });

    renderPaginationControls({
        paginationEl: '#staffPagination',
        footerTextEl: '#staffFooterText',
        totalItems: totalItems,
        currentPage: currentUsersPage,
        pageSize: PAGE_SIZE,
        onPageChange: (newPage) => {
            currentUsersPage = newPage;
            renderUsersTable();
        }
    });
}

async function toggleStatus(empId) {
    if (!confirm(`คุณต้องการเปลี่ยนสถานะการใช้งานของรหัส ${empId} ใช่หรือไม่?`)) return;

    try {
        const res = await fetch(`/api/users/${encodeURIComponent(empId)}/status`, { method: 'PATCH' });
        const result = await res.json();
        if (res.ok && result.success) {
            loadUsers();
        } else {
            alert(result.message || 'ไม่สามารถเปลี่ยนสถานะได้');
        }
    } catch (err) {
        console.error('Error toggling status:', err);
    }
}

function prepareAddUserForm() {
    document.getElementById('userModalLabel').innerText = 'เพิ่มผู้ใช้งานใหม่';
    document.getElementById('userForm').reset();
    
    document.getElementById('modalEmpId').readOnly = false;
    document.getElementById('modalUsername').readOnly = false;
    
    document.getElementById('pwRequiredStar').style.display = 'inline';
    document.getElementById('pwHelpText').innerText = 'กำหนดรหัสผ่านเพื่อเข้าใช้งาน (บังคับ)';
    document.getElementById('modalPassword').required = true;
    
    document.getElementById('modalRole').value = 'staff';
    document.getElementById('modalStatus').value = 'active';
}

function prepareEditUserForm(empId) {
    document.getElementById('userModalLabel').innerText = 'แก้ไขข้อมูลผู้ใช้งาน';
    
    const user = usersData.find(u => u.empId === empId);
    if (!user) return;

    document.getElementById('modalEmpId').value = user.empId;
    document.getElementById('modalEmpId').readOnly = true;
    document.getElementById('modalUsername').value = user.username;
    document.getElementById('modalUsername').readOnly = true;
    
    document.getElementById('pwRequiredStar').style.display = 'none';
    document.getElementById('pwHelpText').innerText = 'เว้นว่างไว้หากไม่ต้องการเปลี่ยนรหัสผ่าน';
    document.getElementById('modalPassword').required = false;
    document.getElementById('modalPassword').value = '';
    
    document.getElementById('modalName').value = user.name;
    document.getElementById('modalRole').value = user.role;
    document.getElementById('modalStatus').value = user.status;
}

async function handleSaveUser() {
    const empId = document.getElementById('modalEmpId').value.trim();
    const name = document.getElementById('modalName').value.trim();
    const username = document.getElementById('modalUsername').value.trim();
    const password = document.getElementById('modalPassword').value.trim();
    const role = document.getElementById('modalRole').value;
    const status = document.getElementById('modalStatus').value;
    const isEdit = document.getElementById('modalEmpId').readOnly;

    if (!empId || !name || !username) {
        alert('กรุณากรอกข้อมูลที่จำเป็นให้ครบถ้วน');
        return;
    }

    if (!isEdit && !password) {
        alert('กรุณากำหนดรหัสผ่านสำหรับการสร้างบัญชีใหม่');
        return;
    }

    try {
        let res;
        if (isEdit) {
            res = await fetch(`/api/users/${encodeURIComponent(empId)}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ name, role, status, password })
            });
        } else {
            res = await fetch('/api/users', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ empId, name, username, password, role, status })
            });
        }

        const result = await res.json();
        if (res.ok && result.success) {
            const modalEl = document.getElementById('userModal');
            const modal = bootstrap.Modal.getInstance(modalEl);
            if (modal) modal.hide();

            loadUsers();
        } else {
            alert(result.message || 'บันทึกข้อมูลไม่สำเร็จ');
        }
    } catch (err) {
        console.error('Error saving user:', err);
        alert('ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้');
    }
}

// public/user/js/profile.js

document.addEventListener("DOMContentLoaded", async function() {
    try {
        const res = await fetch('/api/auth/me');
        if (res.ok) {
            const result = await res.json();
            if (result.success && result.user) {
                const user = result.user;
                
                // อัปเดตรูปภาพ Avatar
                const avatarEl = document.getElementById('profileAvatar') || document.querySelector('.card-body img');
                if (avatarEl && user.name) {
                    avatarEl.src = `https://ui-avatars.com/api/?name=${encodeURIComponent(user.name)}&background=4a6d8c&color=fff&size=128`;
                }

                // อัปเดตชื่อ
                const nameEl = document.getElementById('profileName') || document.querySelector('.card-body h5');
                if (nameEl) nameEl.innerText = user.name;

                // อัปเดตรหัสพนักงาน
                const empIdEl = document.getElementById('profileEmpId') || document.querySelector('.card-body .text-muted.fw-semibold');
                if (empIdEl) empIdEl.innerText = user.empId;

                // อัปเดตสิทธิ์
                const roleBadge = document.getElementById('profileRole') || document.querySelector('.card-body .badge');
                if (roleBadge) {
                    roleBadge.innerText = user.role === 'admin' ? 'ผู้ดูแลระบบ' : 'พนักงานคลังสินค้า';
                }

                // อัปเดตยอดการทำรายการ
                const txnCountEl = document.getElementById('profileTxnCount') || document.querySelector('.card-body strong');
                if (txnCountEl) {
                    txnCountEl.innerText = (user.txnCountMonth !== undefined ? user.txnCountMonth : 0).toLocaleString();
                }
            }
        } else {
            window.location.href = '/index.html';
        }
    } catch (err) {
        console.error('Error fetching profile:', err);
    }
});

function simulateNav(pageName) {
    alert(`กำลังนำทางไปที่หน้า: ${pageName}`);
}

async function confirmLogout() {
    
    const logoutBtn = document.querySelector('.btn-logout');
    logoutBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>กำลังออกจากระบบ...';
        
    try {
        await fetch('/api/auth/logout', { method: 'POST' });
    } catch (e) {
        console.error('Logout error:', e);
    } finally {
        localStorage.clear();
        window.location.href = '/index.html';
    }
}
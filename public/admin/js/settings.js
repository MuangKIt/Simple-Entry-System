// public/admin/js/settings.js

document.addEventListener("DOMContentLoaded", function() {
    loadSettings();

    // ปุ่มดาวน์โหลด Backup
    const backupBtn = document.querySelector('button:has(.bi-cloud-download)');
    if (backupBtn) {
        backupBtn.addEventListener('click', () => {
            window.location.href = '/api/settings/backup';
        });
    }

    // ปุ่ม Factory Reset (อันตราย)
    const resetBtn = document.querySelector('button:has(.bi-exclamation-triangle)');
    if (resetBtn) {
        resetBtn.addEventListener('click', () => {
            alert('การดำเนินการนี้ต้องได้รับการยืนยันระดับระบบขั้นสูง (ฟังก์ชันป้องกันความปลอดภัย)');
        });
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

async function loadSettings() {
    try {
        const res = await fetch('/api/settings');
        if (!res.ok) return;

        const result = await res.json();
        if (result.success && result.data) {
            const s = result.data;
            const orgNameInput = document.querySelector('input[value*="สถาบัน"]');
            const sysNameInput = document.querySelector('input[value*="Simple Entry System"]');
            const thresholdInput = document.querySelector('#v-inventory input[type="number"]');
            const emailInput = document.querySelector('input[type="email"]');
            const notifSys = document.getElementById('notifSystem');
            const notifEmail = document.getElementById('notifEmail');

            if (orgNameInput && s.orgName) orgNameInput.value = s.orgName;
            if (sysNameInput && s.systemName) sysNameInput.value = s.systemName;
            if (thresholdInput && s.globalThreshold !== undefined) thresholdInput.value = s.globalThreshold;
            if (emailInput && s.adminEmail) emailInput.value = s.adminEmail;
            if (notifSys && s.inAppAlerts !== undefined) notifSys.checked = s.inAppAlerts;
            if (notifEmail && s.emailAlerts !== undefined) notifEmail.checked = s.emailAlerts;
        }
    } catch (err) {
        console.error('Error loading settings:', err);
    }
}

async function saveSettings() {
    const btn = document.querySelector('button[onclick="saveSettings()"]');
    const originalHTML = btn ? btn.innerHTML : '';

    if (btn) {
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> กำลังบันทึก...';
        btn.disabled = true;
    }

    const orgNameInput = document.querySelector('input[value*="สถาบัน"]');
    const sysNameInput = document.querySelector('input[value*="Simple Entry System"]');
    const thresholdInput = document.querySelector('#v-inventory input[type="number"]');
    const emailInput = document.querySelector('input[type="email"]');
    const notifSys = document.getElementById('notifSystem');
    const notifEmail = document.getElementById('notifEmail');

    const payload = {
        orgName: orgNameInput ? orgNameInput.value.trim() : undefined,
        systemName: sysNameInput ? sysNameInput.value.trim() : undefined,
        globalThreshold: thresholdInput ? parseInt(thresholdInput.value) || 10 : undefined,
        adminEmail: emailInput ? emailInput.value.trim() : undefined,
        inAppAlerts: notifSys ? notifSys.checked : undefined,
        emailAlerts: notifEmail ? notifEmail.checked : undefined
    };

    try {
        const res = await fetch('/api/settings', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });

        const result = await res.json();

        if (res.ok && result.success) {
            const toastEl = document.getElementById('saveToast');
            const toast = new bootstrap.Toast(toastEl, { delay: 3000 });
            toast.show();
        } else {
            alert(result.message || 'บันทึกการตั้งค่าไม่สำเร็จ');
        }
    } catch (err) {
        console.error('Error saving settings:', err);
        alert('ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้');
    } finally {
        if (btn) {
            btn.innerHTML = originalHTML;
            btn.disabled = false;
        }
    }
}
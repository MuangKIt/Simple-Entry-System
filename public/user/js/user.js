// public/user/js/user.js

document.addEventListener("DOMContentLoaded", function() {
    // 1. อัปเดตเวลาและวันที่
    updateDateTime();
    setInterval(updateDateTime, 60000);

    // 2. ดึงข้อมูลผู้ใช้ปัจจุบันและข้อมูลแดชบอร์ด
    loadStaffProfile();
    loadStaffDashboard();

    // 3. จัดการการคลิกที่ปุ่มใน Bottom Nav (Visual effect)
    const navItems = document.querySelectorAll('.bottom-nav .nav-item:not(.scan-btn-wrapper)');
    navItems.forEach(item => {
        item.addEventListener('click', function() {
            navItems.forEach(nav => nav.classList.remove('active'));
            this.classList.add('active');
        });
    });

    // 4. ผูก Event ปุ่มทำรายการ
    const btnStockIn = document.querySelector('.bg-tile-green');
    const btnStockOut = document.querySelector('.bg-tile-orange');
    const btnScan = document.querySelector('.scan-btn');
    const btnCheckStock = document.querySelector('.btn-operation.bg-white');

    if (btnStockIn) {
        btnStockIn.addEventListener('click', () => {
            window.location.href = 'stock-in.html';
        });
    }

    if (btnStockOut) {
        btnStockOut.addEventListener('click', () => {
            window.location.href = 'stock-out.html';
        });
    }

    if (btnScan) {
        btnScan.addEventListener('click', () => {
            alert('โหมดสแกนบาร์โค้ดผ่านกล้อง (ฟังก์ชันจำลองสำหรับ Demo)');
        });
    }

    if (btnCheckStock) {
        btnCheckStock.addEventListener('click', () => {
            window.location.href = 'check-stock.html';
        });
    }
});

async function loadStaffProfile() {
    try {
        const res = await fetch('/api/auth/me');
        if (res.ok) {
            const result = await res.json();
            if (result.success && result.user) {
                const nameHeader = document.getElementById('userHeaderName') || document.querySelector('.app-header .fw-bold');
                if (nameHeader) {
                    nameHeader.innerText = `สวัสดี, ${result.user.name}`;
                }
                const avatarEl = document.getElementById('userHeaderAvatar') || document.querySelector('.app-header img');
                if (avatarEl && result.user.name) {
                    avatarEl.src = `https://ui-avatars.com/api/?name=${encodeURIComponent(result.user.name)}&background=4a6d8c&color=fff`;
                }
            }
        }
    } catch (err) {
        console.error('Error loading staff profile:', err);
    }
}

async function loadStaffDashboard() {
    try {
        const res = await fetch('/api/dashboard/staff');
        if (!res.ok) return;

        const result = await res.json();
        if (result.success && result.data) {
            const { todayStats, myLogs } = result.data;

            // อัปเดตตัวเลข In / Out วันนี้
            const statCards = document.querySelectorAll('.stat-card .fs-5');
            if (statCards.length >= 2) {
                statCards[0].innerText = todayStats.inCount;
                statCards[1].innerText = todayStats.outCount;
            }

            // อัปเดตรายการล่าสุด
            const logsContainer = document.querySelector('.recent-logs');
            if (logsContainer && myLogs) {
                logsContainer.innerHTML = '';
                
                if (myLogs.length === 0) {
                    const li = document.createElement('li');
                    li.className = 'list-group-item p-4 text-center text-muted';
                    li.innerHTML = 'ไม่มีรายการล่าสุด';
                    logsContainer.appendChild(li);
                } else {
                    myLogs.forEach(log => {
                        const isIn = log.type === 'in';
                        const timeAgo = formatTimeAgo(log.timestamp);
                        const li = document.createElement('li');
                        li.className = 'list-group-item p-2 d-flex align-items-center';
                        li.innerHTML = `
                            <div class="log-icon ${isIn ? 'bg-success bg-opacity-10 text-success' : 'bg-warning bg-opacity-10 text-warning-custom'} me-3">
                                <i class="bi ${isIn ? 'bi-plus-lg' : 'bi-dash-lg'}"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="fw-semibold text-dark" style="font-size: 0.8rem;">
                                    ${log.sku} <span class="text-muted fw-normal">${log.productName}</span>
                                </div>
                                <div class="text-muted" style="font-size: 0.65rem;">${timeAgo}</div>
                            </div>
                            <div class="fw-bold ${isIn ? 'text-success' : 'text-mute-orange'}" style="font-size: 0.85rem;">
                                ${isIn ? '+' : '-'}${log.qty}
                            </div>
                        `;
                        logsContainer.appendChild(li);
                    });
                }
            }
        }
    } catch (err) {
        console.error('Error loading staff dashboard:', err);
    }
}

function formatTimeAgo(timestamp) {
    if (!timestamp) return 'เมื่อสักครู่';
    const diff = (Date.now() - new Date(timestamp).getTime()) / 1000;
    if (diff < 60) return 'เมื่อสักครู่';
    if (diff < 3600) return `${Math.floor(diff / 60)} นาทีที่แล้ว`;
    if (diff < 86400) return `${Math.floor(diff / 3600)} ชั่วโมงที่แล้ว`;
    return `${Math.floor(diff / 86400)} วันที่แล้ว`;
}

function updateDateTime() {
    const dateElement = document.getElementById('currentDate');
    const timeElement = document.getElementById('currentTime');
    
    const now = new Date();
    const thaiMonths = [
        "ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.",
        "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."
    ];
    
    const day = now.getDate();
    const month = thaiMonths[now.getMonth()];
    const year = now.getFullYear();
    
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    
    if (dateElement) dateElement.innerText = `${day} ${month} ${year}`;
    if (timeElement) timeElement.innerText = `${hours}:${minutes}`;
}
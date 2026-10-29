// public/admin/js/admin.js

document.addEventListener("DOMContentLoaded", function() {
    loadAdminDashboard();

    // จัดการปุ่มออกจากระบบใน Dropdown
    const logoutLinks = document.querySelectorAll('a[href*="index.html"]');
    logoutLinks.forEach(link => {
        link.addEventListener('click', async (e) => {
            e.preventDefault();
            try {
                await fetch('/api/auth/logout', { method: 'POST' });
            } catch (err) {
                console.error(err);
            } finally {
                localStorage.clear();
                window.location.href = '/index.html';
            }
        });
    });
});

async function loadAdminDashboard() {
    try {
        const res = await fetch('/api/dashboard/admin');
        if (!res.ok) return;

        const result = await res.json();
        if (result.success && result.data) {
            const { tiles, reminders, topItems, recentActivities } = result.data;

            // 1. อัปเดต Tiles
            const tileValues = document.querySelectorAll('.tile-card .fs-5');
            if (tileValues.length >= 4) {
                tileValues[0].innerText = tiles.todayIn.toLocaleString();
                tileValues[1].innerText = tiles.todayOut.toLocaleString();
                tileValues[2].innerText = tiles.totalSku.toLocaleString();
                tileValues[3].innerText = tiles.lowStockCount.toLocaleString();
            }

            // 2. อัปเดต Reminders
            const reminderLowStock = document.querySelector('.reminder-list .text-danger');
            if (reminderLowStock) reminderLowStock.innerText = reminders.lowStockCount;

            const reminderStaff = document.querySelector('.reminder-list .text-warning');
            if (reminderStaff) reminderStaff.innerText = reminders.pendingStaff;

            // 3. อัปเดต Recent Activities
            if (recentActivities && recentActivities.length > 0) {
                const tbody = document.querySelector('.table-hover tbody');
                if (tbody) {
                    tbody.innerHTML = '';
                    recentActivities.forEach(item => {
                        const isIn = item.type === 'in';
                        const timeStr = new Date(item.timestamp).toLocaleTimeString('th-TH', { hour: '2-digit', minute: '2-digit' }) + ' น.';
                        const tr = document.createElement('tr');
                        tr.innerHTML = `
                            <td class="ps-3 text-muted">${timeStr}</td>
                            <td>
                                <span class="badge ${isIn ? 'badge-stock-in border' : 'badge-stock-out border'} px-2 py-1" style="font-size: 0.65rem;">
                                    ${isIn ? 'Stock In' : 'Stock Out'}
                                </span>
                            </td>
                            <td class="fw-semibold">${item.sku} (${item.productName})</td>
                            <td class="${isIn ? 'text-mute-green' : 'text-mute-orange'} fw-semibold">${isIn ? '+' : '-'}${item.qty}</td>
                            <td>${item.performedBy}</td>
                        `;
                        tbody.appendChild(tr);
                    });
                }
            }

            // 4. สร้างกราฟ
            initCharts(topItems);
        }
    } catch (err) {
        console.error('Error loading admin dashboard:', err);
    }
}

function initCharts(topItems) {
    // 1. กราฟ Monthly Inventory Trend (Bar Chart)
    const trendEl = document.getElementById('inventoryTrendChart');
    if (trendEl) {
        const trendCtx = trendEl.getContext('2d');
        const inventoryData = {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            datasets: [
                {
                    label: 'Stock In (รับเข้า)',
                    data: [1200, 1900, 3000, 2500, 2200, 3200, 3800, 3500, 4200, 150, 0, 0],
                    backgroundColor: 'rgba(84, 127, 97, 0.85)', // สีเขียวตุ่น
                    borderRadius: 2,
                    barPercentage: 0.6
                },
                {
                    label: 'Stock Out (เบิกจ่าย)',
                    data: [1000, 1500, 2000, 2800, 1800, 2900, 3400, 3100, 3900, 45, 0, 0],
                    backgroundColor: 'rgba(188, 108, 59, 0.85)', // สีส้มตุ่น
                    borderRadius: 2,
                    barPercentage: 0.6
                }
            ]
        };

        new Chart(trendCtx, {
            type: 'bar',
            data: inventoryData,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                        labels: {
                            font: { family: "'Sarabun', sans-serif", size: 10 },
                            boxWidth: 12,
                            usePointStyle: true
                        }
                    }
                },
                scales: {
                    x: { grid: { display: false }, ticks: { font: { size: 10 } } },
                    y: {
                        beginAtZero: true,
                        grid: { color: '#f0f4f7' },
                        ticks: {
                            font: { size: 10 },
                            callback: function(value) { return value.toLocaleString(); }
                        }
                    }
                }
            }
        });
    }

    // 2. กราฟ Top Items By Qty Sold (Doughnut Chart)
    const topItemsEl = document.getElementById('topItemsChart');
    if (topItemsEl) {
        const topItemsCtx = topItemsEl.getContext('2d');
        const labels = topItems ? topItems.map(i => i.name) : ['CPU Core i5', 'RAM 16GB', 'SSD 1TB', 'Mainboard', 'Power Supply'];
        const values = topItems ? topItems.map(i => i.qty) : [35, 25, 20, 12, 8];

        new Chart(topItemsCtx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    data: values,
                    backgroundColor: ['#4e79a7', '#bc6c3b', '#e15759', '#76b7b2', '#547f61'],
                    borderWidth: 0,
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '65%',
                plugins: {
                    legend: {
                        position: 'right',
                        labels: {
                            font: { family: "'Sarabun', sans-serif", size: 9 },
                            boxWidth: 8,
                            usePointStyle: true
                        }
                    }
                }
            }
        });
    }
}

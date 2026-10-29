// public/admin/js/reports.js

let transactionsData = [];
let currentReportsPage = 1;
const PAGE_SIZE = 10;

let stockSummaryData = null;

document.addEventListener("DOMContentLoaded", function() {
    toggleCustomDate();
    loadReports();

    // ==========================================
    // Tab 1: Transaction History Filters
    // ==========================================
    const searchInput = document.querySelector('input[placeholder*="ค้นหา รหัสอ้างอิง"]');
    const typeSelect = document.querySelector('#history-pane .card-header select:not(#dateRangeSelect)');
    const datePresetSelect = document.getElementById('dateRangeSelect');
    const customDateInputs = document.querySelectorAll('#customDateGroup input[type="date"]');

    if (searchInput) {
        searchInput.addEventListener('input', () => {
            currentReportsPage = 1;
            loadReports();
        });
    }

    if (typeSelect) {
        typeSelect.addEventListener('change', () => {
            currentReportsPage = 1;
            loadReports();
        });
    }

    if (datePresetSelect) {
        datePresetSelect.addEventListener('change', () => {
            toggleCustomDate();
            currentReportsPage = 1;
            loadReports();
        });
    }

    if (customDateInputs.length >= 2) {
        customDateInputs[0].addEventListener('change', () => {
            currentReportsPage = 1;
            loadReports();
        });
        customDateInputs[1].addEventListener('change', () => {
            currentReportsPage = 1;
            loadReports();
        });
    }

    // Export CSV สำหรับ Transaction History
    const exportTxnCsvBtn = document.getElementById('btnExportTransactionsCsv');
    if (exportTxnCsvBtn) {
        exportTxnCsvBtn.addEventListener('click', exportTransactionsToCsv);
    }

    // ==========================================
    // Tab 2: Stock Summary Listeners
    // ==========================================
    const summaryTabBtn = document.getElementById('summary-tab');
    if (summaryTabBtn) {
        summaryTabBtn.addEventListener('shown.bs.tab', () => {
            loadStockSummary();
        });
    }

    const summaryMonthSelect = document.getElementById('summaryMonthSelect');
    const summaryCategorySelect = document.getElementById('summaryCategorySelect');

    if (summaryMonthSelect) {
        summaryMonthSelect.addEventListener('change', loadStockSummary);
    }
    if (summaryCategorySelect) {
        summaryCategorySelect.addEventListener('change', loadStockSummary);
    }

    const exportSummaryCsvBtn = document.getElementById('btnExportSummaryCsv');
    if (exportSummaryCsvBtn) {
        exportSummaryCsvBtn.addEventListener('click', exportStockSummaryToCsv);
    }

    // ==========================================
    // Logout Action
    // ==========================================
    document.querySelectorAll('a[href*="index.html"]').forEach(link => {
        link.addEventListener('click', async (e) => {
            e.preventDefault();
            await fetch('/api/auth/logout', { method: 'POST' }).catch(() => {});
            localStorage.clear();
            window.location.href = '/index.html';
        });
    });
});

function toggleCustomDate() {
    const select = document.getElementById('dateRangeSelect');
    const customGroup = document.getElementById('customDateGroup');
    if (!select || !customGroup) return;
    
    if (select.value === 'custom') {
        customGroup.classList.remove('d-none');
        customGroup.classList.add('d-flex');
    } else {
        customGroup.classList.add('d-none');
        customGroup.classList.remove('d-flex');
    }
}

// ==========================================
// Tab 1 Logic: Transactions History
// ==========================================
async function loadReports() {
    const searchInput = document.querySelector('input[placeholder*="ค้นหา รหัสอ้างอิง"]');
    const typeSelect = document.querySelector('#history-pane .card-header select:not(#dateRangeSelect)');
    const datePresetSelect = document.getElementById('dateRangeSelect');
    const customDateInputs = document.querySelectorAll('#customDateGroup input[type="date"]');

    const params = new URLSearchParams();

    if (searchInput && searchInput.value.trim()) params.append('search', searchInput.value.trim());
    if (typeSelect && typeSelect.value) params.append('type', typeSelect.value);

    if (datePresetSelect) {
        if (datePresetSelect.value === 'custom') {
            if (customDateInputs[0].value) params.append('startDate', customDateInputs[0].value);
            if (customDateInputs[1].value) params.append('endDate', customDateInputs[1].value);
        } else {
            params.append('datePreset', datePresetSelect.value);
        }
    }

    try {
        const res = await fetch(`/api/reports/transactions?${params.toString()}`);
        if (!res.ok) return;

        const result = await res.json();
        if (result.success) {
            transactionsData = result.data || [];
            renderQuickStats(result.summary);
            renderTransactionsTable();
        }
    } catch (err) {
        console.error('Error loading reports:', err);
    }
}

function renderQuickStats(summary) {
    if (!summary) return;
    const statCards = document.querySelectorAll('#history-pane .card-body .fs-4');
    if (statCards.length >= 3) {
        statCards[0].innerHTML = `+${summary.totalIn.toLocaleString()} <span class="fs-6 fw-normal text-muted">ชิ้น</span>`;
        statCards[1].innerHTML = `-${summary.totalOut.toLocaleString()} <span class="fs-6 fw-normal text-muted">ชิ้น</span>`;
        statCards[2].innerHTML = `${summary.totalCount.toLocaleString()} <span class="fs-6 fw-normal text-muted">รายการ</span>`;
    }
}

function renderTransactionsTable() {
    const tbody = document.querySelector('#history-pane .master-data-table tbody');
    if (!tbody) return;

    tbody.innerHTML = '';

    const totalItems = transactionsData.length;
    const totalPages = Math.max(1, Math.ceil(totalItems / PAGE_SIZE));
    if (currentReportsPage > totalPages) {
        currentReportsPage = totalPages;
    }

    if (totalItems === 0) {
        tbody.innerHTML = `<tr><td colspan="7" class="text-center py-4 text-muted">ไม่พบประวัติรายการตามเงื่อนไขที่เลือก</td></tr>`;
        renderPaginationControls({
            paginationEl: '#reportsPagination',
            footerTextEl: '#reportsFooterText',
            totalItems: 0,
            currentPage: 1,
            pageSize: PAGE_SIZE,
            onPageChange: (newPage) => {
                currentReportsPage = newPage;
                renderTransactionsTable();
            }
        });
        return;
    }

    const startIndex = (currentReportsPage - 1) * PAGE_SIZE;
    const endIndex = Math.min(startIndex + PAGE_SIZE, totalItems);
    const pageItems = transactionsData.slice(startIndex, endIndex);

    pageItems.forEach(t => {
        const isIn = t.type === 'in';
        const dateStr = new Date(t.timestamp).toLocaleString('th-TH', { 
            day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' 
        }) + ' น.';

        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td class="ps-3 text-muted">${dateStr}</td>
            <td class="fw-semibold text-dark">
                <a href="/slip.html?refId=${encodeURIComponent(t.refId)}" target="_blank" class="text-dark-blue text-decoration-none fw-bold" title="ดูสลิป">
                    ${t.refId} <i class="bi bi-box-arrow-up-right text-muted" style="font-size: 0.7rem;"></i>
                </a>
            </td>
            <td class="text-center">
                <span class="badge ${isIn ? 'badge-stock-in border' : 'badge-stock-out border'} px-2 py-1">
                    ${isIn ? 'Stock In' : 'Stock Out'}
                </span>
            </td>
            <td>
                <div class="fw-semibold text-dark">${t.sku}</div>
                <div class="text-muted" style="font-size: 0.7rem;">${t.productName}</div>
            </td>
            <td class="text-end fw-bold ${isIn ? 'text-mute-green' : 'text-mute-orange'} fs-6">
                ${isIn ? '+' : '-'}${t.qty.toLocaleString()}
            </td>
            <td>${t.performedBy}</td>
            <td class="text-center pe-3">
                <button class="btn btn-sm btn-outline-secondary py-0 px-2 shadow-none" title="เปิดดูใบสำคัญ (PDF Slip)" onclick="window.open('/slip.html?refId=${encodeURIComponent(t.refId)}', '_blank')">
                    <i class="bi bi-file-earmark-pdf text-danger me-1"></i>สลิป
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });

    renderPaginationControls({
        paginationEl: '#reportsPagination',
        footerTextEl: '#reportsFooterText',
        totalItems: totalItems,
        currentPage: currentReportsPage,
        pageSize: PAGE_SIZE,
        onPageChange: (newPage) => {
            currentReportsPage = newPage;
            renderTransactionsTable();
        }
    });
}

function exportTransactionsToCsv() {
    if (!transactionsData || transactionsData.length === 0) {
        alert('ไม่มีข้อมูลสำหรับส่งออก');
        return;
    }

    const headers = ['วันที่เวลา', 'รหัสอ้างอิง (Ref ID)', 'ประเภท', 'รหัสสินค้า (SKU)', 'ชื่อสินค้า', 'จำนวน', 'ผู้ทำรายการ', 'หมายเหตุ'];
    const rows = transactionsData.map(t => [
        `"${new Date(t.timestamp).toLocaleString('th-TH')}"`,
        `"${t.refId}"`,
        `"${t.type === 'in' ? 'รับเข้า' : 'จ่ายออก'}"`,
        `"${t.sku}"`,
        `"${t.productName.replace(/"/g, '""')}"`,
        t.type === 'in' ? t.qty : -t.qty,
        `"${t.performedBy}"`,
        `"${(t.note || '-').replace(/"/g, '""')}"`
    ]);

    const csvContent = '\uFEFF' + [headers.join(','), ...rows.map(e => e.join(','))].join('\n');
    downloadBlob(csvContent, `Transaction_History_${new Date().toISOString().slice(0, 10)}.csv`, 'text/csv;charset=utf-8;');
}

// ==========================================
// Tab 2 Logic: Stock Summary Report
// ==========================================
async function loadStockSummary() {
    const monthSelect = document.getElementById('summaryMonthSelect');
    const categorySelect = document.getElementById('summaryCategorySelect');

    const params = new URLSearchParams();
    if (monthSelect && monthSelect.value) params.append('month', monthSelect.value);
    if (categorySelect && categorySelect.value) params.append('category', categorySelect.value);

    try {
        const res = await fetch(`/api/reports/stock-summary?${params.toString()}`);
        if (!res.ok) return;

        const result = await res.json();
        if (result.success && result.data) {
            stockSummaryData = result.data;
            renderStockSummary(stockSummaryData);
        }
    } catch (err) {
        console.error('Error loading stock summary:', err);
    }
}

function renderStockSummary(data) {
    const { kpis, categories, items } = data;

    // 1. Render 4 KPIs
    document.getElementById('kpiTotalStock').innerHTML = `${kpis.totalStock.toLocaleString()} <span class="fs-6 fw-normal text-muted">ชิ้น</span>`;
    document.getElementById('kpiPeriodIn').innerHTML = `+${kpis.totalIn.toLocaleString()} <span class="fs-6 fw-normal text-muted">ชิ้น</span>`;
    document.getElementById('kpiPeriodOut').innerHTML = `-${kpis.totalOut.toLocaleString()} <span class="fs-6 fw-normal text-muted">ชิ้น</span>`;
    document.getElementById('kpiLowStockCount').innerHTML = `${kpis.lowStockCount.toLocaleString()} <span class="fs-6 fw-normal text-muted">รายการ</span>`;

    // 2. Render Category Breakdown
    const catContainer = document.getElementById('categoryBreakdownContainer');
    if (catContainer) {
        if (!categories || categories.length === 0) {
            catContainer.innerHTML = `<div class="text-center text-muted small py-2">ไม่มีข้อมูลหมวดหมู่</div>`;
        } else {
            catContainer.innerHTML = '';
            const row = document.createElement('div');
            row.className = 'row g-3';

            categories.forEach(cat => {
                const totalActivity = cat.in + cat.out;
                const inPercent = totalActivity > 0 ? Math.round((cat.in / totalActivity) * 100) : 50;
                const outPercent = totalActivity > 0 ? Math.round((cat.out / totalActivity) * 100) : 50;

                const col = document.createElement('div');
                col.className = 'col-md-4';
                col.innerHTML = `
                    <div class="border rounded p-3 bg-light">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <strong class="text-dark-blue">${cat.category}</strong>
                            <span class="badge bg-secondary bg-opacity-10 text-dark">คงคลัง: ${cat.currentStock.toLocaleString()} ชิ้น</span>
                        </div>
                        <div class="d-flex justify-content-between small text-muted mb-2">
                            <span class="text-mute-green"><i class="bi bi-arrow-down-left"></i> เข้า: +${cat.in}</span>
                            <span class="text-mute-orange"><i class="bi bi-arrow-up-right"></i> ออก: -${cat.out}</span>
                        </div>
                        <div class="progress" style="height: 6px;">
                            <div class="progress-bar bg-mute-green" style="width: ${inPercent}%" title="รับเข้า ${inPercent}%"></div>
                            <div class="progress-bar bg-mute-orange" style="width: ${outPercent}%" title="จ่ายออก ${outPercent}%"></div>
                        </div>
                    </div>
                `;
                row.appendChild(col);
            });
            catContainer.appendChild(row);
        }
    }

    // 3. Render Movement Ledger Table
    const tbody = document.getElementById('summaryTableBody');
    const badgeTotal = document.getElementById('summaryTotalItemsBadge');

    if (badgeTotal) badgeTotal.innerText = `${items.length} รายการ`;

    if (!tbody) return;
    tbody.innerHTML = '';

    if (items.length === 0) {
        tbody.innerHTML = `<tr><td colspan="9" class="text-center py-4 text-muted">ไม่พบรายการสินค้าตามเงื่อนไขที่เลือก</td></tr>`;
        return;
    }

    items.forEach(item => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td class="ps-3 fw-bold text-dark">${item.sku}</td>
            <td>
                <div class="fw-semibold text-dark">${item.name}</div>
                <div class="text-muted" style="font-size: 0.7rem;">เกณฑ์เตือน: ${item.threshold} ชิ้น</div>
            </td>
            <td><span class="text-muted">${item.category}</span></td>
            <td class="text-end fw-semibold text-secondary">${item.beginningStock.toLocaleString()}</td>
            <td class="text-end fw-bold text-mute-green">+${item.totalIn.toLocaleString()}</td>
            <td class="text-end fw-bold text-mute-orange">-${item.totalOut.toLocaleString()}</td>
            <td class="text-end fw-bold fs-6 text-dark-blue">${item.currentStock.toLocaleString()}</td>
            <td class="text-center">
                <span class="status-badge ${item.statusBadge}">${item.statusText}</span>
            </td>
            <td class="text-center pe-3">
                <span class="badge ${item.activityBadge}" style="font-size: 0.72rem;">${item.activityText}</span>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function exportStockSummaryToCsv() {
    if (!stockSummaryData || !stockSummaryData.items || stockSummaryData.items.length === 0) {
        alert('ไม่มีข้อมูลสำหรับส่งออก');
        return;
    }

    const headers = ['รหัสสินค้า (SKU)', 'ชื่อสินค้า', 'หมวดหมู่', 'ยอดยกมา', 'รับเข้ารวม', 'จ่ายออกรวม', 'คงเหลือสิ้นงวด', 'เกณฑ์เตือน', 'สถานะสต็อก', 'ความเคลื่อนไหว'];
    const rows = stockSummaryData.items.map(item => [
        `"${item.sku}"`,
        `"${item.name.replace(/"/g, '""')}"`,
        `"${item.category}"`,
        item.beginningStock,
        item.totalIn,
        item.totalOut,
        item.currentStock,
        item.threshold,
        `"${item.statusText}"`,
        `"${item.activityText}"`
    ]);

    const csvContent = '\uFEFF' + [headers.join(','), ...rows.map(e => e.join(','))].join('\n');
    downloadBlob(csvContent, `Stock_Summary_${stockSummaryData.period || 'report'}.csv`, 'text/csv;charset=utf-8;');
}

function downloadBlob(content, filename, contentType) {
    const blob = new Blob([content], { type: contentType });
    const url = URL.createObjectURL(blob);
    const pom = document.createElement('a');
    pom.href = url;
    pom.setAttribute('download', filename);
    pom.click();
    URL.revokeObjectURL(url);
}

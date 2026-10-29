// public/admin/js/master-data.js

let productsData = [];
let filteredProducts = [];
let currentProductsPage = 1;
const PAGE_SIZE = 10;

document.addEventListener("DOMContentLoaded", function() {
    loadProducts();

    // ตัวค้นหาและตัวกรองหมวดหมู่
    const searchInput = document.querySelector('input[placeholder*="ค้นหา SKU"]');
    const categorySelect = document.querySelector('.card-header select');

    if (searchInput) {
        searchInput.addEventListener('input', () => {
            filterAndRender();
        });
    }

    if (categorySelect) {
        categorySelect.addEventListener('change', () => {
            filterAndRender();
        });
    }

    // จัดการการส่งฟอร์ม Modal
    const saveBtn = document.querySelector('#productModal .btn-primary-custom');
    if (saveBtn) {
        saveBtn.addEventListener('click', handleSaveProduct);
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

async function loadProducts() {
    try {
        const res = await fetch('/api/products');
        if (!res.ok) return;

        const result = await res.json();
        if (result.success && result.data) {
            productsData = result.data;
            filterAndRender();
            renderAlertCards(productsData);
        }
    } catch (err) {
        console.error('Error loading products:', err);
    }
}

function filterAndRender() {
    const searchInput = document.querySelector('input[placeholder*="ค้นหา SKU"]');
    const categorySelect = document.querySelector('.card-header select');

    const searchVal = searchInput ? searchInput.value.trim().toLowerCase() : '';
    const catVal = categorySelect ? categorySelect.value.trim().toLowerCase() : '';

    filteredProducts = productsData.filter(p => {
        const matchesSearch = !searchVal || 
            p.sku.toLowerCase().includes(searchVal) || 
            p.name.toLowerCase().includes(searchVal);
        const matchesCat = !catVal || p.category.toLowerCase() === catVal;
        return matchesSearch && matchesCat;
    });

    currentProductsPage = 1; // เมื่อค้นหาหรือกรอง ให้รีเซ็ตกลับไปหน้า 1 เสมอ
    renderTable();
}

function renderTable() {
    const tbody = document.querySelector('.master-data-table tbody');
    if (!tbody) return;

    tbody.innerHTML = '';

    const totalItems = filteredProducts.length;
    const totalPages = Math.max(1, Math.ceil(totalItems / PAGE_SIZE));
    if (currentProductsPage > totalPages) {
        currentProductsPage = totalPages;
    }

    if (totalItems === 0) {
        tbody.innerHTML = `<tr><td colspan="7" class="text-center py-4 text-muted">ไม่พบข้อมูลสินค้าที่ค้นหา</td></tr>`;
        renderPaginationControls({
            paginationEl: '#masterDataPagination',
            footerTextEl: '#masterDataFooterText',
            totalItems: 0,
            currentPage: 1,
            pageSize: PAGE_SIZE,
            onPageChange: (newPage) => {
                currentProductsPage = newPage;
                renderTable();
            }
        });
        return;
    }

    const startIndex = (currentProductsPage - 1) * PAGE_SIZE;
    const endIndex = Math.min(startIndex + PAGE_SIZE, totalItems);
    const pageItems = filteredProducts.slice(startIndex, endIndex);

    pageItems.forEach(p => {
        let statusBadge = '<span class="status-badge status-normal">In Stock</span>';
        let stockClass = 'fw-semibold';

        if (p.stock === 0) {
            statusBadge = '<span class="status-badge status-out">Out of Stock</span>';
            stockClass = 'fw-semibold text-danger';
        } else if (p.stock <= p.threshold) {
            statusBadge = '<span class="status-badge status-low">Low Stock</span>';
            stockClass = 'fw-semibold text-warning-custom';
        }

        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td class="ps-3"><input class="form-check-input" type="checkbox"></td>
            <td class="fw-bold text-dark">${p.sku}</td>
            <td>${p.name}</td>
            <td><span class="text-muted">${p.category}</span></td>
            <td class="text-end ${stockClass}">${p.stock.toLocaleString()}</td>
            <td class="text-center">${statusBadge}</td>
            <td class="text-center pe-3">
                <button class="btn btn-sm btn-icon text-primary" title="แก้ไข" onclick="prepareEditForm('${p.sku}')" data-bs-toggle="modal" data-bs-target="#productModal">
                    <i class="bi bi-pencil-square"></i>
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });

    renderPaginationControls({
        paginationEl: '#masterDataPagination',
        footerTextEl: '#masterDataFooterText',
        totalItems: totalItems,
        currentPage: currentProductsPage,
        pageSize: PAGE_SIZE,
        onPageChange: (newPage) => {
            currentProductsPage = newPage;
            renderTable();
        }
    });
}

function renderAlertCards(products) {
    // 1. สินค้าหมด (Out of Stock)
    const outItems = products.filter(p => p.stock === 0);
    const outList = document.querySelector('.border-danger .reminder-list');
    if (outList) {
        outList.innerHTML = '';
        if (outItems.length === 0) {
            outList.innerHTML = `<li class="list-group-item text-muted text-center border-0 py-2" style="font-size: 0.75rem;">ไม่มีสินค้าหมด</li>`;
        } else {
            outItems.forEach(item => {
                const li = document.createElement('li');
                li.className = 'list-group-item d-flex justify-content-between align-items-center border-0 px-1 py-1';
                li.innerHTML = `
                    <div class="me-auto text-truncate">
                        <div class="fw-semibold text-dark" style="font-size: 0.75rem;">${item.sku}</div>
                        <div class="text-muted text-truncate" style="font-size: 0.7rem; max-width: 150px;">${item.name}</div>
                    </div>
                    <span class="badge bg-danger bg-opacity-10 text-danger border border-danger px-2 py-1" style="font-size: 0.65rem;">0</span>
                `;
                outList.appendChild(li);
            });
        }
    }

    // 2. สินค้าใกล้หมด (Low Stock)
    const lowItems = products.filter(p => p.stock > 0 && p.stock <= p.threshold);
    const lowList = document.querySelector('.border-warning .reminder-list');
    if (lowList) {
        lowList.innerHTML = '';
        if (lowItems.length === 0) {
            lowList.innerHTML = `<li class="list-group-item text-muted text-center border-0 py-2" style="font-size: 0.75rem;">ไม่มีสินค้าใกล้หมด</li>`;
        } else {
            lowItems.forEach(item => {
                const li = document.createElement('li');
                li.className = 'list-group-item d-flex justify-content-between align-items-center border-0 px-1 py-1';
                li.innerHTML = `
                    <div class="me-auto text-truncate">
                        <div class="fw-semibold text-dark" style="font-size: 0.75rem;">${item.sku}</div>
                        <div class="text-muted text-truncate" style="font-size: 0.7rem; max-width: 150px;">${item.name}</div>
                    </div>
                    <div class="text-end">
                        <div class="fw-bold text-warning-custom" style="font-size: 0.8rem;">${item.stock}</div>
                        <div class="text-muted" style="font-size: 0.65rem;">เกณฑ์: ${item.threshold}</div>
                    </div>
                `;
                lowList.appendChild(li);
            });
        }
    }
}

function prepareAddForm() {
    document.getElementById('productModalLabel').innerText = 'เพิ่มสินค้าใหม่';
    document.getElementById('productForm').reset();
    
    document.getElementById('modalSku').readOnly = false;
    document.getElementById('initialStockGroup').style.display = 'block';
}

async function prepareEditForm(sku) {
    document.getElementById('productModalLabel').innerText = 'แก้ไขข้อมูลสินค้า';
    
    document.getElementById('modalSku').value = sku;
    document.getElementById('modalSku').readOnly = true;
    document.getElementById('initialStockGroup').style.display = 'none';

    try {
        const res = await fetch(`/api/products/${encodeURIComponent(sku)}`);
        if (res.ok) {
            const result = await res.json();
            if (result.success && result.data) {
                const p = result.data;
                document.getElementById('modalName').value = p.name;
                document.getElementById('modalCategory').value = p.category;
                document.getElementById('modalThreshold').value = p.threshold;
            }
        }
    } catch (err) {
        console.error('Error fetching product for edit:', err);
    }
}

async function handleSaveProduct() {
    const sku = document.getElementById('modalSku').value.trim();
    const name = document.getElementById('modalName').value.trim();
    const category = document.getElementById('modalCategory').value;
    const threshold = document.getElementById('modalThreshold').value;
    const isEdit = document.getElementById('modalSku').readOnly;

    if (!sku || !name) {
        alert('กรุณากรอกรหัสสินค้าและชื่อสินค้าให้ครบถ้วน');
        return;
    }

    try {
        let res;
        if (isEdit) {
            res = await fetch(`/api/products/${encodeURIComponent(sku)}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ name, category, threshold })
            });
        } else {
            const initialStock = document.getElementById('modalStock').value;
            res = await fetch('/api/products', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ sku, name, category, threshold, initialStock })
            });
        }

        const result = await res.json();
        if (res.ok && result.success) {
            // ปิด Modal
            const modalEl = document.getElementById('productModal');
            const modal = bootstrap.Modal.getInstance(modalEl);
            if (modal) modal.hide();

            loadProducts();
        } else {
            alert(result.message || 'บันทึกข้อมูลไม่สำเร็จ');
        }
    } catch (err) {
        console.error('Error saving product:', err);
        alert('ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้');
    }
}

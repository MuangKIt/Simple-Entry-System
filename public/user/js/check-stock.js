// public/user/js/check-stock.js

let products = [];
let selectedCategory = '';
let selectedStatus = '';
let targetSku = '';

document.addEventListener("DOMContentLoaded", function() {
    // 1. อ่าน URL Query Parameters (เช่น ?sku=SKU-001)
    const urlParams = new URLSearchParams(window.location.search);
    const skuParam = urlParams.get('sku');
    if (skuParam) {
        targetSku = skuParam.trim().toUpperCase();
        const searchInput = document.getElementById('searchInput');
        if (searchInput) searchInput.value = targetSku;
    }

    // 2. โหลดรายการสินค้า
    loadProducts();

    // 3. ผูก Event ช่องค้นหา
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('input', () => {
            targetSku = ''; // ยกเลิกการล็อกเป้าหมายเฉพาะถ้าผู้ใช้พิมพ์ค้นหาเอง
            renderFilteredProducts();
        });
    }

    // 4. ผูก Event ตัวกรองหมวดหมู่
    const catChips = document.querySelectorAll('#categoryChips .filter-chip');
    catChips.forEach(chip => {
        chip.addEventListener('click', function() {
            catChips.forEach(c => c.classList.remove('active'));
            this.classList.add('active');
            selectedCategory = this.getAttribute('data-cat') || '';
            renderFilteredProducts();
        });
    });

    // 5. ผูก Event ตัวกรองสถานะ
    const statusChips = document.querySelectorAll('#statusChips .filter-chip');
    statusChips.forEach(chip => {
        chip.addEventListener('click', function() {
            statusChips.forEach(c => c.classList.remove('active'));
            this.classList.add('active');
            selectedStatus = this.getAttribute('data-status') || '';
            renderFilteredProducts();
        });
    });

    // 6. ปุ่มรีเฟรช
    const btnRefresh = document.getElementById('btnRefresh');
    if (btnRefresh) {
        btnRefresh.addEventListener('click', () => {
            btnRefresh.classList.add('rotate-anim');
            loadProducts().then(() => {
                setTimeout(() => btnRefresh.classList.remove('rotate-anim'), 600);
            });
        });
    }

    // 7. ปุ่มสแกนบาร์โค้ด (Dummy ตามสเปก)
    const scanBtn = document.getElementById('scanBtn');
    if (scanBtn) {
        scanBtn.addEventListener('click', () => {
            const sampleSkus = ['SKU-001', 'SKU-042', 'SKU-110', 'SKU-205'];
            const randomSku = sampleSkus[Math.floor(Math.random() * sampleSkus.length)];
            searchInput.value = randomSku;
            targetSku = randomSku;
            renderFilteredProducts();
        });
    }
});

async function loadProducts() {
    try {
        const res = await fetch('/api/products');
        if (!res.ok) throw new Error('Failed to fetch');

        const result = await res.json();
        if (result.success && result.data) {
            products = result.data;
            renderFilteredProducts();
            updateLastModified();
        }
    } catch (err) {
        console.error('Error loading products:', err);
        const list = document.getElementById('stockCardList');
        if (list) {
            list.innerHTML = `
                <div class="empty-state">
                    <i class="bi bi-wifi-off"></i>
                    <div>ไม่สามารถโหลดข้อมูลสินค้าได้</div>
                    <button class="btn btn-sm btn-outline-secondary mt-2" onclick="loadProducts()">ลองใหม่อีกครั้ง</button>
                </div>
            `;
        }
    }
}

function renderFilteredProducts() {
    const searchInput = document.getElementById('searchInput');
    const q = searchInput ? searchInput.value.trim().toLowerCase() : '';

    let filtered = products.filter(p => {
        const matchesQuery = !q || p.sku.toLowerCase().includes(q) || p.name.toLowerCase().includes(q);
        const matchesCat = !selectedCategory || p.category.toLowerCase() === selectedCategory.toLowerCase();
        const matchesStatus = !selectedStatus || p.status.toLowerCase() === selectedStatus.toLowerCase();
        return matchesQuery && matchesCat && matchesStatus;
    });

    const resultCountEl = document.getElementById('resultCount');
    if (resultCountEl) {
        resultCountEl.innerText = `พบทั้งหมด ${filtered.length} รายการ`;
    }

    const list = document.getElementById('stockCardList');
    if (!list) return;

    list.innerHTML = '';

    if (filtered.length === 0) {
        list.innerHTML = `
            <div class="empty-state">
                <i class="bi bi-inbox"></i>
                <div class="fw-semibold">ไม่พบข้อมูลสินค้าที่ตรงกับเงื่อนไข</div>
                <div class="small text-muted mt-1">ลองเปลี่ยนคำค้นหาหรือตัวกรอง</div>
            </div>
        `;
        return;
    }

    filtered.forEach(p => {
        let badgeClass = 'badge-in-stock';
        let statusText = 'มีสินค้า';
        let stockColor = 'text-dark';

        if (p.stock === 0) {
            badgeClass = 'badge-out-stock';
            statusText = 'สินค้าหมด';
            stockColor = 'text-danger';
        } else if (p.stock <= p.threshold) {
            badgeClass = 'badge-low-stock';
            statusText = 'ใกล้หมด';
            stockColor = 'text-warning-custom';
        }

        const isHighlighted = targetSku && p.sku.toUpperCase() === targetSku;

        const card = document.createElement('div');
        card.className = `card stock-card p-3 ${isHighlighted ? 'highlighted' : ''}`;
        card.id = `card-${p.sku}`;

        card.innerHTML = `
            <div class="d-flex justify-content-between align-items-start mb-2">
                <span class="badge bg-light text-secondary border" style="font-size: 0.7rem;">${p.category}</span>
                <span class="badge ${badgeClass}" style="font-size: 0.7rem;">${statusText}</span>
            </div>
            
            <h6 class="fw-bold text-dark-blue mb-1" style="font-size: 0.95rem;">${p.sku}</h6>
            <div class="text-muted mb-3" style="font-size: 0.8rem; line-height: 1.3;">${p.name}</div>
            
            <div class="bg-light rounded-3 p-2 d-flex justify-content-between align-items-center mb-3">
                <div>
                    <span class="text-muted d-block" style="font-size: 0.65rem;">ยอดคงเหลือปัจจุบัน</span>
                    <span class="fw-bold fs-5 ${stockColor}">${p.stock.toLocaleString()} <small class="fw-normal text-muted" style="font-size: 0.75rem;">ชิ้น</small></span>
                </div>
                <div class="text-end">
                    <span class="text-muted d-block" style="font-size: 0.65rem;">เกณฑ์เตือนขั้นต่ำ</span>
                    <span class="fw-semibold text-muted" style="font-size: 0.8rem;">${p.threshold} ชิ้น</span>
                </div>
            </div>

            <!-- ปุ่มลัดรับเข้า / จ่ายออก ส่ง SKU ไปหน้าทำรายการทันที -->
            <div class="row g-2">
                <div class="col-6">
                    <a href="stock-in.html?sku=${encodeURIComponent(p.sku)}" class="card-action-btn btn-card-in w-100">
                        <i class="bi bi-box-arrow-in-down"></i> รับเข้า (+In)
                    </a>
                </div>
                <div class="col-6">
                    <a href="stock-out.html?sku=${encodeURIComponent(p.sku)}" class="card-action-btn btn-card-out w-100 ${p.stock === 0 ? 'disabled' : ''}">
                        <i class="bi bi-box-arrow-up"></i> จ่ายออก (-Out)
                    </a>
                </div>
            </div>
        `;

        list.appendChild(card);
    });

    // หากมี targetSku ให้เลื่อนหน้าจอมาที่การ์ดนั้น
    if (targetSku) {
        setTimeout(() => {
            const targetEl = document.getElementById(`card-${targetSku}`);
            if (targetEl) {
                targetEl.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }, 150);
    }
}

function updateLastModified() {
    const textEl = document.getElementById('lastUpdateText');
    if (!textEl) return;
    const now = new Date();
    const timeStr = now.toLocaleTimeString('th-TH', { hour: '2-digit', minute: '2-digit' });
    textEl.innerText = `อัปเดต: ${timeStr} น.`;
}

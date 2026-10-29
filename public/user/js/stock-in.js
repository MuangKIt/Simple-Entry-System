// public/user/js/stock-in.js
document.addEventListener("DOMContentLoaded", function() {
    const skuInput = document.getElementById('skuInput');
    const skuFeedback = document.getElementById('skuFeedback');
    const productPreviewWrapper = document.getElementById('productPreviewWrapper');
    const quantitySection = document.getElementById('quantitySection');
    const btnSubmit = document.getElementById('btnSubmit');
    const qtyInput = document.getElementById('qtyInput');
    const btnMinus = document.getElementById('btnMinus');
    const btnPlus = document.getElementById('btnPlus');
    const noteInput = document.querySelector('input[placeholder*="PO-1234"]');
    const scanBtn = document.getElementById('scanBtn');

    let debounceTimer = null;
    let currentProduct = null;

    // 1. อ่าน URL Parameter ถ้าส่ง ?sku=... มาจากหน้า Check Stock
    const urlParams = new URLSearchParams(window.location.search);
    const skuParam = urlParams.get('sku');
    if (skuParam) {
        skuInput.value = skuParam.trim().toUpperCase();
        checkSku(skuParam.trim().toUpperCase());
    }

    // ปุ่มสแกนบาร์โค้ด (Dummy ตามสเปก)
    if (scanBtn) {
        scanBtn.addEventListener('click', () => {
            skuInput.value = 'SKU-001';
            checkSku('SKU-001');
        });
    }

    // ตรวจจับการพิมพ์ในช่อง SKU
    skuInput.addEventListener('input', function() {
        const value = this.value.toUpperCase();
        this.value = value;

        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(() => {
            checkSku(value);
        }, 300);
    });

    async function checkSku(sku) {
        if (!sku || sku.length < 5) {
            hidePreview();
            lockForm();
            return;
        }

        try {
            const res = await fetch(`/api/products/${encodeURIComponent(sku)}`);
            const data = await res.json();

            if (res.ok && data.success && data.data) {
                currentProduct = data.data;
                document.getElementById('previewSku').innerText = currentProduct.sku;
                document.getElementById('previewName').innerText = currentProduct.name;
                document.getElementById('previewCategory').innerText = currentProduct.category;
                document.getElementById('previewCurrentStock').innerText = currentProduct.stock;

                productPreviewWrapper.classList.remove('d-none');
                skuFeedback.classList.add('d-none');

                // ปลดล็อกการกรอกจำนวน
                quantitySection.style.opacity = '1';
                quantitySection.style.pointerEvents = 'auto';
                btnSubmit.classList.remove('disabled');

                setTimeout(() => {
                    qtyInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }, 100);
            } else {
                currentProduct = null;
                hidePreview();
                skuFeedback.innerText = 'ไม่พบรหัสสินค้านี้ในระบบ';
                skuFeedback.classList.remove('d-none');
                lockForm();
            }
        } catch (err) {
            console.error('Error fetching product:', err);
            hidePreview();
            lockForm();
        }
    }

    function hidePreview() {
        productPreviewWrapper.classList.add('d-none');
        skuFeedback.classList.add('d-none');
    }

    function lockForm() {
        quantitySection.style.opacity = '0.4';
        quantitySection.style.pointerEvents = 'none';
        btnSubmit.classList.add('disabled');
        qtyInput.value = 1;
    }

    // จัดการปุ่มบวกลบ
    btnMinus.addEventListener('click', () => {
        let currentVal = parseInt(qtyInput.value) || 1;
        if (currentVal > 1) qtyInput.value = currentVal - 1;
    });

    btnPlus.addEventListener('click', () => {
        let currentVal = parseInt(qtyInput.value) || 0;
        qtyInput.value = currentVal + 1;
    });

    // จัดการปุ่มบันทึกรับเข้า (Stock In)
    btnSubmit.addEventListener('click', async () => {
        const sku = skuInput.value.trim().toUpperCase();
        const qty = parseInt(qtyInput.value) || 0;
        const note = noteInput ? noteInput.value.trim() : '';

        if (!sku || qty <= 0) return;

        const originalText = btnSubmit.innerHTML;
        btnSubmit.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>กำลังบันทึก...';
        btnSubmit.classList.add('disabled');

        try {
            const response = await fetch('/api/stock/in', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ sku, qty, note })
            });

            // จำลองเวลาโหลดเพื่อให้ผู้ใช้เห็น Spinner ชัดเจนขึ้น (UX)
            await new Promise(r => setTimeout(r, 600));

            const result = await response.json();

            btnSubmit.innerHTML = originalText;
            btnSubmit.classList.remove('disabled');

            if (response.ok && result.success) {
                // แสดง Modal พร้อมปุ่มไปหน้าเช็คสต็อก
                const updatedStock = result.data.updatedStock;
                const prodName = currentProduct ? currentProduct.name : '';
                const trx = result.data.transaction;

                // อัปเดตข้อมูลใน Success Modal
                document.getElementById('modalRefId').innerText = `#${trx.refId}`;
                document.getElementById('modalTimestamp').innerText = new Date(trx.timestamp).toLocaleString('th-TH');
                document.getElementById('modalProductText').innerText = `${sku} (${prodName})`;
                document.getElementById('modalQtyText').innerText = `+${qty.toLocaleString()} ชิ้น`;
                document.getElementById('modalUpdatedStock').innerText = `${updatedStock.toLocaleString()} ชิ้น`;
                
                // ผูกปุ่มดูสลิป
                const btnViewSlip = document.getElementById('btnViewSlip');
                if (btnViewSlip) {
                    btnViewSlip.onclick = () => {
                        window.open(`/slip.html?refId=${encodeURIComponent(trx.refId)}`, '_blank');
                    };
                }

                // ผูกปุ่มไปหน้า Check Stock
                const btnGoCheckStock = document.getElementById('btnGoCheckStock');
                if (btnGoCheckStock) {
                    btnGoCheckStock.href = `check-stock.html?sku=${encodeURIComponent(sku)}`;
                }

                const modalEl = document.getElementById('successModal');
                const modal = new bootstrap.Modal(modalEl);
                modal.show();

                // เมื่อปิด modal ให้เคลียร์ฟอร์ม
                modalEl.addEventListener('hidden.bs.modal', function onHidden() {
                    skuInput.value = '';
                    if (noteInput) noteInput.value = '';
                    hidePreview();
                    lockForm();
                    window.scrollTo({ top: 0, behavior: 'smooth' });
                    modalEl.removeEventListener('hidden.bs.modal', onHidden);
                });

            } else {
                alert(result.message || 'เกิดข้อผิดพลาดในการบันทึกรับเข้า');
            }
        } catch (err) {
            console.error('Error submitting stock in:', err);
            btnSubmit.innerHTML = originalText;
            btnSubmit.classList.remove('disabled');
            alert('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้');
        }
    });
});

function addQty(amount) {
    const qtyInput = document.getElementById('qtyInput');
    if (!qtyInput) return;
    let currentVal = parseInt(qtyInput.value) || 0;
    qtyInput.value = currentVal + amount;
}

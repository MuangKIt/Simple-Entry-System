// public/admin/js/admin-common.js

document.addEventListener('DOMContentLoaded', () => {
    const nameElement = document.getElementById('adminProfileName');
    const avatarElement = document.getElementById('adminProfileAvatar');
    let roleElement = document.getElementById('adminProfileRole');

    if (!nameElement && !avatarElement) return;

    try {
        const currentUser = JSON.parse(localStorage.getItem('currentUser') || 'null');
        const storedRole = localStorage.getItem('role') || (currentUser && currentUser.role);

        // จัดการชื่อและ Avatar
        if (currentUser && typeof currentUser.name === 'string' && currentUser.name.trim()) {
            const name = currentUser.name.trim().replace(/^นาย\s*/, '').split(/\s+/)[0];
            if (nameElement) nameElement.textContent = name;
            if (avatarElement) {
                avatarElement.src = `https://ui-avatars.com/api/?name=${encodeURIComponent(name)}&background=243f5a&color=fff`;
            }
        }

        // จัดการ Role ให้เป็นรูปแบบภาษาไทยควบคู่อังกฤษสไตล์ Enterprise
        const formatRole = (r) => {
            if (!r) return 'ผู้ดูแลระบบ (Admin)';
            const lower = String(r).toLowerCase();
            if (lower === 'admin') return 'ผู้ดูแลระบบ (Admin)';
            if (lower === 'staff') return 'เจ้าหน้าที่คลัง (Staff)';
            return r.charAt(0).toUpperCase() + r.slice(1);
        };

        const roleText = formatRole(storedRole);

        if (roleElement) {
            roleElement.textContent = roleText;
        } else if (nameElement) {
            // กรณีโครงสร้าง HTML ยังไม่มี container 2 บรรทัด ให้แปลงแบบ Dynamic
            const parent = nameElement.parentNode;
            const container = document.createElement('div');
            container.className = 'admin-profile-info';

            parent.insertBefore(container, nameElement);
            nameElement.className = 'admin-profile-name';
            container.appendChild(nameElement);

            roleElement = document.createElement('span');
            roleElement.id = 'adminProfileRole';
            roleElement.className = 'admin-profile-role';
            roleElement.textContent = roleText;
            container.appendChild(roleElement);
        }
    } catch (error) {
        console.error('Error loading admin profile:', error);
    }
});

/**
 * ฟังก์ชันสร้างและจัดการ Pagination รวมทั้งแสดงข้อความสรุปหน้า
 * @param {Object} options
 * @param {string|HTMLElement} options.paginationEl - Element หรือ selector ของ <ul> pagination
 * @param {string|HTMLElement} options.footerTextEl - Element หรือ selector ของ <span> แสดงจำนวนรายการ
 * @param {number} options.totalItems - จำนวนรายการทั้งหมดหลังผ่าน filter
 * @param {number} options.currentPage - หน้าปัจจุบัน (เริ่มที่ 1)
 * @param {number} [options.pageSize=10] - จำนวนรายการต่อหน้า (ค่าเริ่มต้น 10)
 * @param {Function} options.onPageChange - ฟังก์ชัน callback เมื่อกดเปลี่ยนหน้า (รับ page เป็น argument)
 */
function renderPaginationControls({ paginationEl, footerTextEl, totalItems, currentPage, pageSize = 10, onPageChange }) {
    const pEl = typeof paginationEl === 'string' ? document.querySelector(paginationEl) : paginationEl;
    const fEl = typeof footerTextEl === 'string' ? document.querySelector(footerTextEl) : footerTextEl;

    const totalPages = Math.max(1, Math.ceil(totalItems / pageSize));
    const safeCurrentPage = Math.min(Math.max(1, currentPage), totalPages);

    // อัปเดตข้อความ Footer
    if (fEl) {
        if (totalItems === 0) {
            fEl.innerText = 'แสดง 0 จาก 0 รายการ';
        } else {
            const start = (safeCurrentPage - 1) * pageSize + 1;
            const end = Math.min(safeCurrentPage * pageSize, totalItems);
            fEl.innerText = `แสดง ${start.toLocaleString()} ถึง ${end.toLocaleString()} จาก ${totalItems.toLocaleString()} รายการ (หน้า ${safeCurrentPage}/${totalPages})`;
        }
    }

    if (!pEl) return;
    pEl.innerHTML = '';

    if (totalItems === 0) return;

    // Helper สร้างปุ่ม Page Item
    const createItem = (label, targetPage, disabled = false, active = false) => {
        const li = document.createElement('li');
        li.className = `page-item ${disabled ? 'disabled' : ''} ${active ? 'active' : ''}`;

        if (disabled || active || targetPage === null) {
            const span = document.createElement('span');
            span.className = 'page-link shadow-none';
            span.innerText = label;
            li.appendChild(span);
        } else {
            const a = document.createElement('a');
            a.className = 'page-link shadow-none';
            a.href = 'javascript:void(0)';
            a.innerText = label;
            a.addEventListener('click', (e) => {
                e.preventDefault();
                if (typeof onPageChange === 'function') {
                    onPageChange(targetPage);
                }
            });
            li.appendChild(a);
        }
        return li;
    };

    // ปุ่ม "ก่อนหน้า" (Previous)
    const prevDisabled = safeCurrentPage <= 1;
    pEl.appendChild(createItem('ก่อนหน้า', safeCurrentPage - 1, prevDisabled));

    // รายการหมายเลขหน้า
    let pages = [];
    if (totalPages <= 7) {
        pages = Array.from({ length: totalPages }, (_, i) => i + 1);
    } else {
        if (safeCurrentPage <= 4) {
            pages = [1, 2, 3, 4, 5, '...', totalPages];
        } else if (safeCurrentPage >= totalPages - 3) {
            pages = [1, '...', totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
        } else {
            pages = [1, '...', safeCurrentPage - 1, safeCurrentPage, safeCurrentPage + 1, '...', totalPages];
        }
    }

    pages.forEach(p => {
        if (p === '...') {
            pEl.appendChild(createItem('...', null, true));
        } else {
            pEl.appendChild(createItem(p.toString(), p, false, p === safeCurrentPage));
        }
    });

    // ปุ่ม "ถัดไป" (Next)
    const nextDisabled = safeCurrentPage >= totalPages;
    pEl.appendChild(createItem('ถัดไป', safeCurrentPage + 1, nextDisabled));
}

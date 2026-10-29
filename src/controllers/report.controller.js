// src/controllers/report.controller.js
const { readData } = require('../utils/db');

const getTransactions = (req, res) => {
    const db = readData();
    let txns = [...db.transactions];

    const { type, search, startDate, endDate, datePreset } = req.query;

    // กรองประเภท In / Out
    if (type && type !== '') {
        txns = txns.filter(t => t.type.toLowerCase() === type.toLowerCase());
    }

    // กรองข้อความค้นหา (Ref ID, SKU, ผู้ทำรายการ)
    if (search && search.trim() !== '') {
        const q = search.trim().toLowerCase();
        txns = txns.filter(t => 
            t.refId.toLowerCase().includes(q) ||
            t.sku.toLowerCase().includes(q) ||
            t.productName.toLowerCase().includes(q) ||
            t.performedBy.toLowerCase().includes(q)
        );
    }

    // กรองตามวันเวลา
    if (startDate && endDate) {
        const start = new Date(startDate);
        const end = new Date(endDate);
        end.setHours(23, 59, 59, 999);
        txns = txns.filter(t => {
            const time = new Date(t.timestamp);
            return time >= start && time <= end;
        });
    } else if (datePreset) {
        const now = new Date();
        if (datePreset === 'today') {
            const todayStr = now.toISOString().slice(0, 10);
            txns = txns.filter(t => t.timestamp.startsWith(todayStr));
        } else if (datePreset === 'month') {
            const m = now.getMonth();
            const y = now.getFullYear();
            txns = txns.filter(t => {
                const d = new Date(t.timestamp);
                return d.getMonth() === m && d.getFullYear() === y;
            });
        }
    }

    // คำนวณยอดสรุป (Quick Stats)
    const allTxns = db.transactions;
    const totalIn = allTxns.filter(t => t.type === 'in').reduce((sum, t) => sum + t.qty, 0);
    const totalOut = allTxns.filter(t => t.type === 'out').reduce((sum, t) => sum + t.qty, 0);
    const totalCount = allTxns.length;

    res.json({
        success: true,
        summary: {
            totalIn,
            totalOut,
            totalCount
        },
        data: txns
    });
};

const getTransactionDetail = (req, res) => {
    const { refId } = req.params;
    const db = readData();

    const txn = (db.transactions || []).find(t => t.refId.toUpperCase() === refId.trim().toUpperCase());
    if (!txn) {
        return res.status(404).json({ success: false, message: `ไม่พบรายการรหัส ${refId}` });
    }

    const product = (db.products || []).find(p => p.sku.toUpperCase() === txn.sku.toUpperCase());

    res.json({
        success: true,
        data: {
            transaction: txn,
            product: product || { sku: txn.sku, name: txn.productName, category: '-' },
            settings: db.settings || { orgName: 'สถาบันเทคโนโลยีไทย-ญี่ปุ่น', systemName: 'Simple Entry System' }
        }
    });
};

const getStockSummary = (req, res) => {
    const db = readData();
    const { month, category } = req.query;

    const now = new Date();
    const targetMonthStr = month || `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
    const [targetYear, targetMonth] = targetMonthStr.split('-').map(Number);

    // กรอง Transaction เฉพาะเดือนที่เลือก
    const monthTxns = (db.transactions || []).filter(t => {
        if (!t.timestamp) return false;
        const d = new Date(t.timestamp);
        if (isNaN(d.getTime())) return false;
        return d.getFullYear() === targetYear && (d.getMonth() + 1) === targetMonth;
    });

    let products = [...(db.products || [])];
    if (category && category.trim() !== '') {
        products = products.filter(p => p.category.toLowerCase() === category.trim().toLowerCase());
    }

    let totalStockAll = 0;
    let periodInAll = 0;
    let periodOutAll = 0;
    let lowStockCount = 0;

    const categoryStats = {};

    const itemsSummary = products.map(p => {
        const pTxns = monthTxns.filter(t => t.sku.toUpperCase() === p.sku.toUpperCase());
        const totalIn = pTxns.filter(t => t.type === 'in').reduce((sum, t) => sum + t.qty, 0);
        const totalOut = pTxns.filter(t => t.type === 'out').reduce((sum, t) => sum + t.qty, 0);

        const beginningStock = Math.max(0, p.stock - totalIn + totalOut);

        totalStockAll += p.stock;
        periodInAll += totalIn;
        periodOutAll += totalOut;

        const isLow = p.stock <= p.threshold;
        if (isLow) lowStockCount++;

        if (!categoryStats[p.category]) {
            categoryStats[p.category] = { category: p.category, in: 0, out: 0, currentStock: 0 };
        }
        categoryStats[p.category].in += totalIn;
        categoryStats[p.category].out += totalOut;
        categoryStats[p.category].currentStock += p.stock;

        let statusText = 'In Stock';
        let statusBadge = 'status-normal';
        if (p.stock === 0) {
            statusText = 'Out of Stock';
            statusBadge = 'status-out';
        } else if (p.stock <= p.threshold) {
            statusText = 'Low Stock';
            statusBadge = 'status-low';
        }

        let activityText = 'ปกติ';
        let activityBadge = 'bg-secondary bg-opacity-10 text-secondary';
        if (totalOut >= 10) {
            activityText = 'Fast Moving';
            activityBadge = 'badge-stock-out';
        } else if (totalOut > 0) {
            activityText = 'Active';
            activityBadge = 'bg-primary bg-opacity-10 text-primary border border-primary';
        } else if (totalIn === 0 && totalOut === 0) {
            activityText = 'Slow Moving';
            activityBadge = 'bg-warning bg-opacity-10 text-warning-custom border border-warning';
        }

        return {
            sku: p.sku,
            name: p.name,
            category: p.category,
            threshold: p.threshold,
            beginningStock,
            totalIn,
            totalOut,
            currentStock: p.stock,
            statusText,
            statusBadge,
            activityText,
            activityBadge
        };
    });

    res.json({
        success: true,
        data: {
            period: targetMonthStr,
            kpis: {
                totalStock: totalStockAll,
                totalIn: periodInAll,
                totalOut: periodOutAll,
                lowStockCount
            },
            categories: Object.values(categoryStats),
            items: itemsSummary
        }
    });
};

module.exports = {
    getTransactions,
    getTransactionDetail,
    getStockSummary
};

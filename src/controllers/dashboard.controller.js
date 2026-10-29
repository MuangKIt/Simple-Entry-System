// src/controllers/dashboard.controller.js
const { readData } = require('../utils/db');

const getAdminDashboard = (req, res) => {
    const db = readData();
    const todayStr = new Date().toISOString().slice(0, 10);

    // คำนวณยอดวันนี้
    const todayIn = db.transactions
        .filter(t => t.type === 'in' && t.timestamp.startsWith(todayStr))
        .reduce((sum, t) => sum + t.qty, 0);

    const todayOut = db.transactions
        .filter(t => t.type === 'out' && t.timestamp.startsWith(todayStr))
        .reduce((sum, t) => sum + t.qty, 0);

    const totalSku = db.products.length;
    const lowStockItems = db.products.filter(p => p.stock > 0 && p.stock <= p.threshold);
    const outOfStockItems = db.products.filter(p => p.stock === 0);
    const lowStockCount = lowStockItems.length + outOfStockItems.length;

    // รายการล่าสุด (5 รายการแรก)
    const recentActivities = db.transactions.slice(0, 5);

    // Top 5 Items จากยอด Stock Out
    const itemOutMap = {};
    db.transactions.filter(t => t.type === 'out').forEach(t => {
        itemOutMap[t.productName] = (itemOutMap[t.productName] || 0) + t.qty;
    });

    const topItems = Object.entries(itemOutMap)
        .map(([name, qty]) => ({ name, qty }))
        .sort((a, b) => b.qty - a.qty)
        .slice(0, 5);

    // หากยังไม่มีข้อมูล Transaction พอ ให้ Fallback ตัวอย่างเริ่มต้น
    const fallbackTopItems = [
        { name: 'CPU Core i5', qty: 35 },
        { name: 'RAM 16GB', qty: 25 },
        { name: 'SSD 1TB', qty: 20 },
        { name: 'Mainboard', qty: 12 },
        { name: 'Power Supply', qty: 8 }
    ];

    res.json({
        success: true,
        data: {
            tiles: {
                todayIn: todayIn || 150, // ใช้ข้อมูลจริง หรือ mock fallback ตอนเริ่มวัน
                todayOut: todayOut || 45,
                totalSku: totalSku || 1204,
                lowStockCount: lowStockCount
            },
            reminders: {
                lowStockCount: lowStockCount,
                pendingStaff: db.users.filter(u => u.status === 'inactive').length
            },
            topItems: topItems.length > 0 ? topItems : fallbackTopItems,
            recentActivities
        }
    });
};

const getStaffDashboard = (req, res) => {
    const db = readData();
    const todayStr = new Date().toISOString().slice(0, 10);
    const user = req.user;

    const normalizeName = (n) => (n || '').replace(/^(นาย|นางสาว|นาง|น\.ส\.)\s*/, '').trim();
    const userCleanName = normalizeName(user.name);

    const isUserTxn = (t) => {
        if (t.empId && user.empId && t.empId === user.empId) return true;
        const txnCleanName = normalizeName(t.performedBy);
        return txnCleanName === userCleanName || t.performedBy === user.name;
    };

    // คำนวณงานวันนี้ของพนักงานคนนี้
    const userTodayTxns = (db.transactions || []).filter(t => 
        t.timestamp && t.timestamp.startsWith(todayStr) && isUserTxn(t)
    );

    const todayInCount = userTodayTxns.filter(t => t.type === 'in').length;
    const todayOutCount = userTodayTxns.filter(t => t.type === 'out').length;

    // ประวัติการทำงานล่าสุดของตนเอง (ล่าสุด 5 รายการ)
    const myLogs = (db.transactions || [])
        .filter(t => isUserTxn(t))
        .slice(0, 5);

    res.json({
        success: true,
        data: {
            todayStats: {
                inCount: todayInCount,
                outCount: todayOutCount
            },
            myLogs: myLogs
        }
    });
};

module.exports = {
    getAdminDashboard,
    getStaffDashboard
};

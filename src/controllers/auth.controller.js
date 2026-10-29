// src/controllers/auth.controller.js
const { readData, writeData } = require('../utils/db');
const { createToken } = require('../middlewares/auth.middleware');

const login = (req, res) => {
    const { username, password } = req.body;
    const db = readData();

    const user = db.users.find(u => u.username === username && u.password === password);

    if (!user) {
        return res.status(401).json({ success: false, message: 'Username หรือ Password ไม่ถูกต้อง' });
    }

    if (user.status === 'inactive') {
        return res.status(403).json({ success: false, message: 'บัญชีของคุณถูกระงับการใช้งาน กรุณาติดต่อผู้ดูแลระบบ' });
    }

    // อัปเดตเวลา lastLogin
    user.lastLogin = new Date().toISOString();
    writeData(db);

    const safeUser = {
        empId: user.empId,
        username: user.username,
        name: user.name,
        role: user.role,
        email: user.email
    };

    const token = createToken(safeUser);

    // ตั้งค่า Cookie แบบ HttpOnly ป้องกันการเข้าถึงจาก JavaScript
    res.cookie('auth_token', token, {
        httpOnly: true,
        secure: false, // สำหรับ Localhost
        sameSite: 'lax',
        maxAge: 24 * 60 * 60 * 1000 // 1 วัน
    });

    res.json({
        success: true,
        role: user.role,
        user: safeUser
    });
};

const logout = (req, res) => {
    res.clearCookie('auth_token');
    res.json({ success: true, message: 'ออกจากระบบเรียบร้อย' });
};

const getMe = (req, res) => {
    const db = readData();
    const user = db.users.find(u => u.empId === req.user.empId);

    if (!user) {
        return res.status(404).json({ success: false, message: 'ไม่พบข้อมูลผู้ใช้' });
    }

    // คำนวณจำนวน Transaction ที่ผู้ใช้คนนี้ทำในเดือนนี้
    const now = new Date();
    const currentMonth = now.getMonth();
    const currentYear = now.getFullYear();

    const normalizeName = (n) => (n || '').replace(/^(นาย|นางสาว|นาง|น\.ส\.)\s*/, '').trim();
    const userCleanName = normalizeName(user.name);

    const userTxnsThisMonth = (db.transactions || []).filter(t => {
        if (!t.timestamp) return false;
        const d = new Date(t.timestamp);
        if (isNaN(d.getTime())) return false;

        const isThisMonth = d.getMonth() === currentMonth && d.getFullYear() === currentYear;
        if (!isThisMonth) return false;

        if (t.empId && t.empId === user.empId) return true;

        const txnCleanName = normalizeName(t.performedBy);
        return txnCleanName === userCleanName || t.performedBy === user.name;
    }).length;

    res.json({
        success: true,
        user: {
            empId: user.empId,
            username: user.username,
            name: user.name,
            role: user.role,
            email: user.email,
            status: user.status,
            txnCountMonth: userTxnsThisMonth
        }
    });
};

module.exports = {
    login,
    logout,
    getMe
};

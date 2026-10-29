// src/controllers/user.controller.js
const { readData, writeData } = require('../utils/db');

const getAllUsers = (req, res) => {
    const db = readData();
    const safeUsers = db.users.map(u => ({
        empId: u.empId,
        username: u.username,
        name: u.name,
        role: u.role,
        email: u.email,
        status: u.status,
        lastLogin: u.lastLogin
    }));

    const totalUsers = safeUsers.length;
    const activeUsers = safeUsers.filter(u => u.status === 'active').length;
    const inactiveUsers = safeUsers.filter(u => u.status === 'inactive').length;

    res.json({
        success: true,
        summary: { totalUsers, activeUsers, inactiveUsers },
        data: safeUsers
    });
};

const createUser = (req, res) => {
    const { empId, name, username, password, role, status } = req.body;

    if (!empId || !name || !username || !password) {
        return res.status(400).json({ success: false, message: 'กรุณากรอกข้อมูลให้ครบถ้วน' });
    }

    const db = readData();

    if (db.users.some(u => u.empId === empId.trim())) {
        return res.status(400).json({ success: false, message: 'รหัสพนักงานนี้มีอยู่ในระบบแล้ว' });
    }

    if (db.users.some(u => u.username.toLowerCase() === username.trim().toLowerCase())) {
        return res.status(400).json({ success: false, message: 'Username นี้ถูกใช้งานแล้ว' });
    }

    const newUser = {
        empId: empId.trim(),
        username: username.trim(),
        password: password.trim(),
        name: name.trim(),
        role: role || 'staff',
        email: `${username.trim()}@tni.ac.th`,
        status: status || 'active',
        lastLogin: null
    };

    db.users.push(newUser);
    writeData(db);

    res.status(201).json({ success: true, message: 'เพิ่มผู้ใช้งานสำเร็จ', data: newUser });
};

const updateUser = (req, res) => {
    const { empId } = req.params;
    const { name, role, status, password } = req.body;

    const db = readData();
    const user = db.users.find(u => u.empId === empId);

    if (!user) {
        return res.status(404).json({ success: false, message: 'ไม่พบผู้ใช้งานนี้' });
    }

    if (name) user.name = name.trim();
    if (role) user.role = role;
    if (status) user.status = status;
    if (password && password.trim() !== '') user.password = password.trim();

    writeData(db);
    res.json({ success: true, message: 'อัปเดตข้อมูลผู้ใช้สำเร็จ' });
};

const toggleUserStatus = (req, res) => {
    const { empId } = req.params;
    const db = readData();
    const user = db.users.find(u => u.empId === empId);

    if (!user) {
        return res.status(404).json({ success: false, message: 'ไม่พบผู้ใช้งานนี้' });
    }

    user.status = user.status === 'active' ? 'inactive' : 'active';
    writeData(db);

    res.json({ 
        success: true, 
        message: `เปลี่ยนสถานะเป็น ${user.status === 'active' ? 'Active' : 'Inactive'} เรียบร้อยแล้ว`,
        status: user.status 
    });
};

module.exports = {
    getAllUsers,
    createUser,
    updateUser,
    toggleUserStatus
};

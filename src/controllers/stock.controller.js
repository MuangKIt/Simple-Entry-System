// src/controllers/stock.controller.js
const { readData, writeData } = require('../utils/db');

// สร้างรหัส Transaction อัตโนมัติ (เช่น TXN-2610001)
const generateRefId = (db) => {
    const today = new Date();
    const yearShort = today.getFullYear().toString().slice(-2);
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const prefix = `TXN-${yearShort}${month}`;
    
    const countThisMonth = db.transactions.filter(t => t.refId.startsWith(prefix)).length + 1;
    return `${prefix}${String(countThisMonth).padStart(3, '0')}`;
};

const stockIn = (req, res) => {
    const { sku, qty, note } = req.body;
    const amount = parseInt(qty);

    if (!sku || isNaN(amount) || amount <= 0) {
        return res.status(400).json({ success: false, message: 'กรุณาระบุรหัสสินค้าและจำนวนที่ถูกต้อง (มากกว่า 0)' });
    }

    const db = readData();
    const cleanSku = sku.trim().toUpperCase();
    const product = db.products.find(p => p.sku.toUpperCase() === cleanSku);

    if (!product) {
        return res.status(404).json({ success: false, message: `ไม่พบรหัสสินค้า ${cleanSku} ในระบบ` });
    }

    // เพิ่มสต็อก
    product.stock += amount;

    // สร้าง Transaction
    const newTxn = {
        refId: generateRefId(db),
        type: 'in',
        sku: product.sku,
        productName: product.name,
        qty: amount,
        note: (note && note.trim()) ? note.trim() : '-',
        performedBy: (req.user && req.user.name) ? req.user.name : 'พนักงานคลังสินค้า',
        empId: (req.user && req.user.empId) ? req.user.empId : undefined,
        timestamp: new Date().toISOString()
    };

    db.transactions.unshift(newTxn);
    writeData(db);

    res.json({
        success: true,
        message: `รับเข้า ${product.sku} จำนวน ${amount} ชิ้น เรียบร้อย!`,
        data: {
            sku: product.sku,
            updatedStock: product.stock,
            transaction: newTxn
        }
    });
};

const stockOut = (req, res) => {
    const { sku, qty, note } = req.body;
    const amount = parseInt(qty);

    if (!sku || isNaN(amount) || amount <= 0) {
        return res.status(400).json({ success: false, message: 'กรุณาระบุรหัสสินค้าและจำนวนที่ถูกต้อง (มากกว่า 0)' });
    }

    const db = readData();
    const cleanSku = sku.trim().toUpperCase();
    const product = db.products.find(p => p.sku.toUpperCase() === cleanSku);

    if (!product) {
        return res.status(404).json({ success: false, message: `ไม่พบรหัสสินค้า ${cleanSku} ในระบบ` });
    }

    // ตรวจสอบสต็อกคงเหลือ (ห้ามติดลบ)
    if (product.stock < amount) {
        return res.status(400).json({ 
            success: false, 
            message: `สินค้าในคลังไม่เพียงพอ (มีคงเหลือเพียง ${product.stock} ชิ้น)` 
        });
    }

    // ตัดสต็อกทันที (Simple Deduction Mechanism)
    product.stock -= amount;

    // สร้าง Transaction
    const newTxn = {
        refId: generateRefId(db),
        type: 'out',
        sku: product.sku,
        productName: product.name,
        qty: amount,
        note: (note && note.trim()) ? note.trim() : '-',
        performedBy: (req.user && req.user.name) ? req.user.name : 'พนักงานคลังสินค้า',
        empId: (req.user && req.user.empId) ? req.user.empId : undefined,
        timestamp: new Date().toISOString()
    };

    db.transactions.unshift(newTxn);
    writeData(db);

    res.json({
        success: true,
        message: `จ่ายออก ${product.sku} จำนวน ${amount} ชิ้น เรียบร้อย!`,
        data: {
            sku: product.sku,
            updatedStock: product.stock,
            transaction: newTxn
        }
    });
};

module.exports = {
    stockIn,
    stockOut
};

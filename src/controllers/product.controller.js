// src/controllers/product.controller.js
const { readData, writeData } = require('../utils/db');

// ฟังก์ชันคำนวณสถานะสต็อก
const calculateStatus = (stock, threshold) => {
    if (stock <= 0) return 'Out of Stock';
    if (stock <= threshold) return 'Low Stock';
    return 'In Stock';
};

const getAllProducts = (req, res) => {
    const db = readData();
    let products = db.products.map(p => ({
        ...p,
        status: calculateStatus(p.stock, p.threshold)
    }));

    const { category, search, status } = req.query;

    if (category) {
        products = products.filter(p => p.category.toLowerCase() === category.toLowerCase());
    }

    if (search) {
        const q = search.toLowerCase();
        products = products.filter(p => 
            p.sku.toLowerCase().includes(q) || p.name.toLowerCase().includes(q)
        );
    }

    if (status) {
        products = products.filter(p => p.status.toLowerCase() === status.toLowerCase());
    }

    res.json({ success: true, data: products });
};

const getProductBySku = (req, res) => {
    const db = readData();
    const sku = req.params.sku.toUpperCase();
    const product = db.products.find(p => p.sku.toUpperCase() === sku);

    if (!product) {
        return res.status(404).json({ success: false, message: 'ไม่พบรหัสสินค้านี้ในระบบ' });
    }

    res.json({
        success: true,
        data: {
            ...product,
            status: calculateStatus(product.stock, product.threshold)
        }
    });
};

const createProduct = (req, res) => {
    const { sku, name, category, threshold, initialStock } = req.body;

    if (!sku || !name) {
        return res.status(400).json({ success: false, message: 'กรุณากรอกรหัสสินค้าและชื่อสินค้า' });
    }

    const db = readData();
    const cleanSku = sku.trim().toUpperCase();

    // ตรวจสอบ SKU ซ้ำ
    if (db.products.some(p => p.sku.toUpperCase() === cleanSku)) {
        return res.status(400).json({ success: false, message: 'รหัสสินค้านี้มีอยู่ในระบบแล้ว' });
    }

    const stockNumber = parseInt(initialStock) || 0;
    const thresholdNumber = parseInt(threshold) || (db.settings.globalThreshold || 10);

    const newProduct = {
        sku: cleanSku,
        name: name.trim(),
        category: category || 'Hardware',
        stock: stockNumber,
        threshold: thresholdNumber
    };

    db.products.push(newProduct);

    // หากมียอดยกมาเริ่มต้น ให้บันทึก Transaction การรับเข้าก้อนแรกด้วย
    if (stockNumber > 0) {
        const txnId = `TXN-${Date.now().toString().slice(-7)}`;
        db.transactions.unshift({
            refId: txnId,
            type: 'in',
            sku: cleanSku,
            productName: newProduct.name,
            qty: stockNumber,
            note: 'ยอดยกมาเริ่มต้น (Initial Stock)',
            performedBy: req.user.name || 'Admin',
            timestamp: new Date().toISOString()
        });
    }

    writeData(db);
    res.status(201).json({ success: true, message: 'เพิ่มสินค้าสำเร็จ', data: newProduct });
};

const updateProduct = (req, res) => {
    const sku = req.params.sku.toUpperCase();
    const { name, category, threshold } = req.body;

    const db = readData();
    const product = db.products.find(p => p.sku.toUpperCase() === sku);

    if (!product) {
        return res.status(404).json({ success: false, message: 'ไม่พบรหัสสินค้านี้' });
    }

    if (name) product.name = name.trim();
    if (category) product.category = category;
    if (threshold !== undefined) product.threshold = parseInt(threshold) || 10;

    writeData(db);
    res.json({ success: true, message: 'แก้ไขข้อมูลสินค้าสำเร็จ', data: product });
};

module.exports = {
    getAllProducts,
    getProductBySku,
    createProduct,
    updateProduct
};

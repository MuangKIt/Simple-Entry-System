// src/routes/product.routes.js
const express = require('express');
const router = express.Router();
const productController = require('../controllers/product.controller');
const { apiAuthGuard } = require('../middlewares/auth.middleware');

// สิทธิ์ All Staff (Staff หรือ Admin ก็ดูสินค้าได้เพื่อใช้ใน Stock In/Out)
router.get('/', apiAuthGuard(), productController.getAllProducts);
router.get('/:sku', apiAuthGuard(), productController.getProductBySku);

// สิทธิ์ Admin เท่านั้นสำหรับการแก้ไขและเพิ่มสินค้าหลัก
router.post('/', apiAuthGuard(['admin']), productController.createProduct);
router.put('/:sku', apiAuthGuard(['admin']), productController.updateProduct);

module.exports = router;

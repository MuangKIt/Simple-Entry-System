// src/routes/stock.routes.js
const express = require('express');
const router = express.Router();
const stockController = require('../controllers/stock.controller');
const { apiAuthGuard } = require('../middlewares/auth.middleware');

// อนุญาตให้ทั้ง Staff และ Admin ทำรายการรับเข้าและจ่ายออกได้
router.post('/in', apiAuthGuard(), stockController.stockIn);
router.post('/out', apiAuthGuard(), stockController.stockOut);

module.exports = router;

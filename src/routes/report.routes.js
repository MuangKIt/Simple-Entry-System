// src/routes/report.routes.js
const express = require('express');
const router = express.Router();
const reportController = require('../controllers/report.controller');
const { apiAuthGuard } = require('../middlewares/auth.middleware');

// รายการประวัติธุรกรรม
router.get('/transactions', apiAuthGuard(['admin']), reportController.getTransactions);

// รายละเอียดใบสลิป (เปิดให้ทั้ง admin และ staff ดูได้)
router.get('/transactions/:refId', apiAuthGuard(['admin', 'staff']), reportController.getTransactionDetail);

// รายงานสรุปสต็อก
router.get('/stock-summary', apiAuthGuard(['admin']), reportController.getStockSummary);

module.exports = router;

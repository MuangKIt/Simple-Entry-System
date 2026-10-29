// src/routes/dashboard.routes.js
const express = require('express');
const router = express.Router();
const dashboardController = require('../controllers/dashboard.controller');
const { apiAuthGuard } = require('../middlewares/auth.middleware');

router.get('/admin', apiAuthGuard(['admin']), dashboardController.getAdminDashboard);
router.get('/staff', apiAuthGuard(), dashboardController.getStaffDashboard);

module.exports = router;

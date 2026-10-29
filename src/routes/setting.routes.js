// src/routes/setting.routes.js
const express = require('express');
const router = express.Router();
const settingController = require('../controllers/setting.controller');
const { apiAuthGuard } = require('../middlewares/auth.middleware');

// สิทธิ์ Admin เท่านั้น
router.use(apiAuthGuard(['admin']));

router.get('/', settingController.getSettings);
router.put('/', settingController.updateSettings);
router.get('/backup', settingController.downloadBackup);

module.exports = router;

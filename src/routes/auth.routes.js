// src/routes/auth.routes.js
const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const { apiAuthGuard } = require('../middlewares/auth.middleware');

router.post('/login', authController.login);
router.post('/logout', authController.logout);
router.get('/me', apiAuthGuard(), authController.getMe);

module.exports = router;

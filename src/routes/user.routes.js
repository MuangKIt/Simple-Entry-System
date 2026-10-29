// src/routes/user.routes.js
const express = require('express');
const router = express.Router();
const userController = require('../controllers/user.controller');
const { apiAuthGuard } = require('../middlewares/auth.middleware');

// สิทธิ์ Admin เท่านั้น
router.use(apiAuthGuard(['admin']));

router.get('/', userController.getAllUsers);
router.post('/', userController.createUser);
router.put('/:empId', userController.updateUser);
router.patch('/:empId/status', userController.toggleUserStatus);

module.exports = router;

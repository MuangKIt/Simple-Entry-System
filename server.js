// server.js
const express = require('express');
const cookieParser = require('cookie-parser');
const path = require('path');

// Middlewares
const { pageAuthGuard, parseToken } = require('./src/middlewares/auth.middleware');

// Routes
const authRoutes = require('./src/routes/auth.routes');
const productRoutes = require('./src/routes/product.routes');
const stockRoutes = require('./src/routes/stock.routes');
const userRoutes = require('./src/routes/user.routes');
const reportRoutes = require('./src/routes/report.routes');
const dashboardRoutes = require('./src/routes/dashboard.routes');
const settingRoutes = require('./src/routes/setting.routes');

const authController = require('./src/controllers/auth.controller');

const app = express();
const PORT = 3000;

// Body & Cookie Parsing
app.use(express.json());
app.use(cookieParser());

// ==========================================
// 1. Static Assets (CSS, JS, Images) - เปิดให้โหลดได้เสมอ
// ==========================================
app.use('/admin/css', express.static(path.join(__dirname, 'public', 'admin', 'css')));
app.use('/admin/js', express.static(path.join(__dirname, 'public', 'admin', 'js')));
app.use('/user/css', express.static(path.join(__dirname, 'public', 'user', 'css')));
app.use('/user/js', express.static(path.join(__dirname, 'public', 'user', 'js')));
app.use('/css', express.static(path.join(__dirname, 'public', 'css')));
app.use('/js', express.static(path.join(__dirname, 'public', 'js')));

// ==========================================
// 2. API Routes
// ==========================================
app.use('/api/auth', authRoutes);
app.post('/api/login', authController.login); // Alias สำหรับความเข้ากันได้
app.use('/api/products', productRoutes);
app.use('/api/stock', stockRoutes);
app.use('/api/users', userRoutes);
app.use('/api/reports', reportRoutes);
app.use('/api/dashboard', dashboardRoutes);
app.use('/api/settings', settingRoutes);

// ==========================================
// 3. Protected Page Routes (Auth Guard)
// ==========================================
app.get('/slip.html', pageAuthGuard(['admin', 'staff']), (req, res) => res.sendFile(path.join(__dirname, 'public', 'slip.html')));

app.get('/admin', pageAuthGuard(['admin']), (req, res) => res.redirect('/admin/admin.html'));
app.use('/admin', pageAuthGuard(['admin']), express.static(path.join(__dirname, 'public', 'admin')));

app.get('/user', pageAuthGuard(['admin', 'staff']), (req, res) => res.redirect('/user/user.html'));
app.use('/user', pageAuthGuard(['admin', 'staff']), express.static(path.join(__dirname, 'public', 'user')));

// ==========================================
// 4. Public Pages (หน้า Login)
// ==========================================
app.get('/', (req, res) => {
    const token = req.cookies && req.cookies.auth_token;
    const user = parseToken(token);

    if (user) {
        if (user.role === 'admin') return res.redirect('/admin/admin.html');
        if (user.role === 'staff') return res.redirect('/user/user.html');
    }
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// เสิร์ฟ index.html และ root assets ใน public
app.use(express.static(path.join(__dirname, 'public')));

// เริ่มรันเซิร์ฟเวอร์
const server = app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});

module.exports = server;

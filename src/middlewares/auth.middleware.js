// src/middlewares/auth.middleware.js

// ถอดรหัส Token แบบ Base64 JSON อย่างง่าย (ปลอดภัยพอดีสำหรับโปรเจกต์การศึกษาและไม่เพิ่ม dependency หนัก)
const parseToken = (token) => {
    if (!token) return null;
    try {
        const decoded = Buffer.from(token, 'base64').toString('utf-8');
        return JSON.parse(decoded);
    } catch (e) {
        return null;
    }
};

// สร้าง Token จากข้อมูลผู้ใช้
const createToken = (userData) => {
    return Buffer.from(JSON.stringify(userData)).toString('base64');
};

// Middleware สำหรับป้องกันหน้าเว็บ HTML (Page Guard)
const pageAuthGuard = (allowedRoles = []) => {
    return (req, res, next) => {
        const token = req.cookies && req.cookies.auth_token;
        const user = parseToken(token);

        if (!user) {
            // ยังไม่ได้ Login ให้ redirect กลับหน้า Login
            return res.redirect('/index.html');
        }

        if (allowedRoles.length > 0 && !allowedRoles.includes(user.role)) {
            // มี Login แล้วแต่สิทธิ์ไม่ถึง เช่น staff แอบเข้า /admin
            if (user.role === 'staff') {
                return res.redirect('/user/user.html');
            }
            return res.redirect('/index.html');
        }

        req.user = user;
        next();
    };
};

// Middleware สำหรับป้องกัน API Endpoints
const apiAuthGuard = (allowedRoles = []) => {
    return (req, res, next) => {
        const token = (req.cookies && req.cookies.auth_token) || 
                      (req.headers.authorization && req.headers.authorization.replace('Bearer ', ''));
        const user = parseToken(token);

        if (!user) {
            return res.status(401).json({ success: false, message: 'กรุณาเข้าสู่ระบบก่อนทำรายการ' });
        }

        if (allowedRoles.length > 0 && !allowedRoles.includes(user.role)) {
            return res.status(403).json({ success: false, message: 'ไม่มีสิทธิ์ในการเข้าถึง API นี้' });
        }

        req.user = user;
        next();
    };
};

module.exports = {
    createToken,
    parseToken,
    pageAuthGuard,
    apiAuthGuard
};

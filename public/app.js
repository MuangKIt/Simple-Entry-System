// public/app.js
const loginForm = document.getElementById('loginForm');

if (loginForm) {
    loginForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value.trim();
        const errorMessage = document.getElementById('errorMessage');
        const submitBtn = loginForm.querySelector('button[type="submit"]');
        const originalBtnText = submitBtn.innerHTML;

        errorMessage.style.display = 'none';
        submitBtn.disabled = true;
        submitBtn.innerHTML = 'กำลังเข้าสู่ระบบ...';
        
        try {
            const response = await fetch('/api/auth/login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ username, password })
            });
            
            const result = await response.json();
            
            if (response.ok && result.success) {
                // เก็บข้อมูลผู้ใช้และ Role ไว้สำหรับ Client-side display
                localStorage.setItem('role', result.role);
                localStorage.setItem('currentUser', JSON.stringify(result.user));
                
                // นำทางตามสิทธิ์ของผู้ใช้งาน
                if (result.role === 'admin') {
                    window.location.href = '/admin/admin.html';
                } else if (result.role === 'staff') {
                    window.location.href = '/user/user.html';
                }
            } else {
                errorMessage.textContent = result.message || 'Username หรือ Password ไม่ถูกต้อง';
                errorMessage.style.display = 'block';
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalBtnText;
            }
        } catch (error) {
            console.error('Login error:', error);
            errorMessage.textContent = 'เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์';
            errorMessage.style.display = 'block';
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalBtnText;
        }
    });
}
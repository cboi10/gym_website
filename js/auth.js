document.addEventListener('DOMContentLoaded', function() {
    // Login Form
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const email = document.getElementById('loginEmail').value;
            const password = document.getElementById('loginPassword').value;
            
            // Basic validation
            if (!email || !password) {
                alert('Please fill in all fields');
                return;
            }
            
            // Here you would typically send the data to a server for authentication
            // For this example, we'll simulate a successful login
            localStorage.setItem('isLoggedIn', 'true');
            localStorage.setItem('userEmail', email);
            
            alert('Login successful!');
            document.getElementById('loginModal').style.display = 'none';
            document.body.style.overflow = 'auto';
            
            // Update UI to show user is logged in
            updateAuthUI();
        });
    }
    
    // Register Form
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const name = document.getElementById('regName').value;
            const email = document.getElementById('regEmail').value;
            const password = document.getElementById('regPassword').value;
            const confirmPassword = document.getElementById('regConfirmPassword').value;
            
            // Basic validation
            if (!name || !email || !password || !confirmPassword) {
                alert('Please fill in all fields');
                return;
            }
            
            if (password !== confirmPassword) {
                alert('Passwords do not match');
                return;
            }
            
            // Here you would typically send the data to a server for registration
            // For this example, we'll simulate a successful registration
            localStorage.setItem('isLoggedIn', 'true');
            localStorage.setItem('userEmail', email);
            localStorage.setItem('userName', name);
            
            alert('Registration successful! You are now logged in.');
            document.getElementById('registerModal').style.display = 'none';
            document.body.style.overflow = 'auto';
            
            // Update UI to show user is logged in
            updateAuthUI();
        });
    }
    
    // Check if user is logged in on page load
    function updateAuthUI() {
        const isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
        const authButtons = document.querySelectorAll('.auth-buttons');
        
        if (isLoggedIn) {
            const userName = localStorage.getItem('userName') || 'User';
            authButtons.forEach(container => {
                container.innerHTML = `
                    <div class="user-profile">
                        <span>Hello, ${userName}</span>
                        <a href="#" class="btn-logout">Logout</a>
                    </div>
                `;
            });
            
            // Add logout functionality
            document.querySelectorAll('.btn-logout').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    localStorage.removeItem('isLoggedIn');
                    localStorage.removeItem('userEmail');
                    localStorage.removeItem('userName');
                    updateAuthUI();
                    window.location.reload();
                });
            });
        } else {
            authButtons.forEach(container => {
                container.innerHTML = `
                    <a href="#" class="btn-login">LOGIN</a>
                    <a href="#" class="btn-register">REGISTER</a>
                `;
            });
        }
    }
    
    // Initialize auth UI
    updateAuthUI();
});
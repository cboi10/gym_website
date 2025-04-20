// Simulated backend functionality
document.addEventListener('DOMContentLoaded', function() {
    // Simulate fetching news data
    function fetchNews() {
        // In a real app, this would be an API call
        return [
            {
                id: 1,
                date: { day: '22', month: 'OCT' },
                title: '7 Precious tips to help you get better at GYM',
                author: 'Admin',
                likes: 23
            },
            {
                id: 2,
                date: { day: '09', month: 'SEP' },
                title: 'You\'ll never thought that knowing GYM could be so beneficial',
                author: 'Admin',
                likes: 12
            },
            {
                id: 3,
                date: { day: '18', month: 'AUG' },
                title: 'What\'s so trendy about GYM that everyone went crazy over it?',
                author: 'Admin',
                likes: 78
            }
        ];
    }
    
    // Simulate fetching trainers data
    function fetchTrainers() {
        return [
            {
                id: 1,
                name: 'Rahul',
                specialization: 'Yoga Trainer',
                image: 'images/trainers/trainer2.jpg',
                social: {
                    facebook: '#',
                    twitter: '#',
                    instagram: '#',
                    linkedin: '#'
                }
            },
            {
                id: 2,
                name: 'Karan',
                specialization: 'Aerobic Trainer',
                image: 'images/trainers/trainer1.jpg',
                social: {
                    facebook: '#',
                    twitter: '#',
                    instagram: '#',
                    linkedin: '#'
                }
            },
            {
                id: 3,
                name: 'Jogesh',
                specialization: 'Boxing Trainer',
                image: 'images/trainers/trainer3.jpg',
                social: {
                    facebook: '#',
                    twitter: '#',
                    instagram: '#',
                    linkedin: '#'
                }
            }
        ];
    }
    
    // Simulate fetching products data
    function fetchProducts() {
        return [
            {
                id: 1,
                name: 'Treadmill',
                price: 214.00,
                image: 'images/equipment/treadmill.jpg'
            },
            {
                id: 2,
                name: 'Workout Tools',
                price: 115.00,
                image: 'images/equipment/workout-tools.jpg'
            },
            {
                id: 3,
                name: 'Workout Machine',
                price: 326.00,
                image: 'images/equipment/workout-machine.jpg'
            }
        ];
    }
    
    // Initialize cart functionality
    function initCart() {
        let cart = JSON.parse(localStorage.getItem('cart')) || [];
        
        // Add to cart buttons
        document.querySelectorAll('.btn-secondary').forEach(btn => {
            if (btn.textContent.trim() === 'ADD TO CART') {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const productCard = this.closest('.product-card');
                    const productId = productCard.dataset.id;
                    const productName = productCard.querySelector('h3').textContent;
                    const productPrice = parseFloat(productCard.querySelector('.price').textContent.replace('$', ''));
                    
                    // Check if product already in cart
                    const existingItem = cart.find(item => item.id === productId);
                    
                    if (existingItem) {
                        existingItem.quantity += 1;
                    } else {
                        cart.push({
                            id: productId,
                            name: productName,
                            price: productPrice,
                            quantity: 1
                        });
                    }
                    
                    localStorage.setItem('cart', JSON.stringify(cart));
                    alert(`${productName} added to cart!`);
                });
            }
        });
    }
    
    // Initialize all backend functionality
    function initBackend() {
        initCart();
        
        // In a real app, you would use the fetched data to populate the page
        // For this example, we're using static HTML with simulated data
    }
    
    // Initialize backend when DOM is loaded
    initBackend();
});
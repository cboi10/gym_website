-- Create database
CREATE DATABASE IF NOT EXISTS gym_website;
USE gym_website;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Contacts table
CREATE TABLE IF NOT EXISTS contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Subscribers table
CREATE TABLE IF NOT EXISTS subscribers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    subscribed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    verification_token VARCHAR(255),
    is_verified BOOLEAN DEFAULT FALSE,
    unsubscribed_at TIMESTAMP NULL
);

-- Products table
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Trainers table
CREATE TABLE IF NOT EXISTS trainers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    bio TEXT,
    image_path VARCHAR(255),
    facebook_url VARCHAR(255),
    twitter_url VARCHAR(255),
    instagram_url VARCHAR(255),
    linkedin_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Classes table
CREATE TABLE IF NOT EXISTS classes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    duration INT NOT NULL COMMENT 'Duration in minutes',
    capacity INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Timetable table
CREATE TABLE IF NOT EXISTS timetable (
    id INT AUTO_INCREMENT PRIMARY KEY,
    class_id INT NOT NULL,
    trainer_id INT NOT NULL,
    day_of_week TINYINT NOT NULL COMMENT '0=Sunday, 1=Monday, etc.',
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (class_id) REFERENCES classes(id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Memberships table
CREATE TABLE IF NOT EXISTS memberships (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    duration_days INT NOT NULL COMMENT 'Duration in days',
    classes_per_week INT,
    personal_training_sessions INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- User memberships table
CREATE TABLE IF NOT EXISTS user_memberships (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    membership_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (membership_id) REFERENCES memberships(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Cart table
CREATE TABLE IF NOT EXISTS cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    session_id VARCHAR(255) COMMENT 'For guests without accounts',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Cart items table
CREATE TABLE IF NOT EXISTS cart_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (cart_id) REFERENCES cart(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'processing', 'completed', 'cancelled') DEFAULT 'pending',
    payment_method VARCHAR(50),
    transaction_id VARCHAR(255),
    shipping_address TEXT,
    billing_address TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Order items table
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Blog posts table
CREATE TABLE IF NOT EXISTS blog_posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    excerpt TEXT,
    author_id INT NOT NULL,
    image_path VARCHAR(255),
    slug VARCHAR(255) NOT NULL UNIQUE,
    published_at TIMESTAMP NULL,
    is_published BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (author_id) REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Blog post likes table
CREATE TABLE IF NOT EXISTS blog_post_likes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (post_id) REFERENCES blog_posts(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_like (post_id, user_id)
);

-- Gallery images table
CREATE TABLE IF NOT EXISTS gallery_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    description TEXT,
    image_path VARCHAR(255) NOT NULL,
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data for products
INSERT INTO products (name, description, price, image_path) VALUES
('Treadmill', 'Professional grade treadmill with incline feature', 214.00, 'images/equipment/treadmill.jpg'),
('Workout Tools', 'Set of high-quality workout tools', 115.00, 'images/equipment/workout-tools.jpg'),
('Workout Machine', 'Multi-functional workout machine', 326.00, 'images/equipment/workout-machine.jpg');

-- Insert sample data for trainers
INSERT INTO trainers (name, specialization, bio, image_path, facebook_url, twitter_url, instagram_url, linkedin_url) VALUES
('Ann Woody', 'Yoga Trainer', 'Certified yoga instructor with 10 years of experience', 'images/trainers/trainer1.jpg', '#', '#', '#', '#'),
('Imogene Byas', 'Aerobic Trainer', 'Specialized in high-intensity aerobic workouts', 'images/trainers/trainer2.jpg', '#', '#', '#', '#'),
('Wilfred Drake', 'Boxing Trainer', 'Former professional boxer turned trainer', 'images/trainers/trainer3.jpg', '#', '#', '#', '#');

-- Insert sample data for classes
INSERT INTO classes (name, description, duration, capacity) VALUES
('Weight Loss', 'High-intensity interval training for weight loss', 60, 20),
('Cycling', 'Indoor cycling class with great music', 45, 15),
('Yoga', 'Vinyasa flow yoga for all levels', 60, 25),
('Boxing', 'Boxing fundamentals and cardio workout', 60, 15),
('Crossfit', 'Functional fitness at high intensity', 60, 20),
('Spinning', 'Indoor cycling with varied resistance', 45, 15),
('Bootcamp', 'Military-style total body workout', 60, 25),
('Body Building', 'Strength training for muscle growth', 90, 15),
('Dance', 'Cardio dance workout', 60, 30);

-- Insert sample data for timetable
INSERT INTO timetable (class_id, trainer_id, day_of_week, start_time, end_time) VALUES
(1, 1, 0, '10:00:00', '11:00:00'), -- Sunday Weight Loss
(2, 2, 0, '11:00:00', '12:00:00'), -- Sunday Cycling
(3, 1, 0, '15:00:00', '16:00:00'), -- Sunday Yoga
(4, 3, 0, '17:00:00', '18:00:00'), -- Sunday Boxing
(5, 2, 0, '19:00:00', '20:00:00'), -- Sunday Crossfit
(6, 2, 1, '10:00:00', '11:00:00'), -- Monday Spinning
(7, 3, 1, '15:00:00', '16:00:00'), -- Monday Bootcamp
(8, 3, 2, '10:00:00', '11:30:00'), -- Tuesday Body Building
(9, 2, 2, '15:00:00', '16:00:00'), -- Tuesday Dance
(7, 1, 3, '11:00:00', '12:00:00');  -- Thursday Bootcamp

-- Insert sample data for memberships
INSERT INTO memberships (name, description, price, duration_days, classes_per_week, personal_training_sessions) VALUES
('STANDARD', 'Basic membership with limited access', 29.00, 30, 3, 1),
('PREMIUM', 'Popular membership with more benefits', 49.00, 30, 5, 2),
('PLATINUM', 'Premium membership with all benefits', 99.00, 60, 7, 5);

-- Insert sample data for blog posts
INSERT INTO blog_posts (title, content, excerpt, author_id, image_path, slug, published_at, is_published) VALUES
('7 Precious tips to help you get better at GYM', 'Full content of the blog post...', 'Short excerpt about the post...', 1, 'images/blog/post1.jpg', '7-precious-tips', NOW(), TRUE),
('You''ll never thought that knowing GYM could be so beneficial', 'Full content of the blog post...', 'Short excerpt about the post...', 1, 'images/blog/post2.jpg', 'gym-benefits', NOW(), TRUE),
('What''s so trendy about GYM that everyone went crazy over it?', 'Full content of the blog post...', 'Short excerpt about the post...', 1, 'images/blog/post3.jpg', 'gym-trends', NOW(), TRUE);

-- Insert sample data for gallery images
INSERT INTO gallery_images (title, description, image_path, is_featured) VALUES
('Gym Facility 1', 'Our main workout area', 'images/gallery/gym1.jpg', TRUE),
('Gym Facility 2', 'Cardio equipment section', 'images/gallery/gym2.jpg', FALSE),
('Gym Facility 3', 'Weight training area', 'images/gallery/gym3.jpg', TRUE),
('Gym Facility 4', 'Group class in session', 'images/gallery/gym4.jpg', FALSE),
('Gym Facility 5', 'Personal training session', 'images/gallery/gym5.jpg', FALSE),
('Gym Facility 6', 'Yoga class', 'images/gallery/gym6.jpg', FALSE);
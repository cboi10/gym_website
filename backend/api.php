<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

// Database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "gym_website";

try {
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    echo json_encode(['error' => 'Connection failed: ' . $e->getMessage()]);
    exit;
}

// Handle different API endpoints
$request_method = $_SERVER['REQUEST_METHOD'];
$request_uri = $_SERVER['REQUEST_URI'];
$endpoint = parse_url($request_uri, PHP_URL_PATH);
$endpoint = str_replace('/api.php', '', $endpoint);

switch ($endpoint) {
    case '/contact':
        if ($request_method === 'POST') {
            $data = json_decode(file_get_contents('php://input'), true);
            
            // Validate data
            if (empty($data['name']) || empty($data['subject']) || empty($data['message']) || empty($data['captcha'])) {
                echo json_encode(['error' => 'All fields are required']);
                exit;
            }
            
            if ($data['captcha'] !== $_SESSION['captcha']) {
                echo json_encode(['error' => 'Invalid CAPTCHA']);
                exit;
            }
            
            // Save to database
            try {
                $stmt = $conn->prepare("INSERT INTO contacts (name, subject, message, created_at) VALUES (:name, :subject, :message, NOW())");
                $stmt->bindParam(':name', $data['name']);
                $stmt->bindParam(':subject', $data['subject']);
                $stmt->bindParam(':message', $data['message']);
                $stmt->execute();
                
                echo json_encode(['success' => 'Message sent successfully']);
            } catch(PDOException $e) {
                echo json_encode(['error' => 'Error saving message: ' . $e->getMessage()]);
            }
        }
        break;
        
    case '/subscribe':
        if ($request_method === 'POST') {
            $data = json_decode(file_get_contents('php://input'), true);
            
            if (empty($data['email'])) {
                echo json_encode(['error' => 'Email is required']);
                exit;
            }
            
            if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
                echo json_encode(['error' => 'Invalid email format']);
                exit;
            }
            
            try {
                $stmt = $conn->prepare("INSERT INTO subscribers (email, subscribed_at) VALUES (:email, NOW())");
                $stmt->bindParam(':email', $data['email']);
                $stmt->execute();
                
                echo json_encode(['success' => 'Subscribed successfully']);
            } catch(PDOException $e) {
                // If duplicate email, ignore the error
                if ($e->getCode() == 23000) {
                    echo json_encode(['success' => 'Already subscribed']);
                } else {
                    echo json_encode(['error' => 'Error subscribing: ' . $e->getMessage()]);
                }
            }
        }
        break;
        
    case '/login':
        if ($request_method === 'POST') {
            $data = json_decode(file_get_contents('php://input'), true);
            
            if (empty($data['email']) || empty($data['password'])) {
                echo json_encode(['error' => 'Email and password are required']);
                exit;
            }
            
            try {
                $stmt = $conn->prepare("SELECT * FROM users WHERE email = :email");
                $stmt->bindParam(':email', $data['email']);
                $stmt->execute();
                
                $user = $stmt->fetch(PDO::FETCH_ASSOC);
                
                if ($user && password_verify($data['password'], $user['password'])) {
                    // Start session and return success
                    session_start();
                    $_SESSION['user_id'] = $user['id'];
                    $_SESSION['user_name'] = $user['name'];
                    $_SESSION['user_email'] = $user['email'];
                    
                    echo json_encode([
                        'success' => true,
                        'user' => [
                            'id' => $user['id'],
                            'name' => $user['name'],
                            'email' => $user['email']
                        ]
                    ]);
                } else {
                    echo json_encode(['error' => 'Invalid email or password']);
                }
            } catch(PDOException $e) {
                echo json_encode(['error' => 'Error logging in: ' . $e->getMessage()]);
            }
        }
        break;
        
    case '/register':
        if ($request_method === 'POST') {
            $data = json_decode(file_get_contents('php://input'), true);
            
            if (empty($data['name']) || empty($data['email']) || empty($data['password']) || empty($data['confirm_password'])) {
                echo json_encode(['error' => 'All fields are required']);
                exit;
            }
            
            if ($data['password'] !== $data['confirm_password']) {
                echo json_encode(['error' => 'Passwords do not match']);
                exit;
            }
            
            if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
                echo json_encode(['error' => 'Invalid email format']);
                exit;
            }
            
            try {
                // Check if email already exists
                $stmt = $conn->prepare("SELECT id FROM users WHERE email = :email");
                $stmt->bindParam(':email', $data['email']);
                $stmt->execute();
                
                if ($stmt->rowCount() > 0) {
                    echo json_encode(['error' => 'Email already registered']);
                    exit;
                }
                
                // Hash password
                $hashedPassword = password_hash($data['password'], PASSWORD_DEFAULT);
                
                // Insert new user
                $stmt = $conn->prepare("INSERT INTO users (name, email, password, created_at) VALUES (:name, :email, :password, NOW())");
                $stmt->bindParam(':name', $data['name']);
                $stmt->bindParam(':email', $data['email']);
                $stmt->bindParam(':password', $hashedPassword);
                $stmt->execute();
                
                // Get the new user
                $userId = $conn->lastInsertId();
                $stmt = $conn->prepare("SELECT * FROM users WHERE id = :id");
                $stmt->bindParam(':id', $userId);
                $stmt->execute();
                $user = $stmt->fetch(PDO::FETCH_ASSOC);
                
                // Start session
                session_start();
                $_SESSION['user_id'] = $user['id'];
                $_SESSION['user_name'] = $user['name'];
                $_SESSION['user_email'] = $user['email'];
                
                echo json_encode([
                    'success' => true,
                    'user' => [
                        'id' => $user['id'],
                        'name' => $user['name'],
                        'email' => $user['email']
                    ]
                ]);
            } catch(PDOException $e) {
                echo json_encode(['error' => 'Error registering user: ' . $e->getMessage()]);
            }
        }
        break;
        
    default:
        echo json_encode(['error' => 'Invalid API endpoint']);
        break;
}
?>
<?php
// Mengatur header response untuk memastikan respons dalam format JSON
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, X-Requested-With");
header('Content-Type: application/json');

// Menyertakan file koneksi
include $_SERVER['DOCUMENT_ROOT'].'/UASpraktikum/Api/koneksi.php';


// Cek koneksi database
if ($conn->connect_error) {
    echo json_encode([
        'status' => 500,
        'message' => 'Koneksi database gagal: ' . $conn->connect_error
    ]);
    exit();
}

// Mendapatkan data POST dari request body
$data = json_decode(file_get_contents("php://input"), true);

// Validasi input untuk email dan password
if (empty($data['email']) || empty($data['password'])) {
    echo json_encode([
        'status' => 400,
        'message' => 'Email dan Password diperlukan'
    ]);
    exit();
}

$email = trim($data['email']);
$password = $data['password'];

// Validasi format email
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode([
        'status' => 400,
        'message' => 'Format email tidak valid'
    ]);
    exit();
}

// Query untuk mencari user berdasarkan email
$sql = "SELECT * FROM user WHERE email = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

// Cek apakah user ditemukan
if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    
    // Verifikasi password
    if (password_verify($password, $user['password'])) {
        echo json_encode([
            'status' => 200,
            'message' => 'Login berhasil',
            'user' => [
                'id' => $user['id'],
                'username' => $user['username'],
                'email' => $user['email']
            ]
        ]);
    } else {
        echo json_encode([
            'status' => 401,
            'message' => 'Password salah'
        ]);
    }
} else {
    echo json_encode([
        'status' => 404,
        'message' => 'User tidak ditemukan'
    ]);
}

// Menutup koneksi database
$stmt->close();
$conn->close();
?>
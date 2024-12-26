<?php

// Menambahkan header untuk memastikan respons dalam format JSON
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, X-Requested-With");

// Menghubungkan ke database
include $_SERVER['DOCUMENT_ROOT'].'/UASpraktikum/Api/koneksi.php';

if (!$conn) {
    $response = array(
        'status' => 500,
        'result' => 'Koneksi ke database gagal: ' . mysqli_connect_error(),
    );
    echo json_encode($response);
    exit;
}

// Mendapatkan data JSON dari request body
$data = json_decode(file_get_contents("php://input"), true);
$username = isset($data['username']) ? trim($data['username']) : '';
$email = isset($data['email']) ? trim($data['email']) : '';
$password = isset($data['password']) ? trim($data['password']) : '';

// Validasi input kosong
if (empty($username) || empty($email) || empty($password)) {
    $response = array(
        'status' => 400,
        'result' => 'Semua field harus diisi',
    );
    echo json_encode($response);
    exit;
}

// Validasi format email
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $response = array(
        'status' => 400,
        'result' => 'Format email tidak valid',
    );
    echo json_encode($response);
    exit;
}

// Pengecekan duplikasi email
$emailCheckQuery = "SELECT * FROM user WHERE email = ?";
$stmt = $conn->prepare($emailCheckQuery);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $response = array(
        'status' => 409,
        'result' => 'Email sudah terdaftar',
    );
    echo json_encode($response);
    exit;
}

// Enkripsi password
$hashedPassword = password_hash($password, PASSWORD_BCRYPT);

// Query untuk menambahkan user
$insertQuery = "INSERT INTO user (username, email, password) VALUES (?, ?, ?)";
$stmt = $conn->prepare($insertQuery);
$stmt->bind_param("sss", $username, $email, $hashedPassword);

if ($stmt->execute()) {
    $response = array(
        'status' => 200,
        'result' => 'Register berhasil',
    );
} else {
    $response = array(
        'status' => 500,
        'result' => 'Gagal menambahkan user: ' . $stmt->error,
    );
}

// Menutup koneksi
echo json_encode($response);
$stmt->close();
$conn->close();

?>
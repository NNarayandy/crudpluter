<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, PUT, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, X-Requested-With");

include $_SERVER['DOCUMENT_ROOT'].'/UASpraktikum/Api/koneksi.php';


// Mendapatkan data input dalam format JSON
$data = json_decode(file_get_contents("php://input"), true);

// Mendapatkan data user yang diupdate
$id = isset($data['id']) ? $data['id'] : '';
$username = isset($data['username']) ? $data['username'] : '';
$email = isset($data['email']) ? $data['email'] : '';
$password = isset($data['password']) ? $data['password'] : '';

// Validasi input id, username, dan email
if (empty($id)) {
    $response = array(
        'status' => 400,
        'result' => 'ID tidak boleh kosong',
    );
    echo json_encode($response);
    exit;
}

if (empty($username) || empty($email)) {
    $response = array(
        'status' => 400,
        'result' => 'Username dan email tidak boleh kosong',
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

// Pastikan ID valid dan user dengan ID tersebut ada
$check = mysqli_query($conn, "SELECT * FROM user WHERE id='$id'");

if (mysqli_num_rows($check) == 0) {
    // User tidak ditemukan
    $response = array(
        'status' => 404,
        'result' => 'User tidak ditemukan',
    );
    echo json_encode($response);
    exit;
} else {
    // Jika password diubah, enkripsi password baru
    $hashedPassword = null;
    if (!empty($password)) {
        // Hanya lakukan enkripsi jika password tidak kosong
        $hashedPassword = password_hash($password, PASSWORD_BCRYPT);
    }

    // Update user data
    if ($hashedPassword !== null) {
        // Jika password diubah, masukkan password baru
        $stmt = $conn->prepare("UPDATE user SET username=?, email=?, password=? WHERE id=?");
        $stmt->bind_param("sssi", $username, $email, $hashedPassword, $id);
    } else {
        // Jika password tidak diubah, update tanpa password
        $stmt = $conn->prepare("UPDATE user SET username=?, email=? WHERE id=?");
        $stmt->bind_param("ssi", $username, $email, $id);
    }

    if ($stmt->execute()) {
        $response = array(
            'status' => 200,
            'result' => 'Data berhasil diperbarui',
        );
    } else {
        // Logging error database
        error_log('MySQL error: ' . $stmt->error);
        $response = array(
            'status' => 500,
            'result' => 'Gagal memperbarui data, silakan coba lagi nanti',
        );
    }
}

echo json_encode($response);
mysqli_close($conn);
?>
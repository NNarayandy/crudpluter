<?php
// Header untuk mengizinkan akses dari semua origin dan mendukung metode yang diperlukan
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, X-Requested-With");

// Mengimpor file koneksi ke database
include $_SERVER['DOCUMENT_ROOT'].'/UASpraktikum/Api/koneksi.php';


// Query untuk mengambil data pengguna
$sql = "SELECT * FROM user";
$query = mysqli_query($conn, $sql);

// Membuat array untuk menyimpan data pengguna
$users = array();

// Memeriksa apakah ada data
if (mysqli_num_rows($query) > 0) {
    while ($row = mysqli_fetch_assoc($query)) {
        $users[] = $row; // Menambahkan data pengguna ke array
    }
    // Mengirimkan data pengguna dalam format JSON
    echo json_encode($users);
} else {
    // Jika tidak ada data pengguna
    echo json_encode([]);
}

// Menutup koneksi
mysqli_close($conn);
?>
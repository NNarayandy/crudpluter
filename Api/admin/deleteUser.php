<?php

// Header untuk mengizinkan akses dari semua origin dan mendukung metode yang diperlukan
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, X-Requested-With");

// Mengimpor file koneksi ke database
include $_SERVER['DOCUMENT_ROOT'].'/UASpraktikum/Api/koneksi.php';


// Mendapatkan data input dalam format JSON
$data = json_decode(file_get_contents("php://input"), true);

// Mengambil nilai 'id' dari data yang dikirim
$id = isset($data['id']) ? $data['id'] : '';

// Memeriksa apakah id tidak kosong
if (!empty($id)) {
    // Query untuk menghapus data berdasarkan id
    $sql = "DELETE FROM user WHERE id='$id'";
    $query = mysqli_query($conn, $sql); // Menjalankan query

    // Memeriksa apakah ada baris yang terpengaruh (berhasil menghapus data)
    if (mysqli_affected_rows($conn) > 0) {
        $response = array(
            'status' => 200, // Status OK
            'result' => 'Data berhasil dihapus', // Pesan sukses
        );
    } else {
        $response = array(
            'status' => 404, // Status Not Found
            'result' => 'Data tidak ditemukan atau gagal dihapus', // Pesan gagal
        );
    }
} else {
    // Jika input id kosong
    $response = array(
        'status' => 400, // Bad Request
        'result' => 'ID tidak boleh kosong', // Pesan error
    );
}

// Menampilkan hasil akhir dalam format JSON
echo json_encode($response);

// Menutup koneksi
mysqli_close($conn);

?>
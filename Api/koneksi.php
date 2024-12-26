<?php

// Menambahkan header untuk memastikan respons dalam format JSON
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, X-Requested-With");

// Menyembunyikan kesalahan koneksi di produksi untuk keamanan (penggunaan dalam development)
error_reporting(E_ERROR | E_PARSE);

// Mengatur konfigurasi koneksi database
$servername = "localhost";
$username = "root"; // Sesuaikan dengan username MySQL Anda
$password = ""; // Sesuaikan dengan password MySQL Anda
$dbname = "fluttercrud"; // Sesuaikan dengan nama database Anda

// Membuat koneksi ke database
$conn = new mysqli($servername, $username, $password, $dbname);

// Cek koneksi, jika gagal maka koneksi akan dihentikan tanpa output ke pengguna
if ($conn->connect_error) {
    die("Koneksi ke database gagal");
} else

// Jika berhasil, koneksi siap digunakan tanpa output apapun
?>
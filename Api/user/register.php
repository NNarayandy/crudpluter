<?php

include $_SERVER['DOCUMENT_ROOT'].'/UASpraktikum/Api/koneksi.php';


$query = "SELECT * FROM absensi";
$result = mysqli_query($conn, $query);

$data = array();
while ($row = mysqli_fetch_assoc($result)) {
    $data[] = $row;
}

echo json_encode($data);
?>

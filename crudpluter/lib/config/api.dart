import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  // Base URL (sesuaikan dengan URL backend kamu)
  static const String _host = 'http://localhost/UASpraktikum/Api/';

  // Endpoint constants
  static const String register = '$_host/admin/CreateUser.php';
  static const String login = '$_host/admin/login.php';
  static const String userView = '$_host/admin/GetDataUser.php'; // Endpoint untuk mengambil data pengguna
  static const String updateUserView = '$_host/admin/updateuser.php'; // Endpoint untuk memperbarui data pengguna
  static const String deleteUserView = '$_host/admin/deleteuser.php'; // Endpoint untuk menghapus data pengguna

  // Helper function to handle HTTP POST requests
  static Future<Map<String, dynamic>> post(String url, Map<String, String> body) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to connect to the server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during HTTP POST: $e');
    }
  }

  // Helper function to handle HTTP GET requests
  static Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to connect to the server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during HTTP GET: $e');
    }
  }

  // Register User
  static Future<Map<String, dynamic>> registerUser(Map<String, String> body) async {
    return await post(register, body);
  }

  // Login User
  static Future<Map<String, dynamic>> loginUser(Map<String, String> body) async {
    return await post(login, body);
  }

  // Fetch user data from userView endpoint
  static Future<Map<String, dynamic>> fetchUserData() async {
    return await get(userView);  // Mengambil data pengguna dari API
  }

  // Update user data
  static Future<Map<String, dynamic>> updateUser(Map<String, String> body) async {
    return await post(updateUserView, body);
  }

  // Delete user data
  static Future<Map<String, dynamic>> deleteUser(Map<String, String> body) async {
    return await post(deleteUserView, body);
  }
}
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttercrud/config/Api.dart';
import 'package:fluttercrud/model/User.dart';
import 'package:fluttercrud/services/shared_preferences.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  List<User> users = [];
  String loggedInUser = ""; // Variabel untuk menyimpan nama pengguna yang sedang login
  String loginTime = ""; // Variabel untuk menyimpan waktu login
  String duration = ""; // Variabel untuk menyimpan durasi login

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _getLoggedInUser();
  }

  // Mengambil data pengguna yang sedang login dari SharedPreferences
  Future<void> _getLoggedInUser() async {
    final user = await SharedPreferencesService().getLoggedInUser();
    final login = await SharedPreferencesService().getLoginTime();

    setState(() {
      loggedInUser = user ?? "Tidak ada pengguna yang login";
      if (login != null) {
        // loginTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(login));   
        duration = _calculateDuration(DateTime.parse(login), DateTime.now());
      } else {
        loginTime = "Tidak ada data login";
      }
    });
  }

  // Menghitung durasi login
  String _calculateDuration(DateTime loginTime, DateTime currentTime) {
    final difference = currentTime.difference(loginTime);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    return "${hours} jam ${minutes} menit";
  }

  // Fetch users from API
  Future<void> _fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(Api.userView));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data != null) {
          setState(() {
            users = data.map((e) => User.fromJson(e)).toList();
          });
        } else {
          _showErrorDialog('No users found');
        }
      } else {
        _showErrorDialog('Error fetching users');
      }
    } catch (e) {
      _showErrorDialog('Terjadi kesalahan: $e');
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  // Fungsi Logout dengan konfirmasi Ya/Tidak
  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi Logout"),
        content: Text("Apakah Anda yakin ingin logout?"),
        actions: [
          TextButton(
            onPressed: () async {
              await SharedPreferencesService().setLogoutTime();
              await SharedPreferencesService().clearLoggedInUser();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text("Ya"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Tidak"),
          ),
        ],
      ),
    );
  }

  // Show success dialog
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _fetchUsers(); // Refresh the list after success
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  // Hapus pengguna
  Future<void> _deleteUser(int userId) async {
    try {
      final response = await http.post(
        Uri.parse(Api.deleteUserView),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': userId}),
      );

      if (response.statusCode == 200) {
        _showSuccessDialog('Data berhasil dihapus');
      } else {
        _showErrorDialog('Failed to delete user');
      }
    } catch (e) {
      _showErrorDialog('Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User View"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Tombol logout
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFDD0), // Ungu
              Color(0xFF3B7EF5), // Biru
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column( 
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pengguna yang login: $loggedInUser',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Waktu login: $loginTime',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Durasi login: $duration',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Daftar Member',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                        title: Text(user.userName),
                        subtitle: Text(user.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/updateUserView',
                                  arguments: user, // Passing user data to the update page
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteUser(user.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
            onPressed: () {
            Navigator.pushReplacementNamed(context, '/register');
            },
            style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            ),
              child: const Text(
              'Tambahkan Member',
              style: TextStyle(fontSize: 16),
              ),
            ),
            ),
              ]
        )
      )
              
    );
        
  }
}

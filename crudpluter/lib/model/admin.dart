// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:fluttercrud/config/Api.dart';

// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({Key? key}) : super(key: key);

//   @override
//   State<AdminDashboard> createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   List<dynamic> users = [];
//   List<dynamic> absensi = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchUsers();
//     _fetchAbsensi();
//   }

//   Future<void> _fetchUsers() async {
//     try {
//       final response = await http.get(Uri.parse(Api.userView));
//       if (response.statusCode == 200) {
//         setState(() {
//           users = jsonDecode(response.body);
//         });
//       } else {
//         _showErrorDialog("Gagal mengambil data pengguna.");
//       }
//     } catch (e) {
//       _showErrorDialog("Terjadi kesalahan: $e");
//     }
//   }

//   Future<void> _fetchAbsensi() async {
//     try {
//       final response = await http.get(Uri.parse(Api.absensiView));
//       if (response.statusCode == 200) {
//         setState(() {
//           absensi = jsonDecode(response.body);
//         });
//       } else {
//         _showErrorDialog("Gagal mengambil data absensi.");
//       }
//     } catch (e) {
//       _showErrorDialog("Terjadi kesalahan: $e");
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Error"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Dashboard Admin"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const Text(
//               "Daftar Pengguna",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             ListView.builder(
//               shrinkWrap: true,
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 final user = users[index];
//                 return ListTile(
//                   title: Text(user['username']),
//                   subtitle: Text(user['email']),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.edit),
//                         onPressed: () {
//                           // Navigasi ke halaman edit user
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () {
//                           // Tambahkan fungsi hapus user
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "Daftar Absensi",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             ListView.builder(
//               shrinkWrap: true,
//               itemCount: absensi.length,
//               itemBuilder: (context, index) {
//                 final data = absensi[index];
//                 return ListTile(
//                   title: Text("User ID: ${data['user_id']}"),
//                   subtitle: Text("Check-in: ${data['check_in']}"),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

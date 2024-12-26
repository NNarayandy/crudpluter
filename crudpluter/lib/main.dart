import 'package:flutter/material.dart';
import 'package:fluttercrud/pages/admin/updateUserView.dart';
import 'package:fluttercrud/pages/admin/userview.dart';
import 'package:fluttercrud/pages/login/login.dart';
import 'package:fluttercrud/pages/login/register.dart';
import 'package:fluttercrud/model/User.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cihuy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Halaman pertama yang akan muncul
      routes: {
        '/register': (context) => Register(), // Halaman Register
        '/login': (context) => LoginScreen(), // Halaman Login
        '/userView': (context) => UserView(), // Halaman UserView setelah Login
        // '/admin': (context) => AdminView(),

        '/updateUserView': (context) {
          final user = ModalRoute.of(context)?.settings.arguments as User?;
          if (user == null) {
            // Jika data User null, tampilkan error atau kembali ke halaman sebelumnya
            return const Scaffold(
              body: Center(
                child: Text('Data user tidak valid'),
              ),
            );
          }
          return UpdateUserView(user: user); // Mengirim data user ke halaman UpdateUserView
        },
      },
      onUnknownRoute: (settings) {
        // Jika route tidak ditemukan, tampilkan halaman fallback
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Halaman tidak ditemukan'),
            ),
          ),
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
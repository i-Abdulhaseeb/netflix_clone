import 'package:flutter/material.dart';
import 'package:netflix_clone/login_page.dart';

void main() {
  runApp(const NetflixCloneApp());
}

class NetflixCloneApp extends StatelessWidget {
  const NetflixCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hide debug banner
      title: 'Netflix Clone',
      theme: ThemeData(
        fontFamily: 'Roboto', // optional for a clean look
      ),
      home: const LoginPage(),
    );
  }
}

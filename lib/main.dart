import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart'; // import ของคุณ

void main() {
  runApp(const SimpleTodoApp());
}

class SimpleTodoApp extends StatefulWidget {
  const SimpleTodoApp({super.key});

  @override
  State<SimpleTodoApp> createState() => _SimpleTodoAppState();
}

class _SimpleTodoAppState extends State<SimpleTodoApp> {
  String? _username;

  void _handleLogin(String username, String password) {
    setState(() {
      _username = username;
    });
  }

  void _handleLogout() {
    setState(() {
      _username = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_username == null) {
      return MaterialApp(
        title: 'Simple Login App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LoginScreen(onLogin: _handleLogin),
      );
    }

    return MaterialApp(
      title: 'Simple Login App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(
        onLogout: _handleLogout, // ถ้า HomeScreen รับ onLogout
      ),
    );
  }
}

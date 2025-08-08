import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

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
    // สำหรับตอนนี้ยังไม่ตรวจสอบรหัสผ่านจริง
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

    // หน้า logged in แบบง่าย ๆ มีปุ่ม Logout
    return MaterialApp(
      title: 'Simple Login App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text('ยินดีต้อนรับ $_username'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _handleLogout,
              tooltip: 'Logout',
            ),
          ],
        ),
        body: Center(
          child: Text('คุณเข้าสู่ระบบเรียบร้อยแล้ว'),
        ),
      ),
    );
  }
}

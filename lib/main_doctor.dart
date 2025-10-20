import 'package:flutter/material.dart';
import 'screens/doctor/login_screen.dart';

void main() {
  runApp(const DoctorApp());
}

class DoctorApp extends StatelessWidget {
  const DoctorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TeleConsult Doctor',
      home: LoginScreen(),
    );
  }
}

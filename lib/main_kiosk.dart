import 'package:flutter/material.dart';
import 'screens/kiosk/patient_form_screen.dart';

void main() {
  runApp(const KioskApp());
}

class KioskApp extends StatelessWidget {
  const KioskApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TeleConsult Kiosk',
      home: PatientFormScreen(),
    );
  }
}

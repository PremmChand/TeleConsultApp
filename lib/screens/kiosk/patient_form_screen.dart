import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teleconsult_app/screens/kiosk/queue_screen.dart';
import 'package:uuid/uuid.dart';
import '../../models/patient.dart';
import '../widgets/custom_button.dart';
import '../widgets/input_field.dart';

class PatientFormScreen extends StatefulWidget {
  const PatientFormScreen({super.key});
  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _phone = TextEditingController();
  final _symptoms = TextEditingController();
  final uuid = const Uuid();

  void _callDoctor() {
    if (!_formKey.currentState!.validate()) return;

    final patient = Patient(
      id: uuid.v4(),
      name: _name.text.trim(),
      age: int.tryParse(_age.text.trim()) ?? 0,
      phone: _phone.text.trim(),
      symptoms: _symptoms.text.trim(),
    );

    // Navigate to Queue Screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QueueScreen(patient: patient)),
    );

    // Clear form after submit
    _formKey.currentState!.reset();
    _name.clear();
    _age.clear();
    _phone.clear();
    _symptoms.clear();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 3) return 'Enter at least 3 characters';
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.trim().isEmpty) return 'Age is required';
    final age = int.tryParse(value.trim());
    if (age == null || age <= 0 || age > 99) return 'Enter valid age (max 2 digits)';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    final pattern = RegExp(r'^[6-9]\d{9}$'); // exactly 10 digits
    if (!pattern.hasMatch(value.trim())) return 'Enter valid 10-digit phone';
    return null;
  }

  String? _validateSymptoms(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please describe your symptoms';
    if (value.trim().length < 5) return 'Describe symptoms in more detail';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Kiosk')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Patient Details',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              InputField(
                controller: _name,
                label: 'Name',
                validator: _validateName,
              ),
              const SizedBox(height: 16),
              InputField(
                controller: _age,
                label: 'Age',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2), // max 2 digits
                ],
                validator: _validateAge,
              ),
              const SizedBox(height: 16),
              InputField(
                controller: _phone,
                label: 'Phone',
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10), // exactly 10 digits
                ],
                validator: _validatePhone,
              ),
              const SizedBox(height: 16),
              InputField(
                controller: _symptoms,
                label: 'Symptoms',
                maxLines: 4,
                validator: _validateSymptoms,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Call Doctor',
                onPressed: _callDoctor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

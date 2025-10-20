import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/pdf_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/input_field.dart';

class PrescriptionFormScreen extends StatefulWidget {
  final String patientName;
  const PrescriptionFormScreen({super.key, required this.patientName});

  @override
  State<PrescriptionFormScreen> createState() => _PrescriptionFormScreenState();
}

class _PrescriptionFormScreenState extends State<PrescriptionFormScreen> {
  final _diag = TextEditingController();
  final _med = TextEditingController();
  bool _loading = false;

  Future<void> _generateAndSend() async {
    final diag = _diag.text.trim();
    final med = _med.text.trim();
    if (diag.isEmpty || med.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill diagnosis and medicine')));
      return;
    }
    setState(() => _loading = true);
    final File pdfFile = await PDFService.generatePrescription(widget.patientName, diag, med);
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF generated (mock)')));

    // Mock "Send to WhatsApp" — open share URL or use url_launcher to open WhatsApp with text
    final text = Uri.encodeComponent('Prescription for ${widget.patientName}\nDiagnosis: $diag\nMedicine: $med\n(PDF saved at ${pdfFile.path})');
    final whatsappUrl = Uri.parse("https://wa.me/?text=$text");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open WhatsApp (mock)')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prescription Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Text('Patient: ${widget.patientName}', style: const TextStyle(fontSize: 18)),
          InputField(controller: _diag, label: 'Diagnosis', maxLines: 3),
          InputField(controller: _med, label: 'Medicine', maxLines: 3),
          const SizedBox(height: 12),
          _loading ? const CircularProgressIndicator() : CustomButton(text: 'Generate PDF & Send to WhatsApp (Mock)', onPressed: _generateAndSend),
        ]),
      ),
    );
  }
}

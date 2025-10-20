import 'package:flutter/material.dart';

class IncomingCallPopup extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const IncomingCallPopup({super.key, required this.onAccept, required this.onReject});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Incoming Consultation'),
      content: const Text('A patient is requesting a video consultation.'),
      actions: [
        TextButton(onPressed: onReject, child: const Text('Reject')),
        ElevatedButton(onPressed: onAccept, child: const Text('Accept')),
      ],
    );
  }
}

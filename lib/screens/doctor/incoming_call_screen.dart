import 'package:flutter/material.dart';
import '../common/video_call_screen.dart';

class IncomingCallScreen extends StatelessWidget {
  // Mocked doctor details (in real app this can come from login or backend)
  final String doctorID;
  final String doctorName;
  final String callID;

  const IncomingCallScreen({
    super.key,
    this.doctorID = "doctor_001",
    this.doctorName = "Dr. Prem",
    this.callID = "tele_consult_room_1",
  });

  void acceptCall(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoCallScreen(
          userID: doctorID,
          userName: doctorName,
          callID: callID,
          isDoctor: true,
        ),
      ),
    );
  }

  void rejectCall(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Call Rejected')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Incoming Video Call',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  doctorName,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.call, color: Colors.white),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () => acceptCall(context),
                      label: const Text('Accept'),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.call_end, color: Colors.white),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => rejectCall(context),
                      label: const Text('Reject'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

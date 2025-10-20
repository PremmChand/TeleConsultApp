import 'package:flutter/material.dart';
// import 'package:teleconsult_app/services/video_service.dart';
// import 'package:teleconsult_app/utils/app_constants.dart';
// import 'package:teleconsult_app/widgets/custom_button.dart';
import '../services/video_service.dart';
import '../utils/app_constants.dart';
import '../widgets/custom_button.dart';
import 'incoming_call_popup.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  void _simulateIncomingCall(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => IncomingCallPopup(
        onAccept: () {
          Navigator.of(context).pop();
          VideoService.joinCall(
            context,
            userID: AppConstants.doctorUserId,
            userName: AppConstants.doctorUserName,
          );
        },
        onReject: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Call Rejected')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.primaryColor,
        title: const Text('Doctor Home'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // 👨‍⚕️ Header
            Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.primaryColor.withOpacity(0.15),
                  child: Icon(
                    Icons.medical_services_rounded,
                    color: theme.primaryColor,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Welcome, Doctor!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Manage your teleconsultations easily',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 📊 Dashboard Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.dashboard_rounded,
                            color: theme.primaryColor, size: 28),
                        const SizedBox(width: 10),
                        Text(
                          'Doctor Dashboard (Mock)',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 📞 Incoming call simulation
                    CustomButton(
                      text: 'Simulate Incoming Call',
                      icon: Icons.call,
                      onPressed: () => _simulateIncomingCall(context),
                    ),
                    const SizedBox(height: 12),

                    // 🚀 Direct join call
                    // CustomButton(
                    //   text: 'Join Room as Doctor',
                    //   icon: Icons.video_call_rounded,
                    //   onPressed: () {
                    //     VideoService.joinCall(
                    //       context,
                    //       userID: AppConstants.doctorUserId,
                    //       userName: AppConstants.doctorUserName,
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 👣 Footer or tip
            Text(
              'Tip: Keep your device camera & mic ready before joining a call.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

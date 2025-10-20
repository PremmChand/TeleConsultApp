import 'package:flutter/material.dart';
import '../../models/patient.dart';
import '../utils/app_constants.dart';
import '../widgets/custom_button.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class QueueScreen extends StatefulWidget {
  final Patient patient;
  const QueueScreen({super.key, required this.patient});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  bool doctorAvailable = false;
  bool callEnded = false;

  @override
  void initState() {
    super.initState();
    // Simulate doctor availability
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        doctorAvailable = true;
      });
    });
  }

  void _joinCall() async {
    // Navigate to patient video call and wait for result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PatientVideoCallScreen(
          userID: widget.patient.id,
          userName: widget.patient.name,
          callID: AppConstants.defaultRoomID,
        ),
      ),
    );

    if (result == true) {
      setState(() {
        callEnded = true; // show WhatsApp message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Queue')),
      body: Center(
        child: callEnded
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 12),
            Text(
              'Your prescription will be sent to your WhatsApp',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        )
            : doctorAvailable
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Doctor is connecting...',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Connect Now',
              onPressed: _joinCall,
            ),
          ],
        )
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Doctor will connect shortly',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 12),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

// ------------------ Patient Video Call Screen ------------------

class PatientVideoCallScreen extends StatelessWidget {
  final String userID;
  final String userName;
  final String callID;

  const PatientVideoCallScreen({
    super.key,
    required this.userID,
    required this.userName,
    required this.callID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ZegoUIKitPrebuiltCall(
          appID: AppConstants.zegoAppID,
          appSign: AppConstants.zegoAppSign,
          userID: userID,
          userName: userName,
          callID: callID,
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            ..turnOnCameraWhenJoining = true
            ..turnOnMicrophoneWhenJoining = true,
          events: ZegoUIKitPrebuiltCallEvents(
            onCallEnd: (event, defaultAction) {
              // pop with result true to notify QueueScreen
              Navigator.pop(context, true);
            },
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../../models/patient.dart';
// import '../services/video_service.dart';
// import '../utils/app_constants.dart';
// import '../widgets/custom_button.dart';
// //import '../../services/video_service.dart';
// //import '../../constants/app_constants.dart';
// //import '../../widgets/custom_button.dart';
//
// class QueueScreen extends StatefulWidget {
//   final Patient patient;
//   const QueueScreen({super.key, required this.patient});
//
//   @override
//   State<QueueScreen> createState() => _QueueScreenState();
// }
//
// class _QueueScreenState extends State<QueueScreen> {
//   bool doctorAvailable = false; // simulate queue
//
//   @override
//   void initState() {
//     super.initState();
//     // Simulate waiting: doctor becomes available after 3 seconds
//     Future.delayed(const Duration(seconds: 3), () {
//       setState(() {
//         doctorAvailable = true;
//       });
//     });
//   }
//
//   void _connect() {
//     // Join call as patient
//     VideoService.joinCall(context, userID: widget.patient.id, userName: widget.patient.name, roomID: AppConstants.defaultRoomID);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Queue')),
//       body: Center(
//         child: doctorAvailable
//             ? Column(mainAxisSize: MainAxisSize.min, children: [
//           const Text('Doctor is connecting...', style: TextStyle(fontSize: 18)),
//           const SizedBox(height: 12),
//           CustomButton(text: 'Connect Now', onPressed: _connect),
//         ])
//             : Column(mainAxisSize: MainAxisSize.min, children: const [
//           Text('Doctor will connect shortly', style: TextStyle(fontSize: 18)),
//           SizedBox(height: 12),
//           CircularProgressIndicator(),
//         ]),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../doctor/prescription_screen.dart';
import '../utils/app_constants.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';


/// Incoming call simulation
class IncomingCallScreen extends StatelessWidget {
  final String doctorID;
  final String doctorName;
  final bool isDoctor;

  const IncomingCallScreen({
    super.key,
    required this.doctorID,
    required this.doctorName,
    this.isDoctor = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Incoming Call Simulation")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Simulate an incoming call popup
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                title: const Text("Incoming Call"),
                content: const Text("Patient John Doe is calling..."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Reject"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoCallScreen(
                            userID: doctorID,
                            userName: doctorName,
                            callID: AppConstants.defaultRoomID,
                            isDoctor: isDoctor,
                          ),
                        ),
                      );
                    },
                    child: const Text("Accept"),
                  ),
                ],
              ),
            );
          },
          child: const Text("Simulate Incoming Call"),
        ),
      ),
    );
  }
}

/// Video call screen with PDF + Share after call ends
class VideoCallScreen extends StatelessWidget {
  final String userID;
  final String userName;
  final String callID;
  final bool isDoctor;

  const VideoCallScreen({
    super.key,
    required this.userID,
    required this.userName,
    required this.callID,
    this.isDoctor = false,
  });

  /// Step 1. Generate prescription PDF
  Future<File> _createPrescriptionPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Padding(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'TeleConsult Prescription',
                style: pw.TextStyle(
                  fontSize: 26,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 24),
              pw.Text('Patient: $userName', style: const pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 16),
              pw.Text(
                'Prescription Details:\nMedicine: Paracetamol 500mg\nDosage: Twice daily\nDuration: 5 days',
                style: const pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 24),
              pw.Text('Consulted By: Dr. $userID', style: const pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.Text(
                'Thank you for using TeleConsult',
                style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/prescription_$userName.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Step 2. Open file share chooser (Gmail, WhatsApp, etc.)
  // Future<void> _openShareOptions(File pdfFile) async {
  //   try {
  //     await Share.shareXFiles(
  //       [XFile(pdfFile.path)],
  //       text: "Prescription for $userName",
  //     );
  //   } catch (e) {
  //     debugPrint("Error sharing PDF: $e");
  //   }
  // }

  //
  Future<void> _openShareOptions(File pdfFile) async {
    try {
      final isInstalled = await WhatsappShare.isInstalled(package: Package.whatsapp);

      // Convert path to proper accessible directory
      final shareFile = XFile(
        pdfFile.path,
        mimeType: 'application/pdf',
      );

      if (isInstalled == true) {
        await Future.delayed(const Duration(milliseconds: 800));
        await WhatsappShare.shareFile(
          phone: '919999595343', // use correct country code
          filePath: [pdfFile.path],
          text: "Prescription for $userName. Please see attached PDF.",
        );
      } else {
        // Fallback: use system share
        await Share.shareXFiles(
          [shareFile],
          text: "Prescription for $userName",
        );
      }
    } catch (e) {
      debugPrint("Error sharing via WhatsApp: $e");
      // Final fallback
      await Share.shareXFiles(
        [XFile(pdfFile.path, mimeType: 'application/pdf')],
        text: "Prescription for $userName",
      );
    }
  }


  // Future<void> _openShareOptions(File pdfFile) async {
  //   try {
  //     final isInstalled = await WhatsappShare.isInstalled(package: Package.whatsapp);
  //
  //     if (isInstalled == true) {
  //       // Small delay so navigation completes before opening WhatsApp
  //       await Future.delayed(const Duration(milliseconds: 800));
  //
  //       await WhatsappShare.shareFile(
  //         phone: '919999595343', // optional or provide number like '91XXXXXXXXXX'
  //         filePath: [pdfFile.path],
  //         text: "Prescription for $userName. Please see attached PDF.",
  //       );
  //     } else {
  //       // Fallback to normal share if WhatsApp is not available
  //       await Share.shareXFiles(
  //         [XFile(pdfFile.path)],
  //         text: "Prescription for $userName",
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint("Error sharing via WhatsApp: $e");
  //     await Share.shareXFiles(
  //       [XFile(pdfFile.path)],
  //       text: "Prescription for $userName",
  //     );
  //   }
  // }


  /// Step 3. Navigate to Prescription UI first
  Future<void> _navigateToPrescriptionThenShare(BuildContext context) async {
    // 1️⃣ Navigate to Prescription screen
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PrescriptionFormScreen(patientName: userName),
      ),
    );

    // 2️⃣ After navigation complete, delay slightly to ensure screen load
    await Future.delayed(const Duration(milliseconds: 600));

    // 3️⃣ Then generate & share PDF automatically
    final pdfFile = await _createPrescriptionPdf();
    await _openShareOptions(pdfFile);
  }

  /// Step 4. Handle video call end logic
  void _endCall(BuildContext context) {
    try {
      ZegoUIKitPrebuiltCallController().hangUp(context);
    } catch (e) {
      debugPrint("Hang-up error: $e");
    }
    _navigateToPrescriptionThenShare(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
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
                onCallEnd: (ZegoCallEndEvent event, VoidCallback defaultAction) {
                  _navigateToPrescriptionThenShare(context);
                },
              ),
            ),
          ),

          // Transparent top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text("Video Call - $userName"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => _endCall(context),
              ),
            ),
          ),

          // Bottom "End Call" for doctor
          if (isDoctor)
            Positioned(
              bottom: 25,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.call_end),
                  label: const Text("End & Go to Prescription"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  onPressed: () => _endCall(context),
                ),
              ),
            ),
        ],
      ),
    );
  }
}







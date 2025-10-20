import 'package:flutter/material.dart';

import '../common/video_call_screen.dart';
import '../utils/app_constants.dart';
import 'permission_service.dart';

class VideoService {
  // Join call after asking permissions; returns true if joined
  static Future<void> joinCall(BuildContext context, {required String userID, required String userName, String? roomID}) async {
    final ok = await PermissionService.requestCameraAndMic();
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Camera & mic permissions required')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoCallScreen(
          userID: userID,
          userName: userName,
          callID: roomID ?? AppConstants.defaultRoomID,
        ),
      ),
    );
  }
}

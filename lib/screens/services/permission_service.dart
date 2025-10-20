import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestCameraAndMic() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    final camera = statuses[Permission.camera];
    final mic = statuses[Permission.microphone];

    if (camera != null && mic != null && camera.isGranted && mic.isGranted) {
      return true;
    }
    return false;
  }
}

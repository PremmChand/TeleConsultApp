class AuthService {
  // Mocked login: username "doctor", password "1234"
  static Future<bool> loginDoctor(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 300)); // simulate latency
    return username == 'doctor' && password == '1234';
  }
}

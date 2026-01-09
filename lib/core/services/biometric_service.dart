import 'dart:async';

// STUBBED FOR BYPASS (File Lock on local_auth)
class BiometricService {
  Future<bool> get isAvailable async {
    return true; // Mock availability
  }

  Future<bool> authenticate() async {
    // Mock successful authentication
    await Future.delayed(const Duration(milliseconds: 500));
    return true; 
  }
}

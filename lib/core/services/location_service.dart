import 'dart:async';
import 'package:neuvox/core/constants/app_strings.dart';

class LocationService {
  // Mock Location (Redmond, WA - Microsoft Campus)
  static const double _mockLat = 47.6423;
  static const double _mockLng = -122.1369;

  Future<Map<String, double>> getCurrentLocation() async {
    // Simulate GPS Latency
    await Future.delayed(const Duration(seconds: 2));
    return {
      'lat': _mockLat,
      'lng': _mockLng,
    };
  }

  Future<bool> sendEmergencySms(String phone, double lat, double lng) async {
    // Simulate Network Request to Twilio/Azure Communication Services
    await Future.delayed(const Duration(seconds: 1));
    return true; 
  }
}

import 'dart:async';

class AzureConfig {
  final String tenantId;
  final String clientId;
  final String iotHubUrl;

  const AzureConfig({
    required this.tenantId,
    required this.clientId,
    required this.iotHubUrl,
  });
}

class AzureService {
  final AzureConfig config;
  bool _isAuthenticated = false;

  AzureService(this.config);

  bool get isAuthenticated => _isAuthenticated;

  /// Simulates MSAL (Microsoft Authentication Library) login
  Future<bool> login() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    print('[Azure] User authenticated via Entra ID: ${config.tenantId}');
    return true;
  }

  /// Sends telemetry to Azure IoT Hub via MQTT (Simulated)
  Future<void> sendTelemetry(Map<String, dynamic> payload) async {
    if (!_isAuthenticated) return;
    // In a real app, this would use mqtt_client to publish to IoTHub
    print('[IoT Hub] Sent packet: ${payload.keys.join(',')} -> ${config.iotHubUrl}');
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    print('[Azure] User logged out.');
  }
}

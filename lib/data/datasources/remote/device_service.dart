import 'dart:async';

class DeviceService {
  Stream<DeviceStatus> getDeviceStatusStream() {
    return Stream.periodic(
      const Duration(seconds: 5),
      (count) => DeviceStatus(
        isConnected: true,
        batteryPercentage: 100 - (count % 80),
        signalStrength: 80 + (count % 20),
        lastUpdated: DateTime.now(),
      ),
    );
  }
  
  Future<bool> connectDevice(String deviceId) async {
    await Future.delayed(const Duration(seconds: 3));
    return true;
  }
  
  Future<void> disconnectDevice() async {
    await Future.delayed(const Duration(seconds: 1));
  }
  
  Future<DeviceInfo> getDeviceInfo() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return DeviceInfo(
      deviceId: 'NVX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      modelName: 'NeuVox Smart Glasses v1',
      firmwareVersion: '1.0.2',
      lastSync: DateTime.now(),
    );
  }
}

class DeviceStatus {
  final bool isConnected;
  final int batteryPercentage;
  final int signalStrength;
  final DateTime lastUpdated;
  
  DeviceStatus({
    required this.isConnected,
    required this.batteryPercentage,
    required this.signalStrength,
    required this.lastUpdated,
  });
}

class DeviceInfo {
  final String deviceId;
  final String modelName;
  final String firmwareVersion;
  final DateTime lastSync;
  
  DeviceInfo({
    required this.deviceId,
    required this.modelName,
    required this.firmwareVersion,
    required this.lastSync,
  });
}
class AppStrings {
  // Titles
  static const String appTitle = 'NeuVox';
  static const String systemStatusOnline = 'SYSTEM ONLINE';
  static const String systemStatusOffline = 'SYSTEM OFFLINE';
  
  // Communication States
  static const String stateIdle = 'IDLE';
  static const String stateListening = 'LISTENING FOR INTENT';
  static const String stateProcessing = 'PROCESSING NEURAL PATTERNS';
  static const String stateSpeaking = 'VOCALIZING';
  static const String stateComplete = 'COMPLETE';
  static const String stateAwaiting = 'AWAITING INPUT';
  
  // UI Visuals
  static const String patternClassifying = 'CLASSIFYING PATTERN...';
  static const String confidenceHigh = 'CONFIDENCE > 85%';
  static const String outputLabel = 'OUTPUT:';
  static const String channelActive = 'CH-1: ACTIVE';
  static const String bandwidth = 'BW: 200Hz';
  
  // Manual Input
  static const String manualOverrideLabel = 'MANUAL OVERRIDE';
  static const String typeToSpeak = 'Type to speak...';
  
  // Emergency
  static const String sosLabel = 'SOS';
  static const String emergencyAlert = 'MEDICAL EMERGENCY DETECTED';
  
  // Demo / Debug
  static const String demoModeActive = 'DEMO MODE ACTIVE';
}

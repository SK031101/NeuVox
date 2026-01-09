class PreferencesService {
  final Map<String, dynamic> _prefs = {};
  
  Future<void> setBool(String key, bool value) async {
    _prefs[key] = value;
  }
  
  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    return _prefs[key] as bool? ?? defaultValue;
  }
  
  Future<void> setString(String key, String value) async {
    _prefs[key] = value;
  }
  
  Future<String?> getString(String key) async {
    return _prefs[key] as String?;
  }
  
  Future<void> setInt(String key, int value) async {
    _prefs[key] = value;
  }
  
  Future<int?> getInt(String key) async {
    return _prefs[key] as int?;
  }
  
  Future<void> clear() async {
    _prefs.clear();
  }
  
  Future<bool> isFirstLaunch() async {
    return await getBool('first_launch', defaultValue: true);
  }
  
  Future<void> setFirstLaunchComplete() async {
    await setBool('first_launch', false);
  }
  
  Future<bool> hasCompletedOnboarding() async {
    return await getBool('onboarding_complete', defaultValue: false);
  }
  
  Future<void> setOnboardingComplete() async {
    await setBool('onboarding_complete', true);
  }
}
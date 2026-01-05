import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/di/service_locator.dart' as di;
import 'presentation/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Service Locator
  await di.init();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  runApp(const NeuVoxApp());
}

class NeuVoxApp extends StatelessWidget {
  const NeuVoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuVox',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // themeMode: ThemeMode.dark, // Enforce dark mode as primary
      
      // TODO: Implement Routing
      home: const SplashScreen(),
    );
  }
}
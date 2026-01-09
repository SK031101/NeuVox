import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/di/service_locator.dart' as di;
import 'presentation/pages/splash_screen.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/communication_provider.dart';
import 'presentation/pages/home_screen.dart';
import 'presentation/pages/login_screen.dart';
import 'presentation/pages/onboarding/medical_intake_screen.dart';
import 'presentation/pages/onboarding/emergency_setup_screen.dart';
import 'presentation/pages/voice_studio_screen.dart';
import 'presentation/pages/train_screen.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<CommunicationProvider>()),
      ],
      child: MaterialApp(
        title: 'NeuVox',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/medical_intake': (context) => const MedicalIntakeScreen(),
          '/emergency_setup': (context) => const EmergencySetupScreen(),
          '/voice_studio': (context) => const VoiceStudioScreen(),
          '/train': (context) => const TrainScreen(),
        },
        // home: const SplashScreen(), // using initialRoute instead
      ),
    );
  }
}
import 'dart:math';
import '../../domain/services/ai_service.dart';

class AiServiceImpl implements AiService {
  final List<String> _intents = [
    "I need water.",
    "I am experiencing pain.",
    "Please call the nurse.",
    "I would like to go outside.",
    "Turn off the lights, please."
  ];

  @override
  Future<String> determineIntent() async {
    // Simulate processing time
    await Future.delayed(const Duration(seconds: 3));
    
    // Return random intent
    return _intents[Random().nextInt(_intents.length)];
  }
}

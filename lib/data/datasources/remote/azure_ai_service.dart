import 'dart:async';

class AzureAIService {
  Future<InterpretationResult> interpretEEGSignal(List<double> eegData) async {
    await Future.delayed(const Duration(seconds: 2));
    
    final interpretations = [
      'I would like some water',
      'I need help',
      'Yes, I agree',
      'No, thank you',
      'I am feeling tired',
      'Can we talk later?',
      'I appreciate your help',
      'I want to rest now',
    ];
    
    final randomIndex = DateTime.now().second % interpretations.length;
    
    return InterpretationResult(
      text: interpretations[randomIndex],
      confidence: 0.85 + (DateTime.now().millisecond % 15) / 100,
      timestamp: DateTime.now(),
    );
  }
  
  Future<List<String>> getSuggestions(String context) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      'Yes',
      'No',
      'Help',
      'Water',
      'Rest',
    ];
  }
}

class InterpretationResult {
  final String text;
  final double confidence;
  final DateTime timestamp;
  
  InterpretationResult({
    required this.text,
    required this.confidence,
    required this.timestamp,
  });
}
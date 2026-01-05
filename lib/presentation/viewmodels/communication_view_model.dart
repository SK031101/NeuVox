import 'package:flutter/foundation.dart';
import '../../data/repositories/ai_repository_impl.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, required this.timestamp});
}

class CommunicationViewModel extends ChangeNotifier {
  final AIRepositoryImpl _aiRepository = AIRepositoryImpl(); // Ideally injected via DI
  
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    _messages.add(ChatMessage(text: text, isUser: true, timestamp: DateTime.now()));
    _isTyping = true;
    notifyListeners();

    // Call AI Service
    final result = await _aiRepository.generateResponse(text);

    result.fold(
      (failure) {
        // Handle error
        _messages.add(ChatMessage(text: "Error: ${failure.message}", isUser: false, timestamp: DateTime.now()));
      },
      (response) {
        // Add AI response
        _messages.add(ChatMessage(text: response, isUser: false, timestamp: DateTime.now()));
      },
    );

    _isTyping = false;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

/// Clean minimal AI chat screen — single declaration only.
class AIChatScreen extends StatefulWidget {
  const AIChatScreen({Key? key}) : super(key: key);

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final List<_Message> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isAIThinking = false;

  @override
  void initState() {
    super.initState();
    _messages.add(_Message(text: 'Hello — ready to help.', fromAI: true));
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(text: text, fromAI: false));
      _inputController.clear();
      _isAIThinking = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _messages.add(_Message(text: 'AI: $text', fromAI: true));
        _isAIThinking = false;
      });
      _scrollToBottom();
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 60,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Chat')),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: _messages.length + (_isAIThinking ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length && _isAIThinking) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(children: [CircularProgressIndicator(strokeWidth: 2), SizedBox(width: 8), Text('AI is thinking...')]),
                  ),
                );
              }
              final msg = _messages[index];
              return Align(
                alignment: msg.fromAI ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: msg.fromAI ? Colors.grey[200] : Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(msg.text, style: TextStyle(color: msg.fromAI ? Colors.black87 : Theme.of(context).colorScheme.onPrimary)),
                ),
              );
            },
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  decoration: const InputDecoration(hintText: 'Type a message', border: OutlineInputBorder()),
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _send, child: const Text('Send')),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _Message {
  final String text;
  final bool fromAI;
  _Message({required this.text, required this.fromAI});
}

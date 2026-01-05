import 'package:flutter/material.dart';
import 'package:neuvox/core/constants/app_colors.dart';
import 'package:neuvox/presentation/widgets/gradient_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../viewmodels/communication_view_model.dart';

class CommunicationScreen extends StatelessWidget {
  const CommunicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CommunicationViewModel(),
      child: const _CommunicationScreenContent(),
    );
  }
}

class _CommunicationScreenContent extends StatefulWidget {
  const _CommunicationScreenContent();

  @override
  State<_CommunicationScreenContent> createState() => _CommunicationScreenContentState();
}

class _CommunicationScreenContentState extends State<_CommunicationScreenContent> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CommunicationViewModel>();

    // Auto scroll to bottom when messages change
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return GradientScaffold(
      appBar: AppBar(
        title: const Text("AI Communicator"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.volume_up), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Chat Area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: viewModel.messages.length + (viewModel.isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == viewModel.messages.length) {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: _ThinkingIndicator(),
                  );
                }
                final msg = viewModel.messages[index];
                return _ChatBubble(message: msg);
              },
            ),
          ),

          // Quick Suggestions (Horizontal Scroll)
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _SuggestionChip(label: "I need water", onTap: () => viewModel.sendMessage("water")),
                _SuggestionChip(label: "I am in pain", onTap: () => viewModel.sendMessage("pain")),
                _SuggestionChip(label: "Turn off lights", onTap: () => viewModel.sendMessage("lights")),
                _SuggestionChip(label: "Call Nurse", onTap: () => viewModel.sendMessage("nurse")),
              ],
            ),
          ),
          
          const SizedBox(height: 10),

          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              border: const Border(top: BorderSide(color: Colors.white10)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type thoughts...",
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onSubmitted: (val) {
                      viewModel.sendMessage(val);
                      _controller.clear();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton( // Send Button
                  onPressed: () {
                    viewModel.sendMessage(_controller.text);
                    _controller.clear();
                  },
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? AppColors.accent : AppColors.backgroundLight,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(2),
            bottomRight: isUser ? const Radius.circular(2) : const Radius.circular(20),
          ),
          border: isUser ? null : Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Text(
          message.text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ).animate().fade().slideY(begin: 10, duration: 300.ms);
  }
}

class _ThinkingIndicator extends StatelessWidget {
  const _ThinkingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dot(0),
          const SizedBox(width: 4),
          _dot(200),
          const SizedBox(width: 4),
          _dot(400),
        ],
      ),
    );
  }

  Widget _dot(int delay) {
    return Container(
      width: 8, height: 8,
      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.2, 1.2), delay: Duration(milliseconds: delay), duration: 600.ms);
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SuggestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Center(
            child: Text(label, style: const TextStyle(color: Colors.white))
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:neuvox/core/constants/app_colors.dart';
import 'package:neuvox/presentation/widgets/gradient_scaffold.dart';

class VoiceStudioScreen extends StatefulWidget {
  const VoiceStudioScreen({super.key});

  @override
  State<VoiceStudioScreen> createState() => _VoiceStudioScreenState();
}

class _VoiceStudioScreenState extends State<VoiceStudioScreen> {
  bool _isRecording = false;
  double _progress = 0.0;
  final int _requiredSamples = 5;
  int _completedSamples = 0;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "Voice Studio",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Create your Digital Voice Twin using Azure Custom Neural Voice.",
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              
              const SizedBox(height: 48),
              
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                    color: _isRecording ? AppColors.accent.withOpacity(0.2) : Colors.transparent,
                  ),
                  child: Icon(
                    _isRecording ? Icons.mic : Icons.mic_none,
                    size: 80,
                    color: _isRecording ? AppColors.accent : Colors.white54,
                  ).animate(target: _isRecording ? 1 : 0).scale(end: const Offset(1.1, 1.1), duration: 1.seconds),
                ),
              ),
              
              const SizedBox(height: 32),
              
              if (_completedSamples < _requiredSamples)
                Column(
                  children: [
                    Text(
                      "Read the following phrase:",
                      style: TextStyle(color: Colors.white54),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "\"The quick brown fox jumps over the lazy dog.\"",
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              else
                Column(
                   children: [
                     const Icon(Icons.check_circle, color: Colors.green, size: 48),
                     const SizedBox(height: 16),
                     const Text(
                       "Voice Profile Ready for Training",
                       style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
                     ),
                     const SizedBox(height: 8),
                     Text(
                       "Estimated Azure Training Time: 2 hours",
                       style: TextStyle(color: Colors.white54),
                     ),
                   ],
                ).animate().fadeIn(),
              
              const Spacer(),
              
              if (_completedSamples < _requiredSamples)
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _toggleRecording,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRecording ? Colors.red : AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_isRecording ? "STOP RECORDING" : "START RECORDING"),
                  ),
                ),
                
              const SizedBox(height: 16),
              LinearProgressIndicator(
                 value: _completedSamples / _requiredSamples,
                 backgroundColor: Colors.white10,
                 color: AppColors.accent,
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  "$_completedSamples / $_requiredSamples Samples",
                  style: const TextStyle(color: Colors.white54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleRecording() async {
    if (_isRecording) {
      // Stop logic
      setState(() => _isRecording = false);
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => _completedSamples++);
    } else {
      setState(() => _isRecording = true);
    }
  }
}

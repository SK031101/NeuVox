import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:neuvox/core/constants/app_colors.dart';
import 'package:neuvox/core/constants/app_strings.dart';
import 'package:neuvox/presentation/widgets/gradient_scaffold.dart';
import '../../providers/communication_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neuro_capture/neuro_capture.dart';

import '../emergency_screen.dart';

class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({super.key});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {

  @override
  void initState() {
    super.initState();
    // Auto-start communication loop when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunicationProvider>().startCommunicationLoop();
    });
  }

  @override
  void dispose() {
    // Note: Provider disposal handled by DI container or parent widget
    super.dispose();
  }
  
  void _handleStop(BuildContext context) {
    context.read<CommunicationProvider>().stop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // SECURITY: Demo Triggers strictly isolated to Debug/Profile modes
    // RATIONALE: ISO 13485 Risk Control - prevents accidental override in production
    bool allowDemo = false;
    assert(() {
      allowDemo = true;
      return true;
    }());

    return RawKeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKey: (event) {
        if (!allowDemo) return; // Strict Gate
        if (event is! RawKeyDownEvent) return;
        
        final provider = context.read<CommunicationProvider>();
        if (event.logicalKey.keyLabel == '1') {
           provider.speakManually("Could I have some water, please?");
        } else if (event.logicalKey.keyLabel == '2') {
           provider.forceEmotion(EmotionalState.happy);
           provider.speakManually("I love you, Sarah. I am so proud of you.");
        } else if (event.logicalKey.keyLabel == '3') {
           provider.forceEmotion(EmotionalState.stressed);
           Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencyScreen()));
        }
      },
      child: GradientScaffold(
        body: SafeArea(
          child: Consumer<CommunicationProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                   // ... UI ...
                   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => _handleStop(context),
                          icon: const Icon(Icons.close, color: Colors.white, size: 30),
                          tooltip: "Close Communication", // A11y
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.red),
                          ),
                           child: GestureDetector(
                             onTap: () {
                               Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencyScreen()));
                             },
                             child: Row(
                             children: const [
                               Icon(Icons.warning, color: Colors.red, size: 16),
                               SizedBox(width: 4),
                               Text(AppStrings.sosLabel, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                             ],
                           )),
                        )
                      ],
                    ),
                  ),
                
                const Spacer(),
                
                // Central Visualization
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Center(child: _buildStateVisual(provider)),
                ),
                
                // State Label
                Text(
                  _getStateLabel(provider.state),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ).animate(target: provider.state == CommunicationState.listening ? 1 : 0)
                 .shimmer(duration: 2.seconds, color: AppColors.accent),
                
                const Spacer(),
                
                // Output Text / Confidence
                if (provider.state == CommunicationState.speaking || provider.state == CommunicationState.completed)
                   Padding(
                     padding: const EdgeInsets.all(24.0),
                     child: Text(
                       "\"${provider.currentIntent}\"",
                       textAlign: TextAlign.center,
                       style: const TextStyle(
                         color: Colors.white,
                         fontSize: 28,
                         fontWeight: FontWeight.w300,
                         fontStyle: FontStyle.italic,
                       ),
                     ).animate().fadeIn().moveY(begin: 20),
                   )
                else if (provider.state == CommunicationState.processing)
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        "Processing Neural Signals...",
                        style: TextStyle(color: AppColors.primary.withOpacity(0.8), fontSize: 18),
                      ).animate(onPlay: (c) => c.repeat()).shimmer(),
                    ),
                    
                const Spacer(),
                
                // Manual Text Input (Backup)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("MANUAL OVERRIDE", style: TextStyle(color: AppColors.textSecondary, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Type to speak...",
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                          filled: true,
                          fillColor: AppColors.backgroundLight,
                          suffixIcon: IconButton(
                             icon: const Icon(Icons.send, color: AppColors.primary),
                             onPressed: () {
                               // TODO: Hook up manual text input to provider
                               // provider.speakText(controller.text);
                             },
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        onSubmitted: (val) {
                           if (val.isNotEmpty) {
                              provider.speakManually(val); 
                           }
                        },
                      ),
                    ],
                  ),
                ),

                // Controls
                // Maybe a manual "Speak" confirm button?
                 Padding(
                   padding: const EdgeInsets.only(bottom: 32.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       if (provider.state == CommunicationState.completed)
                         ElevatedButton.icon(
                           onPressed: () => provider.startCommunicationLoop(),
                           icon: const Icon(Icons.refresh),
                           label: const Text("NEW THOUGHT"),
                           style: ElevatedButton.styleFrom(
                             backgroundColor: AppColors.backgroundLight,
                             foregroundColor: Colors.white,
                           ),
                         ).animate().fadeIn(),
                     ],
                   ),
                 ),
              ],
            );
          },
        ),
      ),
    ));
  }

  String _getStateLabel(CommunicationState state) {
    switch (state) {
      case CommunicationState.listening: return AppStrings.stateListening;
      case CommunicationState.processing: return AppStrings.stateProcessing;
      case CommunicationState.speaking: return AppStrings.stateSpeaking;
      case CommunicationState.completed: return AppStrings.stateComplete;
      default: return AppStrings.stateIdle;
    }
  }

  Widget _buildStateVisual(CommunicationProvider provider) {
    // SEMANTICS: A11y tree announcement for blind users
    return Semantics(
      label: "System Status: ${_getStateLabel(provider.state)}",
      liveRegion: true, // Auto-announce changes
      child: Container(
         width: double.infinity,
         height: 250,
         decoration: BoxDecoration(
           color: Colors.black,
           borderRadius: BorderRadius.circular(4),
           border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
         ),
         child: Stack(
           alignment: Alignment.center,
           children: [
             // Emotional Aura (New)
             _buildEmotionalAura(provider.currentEmotion),
             
             // Grid Background
             GridPaper(
               color: Colors.white.withOpacity(0.05),
               divisions: 2,
               subdivisions: 2,
             ),
             
             // Content based on state
             if (provider.state == CommunicationState.listening)
                _buildWaveform(provider.signalIntensity)
             else if (provider.state == CommunicationState.processing)
                _buildProcessingData()
             else if (provider.state == CommunicationState.speaking)
                _buildSpeakingVisual(provider.currentIntent)
             else if (provider.state == CommunicationState.completed)
                const Icon(Icons.check_circle, color: AppColors.success, size: 60)
             else
                const Text(AppStrings.stateAwaiting, style: TextStyle(color: Colors.white24, letterSpacing: 2, fontSize: 12)),
               
             // Corner Indicators
             Positioned(top: 8, left: 8, child: Text(AppStrings.channelActive, style: TextStyle(color: AppColors.primary, fontSize: 10))),
             Positioned(top: 8, right: 8, child: Text(AppStrings.bandwidth, style: TextStyle(color: Colors.white24, fontSize: 10))),
           ],
         ),
      ),
    );
  }

  Widget _buildWaveform(double intensity) {
    // Simulating an oscilloscope line
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(20, (index) {
        return Container(
          width: 4,
          height: 10 + (intensity * 100 * (index % 3 == 0 ? 1 : 0.5)),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          color: AppColors.primary,
        );
      }),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleY(begin: 1.0, end: 1.5, duration: 100.ms);
  }
  
  Widget _buildProcessingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: AppColors.accent, strokeWidth: 2),
        const SizedBox(height: 16),
        const Text(AppStrings.patternClassifying, style: TextStyle(color: AppColors.accent, fontFamily: 'monospace')),
        const SizedBox(height: 8),
        Text(AppStrings.confidenceHigh, style: TextStyle(color: AppColors.accent.withOpacity(0.5), fontSize: 10, fontFamily: 'monospace')),
      ],
    );
  }
  
  Widget _buildSpeakingVisual(String text) {
     return Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         const Icon(Icons.volume_up, color: AppColors.success, size: 40),
         const SizedBox(height: 16),
         Container(
           padding: const EdgeInsets.all(8),
           color: AppColors.success.withOpacity(0.1),
           child: Text("${AppStrings.outputLabel} $text", style: const TextStyle(color: AppColors.success, fontFamily: 'monospace')),
         ),
       ],
     );
  }

  Widget _buildEmotionalAura(EmotionalState emotion) {
      Color sentimentColor = Colors.transparent;
      switch (emotion) {
          case EmotionalState.calm: sentimentColor = Colors.blue.withOpacity(0.2); break;
          case EmotionalState.happy: sentimentColor = Colors.yellow.withOpacity(0.2); break;
          case EmotionalState.stressed: sentimentColor = Colors.red.withOpacity(0.2); break;
          case EmotionalState.focused: sentimentColor = Colors.purple.withOpacity(0.2); break;
          default: sentimentColor = Colors.transparent;
      }
      
      if (sentimentColor == Colors.transparent) return const SizedBox();
      
      return Container(
          decoration: BoxDecoration(
             gradient: RadialGradient(
               colors: [sentimentColor, Colors.transparent],
               stops: const [0.2, 1.0],
             ),
          ),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
       .scale(begin: const Offset(1,1), end: const Offset(1.5, 1.5), duration: 2.seconds);
  }
}

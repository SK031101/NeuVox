import 'package:flutter/material.dart';
import '../../domain/services/ai_service.dart';
import '../../domain/services/text_to_speech_service.dart';
import '../../data/services/context_service.dart';
import 'package:neuro_capture/neuro_capture.dart';
import 'package:azure_client/azure_client.dart';
import 'package:neuvox/core/utils/artifact_rejection.dart';
import 'dart:async';

enum CommunicationState { idle, listening, processing, speaking, completed }

class CommunicationProvider extends ChangeNotifier {
  final AiService _aiService;
  final TextToSpeechService _ttsService;
  final ContextService _contextService;
  final NeuralDevice _neuralDevice; // From neuro_capture package
  final AzureService _azureService; // From azure_client package
  
  StreamSubscription? _neuralSubscription;

  CommunicationProvider(this._aiService, this._ttsService, this._contextService, this._neuralDevice, this._azureService);

  CommunicationState _state = CommunicationState.idle;
  CommunicationState get state => _state;

  String _currentIntent = "";
  String get currentIntent => _currentIntent;

  double _confidence = 0.0;
  double get confidence => _confidence;

  double _signalIntensity = 0.0;
  double get signalIntensity => _signalIntensity;
  
  EmotionalState _currentEmotion = EmotionalState.neutral;
  EmotionalState get currentEmotion => _currentEmotion;

  double _signalQuality = 1.0;
  double get signalQuality => _signalQuality;

  PowerMode _powerMode = PowerMode.highPerformance;
  PowerMode get powerMode => _powerMode;

  Future<void> startCommunicationLoop() async {
    _reset();
    
    // Connect to Hardware
    await _neuralDevice.connect();
    
    // Subscribe to Data Stream (Real-time 60Hz)
    _neuralSubscription = _neuralDevice.dataStream.listen((frame) {
       _processFrame(frame);
    });
    
    _state = CommunicationState.listening;
    notifyListeners();
  }
  
  void _processFrame(dynamic frame) {
      // 0. Artifact Rejection
      if (ArtifactRejection.isArtifact(frame)) {
         return; // Discard frame
      }
      
      // frame is NeuralFrame. calculate RMS of channels
      // Simulating high-frequency data processing
      double energy = 0.0;
      for (final val in frame.channelData) {
          energy += val * val;
      }
      _signalIntensity = (energy / 8).clamp(0.0, 1.0);
      _currentEmotion = frame.emotion;
      _signalQuality = frame.signalQuality;
      
      // Heuristic: If intensity > 0.8 for a sustained period, trigger "Processing"
      if (_signalIntensity > 0.85 && _state == CommunicationState.listening) {
           _triggerIntentAnalysis();
      }
      
      notifyListeners();
  }
  
  Future<void> _triggerIntentAnalysis() async {
      _state = CommunicationState.processing;
      notifyListeners(); // Immediate UI update
      
      // Stop listening momentarily
       _neuralSubscription?.pause();
       
       try {
          final intent = await _aiService.determineIntent();
          _currentIntent = intent;
          _confidence = 0.99;
          
          await _azureService.sendTelemetry({
              "event": "intent_decoded",
              "intent": intent,
              "confidence": _confidence
          });
          
          _state = CommunicationState.speaking;
          notifyListeners();
          
          await _ttsService.speak(intent, emotion: _currentEmotion);
          await _contextService.addInteraction(intent);
          
          _state = CommunicationState.completed;
          notifyListeners();
          
          // Resume Listening after delay
          await Future.delayed(const Duration(seconds: 2));
           _state = CommunicationState.listening;
           _neuralSubscription?.resume();
           
       } catch (e) {
           _state = CommunicationState.listening;
           _neuralSubscription?.resume();
       }
  }
    

  void stop() async {
    await _ttsService.stop();
    _reset();
    notifyListeners();
  }

  void _reset() {
    _state = CommunicationState.idle;
     _currentIntent = "";
     _confidence = 0.0;
     _signalIntensity = 0.0;
  }
  
  Future<void> speakManually(String text) async {
    _reset();
    _currentIntent = text;
    _confidence = 1.0; // Manual input is 100% confident
    
    _state = CommunicationState.speaking;
    notifyListeners();
    
    await _ttsService.speak(text, emotion: _currentEmotion);
    
    _state = CommunicationState.completed;
    notifyListeners();
  }

  void forceEmotion(EmotionalState emotion) {
    _currentEmotion = emotion;
    notifyListeners();
  }

  Future<void> setPowerMode(PowerMode mode) async {
    _powerMode = mode;
    await _neuralDevice.setPowerMode(mode);
    notifyListeners();
  }

  void confirmIntent() {
     // Logic to confirm intent if needed, or if flow requires manual confirmation before speaking
     // For now, auto-speak is implemented in the loop
  }
}

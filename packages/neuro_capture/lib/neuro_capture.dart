import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

enum EmotionalState { neutral, calm, happy, stressed, focused }

class NeuralFrame {
  final DateTime timestamp;
  final Float64List channelData; // 8 Channels for now
  final double signalQuality; // 0.0 - 1.0
  final EmotionalState emotion;

  NeuralFrame(this.timestamp, this.channelData, this.signalQuality, {this.emotion = EmotionalState.neutral});
}

enum PowerMode { highPerformance, balanced, lowPower }

abstract class NeuralDevice {
  Stream<NeuralFrame> get dataStream;
  Future<void> connect();
  Future<void> disconnect();
  Future<void> setPowerMode(PowerMode mode);
  bool get isConnected;
}

/// Simulates the "NeuroSense" hardware array
class MockNeuralDevice implements NeuralDevice {
  StreamController<NeuralFrame>? _controller;
  Timer? _timer;
  bool _isConnected = false;
  final Random _rng = Random();
  PowerMode _powerMode = PowerMode.highPerformance;
  
  // Simulation State
  int _tick = 0;
  EmotionalState _currentEmotion = EmotionalState.neutral;

  @override
  Stream<NeuralFrame> get dataStream => _controller?.stream ?? const Stream.empty();

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> connect() async {
    if (_isConnected) return;
    await Future.delayed(const Duration(milliseconds: 800));
    _controller = StreamController<NeuralFrame>.broadcast();
    _isConnected = true;
    _startTimer();
  }
  
  @override
  Future<void> setPowerMode(PowerMode mode) async {
    if (_powerMode == mode) return;
    _powerMode = mode;
    if (_isConnected) {
      _startTimer(); // Restart with new frequency
    }
  }

  void _startTimer() {
    _timer?.cancel();
    int intervalMs = 16; // 60Hz default
    switch (_powerMode) {
      case PowerMode.highPerformance: intervalMs = 16; break; // ~60Hz
      case PowerMode.balanced: intervalMs = 33; break; // ~30Hz
      case PowerMode.lowPower: intervalMs = 1000; break; // 1Hz
    }
    
    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (!_isConnected) {
        timer.cancel();
        return;
      }
      _tick++;
      _emitFrame();
    });
  }

  void _emitFrame() {
    // Drifting Emotion Simulation
    if (_tick % (300 * (60 / (1000 / (_timer?.tick ?? 16)))) == 0) { // Rough adjust for tick rate
         // Emotion change logic... simplified for robustness
         if (_rng.nextDouble() < 0.01) {
            final next = _rng.nextInt(5);
            _currentEmotion = EmotionalState.values[next];
         }
    }
  
    final data = Float64List(8);
    final now = DateTime.now().millisecondsSinceEpoch / 1000.0;
    
    double alphaStr = 1.0;
    double betaStr = 0.5;
    double spikiness = 0.02;
    double noiseLevel = 0.05;
    
    // Simulate Signal degradation in Low Power
    if (_powerMode == PowerMode.lowPower) {
       noiseLevel = 0.2; // Higher noise due to lower sampling fidelity
    }

    switch (_currentEmotion) {
        case EmotionalState.calm:
           alphaStr = 2.0; betaStr = 0.2; break;
        case EmotionalState.stressed:
           alphaStr = 0.2; betaStr = 2.0; spikiness = 0.2; break;
        case EmotionalState.focused:
           alphaStr = 0.5; betaStr = 2.5; break;
        default: break;
    }

    double signalVariance = 0.0;

    for (int i = 0; i < 8; i++) {
      double alpha = alphaStr * sin(2 * pi * 10 * now + i);
      double beta = betaStr * sin(2 * pi * 20 * now + i);
      double noise = noiseLevel * (_rng.nextDouble() - 0.5);
      
      if (_rng.nextDouble() > (1.0 - spikiness)) {
        noise += 2.0; 
      }
      
      data[i] = alpha + beta + noise;
      signalVariance += noise.abs();
    }
    
    // Calculate simulated quality (Inverse of noise/variance)
    double quality = (1.0 - (signalVariance / 8.0)).clamp(0.0, 1.0);
    if (_powerMode == PowerMode.lowPower) quality *= 0.8; // Penalty for low power
    
    _controller?.add(NeuralFrame(DateTime.now(), data, quality, emotion: _currentEmotion));
  }

  @override
  Future<void> disconnect() async {
    _isConnected = false;
    _timer?.cancel();
    await _controller?.close();
    _controller = null;
  }
}

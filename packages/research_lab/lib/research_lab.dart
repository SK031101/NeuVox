import 'dart:typed_data';
import 'package:neuro_capture/neuro_capture.dart';

/// Represents a unified frame from widely disparate sensors due to late fusion.
class MultiSensorFrame {
  final DateTime timestamp;
  
  // Modality 1: EEG (From NeuroCapture)
  final NeuralFrame? eegFrame; 
  
  // Modality 2: Eye Tracking (Gaze Vector)
  final Float64List? gazeVector; // [x, y, pupil_dilation]
  
  // Modality 3: fNIRS (Hemodynamic Response)
  final double? oxygenationLevel; // HbO2

  MultiSensorFrame({
    required this.timestamp,
    this.eegFrame,
    this.gazeVector,
    this.oxygenationLevel,
  });

  bool get isComplete => eegFrame != null && gazeVector != null;
}

/// Abstract Interface for the "Zero-Shot" Decoder
abstract class ZeroShotDecoder {
  /// Decodes intent without prior calibration for this specific user.
  /// [subjectEmbedding] is the learned vector representing user's anatomical variance.
  Future<String> decodeIntent(MultiSensorFrame frame, Float64List subjectEmbedding);
  
  /// Calibrates the "Subject Embedding" in real-time.
  Future<Float64List> adaptToSubject(List<MultiSensorFrame> enrollmentSession);
}

/// Abstract Interface for "Collective Intelligence"
abstract class HiveMindNode {
  /// Joins a local P2P mesh for collaborative problem solving.
  Future<void> joinSwarm(String swarmId);
  
  ///Contributes local gradient (privacy-preserving) to the swarm.
  Future<void> contributeGradient(Float64List gradient);
  
  /// Receives the aggregated "Wisdom" from the swarm.
  Stream<String> get swarmConsensus;
}

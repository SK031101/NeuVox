import 'dart:math';
import 'package:neuro_capture/neuro_capture.dart';

class ArtifactRejection {
  static const double _clippingThreshold = 0.95;
  static const double _blinkThreshold = 3.0; // Statistical deviation (Z-score approx)
  
  /// Returns true if the frame contains significant artifacts (blink, clench, loose lead)
  static bool isArtifact(NeuralFrame frame) {
    // 1. Check Signal Quality reported by hardware
    if (frame.signalQuality < 0.3) return true;
    
    // 2. Check for Clipping (Amp > 0.95)
    for (final val in frame.channelData) {
      if (val.abs() > _clippingThreshold) return true;
    }
    
    // 3. Simple Blink Detection (High Amplitude Low Frequency in frontal channels)
    // Assuming channels 0 and 1 are frontal.
    if (frame.channelData.length >= 2) {
       final frontalAvg = (frame.channelData[0].abs() + frame.channelData[1].abs()) / 2;
       if (frontalAvg > 1.5) return true; // Heuristic threshold for blink
    }
    
    return false;
  }
}

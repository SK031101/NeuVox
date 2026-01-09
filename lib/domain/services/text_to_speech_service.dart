import 'package:neuro_capture/neuro_capture.dart';

abstract class TextToSpeechService {
  Future<void> speak(String text, {EmotionalState? emotion});
  Future<void> stop();
}

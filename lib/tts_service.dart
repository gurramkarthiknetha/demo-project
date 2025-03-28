import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> initializeTTS() async {
    await _flutterTts.setLanguage("en-US"); // Change for different languages
    await _flutterTts.setPitch(1.0); // 1.0 = Normal pitch
    await _flutterTts.setSpeechRate(0.5); // Adjust speed
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  Future<void> dispose() async {
    await stop();
    await _flutterTts.awaitSpeakCompletion(false);
  }
}




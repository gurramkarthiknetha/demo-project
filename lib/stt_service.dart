import 'package:speech_to_text/speech_to_text.dart' as stt;

class STTService {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  bool _initialized = false;

  Future<bool> initializeSTT() async {
    try {
      if (!_initialized) {
        _initialized = await _speechToText.initialize(
          onError: (error) => print('Speech recognition error: $error'),
          onStatus: (status) => print('Speech recognition status: $status'),
        );
      }
      return _initialized;
    } catch (e) {
      print("Error in initializeSTT: $e");
      return false;
    }
  }

  Future<void> startListening(Function(String) onTextChanged) async {
    try {
      if (!_initialized) {
        bool initialized = await initializeSTT();
        if (!initialized) return;
      }

      if (!_isListening) {
        _isListening = true;
        await _speechToText.listen(
          onResult: (result) {
            onTextChanged(result.recognizedWords);
          },
          listenFor: Duration(seconds: 30),
          pauseFor: Duration(seconds: 3),
          localeId: "en_US",
        );
      }
    } catch (e) {
      print("Error in startListening: $e");
      _isListening = false;
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      _isListening = false;
      await _speechToText.stop();
    }
  }

  bool get isListening => _isListening;
}

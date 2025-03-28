import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'stt_service.dart';

class STTScreen extends StatefulWidget {
  @override
  _STTScreenState createState() => _STTScreenState();
}

class _STTScreenState extends State<STTScreen> {
  final STTService _sttService = STTService();
  String _recognizedText = "Tap the button and start speaking...";
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  @override
  void dispose() {
    _sttService.stopListening();
    super.dispose();
  }

  Future<void> _initializeService() async {
    bool initialized = await _sttService.initializeSTT();
    setState(() {
      _isInitialized = initialized;
      if (!initialized) {
        _recognizedText = "Failed to initialize speech recognition";
      }
    });
  }

  void _toggleListening() async {
    try {
      // Request microphone permission first
      var status = await Permission.microphone.request();

      if (status != PermissionStatus.granted) {
        if (status == PermissionStatus.permanentlyDenied) {
          // Show dialog to open settings
          if (mounted) {
            showDialog(
              context: context,
              builder:
                  (BuildContext context) => AlertDialog(
                    title: Text('Microphone Permission'),
                    content: Text(
                      'Please enable microphone access in settings to use speech recognition.',
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: Text('Open Settings'),
                        onPressed: () => openAppSettings(),
                      ),
                    ],
                  ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Microphone permission is required")),
            );
          }
        }
        return;
      }

      // Initialize if not already initialized
      if (!_isInitialized) {
        _isInitialized = await _sttService.initializeSTT();
        if (!_isInitialized) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Failed to initialize speech recognition"),
              ),
            );
          }
          return;
        }
      }

      // Toggle listening
      if (_sttService.isListening) {
        await _sttService.stopListening();
      } else {
        await _sttService.startListening((text) {
          if (mounted) setState(() => _recognizedText = text);
        });
      }
      if (mounted) setState(() {});
    } catch (e) {
      print("Error in _toggleListening: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error in speech recognition")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Speech to Text")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _recognizedText,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _toggleListening,
              icon: Icon(_sttService.isListening ? Icons.mic_off : Icons.mic),
              label: Text(
                _sttService.isListening ? "Stop Listening" : "Start Listening",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

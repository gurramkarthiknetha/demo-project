import 'package:flutter/material.dart';
import 'tts_service.dart';
import 'stt_screen.dart';

void main() {
  runApp(MaterialApp(home: TTSScreen(), debugShowCheckedModeBanner: false));
}

class TTSScreen extends StatefulWidget {
  @override
  _TTSScreenState createState() => _TTSScreenState();
}

class _TTSScreenState extends State<TTSScreen> {
  final TTSService _ttsService = TTSService();
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ttsService.initializeTTS();
  }

  void _speakText() {
    String text = _textController.text;
    if (text.isNotEmpty) {
      _ttsService.speak(text);
    }
  }

  void _stopSpeaking() {
    _ttsService.stop();
  }

  @override
  void dispose() {
    _textController.dispose();
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text to Speech"),
        actions: [
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: () async {
              try {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => STTScreen()),
                );
              } catch (e) {
                print("Navigation error: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to open Speech to Text")),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: "Enter text to speak"),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _speakText, child: Text("Speak")),
                SizedBox(width: 10),
                ElevatedButton(onPressed: _stopSpeaking, child: Text("Stop")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}





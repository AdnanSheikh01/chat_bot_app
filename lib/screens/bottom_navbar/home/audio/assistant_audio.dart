import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AssistantAudio extends StatefulWidget {
  final String data;
  const AssistantAudio({
    super.key,
    required this.data,
  });

  @override
  State<AssistantAudio> createState() => _AssistantAudioState();
}

class _AssistantAudioState extends State<AssistantAudio> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false; // Track whether speech is active

  @override
  void initState() {
    super.initState();
    if (widget.data.isNotEmpty) {
      _speak(widget.data);
    }
  }

  @override
  void dispose() {
    _flutterTts.stop(); // Stop TTS when widget is disposed
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US"); // Set language
    await _flutterTts.setPitch(1.0); // Adjust pitch
    await _flutterTts.setSpeechRate(0.5); // Adjust speech rate
    await _flutterTts.speak(text); // Speak the text
    setState(() {
      _isSpeaking = true;
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false; // Reset when speech is completed
      });
    });
  }

  Future<void> _stop() async {
    await _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: size.width * .7),
        decoration: BoxDecoration(
          color: widget.data.isEmpty
              ? Colors.transparent
              : isDarkTheme
                  ? Colors.grey.shade900
                  : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 10),
        child: widget.data.isEmpty
            ? Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    SpinKitThreeBounce(
                      color: isDarkTheme ? Colors.white : Colors.black,
                      size: 12,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Bot Buddy is typing...",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MarkdownBody(
                    data: widget.data,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_isSpeaking) {
                        _stop();
                      } else {
                        _speak(widget.data);
                      }
                    },
                    child: Icon(
                      _isSpeaking ? Icons.volume_off : Icons.volume_up,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

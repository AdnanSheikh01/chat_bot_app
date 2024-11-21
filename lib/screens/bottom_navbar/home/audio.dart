import 'dart:developer';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_bot_app/utils/my_data.dart';
import 'package:chat_bot_app/widgets/auto_type_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final SpeechToText speech = SpeechToText();
  bool startRecording = false;
  String recordedAudio = "";

  final List<Map<String, String>> messages = [];

  Future<void> initializeSpeechToText() async {
    bool available = await speech.initialize(
      onStatus: (status) {
        if (status == "done") {
          // Automatically stop recording when speech stops
          setState(() {
            startRecording = false;
            if (recordedAudio.isNotEmpty) {
              messages.add({"sender": "user", "message": recordedAudio});
              _getAssistantResponse(recordedAudio);
            }
          });
        }
      },
      onError: (error) {
        Get.snackbar("Error!", "Failed to get audio",
            colorText: Colors.white, backgroundColor: Colors.red);
        setState(() {
          startRecording = false;
        });
      },
    );

    if (!available) {
      Get.snackbar("Error!", "Failed to initialize speech to text",
          colorText: Colors.white, backgroundColor: Colors.red);
    }
    setState(() {});
  }

  Future<void> startListening() async {
    setState(() {
      startRecording = true;
      recordedAudio = "";
    });

    await speech.listen(
      onResult: (result) {
        setState(() {
          recordedAudio = result.recognizedWords;
        });
        log("Speech result: $recordedAudio");
      },
    );
  }

  Future<void> stopListening() async {
    await speech.stop();
    setState(() {
      startRecording = false;
      if (recordedAudio.isNotEmpty) {
        messages.add({"sender": "user", "message": recordedAudio});
        _getAssistantResponse(recordedAudio);
      }
    });
  }

  Future<void> _getAssistantResponse(String userMessage) async {
    // Mocking an assistant response for demonstration
    try {
      final model =
          GenerativeModel(model: 'gemini-1.5-flash', apiKey: Utils.apiKey);
      final content = Content.text(userMessage);

      final response = await model.generateContent([content]);

      setState(() {
        messages.add({"sender": "assistant", "message": response.text!});
      });
    } catch (e) {
      Get.snackbar(
        "Error",
        "Try again later",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  void initState() {
    initializeSpeechToText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: isDarkTheme
          ? BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Color(0xff0D1B2A), Color(0xff1C2541)]),
            )
          : BoxDecoration(
              color: Color(0xFFF2F5FA),
            ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Audio Chat"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: messages.isEmpty
                    ? Center(
                        child: AutoTypeText(
                          text: "Let's Start Voice Conversation",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1,
                              color: isDarkTheme ? Colors.white : Colors.black),
                        ),
                      )
                    : ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isUser = message["sender"] == "user";

                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: const EdgeInsets.all(12),
                              constraints:
                                  BoxConstraints(maxWidth: size.width * 0.7),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? Colors.blue[100]
                                    : Colors.green[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                message["message"]!,
                                style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        isUser ? Colors.black : Colors.black),
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Mic button
              GestureDetector(
                onTap: () async {
                  if (speech.isListening) {
                    await stopListening();
                  } else {
                    await startListening();
                  }
                },
                child: AvatarGlow(
                  animate: startRecording,
                  glowColor: Colors.indigo,
                  child: CircleAvatar(
                    backgroundColor: Colors.indigo,
                    radius: size.width * .08,
                    child: Icon(
                      startRecording ? Icons.close : Icons.mic,
                      color: Colors.white,
                      size: size.width * .08,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Instruction text
              Text(
                startRecording ? "Listening... Tap to stop" : "Tap to speak",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

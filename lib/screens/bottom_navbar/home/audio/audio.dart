import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/audio/assistant_audio.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/audio/my_audio_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:chat_bot_app/utils/my_data.dart';
import 'package:chat_bot_app/widgets/auto_type_text.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final _scrollController = ScrollController();

  final SpeechToText speech = SpeechToText();
  bool startRecording = false;
  bool isProcessing = false; // NEW: Prevent duplicate handling
  String recordedAudio = "";

  final List<Map<String, String?>> messages = [];

  Future<void> initializeSpeechToText() async {
    bool available = await speech.initialize(
      onStatus: (status) {
        if (status == "done") {
          // Automatically stop recording when speech stops
          if (mounted) {
            setState(() {
              startRecording = false;
              if (recordedAudio.isNotEmpty && !isProcessing) {
                _handleUserMessage(recordedAudio);
              }
            });
          }
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

  void _scrolltoBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0.0) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> startListening() async {
    setState(() {
      startRecording = true;
      recordedAudio = "";
    });

    await speech.listen(
      onResult: (result) {
        // Process only the final result
        if (result.finalResult && recordedAudio.isEmpty && !isProcessing) {
          recordedAudio = result.recognizedWords;
        }
      },
    );
  }

  Future<void> stopListening() async {
    await speech.stop();
    setState(() {
      startRecording = false;
    });
  }

  Future<void> _handleUserMessage(String userMessage) async {
    if (userMessage.isNotEmpty) {
      setState(() {
        messages.add({"sender": "user", "message": userMessage});
      });
      _scrolltoBottom();

      // Fetch assistant response
      await _getAssistantResponse(userMessage);
    }
  }

  Future<void> _getAssistantResponse(String userMessage) async {
    if (isProcessing) return; // Prevent multiple simultaneous calls
    isProcessing = true;

    log("Fetching response for: $userMessage");

    // Add a typing placeholder
    setState(() {
      messages.add({
        "sender": "assistant",
        "message": null, // Typing placeholder
      });
    });
    _scrolltoBottom();

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: Utils.apiKey,
      );
      final content = Content.text(userMessage);

      final response = await model.generateContent([content]);

      if (mounted && response.text != null) {
        setState(() {
          // Replace typing placeholder with actual response
          messages.removeLast();
          messages.add({
            "sender": "assistant",
            "message": response.text!,
          });
        });
        _scrolltoBottom();
        log("Assistant response added: ${response.text!}");
      }
    } catch (e) {
      log("Error fetching response: $e");
      setState(() {
        messages.removeLast(); // Remove typing placeholder
        messages.add({
          "sender": "assistant",
          "message": "Oops! Something went wrong. Try again.",
        });
      });
      _scrolltoBottom();
      Get.snackbar(
        "Error!",
        "Try again later",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      isProcessing = false; // Reset processing flag
    }
  }

  @override
  void initState() {
    initializeSpeechToText();
    super.initState();
  }

  @override
  void dispose() {
    speech.stop();
    super.dispose();
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
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isUser = message["sender"] == "user";

                          if (isUser) {
                            return MyAudioMessage(message: message["message"]!);
                          } else if (message["sender"] == "assistant" &&
                              message["message"] == null) {
                            return Container(
                              color: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  SpinKitThreeBounce(
                                    color: isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    "Bot Buddy is typing...",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  child: Text("B"),
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Bot Buddy",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    AssistantAudio(data: message["message"]!),
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                      ),
              ),

              // Mic button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: GestureDetector(
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
              ),

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

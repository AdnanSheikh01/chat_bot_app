import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:chat_bot_app/widgets/prog_language.dart';
import 'package:chat_bot_app/utils/my_data.dart';
import 'package:chat_bot_app/widgets/auto_type_text.dart';

class CodeGeneratorPage extends StatefulWidget {
  const CodeGeneratorPage({super.key});

  @override
  State<CodeGeneratorPage> createState() => _CodeGeneratorPageState();
}

class _CodeGeneratorPageState extends State<CodeGeneratorPage> {
  String code = '';
  ProgLanguage? _selectedLanguage;
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  // Function to fetch data from the Gemini model
  Future<void> getData(String message, String? lang) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final model =
          GenerativeModel(model: 'gemini-1.5-flash', apiKey: Utils.apiKey);
      final content = Content.text(
          "Give me Code only with boiler plate for $message in $lang without any expalanation.");
      final response = await model.generateContent([content]);
      setState(() {
        code = response.text?.replaceAll(RegExp(r'```[a-zA-Z]*|```'), '') ??
            'No code generated';
      });
    } catch (e) {
      log("Error: $e");
      Get.snackbar(
        "Error",
        "Failed to generate code",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onGeneratePressed() async {
    if (_selectedLanguage == null) {
      Get.snackbar("Error!", "Please select a programming language",
          colorText: Colors.white, backgroundColor: Colors.red);
      return;
    }
    final prompt = _controller.text;
    if (prompt.isEmpty) {
      Get.snackbar("Error!", 'Please enter a prompt',
          colorText: Colors.white, backgroundColor: Colors.red);
      return;
    }

    await getData(prompt, _selectedLanguage?.name);
  }

  // Function to copy code to clipboard
  void _copyCodeToClipboard() {
    Clipboard.setData(ClipboardData(text: code)).then((_) {
      Get.snackbar("Success", 'Code copied to clipboard',
          colorText: Colors.white, backgroundColor: Colors.green);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: isDarkTheme
          ? const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Color(0xff0D1B2A), Color(0xff1C2541)],
              ),
            )
          : const BoxDecoration(color: Color(0xFFF2F5FA)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Code Generator Page',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<ProgLanguage>(
                  value: _selectedLanguage,
                  hint: Text("Select a programming language"),
                  onChanged: (ProgLanguage? newValue) {
                    setState(() {
                      _selectedLanguage = newValue;
                    });
                  },
                  items: languages.map((ProgLanguage lang) {
                    return DropdownMenuItem<ProgLanguage>(
                      value: lang,
                      child: Text(lang.name),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Programming Language",
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    helperText: "e.g., Addition of two Numbers",
                    labelText: 'Enter your prompt',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            isDarkTheme ? Colors.indigo : Colors.grey.shade900),
                    onPressed: _isLoading ? null : _onGeneratePressed,
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Generate Code'),
                  ),
                ),
                const SizedBox(height: 20),
                if (code.isNotEmpty)
                  Container(
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: isDarkTheme ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: _copyCodeToClipboard,
                              icon: Icon(Icons.copy,
                                  color: isDarkTheme
                                      ? Colors.white
                                      : Colors.black),
                              label: Text('Copy Code',
                                  style: TextStyle(
                                      color: isDarkTheme
                                          ? Colors.white
                                          : Colors.black)),
                            ),
                          ),
                          MarkdownBody(
                            data: code, // Wraps code with triple backticks
                          )
                        ],
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .4,
                    child: Center(
                      child: AutoTypeText(
                        text: "Let's Generate Code",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            letterSpacing: 1,
                            color: isDarkTheme ? Colors.white : Colors.black),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

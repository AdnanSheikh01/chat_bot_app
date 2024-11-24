import 'dart:io';

import 'package:chat_bot_app/language.dart';
import 'package:chat_bot_app/utils/my_data.dart';
import 'package:chat_bot_app/widgets/auto_type_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:translator/translator.dart';

class LensPage extends StatefulWidget {
  const LensPage({super.key});

  @override
  State<LensPage> createState() => _LensPageState();
}

class _LensPageState extends State<LensPage> {
  XFile? imageFile;
  String recognizedText = '';
  final translator = GoogleTranslator();
  bool isloading = false;

  String selectedLanguage = languages[0].name;

  Future<void> pickImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: imageSource);
    if (file != null) {
      setState(() {
        imageFile = file;
      });
      analyzeImage(file);
    }
  }

  Future<void> analyzeImage(XFile file) async {
    final inputImage = InputImage.fromFilePath(file.path);
    // ignore: deprecated_member_use
    final textRecognizer = GoogleMlKit.vision.textRecognizer();

    final RecognizedText recognized =
        await textRecognizer.processImage(inputImage);

    setState(() {
      recognizedText = recognized.text;
    });
    textRecognizer.close();
  }

  Future<void> _translateLanguages(String text) async {
    if (recognizedText.isNotEmpty) {
      final toLang = selectedLanguage;

      setState(() {
        isloading = true; // Show loading indicator
      });

      try {
        final model =
            GenerativeModel(model: 'gemini-1.5-flash', apiKey: Utils.apiKey);
        final content = [
          Content.text("Translate only the following text to $toLang: $text")
        ];

        final response = await model.generateContent(content);

        setState(() {
          if (response.text != null) {
            recognizedText = response.text!;
          } else {
            recognizedText = "Translation failed. Please try again.";
          }
        });
      } catch (e) {
        Get.snackbar("Error", e.toString(),
            colorText: Colors.white, backgroundColor: Colors.red);
      } finally {
        setState(() {
          isloading = false;
        });
      }
    } else {
      Get.snackbar("Error", "No text to translate",
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  void _copyCodeToClipboard() {
    Clipboard.setData(ClipboardData(text: recognizedText)).then((_) {
      Get.snackbar("Success", 'Code copied to clipboard',
          colorText: Colors.white, backgroundColor: Colors.green);
    });
  }

  @override
  Widget build(BuildContext context) {
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
          elevation: 0,
          title: Text("Google Lens"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (imageFile != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(imageFile!.path),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDarkTheme
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: isDarkTheme ? Colors.white70 : Colors.grey,
                          width: 1.5),
                    ),
                    child: Center(
                      child: AutoTypeText(
                        text: "No Image Selected",
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white70 : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                if (recognizedText.isNotEmpty)
                  Card(
                    color: isDarkTheme
                        ? Colors.black.withOpacity(0.8)
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: _copyCodeToClipboard,
                          label: Text("Copy Text"),
                          icon: Icon(Icons.copy),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            recognizedText,
                            style: TextStyle(
                              color: isDarkTheme ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => pickImage(ImageSource.camera),
                      icon: Icon(Icons.camera_alt),
                      label: Text("Capture Image"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue.shade800,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => pickImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library),
                      label: Text("Pick Image"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green.shade700,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                isloading ? SizedBox.shrink() : const SizedBox(height: 20),
                isloading
                    ? SizedBox.shrink()
                    : Container(
                        decoration: BoxDecoration(
                          color: isDarkTheme ? Colors.black : Colors.white,
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<String>(
                          value: selectedLanguage,
                          items: languages
                              .map((entry) => DropdownMenuItem<String>(
                                    value: entry.name,
                                    child: Text(entry.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedLanguage = value;
                              });
                            }
                          },
                          isExpanded: true,
                          underline: SizedBox(),
                          hint: Text(
                            "Select Language",
                            style: TextStyle(color: Colors.grey),
                          ),
                          dropdownColor:
                              isDarkTheme ? Colors.black : Colors.white,
                        ),
                      ),
                const SizedBox(height: 20),
                isloading
                    ? SizedBox(
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: () => _translateLanguages(recognizedText),
                        icon: Icon(Icons.translate),
                        label: Text("Translate to: $selectedLanguage"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.purple.shade600,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:chat_bot_app/utils/my_data.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:chat_bot_app/language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class LanguageTranslationPage extends StatefulWidget {
  const LanguageTranslationPage({super.key});

  @override
  State<LanguageTranslationPage> createState() =>
      _LanguageTranslationPageState();
}

class _LanguageTranslationPageState extends State<LanguageTranslationPage> {
  final TextEditingController _sourceTextController = TextEditingController();
  final TextEditingController _targetTextController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();

  String _sourceLanguage = 'Auto Detect'; // Set default to "Auto Detect"
  String _targetLanguage = languages[3].name; // Default target language
  int _wordCount = 0;
  final int _wordLimit = 100;
  bool _speak = false;

  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    _sourceTextController.addListener(_updateWordCount);
    _flutterTts.setCompletionHandler(() {
      setState(() => _speak = false);
    });
  }

  void _updateWordCount() {
    final text = _sourceTextController.text.trim();
    final words = text.isEmpty ? [] : text.split(RegExp(r'\s+'));

    setState(() {
      _wordCount = words.length > _wordLimit ? _wordLimit : words.length;
      if (words.length > _wordLimit) {
        _sourceTextController.text = words.take(_wordLimit).join(" ");
        _sourceTextController.selection = TextSelection.collapsed(
          offset: _sourceTextController.text.length,
        );
      }
    });
  }

  Future<void> _toggleSpeak(TextEditingController controller) async {
    if (_speak) {
      await _flutterTts.stop();
    } else {
      await _flutterTts.speak(controller.text);
    }
    setState(() => _speak = !_speak);
  }

  Future<void> _translateLanguages() async {
    final input = _sourceTextController.text;
    final fromLang = _sourceLanguage;
    final toLang = _targetLanguage;

    setState(() {
      _isloading = true;
    });
    try {
      final model =
          GenerativeModel(model: 'gemini-1.5-flash', apiKey: Utils.apiKey);
      final content = [
        Content.text(_sourceLanguage == 'Auto Detect'
            ? "Translate the following text into $toLang: $input"
            : "Translate the following text from $fromLang to $toLang: $input")
      ];

      final response = await model.generateContent(content);

      setState(() {
        _targetTextController.text = response.text!;
      });

      setState(() {
        _isloading = false;
      });
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          colorText: Colors.white, backgroundColor: Colors.red);
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  void dispose() {
    _sourceTextController.removeListener(_updateWordCount);
    _sourceTextController.dispose();
    _targetTextController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Widget _buildLanguageDropdown(
      {required String value,
      required List<DropdownMenuItem<String>> items,
      required void Function(String?) onChanged}) {
    return DropdownButtonFormField(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade900
                : Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade900
                : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

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
        appBar: AppBar(title: const Text("Language Translator")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildLanguageDropdown(
                        value: _sourceLanguage,
                        items: [
                          DropdownMenuItem(
                              value: 'Auto Detect', child: Text("Auto Detect")),
                          ...languages.map((lang) => DropdownMenuItem(
                              value: lang.name, child: Text(lang.name))),
                        ],
                        onChanged: (value) =>
                            setState(() => _sourceLanguage = value as String),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_sourceLanguage != 'Auto Detect') {
                          setState(() {
                            final temp = _sourceLanguage;
                            _sourceLanguage = _targetLanguage;
                            _targetLanguage = temp;
                          });
                        }
                      },
                      icon: Icon(CupertinoIcons.repeat),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: _buildLanguageDropdown(
                          value: _targetLanguage,
                          items: languages
                              .where((lang) => lang.name != 'Auto Detect')
                              .map((lang) {
                            return DropdownMenuItem(
                                value: lang.name, child: Text(lang.name));
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => _targetLanguage = value as String),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Text("Translate From"),
                    Text(
                        " ${languages.firstWhere((lang) => lang.name == _sourceLanguage, orElse: () => LanguageName(name: 'Auto Detect')).name}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade900
                          : Colors.grey.shade300,
                    ),
                  ),
                  height: 240,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _sourceTextController,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Have Something to Translate?',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.withOpacity(.6),
                          ),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                        maxLines: 7,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey.shade900
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("$_wordCount/$_wordLimit words",
                                style: TextStyle(color: Colors.grey)),
                            IconButton(
                              onPressed: () =>
                                  _toggleSpeak(_sourceTextController),
                              icon: Icon(Icons.volume_up_outlined),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("Translate To"),
                    Text(
                        " ${languages.firstWhere((lang) => lang.name == _targetLanguage).name}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade900
                          : Colors.grey.shade300,
                    ),
                  ),
                  height: 240,
                  child: _isloading
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: MarkdownBody(
                                    data: _targetTextController.text,
                                    styleSheet: MarkdownStyleSheet(
                                      p: TextStyle(
                                          fontSize: 18, wordSpacing: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey.shade900
                                        : Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (_targetTextController
                                          .text.isNotEmpty) {
                                        Clipboard.setData(ClipboardData(
                                            text: _targetTextController.text));
                                        Get.snackbar(
                                            "Success", "Copied to clipboard",
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white);
                                      } else {
                                        Get.snackbar(
                                            "Error!", "No Text to Copy",
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white);
                                      }
                                    },
                                    icon: Icon(Icons.copy_all_outlined),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        _toggleSpeak(_targetTextController),
                                    icon: Icon(Icons.volume_up_outlined),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 25.0),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDarkTheme ? Colors.grey.shade900 : Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_sourceTextController.text.isNotEmpty) {
                        _translateLanguages();
                      } else {
                        Get.snackbar(
                            "Error!", "Please Enter Something to Translate",
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                      }
                    },
                    child: const Text('Translate'),
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

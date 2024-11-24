import 'package:chat_bot_app/screens/bottom_navbar/home/audio/audio.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/code_gen.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/dum_lens.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/image_gen.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/incognito_chat.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/language_trans.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    List containerVal = [
      [
        Icon(Icons.edit, size: 30, color: Colors.white),
        Colors.blue,
        "Incognito Content",
        IncognitoChat(),
        "Explore a variety of content tailored just for you."
      ],
      [
        Icon(Icons.photo, size: 30, color: Colors.white),
        Colors.yellow,
        "Image Generator",
        ImageGeneratorPage(),
        "Create stunning visuals instantly with our image generation tool."
      ],
      [
        Icon(Icons.headphones, size: 30, color: Colors.white),
        Colors.green,
        "Audio Hearer",
        AudioPage(),
        "Enhance your listening experience with advanced audio playback."
      ],
      [
        Icon(Icons.lightbulb_outline, size: 30, color: Colors.white),
        Colors.red,
        "Google Lens",
        LensPage(),
        "Discover insights from the world around you using Google Lens."
      ],
      [
        Icon(Icons.code, size: 30, color: Colors.white),
        Colors.brown,
        "Code Generator",
        CodeGeneratorPage(),
        "Generate efficient code snippets effortlessly for your projects."
      ],
      [
        Icon(Icons.language, size: 30, color: Colors.white),
        Colors.deepPurple,
        "Language Translator",
        LanguageTranslationPage(),
        "Break language barriers with instant translations."
      ],
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bot Buddy",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: isDarkTheme ? Colors.white : Colors.black),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Your Personal AI Assistant",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: isDarkTheme
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade700),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor:
                            isDarkTheme ? Colors.white : Colors.black,
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: isDarkTheme ? Colors.black : Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                  ),
                  itemCount: containerVal.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => Get.to(containerVal[index][3]),
                    child: Card(
                      color: isDarkTheme ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: containerVal[index][1],
                              radius: 30,
                              child: containerVal[index][0],
                            ),
                            SizedBox(height: 10),
                            Text(
                              containerVal[index][2],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color:
                                    isDarkTheme ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              containerVal[index][4],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDarkTheme
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
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

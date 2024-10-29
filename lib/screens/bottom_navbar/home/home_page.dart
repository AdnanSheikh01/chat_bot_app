import 'package:chat_bot_app/controller/user_controller.dart';
import 'package:chat_bot_app/screens/bottom_navbar/dummy_chat.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/audio.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/code_gen.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/image_gen.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/language_trans.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/lens.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    List containerVal = [
      [
        Icon(Icons.edit),
        Colors.blue,
        "Content",
        ChatScreenDum(),
        "Explore a variety of content tailored just for you."
      ],
      [
        Icon(Icons.photo),
        Colors.yellow,
        "Image Generator",
        ImageGeneratorPage(),
        "Create stunning visuals instantly with our image generation tool."
      ],
      [
        Icon(Icons.headphones),
        Colors.green,
        "Audio Hearer",
        AudioPage(),
        "Enhance your listening experience with advanced audio playback."
      ],
      [
        Icon(Icons.lightbulb_outline),
        Colors.red,
        "Google lens",
        LensPage(),
        "Discover insights from the world around you using Google Lens."
      ],
      [
        Icon(Icons.code),
        Colors.brown,
        "Code Generator",
        CodeGenerator(),
        "Generate efficient code snippets effortlessly for your projects."
      ],
      [
        Icon(Icons.language),
        Colors.deepPurple,
        "Language Translator",
        LanguageTranslationPage(),
        "Break language barriers with instant translations."
      ],
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .02),
              SizedBox(height: 10),
              Text(
                "Welcome to Bot Buddy,\n${userController.userFullName.value}",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : Colors.black),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: containerVal.length,
                  itemBuilder: (context, index) => Card(
                    shadowColor: isDarkTheme ? Colors.blue : Colors.black,
                    margin: EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => containerVal[index][3],
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: containerVal[index][1],
                        child: containerVal[index][0],
                      ),
                      title: Text(
                        containerVal[index][2],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(containerVal[index][4]),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

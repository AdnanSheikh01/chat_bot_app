import 'package:chat_bot_app/screens/bottom_navbar/home/audio.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/image_gen.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/language_trans.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/lens.dart';
import 'package:chat_bot_app/screens/bottom_navbar/chat/new_chat.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    List containerVal = [
      [
        Icon(Icons.edit),
        Colors.blue,
        "Content",
        NewChatPage(
          appTitle: "Content",
        ),
      ],
      [
        Icon(Icons.photo),
        Colors.yellow,
        "Image",
        ImageGeneratorPage(),
      ],
      [
        Icon(Icons.headphones),
        Colors.green,
        "Audio",
        AudioPage(),
      ],
      [
        Icon(Icons.lightbulb_outline),
        Colors.red,
        "Lens",
        LensPage(),
      ],
      [
        Icon(Icons.language),
        Colors.deepPurple,
        "Language",
        LanguageTranslationPage(),
      ],
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .1),
              Center(
                child: GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                        image: AssetImage("assets/images/person.png"),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "Welcome to \nAI Chat",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme ? Colors.white : Colors.black),
                ),
              ),
              SizedBox(height: 10),
              SearchBar(
                backgroundColor: WidgetStatePropertyAll(
                    isDarkTheme ? Colors.black : Colors.white),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 10),
                ),
                hintText: "Ask me Anything...",
                hintStyle: WidgetStatePropertyAll(
                  TextStyle(color: Colors.grey),
                ),
                trailing: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.photo,
                      color: isDarkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.mic,
                      color: isDarkTheme ? Colors.white : Colors.black,
                    ),
                  )
                ],
                elevation: WidgetStatePropertyAll(1),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  itemCount: containerVal.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => containerVal[index][3],
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: isDarkTheme ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: containerVal[index][1],
                              child: containerVal[index][0],
                            ),
                            SizedBox(width: 10),
                            Text(
                              containerVal[index][2],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Recent",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                  physics:
                      NeverScrollableScrollPhysics(), // Disable scrolling for GridView
                  itemCount: 10,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(10),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: isDarkTheme ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

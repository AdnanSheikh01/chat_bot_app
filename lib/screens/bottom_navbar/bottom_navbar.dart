import 'package:chat_bot_app/controller/user_controller.dart';
import 'package:chat_bot_app/providers/chat_provider.dart';
import 'package:chat_bot_app/screens/bottom_navbar/dummy_chat.dart';
import 'package:chat_bot_app/theme/provider.dart';
import 'package:chat_bot_app/widgets/double_tap_to_exit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/home_page.dart';
import 'package:chat_bot_app/screens/log_in/login.dart';
import 'package:chat_bot_app/screens/bottom_navbar/saved/saved_page.dart';

class BottomNavbarScreen extends StatefulWidget {
  const BottomNavbarScreen({super.key});

  @override
  State<BottomNavbarScreen> createState() => _BottomNavbarScreenState();
}

class _BottomNavbarScreenState extends State<BottomNavbarScreen> {
  final UserController userController = Get.find();
  final List<Widget> _pages = [
    HomePage(),
    // ChatPage(),
    ChatScreenDum(),
    SavedPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ChatProvider>(builder: (context, chatprovider, child) {
      return DoubleTapExitApp(
        child: Container(
          decoration: isDarkTheme
              ? BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black,
                        Color(0xff0D1B2A),
                        Color(0xff1C2541)
                      ]),
                )
              : BoxDecoration(
                  color: Color(0xFFF2F5FA),
                ),
          child: Scaffold(
            drawer: Drawer(
              backgroundColor:
                  isDarkTheme ? Colors.black : Colors.white.withOpacity(.9),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * .1),
                    CircleAvatar(
                      radius: 50,
                      child: Text(
                        "F",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      userController.userFullName.value,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Text(
                      userController.userEmail.value,
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.settings_outlined),
                      title: Text("Settings"),
                    ),
                    Divider(color: Colors.grey.shade300),
                    ListTile(
                      leading: Icon(Icons.support_agent_outlined),
                      title: Text("Help Centre"),
                    ),
                    Divider(color: Colors.grey.shade300),
                    ListTile(
                      leading: Icon(Icons.feedback_outlined),
                      title: Text("Send Us Feedback"),
                    ),
                    Divider(color: Colors.grey.shade300),
                    ListTile(
                      leading: Icon(Icons.star_rounded),
                      title: Text("Rate our App"),
                    ),
                    Divider(color: Colors.grey.shade300),
                    ListTile(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Get.offAll(LoginScreen());
                      },
                      leading: Icon(Icons.logout_outlined),
                      title: Text("Sign Out"),
                    ),
                    Divider(color: Colors.grey.shade300),
                    Spacer(),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          themeProvider.toggleTheme(!isDarkTheme);
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            color: isDarkTheme
                                ? Colors.grey.shade900
                                : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Stack(
                            children: [
                              AnimatedAlign(
                                alignment: isDarkTheme
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.indigo,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.light_mode,
                                        color: isDarkTheme
                                            ? Colors.grey
                                            : Colors.white,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Light',
                                        style: TextStyle(
                                          color: isDarkTheme
                                              ? Colors.grey
                                              : Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.dark_mode,
                                        color: isDarkTheme
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Dark',
                                        style: TextStyle(
                                          color: isDarkTheme
                                              ? Colors.white
                                              : Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            body: PageView(
              controller: chatprovider.pageController,
              children: _pages,
              onPageChanged: (value) {
                chatprovider.setCurrentIndex(newIndex: value);
              },
            ),
            backgroundColor: Colors.transparent,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor:
                  isDarkTheme ? Color(0xff0D1B2A) : Color(0xFFF2F5FA),
              selectedItemColor: isDarkTheme ? Colors.white : Colors.black,
              unselectedItemColor: Colors.grey,
              onTap: (value) {
                chatprovider.setCurrentIndex(newIndex: value);
                chatprovider.pageController.jumpToPage(value);
              },
              currentIndex: chatprovider.currentIndex,
              items: const [
                BottomNavigationBarItem(
                    activeIcon: Icon(Icons.home),
                    icon: Icon(Icons.home_outlined),
                    label: "Home"),
                BottomNavigationBarItem(
                    activeIcon: Icon(CupertinoIcons.chat_bubble_fill),
                    icon: Icon(CupertinoIcons.chat_bubble),
                    label: "Chats"),
                BottomNavigationBarItem(
                    activeIcon: Icon(CupertinoIcons.bookmark_fill),
                    icon: Icon(CupertinoIcons.bookmark),
                    label: "History"),
              ],
            ),
          ),
        ),
      );
    });
  }
}

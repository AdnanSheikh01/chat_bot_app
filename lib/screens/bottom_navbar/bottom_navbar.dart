import 'package:chat_bot_app/auth/firebase_auth.dart';
import 'package:chat_bot_app/providers/chat_provider.dart';
import 'package:chat_bot_app/screens/bottom_navbar/chat/chat.dart';
import 'package:chat_bot_app/theme/provider.dart';
import 'package:chat_bot_app/widgets/double_tap_to_exit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_bot_app/screens/bottom_navbar/home/home_page.dart';
import 'package:chat_bot_app/screens/log_in/login.dart';
import 'package:chat_bot_app/screens/bottom_navbar/history/history_page.dart';

class BottomNavbarScreen extends StatefulWidget {
  const BottomNavbarScreen({super.key});

  @override
  State<BottomNavbarScreen> createState() => _BottomNavbarScreenState();
}

class _BottomNavbarScreenState extends State<BottomNavbarScreen> {
  String fullName = '';
  String email = '';
  @override
  void initState() {
    _fetchUserData();
    super.initState();
  }

  Future<void> _fetchUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var userData = await FirebaseAuthServices().getUserData(uid);

    if (userData != null) {
      setState(() {
        fullName = userData['fullName'];
        email = userData['email'];
      });
    }
  }

  final List<Widget> _pages = [
    HomePage(),
    // ChatPage(),
    ChatScreen(),
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
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color:
                            isDarkTheme ? Colors.grey.shade900 : Colors.indigo,
                      ),
                      accountName: Text(
                        fullName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme ? Colors.white : Colors.white,
                        ),
                      ),
                      accountEmail: Text(
                        email,
                        style: TextStyle(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        child: Text(
                          fullName.isNotEmpty ? fullName[0].toUpperCase() : '',
                          style: TextStyle(
                              fontSize: 24,
                              color: isDarkTheme
                                  ? Colors.grey.shade900
                                  : Colors.indigo),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildDrawerItem(Icons.settings_outlined, "Settings"),
                    _buildDrawerItem(
                        Icons.support_agent_outlined, "Help Centre"),
                    _buildDrawerItem(
                        Icons.feedback_outlined, "Send Us Feedback"),
                    _buildDrawerItem(Icons.star_rounded, "Rate our App"),
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

  Widget _buildDrawerItem(IconData icon, String title) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
        ),
        Divider(color: Colors.grey.shade300),
      ],
    );
  }
}

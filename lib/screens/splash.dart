import 'dart:async';

import 'package:chat_bot_app/screens/bottom_navbar/bottom_navbar.dart';
import 'package:chat_bot_app/screens/log_in/login.dart';
import 'package:chat_bot_app/widgets/auto_type_text.dart';
import 'package:chat_bot_app/widgets/double_tap_to_exit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return FirebaseAuth.instance.currentUser != null
              ? FirebaseAuth.instance.currentUser!.emailVerified
                  ? BottomNavbarScreen()
                  : LoginScreen()
              : LoginScreen();
        }),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

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
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Image.asset(
                    "assets/images/splash_astronaut.png",
                    scale: 7,
                  ),
                  const AutoTypeText(
                    text: "Welcome to Bot Buddy",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        letterSpacing: 0),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Created by: ",
                          style: TextStyle(
                              color: isDarkTheme ? Colors.white : Colors.black),
                          children: [
                            TextSpan(
                              text: "Mohd Adnan",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

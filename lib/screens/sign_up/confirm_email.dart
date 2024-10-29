import 'dart:async';

import 'package:chat_bot_app/screens/sign_up/after_confirm_email.dart';
import 'package:chat_bot_app/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConfirmEmailScreen extends StatefulWidget {
  const ConfirmEmailScreen({super.key});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  Timer? _timer; // Declare a timer variable

  @override
  void initState() {
    sendVerificationEmail();
    super.initState();
  }

  @override
  void dispose() {
    // Cancel the timer when disposing the screen
    _timer?.cancel();
    super.dispose();
  }

  void sendVerificationEmail() {
    FirebaseAuth.instance.currentUser!.sendEmailVerification();

    // Start the timer to check for email verification periodically
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;

      if (user!.emailVerified) {
        timer.cancel();

        showDialog(
          context: context,
          builder: (ctx) => const AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: SizedBox(
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Please Wait...",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );

        // After 2 seconds, navigate to the next screen
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => AfterConfirmEmailScreen(),
              ),
              (route) => false,
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
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
            : BoxDecoration(color: Color(0xFFF2F5FA)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: size.height * .06),
                Image.asset(
                  "assets/images/email_astronaut.png",
                  scale: 5,
                ),
                SizedBox(height: 10),
                Text(
                  "Almost there!\nPlease Verify Your Email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      letterSpacing: 0),
                ),
                SizedBox(height: 5),
                Text(
                  textAlign: TextAlign.center,
                  "Please check your inbox for a verification email and click on the link provided. If you can’t find it, check your spam folder or request a resend.",
                ),
                SizedBox(height: 20),
                MyButton(
                    onPressed: () {
                      sendVerificationEmail(); // Resend the email when this button is pressed
                    },
                    label: "Resend Email"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

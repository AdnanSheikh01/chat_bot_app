import 'package:chat_bot_app/screens/bottom_navbar/bottom_navbar.dart';
import 'package:chat_bot_app/widgets/button.dart';
import 'package:flutter/material.dart';

class AfterConfirmEmailScreen extends StatelessWidget {
  const AfterConfirmEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: isDarkTheme
          ? BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Color(0xff0D1B2A), Color(0xff1C2541)]),
            )
          : BoxDecoration(color: Color(0xFFF2F5FA)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: size.height * .06),
                Image.asset(
                  "assets/images/ready_rocket_astronaut.png",
                  scale: 5,
                ),
                SizedBox(height: 10),
                Text(
                  "You’re all set!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      letterSpacing: 0),
                ),
                SizedBox(height: 5),
                Text(
                  textAlign: TextAlign.center,
                  "Congratulations! Your account is now ready. Dive in and explore the amazing features waiting for you.",
                ),
                SizedBox(height: 20),
                MyButton(
                  label: "Continue",
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavbarScreen(),
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

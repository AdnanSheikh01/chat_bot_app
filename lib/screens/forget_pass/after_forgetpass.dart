import 'package:chat_bot_app/screens/log_in/login.dart';
import 'package:chat_bot_app/widgets/button.dart';
import 'package:flutter/material.dart';

class AfterForgetPassScreen extends StatelessWidget {
  const AfterForgetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    var size = MediaQuery.of(context).size;
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: size.height * .06),
                Image.asset(
                  "assets/images/cute-astronaut-working.png",
                  scale: 5,
                ),
                SizedBox(height: 10),
                Text(
                  "Password Reset Email Sent!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      letterSpacing: 0),
                ),
                SizedBox(height: 5),
                Text(
                  textAlign: TextAlign.center,
                  "Congratulations! We've Sent You a Secure Link to Safely Change Your Password and Keep Your Account Protected.",
                ),
                SizedBox(height: 20),
                MyButton(
                  label: "Done",
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                    (route) => false,
                  ),
                ),
                SizedBox(height: 10),
                TextButton(onPressed: () {}, child: Text("Resend Link"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

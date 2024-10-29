import 'package:chat_bot_app/widgets/double_tap_to_exit.dart';
import 'package:flutter/material.dart';
import '../../auth/firebase_auth.dart';
import '../forget_pass/forget_pass.dart';
import '../sign_up/new_member.dart';
import '../../widgets/auto_type_text.dart';
import '../../widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuthServices();
  final _key = GlobalKey<FormState>();

  bool _obscurePassword = true;
  String _email = '', _password = '';

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    var size = MediaQuery.of(context).size;

    return DoubleTapExitApp(
      child: Container(
        decoration: _buildBackgroundDecoration(isDarkTheme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * .08),
                  _buildHeader(),
                  SizedBox(height: size.height * .05),
                  _buildTextField(
                    hintText: "Email",
                    prefixIcon: Icons.email_outlined,
                    onChanged: (value) => _email = value,
                    validator: _emailValidator,
                    isDarkTheme: isDarkTheme,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    hintText: "Password",
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                      onPressed: () => setState(() {
                        _obscurePassword = !_obscurePassword;
                      }),
                    ),
                    onChanged: (value) => _password = value,
                    validator: _passwordValidator,
                    isDarkTheme: isDarkTheme,
                  ),
                  const SizedBox(height: 20),
                  _buildForgotPassword(context),
                  const SizedBox(height: 20),
                  MyButton(
                    label: "Sign In",
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        _auth.signInWithEmail(context, _email, _password);
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  _buildNewMemberSection(context, isDarkTheme),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper Methods
  BoxDecoration _buildBackgroundDecoration(bool isDarkTheme) {
    return isDarkTheme
        ? BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xff0D1B2A), Color(0xff1C2541)],
          ))
        : const BoxDecoration(
            color: Color(0xFFF2F5FA),
          );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sign In",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            AutoTypeText(
              text: "Let's get into \nyour account",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        Image.asset(
          "assets/images/login_astronaut.png",
          scale: 9,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData prefixIcon,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    bool isDarkTheme = false,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon,
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        filled: true,
        fillColor: isDarkTheme ? Colors.black : Colors.white,
        hintStyle: const TextStyle(color: Colors.blueGrey),
        errorStyle: const TextStyle(color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return "Please enter email";
    if (!value.contains("@gmail.com")) return "Please enter valid email";
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return "Please enter password";
    if (value.length < 6) {
      return "Password should contain at least 6 characters";
    }
    return null;
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgetPassScreen()),
          ),
          child: const Text(
            "Forgot Password?",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildNewMemberSection(BuildContext context, bool isDarkTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "New Member? ",
          style: TextStyle(
            color: isDarkTheme ? Colors.white70 : Colors.grey.shade700,
          ),
        ),
        InkWell(
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateAccountScreen()),
          ),
          child: const Text(
            "Create Account",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

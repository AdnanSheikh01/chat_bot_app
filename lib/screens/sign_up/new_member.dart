import 'package:chat_bot_app/auth/firebase_auth.dart';
import 'package:chat_bot_app/screens/log_in/login.dart';
import 'package:chat_bot_app/widgets/auto_type_text.dart';
import 'package:chat_bot_app/widgets/button.dart';
import 'package:chat_bot_app/widgets/double_tap_to_exit.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  late bool _isDarkTheme;
  String _fullname = '', _email = '', _password = '', confirmPass = '';

  @override
  Widget build(BuildContext context) {
    _isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return DoubleTapExitApp(
      child: Container(
        decoration: _buildBackgroundDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.06),
                  _buildHeader(),
                  const SizedBox(height: 10),
                  _buildTextField(
                    isPassField: false,
                    label: "Full Name",
                    icon: Icons.person_outline,
                    onChanged: (val) => _fullname = val,
                    validator: (val) =>
                        val!.isEmpty ? "Please enter your name" : null,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    isPassField: false,
                    label: "Email",
                    icon: Icons.email_outlined,
                    onChanged: (val) => _email = val,
                    validator: (val) {
                      if (val!.isEmpty) return "Please enter email";
                      if (!val.contains("@gmail.com")) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    needSuffIcon: true,
                    icon: Icons.lock_open,
                    label: "Password",
                    onChanged: (val) => _password = val,
                    validator: (val) {
                      if (val!.isEmpty) return "Please enter password";
                      if (val.length < 6) {
                        return "Password should contain at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    icon: Icons.lock_open,
                    label: "Confirm Password",
                    onChanged: (val) => confirmPass = val,
                    validator: (val) {
                      if (val!.isEmpty) return "Please confirm your password";
                      if (val != _password) return "Passwords do not match";
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    label: "Create Account",
                    onPressed: _handleCreateAccount,
                  ),
                  const SizedBox(height: 30),
                  _buildSignInLink(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return _isDarkTheme
        ? const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Color(0xff0D1B2A), Color(0xff1C2541)],
            ),
          )
        : const BoxDecoration(color: Color(0xFFF2F5FA));
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sign Up",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            AutoTypeText(
              text: "You don't have \nan account?",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        Flexible(
          child: Image.asset(
            "assets/images/sign_up_astronaut.png",
            scale: 9,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    bool isPassField = true,
    bool needSuffIcon = false,
    required IconData icon,
    required ValueChanged<String> onChanged,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      obscureText: isPassField ? _obscurePassword : false,
      decoration: _inputDecoration(label, icon, needSuffIcon),
    );
  }

  InputDecoration _inputDecoration(
      String hint, IconData icon, bool isPassIcon) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(vertical: 20),
      filled: true,
      suffixIcon: isPassIcon
          ? IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: Icon(_obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
            )
          : null,
      fillColor: _isDarkTheme ? Colors.black : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Colors.blueGrey),
      errorStyle: const TextStyle(color: Colors.red),
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already a Member? ",
          style: TextStyle(
            color: _isDarkTheme ? Colors.white70 : Colors.grey.shade700,
          ),
        ),
        InkWell(
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          ),
          child: const Text(
            "Sign In",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Future<void> _handleCreateAccount() async {
    if (_formKey.currentState!.validate()) {
      await _auth.signUpWithEmail(context, _fullname, _email, _password);
    }
  }
}

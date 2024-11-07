import 'package:chat_bot_app/screens/bottom_navbar/bottom_navbar.dart';
import 'package:chat_bot_app/screens/sign_up/confirm_email.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User?> signUpWithEmail(BuildContext context, String fullName,
      String email, String password) async {
    try {
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
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'fullName': fullName,
        'email': email,
      });

      Get.back();
      Get.to(
        () => ConfirmEmailScreen(),
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error!",
        e.code,
      );
      if (e.code == 'invalid-credential') {
        // Display an error message to the user
        Get.back();
        Get.snackbar(
            backgroundColor: Colors.red,
            colorText: Colors.white,
            "Error!",
            "The supplied auth credential is malformed or has expired.");
      } else if (e.code == 'email-already-in-use') {
        Get.back();
        Get.snackbar(
            backgroundColor: Colors.red,
            colorText: Colors.white,
            "Error!",
            "User Already exists for that email.");
      } else if (e.code == 'weak-password') {
        Get.back();

        Get.snackbar(colorText: Colors.white, "Info!", "Weak Password.");
      } else {
        // Handle other Firebase sign-in errors if necessary
        Get.back();
        Get.snackbar(
            backgroundColor: Colors.red,
            colorText: Colors.white,
            "Error!",
            "Error Occured. Try Again Later.");
      }
    }
    return null;
  }

  Future<String?> signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
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
      // Sign in using Firebase Authentication
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      FirebaseAuth.instance.currentUser!.emailVerified
          ? Get.offUntil(
              GetPageRoute(page: () => const BottomNavbarScreen()),
              (route) => false,
            )
          : Get.to(
              () => ConfirmEmailScreen(),
            );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Show an error message to the user
        Get.back();
        Get.snackbar(
            backgroundColor: Colors.red,
            colorText: Colors.white,
            "Error!",
            "The email address is already in use by another account.");
      } else if (e.code == 'invalid-email') {
        Get.back();
        Get.snackbar(
            backgroundColor: Colors.red,
            colorText: Colors.white,
            "Error!",
            "Invalid User.");
      } else if (e.code == 'wrong-password') {
        Get.back();

        Get.snackbar(
            backgroundColor: Colors.red,
            colorText: Colors.white,
            "Error!",
            "Wrong Password.");
      } else if (e.code == 'invalid-credential') {
        Get.back();

        Get.snackbar(
            backgroundColor: Colors.red,
            colorText: Colors.white,
            "Error!",
            "No user found for that email.");
      } else {
        // Handle other errors if necessary
        Get.back();
        Get.snackbar(
            backgroundColor: Colors.red,
            colorText: Colors.white,
            "Error!",
            "Sign in Failed. Try Again Later.");
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc.exists ? userDoc.data() as Map<String, dynamic> : null;
  }
}

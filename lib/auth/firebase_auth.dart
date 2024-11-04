// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:chat_bot_app/dum_controller.dart';
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

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmEmailScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        // Display an error message to the user
        Navigator.pop(context);
        Get.snackbar(
            backgroundColor: Colors.red,
            colorText: Colors.white,
            "Error!",
            "The supplied auth credential is malformed or has expired.");
      } else if (e.code == 'email-already-in-use') {
        Navigator.pop(context);
        Get.snackbar(
            backgroundColor: Colors.red,
            colorText: Colors.white,
            "Error!",
            "User Already exists for that email.");
      } else if (e.code == 'weak-password') {
        Navigator.pop(context);

        Get.snackbar(colorText: Colors.white, "Info!", "Weak Password.");
      } else {
        // Handle other Firebase sign-in errors if necessary
        Navigator.pop(context);
        Get.snackbar(
            backgroundColor: Colors.red,
            colorText: Colors.white,
            "Error!",
            "Error Occured. Try Again Later.");
      }
    }
    return null;
  }

  Future<User?> signInWithEmail(
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
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Retrieve the full name from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (userDoc.exists) {
        String fullName = userDoc.get('fullName');
        log('User full name: $fullName');

        Get.find<UserController>().setUser(fullName, email);
        Navigator.pop(context);

        FirebaseAuth.instance.currentUser!.emailVerified
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const BottomNavbarScreen()),
                (route) => false,
              )
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfirmEmailScreen(),
                ),
              );

        // You can now pass this full name to the home page
      } else {
        log('User document not found');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Show an error message to the user
        Navigator.pop(context);
        Get.snackbar(
            backgroundColor: Colors.red,
            colorText: Colors.white,
            "Error!",
            "The email address is already in use by another account.");
      } else if (e.code == 'invalid-email') {
        Navigator.pop(context);
        Get.snackbar(
            backgroundColor: Colors.red,
            colorText: Colors.white,
            "Error!",
            "Invalid User.");
      } else if (e.code == 'wrong-password') {
        Navigator.pop(context);

        Get.snackbar(
            backgroundColor: Colors.red,
            colorText: Colors.white,
            "Error!",
            "Wrong Password.");
      } else if (e.code == 'invalid-credential') {
        Navigator.pop(context);

        Get.snackbar(
            backgroundColor: Colors.red,
            colorText: Colors.white,
            "Error!",
            "No user found for that email.");
      } else {
        // Handle other errors if necessary
        Navigator.pop(context);
        Get.snackbar(
            backgroundColor: Colors.red,
            colorText: Colors.white,
            "Error!",
            "Sign in Failed. Try Again Later.");
      }
    }
    return null;
  }
}

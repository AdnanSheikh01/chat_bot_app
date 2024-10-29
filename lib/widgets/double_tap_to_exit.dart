// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';

class DoubleTapExitApp extends StatefulWidget {
  final Widget child;

  const DoubleTapExitApp({super.key, required this.child});

  @override
  State<DoubleTapExitApp> createState() => _DoubleTapExitAppState();
}

class _DoubleTapExitAppState extends State<DoubleTapExitApp> {
  bool _backPressedOnce = false;
  Timer? _exitTimer;

  @override
  void dispose() {
    _exitTimer?.cancel();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_backPressedOnce) {
      return true; // Exit the app
    } else {
      setState(() {
        _backPressedOnce = true;
      });

      // Show a toast message (or Snackbar) indicating "Press again to exit"
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Center(
            child: Text(
              "Press back again to exit",
            ),
          ),
          duration: Duration(seconds: 2),
        ),
      );

      // Reset the flag after 2 seconds
      _exitTimer = Timer(const Duration(seconds: 2), () {
        setState(() {
          _backPressedOnce = false;
        });
      });

      return false; // Prevent immediate exit
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: widget.child,
    );
  }
}

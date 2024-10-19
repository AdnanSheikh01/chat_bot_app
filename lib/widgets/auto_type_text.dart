import 'dart:async';
import 'package:flutter/material.dart';

class AutoTypeText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const AutoTypeText({super.key, required this.text, this.style});

  @override
  State<AutoTypeText> createState() => _AutoTypeTextState();
}

class _AutoTypeTextState extends State<AutoTypeText> {
  String _displayedText = "";
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_index < widget.text.length) {
        setState(() {
          _displayedText += widget.text[_index];
          _index++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style ?? const TextStyle(fontSize: 20),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MyAudioMessage extends StatelessWidget {
  const MyAudioMessage({
    super.key,
    required this.message,
  });
  final String message;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: size.width * .7),
        decoration: BoxDecoration(
          color: isDarkTheme ? Colors.indigo : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 10),
        child: MarkdownBody(
          data: message,
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

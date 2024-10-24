import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AssistantMessageWidget extends StatelessWidget {
  final String data;
  const AssistantMessageWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: size.width * .9),
        decoration: BoxDecoration(
          color: data.isEmpty
              ? Colors.transparent
              : isDarkTheme
                  ? Colors.grey.shade900
                  : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 10),
        child: data.isEmpty
            ? Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Text("Bot Buddy is typing"),
                    SizedBox(width: 5),
                    SpinKitThreeBounce(
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
              )
            : MarkdownBody(
                data: data,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                  color: isDarkTheme ? Colors.white : Colors.black,
                )),
              ),
      ),
    );
  }
}

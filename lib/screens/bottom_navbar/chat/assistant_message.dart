import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';

class AssistantMessageWidget extends StatefulWidget {
  final String data;
  const AssistantMessageWidget({
    super.key,
    required this.data,
  });

  @override
  State<AssistantMessageWidget> createState() => _AssistantMessageWidgetState();
}

class _AssistantMessageWidgetState extends State<AssistantMessageWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    bool copy = false;

    return Align(
      alignment: Alignment.centerLeft,
      child: FocusedMenuHolder(
        onPressed: () {},
        menuWidth: 150,
        menuItems: [
          FocusedMenuItem(
            title: Text("Copy"),
            backgroundColor: Colors.white,
            onPressed: () {
              setState(() {
                copy = true;
              });
              Clipboard.setData(ClipboardData(text: widget.data));

              Future.delayed(Duration(seconds: 3), () {
                setState(() {
                  copy = false;
                });
              });

              Get.snackbar("Success", 'Code copied to clipboard',
                  colorText: Colors.white, backgroundColor: Colors.green);
            },
            trailingIcon: Icon(copy == true ? Icons.check : Icons.copy),
          )
        ],
        child: Container(
          constraints: BoxConstraints(maxWidth: size.width * .7),
          decoration: BoxDecoration(
            color: widget.data.isEmpty
                ? Colors.transparent
                : isDarkTheme
                    ? Colors.grey.shade900
                    : Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.only(bottom: 10),
          child: widget.data.isEmpty
              ? Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      SpinKitThreeBounce(
                        color: isDarkTheme ? Colors.white : Colors.black,
                        size: 12,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Bot Buddy is typing",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                )
              : MarkdownBody(
                  data: widget.data,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      color: isDarkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

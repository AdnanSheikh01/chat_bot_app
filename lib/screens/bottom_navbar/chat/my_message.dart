import 'package:chat_bot_app/models/message.dart';
import 'package:chat_bot_app/widgets/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MyMessageWidget extends StatelessWidget {
  final Message data;
  const MyMessageWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: data.imageUrls.isNotEmpty
            ? BoxConstraints(maxWidth: size.width * .7)
            : BoxConstraints(maxWidth: size.width * .7),
        decoration: BoxDecoration(
          color: data.imageUrls.isNotEmpty
              ? Colors.transparent
              : isDarkTheme
                  ? Colors.indigo
                  : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 10),
        child: data.imageUrls.isNotEmpty
            ? SizedBox(
                height: 100,
                width: size.width * .5,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 200,
                      child: PreviewImageWidget(
                        message: data,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        // margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDarkTheme ? Colors.indigo : Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: MarkdownBody(
                          data: data.message.toString(),
                          selectable: true,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              color: isDarkTheme ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : MarkdownBody(
                data: data.message.toString(),
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

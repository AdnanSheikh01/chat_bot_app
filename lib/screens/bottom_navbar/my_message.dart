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
        constraints: BoxConstraints(maxWidth: size.width * .7),
        decoration: BoxDecoration(
          color: isDarkTheme ? Colors.indigo : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            if (data.imagUrl.isNotEmpty)
              PreviewImageWidget(
                message: data,
              )
            else
              const Text(
                'No images to display.',
                style: TextStyle(color: Colors.grey),
              ),
            MarkdownBody(
              data: data.message.toString(),
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  color: isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

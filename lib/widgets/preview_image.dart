import 'dart:io';
import 'package:chat_bot_app/models/message.dart';
import 'package:chat_bot_app/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviewImageWidget extends StatelessWidget {
  final Message? message;

  const PreviewImageWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatprovider, child) {
        final imageFiles =
            message != null ? message!.imageUrls : chatprovider.imageFileList;

        final padding = message != null
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 8);

        return Padding(
          padding: padding,
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageFiles!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(message != null
                          ? message!.imageUrls[index]
                          : chatprovider.imageFileList![index].path),
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 50);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

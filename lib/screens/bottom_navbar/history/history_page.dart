import 'package:chat_bot_app/hive/boxes.dart';
import 'package:chat_bot_app/hive/chat_history.dart';
import 'package:chat_bot_app/providers/chat_provider.dart';
import 'package:chat_bot_app/widgets/auto_type_text.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import 'package:get/get.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  String markdownToPlainText(String markdown) {
    final lines = md.Document().parseLines(markdown.split('\n'));
    return lines.map((e) => e.textContent).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Consumer<ChatProvider>(
      builder: (context, chatprovider, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              "Chat History",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ValueListenableBuilder<Box<ChatHistory>>(
                valueListenable: Boxes.getChatHistory().listenable(),
                builder:
                    (BuildContext context, Box<ChatHistory> box, Widget? _) {
                  final chaHistory =
                      box.values.toList().cast<ChatHistory>().reversed.toList();
                  return chaHistory.isEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * .7,
                          child: Center(
                            child: AutoTypeText(
                              text: "Ask Bot Buddy to Create History",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  letterSpacing: 1,
                                  color: isDarkTheme
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: chaHistory.length,
                            itemBuilder: (context, index) {
                              final chat = chaHistory[index];

                              var plainText =
                                  markdownToPlainText(chat.response);
                              return FocusedMenuHolder(
                                onPressed: () {},
                                menuWidth: 150,
                                menuItems: [
                                  FocusedMenuItem(
                                    title: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                    onPressed: () async {
                                      await context
                                          .read<ChatProvider>()
                                          .deletChatMessage(chatID: chat.uid);
                                      await chat.delete();

                                      Get.snackbar("Success",
                                          "Chat Deleted Successfully",
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white);
                                    },
                                    trailingIcon: Icon(
                                      Icons.delete_forever,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                                child: Card(
                                  margin: EdgeInsets.only(bottom: 15),
                                  shadowColor:
                                      isDarkTheme ? Colors.blue : Colors.black,
                                  child: ListTile(
                                    onTap: () async {
                                      final chatprovider =
                                          context.read<ChatProvider>();
                                      await chatprovider.prepareChatRoom(
                                          isNewChat: false, chatID: chat.uid);

                                      chatprovider.setCurrentIndex(newIndex: 1);
                                      chatprovider.pageController.jumpToPage(1);
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: chat.image.isNotEmpty
                                          ? Colors.green
                                          : Colors.blue,
                                      child: Icon(
                                          chat.image.isNotEmpty
                                              ? Icons.image
                                              : Icons.text_snippet_rounded,
                                          color: Colors.white),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    title: Text(chat.name),
                                    subtitle: Text(
                                      plainText,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    trailing:
                                        Icon(Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

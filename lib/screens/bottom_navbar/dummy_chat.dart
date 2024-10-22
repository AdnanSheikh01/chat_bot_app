import 'package:chat_bot_app/models/message.dart';
import 'package:chat_bot_app/providers/chat_provider.dart';
import 'package:chat_bot_app/widgets/auto_type_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreenDum extends StatefulWidget {
  const ChatScreenDum({super.key});

  @override
  State<ChatScreenDum> createState() => _ChatScreenDumState();
}

class _ChatScreenDumState extends State<ChatScreenDum> {
  String _message = "";
  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ChatProvider>(
      builder: (context, chatprovider, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: chatprovider.inchatMessage.isEmpty
                      ? Center(
                          child: AutoTypeText(
                            text: "Let's Explore Chats",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 1,
                                color:
                                    isDarkTheme ? Colors.white : Colors.black),
                          ),
                        )
                      : ListView.builder(
                          itemCount: chatprovider.inchatMessage.length,
                          itemBuilder: (context, index) {
                            final message = chatprovider.inchatMessage[index];
                            return ListTile(
                              title: Text(message.message.toString()),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _message = value;
                            });
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              hintText: "Ask me Anything..."),
                        ),
                      ),
                      _message.isEmpty ? SizedBox.shrink() : SizedBox(width: 5),
                      _message.isEmpty
                          ? SizedBox.shrink()
                          : CircleAvatar(
                              backgroundColor: Colors.indigo,
                              radius: 25,
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.rocket, color: Colors.white),
                              ),
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

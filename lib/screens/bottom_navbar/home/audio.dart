import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../utils/my_data.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  ChatUser myUser = ChatUser(id: '1', firstName: 'Me');
  ChatUser geminiUser = ChatUser(id: '2', firstName: 'Bot Buddy');

  List<ChatMessage> messages = [];

  List<ChatUser> typing = [];
  getData(ChatMessage message) async {
    typing.add(geminiUser);
    messages.insert(0, message);
    setState(() {});
    final model =
        GenerativeModel(model: 'gemini-1.5-flash', apiKey: Utils.apiKey);
    final content = Content.text(message.text);

    final response = await model.generateContent([content]);

    ChatMessage m1 = ChatMessage(
        text: '${response.text}', user: geminiUser, createdAt: DateTime.now());

    messages.insert(0, m1);

    typing.remove(geminiUser);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: isDarkTheme
          ? BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Color(0xff0D1B2A), Color(0xff1C2541)]),
            )
          : BoxDecoration(
              color: Color(0xFFF2F5FA),
            ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Chat Audio",
          ),
        ),
        body: DashChat(
          scrollToBottomOptions: ScrollToBottomOptions(
            scrollToBottomBuilder: (scrollController) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      mini: true,
                      onPressed: () {
                        scrollController.animateTo(
                          scrollController.position.minScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                      backgroundColor:
                          isDarkTheme ? Colors.white : Colors.black,
                      child: Icon(
                        Icons.arrow_downward,
                        color: isDarkTheme ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          typingUsers: typing,
          messageListOptions: const MessageListOptions(
            showDateSeparator: true,
          ),
          messageOptions: MessageOptions(
              messageTextBuilder: (message, previousMessage, nextMessage) {
                return MarkdownBody(
                  data: message.text,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      color: isDarkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
              messagePadding: EdgeInsets.all(15),
              textColor: isDarkTheme ? Colors.white : Colors.black,
              containerColor: isDarkTheme ? Colors.black : Colors.white,
              currentUserTextColor: isDarkTheme ? Colors.white : Colors.black,
              currentUserContainerColor:
                  isDarkTheme ? Colors.indigo : Colors.grey[300]),
          inputOptions: InputOptions(
            sendButtonBuilder: (send) {
              return SizedBox(
                height: size.height * .05,
                child: ElevatedButton(
                  onPressed: send,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: isDarkTheme ? Colors.white : Colors.black,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(Icons.send),
                ),
              );
            },
            autocorrect: true,
            sendOnEnter: true,
            inputDecoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              hintText: 'How can I help you?',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: isDarkTheme ? Colors.black : Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDarkTheme ? Colors.black : Colors.white,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          currentUser: myUser,
          onSend: (ChatMessage message) {
            getData(message);
          },
          messages: messages,
        ),
      ),
    );
  }
}

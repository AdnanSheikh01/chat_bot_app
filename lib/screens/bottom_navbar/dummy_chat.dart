import 'package:chat_bot_app/models/message.dart';
import 'package:chat_bot_app/providers/chat_provider.dart';
import 'package:chat_bot_app/screens/bottom_navbar/assistant_message.dart';
import 'package:chat_bot_app/screens/bottom_navbar/my_message.dart';
import 'package:chat_bot_app/widgets/auto_type_text.dart';
import 'package:chat_bot_app/widgets/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatScreenDum extends StatefulWidget {
  const ChatScreenDum({super.key});

  @override
  State<ChatScreenDum> createState() => _ChatScreenDumState();
}

class _ChatScreenDumState extends State<ChatScreenDum> {
  String _message = "";
  final _mesController = TextEditingController();
  final _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> sendMessage(
      {required String message,
      required ChatProvider chatProvider,
      required bool isTextOnly}) async {
    try {
      await chatProvider.getMessage(message: message, isTextOnly: isTextOnly);
    } catch (e) {
      Get.snackbar("Error!", 'Failed while getting image.',
          colorText: Colors.white, backgroundColor: Colors.red);
    } finally {
      _mesController.clear();
      chatProvider.setImageFileList(imageList: []);
      _message = "";
    }
  }

  Future<void> openImagePicker({required ChatProvider chatprovider}) async {
    try {
      List<XFile>? pickedImages = await _imagePicker.pickMultiImage(
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 95,
      );

      if (pickedImages.isNotEmpty) {
        chatprovider.setImageFileList(imageList: pickedImages);
        setState(() {});
      }
    } catch (e) {
      Get.snackbar(
        "Error!",
        'Failed to get image.',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrolltoBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0.0) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ChatProvider>(
      builder: (context, chatprovider, state) {
        bool hasImages = chatprovider.imageFileList != null &&
            chatprovider.imageFileList!.isNotEmpty;
        if (chatprovider.inchatMessage.isNotEmpty) {
          _scrolltoBottom();
        }

        chatprovider.addListener(() {
          if (chatprovider.inchatMessage.isNotEmpty) {
            _scrolltoBottom();
          }
        });

        return Container(
          decoration: isDarkTheme
              ? BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black,
                        Color(0xff0D1B2A),
                        Color(0xff1C2541)
                      ]),
                )
              : BoxDecoration(
                  color: Color(0xFFF2F5FA),
                ),
          child: Scaffold(
            appBar: AppBar(
              title: Text("Chats"),
              actions: [
                if (chatprovider.inchatMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isDarkTheme ? Colors.grey.shade900 : Colors.black,
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            title: Text("Start New Chat"),
                            content: Text(
                                "Are you sure you want to start a new chat?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await chatprovider.prepareChatRoom(
                                      isNewChat: true, chatID: "");
                                  Navigator.pop(context);
                                  Get.snackbar("Success",
                                      "New Chat Generated Successfully",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white);
                                },
                                child: Text(
                                  "Yes",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      label: Text("New Chat"),
                      icon: Icon(Icons.add),
                    ),
                  )
              ],
            ),
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Expanded(
                      child: chatprovider.inchatMessage.isEmpty
                          ? Center(
                              child: AutoTypeText(
                                text: "Let's Start a Conversation",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    letterSpacing: 1,
                                    color: isDarkTheme
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: chatprovider.inchatMessage.length,
                              itemBuilder: (context, index) {
                                final message =
                                    chatprovider.inchatMessage[index];
                                return message.role == Role.user
                                    ? MyMessageWidget(
                                        data: message,
                                      )
                                    : message.message.toString().isEmpty
                                        ? AssistantMessageWidget(
                                            data: message.message.toString(),
                                          )
                                        : Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                child: Text("B"),
                                              ),
                                              SizedBox(width: 5),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(
                                                      "Bot Buddy",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  AssistantMessageWidget(
                                                    data: message.message
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                              },
                            ),
                    ),
                    Column(
                      children: [
                        if (hasImages) const PreviewImageWidget(),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                textInputAction: TextInputAction.send,
                                controller: _mesController,
                                onChanged: (value) {
                                  setState(() {
                                    _message = value;
                                  });
                                },
                                onSubmitted: chatprovider.isloading
                                    ? null
                                    : (val) {
                                        sendMessage(
                                            message: _message,
                                            chatProvider: chatprovider,
                                            isTextOnly:
                                                hasImages ? false : true);
                                      },
                                decoration: InputDecoration(
                                    prefixIcon: IconButton(
                                      onPressed: () async {
                                        if (hasImages) {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) => AlertDialog(
                                              title: Text("Delete Image"),
                                              content: Text("Are you sure?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    chatprovider
                                                        .setImageFileList(
                                                            imageList: []);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          openImagePicker(
                                              chatprovider: chatprovider);
                                        }
                                      },
                                      icon: Icon(hasImages
                                          ? Icons.delete_forever
                                          : Icons.image),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    filled: true,
                                    fillColor: isDarkTheme
                                        ? Colors.black
                                        : Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    hintText: hasImages
                                        ? "Ask me about this Image..."
                                        : "Ask me Anything..."),
                              ),
                            ),
                            _message.isEmpty
                                ? SizedBox.shrink()
                                : SizedBox(width: 5),
                            _message.isEmpty
                                ? SizedBox.shrink()
                                : CircleAvatar(
                                    backgroundColor: Colors.indigo,
                                    radius: 25,
                                    child: IconButton(
                                      onPressed: chatprovider.isloading
                                          ? null
                                          : () {
                                              sendMessage(
                                                  message: _message,
                                                  chatProvider: chatprovider,
                                                  isTextOnly:
                                                      hasImages ? false : true);
                                            },
                                      icon: Icon(Icons.rocket_outlined,
                                          color: Colors.white),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

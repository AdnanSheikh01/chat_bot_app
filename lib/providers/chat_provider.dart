import 'dart:developer';
import 'dart:typed_data';

import 'package:chat_bot_app/hive/boxes.dart';
import 'package:chat_bot_app/hive/chat_history.dart';
import 'package:chat_bot_app/hive/user_model.dart';
import 'package:chat_bot_app/models/message.dart';
import 'package:chat_bot_app/screens/contrants.dart';
import 'package:chat_bot_app/utils/my_data.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  final List<Message> _inChatMessage = [];
  final PageController _pageController = PageController();
  List<XFile>? _imageFileList = [];
  int _currentIndex = 0;
  String _currentChatId = "";
  GenerativeModel? _model;
  GenerativeModel? _textModel;
  GenerativeModel? _visionModel;
  String _modelType = "gemini-pro";

  bool _isloading = false;

  List<Message> get inchatMessage => _inChatMessage;
  PageController get pageController => _pageController;
  List<XFile>? get imageFileList => _imageFileList;
  int get currentIndex => _currentIndex;
  String get currentChatId => _currentChatId;
  GenerativeModel? get model => _model;
  GenerativeModel? get textModel => _textModel;
  GenerativeModel? get visionModel => _visionModel;
  String get modelType => _modelType;
  bool get isloading => _isloading;

// Set Chat Message
  Future<void> setInChatMessage({required String chatId}) async {
    final messagefromDB = await loadMessage(chatId: chatId);
    for (var message in messagefromDB) {
      if (_inChatMessage.contains(message)) {
        log("Already Message Exist");
        continue;
      }
      _inChatMessage.add(message);
    }
    notifyListeners();
  }

  Future<List<Message>> loadMessage({required String chatId}) async {
    await Hive.openBox('${Contrants.chatMessages}$chatId');

    final messageBox = Hive.box('${Contrants.chatMessages}$chatId');

    final newData = messageBox.keys.map((e) {
      final message = messageBox.get(e);
      final messageData = Message.fromMap(Map<String, dynamic>.from(message));
      return messageData;
    }).toList();
    notifyListeners();
    return newData;
  }

// Set Image List
  void setImageFileList({required List<XFile> imageList}) {
    _imageFileList = imageList;
    notifyListeners();
  }

// Set Current Model
  String setCurrentModel({required String newModel}) {
    _modelType = newModel;
    notifyListeners();
    return newModel;
  }

// Function to Set the Model Based on Bool

  Future<void> setModel({required bool isTextOnly}) async {
    _model ??= (isTextOnly ? _textModel : _visionModel) ??
        GenerativeModel(
          model: setCurrentModel(
              newModel: isTextOnly ? "gemini-1.5-flash" : "gemini-1.5-pro"),
          apiKey: Utils.apiKey,
        );

    notifyListeners();
  }

// Set Current Index
  void setCurrentIndex({required int newIndex}) {
    _currentIndex = newIndex;
    notifyListeners();
  }

// Set current Chat id
  void setCurrentChatId({required String newChatId}) {
    _currentChatId = newChatId;
    notifyListeners();
  }

// Set Loading
  void setLoading({required bool newLoading}) {
    _isloading = newLoading;
    notifyListeners();
  }

// delete Chat
  Future<void> deletChatMessage({required String chatID}) async {
    if (!Hive.isBoxOpen("${Contrants.chatMessages}$chatID")) {
      await Hive.openBox("${Contrants.chatMessages}$chatID");

      await Hive.box("${Contrants.chatMessages}$chatID").clear();
      await Hive.box("${Contrants.chatMessages}$chatID").close();
    } else {
      await Hive.box("${Contrants.chatMessages}$chatID").clear();
      await Hive.box("${Contrants.chatMessages}$chatID").close();
    }

    //get the current chat id, if not empty
    if (currentChatId.isNotEmpty) {
      if (currentChatId == chatID) {
        setCurrentChatId(newChatId: "");
        _inChatMessage.clear();
        notifyListeners();
      }
    }
  }

// prepare chat room
  Future<void> prepareChatRoom(
      {required bool isNewChat, required String chatID}) async {
    if (!isNewChat) {
      // load chat from db
      final chatHistory = await loadMessage(chatId: chatID);

      //clearing inchatmessage
      inchatMessage.clear();

      for (var mesage in chatHistory) {
        _inChatMessage.add(mesage);
      }

      //set current chat id
      setCurrentChatId(newChatId: chatID);
    } else {
      _inChatMessage.clear();

      setCurrentChatId(newChatId: chatID);
    }
  }

// Gettign gemini reponse
  Future<void> getMessage(
      {required String message, required bool isTextOnly}) async {
    //set the model
    await setModel(isTextOnly: isTextOnly);

    // set loading
    setLoading(newLoading: true);

    //get the chat id
    String chatId = getChatID();

    //list of history message
    List<Content> history = [];

    //get the chat history
    history = await getHistory(chatId: chatId);

    //get th images urls
    List<String> imagesUrls = getImageUrls(isTextOnly: isTextOnly);

    final messageBox = await Hive.openBox('${Contrants.chatMessages}$chatId');

    //user message id
    final userMessageId = messageBox.keys.length;

    //assistant message id
    final assistantMessageId = messageBox.keys.length + 1;

    //get the user message
    final userMessage = Message(
      messageId: userMessageId.toString(),
      chatId: chatId,
      role: Role.user,
      message: StringBuffer(message),
      imageUrls: imagesUrls,
      timeSent: DateTime.now(),
    );

    // add message to inChatMeassage
    _inChatMessage.add(userMessage);

    notifyListeners();

    if (currentChatId.isEmpty) {
      setCurrentChatId(newChatId: chatId);
    }

    await sendMessageAndGettingResponse(
        message: message,
        chatId: chatId,
        isTextOnly: isTextOnly,
        history: history,
        userMessage: userMessage,
        modelMessageId: assistantMessageId.toString(),
        messageBox: messageBox);
  }

// send the message to the model and wait for the response
  Future<void> sendMessageAndGettingResponse(
      {required String message,
      required String chatId,
      required bool isTextOnly,
      required List<Content> history,
      required Message userMessage,
      required String modelMessageId,
      required Box messageBox}) async {
    final chatSession = _model!
        .startChat(history: history.isEmpty || !isTextOnly ? null : history);

    //get content
    final content = await getContent(message: message, isTextOnly: isTextOnly);

    final modelMessageId = const Uuid().v4();

    //assistant message
    final assistantMessage = userMessage.copyWith(
      messageId: modelMessageId,
      role: Role.assistant,
      message: StringBuffer(),
      timeSent: DateTime.now(),
    );

    //add this message in inChatMessage
    _inChatMessage.add(assistantMessage);
    notifyListeners();

    chatSession.sendMessageStream(content).asyncMap((event) {
      return event;
    }).listen(
      (event) {
        _inChatMessage
            .firstWhere((element) =>
                element.messageId == assistantMessage.messageId &&
                element.role.name == Role.assistant.name)
            .message
            .write(event.text);
        notifyListeners();
      },
      onDone: () async {
        //save message to hive db
        await saveDataInHiveDB(
            chatID: chatId,
            userMessage: userMessage,
            assistantMessage: assistantMessage,
            messageBox: messageBox);

        //set loading to false
        setLoading(newLoading: false);
      },
    ).onError((error, stacktrace) {
      //set loading to false
      setLoading(newLoading: false);
    });
  }

// save to hive db
  Future<void> saveDataInHiveDB(
      {required String chatID,
      required Message userMessage,
      required Message assistantMessage,
      required Box messageBox}) async {
    //save the user message
    await messageBox.add(userMessage.toMap());

    //save the assistant message
    await messageBox.add(assistantMessage.toMap());

    //save the history with same chatID
    final chatHistoryBox = Boxes.getChatHistory();

    final chatHistory = ChatHistory(
        uid: chatID,
        name: userMessage.message.toString(),
        response: assistantMessage.message.toString(),
        image: userMessage.imageUrls,
        timestamp: DateTime.now());

    await chatHistoryBox.put(chatID, chatHistory);

    //close the box

    await messageBox.close();
  }

// get Content
  Future<Content> getContent({
    required String message,
    required bool isTextOnly,
  }) async {
    if (isTextOnly) {
      return Content.text(message);
    } else {
      if (_imageFileList == null || _imageFileList!.isEmpty) {
        log("Image list is empty.");
        return Content.text("No images found.");
      }

      // final futureImage = _imageFileList!
      //     .map((imageFile) => imageFile.readAsBytes())
      //     .toList(growable: false);
      final futureImage = _imageFileList!.map((imageFile) async {
        try {
          return await imageFile.readAsBytes();
        } catch (e) {
          log("Error reading image bytes: $e");
          return Uint8List(0);
        }
      });

      final imageByte = await Future.wait(futureImage);
      if (imageByte.any((bytes) => bytes.isEmpty)) {
        throw Exception("Some images could not be read properly.");
      }
      final prompt = TextPart(message);
      final imageParts =
          imageByte.map((bytes) => DataPart('image/jpeg', bytes)).toList();

      return Content.multi([prompt, ...imageParts]);
    }
  }

// get the image Urls
  List<String> getImageUrls({required bool isTextOnly}) {
    List<String> imageUrls = [];
    if (!isTextOnly && imageFileList != null) {
      for (var image in imageFileList!) {
        imageUrls.add(image.path);
      }
    }
    return imageUrls;
  }

// get the history
  Future<List<Content>> getHistory({required String chatId}) async {
    List<Content> history = [];
    if (currentChatId.isNotEmpty) {
      await setInChatMessage(chatId: chatId);

      for (var message in inchatMessage) {
        if (message.role == Role.user) {
          history.add(Content.text(message.message.toString()));
        } else {
          history.add(
            Content.model(
              [
                TextPart(
                  message.message.toString(),
                ),
              ],
            ),
          );
        }
      }
    }
    return history;
  }

  String getChatID() {
    if (currentChatId.isEmpty) {
      return Uuid().v4();
    } else {
      return currentChatId;
    }
  }

  static Future<void> initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    await Hive.initFlutter(Contrants.geminiDB);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatHistoryAdapter());
      await Hive.openBox<ChatHistory>(Contrants.chatHistoryBox);
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserModelAdapter());
      await Hive.openBox<UserModel>(Contrants.userBox);
    }
  }
}

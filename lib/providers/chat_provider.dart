import 'package:chat_bot_app/hive/chat_history.dart';
import 'package:chat_bot_app/hive/user_model.dart';
import 'package:chat_bot_app/models/message.dart';
import 'package:chat_bot_app/screens/contrants.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ChatProvider extends ChangeNotifier {
  final List<Message> _inChatMessage = [];
  final PageController _pageController = PageController();
  final List<XFile> _imageFileList = [];
  final int _currentIndex = 0;
  final String _currentChatId = "";
  GenerativeModel? _model;
  GenerativeModel? _textModel;
  GenerativeModel? _visionModel;
  final String _modelType = "gemini-1.5-flash";

  List<Message> get inchatMessage => _inChatMessage;
  PageController get pageController => _pageController;
  List<XFile>? get imageFileList => _imageFileList;
  int get currentIndex => _currentIndex;
  String get currentChatId => _currentChatId;
  GenerativeModel? get model => _model;
  GenerativeModel? get textModel => _textModel;
  GenerativeModel? get visionModel => _visionModel;
  String get modelType => _modelType;

  static initHive() async {
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

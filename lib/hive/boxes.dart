import 'package:chat_bot_app/hive/chat_history.dart';
import 'package:chat_bot_app/hive/user_model.dart';
import 'package:chat_bot_app/screens/contrants.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<ChatHistory> getChatHistory() =>
      Hive.box<ChatHistory>(Contrants.chatHistoryBox);
  static Box<UserModel> getUser() => Hive.box<UserModel>(Contrants.userBox);
}

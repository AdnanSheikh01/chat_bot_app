import 'package:hive_flutter/hive_flutter.dart';
part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  final String chatId;

  @HiveField(1)
  final String prompt;

  @HiveField(2)
  final String response;

  @HiveField(3)
  final List<String> imageUrl;

  @HiveField(4)
  final String timestamp;

  UserModel(
      {required this.chatId,
      required this.prompt,
      required this.response,
      required this.imageUrl,
      required this.timestamp});
}

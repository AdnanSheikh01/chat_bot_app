import 'package:hive_flutter/hive_flutter.dart';

part 'chat_history.g.dart';

@HiveType(typeId: 0)
class ChatHistory extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String response;

  @HiveField(3)
  final List<String> image;

  @HiveField(4)
  final DateTime timestamp;

  ChatHistory({
    required this.uid,
    required this.name,
    required this.response,
    required this.image,
    required this.timestamp,
  });
}

class Message {
  String messageId;
  String chatId;
  Role role;
  StringBuffer message;
  List<String> imagUrl;
  DateTime timeSent;
  Message({
    required this.messageId,
    required this.chatId,
    required this.role,
    required this.message,
    required this.imagUrl,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'chatId': chatId,
      'role': role.index,
      'message': message.toString(),
      'imagUrl': imagUrl,
      'timeSent': timeSent.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['messageId'],
      chatId: map['chatId'],
      role: Role.values[map['role']],
      message: StringBuffer(map['message']),
      imagUrl: List<String>.from(map['imagUrl']),
      timeSent: DateTime.parse(map['timeSent']),
    );
  }

  Message copyWith({
    String? messageId,
    String? chatId,
    Role? role,
    StringBuffer? message,
    List<String>? imagUrl,
    DateTime? timeSent,
  }) {
    return Message(
        messageId: messageId ?? this.messageId,
        chatId: chatId ?? this.chatId,
        role: role ?? this.role,
        message: message ?? this.message,
        imagUrl: imagUrl ?? this.imagUrl,
        timeSent: timeSent ?? this.timeSent);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.messageId == messageId;
  }

  @override
  int get hashCode {
    return messageId.hashCode;
  }
}

enum Role {
  user,
  assistant,
}

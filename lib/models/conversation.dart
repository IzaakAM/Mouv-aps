import 'chat_message.dart';

class Conversation {
  final int id;
  final int user1; // user1 ID from backend
  final int user2; // user2 ID
  final DateTime createdAt;
  final List<ChatMessage> messages;

  Conversation({
    required this.id,
    required this.user1,
    required this.user2,
    required this.createdAt,
    required this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    // "messages" in the backend is nested
    var msgs = <ChatMessage>[];
    if (json['messages'] != null) {
      msgs = (json['messages'] as List)
          .map((m) => ChatMessage.fromJson(m))
          .toList();
    }

    return Conversation(
      id: json['id'],
      user1: json['user1'],
      user2: json['user2'],
      createdAt: DateTime.parse(json['created_at']),
      messages: msgs,
    );
  }

  get user1Name => 'User $user1';
  get user2Name => 'User $user2';
}

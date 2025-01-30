class ChatMessage {
  final int id;
  final int conversationId;
  final String sender;
  final String message;
  final DateTime sentAt;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.message,
    required this.sentAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      conversationId: json['conversation'],
      sender: json['sender'], // a string username from the API
      message: json['message'],
      sentAt: DateTime.parse(json['sent_at']),
    );
  }
}

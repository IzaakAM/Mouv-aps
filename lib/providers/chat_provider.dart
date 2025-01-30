import 'package:flutter/material.dart';
import 'package:mouv_aps/models/conversation.dart';
import 'package:mouv_aps/models/chat_message.dart';
import 'package:mouv_aps/services/api_service.dart';

class ChatProvider with ChangeNotifier {
  bool isLoading = false;
  String errorMessage = '';

  List<Conversation> _conversations = [];
  List<Conversation> get conversations => _conversations;

  // Example: fetch all conversations
  Future<void> fetchConversations() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final convList = await ApiService.fetchConversations();
      _conversations = convList;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Example: send message to a user by username
  Future<void> sendMessageToUsername(String username, String text) async {
    try {
      final newMsg = await ApiService.sendMessageToUsername(
        recipientUsername: username,
        text: text,
      );
      // This newMsg includes conversation ID
      // Update the local conversation for that ID if we have it
      // or fetch again from the server if needed
      await fetchConversations(); // simplistic approach
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Or if you have conversation-based approach
  Future<void> sendMessageToConversation(int conversationId, String text) async {
    try {
      final newMsg = await ApiService.sendMessageToConversation(
        conversationId: conversationId,
        text: text,
      );
      // Insert the newMsg into the local conversation
      final index = _conversations.indexWhere((c) => c.id == conversationId);
      if (index != -1) {
        // Insert message into that conversation
        final conv = _conversations[index];
        final updatedMessages = List<ChatMessage>.from(conv.messages)
          ..add(newMsg);
        final updatedConv = Conversation(
          id: conv.id,
          user1: conv.user1,
          user2: conv.user2,
          createdAt: conv.createdAt,
          messages: updatedMessages,
        );
        _conversations[index] = updatedConv;
        notifyListeners();
      }
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Conversation? findConversationByUsername(String username) {
    for (var c in _conversations) {
      // If you have c.user1Name / c.user2Name for example:
      if (c.user1Name == username || c.user2Name == username) {
        return c;
      }
    }
    return null;
  }
}

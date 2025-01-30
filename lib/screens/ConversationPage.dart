import 'package:flutter/material.dart';
import 'package:mouv_aps/models/conversation.dart';
import 'package:mouv_aps/models/chat_message.dart';
import 'package:provider/provider.dart';
import 'package:mouv_aps/providers/chat_provider.dart';

class ConversationPage extends StatefulWidget {
  final Conversation conversation;
  const ConversationPage({Key? key, required this.conversation}) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final chatProvider = context.read<ChatProvider>();

    // Assuming we have a conversation-based endpoint:
    await chatProvider.sendMessageToConversation(widget.conversation.id, text);

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Possibly re-fetch the conversation from the provider
    final conv = context.select<ChatProvider, Conversation?>((cp) {
      return cp.conversations.firstWhere(
            (c) => c.id == widget.conversation.id,
        orElse: () => widget.conversation,
      );
    });

    final messages = conv?.messages ?? widget.conversation.messages;

    return Scaffold(
      appBar: AppBar(title: Text('Conversation #${widget.conversation.id}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (ctx, index) {
                final ChatMessage msg = messages[index];
                final isMe = (msg.sender == "myUsername"); // or compare user IDs
                return Container(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(msg.message),
                  ),
                );
              },
            ),
          ),
          // Input field
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

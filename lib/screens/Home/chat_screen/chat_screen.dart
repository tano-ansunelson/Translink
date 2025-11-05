import 'package:flutter/material.dart';

class TransLinkChatPage extends StatefulWidget {
  const TransLinkChatPage({super.key});
  static const String id = 'translink_chat_page';

  @override
  State<TransLinkChatPage> createState() => _TransLinkChatPageState();
}

class _TransLinkChatPageState extends State<TransLinkChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> messages = [
    ChatMessage(
      sender: 'other',
      text: "Hello, I'm at the pickup point. Are you ready?",
      timestamp: '10:30 AM',
      avatarColor: const Color(0xFFE8D5C4),
    ),
    ChatMessage(
      sender: 'me',
      text: "Yes, I'm here. Just finishing up a few things.",
      timestamp: '10:31 AM',
      avatarColor: const Color(0xFF4A9BA8),
    ),
    ChatMessage(
      sender: 'other',
      text: "Great, see you in a bit.",
      timestamp: '10:32 AM',
      avatarColor: const Color(0xFF2D5A66),
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  // User info
                  Stack(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE8D5C4),
                        ),
                        child: const Center(
                          child: Icon(Icons.person, size: 24),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF4CAF50),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kwame Mensah',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Online',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: const Color(0xFF999999)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('More options pressed')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildChatBubble(message),
                  );
                },
              ),
            ),
            // Message input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: const TextStyle(
                          color: Color(0xFFCCCCCC),
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF5F5F5),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.emoji_emotions_outlined,
                        color: Color(0xFF999999),
                        size: 20,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Emoji picker opened')),
                        );
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFA500),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                          setState(() {
                            messages.add(
                              ChatMessage(
                                sender: 'me',
                                text: _messageController.text,
                                timestamp: _getCurrentTime(),
                                avatarColor: const Color(0xFF4A9BA8),
                              ),
                            );
                          });
                          _messageController.clear();
                        }
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    final isMe = message.sender == 'me';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe) ...[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: message.avatarColor,
            ),
            child: const Icon(Icons.person, size: 18),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isMe
                      ? const Color(0xFFFFA500)
                      : const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    fontSize: 14,
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message.timestamp,
                style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
            ],
          ),
        ),
        if (isMe) ...[
          const SizedBox(width: 8),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: message.avatarColor,
            ),
            child: const Icon(Icons.person, size: 18, color: Colors.white),
          ),
        ],
      ],
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
  }
}

class ChatMessage {
  final String sender; // 'me' or 'other'
  final String text;
  final String timestamp;
  final Color avatarColor;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
    required this.avatarColor,
  });
}

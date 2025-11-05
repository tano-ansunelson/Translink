import 'package:flutter/material.dart';
import 'package:translink/screens/Home/chat_screen/chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});
  static const String id = 'messages_screen';

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _searchController = TextEditingController();

  final List<MessageItem> _messages = [
    MessageItem(
      name: 'Kofi Mensah',
      message: 'Okay, I will meet you at the Accra...',
      time: '10:45 AM',
      avatar: 'assets/kofi.png',
      isOnline: true,
      unreadCount: 2,
    ),
    MessageItem(
      name: 'Ama Serwaa',
      message: 'Perfect, thank you!',
      time: 'Yesterday',
      avatar: 'assets/ama.png',
      isOnline: false,
      unreadCount: 0,
    ),
    MessageItem(
      name: 'Femi Adebayo',
      message: 'The package has been delivered s...',
      time: 'Mon',
      avatar: 'assets/femi.png',
      isOnline: true,
      unreadCount: 1,
    ),
    MessageItem(
      name: 'Adjoa Afriyie',
      message: 'Are you on your way?',
      time: 'Sun',
      avatar: 'assets/adjoa.png',
      isOnline: false,
      unreadCount: 0,
    ),
    MessageItem(
      name: 'Kwame Nkrumah',
      message: 'Typing...',
      time: '3/15/24',
      avatar: 'assets/kwame.png',
      isOnline: false,
      unreadCount: 0,
      isTyping: true,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        // ),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Handle menu action
            },
            icon: const Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search conversations',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade400,
                  size: 24,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFFFA500),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageTile(_messages[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(MessageItem message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, TransLinkChatPage.id);
            // Navigate to chat screen
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar with online indicator
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: AssetImage(message.avatar),
                      onBackgroundImageError: (exception, stackTrace) {},
                      child: message.avatar.isEmpty
                          ? const Icon(Icons.person, size: 30)
                          : null,
                    ),
                    if (message.isOnline)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),

                // Message content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            message.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            message.time,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              message.message,
                              style: TextStyle(
                                fontSize: 14,
                                color: message.isTyping
                                    ? const Color(0xFF2196F3)
                                    : message.unreadCount > 0
                                    ? const Color(0xFFFFA500)
                                    : Colors.grey.shade600,
                                fontWeight: message.unreadCount > 0
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (message.unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFA500),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 24,
                                minHeight: 24,
                              ),
                              child: Center(
                                child: Text(
                                  message.unreadCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageItem {
  final String name;
  final String message;
  final String time;
  final String avatar;
  final bool isOnline;
  final int unreadCount;
  final bool isTyping;

  MessageItem({
    required this.name,
    required this.message,
    required this.time,
    required this.avatar,
    this.isOnline = false,
    this.unreadCount = 0,
    this.isTyping = false,
  });
}

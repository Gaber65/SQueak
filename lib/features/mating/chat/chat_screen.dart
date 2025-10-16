import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

// Models
class MatingChat {
  final String id;
  final String petAName;
  final String petBName;
  final String petBreed;
  final String petImage;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;
  final ChatStatus status;

  MatingChat({
    required this.id,
    required this.petAName,
    required this.petBName,
    required this.petBreed,
    required this.petImage,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isOnline = false,
    required this.status,
  });
}

enum ChatStatus { active, onMating, completed, blocked }

// Professional Chat List Screen
class ProfessionalChatListScreen extends StatefulWidget {
  const ProfessionalChatListScreen({super.key});

  @override
  _ProfessionalChatListScreenState createState() =>
      _ProfessionalChatListScreenState();
}

class _ProfessionalChatListScreenState
    extends State<ProfessionalChatListScreen> {
  List<MatingChat> chats = [
    MatingChat(
      id: '1',
      petAName: 'You',
      petBName: 'Luna',
      petBreed: 'German Shepherd',
      petImage: 'assets/luna.jpg',
      lastMessage: 'Hello! Would you like to mate our pets?',
      lastMessageTime: DateTime.now().subtract(Duration(minutes: 5)),
      unreadCount: 2,
      isOnline: true,
      status: ChatStatus.active,
    ),
    MatingChat(
      id: '2',
      petAName: 'You',
      petBName: 'Charlie',
      petBreed: 'Golden Retriever',
      petImage: 'assets/charlie.jpg',
      lastMessage: 'Mating process started successfully! 🎉',
      lastMessageTime: DateTime.now().subtract(Duration(hours: 2)),
      unreadCount: 0,
      isOnline: false,
      status: ChatStatus.onMating,
    ),
    MatingChat(
      id: '3',
      petAName: 'You',
      petBName: 'Bella',
      petBreed: 'Siberian Husky',
      petImage: 'assets/bella.jpg',
      lastMessage: 'Thank you for the wonderful experience!',
      lastMessageTime: DateTime.now().subtract(Duration(days: 1)),
      unreadCount: 0,
      isOnline: true,
      status: ChatStatus.completed,
    ),
    MatingChat(
      id: '4',
      petAName: 'You',
      petBName: 'Max',
      petBreed: 'Labrador Retriever',
      petImage: 'assets/max.jpg',
      lastMessage: 'Looking forward to meeting your pet!',
      lastMessageTime: DateTime.now().subtract(Duration(days: 3)),
      unreadCount: 1,
      isOnline: false,
      status: ChatStatus.active,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Status Section
          Container(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildStatusItem('All', 12, true),
                _buildStatusItem(ChatStatus.active.name, 8, false),
                _buildStatusItem(ChatStatus.onMating.name, 3, false),
                _buildStatusItem(ChatStatus.completed.name, 1, false),
                _buildStatusItem(ChatStatus.blocked.name, 0, false),
              ],
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return _buildChatListItem(chat);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String title, int count, bool isActive) {
    return Container(
      margin: EdgeInsets.only(right: 12, top: 8, bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? ColorManager.primaryColor: Colors.grey[50],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: isActive ? ColorManager.primaryColor : Colors.grey[300]!),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            chats = chats.where((chat) => chat.status.name == title).toList();
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            if (count > 0) ...[
              SizedBox(width: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : ColorManager.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: isActive ? ColorManager.primaryColor : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChatListItem(MatingChat chat) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: ListTile(
        leading: Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.primaryColor.withOpacity(0.1),
              ),
              child: Icon(Icons.pets, color: ColorManager.primaryColor),
            ),
            if (chat.isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Text(
              chat.petBName,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            SizedBox(width: 6),
            _buildStatusIndicator(chat.status),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                chat.lastMessage,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (chat.unreadCount > 0) ...[
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: ColorManager.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  chat.unreadCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatTime(chat.lastMessageTime),
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            if (chat.status == ChatStatus.onMating)
              Icon(Icons.favorite, color: ColorManager.primaryColor, size: 16),
          ],
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfessionalChatScreen(chat: chat),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusIndicator(ChatStatus status) {
    Color color;
    IconData icon;

    switch (status) {
      case ChatStatus.active:
        color = Colors.blue;
        icon = Icons.chat;
        break;
      case ChatStatus.onMating:
        color = Colors.green;
        icon = Icons.favorite;
        break;
      case ChatStatus.completed:
        color = Colors.purple;
        icon = Icons.check_circle;
        break;
      case ChatStatus.blocked:
        color = Colors.red;
        icon = Icons.block;
        break;
    }

    return Icon(icon, color: color, size: 16);
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}

// Professional Chat Screen
class ProfessionalChatScreen extends StatefulWidget {
  final MatingChat chat;

  const ProfessionalChatScreen({Key? key, required this.chat})
    : super(key: key);

  @override
  _ProfessionalChatScreenState createState() => _ProfessionalChatScreenState();
}

class _ProfessionalChatScreenState extends State<ProfessionalChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Sample messages
    _messages.addAll([
      ChatMessage(
        text:
            'Hello! I saw your profile and I think our pets would be a great match!',
        isMe: false,
        time: DateTime.now().subtract(Duration(hours: 2)),
        status: MessageStatus.delivered,
      ),
      ChatMessage(
        text:
            'Hi! Yes, my German Shepherd is very gentle and well-trained. Would you like to schedule a meeting?',
        isMe: true,
        time: DateTime.now().subtract(Duration(hours: 1, minutes: 45)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        text: 'That sounds perfect! How about this weekend?',
        isMe: false,
        time: DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
        status: MessageStatus.delivered,
      ),
      ChatMessage(
        text:
            'Saturday works great for us! Should we meet at the central park?',
        isMe: true,
        time: DateTime.now().subtract(Duration(minutes: 45)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        text: 'Perfect! See you then at 2 PM. Looking forward to it! 🐕',
        isMe: false,
        time: DateTime.now().subtract(Duration(minutes: 30)),
        status: MessageStatus.delivered,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorManager.primaryColor.withOpacity(0.1),
                  ),
                  child: Icon(Icons.pets, color: ColorManager.primaryColor),
                ),
                if (widget.chat.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.petBName,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  Text(
                    widget.chat.isOnline ? 'Online' : 'Last seen recently',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam, color: Colors.grey[700]),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.call, color: Colors.grey[700]),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleAction(value),
            icon: Icon(Icons.more_vert, color: Colors.grey[700]),
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem(
                    value: 'view_profile',
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('View Profile'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'start_mating',
                    child: Row(
                      children: [
                        Icon(Icons.favorite, color: ColorManager.primaryColor),
                        SizedBox(width: 8),
                        Text('Start Mating Process'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'block',
                    child: Row(
                      children: [
                        Icon(Icons.block, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Block User'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'end_chat',
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app, color: Colors.orange),
                        SizedBox(width: 8),
                        Text('End Chat'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Mating Status Banner
          if (widget.chat.status == ChatStatus.onMating)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              color: Colors.green[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, color: Colors.green, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Mating Process Started',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.primaryColor.withOpacity(0.1),
              ),
              child: Icon(Icons.pets, size: 18, color: ColorManager.primaryColor),
            ),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  message.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isMe ? ColorManager.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMe ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatMessageTime(message.time),
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                    if (message.isMe) ...[
                      SizedBox(width: 4),
                      Icon(
                        message.status == MessageStatus.read
                            ? Icons.done_all
                            : Icons.done,
                        size: 12,
                        color:
                            message.status == MessageStatus.read
                                ? Colors.blue
                                : Colors.grey,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (message.isMe) SizedBox(width: 8),
          if (message.isMe)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[100],
              ),
              child: Icon(Icons.person, size: 18, color: Colors.blue),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          // Attachment Button
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.grey[600]),
            onPressed: () {},
          ),
          // Emoji Button
          IconButton(
            icon: Icon(Icons.emoji_emotions, color: Colors.grey[600]),
            onPressed: () {},
          ),
          // Message Input
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          ),
          // Send Button
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.primaryColor,
              ),
              child: Icon(Icons.send, color: Colors.white, size: 20),
            ),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: text,
            isMe: true,
            time: DateTime.now(),
            status: MessageStatus.sent,
          ),
        );
        _messageController.clear();
      });

      // Auto-scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  String _formatMessageTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _handleAction(String value) {
    switch (value) {
      case 'view_profile':
        // Navigate to profile
        break;
      case 'start_mating':
        _showStartMatingDialog();
        break;
      case 'block':
        _showBlockDialog();
        break;
      case 'end_chat':
        _showEndChatDialog();
        break;
    }
  }

  void _showStartMatingDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Start Mating Process'),
            content: Text(
              'Are you sure you want to start the mating process with ${widget.chat.petBName}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mating process started!')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: ColorManager.primaryColor),
                child: Text('Start', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Block User'),
            content: Text(
              'Are you sure you want to block ${widget.chat.petBName}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('User blocked')));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Block', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  void _showEndChatDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('End Chat'),
            content: Text(
              'Are you sure you want to end this chat? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Chat ended')));
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Text('End Chat', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;
  final MessageStatus status;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    required this.status,
  });
}

enum MessageStatus { sent, delivered, read }

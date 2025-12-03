// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'core/service/cache/shared_preferences/cache_helper.dart';
// import 'core/service/signalr/signalr_conversation_services.dart';
// import 'core/service/signalr/signalr_general_service.dart';

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await CacheHelper.init();
//   runApp(const SqueakChatApp());
// }

// class SqueakChatApp extends StatelessWidget {
//   const SqueakChatApp({super.key});


//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Squeak Chat',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         useMaterial3: true,
//       ),
//       home: const ChatScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final SignalRConversationHubService _conversationHub = SignalRConversationHubService();
//   final SignalRGeneralHubService _generalHub = SignalRGeneralHubService();
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   final List<ChatMessage> _messages = [];
//   bool _friendTyping = false;

//   @override
//   void initState() {
//     super.initState();
//     _initSignalR();
//   }

//   void _initSignalR() async {
//     await _generalHub.connect(petId: 'your-pet-id');
//     await _conversationHub.connect(
//       conversationId: '7dfa010a-da56-4052-9cb2-1bd3b0f16235',
//       petId: 'c82a5cfc-ec59-4cb1-bcfb-4331d39c6388',
//     );

//     // الاستماع لجميع الأحداث
//     conversationSignalEventStream.stream.listen((event) {
//       if (event.hub == "ConversationHub") {
//         if (event.method == "ReceiveMessageFromUser" || event.method == "NewMessage") {
//           final data = event.data?.first as Map<String, dynamic>?;
//           if (data != null) {
//             _addChatMessage(data['Description'] ?? '', false);
//           }
//         } else if (event.method == "SetTyping") {
//           final data = event.data;
//           if (data != null && data.isNotEmpty) {
//             final isTyping = data[2] as bool? ?? false;
//             setState(() {
//               _friendTyping = isTyping;
//             });
//           }
//         }
//       }

//       if (event.hub == "GeneralHub" && event.method == "FriendIsTyping") {
//         final data = event.data;
//         if (data != null && data.isNotEmpty) {
//           final isTyping = data[0] as bool? ?? false;
//           setState(() {
//             _friendTyping = isTyping;
//           });
//         }
//       }
//     });
//   }

//   void _addChatMessage(String text, bool isMe) {
//     setState(() {
//       _messages.add(ChatMessage(text: text, isMe: isMe, timestamp: DateTime.now()));
//     });
//     _scrollToBottom();
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   void _sendMessage() async {
//     if (_messageController.text.isEmpty) return;

//     final text = _messageController.text;
//     _messageController.clear();

//     _addChatMessage(text, true);

//     final command = {
//       "ConversationId": "7dfa010a-da56-4052-9cb2-1bd3b0f16235",
//       "FromPetId": "c82a5cfc-ec59-4cb1-bcfb-4331d39c6388",
//       "ToPetId": "b0ae0b8b-ec59-4801-b62e-1fcc5992596c",
//       "Description": text,
//     };

//     await _conversationHub.sendMessageToUser(command);
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     _conversationHub.disconnect();
//     _generalHub.disconnect();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Squeak Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 return Align(
//                   alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     child: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: msg.isMe ? Colors.blue[100] : Colors.grey[300],
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(msg.text),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           if (_friendTyping)
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text('Friend is typing...', style: TextStyle(fontStyle: FontStyle.italic)),
//               ),
//             ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(
//                       hintText: 'Type a message...',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChatMessage {
//   final String text;
//   final bool isMe;
//   final DateTime timestamp;

//   ChatMessage({required this.text, this.isMe = false, required this.timestamp});
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wizzy/core/constants/app_colors.dart';
import 'package:wizzy/features/messenger/models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  const ChatScreen({super.key, required this.receiverId, required this.receiverName});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final String currentId = FirebaseAuth.instance.currentUser!.uid;

  String getChatId() {
    return currentId.hashCode <= widget.receiverId.hashCode ? "${currentId}_${widget.receiverId}" : "${widget.receiverId}_$currentId";
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(getChatId());
    final messageData = MessageModel(
      id: "", 
      senderId: currentId, 
      text: _messageController.text.trim(), 
      timestamp: Timestamp.now(),
      status: MessageStatus.sent
    );
    _messageController.clear();
    await chatRef.collection('messages').add(messageData.toMap());
    await chatRef.set({'lastTimestamp': FieldValue.serverTimestamp(), 'participants': [currentId, widget.receiverId]}, SetOptions(merge: true));
  }

  void _markAsRead() async {
    final messages = await FirebaseFirestore.instance.collection('chats').doc(getChatId()).collection('messages')
        .where('senderId', isEqualTo: widget.receiverId)
        .where('status', isNotEqualTo: MessageStatus.read.toString())
        .get();
    for (var doc in messages.docs) {
      await doc.reference.update({'status': MessageStatus.read.toString()});
    }
  }

  @override
  Widget build(BuildContext context) {
    _markAsRead(); // Marquer comme lu à l'ouverture
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text(widget.receiverName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('chats').doc(getChatId()).collection('messages').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true, padding: const EdgeInsets.all(20), itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final msg = MessageModel.fromFirestore(docs[index].data() as Map<String, dynamic>, docs[index].id);
                    return _buildBubble(msg);
                  },
                );
              },
            ),
          ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildBubble(MessageModel msg) {
    bool isMe = msg.senderId == currentId;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryPurple : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(msg.text, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 4),
            if (isMe) _statusIcon(msg.status),
          ],
        ),
      ),
    );
  }

  Widget _statusIcon(MessageStatus status) {
    IconData icon = Icons.check;
    Color color = Colors.white38;
    if (status == MessageStatus.read) { icon = Icons.done_all; color = Colors.blueAccent; }
    else if (status == MessageStatus.delivered) { icon = Icons.done_all; }
    return Icon(icon, size: 12, color: color);
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.black,
      child: Row(children: [
        Expanded(child: TextField(controller: _messageController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "Message...", border: InputBorder.none))),
        IconButton(onPressed: _sendMessage, icon: const Icon(Icons.send, color: AppColors.accentYellow)),
      ]),
    );
  }
}


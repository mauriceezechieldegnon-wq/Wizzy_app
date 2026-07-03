import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

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
  bool _isTyping = false;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    // On marque comme lu UNE SEULE FOIS à l'ouverture
    _markAsRead();
  }

  @override
  void dispose() {
    _setTyping(false);
    _messageController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  String getChatId() {
    return currentId.hashCode <= widget.receiverId.hashCode 
        ? "${currentId}_${widget.receiverId}" 
        : "${widget.receiverId}_$currentId";
  }

  // --- LOGIQUE WHATSAPP : EN TRAIN D'ÉCRIRE ---
  void _onTextChanged(String value) {
    if (!_isTyping) {
      _setTyping(true);
    }
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () => _setTyping(false));
  }

  void _setTyping(bool typing) {
    if (_isTyping == typing) return;
    setState(() => _isTyping = typing);
    FirebaseFirestore.instance.collection('chats').doc(getChatId()).set({
      'typing': { currentId: typing }
    }, SetOptions(merge: true));
  }

  // --- LOGIQUE WHATSAPP : COCHES BLEUES ---
  void _markAsRead() async {
    final messages = await FirebaseFirestore.instance
        .collection('chats')
        .doc(getChatId())
        .collection('messages')
        .where('senderId', isEqualTo: widget.receiverId)
        .where('status', isNotEqualTo: MessageStatus.read.toString())
        .get();

    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var doc in messages.docs) {
      batch.update(doc.reference, {'status': MessageStatus.read.toString()});
    }
    await batch.commit();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(getChatId());
    final String messageText = _messageController.text.trim();
    _messageController.clear();
    _setTyping(false);

    final newMessage = MessageModel(
      id: "",
      senderId: currentId,
      text: messageText,
      timestamp: Timestamp.now(),
      status: MessageStatus.sent, // ✓ Gris
    );

    await chatRef.collection('messages').add(newMessage.toMap());
    
    await chatRef.set({
      'lastTimestamp': FieldValue.serverTimestamp(),
      'lastMessage': messageText,
      'participants': [currentId, widget.receiverId],
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.receiverName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            // Indicateur "En train d'écrire" en direct
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('chats').doc(getChatId()).snapshots(),
              builder: (context, snap) {
                if (snap.hasData && snap.data!.exists) {
                  Map? typing = snap.data!['typing'];
                  if (typing != null && typing[widget.receiverId] == true) {
                    return const Text("en train d'écrire...", style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontStyle: FontStyle.italic));
                  }
                }
                return const Text("en ligne", style: TextStyle(color: Colors.white38, fontSize: 10));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(getChatId())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(20),
                  itemCount: docs.length,
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryPurple : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(msg.text, style: const TextStyle(color: Colors.white, fontSize: 15)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${msg.timestamp.toDate().hour}:${msg.timestamp.toDate().minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(color: Colors.white24, fontSize: 9),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  _buildStatusIcon(msg.status),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    if (status == MessageStatus.read) {
      return const Icon(Icons.done_all, color: Colors.blueAccent, size: 13); // ✓✓ Bleu
    } else if (status == MessageStatus.delivered) {
      return const Icon(Icons.done_all, color: Colors.white38, size: 13); // ✓✓ Gris
    }
    return const Icon(Icons.check, color: Colors.white38, size: 13); // ✓ Gris
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                onChanged: _onTextChanged,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Message",
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.03),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send_rounded, color: AppColors.accentYellow),
            ),
          ],
        ),
      ),
    );
  }
}

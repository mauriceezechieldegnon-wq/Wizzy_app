import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wizzy/core/constants/app_colors.dart';
import 'package:wizzy/features/messenger/screens/chat_screen.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});
  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final currentId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: "Rechercher...", hintStyle: TextStyle(color: Colors.white24), border: InputBorder.none),
          onChanged: (v) => setState(() => searchQuery = v.toLowerCase()),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final users = snapshot.data!.docs.where((doc) {
            final name = (doc.data() as Map<String, dynamic>)['username'].toString().toLowerCase();
            return doc.id != currentId && name.contains(searchQuery);
          }).toList();

          return ListView.builder(
            itemCount: users.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final String otherId = users[index].id;
              final String chatId = currentId.hashCode <= otherId.hashCode ? "${currentId}_$otherId" : "${otherId}_$currentId";

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(userData['photoUrl'] ?? "https://ui-avatars.com/api/?name=${userData['username']}")),
                  title: Text(userData['username'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  // --- BADGE DE MESSAGES NON LUS ---
                  trailing: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages')
                        .where('senderId', isEqualTo: otherId)
                        .where('status', isNotEqualTo: MessageStatus.read.toString())
                        .snapshots(),
                    builder: (context, msgSnap) {
                      if (!msgSnap.hasData || msgSnap.data!.docs.isEmpty) return const Icon(Icons.chevron_right, color: Colors.white10);
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                        child: Text("${msgSnap.data!.docs.length}", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(receiverId: otherId, receiverName: userData['username']))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


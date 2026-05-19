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
          decoration: const InputDecoration(hintText: "Chercher...", hintStyle: TextStyle(color: Colors.white24), border: InputBorder.none),
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
            itemCount: users.length, padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
                child: ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(userData['photoUrl'] ?? "https://ui-avatars.com/api/?name=W")),
                  title: Text(userData['username'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(receiverId: users[index].id, receiverName: userData['username']))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

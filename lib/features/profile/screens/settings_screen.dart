import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wizzy/core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final nC = TextEditingController();
  final wC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text("MON PROFIL")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          var data = snapshot.data!.data() as Map<String, dynamic>;
          nC.text = data['username'] ?? "";
          wC.text = data['whatsapp'] ?? "";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(radius: 50, backgroundImage: NetworkImage(data['photoUrl'] ?? "")),
                const SizedBox(height: 30),
                _field("Pseudo", nC),
                _field("WhatsApp", wC),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => FirebaseFirestore.instance.collection('users').doc(user!.uid).update({'username': nC.text, 'whatsapp': wC.text}),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple, minimumSize: const Size(double.infinity, 50)),
                  child: const Text("SAUVEGARDER"),
                ),
                TextButton(onPressed: () => FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!), child: const Text("Changer mot de passe", style: TextStyle(color: AppColors.accentYellow))),
                TextButton(onPressed: () { FirebaseAuth.instance.signOut(); Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false); }, child: const Text("Déconnexion", style: TextStyle(color: Colors.red))),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _field(String l, TextEditingController c) => Padding(padding: const EdgeInsets.only(bottom: 15), child: TextField(controller: c, decoration: InputDecoration(labelText: l, filled: true, fillColor: Colors.white.withValues(alpha: 0.05))));
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wizzy/core/constants/app_colors.dart';

class LuckyDrawScreen extends StatelessWidget {
  const LuckyDrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: const BackButton(color: Colors.white)),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          int pts = userData['points'] ?? 0;
          bool hasPaid = userData['hasPaidEntry'] ?? false;
          return Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                const Text("TIRAGE AU SORT", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                const Spacer(),
                Icon(Icons.confirmation_number, size: 100, color: hasPaid ? Colors.greenAccent : AppColors.accentYellow),
                const SizedBox(height: 20),
                Text(hasPaid ? "TICKET VALIDÉ ✅" : "TENTE TA CHANCE", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                _buildWinnerHistory(),
                const SizedBox(height: 20),
                if (!hasPaid && pts >= 1000)
                  ElevatedButton(
                    onPressed: () => print("Paiement 100F"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple, minimumSize: const Size(double.infinity, 60)),
                    child: const Text("PARTICIPER (100F)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWinnerHistory() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('draw_history').orderBy('timestamp', descending: true).limit(1).snapshots(),
      builder: (context, snap) {
        if (!snap.hasData || snap.data!.docs.isEmpty) return const SizedBox();
        var winner = snap.data!.docs.first;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(20)),
          child: Text("Dernier gagnant : ${winner['winnerName']}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
        );
      },
    );
  }
}

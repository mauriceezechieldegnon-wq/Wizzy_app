import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wizzy/core/constants/app_colors.dart';
import 'package:wizzy/core/services/payment_service.dart';

class LuckyDrawScreen extends StatelessWidget {
  const LuckyDrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          int points = userData['points'] ?? 0;
          bool hasPaid = userData['hasPaidEntry'] ?? false;
          bool isQualified = points >= 1000; 

          return SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centrage vertical
                crossAxisAlignment: CrossAxisAlignment.center, // Centrage horizontal
                children: [
                  const Text("TIRAGE MENSUEL", 
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  const SizedBox(height: 40),
                  
                  _buildStatusIcon(hasPaid, isQualified),
                  
                  const SizedBox(height: 30),

                  Text(
                    hasPaid ? "INSCRIPTION VALIDÉE !" : (isQualified ? "TU ES QUALIFIÉ !" : "PAS ENCORE QUALIFIÉ"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: hasPaid ? Colors.greenAccent : (isQualified ? AppColors.accentYellow : Colors.white24),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 10),
                  Text(
                    hasPaid
                        ? "Ton ticket est enregistré. Tirage le 30 du mois."
                        : (isQualified
                            ? "Paie 100F pour participer au tirage mensuel."
                            : "Gagne encore ${1000 - points} points pour débloquer ton ticket."),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white54),
                  ),

                  const Spacer(),
                  _buildWinnerHistory(),
                  const SizedBox(height: 30),

                  if (isQualified && !hasPaid)
                    GestureDetector(
                      onTap: () => PaymentService().startTransaction(context, 100),
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Colors.orange, Colors.redAccent]),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text("PARTICIPER POUR 100F", 
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusIcon(bool hasPaid, bool isQualified) {
    IconData icon = Icons.lock_outline;
    Color color = Colors.white10;
    if (hasPaid) { icon = Icons.verified_user; color = Colors.greenAccent; }
    else if (isQualified) { icon = Icons.confirmation_number; color = AppColors.accentYellow; }

    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 2),
      ),
      child: Icon(icon, size: 80, color: color),
    );
  }

  Widget _buildWinnerHistory() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('draw_history').orderBy('timestamp', descending: true).limit(1).snapshots(),
      builder: (context, snap) {
        if (!snap.hasData || snap.data!.docs.isEmpty) return const SizedBox();
        var winner = snap.data!.docs.first;
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(15)),
          child: Text("Dernier gagnant : ${winner['winnerName']} 🏆",
            style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
        );
      },
    );
  }
}

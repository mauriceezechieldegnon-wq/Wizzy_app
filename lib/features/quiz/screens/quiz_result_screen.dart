import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:wizzy/core/constants/app_colors.dart';

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  const QuizResultScreen({super.key, required this.score, required this.totalQuestions});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 3));
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(confettiController: _controller, blastDirectionality: BlastDirectionality.explosive),
          ),
          // ON CENTRE TOUT LE CONTENU ICI ✅
          SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centrage vertical
              crossAxisAlignment: CrossAxisAlignment.center, // Centrage horizontal
              children: [
                const Text("SCORE FINAL", style: TextStyle(color: Colors.white38, letterSpacing: 2)),
                const SizedBox(height: 10),
                Text("${widget.score} PTS", 
                  style: const TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.w900)),
                const SizedBox(height: 20),
                _buildBadge(), // Ton badge de rang
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("RETOUR DASHBOARD", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Remplace la fonction _buildBadge dans quiz_result_screen.dart
Widget _buildBadge() {
  String label = "NOVICE";
  Color col = Colors.grey;
  
  // Score maximum possible
  int maxPoints = widget.totalQuestions * 10;
  // Pourcentage de réussite
  double percentage = (widget.score / maxPoints) * 100;

  if (percentage >= 90) {
    label = "LÉGENDE 👑";
    col = Colors.amber;
  } else if (percentage >= 70) {
    label = "EXPERT 🥇";
    col = Colors.blueAccent;
  } else if (percentage >= 50) {
    label = "PRO 🥈";
    col = Colors.purpleAccent;
  } else {
    label = "DÉBUTANT 🥉";
    col = Colors.white38;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
    decoration: BoxDecoration(
      color: col.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: col.withValues(alpha: 0.5), width: 2),
    ),
    child: Text(label, style: TextStyle(color: col, fontWeight: FontWeight.w900, letterSpacing: 2)),
  );
}

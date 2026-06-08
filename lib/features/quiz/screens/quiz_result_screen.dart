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

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accentYellow.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accentYellow.withValues(alpha: 0.5)),
      ),
      child: const Text("🥇 RANG EXPERT", style: TextStyle(color: AppColors.accentYellow, fontWeight: FontWeight.bold)),
    );
  }
}

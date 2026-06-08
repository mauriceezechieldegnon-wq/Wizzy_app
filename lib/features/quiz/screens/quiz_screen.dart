import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wizzy/core/constants/app_colors.dart';
import 'package:wizzy/features/quiz/models/question_model.dart';
import 'package:wizzy/features/quiz/screens/quiz_result_screen.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  final String category;
  const QuizScreen({super.key, required this.category});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  String _selected = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text(widget.category)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('questions')
            .where('category', isEqualTo: widget.category).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final questions = snapshot.data!.docs.map((d) => Question.fromFirestore(d.data() as Map<String, dynamic>, d.id)).toList();
          
          if (questions.isEmpty) return const Center(child: Text("Bientôt...", style: TextStyle(color: Colors.white)));
          if (_currentIndex >= questions.length) return const SizedBox();

          final q = questions[_currentIndex];

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                LinearProgressIndicator(value: (_currentIndex + 1) / questions.length, color: AppColors.accentYellow),
                const SizedBox(height: 40),
                Text(q.label, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 40),
                ...q.options.map((opt) => _optionBtn(opt, q, questions.length)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _optionBtn(String opt, Question q, int total) {
    Color color = Colors.white.withValues(alpha: 0.05);
    if (_isAnswered) {
      if (opt == q.correctAnswer) color = Colors.green.withValues(alpha: 0.4);
      else if (opt == _selected) color = Colors.red.withValues(alpha: 0.4);
    }
    return GestureDetector(
      onTap: () {
        if (_isAnswered) return;
        setState(() { _isAnswered = true; _selected = opt; if (opt == q.correctAnswer) _score += 10; });
        Timer(const Duration(seconds: 1), () {
          if (_currentIndex < total - 1) {
            setState(() { _currentIndex++; _isAnswered = false; });
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => QuizResultScreen(score: _score, totalQuestions: total)));
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)),
        child: Center(child: Text(opt, style: const TextStyle(color: Colors.white))),
      ),
    );
  }
}

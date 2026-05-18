import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wizzy/core/constants/app_colors.dart';
import 'package:wizzy/features/quiz/models/question_model.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  const QuizScreen({super.key, required this.category});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text(widget.category)),
      body: const Center(child: Text("Prêt pour le combat ?", style: TextStyle(color: Colors.white))),
    );
  }
}

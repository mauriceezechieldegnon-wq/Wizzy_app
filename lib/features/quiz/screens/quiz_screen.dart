import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:wizzy/core/constants/app_colors.dart';
import 'package:wizzy/features/quiz/models/question_model.dart';
import 'package:wizzy/features/quiz/screens/quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _totalScore = 0;
  bool _isAnswered = false;
  String _selectedAnswer = "";
  
  // LOGIQUE DU TIMER
  Timer? _questionTimer;
  int _secondsRemaining = 10;

  final AudioPlayer _musicPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _startMusic();
    // Le timer démarre quand les données arrivent (voir le builder)
  }

  void _startTimer(int totalCount) {
    _questionTimer?.cancel();
    _secondsRemaining = 10;
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _handleTimeout(totalCount);
      }
    });
  }

  void _handleTimeout(int totalCount) {
    _questionTimer?.cancel();
    _checkAnswer(null, "TEMPS_ÉCOULÉ", totalCount);
  }

  void _startMusic() async {
    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.play(AssetSource('sounds/quiz_bg.mp3'));
      await _musicPlayer.setVolume(0.3);
    } catch (e) {
      debugPrint("Musique non chargée");
    }
  }

  @override
  void dispose() {
    _questionTimer?.cancel();
    _musicPlayer.stop();
    _musicPlayer.dispose();
    super.dispose();
  }

  void _checkAnswer(Question? q, String selected, int totalCount) {
    if (_isAnswered) return;
    _questionTimer?.cancel();

    setState(() {
      _isAnswered = true;
      _selectedAnswer = selected;
      if (q != null && selected == q.correctAnswer) {
        _totalScore += 10;
      }
    });

    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (_currentIndex < totalCount - 1) {
          setState(() {
            _currentIndex++;
            _isAnswered = false;
            _selectedAnswer = "";
          });
          _startTimer(totalCount);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QuizResultScreen(
                score: _totalScore,
                totalQuestions: totalCount,
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.category, style: const TextStyle(fontSize: 12, color: Colors.white38)),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        actions: [
          // AFFICHAGE DU TIMER DANS L'APPBAR
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                "$_secondsRemaining s",
                style: TextStyle(
                  color: _secondsRemaining <= 3 ? Colors.red : AppColors.accentYellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('questions')
            .where('category', isEqualTo: widget.category)
            .snapshots(), 
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var questions = snapshot.data!.docs.map((doc) {
            return Question.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          if (questions.isEmpty) return const Center(child: Text("Bientôt disponible", style: TextStyle(color: Colors.white)));

          // On démarre le timer une seule fois au début de chaque question
          if (_questionTimer == null || !_questionTimer!.isActive && !_isAnswered) {
             _startTimer(questions.length);
          }

          final currentQ = questions[_currentIndex];

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / questions.length,
                  backgroundColor: Colors.white10,
                  color: AppColors.primaryPurple,
                ),
                const SizedBox(height: 50),
                Text(
                  currentQ.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView(
                    children: currentQ.options.map((option) => _buildOptionCard(option, currentQ, questions.length)).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptionCard(String text, Question q, int totalCount) {
    bool isCorrect = text == q.correctAnswer;
    bool isSelected = text == _selectedAnswer;
    Color borderColor = Colors.white10;

    if (_isAnswered) {
      if (isCorrect) borderColor = Colors.greenAccent;
      else if (isSelected) borderColor = Colors.redAccent;
    }

    return GestureDetector(
      onTap: () => _checkAnswer(q, text, totalCount),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

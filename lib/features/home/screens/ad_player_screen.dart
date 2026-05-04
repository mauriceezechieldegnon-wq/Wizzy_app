import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdPlayerScreen extends StatefulWidget {
  const AdPlayerScreen({super.key});
  @override
  State<AdPlayerScreen> createState() => _AdPlayerScreenState();
}

class _AdPlayerScreenState extends State<AdPlayerScreen> {
  int _secondsLeft = 15;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer.cancel();
        _grantReward();
      }
    });
  }

  void _grantReward() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'points': FieldValue.increment(15),
    });
    if (mounted) Navigator.pop(context, true);
  }

  @override
  void dispose() { _timer.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_fill, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 20),
            const Text("PUBLICITÉ EN COURS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("Récompense dans $_secondsLeft secondes...", style: const TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}

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
  int _timer = 15;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timer > 0) { setState(() => _timer--); } 
      else { t.cancel(); setState(() => _finished = true); _reward(); }
    });
  }

  void _reward() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({'points': FieldValue.increment(15)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            Text(_finished ? "RÉCOMPENSE ACQUISE ! ✅" : "Patiente encore $_timer s", style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

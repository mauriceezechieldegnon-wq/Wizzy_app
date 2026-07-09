import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:wizzy/firebase_options.dart';

// Tes imports
import 'package:wizzy/features/auth/screens/splash_screen.dart';
import 'package:wizzy/features/auth/screens/register_screen.dart';
import 'package:wizzy/features/home/screens/home_screen.dart';
import 'package:wizzy/core/services/notification_service.dart';

void main() async {
  // On s'assure que Flutter est prêt
  WidgetsFlutterBinding.ensureInitialized();

  // Écran de chargement temporaire immédiat
  runApp(MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator()))));

  try {
    // 1. Init Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 2. Init Notifs (Uniquement si mobile)
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        final notificationService = NotificationService();
        await notificationService.init();
      } catch (e) {
        debugPrint("Erreur notifs : $e");
      }
    }

    // 3. Lancement de la vraie App
    runApp(const WizzyApp());

  } catch (e, stack) {
    // --- SI ÇA CRASH, ON AFFICHE L'ERREUR EN ROUGE SUR LE TEL ---
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text("ERREUR AU DÉMARRAGE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Divider(),
              Text("$e", style: TextStyle(color: Colors.white, fontSize: 12)),
              SizedBox(height: 20),
              Text("TRACE : $stack", style: TextStyle(color: Colors.white70, fontSize: 8)),
            ],
          ),
        ),
      ),
    ));
  }
}

class WizzyApp extends StatelessWidget {
  const WizzyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wizzy',
      theme: ThemeData.dark(useMaterial3: true),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const WizzySplashScreen(),
        '/': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) return const HomeScreen();
            return const RegisterScreen();
          },
        ),
      },
    );
  }
}

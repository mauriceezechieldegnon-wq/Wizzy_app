import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:wizzy/firebase_options.dart';

// Imports des écrans
import 'package:wizzy/features/auth/screens/splash_screen.dart';
import 'package:wizzy/features/auth/screens/register_screen.dart';
import 'package:wizzy/features/home/screens/home_screen.dart';
import 'package:wizzy/core/services/notification_service.dart';

void main() async {
  // 1. On empêche le crash silencieux
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.purple),
            SizedBox(height: 20),
            Text("Lancement de WIZZY...", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    ),
  ));

  try {
    // 2. Init Firebase
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // 3. Init Notifs (Uniquement si Android/iOS)
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        final notificationService = NotificationService();
        await notificationService.init();
      } catch (e) {
        debugPrint("Erreur notifs ignorée : $e");
      }
    }

    // 4. Si tout est OK, on lance la vraie App
    runApp(const WizzyApp());

  } catch (e, stack) {
    // --- SI ÇA CRASH, ON AFFICHE L'ERREUR SUR LE TÉLÉPHONE ---
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red.shade900,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.bug_report, color: Colors.white, size: 50),
              Text("ERREUR FATALE AU DÉMARRAGE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Divider(color: Colors.white),
              Text("$e", style: TextStyle(color: Colors.yellow, fontSize: 12)),
              SizedBox(height: 20),
              Text("TRACE :\n$stack", style: TextStyle(color: Colors.white70, fontSize: 8)),
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

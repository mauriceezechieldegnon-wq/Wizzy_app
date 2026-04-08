import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// CORRECTION DES IMPORTS (Vérifie le nom 'wizzy')
import 'package:wizzy/features/auth/screens/splash_screen.dart';
import 'package:wizzy/features/auth/screens/register_screen.dart';
import 'package:wizzy/features/home/screens/home_screen.dart';
import 'package:wizzy/features/core/services/notification_service.dart';

import 'package:flutter/foundation.dart'; // Pour kIsWeb
import 'dart:io'; // Pour Platform.isWindows

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Initialisation Firebase (Utilise la config Web sur Windows)
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 2. Configuration Firestore (Le cache marche sur Windows aussi)
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // 3. INITIALISATION DES NOTIFICATIONS (Uniquement sur Android/iOS)
    // On ignore cette partie sur Windows pour éviter le crash
    if (!kIsWeb && !Platform.isWindows && !Platform.isLinux) {
      try {
        await NotificationService().init();
      } catch (e) {
        debugPrint("Notifications non supportées sur ce support");
      }
    }

    runApp(const WizzyApp());
  } catch (e) {
    // Si ça crash quand même, on pourra voir l'erreur
    debugPrint("ERREUR AU DÉMARRAGE : $e");
  }
}

class WizzyApp extends StatelessWidget {
  const WizzyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wizzy',
      theme: ThemeData.dark(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const WizzySplashScreen(),
        '/': (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                }
                return snapshot.hasData
                    ? const HomeScreen()
                    : const RegisterScreen();
              },
            ),
      },
    );
  }
}

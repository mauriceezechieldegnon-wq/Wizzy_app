import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:wizzy/firebase_options.dart';

import 'package:wizzy/features/auth/screens/splash_screen.dart';
import 'package:wizzy/features/auth/screens/register_screen.dart';
import 'package:wizzy/features/home/screens/home_screen.dart';
import 'package:wizzy/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. Init Firebase
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // 2. Config Mobile (Offline + Notifs)
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      
      try {
        final notificationService = NotificationService();
        await notificationService.init();
      } catch (e) {
        debugPrint("Notifs désactivées : $e");
      }
    }

    runApp(const WizzyApp());
  } catch (e) {
    // SI CRASH AU BOOT : On affiche l'erreur en blanc sur noir
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Text("ERREUR SYSTÈME : $e", style: TextStyle(color: Colors.white))),
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            return snapshot.hasData ? const HomeScreen() : const RegisterScreen();
          },
        ),
      },
    );
  }
}

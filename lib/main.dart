import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'firebase_options.dart';

import 'package:wizzy/features/auth/screens/splash_screen.dart';
import 'package:wizzy/features/auth/screens/register_screen.dart';
import 'package:wizzy/features/home/screens/home_screen.dart';
import 'package:wizzy/features/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialisation Firebase (Indispensable)
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint("Erreur Firebase : $e");
  }

  // 2. ON SAUTE TOUT LE RESTE SI C'EST WINDOWS
  if (!kIsWeb && Platform.isWindows) {
    debugPrint("Mode Windows : Services mobiles désactivés");
    runApp(const WizzyApp());
    return; // On arrête la fonction ici pour Windows
  }

  // 3. LOGIQUE MOBILE UNIQUEMENT (Android / iOS)
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  try {
    final notificationService = NotificationService();
    await notificationService.init();
  } catch (e) {
    debugPrint("Notifs erreur : $e");
  }

  runApp(const WizzyApp());
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

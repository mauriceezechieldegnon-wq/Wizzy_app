import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // Pour kIsWeb
import 'dart:io'; // Pour Platform
import 'firebase_options.dart';

// --- TES IMPORTS DE FONCTIONNALITÉS ---
import 'package:wizzy/features/auth/screens/splash_screen.dart';
import 'package:wizzy/features/auth/screens/register_screen.dart';
import 'package:wizzy/features/home/screens/home_screen.dart';
import 'package:wizzy/features/core/services/notification_service.dart';

void main() async {
  // 1. Capture les erreurs globales pour éviter que l'app se ferme sans rien dire
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint("CRASH DÉTECTÉ : ${details.exception}");
  };

  try {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint("--- INITIALISATION WIZZY ---");

    // 2. Initialisation Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase : OK ✅");

    // 3. Configuration Firestore (Mode Hors-ligne)
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    debugPrint("Mode Offline : OK ✅");

    // 4. Initialisation des NOTIFICATIONS (Uniquement sur MOBILE Android/iOS)
    // On bloque l'appel sur Windows/Web pour éviter l'erreur "Platform not supported"
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        final notificationService = NotificationService();
        await notificationService.init();
        debugPrint("Notifications : OK ✅");
      } catch (e) {
        debugPrint("Erreur notifs (ignorée) : $e");
      }
    } else {
      debugPrint("Support Desktop détecté : Notifications désactivées par sécurité.");
    }

    // 5. Lancement de l'application
    runApp(const WizzyApp());

  } catch (e) {
    // Si l'application échoue à démarrer, on affiche l'erreur à l'écran
    debugPrint("ERREUR FATALE AU BOOT : $e");
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SelectableText(
            "Erreur système : $e", 
            style: const TextStyle(color: Colors.red, fontSize: 12),
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
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        primaryColor: const Color(0xFF6200EE),
        scaffoldBackgroundColor: const Color(0xFF09090B), // Fond noir profond
      ),
      
      // On commence par le Splash Screen animé
      initialRoute: '/splash',
      
      routes: {
        '/splash': (context) => const WizzySplashScreen(),
        '/': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // A. Pendant que Firebase cherche la session (Chargement)
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Color(0xFF09090B),
                body: Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
              );
            }
            
            // B. Si l'utilisateur est bien connecté -> Dashboard
            if (snapshot.hasData && snapshot.data != null) {
              return const HomeScreen();
            }
            
            // C. Sinon, redirection vers l'inscription
            return const RegisterScreen();
          },
        ),
      },
    );
  }
}

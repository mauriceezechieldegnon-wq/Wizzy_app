import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // Pour kIsWeb
import 'dart:io'; // Pour Platform
import 'firebase_options.dart';

// --- TES FEATURES ---
import 'package:wizzy/features/auth/screens/splash_screen.dart';
import 'package:wizzy/features/auth/screens/register_screen.dart';
import 'package:wizzy/features/home/screens/home_screen.dart';
import 'package:wizzy/features/core/services/notification_service.dart';

void main() async {
  // 1. On affiche un message dès le début pour le CMD Windows
  debugPrint("--- DEMARRAGE SYSTEME WIZZY ---");

  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // 2. Initialisation Firebase
    // Sur Windows, cela utilise automatiquement la config 'web' de firebase_options.dart
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase : CONNECTE ✅");

    // 3. Paramètres Firestore (Mode Hors-ligne)
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    debugPrint("Firestore Persistence : ACTIF ✅");

    // 4. Initialisation des NOTIFICATIONS (Uniquement sur MOBILE)
    // On ignore cette partie sur Windows/Web pour éviter le crash (Code 0)
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        final notificationService = NotificationService();
        await notificationService.init();
        debugPrint("Notifications Mobile : INITIALISEES ✅");
      } catch (e) {
        debugPrint("Notifs ignorees ou erreur : $e");
      }
    } else {
      debugPrint("Support Desktop détecté : Notifications désactivées par sécurité.");
    }

    // 5. Lancement de l'interface
    debugPrint("Lancement de l'application... 🚀");
    runApp(const WizzyApp());

  } catch (e, stack) {
    // Si l'app crash au démarrage, ce bloc va écrire l'erreur dans ton CMD
    debugPrint("!!! ERREUR CRITIQUE AU BOOT !!!");
    debugPrint("Erreur : $e");
    debugPrint("Stacktrace : $stack");
    
    // On lance quand même une app d'erreur pour ne pas avoir un écran noir
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text("Erreur système : $e", style: const TextStyle(color: Colors.red)),
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
        scaffoldBackgroundColor: const Color(0xFF09090B),
      ),
      
      // On commence par le Splash Screen (qui redirigera vers '/')
      initialRoute: '/splash',
      
      routes: {
        '/splash': (context) => const WizzySplashScreen(),
        '/': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Pendant que Firebase vérifie si on est déjà connecté
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
              );
            }
            
            // Si l'utilisateur est connecté -> Home
            if (snapshot.hasData && snapshot.data != null) {
              return const HomeScreen();
            }
            
            // Sinon -> Inscription
            return const RegisterScreen();
          },
        ),
      },
    );
  }
}

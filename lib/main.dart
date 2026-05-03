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

  try {
    // 1. Init Firebase
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // 2. Config Firestore (Le mode offline marche aussi sur Windows)
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // 3. Appel au service (le service lui-même gère la sécurité Windows maintenant)
    final notificationService = NotificationService();
    await notificationService.init();

    runApp(const WizzyApp());
  } catch (e) {
    // Si Windows détecte quand même un problème de plateforme
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Text("WIZZY PC : $e", style: const TextStyle(color: Colors.white))),
      ),
    ));
  }
}

// ... garde le reste du fichier WizzyApp ...

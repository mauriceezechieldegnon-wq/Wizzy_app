import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class NotificationService {
  // NE DÉCLARE AUCUNE VARIABLE FirebaseMessaging ICI

  Future<void> init() async {
    // Si on est sur Windows, on quitte immédiatement la fonction
    if (kIsWeb || !Platform.isAndroid && !Platform.isIOS) return;

    try {
      final messaging = FirebaseMessaging.instance;
      final localNotif = FlutterLocalNotificationsPlugin();
      
      await messaging.requestPermission();
      // ... reste de ton code init ...
    } catch (e) {
      debugPrint("Notifs désactivées sur ce support");
    }
  }
}

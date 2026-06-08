import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class NotificationService {
  Future<void> init() async {
    if (kIsWeb || !Platform.isAndroid && !Platform.isIOS) return;
    
    try {
      final FirebaseMessaging fcm = FirebaseMessaging.instance;
      final FlutterLocalNotificationsPlugin localNotif = FlutterLocalNotificationsPlugin();
      
      await fcm.requestPermission(alert: true, badge: true, sound: true);
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidInit, iOS: DarwinInitializationSettings());
      await localNotif.initialize(initSettings);
    } catch (e) {
      debugPrint("Notifs désactivées.");
    }
  }

  Future<void> showVictoryNotification(String title) async {
    if (kIsWeb || !Platform.isAndroid && !Platform.isIOS) return;
    final localNotif = FlutterLocalNotificationsPlugin();
    const androidDetails = AndroidNotificationDetails('wizzy_channel', 'Wizzy Alerts', importance: Importance.max);
    await localNotif.show(0, "🏆 VICTOIRE !", title, const NotificationDetails(android: androidDetails));
  }
}

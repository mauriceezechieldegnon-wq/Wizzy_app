import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

// Vérifie si ton projet s'appelle 'wizzy' ou 'myapp' dans pubspec.yaml
import 'package:wizzy/features/auth/models/user_model.dart'; 

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Initialisation sécurisée pour Windows/Android/iOS
  final GoogleSignIn? _googleSignIn = (kIsWeb || Platform.isAndroid || Platform.isIOS) 
      ? GoogleSignIn() 
      : null;

  // Inscription par Email
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String username,
    required String whatsapp,
  }) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );

    WizzyUser newUser = WizzyUser(
      uid: credential.user!.uid,
      username: username,
      email: email,
      whatsapp: whatsapp,
    );

    await _firestore.collection('users').doc(newUser.uid).set(newUser.toMap());
  }

  // Connexion Google (CORRIGÉE POUR LE NULL SAFETY)
  Future<void> signInWithGoogle() async {
    if (_googleSignIn == null) {
      debugPrint("Google Sign-In n'est pas supporté sur cette plateforme.");
      return;
    }

    try {
      // On utilise ?. car _googleSignIn peut être null
      final GoogleSignInAccount? googleUser = await _googleSignIn?.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (!doc.exists) {
          WizzyUser newUser = WizzyUser(
            uid: user.uid,
            username: user.displayName ?? "Joueur",
            email: user.email!,
            whatsapp: "", 
          );
          await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        }
      }
    } catch (e) {
      debugPrint("Erreur Google Sign-In : $e");
      rethrow;
    }
  }

  // Déconnexion (CORRIGÉE POUR LE NULL SAFETY)
  Future<void> signOut() async {
    try {
      await _googleSignIn?.signOut(); // Utilisation de ?.
      await _auth.signOut();
    } catch (e) {
      debugPrint("Erreur déconnexion : $e");
    }
  }
}

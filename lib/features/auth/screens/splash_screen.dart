import 'package:flutter/material.dart';
import 'dart:async';
import 'package:wizzy/core/constants/app_colors.dart';

class WizzySplashScreen extends StatefulWidget {
  const WizzySplashScreen({super.key});

  @override
  State<WizzySplashScreen> createState() => _WizzySplashScreenState();
}

class _WizzySplashScreenState extends State<WizzySplashScreen> {
  @override
  void initState() {
    super.initState();
    // Redirection automatique vers l'accueil ou l'auth après 4 secondes
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      body: Stack(
        children: [
          // 1. LE LOGO ET LE NOM AU CENTRE
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1), 
                      width: 2
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPurple.withValues(alpha: 0.2),
                        blurRadius: 40,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => 
                          const Icon(Icons.bolt, size: 80, color: AppColors.accentYellow),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "WIZZY",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 12, // Look futuriste
                  ),
                ),
              ],
            ),
          ),

          // 2. LA SIGNATURE ET LE COPYRIGHT EN BAS
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  "BY MAURICE EZÉCHIËL",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Copyright 2026 DEM Productions",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 9,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

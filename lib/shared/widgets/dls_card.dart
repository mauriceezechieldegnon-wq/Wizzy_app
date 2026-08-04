import 'package:flutter/material.dart';
import 'package:wizzy/core/constants/app_colors.dart';

class DLSCard extends StatelessWidget {
  final String title;
  final String rating;
  final Widget child;
  final bool isGoldVIP;
  final VoidCallback? onTap;

  const DLSCard({
    super.key,
    required this.title,
    required this.rating,
    required this.child,
    this.isGoldVIP = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryGlow = isGoldVIP ? AppColors.goldVIP : AppColors.neonYellow;
    final borderColor = isGoldVIP ? AppColors.goldVIP : AppColors.electricPurple;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: borderColor, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: primaryGlow.withValues(alpha: 0.25),
              blurRadius: 12.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.0),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: borderColor.withValues(alpha: 0.15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: primaryGlow, width: 1.5),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            rating,
                            style: TextStyle(
                              color: primaryGlow,
                              fontSize: 22,
                              fontWeight: FontWeight.black,
                            ),
                          ),
                          Text(
                            isGoldVIP ? "VIP" : "PRO",
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.textLight,
                              fontSize: 18,
                              fontWeight: FontWeight.black,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          child,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DlsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final dynamic icon; 
  final Color color;
  final String rating;
  final VoidCallback onTap;

  const DlsCard({super.key, required this.title, required this.subtitle, required this.icon, required this.color, required this.rating, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.1)]),
        ),
        child: Container(
          decoration: BoxDecoration(color: const Color(0xFF121212), borderRadius: BorderRadius.circular(14)),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(rating, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w900)),
                        icon is IconData ? Icon(icon as IconData, color: color, size: 16) : FaIcon(icon as FaIconData, color: color, size: 16),
                      ],
                    ),
                    const Spacer(),
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900)),
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

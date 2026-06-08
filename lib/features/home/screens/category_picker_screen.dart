import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wizzy/core/constants/app_colors.dart'; // <--- IMPORT FIXE
import 'package:wizzy/features/quiz/screens/quiz_screen.dart';

class CategoryPickerScreen extends StatelessWidget {
  const CategoryPickerScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {"name": "SPORT", "icon": FontAwesomeIcons.futbol, "color": Colors.greenAccent},
    {"name": "TECH", "icon": FontAwesomeIcons.microchip, "color": Colors.blueAccent},
    {"name": "CULTURE G", "icon": FontAwesomeIcons.globe, "color": Colors.orangeAccent},
    {"name": "HISTOIRE", "icon": FontAwesomeIcons.landmark, "color": Colors.redAccent},
    {"name": "SCIENCE", "icon": FontAwesomeIcons.flask, "color": Colors.purpleAccent},
    {"name": "GAMING", "icon": FontAwesomeIcons.gamepad, "color": Colors.pinkAccent},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("THÈMES", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
        leading: const BackButton(color: Colors.white),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 1.1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final Color col = cat['color'] as Color;
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen(category: cat['name']))),
            child: Container(
              decoration: BoxDecoration(
                color: col.withValues(alpha: 0.1), // SANS CONST
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: col.withValues(alpha: 0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(cat['icon'] as FaIconData, color: col, size: 30),
                  const SizedBox(height: 12),
                  Text(cat['name'], style: TextStyle(color: col, fontWeight: FontWeight.w900, fontSize: 14)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wizzy/core/constants/app_colors.dart';
import 'package:wizzy/features/admin/screens/add_product_screen.dart';
import 'package:wizzy/features/admin/screens/add_question_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text("WIZZY ADMIN", style: TextStyle(color: Colors.white))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _tile(context, "PRODUIT", FontAwesomeIcons.plus, Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen()))),
          const SizedBox(height: 15),
          _tile(context, "QUESTION", FontAwesomeIcons.question, Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddQuestionScreen()))),
          const SizedBox(height: 15),
          _tile(context, "EXPORT CSV", FontAwesomeIcons.fileCsv, Colors.green, () async {
             var snap = await FirebaseFirestore.instance.collection('users').get();
             String csv = "User,WhatsApp\n";
             for (var d in snap.docs) { csv += "${d['username']},${d['whatsapp']}\n"; }
             await Share.share(csv);
          }),
        ],
      ),
    );
  }

  // LOGIQUE SÉCURISÉE POUR LES ICÔNES DYNAMIC
  Widget _tile(BuildContext context, String t, dynamic i, Color c, VoidCallback o) {
    return ListTile(
      onTap: o,
      leading: i is IconData ? Icon(i, color: c) : FaIcon(i, color: c),
      title: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      tileColor: Colors.white.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white10, size: 14),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wizzy/core/constants/app_colors.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nC = TextEditingController();
  final pC = TextEditingController();
  final uC = TextEditingController();
  final wC = TextEditingController();

  void _save() async {
    await FirebaseFirestore.instance.collection('products').add({
      'name': nC.text,
      'price': int.parse(pC.text),
      'imageUrl': uC.text,
      'sellerWhatsApp': wC.text,
    });
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text("AJOUTER PRODUIT")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: nC, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "Nom", hintStyle: TextStyle(color: Colors.white24))),
            TextField(controller: pC, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "Prix"), keyboardType: TextInputType.number),
            TextField(controller: uC, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "Lien Image")),
            TextField(controller: wC, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "WhatsApp")),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _save, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple), child: const Text("PUBLIER", style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}

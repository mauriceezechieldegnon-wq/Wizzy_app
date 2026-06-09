import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:wizzy/core/constants/app_colors.dart';
import 'dart:io';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});
  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // Clé API intégrée
  final String apiKey = "AQ.Ab8RN6KInQ5dQmP9CYx-LEN5rG4_Hl3I72ddUEIlkdlQ4G4Ppg";

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty || _isLoading) return;
    
    String userText = _controller.text;
    setState(() {
      _messages.add({"role": "user", "text": userText});
      _isLoading = true;
    });
    _controller.clear();

    try {
      // INITIALISATION LOCALE (Plus stable pour Windows)
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );

      final content = [Content.text(userText)];
      final response = await model.generateContent(content);
      
      if (!mounted) return;

      setState(() {
        _messages.add({
          "role": "ai", 
          "text": response.text ?? "Le Génie n'a pas trouvé de mots."
        });
      });
    } catch (e) {
      if (!mounted) return;
      // ON AFFICHE L'ERREUR RÉELLE ICI POUR COMPRENDRE
      setState(() {
        _messages.add({
          "role": "ai", 
          "text": "ERREUR WINDOWS : ${e.toString()}" 
        });
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text("IA WIZZY", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18))
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                bool isMe = msg['role'] == "user";
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.primaryPurple : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(msg['text']!, style: const TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(color: AppColors.accentYellow, backgroundColor: Colors.transparent),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller, 
              onSubmitted: (_) => _sendMessage(),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Pose ta question...", 
                hintStyle: TextStyle(color: Colors.white24),
                border: InputBorder.none
              )
            )
          ),
          IconButton(onPressed: _sendMessage, icon: const Icon(Icons.send, color: AppColors.accentYellow)),
        ],
      ),
    );
  }
}

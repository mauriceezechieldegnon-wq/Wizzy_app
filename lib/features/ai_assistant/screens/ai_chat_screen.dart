import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:wizzy/core/constants/app_colors.dart';
import 'package:flutter/foundation.dart';
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

  // Ta clé API officielle
  final String _apiKey = "AQ.Ab8RN6KInQ5dQmP9CYx-LEN5rG4_Hl3I72ddUEIlkdlQ4G4Ppg";

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty || _isLoading) return;

    String userText = _controller.text;
    setState(() {
      _messages.add({"role": "user", "text": userText});
      _isLoading = true;
    });
    _controller.clear();

    try {
      // INITIALISATION : On utilise 'gemini-1.5-flash' sans le préfixe 'models/'
      // Cela force l'utilisation de l'endpoint stable V1 sur Windows
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _apiKey,
      );

      final content = [Content.text(userText)];
      final response = await model.generateContent(content);
      
      if (!mounted) return;

      setState(() {
        _messages.add({
          "role": "ai", 
          "text": response.text ?? "Le Génie n'a pas pu formuler de réponse."
        });
      });
    } catch (e) {
      if (!mounted) return;
      
      // On capture l'erreur exacte pour la voir dans la bulle sur Windows
      String errorDetails = e.toString();
      debugPrint("DEBUG IA : $errorDetails");

      setState(() {
        _messages.add({
          "role": "ai", 
          "text": "Le Génie dort (Erreur de connexion).\n\nDetails : $errorDetails"
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
        title: const Text(
          "GÉNIE WIZZY", 
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18)
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty 
              ? _buildWelcomeState() 
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    bool isMe = msg['role'] == "user";
                    return _buildChatBubble(msg['text']!, isMe);
                  },
                ),
          ),
          if (_isLoading) 
            const LinearProgressIndicator(color: AppColors.accentYellow, backgroundColor: Colors.transparent),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildWelcomeState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome, size: 60, color: AppColors.primaryPurple.withValues(alpha: 0.3)),
          const SizedBox(height: 20),
          const Text(
            "Je sais tout sur WIZZY et le reste.\nPose-moi une question !",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 13, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryPurple : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: isMe ? null : Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Text(
          text, 
          style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4)
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller, 
              onSubmitted: (_) => _sendMessage(),
              style: const TextStyle(color: Colors.white), 
              decoration: const InputDecoration(
                hintText: "Pose ta question à WIZZY...", 
                hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                border: InputBorder.none
              )
            )
          ),
          IconButton(
            onPressed: _sendMessage, 
            icon: const Icon(Icons.send_rounded, color: AppColors.accentYellow)
          ),
        ],
      ),
    );
  }
}

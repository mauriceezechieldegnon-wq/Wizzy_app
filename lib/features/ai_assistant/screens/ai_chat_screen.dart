import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wizzy/core/constants/app_colors.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});
  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final String _key = "AQ.Ab8RN6LMTpfFjsGdivbHCm6Zf92qa_grInOUzYWApRuuF7JYtQ";

  Future<void> _send() async {
    if (_controller.text.isEmpty || _isLoading) return;
    String txt = _controller.text;
    setState(() { _messages.add({"role": "user", "text": txt}); _isLoading = true; });
    _controller.clear();
    try {
      // URL STABLE V1BETA POUR LES CLÉS RÉCENTES
      final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_key");
      final res = await http.post(url, headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"contents": [{"parts": [{"text": txt}]}]}));
      
      final data = jsonDecode(utf8.decode(res.bodyBytes));
      String responseText = data['candidates'][0]['content']['parts'][0]['text'];
      setState(() { _messages.add({"role": "ai", "text": responseText}); });
    } catch (e) {
      setState(() { _messages.add({"role": "ai", "text": "Le Génie a un souci technique."}); });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, title: const Text("GÉNIE WIZZY", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      body: Column(
        children: [
          Expanded(child: ListView.builder(itemCount: _messages.length, itemBuilder: (c, i) {
            final m = _messages[i];
            bool isUser = m['role'] == "user";
            return Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(10), padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: isUser ? const Color(0xFF6200EE) : Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(15)),
                child: Text(m['text']!, style: const TextStyle(color: Colors.white)),
              ),
            );
          })),
          if (_isLoading) const LinearProgressIndicator(color: AppColors.accentYellow),
          Container(padding: const EdgeInsets.all(20), color: Colors.black, child: Row(children: [Expanded(child: TextField(controller: _controller, onSubmitted: (_) => _send(), style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "Demande-moi...", border: InputBorder.none, hintStyle: TextStyle(color: Colors.white24)))), IconButton(onPressed: _send, icon: const Icon(Icons.send, color: AppColors.accentYellow))])),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wizzy/core/constants/app_colors.dart';
import 'package:wizzy/features/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isLogin = false; // Basculer entre Inscription et Connexion

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        if (_isLogin) {
          // CONNEXION
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
        } else {
          // INSCRIPTION
          await _authService.signUpWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            username: _usernameController.text.trim(),
            whatsapp: _whatsappController.text.trim(),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 80),
              Text(_isLogin ? "BON RETOUR !" : "REJOINDRE WIZZY", 
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2)),
              const SizedBox(height: 40),
              
              if (!_isLogin) _buildField(_usernameController, "Pseudo", Icons.person_outline),
              if (!_isLogin) _buildField(_whatsappController, "WhatsApp (+229...)", Icons.phone),
              
              _buildField(_emailController, "Email", Icons.alternate_email),
              _buildField(_passwordController, "Mot de passe", Icons.lock_outline, isPass: true),

              const SizedBox(height: 30),
              
              GestureDetector(
                onTap: _isLoading ? null : _handleSubmit,
                child: Container(
                  width: double.infinity, height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.primaryPurple, const Color(0xFF9D50BB)]),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : Text(_isLogin ? "SE CONNECTER" : "CRÉER MON COMPTE", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ),
              ),

              const SizedBox(height: 20),
              
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin ? "Pas de compte ? Inscris-toi" : "Déjà un compte ? Connecte-toi", 
                  style: const TextStyle(color: AppColors.accentYellow)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, IconData icon, {bool isPass = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isPass,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.accentYellow, size: 18),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.03),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}

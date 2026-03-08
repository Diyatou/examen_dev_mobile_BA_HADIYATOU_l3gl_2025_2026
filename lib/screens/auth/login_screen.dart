import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      bool success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success) {
        // Le Consumer dans main.dart gérera la redirection vers Home
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Connexion réussie !")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.error ?? "Erreur de connexion")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Connexion", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                CustomTextField(
                  label: "Email",
                  controller: _emailController,
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@') || !v.contains('.')) ? "Email invalide" : null,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "Mot de passe",
                  controller: _passwordController,
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  validator: (v) => (v == null || v.length < 6) ? "Minimum 6 caractères" : null,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: "Se connecter",
                  isLoading: authProvider.isLoading,
                  onPressed: _handleLogin,
                ),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                  child: const Text("Pas de compte ? S'inscrire"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
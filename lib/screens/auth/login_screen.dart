import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),

            authProvider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                final success = await authProvider.signIn(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );

                if (success && mounted) {
                  context.go('/');
                } else if (mounted && authProvider.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(authProvider.errorMessage!)),
                  );
                }
              },
              child: const Text("Login"),
            ),

            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final success = await authProvider.signIn(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );

                if (success && mounted) {
                  context.go('/');
                } else if (mounted && authProvider.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(authProvider.errorMessage!)),
                  );
                }
              },
              icon: const Icon(Icons.login),
              label: const Text("Login dengan Google"),
            ),

            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/register'),
              child: const Text("Belum punya akun? Daftar"),
            ),
          ],
        )
      ),
    );
  }
}

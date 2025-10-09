import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
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
            ElevatedButton.icon(
              onPressed: () async {
                // final success = await authProvider.signInWithGoogle();
                // if (success && mounted) {
                //   context.go('/');
                // } else if (mounted && authProvider.errorMessage != null) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text(authProvider.errorMessage!)),
                //   );
                // }
              },
              icon: const Icon(Icons.login),
              label: const Text("Daftar dengan Google"),
            ),
            authProvider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                final success = await authProvider.signUp(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );

                if (success && mounted) {
                  context.go('/'); // arahkan ke MainNavigation
                } else {
                  if (mounted && authProvider.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(authProvider.errorMessage!)),
                    );
                  }
                }
              },
              child: const Text("Daftar"),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text("Sudah punya akun? Login"),
            ),
          ],
        ),
      ),
    );
  }
}

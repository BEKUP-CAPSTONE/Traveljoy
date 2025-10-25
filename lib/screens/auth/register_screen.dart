import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveljoy/providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _retypePasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isRetypePasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: kWhite,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // App Logo
                _buildMainIcon(),
                const SizedBox(height: 20),

                // Teks (Let's Get Started)
                _buildWelcomeText(),
                const SizedBox(height: 40),

                // Input Email
                _buildInputField(
                  label: 'Email',
                  hint: 'Masukkan Email Anda',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                const SizedBox(height: 20),

                // Input Password
                _buildPasswordField(
                  label: 'Sandi',
                  controller: _passwordController,
                  isPasswordVisible: _isPasswordVisible,
                  onToggleVisibility: (isVisible) {
                    setState(() {
                      _isPasswordVisible = isVisible;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Re-type Password
                _buildPasswordField(
                  label: 'Ulangi Sandi anda',
                  controller: _retypePasswordController,
                  isPasswordVisible: _isRetypePasswordVisible,
                  onToggleVisibility: (isVisible) {
                    setState(() {
                      _isRetypePasswordVisible = isVisible;
                    });
                  },
                ),
                const SizedBox(height: 40),

                _buildRegisterButton(context, authProvider),

                // Error message
                if (authProvider.errorMessage != null &&
                    !authProvider.isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      authProvider.errorMessage!,
                      style: TextStyle(
                        color: kAccentRed,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 10),

                _buildOrContinueWithText(),
                const SizedBox(height: 10),

                _buildGoogleSignInButton(context),

                const SizedBox(height: 20),

                _buildSignUpText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainIcon() {
    return Center(
      child: Image.asset(
        'assets/images/logo_full.png',
        width: 100,
        height: 100,
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'Daftar yuk',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: kBlack,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Temukan berbagai perjalanan wisata menarik hanya dalam genggamanmu!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: kHintColor),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextInputType keyboardType,
    required TextEditingController controller,
  }) {
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: kHintColor.withOpacity(0.5), width: 1.0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: kBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: kBlack),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: kHintColor),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: borderStyle,
            enabledBorder: borderStyle,
            focusedBorder: borderStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isPasswordVisible,
    required Function(bool) onToggleVisibility,
  }) {
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: kHintColor.withOpacity(0.5), width: 1.0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: kBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: !isPasswordVisible,
          style: TextStyle(color: kBlack),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: TextStyle(color: kHintColor),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),

            border: borderStyle,
            enabledBorder: borderStyle,
            focusedBorder: borderStyle,
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: kHintColor,
              ),
              onPressed: () {
                onToggleVisibility(!isPasswordVisible);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context, AuthProvider authProvider) {
    return ElevatedButton(
      onPressed: authProvider.isLoading
          ? null
          : () async {
              if (_passwordController.text != _retypePasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password tidak cocok.')),
                );
                return;
              }

              if (_emailController.text.isEmpty ||
                  _passwordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Email dan Password wajib diisi.'),
                  ),
                );
                return;
              }

              await authProvider.signUp(
                email: _emailController.text.trim(),
                password: _passwordController.text,
              );
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: kTeal,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: authProvider.isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: kWhite, strokeWidth: 3),
            )
          : const Text(
              'Daftar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kWhite,
              ),
            ),
    );
  }

  Widget _buildOrContinueWithText() {
    return const Center(
      child: Text('Atau', style: TextStyle(color: kHintColor, fontSize: 16)),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        final auth = context.read<AuthProvider>();
        final success = await auth.signInWithGoogle();

        if (success) {
          context.go('/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(auth.errorMessage ?? 'Login Google gagal')),
          );
        }
      },
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 55),
        side: BorderSide(color: kNeutralGrey.withOpacity(0.5), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: kWhite,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/icons-google.png', height: 24),
          const SizedBox(width: 12),
          Text(
            'Lanjutkan dengan Google',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpText(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "Sudah memiliki akun? ",
          style: TextStyle(color: kBlack, fontSize: 16),
          children: <TextSpan>[
            TextSpan(
              text: 'Masuk',
              style: TextStyle(
                color: kTeal,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  context.go('/login');
                },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveljoy/providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isChecked = false;
  bool _isPasswordVisible = false;

  final OutlineInputBorder _inputBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: kHintColor.withOpacity(0.5), width: 1.0),
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

                _buildWelcomeText(),
                const SizedBox(height: 40),

                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 20),
                _buildTermsAndConditions(),
                const SizedBox(height: 30),
                _buildLoginButton(context, authProvider),

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
        const Text(
          'Haloo',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: kBlack,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Masuk lagi ke akun anda, dan ayo buat perjalanan yang seru',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: kHintColor),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: kBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: kBlack),
          decoration: InputDecoration(
            hintText: 'Masukkan email anda',
            hintStyle: TextStyle(color: kHintColor),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: _inputBorderStyle,
            enabledBorder: _inputBorderStyle,
            focusedBorder: _inputBorderStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sandi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: kBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          style: const TextStyle(color: kBlack),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: TextStyle(color: kHintColor),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: _inputBorderStyle,
            enabledBorder: _inputBorderStyle,
            focusedBorder: _inputBorderStyle,

            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: kHintColor,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    const TextStyle defaultStyle = TextStyle(fontSize: 14, color: kBlack);
    final TextStyle linkStyle = TextStyle(
      color: kTeal,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 24.0,
          height: 24.0,
          child: Checkbox(
            value: _isChecked,
            activeColor: kTeal,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value!;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8.0),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: "Saya telah membaca dan menyetujui ",
                style: defaultStyle,
                children: <InlineSpan>[
                  TextSpan(
                    text: 'Perjanjian Pengguna & Kebijakan Privasi',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        debugPrint("Navigasi ke halaman Terms");
                        context.push('/terms');
                      },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthProvider authProvider) {
    return ElevatedButton(
      onPressed: authProvider.isLoading
          ? null
          : () async {
              if (_emailController.text.isEmpty ||
                  _passwordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Email dan Password wajib diisi.'),
                  ),
                );
                return;
              }

              await authProvider.signIn(
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
              'Masuk',
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
          context.go('/'); // langsung ke home
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
          text: "Anda tidak memiliki akun? ",
          style: TextStyle(color: kBlack, fontSize: 16),
          children: <TextSpan>[
            TextSpan(
              text: 'Daftar',
              style: TextStyle(
                color: kTeal,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  context.go('/register');
                },
            ),
          ],
        ),
      ),
    );
  }
}

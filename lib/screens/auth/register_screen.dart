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
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double verticalPadding = screenHeight * 0.04;

    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: kWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.0, verticalPadding, 24.0, 24.0),
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
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              const SizedBox(height: 20),

              // Input Password
              _buildPasswordField(
                label: 'Password',
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
                label: 'Re-type Password',
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
              if (authProvider.errorMessage != null && !authProvider.isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    authProvider.errorMessage!,
                    style: TextStyle(color: kAccentRed, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 30),

              // Teks "Or continue with"
              _buildOrContinueWithText(),
              const SizedBox(height: 20),

              // Tombol Google Sign Up
              _buildGoogleSignInButton(context),

              const SizedBox(height: 40),

              // Tautan Sign In
              _buildSignUpText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainIcon() {
    return Center(
      child: Image.asset(
        'assets/images/logo.png',
        width: 100,
        height: 100,
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'Let\'s Get Started',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: kBlack,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'create your new account and find\nmore beautiful destinations',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: kHintColor,
          ),
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
      borderSide: BorderSide(
        color: kHintColor.withOpacity(0.5),
        width: 1.0,
      ),
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
      borderSide: BorderSide(
        color: kHintColor.withOpacity(0.5),
        width: 1.0,
      ),
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
      onPressed: authProvider.isLoading ? null : () async {
        if (_passwordController.text != _retypePasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password tidak cocok.')),
          );
          return;
        }

        if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email dan Password wajib diisi.')),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      child: authProvider.isLoading
          ? const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(color: kWhite, strokeWidth: 3),
      )
          : const Text(
        'Sing Up',
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
      child: Text(
        'Or continue with',
        style: TextStyle(
          color: kHintColor,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        // Logic Sign in with Google
      },
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 55),
        side: BorderSide(color: kNeutralGrey.withOpacity(0.5), width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: kWhite,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/icons-google.png', height: 24),
          const SizedBox(width: 12),
          Text(
            'Sing up with Google',
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
          text: "Already have an account? ",
          style: TextStyle(
            color: kBlack,
            fontSize: 16,
          ),
          children: <InlineSpan>[
            WidgetSpan(
              child: InkWell(
                onTap: () {
                  context.go('/login');
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: kTeal,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
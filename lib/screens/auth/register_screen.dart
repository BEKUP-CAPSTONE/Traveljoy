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

              // Form Input: Email
              _buildInputField(
                label: 'Email',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              const SizedBox(height: 20),

              // Form Input: Password
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

              // Form Input: Re-type Password
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

              // Tombol Register
              _buildRegisterButton(context, authProvider),

              // Tampilkan error message dari AuthProvider
              if (authProvider.errorMessage != null && !authProvider.isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    authProvider.errorMessage!,
                    style: TextStyle(color: kAccentRed, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),

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
          'Create your new account and find\nmore beautiful destinations',
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
            fillColor: kWhite,
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
            fillColor: kWhite,
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

        // Panggil method signUp yang sebenarnya dari AuthProvider
        await authProvider.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        // Redirect otomatis akan terjadi (ke /)
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryDark,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
        shadowColor: kPrimaryDark.withOpacity(0.4),
      ),
      child: authProvider.isLoading
          ? const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(color: kWhite, strokeWidth: 3),
      )
          : const Text(
        'Register',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: kWhite,
        ),
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
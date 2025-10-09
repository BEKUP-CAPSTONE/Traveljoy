import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isRetypePasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double verticalPadding = screenHeight * 0.04;

    return Scaffold(
      // warna latar belakang eksplisit
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

              // Form Input: Nama
              _buildInputField(
                label: 'Name',
                hint: 'Enter your full name',
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 20),

              // Form Input: Email
              _buildInputField(
                label: 'Email',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Form Input: Password
              _buildPasswordField(
                label: 'Password',
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
                isPasswordVisible: _isRetypePasswordVisible,
                onToggleVisibility: (isVisible) {
                  setState(() {
                    _isRetypePasswordVisible = isVisible;
                  });
                },
              ),
              const SizedBox(height: 40),

              // Tombol Register
              _buildRegisterButton(context),
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

  Widget _buildRegisterButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.go('/login');
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
      child: const Text(
        'Sing Up',
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
                  // Navigasi ke rute Register
                  context.go('/register');
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
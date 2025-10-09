import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isChecked = false;
  bool _isPasswordVisible = false;

  final OutlineInputBorder _inputBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(
      color: kHintColor.withOpacity(0.5),
      width: 1.0,
    ),
  );

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

              // Teks Selamat Datang
              _buildWelcomeText(),
              const SizedBox(height: 40),

              // Form Input (Email dan Password)
              _buildEmailField(),
              const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 10),

              // Checkbox dan Tautan Forgot Password
              _buildKeepSignedInAndForgotPwd(),
              const SizedBox(height: 30),

              // Tombol Login
              _buildLoginButton(context),
              const SizedBox(height: 30),

              // Teks "Or continue with"
              _buildOrContinueWithText(),
              const SizedBox(height: 20),

              // Ikon Media Sosial
              _buildSocialMediaIcons(),
              const SizedBox(height: 40),

              // Tautan Sign Up
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
        const Text(
          'Welcome Back !',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: kBlack,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Stay signed in with your account to\nmake searching easier',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: kHintColor,
          ),
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
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: kBlack),
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: TextStyle(color: kHintColor),
            filled: true,
            fillColor: kWhite,
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
          'Password',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: kBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: !_isPasswordVisible,
          style: const TextStyle(color: kBlack),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: TextStyle(color: kHintColor),
            filled: true,
            fillColor: kWhite,
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

  Widget _buildKeepSignedInAndForgotPwd() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 24.0,
              height: 24.0,
              child: Checkbox(
                value: _isChecked,
                activeColor: kPrimaryColor,
                onChanged: (bool? value) {
                  setState(() {
                    _isChecked = value!;
                  });
                },
              ),
            ),
            const SizedBox(width: 8.0),
            const Text(
              'Keep me signed in',
              style: TextStyle(
                fontSize: 14,
                color: kBlack,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            // Lupa Password
          },
          child: const Text(
            'Forgot password?',
            style: TextStyle(
              fontSize: 14,
              color: kTeal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.go('/');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryDark,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
        shadowColor: kPrimaryColor.withOpacity(0.4),
      ),
      child: const Text(
        'Login',
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

  Widget _buildSocialMediaIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildSocialIcon('assets/images/icons-facebook.png'),
        const SizedBox(width: 35),
        _buildSocialIcon('assets/images/icons-google.png'),
        const SizedBox(width: 35),
        _buildSocialIcon('assets/images/icons-twitter.png'),
      ],
    );
  }

  Widget _buildSocialIcon(String assetPath) {
    return Image.asset(
      assetPath,
      width: 30,
      height: 30,
    );
  }

  Widget _buildSignUpText(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "You don't Have an account? ",
          style: TextStyle(
            color: kBlack,
            fontSize: 16,
          ),
          children: <InlineSpan>[
            WidgetSpan(
              child: InkWell(
                onTap: () {
                  context.go('/register');
                },
                child: Text(
                  'Sign Up',
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
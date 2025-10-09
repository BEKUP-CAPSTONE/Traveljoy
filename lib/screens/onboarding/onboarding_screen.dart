import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:traveljoy/providers/onboarding_provider.dart';
import '../../core/constants/app_colors.dart';

class OnboardingContent {
  final String imagePath;
  final String title;
  final String description;

  OnboardingContent({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<OnboardingContent> _onboardingData = [
    OnboardingContent(
      imagePath: 'assets/images/onboarding1.jpeg',
      title: 'Unforgettable Journey',
      description: 'Access thousands of interesting places and make your plans that easy',
    ),
    OnboardingContent(
      imagePath: 'assets/images/onboarding2.jpeg',
      title: 'New Place, New Story',
      description: 'From mountain tops to city corners, we have the best recommendations for you',
    ),
    OnboardingContent(
      imagePath: 'assets/images/onboarding3.jpeg',
      title: 'Start Your Adventure Now',
      description: 'Break boundaries and create beautiful memories on every journey',
    ),
  ];

  void _nextPage() {
    if (_currentIndex < _onboardingData.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() async {
    await context.read<OnboardingProvider>().completeOnboarding();
    context.go('/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _onboardingData.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return _buildPage(context, _onboardingData[index]);
            },
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: TextButton(
              onPressed: _finishOnboarding,
              child: Text(
                "Skip",
                style: TextStyle(
                  color: kWhite.withOpacity(0.9),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context, OnboardingContent content) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(content.imagePath, fit: BoxFit.cover),

        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kWhite.withOpacity(0.0),
                  kWhite.withOpacity(0.8),
                  kWhite,
                  kWhite,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.55, 0.75, 0.9, 1.0],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Judul
                Text(
                  content.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryDark,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),

                // Deskripsi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    content.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: kHintColor,
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                // Indikator Titik
                _buildDotsIndicator(),
                const SizedBox(height: 24),

                // Tombol Get Started / Login
                _buildActionButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_onboardingData.length, (index) {
        bool isCurrent = _currentIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isCurrent ? 30 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isCurrent ? kTeal : kTeal.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: _nextPage,
      style: ElevatedButton.styleFrom(
        backgroundColor: kTeal,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: const Text(
        "Get Started",
        style: TextStyle(
          color: kWhite,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
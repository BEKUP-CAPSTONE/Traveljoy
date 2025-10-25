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
      title: 'Perjalanan Tak Terlupakan',
      description:
          'Jelajahi ribuan tempat menarik dan rencanakan liburanmu dengan mudah.',
    ),
    OnboardingContent(
      imagePath: 'assets/images/onboarding2.jpeg',
      title: 'Tempat Baru, Cerita Baru',
      description:
          'Dari puncak gunung sampai sudut kota, kami punya rekomendasi terbaik untukmu.',
    ),
    OnboardingContent(
      imagePath: 'assets/images/onboarding3.jpeg',
      title: 'Mulai Petualanganmu Sekarang',
      description:
          'Buka pengalaman baru dan ciptakan kenangan indah di setiap perjalanan.',
    ),
  ];

  void _nextPage() {
    if (_currentIndex < _onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
            top: 10,
            right: 20,
            child: SafeArea(
              bottom: false,
              left: false,
              right: false,
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
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _onboardingData[_currentIndex].title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        _onboardingData[_currentIndex].description,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: kHintColor),
                      ),
                    ),

                    const SizedBox(height: 32),
                    _buildDotsIndicator(),
                    const SizedBox(height: 24),
                    _buildActionButton(),
                    const SizedBox(height: 20),
                  ],
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        _currentIndex == _onboardingData.length - 1 ? "Mulai" : "Lanjutkan",
        style: TextStyle(
          color: kWhite,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

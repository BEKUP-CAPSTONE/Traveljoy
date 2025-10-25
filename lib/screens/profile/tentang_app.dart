import 'package:flutter/material.dart';
import 'package:traveljoy/core/constants/app_colors.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kTeal,
        foregroundColor: Colors.white,
        title: const Text('Tentang Aplikasi'),
        centerTitle: true,
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Center(
              child: Image.asset(
                'assets/images/logo_full.png',
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'TravelJoy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'TravelJoy adalah aplikasi yang membantu kamu menemukan wisata '
              'dan membuat jadwal perjalanan menarik dengan mudah. '
              'Nikmati pengalaman perjalanan yang menyenangkan dan praktis '
              'langsung dari genggamanmu.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const Spacer(),
            const Text('Versi 1.0.0', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

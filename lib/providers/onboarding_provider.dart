import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider extends ChangeNotifier {
  bool _hasSeenOnboarding = false;
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  OnboardingProvider() {
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    _hasSeenOnboarding = true;
    notifyListeners();
  }
}

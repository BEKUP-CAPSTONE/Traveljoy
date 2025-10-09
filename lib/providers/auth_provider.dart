import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final supabase = Supabase.instance.client;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isLoggedIn => supabase.auth.currentUser != null;
  String get userEmail => supabase.auth.currentUser?.email ?? '';

  // AuthProvider() {
  //   _init();
  // }

  // Future<void> _init() async {
  //   final currentSession = _supabase.auth.currentSession;
  //   if (currentSession != null) {
  //     _session = currentSession;
  //     notifyListeners();
  //   }
  //
  //   _supabase.auth.onAuthStateChange.listen((event) {
  //     _session = event.session;
  //     notifyListeners();
  //   });
  // }

  /// ---------------- Email Sign Up ----------------

  Future<bool> signUp({required String email, required String password}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      debugPrint('🔵 [Auth] Registering user: $email');

      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        debugPrint('✅ [Auth] Register success: ${response.user!.id}');
        return true;
      } else {
        _errorMessage = 'Registrasi gagal. Silakan coba lagi.';
        debugPrint('⚠️ [Auth] Register failed - no user returned');
        return false;
      }
    } on AuthException catch (e) {
      _errorMessage = e.message;
      debugPrint('❌ [Auth] AuthException: ${e.message}');
      return false;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      debugPrint('❌ [Auth] Unexpected error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      debugPrint('🔵 [Auth] Logging in user: $email');

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        debugPrint('✅ [Auth] Login success: ${response.user!.email}');
        return true;
      } else {
        _errorMessage = 'Login gagal. Periksa email dan password.';
        debugPrint('⚠️ [Auth] Login failed - no user returned');
        return false;
      }
    } on AuthException catch (e) {
      _errorMessage = e.message;
      debugPrint('❌ [Auth] AuthException: ${e.message}');
      return false;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      debugPrint('❌ [Auth] Unexpected error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('has_seen_onboarding'); // Hapus status onboarding

      await supabase.auth.signOut();
      debugPrint('✅ [Auth] User logged out');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ [Auth] Logout error: $e');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

/// ---------------- Google Sign In ----------------
// Future<bool> signInWithGoogle() async {
//   try {
//     _setLoading(true);
//     _errorMessage = null;
//
//     // Pilih akun Google
//     final googleUser = await _googleSignIn.signIn();
//     if (googleUser == null) {
//       _errorMessage = "Login Google dibatalkan.";
//       _setLoading(false);
//       return false;
//     }
//
//     // Ambil token dari Google
//     final googleAuth = await googleUser.authentication;
//
//     // Kirim ke Supabase (sesuai dokumentasi Supabase Flutter)
//     final response = await _supabase.auth.signInWithIdToken(
//       provider: OAuthProvider.google,
//       idToken: googleAuth.idToken!,
//       accessToken: googleAuth.accessToken,
//     );
//
//     if (response.session == null) {
//       _errorMessage = "Login Google gagal.";
//       _setLoading(false);
//       return false;
//     }
//
//     _session = response.session;
//     _setLoading(false);
//     notifyListeners();
//     return true;
//   } catch (e) {
//     _errorMessage = e.toString();
//     _setLoading(false);
//     return false;
//   }
// }

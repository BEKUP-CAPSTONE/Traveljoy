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
  String? get userId => supabase.auth.currentUser?.id;

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

  Future<void> _ensureUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      // Cek apakah profile sudah ada
      final existingProfile = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (existingProfile == null) {
        await supabase.from('profiles').insert({
          'id': user.id,
          'name': user.email?.split('@').first ?? 'User Baru',
          'avatar_url': null,
        });
        debugPrint('✅ [Auth] Profile baru dibuat untuk user: ${user.id}');
      } else {
        debugPrint('ℹ️ [Auth] Profile sudah ada untuk user: ${user.id}');
      }
    } catch (e) {
      debugPrint('❌ [Auth] Gagal memastikan profile user: $e');
    }
  }

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
        await _ensureUserProfile();
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
        await _ensureUserProfile();
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

  Future<bool> signInWithGoogle() async {
    const webClientId =
        '678803397247-srlgok1o6iplsn2cl80drjpn7loegn0m.apps.googleusercontent.com';

    try {
      _setLoading(true);
      _errorMessage = null;

      debugPrint('🔵 [Auth] Sign in with Google...');

      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(serverClientId: webClientId);
      final googleUser = await googleSignIn.authenticate();

      if (googleUser == null) {
        _errorMessage = 'Login Google dibatalkan pengguna.';
        debugPrint('⚠️ [Auth] Google login dibatalkan.');
        return false;
      }

      // Minta authorization untuk akses email & profile
      final scopes = ['email', 'profile'];
      final authorization =
          await googleUser.authorizationClient.authorizationForScopes(scopes) ??
          await googleUser.authorizationClient.authorizeScopes(scopes);

      final idToken = googleUser.authentication.idToken;
      if (idToken == null) throw AuthException('ID Token tidak ditemukan.');

      // Login ke Supabase menggunakan token Google
      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authorization.accessToken,
      );

      final user = response.user;
      if (user == null) {
        _errorMessage = 'Login Google gagal. Tidak ada user yang dikembalikan.';
        debugPrint('⚠️ [Auth] Tidak ada user dari Supabase.');
        return false;
      }

      debugPrint('✅ [Auth] Google login success: ${user.email}');

      // --- Buat atau update profile di tabel profiles ---
      try {
        final existingProfile = await supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        final name =
            user.userMetadata?['name'] ??
            user.email?.split('@').first ??
            'User Baru';
        final avatarUrl =
            user.userMetadata?['avatar_url'] ??
            user.userMetadata?['picture'] ??
            null;

        if (existingProfile == null) {
          await supabase.from('profiles').insert({
            'id': user.id,
            'name': name,
            'avatar_url': avatarUrl,
          });
          debugPrint('✅ [Auth] Profile baru dibuat untuk user: ${user.id}');
        } else {
          debugPrint('ℹ️ [Auth] Profile sudah ada untuk user: ${user.id}');
        }
      } catch (e) {
        debugPrint('❌ [Auth] Gagal menyimpan profile Google: $e');
      }

      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      debugPrint('❌ [Auth] AuthException: ${e.message}');
      return false;
    } catch (e, st) {
      _errorMessage = 'Terjadi kesalahan: $e';
      debugPrint('❌ [Auth] Unexpected error: $e\n$st');
      return false;
    } finally {
      _setLoading(false);
    }
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

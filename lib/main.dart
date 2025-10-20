import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traveljoy/providers/auth_provider.dart';
import 'package:traveljoy/providers/history_provider.dart';
import 'package:traveljoy/providers/onboarding_provider.dart';
import 'package:traveljoy/theme/app_theme.dart';
import 'core/router.dart';
import 'providers/wisata_provider.dart';
import 'providers/itinerary_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/profile_provider.dart';
import 'core/constants/secrets.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Secrets.load();
  // print('🔗 Supabase URL: ${Secrets.supabaseUrl}');
  // print('🔑 Supabase Anon Key: ${Secrets.supabaseAnonKey.substring(0, 10)}...');

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  await Supabase.initialize(
    url: Secrets.supabaseUrl,
    anonKey: Secrets.supabaseAnonKey,
  );
  // try {
  //   final res = await Supabase.instance.client.from('wisata').select('*').limit(1);
  //   print('✅ Tes koneksi sukses: $res');
  // } catch (e) {
  //   print('❌ Tes koneksi gagal: $e');
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WisataProvider()),
        ChangeNotifierProvider(create: (_) => ItineraryProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider(Supabase.instance.client),),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),

      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final router = AppRouter.createRouter(authProvider, context.read<OnboardingProvider>());

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            darkTheme: AppTheme.lightTheme,
            themeMode: ThemeMode.light,
          );
        },
      ),
    );
  }
}


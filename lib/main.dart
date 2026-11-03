import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'screens/login/view/login_page.dart';
import 'screens/home/view/home_page.dart';
import 'screens/settings/controller/settings_controller.dart';
import 'screens/settings/repo/settings_repo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final settingsRepo = SettingsRepo();

  String appearance = 'Light';

  try {
    appearance = await settingsRepo.getAppearance();
  } catch (e) {
    debugPrint('Could not read appearance: $e');
  }

  Get.put(
    SettingsController(
      initialAppearance: appearance,
    ),
    permanent: true,
  );

  runApp(
    MyApp(
      initialThemeMode: appearance == 'Dark'
          ? ThemeMode.dark
          : ThemeMode.light,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeMode initialThemeMode;

  const MyApp({
    super.key,
    required this.initialThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF197866),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF197866),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF197866),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF197866),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: initialThemeMode,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Could not check login status.'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return snapshot.data == null
            ? const Login()
            : const HomePage();
      },
    );
  }
}
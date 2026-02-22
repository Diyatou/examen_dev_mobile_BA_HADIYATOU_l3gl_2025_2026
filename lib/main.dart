import 'package:flutter/material.dart';
import 'package:sunu_task/core/theme/app_theme.dart';
import 'package:sunu_task/screens/splash/splash_screen.dart';
import 'package:sunu_task/services/storage_service.dart';


import 'package:sunu_task/providers/app_provider.dart';
import 'package:sunu_task/providers/auth_provider.dart';
import 'package:sunu_task/providers/project_provider.dart';
import 'package:sunu_task/providers/task_provider.dart';
// Importe aussi tes futurs écrans
import 'package:sunu_task/screens/onboarding/onboarding_screen.dart';
import 'package:sunu_task/screens/auth/login_screen.dart';
import 'package:sunu_task/screens/home/home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.instance.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()..init()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const SunuTask(),
    ),
  );
}

class SunuTask extends StatelessWidget {
  const SunuTask({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SunuTask',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Le Consumer écoute les changements dans AppProvider
      home: Consumer<AppProvider>(
        builder: (context, app, _) {
          // 1. Si pas initialisé -> Splash
          if (!app.isInitialized) return const SplashScreen();

          // 2. Si onboarding pas fait -> Onboarding
          if (!app.isOnboardingComplete) return const OnboardingScreen();

          // 3. On regarde si l'utilisateur est connecté via AuthProvider
          return Consumer<AuthProvider>(
            builder: (context, auth, _) {
              return auth.isAuthenticated
                  ? const HomeScreen()
                  : const LoginScreen();
            },
          );
        },
      ),
    );
  }
}

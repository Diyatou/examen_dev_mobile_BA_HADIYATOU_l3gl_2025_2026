import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_task/core/theme/app_theme.dart';
import 'package:sunu_task/screens/auth/register_screen.dart';
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
  //await StorageService.instance.clear();

  runApp(
    MultiProvider (
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()..init()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()..loadProjects()),
        ChangeNotifierProvider(create: (_) => TaskProvider()..loadTasks()),

      ],
      child: const SunuTask(),
    ),
  );
}

class SunuTask extends StatelessWidget {
  const SunuTask({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SunuTask',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // On réinstalle le "cerveau" de l'application ici
      home: Consumer<AppProvider>(
        builder: (context, app, _) {

          // 1. Splash tant que ce n'est pas initialisé
          // 1. Splash tant que ce n'est pas initialisé
          if (!app.isInitialized) return const SplashScreen();

          // 2. Onboarding si pas fait
          if (!app.isOnboardingComplete) return const OnboardingScreen();

          // 3. Sinon, on regarde l'Auth
          return Consumer<AuthProvider>(
            builder: (context, auth, _) {
              return auth.isAuthenticated
                  ? const HomeScreen()
                  : const LoginScreen();
            },
          );
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}


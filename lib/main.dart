// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_colors.dart';
// import 'core/di/injection_container.dart' as di;
import 'features/authentication/domain/entities/user.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/authentication/presentation/bloc/auth_event.dart';
import 'features/authentication/presentation/bloc/auth_state.dart';
import 'features/authentication/presentation/pages/register_page.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'features/onboarding/presentation/pages/onboarding_screen.dart';
import 'injection_container.dart' as di;

/// Main entry point
void main() async {
  // Required before using any async operations
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 Starting Grand Hotel App...');

  // Initialize dependency injection
  await di.initializeDependencies();

  print('✅ Dependencies initialized, launching app...');

  runApp(const MyApp());
}

/// Root widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Onboarding BLoC
        BlocProvider(
          create: (context) => OnboardingBloc(
            totalPages: 3,
            sharedPreferences: di.sl(),
          ),
        ),

        // Auth BLoC
        BlocProvider(
          create: (context) => di.sl<AuthBloc>()
            ..add(const CheckAuthStatusEvent()),
        ),
      ],

      child: MaterialApp(
        title: 'Grand Hotel',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          primaryColor: AppColors.primary600,
          fontFamily: 'Inter',
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary600,
            brightness: Brightness.light,
          ),
        ),

        home: const AppStartupScreen(),

        routes: {
          '/onboarding': (context) => const OnboardingScreen(),
          '/register': (context) => const RegisterPage(),
        },
      ),
    );
  }
}

/// App Startup Screen
///
/// Decides which screen to show based on:
/// 1. Onboarding completion status
/// 2. Authentication status
class AppStartupScreen extends StatelessWidget {
  const AppStartupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      // ⭐ KEY FIX: Only rebuild for auth status changes
      buildWhen: (previous, current) {
        // Only rebuild when switching between authenticated/unauthenticated
        // Don't rebuild for intermediate states like RegistrationSuccess, OTPSent
        return (previous is! Authenticated && current is Authenticated) ||
            (previous is Authenticated && current is! Authenticated) ||
            current is AuthInitial ||
            (previous is AuthLoading && current is! AuthLoading);
      },
      builder: (context, authState) {
        print('📱 Current Auth State: $authState');

        // Show splash screen while checking authentication
        if (authState is AuthLoading || authState is AuthInitial) {
          return const SplashScreen();
        }

        // Check if onboarding is completed
        final onboardingCompleted = _isOnboardingCompleted();
        print('📱 Onboarding completed: $onboardingCompleted');

        // Decision tree
        if (!onboardingCompleted) {
          // Onboarding not done - show onboarding
          print('➡️  Navigating to: Onboarding');
          return const OnboardingScreen();
        }
        else if (authState is Authenticated) {
          // User is logged in - show main app
          print('➡️  Navigating to: Main App (${authState.user.username})');
          return MainAppPlaceholder(user: authState.user);
        }
        else {
          // User not logged in - show registration
          print('➡️  Navigating to: Registration');
          return const RegisterPage();
        }
      },
    );
  }

  /// Check if onboarding is completed
  bool _isOnboardingCompleted() {
    try {
      final prefs = di.sl<SharedPreferences>();
      return prefs.getBool('onboarding_completed') ?? false;
    } catch (e) {
      print('⚠️  Error checking onboarding: $e');
      return false;
    }
  }
}

/// Splash Screen
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary600,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.hotel,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              'Grand Hotel',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

/// Main App Placeholder
class MainAppPlaceholder extends StatelessWidget {
  final User user;

  const MainAppPlaceholder({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grand Hotel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const LogoutEvent());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome to Grand Hotel!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Logged in as: ${user.username}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${user.email}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
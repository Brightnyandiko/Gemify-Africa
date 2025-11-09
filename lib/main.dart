// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_colors.dart';
import 'core/di/injection_container.dart' as di;
import 'features/authentication/domain/entities/user.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/authentication/presentation/bloc/auth_event.dart';
import 'features/authentication/presentation/bloc/auth_state.dart';
import 'features/authentication/presentation/pages/register_page.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'features/onboarding/presentation/bloc/onboarding_state.dart';
import 'features/onboarding/presentation/pages/onboarding_screen.dart';

/// Main entry point
///
/// This is where everything starts!
void main() async {
  // Required before using any async operations or plugins
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 Starting Grand Hotel App...');

  // ✅ CRITICAL: Initialize dependency injection
  // This sets up all our repositories, use cases, BLoC, etc.
  await di.initializeDependencies();

  print('✅ Dependencies initialized, launching app...');

  // Run the app
  runApp(const MyApp());
}

/// Root widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Provide ALL BLoCs at the root level
    // This makes them available throughout the entire app
    return MultiBlocProvider(
      providers: [
        // Onboarding BLoC (your existing one)
        BlocProvider(
          create: (context) => OnboardingBloc(
            totalPages: 3, // Adjust based on your onboarding pages
            sharedPreferences: di.sl(), // Get from DI container
          ),
        ),

        // Auth BLoC (new - for authentication)
        BlocProvider(
          create: (context) => di.sl<AuthBloc>()
            ..add(const CheckAuthStatusEvent()), // Check if user is logged in
        ),
      ],

      child: MaterialApp(
        title: 'Grand Hotel',
        debugShowCheckedModeBanner: false,

        // Theme
        theme: ThemeData(
          primaryColor: AppColors.primary600,
          fontFamily: 'Inter',
          scaffoldBackgroundColor: Colors.white,

          // Material 3 for modern UI
          useMaterial3: true,

          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary600,
            brightness: Brightness.light,
          ),
        ),

        // ✅ Use home instead of initialRoute for better control
        // This allows us to check onboarding status dynamically
        home: const AppStartupScreen(),

        // ✅ Keep your named routes for navigation
        routes: {
          '/onboarding': (context) => const OnboardingScreen(),
          '/register': (context) => const RegisterPage(),
          // Add more routes as needed
          // '/home': (context) => const HomeScreen(),
          // '/hotel-details': (context) => const HotelDetailsScreen(),
        },
      ),
    );
  }
}

/// App Startup Screen
///
/// This is the FIRST screen shown when app starts
/// It decides where to navigate based on:
/// 1. Has user completed onboarding?
/// 2. Is user authenticated?
class AppStartupScreen extends StatelessWidget {
  const AppStartupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Listen to both BLoCs to make navigation decision
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, onboardingState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            print('📱 Onboarding State: $onboardingState');
            print('📱 Auth State: $authState');

            // ✅ DECISION TREE:

            // 1. Still loading? Show splash/loading
            if (authState is AuthLoading || authState is AuthInitial) {
              return const SplashScreen();
            }

            // 2. Onboarding not completed? Show onboarding
            if (onboardingState is OnboardingInProgress &&
                !_isOnboardingCompleted(context)) {
              return const OnboardingScreen();
            }

            // 3. User authenticated? Show main app
            if (authState is Authenticated) {
              return MainAppPlaceholder(user: authState.user);
            }

            // 4. User not authenticated? Show registration
            // (This includes: Unauthenticated, AuthError, OTPSent, etc.)
            return const RegisterPage();
          },
        );
      },
    );
  }

  /// Check if onboarding is completed
  /// This reads from SharedPreferences via the DI container
  bool _isOnboardingCompleted(BuildContext context) {
    try {
      final prefs = di.sl<SharedPreferences>();
      return prefs.getBool('onboarding_completed') ?? false;
    } catch (e) {
      print('⚠️ Error checking onboarding status: $e');
      return false; // Default to not completed
    }
  }
}

/// Splash Screen
///
/// Shows while app is initializing and checking authentication
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
            // App logo or icon
            const Icon(
              Icons.hotel,
              size: 100,
              color: Colors.white,
            ),

            const SizedBox(height: 24),

            // App name
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

            // Loading indicator
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
///
/// Shown when user is authenticated
/// TODO: Replace with actual home screen
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
              // Logout
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
//```
//
//---
//
//## Understanding the Complete Flow
//
//### Flow Diagram:
//```
//App Starts
//↓
//main() async
//↓
//Initialize Dependencies (DI) ✅
//↓
//Create MultiBlocProvider ✅
//├─ OnboardingBloc (your existing)
//└─ AuthBloc (new)
//↓
//MaterialApp
//↓
//AppStartupScreen (Decision Point)
//↓
//Check States:
//│
//├─ Loading? → SplashScreen
//│
//├─ Onboarding not done? → OnboardingScreen
//│     ↓
//│     User completes onboarding
//│     ↓
//│     Navigate to RegisterPage
//│
//├─ Not authenticated? → RegisterPage
//│     ↓
//│     User registers → OTP → Success
//│     ↓
//│     Authenticated state
//│
//└─ Authenticated? → MainAppPlaceholder
//↓
//User sees main app!
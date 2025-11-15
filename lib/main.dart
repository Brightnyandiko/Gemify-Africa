// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'features/onboarding/presentation/pages/onboarding_screen.dart';
import 'core/constants/app_colors.dart';

// ✅ CRITICAL: Import with 'as di' prefix
import 'injection_container.dart' as di;

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  print('🚀 Starting app initialization...');

  try {
    await di.initializeDependencies();
    print('✅ App initialization complete');
  } catch (e) {
    print('❌ Failed to initialize dependencies: $e');
    // In production, you might want to show an error screen
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ✅ OnboardingBloc takes NO parameters
        BlocProvider(
          create: (context) => di.sl<OnboardingBloc>(),
        ),

        // When you create AuthBloc later, register it here:
        // BlocProvider(create: (context) => di.sl<AuthBloc>()),
      ],
      child: MaterialApp(
        title: 'Grand Hotel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary600,
          fontFamily: 'Inter',
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: '/onboarding',
        routes: {
          '/onboarding': (context) => const OnboardingScreen(),
          // Add authentication routes when ready:
          // '/register': (context) => const RegisterScreen(),
          // '/otp': (context) => const OTPScreen(),
          // '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
//```
//
//---
//
//## Step 5: Verify File Structure
//
//Ensure your files are in the correct locations:
//```
//lib/
//├── injection_container.dart          ← Must be here (root of lib/)
//├── main.dart                         ← Must be here
//├── core/
//│   ├── constants/
//│   │   ├── api_endpoints.dart
//│   │   ├── app_colors.dart
//│   │   └── app_strings.dart
//│   ├── network/
//│   │   ├── dio_client.dart
//│   │   └── network_info.dart
//│   ├── storage/
//│   │   ├── token_storage.dart
//│   │   └── user_storage.dart
//│   └── errors/
//│       ├── exceptions.dart
//│       ├── failures.dart
//│       └── error_handler.dart
//└── features/
//├── authentication/
//│   ├── data/
//│   │   ├── datasources/
//│   │   │   ├── auth_local_datasource.dart
//│   │   │   └── auth_remote_datasource.dart
//│   │   ├── models/
//│   │   │   ├── user_model.dart
//│   │   │   ├── auth_response_model.dart
//│   │   │   ├── register_request_model.dart
//│   │   │   ├── otp_request_model.dart
//│   │   │   └── otp_verify_model.dart
//│   │   └── repositories/
//│   │       └── auth_repository_impl.dart
//│   ├── domain/
//│   │   ├── entities/
//│   │   │   ├── user.dart
//│   │   │   └── auth_response.dart
//│   │   ├── repositories/
//│   │   │   └── auth_repository.dart
//│   │   └── usecases/
//│   │       ├── register_user.dart
//│   │       ├── request_otp.dart
//│   │       ├── verify_otp.dart
//│   │       ├── get_current_user.dart
//│   │       ├── get_user_by_id.dart
//│   │       └── logout.dart
//│   └── presentation/
//│       └── (screens, blocs, widgets - to be created)
//└── onboarding/
//└── (your existing onboarding code)
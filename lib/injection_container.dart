// lib/injection_container.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'core/network/network_info_impl.dart';
import 'core/storage/token_storage.dart';
import 'core/storage/user_storage.dart';

// Authentication Feature
import 'features/authentication/data/datasources/auth_local_datasource.dart';
import 'features/authentication/data/datasources/auth_remote_datasource.dart';
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/domain/repositories/auth_repository.dart';
import 'features/authentication/domain/usecases/get_current_user.dart';
import 'features/authentication/domain/usecases/get_user_by_id.dart';
import 'features/authentication/domain/usecases/logout.dart';
import 'features/authentication/domain/usecases/register_user.dart';
import 'features/authentication/domain/usecases/request_otp.dart';
import 'features/authentication/domain/usecases/verify_otp.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';

/// Service Locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  print('🚀 Initializing Dependency Injection...');

  //==========================================================================
  // EXTERNAL DEPENDENCIES
  //==========================================================================

  // SharedPreferences - async initialization
  print('📦 Initializing SharedPreferences...');
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Connectivity
  print('🌐 Registering Connectivity...');
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // FlutterSecureStorage - ✅ FIXED: Simple initialization
  print('🔐 Registering FlutterSecureStorage...');
  sl.registerLazySingleton<FlutterSecureStorage>(
        () => const FlutterSecureStorage(),
  );

  //==========================================================================
  // CORE - Storage Layer
  //==========================================================================

  print('💾 Registering Storage Services...');

  // TokenStorage
  sl.registerLazySingleton<TokenStorage>(
        () => TokenStorage(sl<FlutterSecureStorage>()),
  );

  // UserStorage - ✅ Check constructor signature
  sl.registerLazySingleton<UserStorage>(
        () => UserStorage(prefs: sl<SharedPreferences>()),
  );

  //==========================================================================
  // CORE - Network Layer
  //==========================================================================

  print('🌍 Registering Network Services...');

  // NetworkInfo
  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(sl<Connectivity>()),
  );

  // DioClient
  sl.registerLazySingleton<DioClient>(
        () => DioClient(sl<TokenStorage>()),
  );

  //==========================================================================
  // AUTHENTICATION - Data Layer
  //==========================================================================

  print('🔑 Registering Authentication Data Sources...');

  // Remote Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(sl<DioClient>()),
  );

  // Local Data Source
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(
      tokenStorage: sl<TokenStorage>(),
      userStorage: sl<UserStorage>(),
    ),
  );

  //==========================================================================
  // AUTHENTICATION - Repository
  //==========================================================================

  print('📚 Registering Authentication Repository...');

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  //==========================================================================
  // AUTHENTICATION - Use Cases
  //==========================================================================

  print('⚙️ Registering Authentication Use Cases...');

  sl.registerLazySingleton<RegisterUser>(
        () => RegisterUser(repository: sl<AuthRepository>()),
  );

  sl.registerLazySingleton<RequestOTP>(
        () => RequestOTP(repository: sl<AuthRepository>()),
  );

  sl.registerLazySingleton<VerifyOTP>(
        () => VerifyOTP(repository: sl<AuthRepository>()),
  );

  sl.registerLazySingleton<GetCurrentUser>(
        () => GetCurrentUser(repository: sl<AuthRepository>()),
  );

  sl.registerLazySingleton<GetUserById>(
        () => GetUserById(repository: sl<AuthRepository>()),
  );

  sl.registerLazySingleton<Logout>(
        () => Logout(repository: sl<AuthRepository>()),
  );

  //==========================================================================
  // ✅ ONBOARDING - Presentation Layer (Bloc)
  //==========================================================================

  print('📱 Registering Onboarding Bloc...');

  // Use registerFactory for Blocs - they should be created fresh each time
  // This prevents state from persisting across navigations
  sl.registerFactory<OnboardingBloc>(
        () => OnboardingBloc(
      totalPages: 3,  // Your app has 3 onboarding pages
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  //==========================================================================
  // SUCCESS
  //==========================================================================

  print('✅ Dependency Injection initialization complete!');
}

/// Reset dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}
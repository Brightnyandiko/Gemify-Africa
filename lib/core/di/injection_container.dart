// lib/core/di/injection_container.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/authentication/data/datasources/auth_local_datasource.dart';
import '../../features/authentication/data/datasources/auth_remote_datasource.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/domain/usecases/get_current_user.dart';
import '../../features/authentication/domain/usecases/logout.dart';
import '../../features/authentication/domain/usecases/register_user.dart';
import '../../features/authentication/domain/usecases/request_otp.dart';
import '../../features/authentication/domain/usecases/verify_otp.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../network/network_info_impl.dart';
import '../storage/token_storage.dart';
import '../storage/user_storage.dart';

/// Service Locator - Global instance
///
/// GetIt is like a magic box where we register all our dependencies
/// Then we can get them anywhere in the app by calling sl<TypeName>()
final sl = GetIt.instance;

/// Initialize all dependencies
///
/// This function is called once when the app starts
/// It sets up everything the app needs in the correct order
Future<void> initializeDependencies() async {
  print('🔧 Initializing dependencies...');

  //==========================================================================
  // External Dependencies (from packages)
  //==========================================================================

  // SharedPreferences - for simple data storage
  print('📦 Registering SharedPreferences...');
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // FlutterSecureStorage - for encrypted storage (JWT tokens)
  print('🔐 Registering FlutterSecureStorage...');
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // // Connectivity - to check internet connection
  // print('🌐 Registering Connectivity...');
  // sl.registerLazySingleton(() => Connectivity());

  // Connectivity - singleton because it's stateless
  print('📦 [DI] Registering Connectivity...');
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  //==========================================================================
  // Core - Utilities and Storage
  //==========================================================================

  // // Network Info - checks if device has internet
  // print('📡 Registering NetworkInfo...');
  // sl.registerLazySingleton<NetworkInfo>(
  //       () => NetworkInfoImpl(sl()),
  // );

  // NetworkInfo - singleton because checking network state is stateless
  print('🌐 [DI] Registering NetworkInfo...');
  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(sl<Connectivity>()),
  );

  // Token Storage - manages JWT tokens securely
  print('🔑 Registering TokenStorage...');
  sl.registerLazySingleton<TokenStorage>(
        () => TokenStorage(sl()),
  );

  // User Storage - manages user data in SharedPreferences
  print('👤 Registering UserStorage...');
  sl.registerLazySingleton<UserStorage>(
        () => UserStorage(sl()),
  );

  // Dio Client - HTTP client for API calls
  print('🌐 Registering DioClient...');
  sl.registerLazySingleton<DioClient>(
        () => DioClient(sl<TokenStorage>()),
  );

  //==========================================================================
  // Data Sources
  //==========================================================================

  // Remote Data Source - talks to Flask API
  print('📡 Registering AuthRemoteDataSource...');
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(sl()),
  );

  // Local Data Source - talks to phone storage
  print('💾 Registering AuthLocalDataSource...');
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(
      tokenStorage: sl(),
      userStorage: sl(),
    ),
  );

  //==========================================================================
  // Repository
  //==========================================================================

  print('🏪 Registering AuthRepository...');
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //==========================================================================
  // Use Cases
  //==========================================================================

  print('⚙️ Registering Use Cases...');
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => RequestOTP(sl()));
  sl.registerLazySingleton(() => VerifyOTP(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  //==========================================================================
  // BLoC
  //==========================================================================

  // We register BLoC as Factory, not Singleton
  // Why? Because we might need fresh BLoC instances for different screens
  print('🧠 Registering AuthBloc...');
  sl.registerFactory(
        () => AuthBloc(
      registerUser: sl(),
      requestOTP: sl(),
      verifyOTP: sl(),
      getCurrentUser: sl(),
      logout: sl(),
    ),
  );

  print('✅ All dependencies initialized successfully!');
}
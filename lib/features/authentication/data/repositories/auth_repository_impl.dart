// lib/features/authentication/data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/otp_request_model.dart';
import '../models/otp_verify_model.dart';
import '../models/register_request_model.dart';

/// Repository Implementation - This is where the actual work happens!
///
/// This class "implements" the AuthRepository interface we created in Domain layer
/// It's like signing a contract and then actually doing the work promised
class AuthRepositoryImpl implements AuthRepository {

  // Dependencies - Things this class needs to do its job
  final AuthRemoteDataSource remoteDataSource;  // Talks to Flask API
  final AuthLocalDataSource localDataSource;    // Talks to phone storage
  final NetworkInfo networkInfo;                // Checks internet connection

  /// Constructor - We receive all dependencies
  /// This is called "Dependency Injection"
  /// Instead of creating these objects ourselves, they're given to us
  ///
  /// Why? Makes testing easier - we can give fake versions for testing
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  //==========================================================================
  // REGISTER USER
  //==========================================================================

  /// Register a new user
  ///
  /// Flow:
  /// 1. Check if we have internet
  /// 2. Call Flask API to register
  /// 3. Save user data locally (for offline access)
  /// 4. Return the user or an error
  ///
  /// Returns: Either<Failure, User>
  /// - Left side = Error occurred (Failure)
  /// - Right side = Success! (User)
  // @override
  // Future<Either<Failure, User>> registerUser({
  //   required String username,
  //   required String email,
  //   required String phone,
  // }) async {
  //
  //   // STEP 1: Check internet connection
  //   // Like checking if your phone has signal before making a call
  //   final isConnected = await networkInfo.isConnected;
  //
  //   if (!isConnected) {
  //     // No internet! Return a NetworkFailure
  //     // The "Left" means error path
  //     print('❌ No internet connection');
  //     return const Left(NetworkFailure('No internet connection'));
  //   }
  //
  //   // STEP 2: We have internet, let's try to register
  //   try {
  //     print('🚀 Starting user registration...');
  //
  //     // Create the request object with user's data
  //     final request = RegisterRequestModel(
  //       username: username,
  //       email: email,
  //       phone: phone,
  //     );
  //
  //     // Call the remote data source (which calls Flask API)
  //     // This is like clicking "Submit" on a registration form
  //     final userModel = await remoteDataSource.registerUser(request);
  //
  //     print('✅ User registered successfully: ${userModel.username}');
  //
  //     // STEP 3: Save user locally so app can work offline
  //     // Like saving a contact on your phone after getting their number
  //     await localDataSource.cacheUser(userModel);
  //
  //     print('💾 User cached locally');
  //
  //     // STEP 4: Return success!
  //     // Convert UserModel (data layer) to User (domain layer)
  //     // The "Right" means success path
  //     return Right(userModel.toEntity());
  //
  //   } on ServerException catch (e) {
  //     // The Flask API returned an error
  //     // Maybe username is taken, or email is invalid
  //     print('❌ Server error: ${e.message}');
  //     return Left(ServerFailure(e.message, statusCode: e.statusCode));
  //
  //   } on NetworkException catch (e) {
  //     // Lost internet during the request
  //     print('❌ Network error: ${e.message}');
  //     return Left(NetworkFailure(e.message));
  //
  //   } catch (e) {
  //     // Something unexpected happened
  //     // Like your phone crashing or running out of memory
  //     print('❌ Unexpected error: $e');
  //     return Left(ServerFailure('Unexpected error during registration'));
  //   }
  // }

  // lib/features/authentication/data/repositories/auth_repository_impl.dart

  @override
  Future<Either<Failure, User>> registerUser({
    required String username,
    required String email,
    required String phone,
  }) async {

    // Use thorough internet check for critical operations
    print('🔍 Verifying internet access for registration...');
    final hasInternet = await networkInfo.hasInternetAccess;

    if (!hasInternet) {
      print('❌ No internet access');
      return const Left(NetworkFailure('No internet connection. Please check your connection and try again.'));
    }

    print('✅ Internet access confirmed, proceeding with registration...');

    try {
      final request = RegisterRequestModel(
        username: username,
        email: email,
        phone: phone,
      );

      final userModel = await remoteDataSource.registerUser(request);

      await localDataSource.cacheUser(userModel);

      return Right(userModel.toEntity());

    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error during registration'));
    }
  }

  //==========================================================================
  // REQUEST OTP
  //==========================================================================

  /// Request OTP to be sent to user's email
  ///
  /// Flow:
  /// 1. Check internet (we need it to send email)
  /// 2. Call Flask API to send OTP
  /// 3. Return success message or error
  ///
  /// Returns: Either<Failure, String>
  /// - Left = Error (couldn't send OTP)
  /// - Right = Success message (OTP sent!)
  @override
  Future<Either<Failure, String>> requestOTP({
    required String email,
  }) async {

    // STEP 1: Check internet
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      print('❌ No internet connection');
      return const Left(NetworkFailure('No internet connection'));
    }

    // STEP 2: Send OTP request
    try {
      print('📧 Requesting OTP for: $email');

      // Create request
      final request = OTPRequestModel(email: email);

      // Call Flask API
      // Your Flask backend will:
      // 1. Generate random OTP (like "ABCD12")
      // 2. Save it in database with expiration time
      // 3. Send email with the OTP
      final message = await remoteDataSource.requestOTP(request);

      print('✅ OTP requested successfully');

      // Return success message
      return Right(message);

    } on ServerException catch (e) {
      // Flask API error - maybe email doesn't exist
      print('❌ Server error: ${e.message}');
      return Left(ServerFailure(e.message, statusCode: e.statusCode));

    } on NetworkException catch (e) {
      // Lost internet
      print('❌ Network error: ${e.message}');
      return Left(NetworkFailure(e.message));

    } catch (e) {
      // Unexpected error
      print('❌ Unexpected error: $e');
      return Left(ServerFailure('Failed to request OTP'));
    }
  }

  //==========================================================================
  // VERIFY OTP
  //==========================================================================

  /// Verify the OTP code user entered
  ///
  /// This is the CRITICAL moment - if OTP is correct, user gets logged in!
  ///
  /// Flow:
  /// 1. Check internet
  /// 2. Send OTP to Flask API for verification
  /// 3. If correct:
  ///    - Receive JWT token from Flask
  ///    - Save token locally (encrypted)
  ///    - Save user data locally
  ///    - Return success with user data and token
  /// 4. If wrong:
  ///    - Return error (invalid OTP)
  ///
  /// Returns: Either<Failure, AuthResponse>
  /// - Left = OTP wrong or other error
  /// - Right = Success! User is now logged in
  @override
  Future<Either<Failure, AuthResponse>> verifyOTP({
    required String email,
    required String otp,
  }) async {

    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      print('❌ No internet connection');
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      print('🔐 Verifying OTP for: $email');

      final request = OTPVerifyModel(email: email, otp: otp);

      // Get AuthResponseModel from remote source
      // Note: We keep it as Model (not convert to entity yet)
      final authResponseModel = await remoteDataSource.verifyOTP(request);

      print('✅ OTP verified successfully!');
      print('👤 Logged in as: ${authResponseModel.user.username}');

      // STEP 1: Save token
      await localDataSource.saveToken(authResponseModel.accessToken);
      print('🔐 Token saved securely');

      // STEP 2: Cache user
      // authResponseModel.user is UserModel (from AuthResponseModel)
      // So this works perfectly without conversion
      await localDataSource.cacheUser(authResponseModel.user);
      print('💾 User data cached');

      // STEP 3: Convert to entity for Domain layer
      // Only convert when returning to use case
      return Right(authResponseModel.toEntity());

    } on ServerException catch (e) {
      print('❌ Server error: ${e.message}');

      if (e.statusCode == 400 || e.statusCode == 401) {
        return const Left(ServerFailure('Invalid or expired OTP'));
      }

      return Left(ServerFailure(e.message, statusCode: e.statusCode));

    } on NetworkException catch (e) {
      print('❌ Network error: ${e.message}');
      return Left(NetworkFailure(e.message));

    } catch (e) {
      print('❌ Unexpected error: $e');
      return Left(ServerFailure('Failed to verify OTP'));
    }
  }

  //==========================================================================
  // GET CURRENT USER
  //==========================================================================

  /// Get the currently logged-in user
  ///
  /// This is used when app starts to check who's logged in
  ///
  /// Flow (Smart caching strategy):
  /// 1. Try to get from local storage (fast, works offline)
  /// 2. If found, return it (no API call needed!)
  /// 3. If not found, try API (need internet)
  /// 4. Save API result locally for next time
  ///
  /// This is called "Cache-First Strategy" - always try local first
  ///
  /// Returns: Either<Failure, User>
  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      print('👤 Getting current user...');

      // STRATEGY 1: Try local storage first (fast!)
      print('📱 Checking local cache...');
      final cachedUser = await localDataSource.getCachedUser();

      if (cachedUser != null) {
        // Found in cache! No need for API call
        print('✅ User found in cache: ${cachedUser.username}');
        print('⚡ Returning cached user (offline-capable)');
        return Right(cachedUser.toEntity());
      }

      // STRATEGY 2: Not in cache, try API (need internet)
      print('🌐 No cached user, fetching from API...');

      final isConnected = await networkInfo.isConnected;

      if (!isConnected) {
        // No cache AND no internet = can't get user
        print('❌ No internet and no cached user');
        return const Left(NetworkFailure('No internet connection'));
      }

      // Fetch from API
      final userModel = await remoteDataSource.getCurrentUser();

      print('✅ User fetched from API: ${userModel.username}');

      // Save to cache for next time
      await localDataSource.cacheUser(userModel);
      print('💾 User cached for offline use');

      return Right(userModel.toEntity());

    } on ServerException catch (e) {
      // API call failed - maybe token expired
      print('❌ Server error: ${e.message}');

      // If 401, user needs to log in again
      if (e.statusCode == 401) {
        // Clear invalid data
        await localDataSource.clearCache();
        return const Left(ServerFailure('Session expired. Please login again'));
      }

      return Left(ServerFailure(e.message, statusCode: e.statusCode));

    } on NetworkException catch (e) {
      print('❌ Network error: ${e.message}');
      return Left(NetworkFailure(e.message));

    } catch (e) {
      print('❌ Unexpected error: $e');
      return Left(ServerFailure('Failed to get current user'));
    }
  }

  //==========================================================================
  // GET USER BY ID
  //==========================================================================

  /// Get a specific user by their ID
  ///
  /// This is used to view other users' profiles, admin functions, etc.
  ///
  /// Flow:
  /// 1. Check internet (we need API for this)
  /// 2. Call Flask API with user ID
  /// 3. Return user data or error
  ///
  /// Note: We don't cache other users' data (privacy, could be outdated)
  ///
  /// Returns: Either<Failure, User>
  @override
  Future<Either<Failure, User>> getUserById(int userId) async {

    // STEP 1: Check internet
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      print('❌ No internet connection');
      return const Left(NetworkFailure('No internet connection'));
    }

    // STEP 2: Fetch user from API
    try {
      print('👤 Fetching user with ID: $userId');

      // Call Flask API: GET /users/{userId}
      final userModel = await remoteDataSource.getUserById(userId);

      print('✅ User fetched: ${userModel.username}');

      return Right(userModel.toEntity());

    } on ServerException catch (e) {
      print('❌ Server error: ${e.message}');

      // If 404, user doesn't exist
      if (e.statusCode == 404) {
        return const Left(ServerFailure('User not found'));
      }

      return Left(ServerFailure(e.message, statusCode: e.statusCode));

    } on NetworkException catch (e) {
      print('❌ Network error: ${e.message}');
      return Left(NetworkFailure(e.message));

    } catch (e) {
      print('❌ Unexpected error: $e');
      return Left(ServerFailure('Failed to get user'));
    }
  }

  //==========================================================================
  // LOGOUT
  //==========================================================================

  /// Log out the current user
  ///
  /// Flow:
  /// 1. Clear JWT token from secure storage
  /// 2. Clear user data from local storage
  /// 3. User is now logged out - need to authenticate again
  ///
  /// Note: We don't need internet for logout - it's a local operation
  /// The token becomes useless once removed
  ///
  /// Returns: Either<Failure, void>
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      print('👋 Logging out user...');

      // Clear all authentication data
      // This removes:
      // - JWT token (secure storage)
      // - User data (SharedPreferences)
      // - Any other cached auth data
      await localDataSource.clearCache();

      print('✅ User logged out successfully');
      print('🗑️ All authentication data cleared');

      // Return success (void = nothing to return, just confirmation)
      return const Right(null);

    } on CacheException catch (e) {
      // Failed to clear cache - rare but possible
      print('❌ Cache error: ${e.message}');
      return Left(CacheFailure(e.message));

    } catch (e) {
      // Unexpected error
      print('❌ Unexpected error: $e');
      return const Left(CacheFailure('Failed to logout'));
    }
  }

  //==========================================================================
  // IS AUTHENTICATED
  //==========================================================================

  /// Check if user is currently authenticated
  ///
  /// This checks if we have:
  /// 1. A valid JWT token
  /// 2. Cached user data
  ///
  /// If both exist, user is considered authenticated
  ///
  /// Used when app starts to decide:
  /// - Show login screen? OR
  /// - Show main app?
  ///
  /// Returns: Either<Failure, bool>
  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      print('🔍 Checking authentication status...');

      // Check local storage for token and user
      final hasSession = await localDataSource.hasValidSession();

      if (hasSession) {
        print('✅ User is authenticated');
      } else {
        print('ℹ️ User is not authenticated');
      }

      return Right(hasSession);

    } catch (e) {
      // If we can't check, assume not authenticated (safe default)
      print('❌ Error checking authentication: $e');
      return const Right(false);
    }
  }
}
//```
//
//---
//
//## Let me explain key concepts for absolute beginners:
//
//### **1. Either<Left, Right> - The Railway Track**
//
//Imagine a train track that splits into two paths:
//```
//START
//|
//Does it work?
///    \
//Yes     No
//↓       ↓
//Success  Error
//(Right)  (Left)
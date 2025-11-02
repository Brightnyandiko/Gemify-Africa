// lib/features/authentication/data/datasources/auth_local_datasource.dart

import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/storage/user_storage.dart';
import '../models/user_model.dart';

/// Abstract class - Contract for local data operations
abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<bool> hasValidSession();
}

/// Implementation - Actually stores/retrieves data from phone
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final TokenStorage tokenStorage;   // Manages JWT tokens (secure)
  final UserStorage userStorage;     // Manages user data (SharedPreferences)

  AuthLocalDataSourceImpl({
    required this.tokenStorage,
    required this.userStorage,
  });

  /// Save user to local storage
  ///
  /// This allows app to work offline and remember the user
  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      print('💾 Caching user: ${user.username}');
      await userStorage.saveUser(user);
      print('✅ User cached successfully');
    } catch (e) {
      print('❌ Failed to cache user: $e');
      throw CacheException('Failed to save user locally');
    }
  }

  /// Get cached user from storage
  ///
  /// Returns null if no user is cached
  @override
  Future<UserModel?> getCachedUser() async {
    try {
      print('📱 Retrieving cached user');
      final user = userStorage.getUser();

      if (user != null) {
        print('✅ Found cached user: ${user.username}');
        // Convert User entity to UserModel
        return UserModel.fromEntity(user);
      }

      print('ℹ️ No cached user found');
      return null;
    } catch (e) {
      print('❌ Failed to get cached user: $e');
      throw CacheException('Failed to retrieve cached user');
    }
  }

  /// Clear all cached authentication data
  ///
  /// Called when user logs out
  @override
  Future<void> clearCache() async {
    try {
      print('🗑️ Clearing authentication cache');
      await userStorage.deleteUser();
      await tokenStorage.clearAll();
      print('✅ Cache cleared successfully');
    } catch (e) {
      print('❌ Failed to clear cache: $e');
      throw CacheException('Failed to clear cache');
    }
  }

  /// Save JWT token securely
  ///
  /// Token is encrypted and stored in secure storage
  @override
  Future<void> saveToken(String token) async {
    try {
      print('🔐 Saving authentication token');
      await tokenStorage.saveToken(token);
      print('✅ Token saved securely');
    } catch (e) {
      print('❌ Failed to save token: $e');
      throw CacheException('Failed to save token');
    }
  }

  /// Retrieve saved token
  ///
  /// Returns null if no token exists
  @override
  Future<String?> getToken() async {
    try {
      print('🔑 Retrieving authentication token');
      final token = await tokenStorage.getToken();

      if (token != null) {
        print('✅ Token found');
        return token;
      }

      print('ℹ️ No token found');
      return null;
    } catch (e) {
      print('❌ Failed to get token: $e');
      throw CacheException('Failed to retrieve token');
    }
  }

  /// Delete token from storage
  ///
  /// Called during logout
  @override
  Future<void> deleteToken() async {
    try {
      print('🗑️ Deleting authentication token');
      await tokenStorage.deleteToken();
      print('✅ Token deleted');
    } catch (e) {
      print('❌ Failed to delete token: $e');
      throw CacheException('Failed to delete token');
    }
  }

  /// Check if user has a valid session
  ///
  /// Returns true if both token and user are cached
  @override
  Future<bool> hasValidSession() async {
    try {
      print('🔍 Checking for valid session');

      final hasToken = await tokenStorage.hasToken();
      final hasUser = userStorage.hasUser();

      final isValid = hasToken && hasUser;

      print(isValid
          ? '✅ Valid session found'
          : 'ℹ️ No valid session');

      return isValid;
    } catch (e) {
      print('❌ Failed to check session: $e');
      return false;
    }
  }
}
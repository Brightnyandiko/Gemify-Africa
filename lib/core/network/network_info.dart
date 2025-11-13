// lib/core/network/network_info.dart

/// Network Information Interface
///
/// This abstraction belongs to the domain/core layer
/// It defines WHAT operations are needed, not HOW they work
///
/// Clean Architecture Rule:
/// - Domain layer defines interfaces
/// - Data layer implements them
/// - This prevents domain from depending on external packages
abstract class NetworkInfo {
  /// Quick check: Is device connected to a network?
  ///
  /// Returns true if device is connected to WiFi, mobile data, or ethernet
  /// Does NOT guarantee internet access
  ///
  /// Use this for: Quick UI indicators, pre-flight checks
  Future<bool> get isConnected;

  /// Thorough check: Does device have actual internet access?
  ///
  /// Performs actual network request to verify connectivity
  /// More reliable but slower than isConnected
  ///
  /// Use this for: Critical operations like authentication, payments
  Future<bool> get hasInternetAccess;
}
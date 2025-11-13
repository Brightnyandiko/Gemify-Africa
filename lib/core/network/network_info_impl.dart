// lib/core/network/network_info_impl.dart

import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'network_info.dart';

/// Network Information Implementation
///
/// This belongs to the data layer
/// It uses the connectivity_plus plugin to check connectivity
///
/// Clean Architecture Rule:
/// - Implementation in data layer
/// - Depends on external packages
/// - Implements domain interface
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  /// Constructor with dependency injection
  ///
  /// We inject Connectivity instead of creating it
  /// This makes testing easier
  NetworkInfoImpl(this.connectivity);

  //==========================================================================
  // Quick Network Availability Check
  //==========================================================================

  @override
  Future<bool> get isConnected async {
    try {
      print('🔍 [NetworkInfo] Checking device connectivity...');

      // Get connectivity status
      final result = await connectivity.checkConnectivity();

      // Log for debugging
      print('📡 [NetworkInfo] Raw result: $result');
      print('📡 [NetworkInfo] Result type: ${result.runtimeType}');

      // Handle version differences
      bool hasConnection = _parseConnectivityResult(result);

      print(hasConnection
          ? '✅ [NetworkInfo] Device is connected to network'
          : '❌ [NetworkInfo] Device has no network connection');

      return hasConnection;

    } catch (e, stackTrace) {
      print('❌ [NetworkInfo] Error checking connectivity: $e');
      print('Stack trace: $stackTrace');

      // On error, assume connection exists (fail open)
      // This prevents false negatives
      return true;
    }
  }

  /// Parse ConnectivityResult handling both API versions
  ///
  /// Returns true if device is connected to any network
  bool _parseConnectivityResult(dynamic result) {
    // Handle new API (List<ConnectivityResult>)
    if (result is List<ConnectivityResult>) {
      print('📋 [NetworkInfo] Using List API (connectivity_plus ≥ 3.0.0)');

      // Device is connected if:
      // 1. List is not empty AND
      // 2. List doesn't contain ConnectivityResult.none
      return result.isNotEmpty &&
          !result.contains(ConnectivityResult.none);
    }

    // Handle old API (single ConnectivityResult)
    if (result is ConnectivityResult) {
      print('📋 [NetworkInfo] Using single-value API (connectivity_plus < 3.0.0)');

      // Device is connected if result is not 'none'
      return result != ConnectivityResult.none;
    }

    // Unknown type - log warning and fail safe
    print('⚠️ [NetworkInfo] Unknown result type: ${result.runtimeType}');
    return false;
  }

  //==========================================================================
  // Thorough Internet Access Check
  //==========================================================================

  @override
  Future<bool> get hasInternetAccess async {
    try {
      print('🌐 [NetworkInfo] Verifying internet access...');

      // Step 1: Quick check - is device connected to network?
      final deviceConnected = await isConnected;

      if (!deviceConnected) {
        print('❌ [NetworkInfo] Device not connected to any network');
        return false;
      }

      print('✅ [NetworkInfo] Device connected to network, testing internet...');

      // Step 2: Thorough check - can we reach the internet?
      // Try DNS lookup to reliable servers
      final results = await Future.wait([
        _checkDNS('google.com'),
        _checkDNS('cloudflare.com'),
      ]);

      // If any DNS lookup succeeds, we have internet
      final hasInternet = results.any((result) => result);

      print(hasInternet
          ? '✅ [NetworkInfo] Internet access confirmed'
          : '❌ [NetworkInfo] No internet access (DNS lookup failed)');

      return hasInternet;

    } catch (e) {
      print('❌ [NetworkInfo] Error checking internet access: $e');

      // On error, assume internet exists (fail open)
      return true;
    }
  }

  /// Perform DNS lookup to check internet connectivity
  ///
  /// Returns true if DNS lookup succeeds
  Future<bool> _checkDNS(String hostname) async {
    try {
      final result = await InternetAddress.lookup(hostname)
          .timeout(const Duration(seconds: 3));

      final success = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      if (success) {
        print('✅ [NetworkInfo] DNS lookup succeeded: $hostname');
      }

      return success;

    } on SocketException catch (e) {
      print('⚠️ [NetworkInfo] DNS lookup failed for $hostname: $e');
      return false;

    } on TimeoutException catch (e) {
      print('⚠️ [NetworkInfo] DNS timeout for $hostname: $e');
      return false;

    } catch (e) {
      print('⚠️ [NetworkInfo] Unexpected error checking $hostname: $e');
      return false;
    }
  }
}
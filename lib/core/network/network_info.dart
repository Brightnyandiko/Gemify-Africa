// // lib/core/network/network_info.dart
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// abstract class NetworkInfo {
//   Future<bool> get isConnected;
// }
//
// class NetworkInfoImpl implements NetworkInfo {
//   final Connectivity connectivity;
//
//   NetworkInfoImpl(this.connectivity);
//
//   @override
//   Future<bool> get isConnected async {
//     final result = await connectivity.checkConnectivity();
//     return result != ConnectivityResult.none;
//   }
// }

// lib/core/network/network_info.dart

import 'dart:io';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Network Information Interface
abstract class NetworkInfo {
  /// Quick connectivity check using device network interfaces
  Future<bool> get isConnected;

  /// Thorough check with actual internet access verification
  Future<bool> get hasInternetAccess;

  /// Stream of connectivity changes
  Stream<bool> get connectivityStream;
}

/// Network Information Implementation
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    try {
      print('🔍 [NetworkInfo] Checking connectivity...');

      // Get connectivity results (returns List in modern versions)
      final List<ConnectivityResult> results =
      (await connectivity.checkConnectivity()) as List<ConnectivityResult>;

      print('📡 [NetworkInfo] Results: $results');

      // Device has connection if:
      // 1. Results list is not empty, AND
      // 2. Not ALL results are 'none'
      final hasConnection = results.isNotEmpty &&
          !results.every((r) => r == ConnectivityResult.none);

      if (hasConnection) {
        print('✅ [NetworkInfo] Device connected via: $results');
      } else {
        print('❌ [NetworkInfo] No active network interfaces');
      }

      return hasConnection;

    } catch (e, stackTrace) {
      print('❌ [NetworkInfo] Error checking connectivity: $e');
      print('Stack trace: $stackTrace');

      // Fail open - let API call determine actual connectivity
      return true;
    }
  }

  @override
  Future<bool> get hasInternetAccess async {
    try {
      // Step 1: Check device connectivity
      final deviceConnected = await isConnected;

      if (!deviceConnected) {
        print('📱 [NetworkInfo] Device has no network interfaces');
        return false;
      }

      print('🌐 [NetworkInfo] Verifying actual internet access...');

      // Step 2: Verify with DNS lookup
      final result = await InternetAddress.lookup('google.com')
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('⏱️ [NetworkInfo] DNS lookup timed out');
          return <InternetAddress>[];
        },
      );

      // Step 3: Check results
      final hasInternet = result.isNotEmpty &&
          result[0].rawAddress.isNotEmpty;

      if (hasInternet) {
        print('✅ [NetworkInfo] Internet access confirmed');
      } else {
        print('❌ [NetworkInfo] DNS lookup failed - no internet');
      }

      return hasInternet;

    } on SocketException catch (e) {
      print('❌ [NetworkInfo] Socket exception: ${e.message}');
      return false;

    } on TimeoutException catch (e) {
      print('❌ [NetworkInfo] Timeout: ${e.message}');
      return false;

    } catch (e) {
      print('❌ [NetworkInfo] Unexpected error: $e');
      return true; // Fail open
    }
  }

  @override
  Stream<bool> get connectivityStream {
    // Stream that emits true/false when connectivity changes
    return connectivity.onConnectivityChanged.map((results) {
      final hasConnection = results.isNotEmpty &&
          !results.every((r) => r == ConnectivityResult.none);

      print('📡 [NetworkInfo] Connectivity changed: $hasConnection ($results)');

      return hasConnection;
    });
  }
}
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

import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Future<bool> get hasInternetAccess;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  /// Quick check using connectivity plugin
  @override
  Future<bool> get isConnected async {
    try {
      final result = await connectivity.checkConnectivity();

      if (result is List<ConnectivityResult>) {
        return result.isNotEmpty && !result.contains(ConnectivityResult.none);
      } else return result != ConnectivityResult.none;


      return false;
    } catch (e) {
      print('⚠️ Connectivity check error: $e');
      return true; // Fail open
    }
  }

  /// Thorough check with actual network request
  /// Use this for critical operations like registration
  @override
  Future<bool> get hasInternetAccess async {
    try {
      // First check device connectivity
      final deviceConnected = await isConnected;
      if (!deviceConnected) {
        print('📱 Device reports no connectivity');
        return false;
      }

      print('🌐 Device connected, verifying internet access...');

      // Try to reach a reliable server (Google DNS)
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('✅ Internet access verified');
        return true;
      }

      print('❌ DNS lookup failed');
      return false;

    } on SocketException catch (e) {
      print('❌ Socket exception: $e');
      return false;
    } on TimeoutException catch (e) {
      print('❌ Timeout: $e');
      return false;
    } catch (e) {
      print('❌ Unknown error: $e');
      return true; // Fail open
    }
  }
}
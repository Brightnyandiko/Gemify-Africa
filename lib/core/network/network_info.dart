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

  @override
  Future<bool> get isConnected async {
    try {
      print('🔍 Checking network connectivity...');

      // This returns List<ConnectivityResult> in modern versions
      final List<ConnectivityResult> connectivityResults =
      await connectivity.checkConnectivity();

      print('📡 Connectivity results: $connectivityResults');

      // Check if there's at least one active connection
      // (not empty and not all 'none')
      final hasConnection = connectivityResults.isNotEmpty &&
          !connectivityResults.every((result) => result == ConnectivityResult.none);

      if (hasConnection) {
        print('✅ Connected via: $connectivityResults');
      } else {
        print('❌ No active connections');
      }

      return hasConnection;

    } catch (e, stackTrace) {
      print('❌ Error checking connectivity: $e');
      print('Stack trace: $stackTrace');
      return true; // Fail open
    }
  }

  @override
  Future<bool> get hasInternetAccess async {
    try {
      // First check device connectivity
      final deviceConnected = await isConnected;

      if (!deviceConnected) {
        print('📱 No network interfaces available');
        return false;
      }

      print('🌐 Verifying actual internet access...');

      // Try to reach a reliable server
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));

      final hasInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      if (hasInternet) {
        print('✅ Internet access verified');
      } else {
        print('❌ No internet access');
      }

      return hasInternet;

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
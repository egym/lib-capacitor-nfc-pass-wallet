import 'dart:async';

import 'package:flutter/services.dart';

class WalletAvailabilityResult {
  const WalletAvailabilityResult({required this.result});

  final bool result;
}

class ReadPassFromWalletResult {
  const ReadPassFromWalletResult({required this.result});

  final bool result;
}

class EgymNfcPassWallet {
  static const MethodChannel _channel = MethodChannel('CapacitorNFCPassWallet');

  static Future<void> savePassToWallet({
    String? iosPkPassBase64,
    String? androidPassJwt,
    String? googlePayJwt,
    String? saveToGooglePayUrl,
  }) async {
    await _channel.invokeMethod<void>('savePassToWallet', {
      'iosPkPassBase64': iosPkPassBase64,
      'androidPassJwt': androidPassJwt,
      'googlePayJwt': googlePayJwt,
      'saveToGooglePayUrl': saveToGooglePayUrl,
    });
  }

  static Future<ReadPassFromWalletResult> readPassFromWallet({String? iosPkPassBase64}) async {
    final result = await _channel.invokeMethod<dynamic>('readPassFromWallet', {
      'iosPkPassBase64': iosPkPassBase64,
    });

    return ReadPassFromWalletResult(result: _extractResultValue(result));
  }

  static Future<WalletAvailabilityResult> isWalletAvailable() async {
    final result = await _channel.invokeMethod<dynamic>('isWalletAvailable');
    return WalletAvailabilityResult(result: _extractResultValue(result));
  }

  static bool _extractResultValue(dynamic result) {
    if (result is Map) {
      final value = result['result'];
      if (value is bool) {
        return value;
      }
    }

    if (result is bool) {
      return result;
    }

    return false;
  }
}

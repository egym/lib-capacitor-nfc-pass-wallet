import 'dart:async';

import 'package:flutter/services.dart';

class EgymNfcPassWallet {
  static const MethodChannel _channel = MethodChannel('egym_nfc_pass_wallet');

  static Future<void> savePassToWallet({
    String? iosPkPassBase64,
    String? googlePayJwt,
    String? saveToGooglePayUrl,
  }) async {
    await _channel.invokeMethod<void>('savePassToWallet', {
      'iosPkPassBase64': iosPkPassBase64,
      'googlePayJwt': googlePayJwt,
      'saveToGooglePayUrl': saveToGooglePayUrl,
    });
  }

  static Future<bool> readPassFromWallet({String? iosPkPassBase64}) async {
    final result = await _channel.invokeMethod<bool>('readPassFromWallet', {
      'iosPkPassBase64': iosPkPassBase64,
    });
    return result ?? false;
  }

  static Future<bool> isWalletAvailable() async {
    final result = await _channel.invokeMethod<bool>('isWalletAvailable');
    return result ?? false;
  }
}

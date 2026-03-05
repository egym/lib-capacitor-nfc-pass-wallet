import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:egym_nfc_pass_wallet/egym_nfc_pass_wallet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('egym_nfc_pass_wallet');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          calls.add(methodCall);

          switch (methodCall.method) {
            case 'readPassFromWallet':
              return true;
            case 'isWalletAvailable':
              return true;
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('savePassToWallet forwards arguments to channel', () async {
    await EgymNfcPassWallet.savePassToWallet(
      iosPkPassBase64: 'pkpass',
      googlePayJwt: 'jwt',
      saveToGooglePayUrl: 'https://example.com/save',
    );

    expect(calls.single.method, 'savePassToWallet');
    expect(calls.single.arguments, {
      'iosPkPassBase64': 'pkpass',
      'googlePayJwt': 'jwt',
      'saveToGooglePayUrl': 'https://example.com/save',
    });
  });

  test('readPassFromWallet returns channel result', () async {
    final value = await EgymNfcPassWallet.readPassFromWallet(iosPkPassBase64: 'pkpass');

    expect(value, true);
    expect(calls.single.method, 'readPassFromWallet');
  });

  test('readPassFromWallet falls back to false when channel returns null', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          calls.add(methodCall);
          return null;
        });

    final value = await EgymNfcPassWallet.readPassFromWallet(iosPkPassBase64: 'pkpass');

    expect(value, false);
  });

  test('isWalletAvailable returns channel result', () async {
    final value = await EgymNfcPassWallet.isWalletAvailable();

    expect(value, true);
    expect(calls.single.method, 'isWalletAvailable');
  });

  test('isWalletAvailable falls back to false when channel returns null', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          calls.add(methodCall);
          return null;
        });

    final value = await EgymNfcPassWallet.isWalletAvailable();

    expect(value, false);
  });
}

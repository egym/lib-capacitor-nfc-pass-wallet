# `egym_nfc_pass_wallet`

Flutter plugin for EGYM NFC pass wallet integration on iOS and Android.

The plugin exposes wallet availability checks plus Apple Wallet and Google Wallet add flows through a single Dart API.

## Installation

```bash
flutter pub add egym_nfc_pass_wallet
```

Then fetch dependencies:

```bash
flutter pub get
```

## Import

```dart
import 'package:egym_nfc_pass_wallet/egym_nfc_pass_wallet.dart';
```

## API

The plugin exposes three methods:

- `EgymNfcPassWallet.savePassToWallet(...)`
- `EgymNfcPassWallet.readPassFromWallet(...)`
- `EgymNfcPassWallet.isWalletAvailable()`

Two small result types wrap boolean responses:

```dart
class WalletAvailabilityResult {
  const WalletAvailabilityResult({required this.result});

  final bool result;
}

class ReadPassFromWalletResult {
  const ReadPassFromWalletResult({required this.result});

  final bool result;
}
```

### `isWalletAvailable()`

Use this before showing wallet actions in the UI.

```dart
final availability = await EgymNfcPassWallet.isWalletAvailable();

if (availability.result) {
  // show wallet CTA
}
```

### `savePassToWallet(...)`

On iOS, pass the Base64-encoded `.pkpass` payload via `iosPkPassBase64`.

```dart
await EgymNfcPassWallet.savePassToWallet(
  iosPkPassBase64: iosPkPassBase64,
);
```

On Android, prefer `googlePayJwt` when available. `saveToGooglePayUrl` is also supported, and `androidPassJwt` remains available temporarily for backward compatibility.

```dart
await EgymNfcPassWallet.savePassToWallet(
  googlePayJwt: googlePayJwt,
  saveToGooglePayUrl: saveToGooglePayUrl,
  androidPassJwt: androidPassJwt,
);
```

Android payload precedence is:

1. `googlePayJwt`
2. `saveToGooglePayUrl`
3. `androidPassJwt`

### `readPassFromWallet(...)`

This is supported on iOS only and returns whether the pass is already present in Apple Wallet.

```dart
final passState = await EgymNfcPassWallet.readPassFromWallet(
  iosPkPassBase64: iosPkPassBase64,
);

if (passState.result) {
  // pass already exists in Apple Wallet
}
```

On Android, `readPassFromWallet(...)` is intentionally unsupported and throws a `PlatformException` with code `NOT_SUPPORTED`.

## Typical Integration Flow

```dart
final availability = await EgymNfcPassWallet.isWalletAvailable();

if (!availability.result) {
  return;
}

if (platformIsIos) {
  final existingPass = await EgymNfcPassWallet.readPassFromWallet(
    iosPkPassBase64: iosPkPassBase64,
  );

  if (!existingPass.result) {
    await EgymNfcPassWallet.savePassToWallet(
      iosPkPassBase64: iosPkPassBase64,
    );
  }
}

if (platformIsAndroid) {
  await EgymNfcPassWallet.savePassToWallet(
    googlePayJwt: googlePayJwt,
    saveToGooglePayUrl: saveToGooglePayUrl,
    androidPassJwt: androidPassJwt,
  );
}
```

## Platform Notes

- iOS `savePassToWallet(...)` presents the native Apple Wallet UI
- iOS `readPassFromWallet(...)` checks whether the pass is already present
- Android `savePassToWallet(...)` launches the Google Wallet add flow
- Android `readPassFromWallet(...)` is not supported by Google Wallet APIs

## Errors

Failures surface as `PlatformException`s. Relevant error codes include:

- `UNAVAILABLE`
- `INVALID_PAYLOAD`
- `NOT_SUPPORTED`
- `NATIVE_ERROR`

## Development

For repository-level build, validation, and release instructions, see the [repository README](../../README.md).

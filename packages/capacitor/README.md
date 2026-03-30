# `@egym/capacitor-nfc-pass-wallet`

Capacitor plugin for EGYM NFC pass wallet integration on iOS and Android.

This package bundles its native implementations, so partner apps do not need separate iOS or Android wrapper libraries for the wallet flows exposed here.

## Installation

```bash
npm install @egym/capacitor-nfc-pass-wallet
npx cap sync
```

## Import

```ts
import { CapacitorNFCPassWallet } from "@egym/capacitor-nfc-pass-wallet";
```

## API

The plugin exposes three methods:

- `savePassToWallet`
- `readPassFromWallet`
- `isWalletAvailable`

`isWalletAvailable()` and `readPassFromWallet()` both resolve to objects with a boolean `result` property.

```ts
type SavePassToWalletOptions = {
  iosPkPassBase64?: string;
  androidPassJwt?: string;
  saveToGooglePayUrl?: string;
  googlePayJwt?: string;
};

type ReadPassFromWalletOptions = {
  iosPkPassBase64?: string;
};

type WalletAvailabilityResult = {
  result: boolean;
};

type ReadPassFromWalletResult = {
  result: boolean;
};
```

### `isWalletAvailable()`

Use this before showing wallet actions in the UI.

```ts
const availability = await CapacitorNFCPassWallet.isWalletAvailable();

if (availability.result) {
  // show wallet CTA
}
```

### `savePassToWallet(options)`

On iOS, pass the Base64-encoded `.pkpass` payload via `iosPkPassBase64`.

```ts
await CapacitorNFCPassWallet.savePassToWallet({
  iosPkPassBase64,
});
```

On Android, prefer `googlePayJwt` when available. `saveToGooglePayUrl` is also supported, and `androidPassJwt` remains available temporarily for backward compatibility.

```ts
await CapacitorNFCPassWallet.savePassToWallet({
  googlePayJwt,
  saveToGooglePayUrl,
  androidPassJwt,
});
```

Android payload precedence is:

1. `googlePayJwt`
2. `saveToGooglePayUrl`
3. `androidPassJwt`

### `readPassFromWallet(options)`

This is supported on iOS only and returns whether the pass is already present in Apple Wallet.

```ts
const passState = await CapacitorNFCPassWallet.readPassFromWallet({
  iosPkPassBase64,
});

if (passState.result) {
  // pass already exists in Apple Wallet
}
```

On Android, `readPassFromWallet()` is intentionally unsupported and rejects with `NOT_SUPPORTED`.

## Typical Integration Flow

```ts
const availability = await CapacitorNFCPassWallet.isWalletAvailable();

if (!availability.result) {
  return;
}

if (platform === "ios") {
  const existingPass = await CapacitorNFCPassWallet.readPassFromWallet({
    iosPkPassBase64,
  });

  if (!existingPass.result) {
    await CapacitorNFCPassWallet.savePassToWallet({ iosPkPassBase64 });
  }
}

if (platform === "android") {
  await CapacitorNFCPassWallet.savePassToWallet({
    googlePayJwt,
    saveToGooglePayUrl,
    androidPassJwt,
  });
}
```

## Platform Notes

- iOS availability is based on whether the app can present the Apple Wallet add flow
- iOS `savePassToWallet()` presents the native Apple Wallet UI
- Android `savePassToWallet()` launches the Google Wallet add flow
- Android `readPassFromWallet()` is not supported by Google Wallet APIs

## Errors

The plugin can reject with these error codes:

- `UNAVAILABLE`
- `INVALID_PAYLOAD`
- `NOT_SUPPORTED`
- `USER_CANCELED`
- `NATIVE_ERROR`

## Development

For monorepo-level build, validation, and release instructions, see the [repository README](../../README.md).

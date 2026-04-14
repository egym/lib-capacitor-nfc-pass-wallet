# @egym/capacitor-nfc-pass-wallet

Capacitor plugin for EGYM NFC pass wallet integration on iOS and Android.

This package bundles its native implementations, so partner apps do not need separate iOS or Android wrapper libraries for the wallet flows exposed here.

## Installation

### Option 1: Install from npm

```bash
npm install @egym/capacitor-nfc-pass-wallet
npx cap sync
```

### Option 2: Vendor via git submodule

If your host projects do not use npm, `npx`, or the Capacitor CLI, you can vendor this repository into your app and wire the native package directly.

Add the plugin repository as a submodule:

```bash
git submodule add https://github.com/egym/lib-capacitor-nfc-pass-wallet.git vendor/lib-capacitor-nfc-pass-wallet
git submodule update --init --recursive
```

Then integrate the native package from the checked-out submodule.

For iOS with CocoaPods, add the local pod in your `Podfile`:

```ruby
pod 'CapacitorNFCPassWallet', :path => '../vendor/lib-capacitor-nfc-pass-wallet'
```

If you prefer Swift Package Manager, add `vendor/lib-capacitor-nfc-pass-wallet` as a local package in Xcode and link the `EgymCapacitorNfcPassWallet` product.

For Android, include the local Gradle module from the submodule checkout.

In `settings.gradle`:

```groovy
include ':capacitor-nfc-pass-wallet'
project(':capacitor-nfc-pass-wallet').projectDir = new File(settingsDir, '../vendor/lib-capacitor-nfc-pass-wallet/android')
```

In your app module `build.gradle`:

```groovy
dependencies {
		implementation project(':capacitor-nfc-pass-wallet')
}
```

Adjust the relative paths to match your repository layout.

When updating the plugin later, pull the new submodule revision first, then rerun your normal native dependency refresh steps such as `pod install` or Gradle sync.

## Import

If your app consumes the plugin through a JavaScript package dependency, import it from the package name:

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

### Local Build

```bash
npm install
npm run build
npm run build:android
npm run build:ios
```

### Local Android Toolchain via `devenv`

To avoid relying on a system-wide Android SDK, this repo supports a project-local Android toolchain via `devenv`.

```bash
devenv shell
cd android
gradle assemble
gradle test
```

- `devenv` provisions Java and the Android SDK for this project
- `ANDROID_HOME` and `ANDROID_SDK_ROOT` are set in the shell
- The Android implementation lives in `android`

### Local iOS Validation

The iOS implementation is distributed through the root podspec.

```bash
pod lib lint CapacitorNFCPassWallet.podspec --allow-warnings
```

### Release Automation

GitHub Actions workflows in `.github/workflows` cover:

- GitHub release and tag creation via `release-github.yml`
- npm publication via `publish-npm.yml`

Release PR preparation is maintainer-driven via `npm run release:prepare`.

### Publish a New Version

This repository uses Changesets for versioning.

1. Create a changeset:

```bash
npx changeset
```

2. Commit the generated `.changeset/*.md` file together with your code changes.
3. Merge the change into `main`.
4. Run `npm run release:prepare` from a clean checkout.
5. Merge the release PR.
6. Optionally run `release-github.yml` to create the Git tag and GitHub Release.
7. Run `publish-npm.yml`.

The release prep command resets `chore/release-package` from `origin/main`, applies pending changesets, force-pushes the branch, and creates the release PR with `gh` when available. If `gh` is not installed, it prints the exact PR command to run manually.

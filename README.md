# EGYM RMWA NFC Wallet Plugins

This repository contains the source for the supported NFC wallet plugin deliverables:

- Capacitor plugin (npm)
- Flutter plugin (pub.dev)

## Capacitor Plugin for Partners

Partners integrating an EGYM RMWA should install the published Capacitor plugin package:

```bash
npm install @egym/capacitor-nfc-pass-wallet
npx cap sync
```

The Capacitor plugin bundles its Android and iOS native implementations, so partner apps do not need to add separate wallet SDK wrappers for this integration.

### Import

```ts
import { CapacitorNFCPassWallet } from "@egym/capacitor-nfc-pass-wallet";
```

### API

The published Capacitor plugin exposes three methods:

- `savePassToWallet`
- `readPassFromWallet`
- `isWalletAvailable`

The `.result` property used in the examples comes from the plugin's TypeScript contract. Both `isWalletAvailable()` and `readPassFromWallet()` resolve to objects with a boolean `result` field rather than returning a bare boolean.

```ts
type WalletAvailabilityResult = {
  result: boolean;
};

type ReadPassFromWalletResult = {
  result: boolean;
};
```

That is why the examples use `availability.result` and `passState.result`.

#### `isWalletAvailable`

Use this before showing wallet actions in the UI.

```ts
const availability = await CapacitorNFCPassWallet.isWalletAvailable();

if (availability.result) {
  // show wallet CTA
}
```

#### `savePassToWallet`

On iOS, pass `iosPkPassBase64` with the Base64-encoded `.pkpass` payload.

```ts
await CapacitorNFCPassWallet.savePassToWallet({
  iosPkPassBase64,
});
```

On Android, prefer `googlePayJwt` when available. `saveToGooglePayUrl` is also supported, and `androidPassJwt` is kept temporarily for backward compatibility.

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

#### `readPassFromWallet`

This is supported on iOS only and returns whether the pass is already present in Apple Wallet.

```ts
const passState = await CapacitorNFCPassWallet.readPassFromWallet({
  iosPkPassBase64,
});

if (passState.result) {
  // pass already exists in Apple Wallet
}
```

On Android, `readPassFromWallet` is not supported by Google Wallet APIs and will reject with `NOT_SUPPORTED`.

### Typical Integration Flow

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

### Platform Notes

- iOS availability is based on whether the app can present the Add to Wallet flow.
- iOS `savePassToWallet` presents the native Apple Wallet UI.
- Android `savePassToWallet` launches the Google Wallet add flow.
- Android `readPassFromWallet` is intentionally unsupported.

## Packages

- `packages/capacitor` Capacitor plugin for RMWAs, including bundled Android and iOS native implementations
- `packages/flutter` Flutter plugin with its own Android and iOS native implementations

## Scope for current phase

- Included now: Capacitor plugin, Flutter plugin, and release automation.
- Deferred: end-to-end sample apps/integration demos (to be added in a later phase).

## Monorepo Development

The sections below are for maintaining and publishing this repository itself.

### Local Build

```bash
npm install
npm run build
npm run build:android
npm run build:ios
npm run build:flutter
```

### Local Android Toolchain via devenv

To avoid using a system-wide Android SDK, this repo supports a project-local SDK/toolchain via `devenv`.

```bash
devenv shell
cd packages/capacitor/android
gradle assemble
gradle test
```

- `devenv` provisions Java + Android SDK for this project.
- `ANDROID_HOME` / `ANDROID_SDK_ROOT` are set in the shell.
- The Capacitor plugin's Android implementation lives in `packages/capacitor/android`.

### Local iOS Validation

The Capacitor plugin's iOS implementation is distributed through the plugin podspec.

```bash
cd packages/capacitor
pod lib lint CapacitorNFCPassWallet.podspec --allow-warnings
```

### Release Automation

GitHub Actions workflows are defined in `.github/workflows` for CI and per-ecosystem publishing:

- npm publish (`publish-npm.yml`)
- Flutter publish (`publish-flutter.yml`)

Required secrets are documented in `docs/RELEASE_SECRETS.md`.

### Publish a New Version

This repository uses Changesets for versioning.

1. Create a changeset for your change.

```bash
npx changeset
```

2. Commit the generated changeset file together with your code changes.
3. Merge the change into `main`.
4. The `changesets.yml` workflow will open or update a release PR with the version bumps.
5. Merge that release PR.
6. Trigger the publish workflow you need from GitHub Actions.

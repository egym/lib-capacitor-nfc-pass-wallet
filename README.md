# EGYM RMWA NFC SDK Monorepo

This repository contains the source for all NFC wallet integration SDKs/plugins:

- Web/Capacitor plugin (npm)
- Android SDK (Maven Central)
- iOS SDK (SPM + CocoaPods)
- Flutter plugin (pub.dev)

## Packages

- `packages/capacitor-nfc-pass-wallet` Capacitor plugin for RMWAs
- `packages/android` Android native SDK (`AAR`)
- `packages/ios` iOS native SDK (`Swift Package` + Podspec)
- `packages/flutter` Flutter plugin wrapper

## Scope for current phase

- Included now: shared contract, Capacitor plugin, Android SDK, iOS SDK, Flutter plugin, and release automation.
- Deferred: end-to-end sample apps/integration demos (to be added in a later phase).

## API Surface

All wrappers align on:

- `savePassToWallet`
- `readPassFromWallet` (iOS only; Android returns `NOT_SUPPORTED`)
- `isWalletAvailable`

## Local Build

```bash
npm install
npm run build
npm run build:android
npm run build:ios
npm run build:flutter
```

## Local Android SDK via devenv

To avoid using a system-wide Android SDK, this repo supports a project-local SDK/toolchain via `devenv`.

```bash
devenv shell
gw assemble
gw test
```

- `devenv` provisions Java + Android SDK for this project.
- `ANDROID_HOME` / `ANDROID_SDK_ROOT` are set in the shell.
- The `gw` helper runs Gradle from `packages/android`.

## Release Automation

GitHub Actions workflows are defined in `.github/workflows` for CI and per-ecosystem publishing:

- npm publish (`publish-npm.yml`)
- Android publish (`publish-android.yml`)
- iOS publish (`publish-ios.yml`)
- Flutter publish (`publish-flutter.yml`)

Required secrets are documented in `docs/RELEASE_SECRETS.md`.

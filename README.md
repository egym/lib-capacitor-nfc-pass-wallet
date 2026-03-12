# EGYM RMWA NFC Wallet Plugins

This repository contains the source for the supported NFC wallet plugin deliverables:

- Capacitor plugin (npm)
- Flutter plugin (pub.dev)

## Packages

- `packages/capacitor` Capacitor plugin for RMWAs, including bundled Android and iOS native implementations
- `packages/flutter` Flutter plugin with its own Android and iOS native implementations

## Scope for current phase

- Included now: Capacitor plugin, Flutter plugin, and release automation.
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

## Local Android Toolchain via devenv

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

## Local iOS Validation

The Capacitor plugin's iOS implementation is distributed through the plugin podspec.

```bash
cd packages/capacitor
pod lib lint CapacitorNFCPassWallet.podspec --allow-warnings
```

## Release Automation

GitHub Actions workflows are defined in `.github/workflows` for CI and per-ecosystem publishing:

- npm publish (`publish-npm.yml`)
- Flutter publish (`publish-flutter.yml`)

Required secrets are documented in `docs/RELEASE_SECRETS.md`.

# EGYM NFC Pass Wallet Plugins

This repository contains the source for EGYM's NFC wallet plugin packages.

## Packages

Use the package-level README that matches your app stack:

| Package | Ecosystem | README |
| --- | --- | --- |
| `@egym/capacitor-nfc-pass-wallet` | Capacitor / Ionic | [`packages/capacitor/README.md`](packages/capacitor/README.md) |
| `egym_nfc_pass_wallet` | Flutter | [`packages/flutter/README.md`](packages/flutter/README.md) |

## Repository Layout

- `packages/capacitor`: publishable Capacitor plugin with bundled Android and iOS implementations
- `packages/flutter`: publishable Flutter plugin with Android and iOS implementations

The repository root is a private workspace used for shared tooling and release automation. Consumer installation and API usage live in the package READMEs above.

## For Package Consumers

- Capacitor apps should start with [`packages/capacitor/README.md`](packages/capacitor/README.md)
- Flutter apps should start with [`packages/flutter/README.md`](packages/flutter/README.md)

## For Maintainers

### Local Build

```bash
npm install
npm run build
npm run build:android
npm run build:ios
npm run build:flutter
```

### Local Android Toolchain via `devenv`

To avoid relying on a system-wide Android SDK, this repo supports a project-local Android toolchain via `devenv`.

```bash
devenv shell
cd packages/capacitor/android
gradle assemble
gradle test
```

- `devenv` provisions Java and the Android SDK for this project
- `ANDROID_HOME` and `ANDROID_SDK_ROOT` are set in the shell
- The Capacitor Android implementation lives in `packages/capacitor/android`

### Local iOS Validation

The Capacitor plugin's iOS implementation is distributed through the podspec in `packages/capacitor`.

```bash
cd packages/capacitor
pod lib lint CapacitorNFCPassWallet.podspec --allow-warnings
```

### Release Automation

GitHub Actions workflows in `.github/workflows` cover:

- changeset release PR generation via `changesets.yml`
- GitHub release and tag creation for Capacitor via `release-github.yml`
- npm publication via `publish-npm.yml`
- Flutter publication via `publish-flutter.yml`

Required secrets are documented in `docs/RELEASE_SECRETS.md`.

### Publish a New Version

This repository uses Changesets for versioning.

1. Create a changeset:

```bash
npx changeset
```

2. Commit the generated `.changeset/*.md` file together with your code changes.
3. Merge the change into `main`.
4. Let `changesets.yml` apply pending changesets and open or refresh the `chore: release packages` PR.
5. Merge the release PR.
6. Optionally run `release-github.yml` to create the Capacitor Git tag and GitHub Release.
7. Run `publish-npm.yml` and/or `publish-flutter.yml` for the ecosystem you want to publish.

The release PR is generated from `chore/release-packages` and reused for subsequent pending releases instead of opening a new PR each time.

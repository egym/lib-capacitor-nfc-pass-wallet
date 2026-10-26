# @egym/capacitor-nfc-pass-wallet

## 0.4.2

### Patch Changes

- cbdb6db: Fix BMACG-605: open existing iOS passes in Apple Wallet instead of presenting the add sheet, with an installed-pass URL fallback and explicit navigation errors. Preserve the add flow for missing passes.

## 0.4.1

### Patch Changes

- f3c6552: Use the optimized default ProGuard configuration so Android host projects can configure the plugin with AGP 9, while retaining AGP 8 and Capacitor 7/8 compatibility. Release minification remains disabled.

## 0.4.0

### Minor Changes

- 5a3f0ad: Support Capacitor 7 and 8 consistently across npm, Android, CocoaPods, and Swift Package Manager, and harden dependency and release reproducibility.

## 0.3.1

### Patch Changes

- 9aff3fc: Name fix

## 0.3.0

### Minor Changes

- Proper iOS packaging

## 0.2.1

### Patch Changes

- Split the repository documentation into repo-level and package-level READMEs so npm consumers get focused install and API guidance from the published package.

## 0.2.0

### Minor Changes

- Updated types

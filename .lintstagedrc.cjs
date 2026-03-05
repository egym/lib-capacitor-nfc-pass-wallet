const runAndroidLint =
  "sh -c 'if command -v devenv >/dev/null 2>&1; then devenv shell -- gw lint; else cd packages/android-sdk && gradle lint; fi'";

module.exports = {
  "{package.json,package-lock.json,.lintstagedrc.cjs}": () => "npm run lint:ts",
  ".github/workflows/*.{yml,yaml}": () => "npm run lint:ts",
  "packages/{contracts,capacitor-nfc-pass-wallet}/**/*.{ts,tsx,js,mjs,cjs,json}":
    () => "npm run lint:ts",
  "packages/android-sdk/**/*.{kt,kts,java,xml,gradle}": () =>
    runAndroidLint,
  "{packages/ios-sdk/Package.swift,packages/ios-sdk/EGYMNFCPassWallet.podspec,packages/ios-sdk/Sources/**/*.{swift,m,mm,h},packages/ios-sdk/Tests/**/*.{swift,m,mm,h}}":
    () => "npm run lint:ios",
  "{packages/flutter_nfc_pass_wallet/pubspec.yaml,packages/flutter_nfc_pass_wallet/lib/**/*.dart,packages/flutter_nfc_pass_wallet/test/**/*.dart,packages/flutter_nfc_pass_wallet/android/src/**/*.{kt,java},packages/flutter_nfc_pass_wallet/ios/Classes/**/*.swift}":
    () => "npm run lint:flutter",
};

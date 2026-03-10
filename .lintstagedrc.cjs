const runAndroidLint =
  "sh -c 'if command -v devenv >/dev/null 2>&1; then devenv shell -- gw lint; else cd packages/android && gradle lint; fi'";

module.exports = {
  "{package.json,package-lock.json,.lintstagedrc.cjs}": () => "npm run lint:ts",
  ".github/workflows/*.{yml,yaml}": () => "npm run lint:ts",
  "packages/{capacitor-nfc-pass-wallet}/**/*.{ts,tsx,js,mjs,cjs,json}": () =>
    "npm run lint:ts",
  "packages/android/**/*.{kt,kts,java,xml,gradle}": () => runAndroidLint,
  "{packages/ios/Package.swift,packages/ios/EGYMNFCPassWallet.podspec,packages/ios/Sources/**/*.{swift,m,mm,h},packages/ios/Tests/**/*.{swift,m,mm,h}}":
    () => "npm run lint:ios",
  "{packages/flutter/pubspec.yaml,packages/flutter/lib/**/*.dart,packages/flutter/test/**/*.dart,packages/flutter/android/src/**/*.{kt,java},packages/flutter/ios/Classes/**/*.swift}":
    () => "npm run lint:flutter",
};

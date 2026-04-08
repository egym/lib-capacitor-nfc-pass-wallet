const runAndroidLint =
  "sh -c 'if command -v devenv >/dev/null 2>&1; then devenv shell -- sh -c \"cd android && gradle lint\"; else cd android && gradle lint; fi'";

module.exports = {
  "{package.json,package-lock.json,tsconfig.json,.lintstagedrc.cjs}": () => "npm run lint:ts",
  ".github/workflows/*.{yml,yaml}": () => "npm run lint:ts",
  "src/**/*.{ts,tsx,js,mjs,cjs,json}": () => "npm run lint:ts",
  "android/**/*.{kt,kts,java,xml,gradle}": () => runAndroidLint,
  "{CapacitorNFCPassWallet.podspec,ios/Sources/**/*.{swift,m,mm,h}}":
    () => "npm run lint:ios",
};

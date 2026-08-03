#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 || ! "$1" =~ ^(7|8)\.[0-9]+\.[0-9]+$ ]]; then
  echo "Usage: $0 <Capacitor 7.x or 8.x version>" >&2
  exit 1
fi

capacitor_version="$1"
repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work_directory="$(mktemp -d)"

cleanup() {
  rm -rf "$work_directory"
}
trap cleanup EXIT

cp -R "$repository_root/ios" "$work_directory/ios"
sed \
  "s#\"7.0.0\"..<\"9.0.0\"#exact: \"$capacitor_version\"#" \
  "$repository_root/Package.swift" > "$work_directory/Package.swift"

if ! grep -q "exact: \"$capacitor_version\"" "$work_directory/Package.swift"; then
  echo "Failed to pin Capacitor $capacitor_version in the temporary package manifest." >&2
  exit 1
fi

cd "$work_directory"
xcodebuild \
  -scheme EgymCapacitorNfcPassWallet \
  -destination generic/platform=iOS \
  -derivedDataPath "$work_directory/DerivedData" \
  -clonedSourcePackagesDirPath "$work_directory/SourcePackages" \
  CODE_SIGNING_ALLOWED=NO \
  build

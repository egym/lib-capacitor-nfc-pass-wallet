# Release Secrets

## npm (public)

- `NPM_TOKEN`

## Maven Central (Android)

- `MAVEN_CENTRAL_USERNAME`
- `MAVEN_CENTRAL_PASSWORD`
- `MAVEN_GPG_PRIVATE_KEY`
- `MAVEN_GPG_PASSPHRASE`

## iOS (SPM + CocoaPods)

- `COCOAPODS_TRUNK_TOKEN`

SPM distribution is tag/release based and does not require package upload credentials.

## pub.dev (Flutter)

- `PUB_DEV_PUBLISH_ACCESS_TOKEN`
- `PUB_DEV_PUBLISH_REFRESH_TOKEN`
- `PUB_DEV_PUBLISH_TOKEN_ENDPOINT`
- `PUB_DEV_PUBLISH_EXPIRATION`

## Optional hardening

- `GH_PAT_RELEASE` (if using GitHub release APIs beyond default `GITHUB_TOKEN`)

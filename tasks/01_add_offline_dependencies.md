# Add Offline Support Dependencies

## Context
- files: @pubspec.yaml
- The project currently uses `isar: ^3.1.0+1` for Printer & Unit models only. No connectivity detection, background sync, or crypto dependencies exist. The offline-first architecture requires new packages for network detection, password hashing, and background task scheduling.

## Goals
- Add `connectivity_plus: ^6.0.0` for network state detection
- Add `crypto: ^3.0.3` for SHA-256 offline password hashing
- Add `workmanager: ^0.5.2` for background sync scheduling
- Run `flutter pub get` successfully with all new dependencies

## Notes
- These are foundational dependencies needed before any offline feature can be built
- `connectivity_plus` will be used by `ConnectivityService` to detect network changes
- `crypto` will be used by `OfflineUser` model for password hashing
- `workmanager` will be used by `BackgroundSyncService` for periodic transaction sync
- The existing `isar` and `isar_flutter_libs` packages are already present and compatible
- `isar_generator` and `build_runner` are already in dev_dependencies

## Tools / Skills
- Flutter dependency management

## Implementation
- Added `connectivity_plus: ^6.0.0`, `crypto: ^3.0.3`, `workmanager: ^0.5.2` to `pubspec.yaml` dependencies
- Ran `flutter pub get` — resolved successfully (connectivity_plus 6.1.5, crypto 3.0.6, workmanager 0.5.2)
- Fixed build failure: `workmanager 0.5.2` is incompatible with Flutter 3.41.7 (uses removed `shim`/`PluginRegistrantCallback` APIs). Updated to `workmanager: ^0.9.0` (resolves to 0.9.0+3)
- Bumped `compileSdk` from 35 to 36 in `android/app/build.gradle` to satisfy plugins requiring SDK 36
- `flutter build apk --debug` succeeds
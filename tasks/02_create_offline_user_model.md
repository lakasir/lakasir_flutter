# Create OfflineUser Isar Model

## Context
- files: @lib/offline/models/offline_user_model.dart (new), @lib/models/lakasir_database.dart
- Currently there is no `OfflineUser` model. Authentication is entirely server-based via tokens stored in SharedPreferences. The offline-first design needs a local user model that stores credentials with SHA-256 hashed passwords so users can register and login without network connectivity.

## Goals
- Create `lib/offline/models/offline_user_model.dart` with the `OfflineUser` Isar collection
- Fields: `id` (auto-increment), `name`, `email`, `hashedPassword`, `salt`, `shopName`, `businessType`, `domain` (nullable), `isOfflineUser` (default true), `createdAt`, `lastSyncAt` (nullable)
- Implement `static String hashPassword(String password, String salt)` using SHA-256 from `crypto` package
- Implement `static String generateSalt()` using timestamp + random int
- Implement `bool verifyPassword(String password)` instance method
- Include `part 'offline_user_model.g.dart';` annotation
- Run `dart run build_runner build` to generate the `.g.dart` file

## Notes
- The `crypto` package must already be added to `pubspec.yaml` (see task 01)
- Use `Isar.autoIncrement` for the `id` field
- The `hashedPassword` must NEVER store plain text — always use `hashPassword()`
- `generateSalt()` uses `DateTime.now().microsecondsSinceEpoch` + `Random().nextInt(999999)` for simplicity (not cryptographic, but sufficient for local POS auth)
- `domain` remains `null` until the user connects to a server
- `isOfflineUser = true` distinguishes locally-created users from server-synced users

## Tools / Skills
- Dart Isar model creation, `crypto` package SHA-256

## Implementation
<!-- Write you've done in here -->
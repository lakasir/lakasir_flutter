# Create OfflineUserService

## Context
- files: @lib/offline/services/offline_user_service.dart (new), @lib/offline/models/offline_user_model.dart
- Currently there is no way to register or authenticate a user locally — all auth goes through the API (`LoginService`). The offline-first flow requires an `OfflineUserService` that can register a new local user (storing hashed password in Isar) and authenticate against that local store.

## Goals
- Create `OfflineUserService` with the following methods:
  - `register({required String name, required String email, required String password, String? shopName, String? businessType})` — creates an `OfflineUser` in Isar with hashed password, stores user ID via `storeOfflineUserId()`
  - `login({required String email, required String password})` — finds user by email in Isar, verifies password with `user.verifyPassword()`, calls `storeOfflineAuth(true)` and `storeOfflineUserId()`
  - `getCurrentUser()` — retrieves the current offline user from Isar using stored ID
  - `logout()` — calls `storeOfflineAuth(false)`
  - `updateDomain(String domain)` — sets the `domain` field on the current offline user (for when they connect to a server later)
- All methods use `LakasirDatabase.isar` for database access

## Notes
- Registration must check for duplicate emails and throw an error if found
- Password hashing uses `OfflineUser.hashPassword(password, salt)` — never store plain text
- `OfflineUser.generateSalt()` is called during registration to generate a unique salt
- `logout()` doesn't delete the user — it just clears the auth flag so they can log in again
- This service does NOT need a service interface yet (that comes in Phase 3 with the repository pattern). It's a standalone service for offline auth.
- `updateDomain()` is needed for the future "connect to server" flow where an offline user links to a domain

## Tools / Skills
- Isar CRUD, SharedPreferences for auth state

## Implementation
- Created `lib/offline/services/offline_user_service.dart`
  - `register()` — checks duplicate emails via Isar `.where().filter().emailEqualTo(email).findAll().firstOrNull`, generates salt, hashes password, stores `OfflineUser` in Isar, calls `storeOfflineAuth(true)` and `storeOfflineUserId(user.id)`
  - `login()` — finds user by email in Isar, verifies password with `user.verifyPassword()`, calls `storeOfflineAuth(true)` and `storeOfflineUserId(user.id)`
  - `getCurrentUser()` — retrieves offline user from Isar using stored `offline_user_id`
  - `logout()` — calls `storeOfflineAuth(false)` (doesn't delete the user)
  - `updateDomain(String domain)` — sets `domain` field on current offline user for future server linking
- Required `import 'package:isar/isar.dart'` for `.where().filter()` query API (Isar 3.x pattern)
- Used `.findAll().firstOrNull` instead of `.findFirst()` (not available in Isar 3.x)
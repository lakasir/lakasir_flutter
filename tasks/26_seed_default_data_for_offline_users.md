# Add Offline Permission & Feature Models, Seeder, and AuthController Integration

## Context
- files: @lib/offline/models/offline_permission_model.dart (new), @lib/offline/models/offline_feature_model.dart (new), @lib/offline/services/offline_permission_service.dart (new), @lib/controllers/auths/auth_controller.dart, @lib/screens/domain/register_offline_user_screen.dart, @lib/models/lakasir_database.dart
- In online mode, `AuthController.fetchPermissions()` loads permissions and features from the server via `ProfileService.get()`. In offline mode, this was skipped entirely, leaving `permissions` and `features` empty. When `MenuScreen` calls `_authController.can(ability: 'read member', feature: 'member')`, `features['member']` returned null, causing a crash. The fix needs offline users to have all permissions and features (admin access).

## Goals
- Create `OfflinePermission` Isar model — simple collection with `name` field storing permission strings like "read selling", "create product"
- Create `OfflineFeature` Isar model — collection with `name` and `enabled` fields storing feature toggles like "member": true, "product-sku": true
- Create `OfflinePermissionService` with:
  - `defaultPermissions` — all permission strings used in the app (27 permissions)
  - `defaultFeatures` — all feature toggles used in the app (8 features, all enabled)
  - `seedDefaultPermissions()` — idempotent, seeds all defaults if table is empty
  - `getPermissions()` — returns list of permission names from Isar
  - `getFeatures()` — returns map of feature name → enabled from Isar
- Update `AuthController.fetchPermissions()`:
  - When offline: load permissions and features from `OfflinePermissionService`
  - On API failure: fall back to `OfflinePermissionService` instead of leaving empty
- Update `RegisterOfflineUserScreen._register()` to call `_seedDefaultPermissions()` after `_seedDefaultPaymentMethods()`
- Register `OfflinePermissionSchema` and `OfflineFeatureSchema` in `LakasirDatabase`

## Notes
- Offline users are always admins — they get ALL permissions and ALL features enabled
- The seeder is idempotent — calling it multiple times won't create duplicates (checks count first)
- All 27 permissions and 8 features were extracted from the codebase by searching for `ability:` and `feature:` usage across all screens

## Implementation
- Created `lib/offline/models/offline_permission_model.dart` — Isar collection with `id` (autoIncrement) and `name` fields
- Created `lib/offline/models/offline_feature_model.dart` — Isar collection with `id` (autoIncrement), `name`, and `enabled` fields
- Ran `dart run build_runner build` to generate `.g.dart` files
- Registered `OfflinePermissionSchema` and `OfflineFeatureSchema` in `LakasirDatabase`
- Created `lib/offline/services/offline_permission_service.dart`:
  - `defaultPermissions`: 27 permission strings matching all `ability:` usages in the app
  - `defaultFeatures`: 8 feature toggles matching all `feature:` usages in the app, all set to `true`
  - `seedDefaultPermissions()`: idempotent — checks count, if >0 returns early, otherwise writes all defaults
  - `getPermissions()`: queries all OfflinePermission records, returns `List<String>` of names
  - `getFeatures()`: queries all OfflineFeature records, returns `Map<String, bool>` of name→enabled
- Updated `AuthController.fetchPermissions()`:
  - Offline mode: loads from OfflinePermissionService instead of skipping
  - API failure: falls back to OfflinePermissionService instead of leaving empty
- Updated `RegisterOfflineUserScreen._register()`: added `_seedDefaultPermissions()` call after `_seedDefaultPaymentMethods()`
- Fixed `AuthController.can()` and `.feature()`: changed `features[feature]!` to `features[feature] ?? false` to prevent null check crashes
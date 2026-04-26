# Seed Default Data for Offline Users

## Context
- files: @lib/offline/services/seed_service.dart (new), @lib/screens/domain/register_offline_user_screen.dart
- When a user registers offline, they start with an empty database. For the POS to be functional immediately, they need default payment methods (Cash, Debit, Credit, E-Wallet) and optionally a default category. These are seeded right after offline registration.

## Goals
- Create `SeedService` with method `seedDefaultData()`:
  - Seeds 4 default payment methods into Isar: Cash (id:1), Debit (id:2), Credit (id:3), E-Wallet (id:4), all with `isLocal=true`
  - Optionally seeds a default "General" category with `isLocal=true`
- Call `SeedService.seedDefaultData()` from the `RegisterOfflineUserScreen` after successful registration (inside the same Isar write transaction as user creation)
- Verify that `PaymentMethodController` loads these seeded methods correctly via `PaymentMethodRepository`

## Notes
- Using fixed IDs (1,2,3,4) for payment methods is safe because these are the first records in a fresh database
- All seeded data has `isLocal=true` so it gets uploaded during initial sync when the user connects to a server
- If the user already has payment methods from a previous session (unlikely for offline-first users, but possible if they reset), skip seeding duplicates
- The default category helps users start adding products immediately without creating categories first
- `SeedService` should be idempotent — calling it multiple times should not create duplicates

## Tools / Skills
- Isar write transactions, seed data patterns

## Implementation
<!-- Write you've done in here -->
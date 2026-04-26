# Initialize New Services in main.dart

## Context
- files: @lib/main.dart
- Currently `main.dart` initializes `LakasirDatabase`, Firebase, and checks auth state. The new offline services need to be initialized and registered as permanent GetX services before the app starts, so they're available to controllers and UI.

## Goals
- In `main()`:
  1. After `LakasirDatabase.initialize()`, register `AppModeService` as permanent GetX service
  2. Register `ConnectivityService` as permanent GetX service (starts listening to network changes)
  3. Register `TransactionQueueService` as permanent GetX service
  4. Call `AppModeService.to.determineMode()` to set initial mode
  5. Call `BackgroundSyncService.initialize()` to set up workmanager
  6. If in online mode, schedule periodic background sync via `BackgroundSyncService.schedulePeriodicSync()`
- Ensure `LakasirDatabase.isar` is initialized before any service that uses it
- The initialization order matters: Isar → AppMode → Connectivity → Queue → Sync

## Notes
- GetX permanent services survive route navigation — they won't be disposed
- `ConnectivityService` starts listening to `connectivity_plus` stream immediately on `onInit()`, which may trigger mode switches — this is intentional
- `TransactionQueueService` loads pending count from Isar in `onInit()` for the UI badge
- `AppModeService.determineMode()` checks for domain + network — if no domain, stays offline
- All service registrations should be in `main()` before `runApp()` and after `LakasirDatabase.initialize()`
- Don't call `SyncService.fullSync()` in `main()` yet — sync should happen after login, not on app start, because auth tokens may not be available yet

## Tools / Skills
- GetX service registration, app initialization flow

## Implementation
<!-- Write you've done in here -->
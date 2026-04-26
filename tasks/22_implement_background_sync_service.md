# Implement BackgroundSyncService (Workmanager)

## Context
- files: @lib/offline/services/background_sync.dart (new), @lib/main.dart
- The `TransactionQueueService` handles sync attempts when the app is active, but we also need background sync when connectivity returns while the app is in the background. `workmanager` provides periodic background task execution on Android/iOS.

## Goals
- Create `BackgroundSyncService` with static methods:
  - `initialize()` → calls `Workmanager().initialize(callbackDispatcher)`
  - `schedulePeriodicSync()` → registers a periodic task every 15 minutes with network and battery constraints
  - `cancelAll()` → cancels all background tasks
- Create the `callbackDispatcher` top-level function:
  - Handles the `syncPendingTransactions` task name
  - Initializes Isar database
  - Calls `TransactionQueueService.to.attemptSync()`
  - Returns `true` on success, `false` on failure
- Register `BackgroundSyncService.initialize()` in `main.dart` before `runApp()`
- Schedule periodic sync when app starts in online mode

## Notes
- The `callbackDispatcher` must be a top-level function (annotated `@pragma('vm:entry-point')`) — it runs in a separate isolate
- Isar must be initialized in the callback dispatcher context before any Isar operations
- The periodic task frequency is 15 minutes minimum (Android WorkManager constraint)
- Network constraint: `NetworkType.connected` ensures tasks only run when there's internet
- Battery constraint: `requiresBatteryNotLow: true` prevents sync when battery is low
- Background sync is only relevant when the user has a domain configured (online mode) — skip scheduling in offline-only mode
- On iOS, background tasks have more restrictions — the periodic task may not run as reliably

## Tools / Skills
- `workmanager` package, Flutter background execution, Isar initialization in isolate

## Implementation
<!-- Write you've done in here -->
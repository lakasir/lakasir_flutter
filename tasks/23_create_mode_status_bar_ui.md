# Create ModeStatusBar & Offline Indicator UI

## Context
- files: @lib/widgets/offline_status_bar.dart (new), @lib/screens/menu_screen.dart, @lib/widgets/layout.dart
- Users need to see at a glance whether the app is online or offline, and how many transactions are pending sync. This info should appear as a persistent banner above the main content.

## Goals
- Create `ModeStatusBar` widget as a `PreferredSizeWidget` that shows:
  - **Offline-only mode** (no domain): blue-grey bar with "Offline Mode" text and offline bolt icon
  - **Online, no pending**: hidden (zero-height)
  - **Online, pending transactions**: orange bar with "Syncing N pending transactions..." and "SYNC NOW" button
  - **Offline (network dropped, domain configured)**: red bar with "No connection" message and pending count if any
- All state is reactive via `Obx`: `ConnectivityService.to.isOnline`, `AppModeService.to.mode`, `TransactionQueueService.to.pendingCount`
- Integrate `ModeStatusBar` above the main content in the app's `Layout` widget or `MenuScreen`
- Ensure the status bar doesn't overlap with the system status bar (use `SafeArea`)

## Notes
- `ModeStatusBar` must be a `PreferredSizeWidget` so it can be used in `Scaffold.appBar` or as a standalone widget
- The widget reads from 3 GetX services: `ConnectivityService`, `AppModeService`, `TransactionQueueService` — all must be initialized before this widget renders
- `TransactionQueueService` must be registered as a permanent GetX service before the UI attempts to use it
- The "SYNC NOW" button calls `TransactionQueueService.to.attemptSync()` directly
- Consider adding the status bar to `Layout` widget so it appears on every screen that uses `Layout`

## Tools / Skills
- Flutter UI, GetX observables, PreferredSizeWidget

## Implementation
<!-- Write you've done in here -->
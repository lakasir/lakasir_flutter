# Create AppModeService & ConnectivityService

## Context
- files: @lib/offline/services/app_mode_service.dart (new), @lib/offline/services/connectivity_service.dart (new)
- The app currently has no concept of "mode" — it's always online and depends on the API. The dual-mode architecture needs an `AppModeService` (GetX controller) that tracks whether the app is in offline or online mode, and a `ConnectivityService` that monitors network changes and triggers mode switches. These are foundational — all repositories will read from `AppModeService`.

## Goals
- Create `AppModeService` as a GetxController:
  - `Rx<AppMode> mode` with `AppMode` enum (offline, online)
  - `bool get isOffline`, `bool get isOnline`
  - `determineMode()` — checks if domain exists and network is available to decide mode
  - `switchToOnline(String domain)` — stores domain, sets mode to online, triggers full sync
  - `switchToOffline()` — sets mode to offline (called when network drops)
  - `switchToOnline()` (no args) — sets mode to online and attempts sync (called when network returns)
  - Register as a permanent GetX service with `Get.put(AppModeService(), permanent: true)`

- Create `ConnectivityService` as a GetxController:
  - `RxBool isOnline` observable tracking current connectivity
  - Subscribe to `connectivity_plus` stream in `onInit()`
  - `_updateConnectionStatus()` — called on every connectivity change, auto-switches `AppModeService` mode
  - `checkConnection()` — one-shot connectivity check returning bool
  - When going offline and `AppModeService.isOnline` → call `AppModeService.to.switchToOffline()`
  - When coming online and `AppModeService.isOffline` and `hasDomain()` → call `AppModeService.to.switchToOnline()`
  - Register as a permanent GetX service with `Get.put(ConnectivityService(), permanent: true)`

## Notes
- `AppModeService` is the single source of truth for the app's mode — all repositories read `AppModeService.to.isOnline/isOffline` to decide which service implementation to call
- `ConnectivityService` needs `connectivity_plus` package (task 01)
- Both services must be `permanent: true` in GetX so they survive route changes
- The connectivity stream fires `ConnectivityResult.none` when offline — this should set `isOnline = false`
- `determineMode()` should be called after login to set the initial mode
- Don't call `SyncService` yet — it doesn't exist. Just leave sync calls as TODOs/comments for now. Those will be wired in Phase 4.

## Tools / Skills
- GetX state management, `connectivity_plus` package

## Implementation
<!-- Write you've done in here -->
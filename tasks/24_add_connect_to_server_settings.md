# Add Connect to Server Settings & Mode Switching UI

## Context
- files: @lib/screens/setting/menus/system.dart (modify), @lib/screens/setting/connect_server_screen.dart (new)
- Currently the system settings menu has no "Connect to Server" option. Offline users need a way to upgrade to online mode by entering their domain. This triggers the `InitialSyncService.performInitialSync()` flow.

## Goals
- Add a "Connect to Server" `ListTile` to the system settings menu (`lib/screens/setting/menus/system.dart`) that is only visible when `isOfflineMode()` returns true
- Create `ConnectServerScreen` — a form similar to `SetupScreen` where the user enters their domain
- On submit: validate domain (try API call), then show a loading/syncing dialog, call `InitialSyncService.performInitialSync()`, then switch to online mode
- Add route `/settings/connect-server` to `main.dart`
- The "Connect to Server" tile should show: cloud icon (orange), title "Connect to Server", subtitle explaining this will sync local data to the server

## Notes
- The `ConnectServerScreen` follows the same pattern as `SetupScreen` — domain input, validate, set up
- After domain validation succeeds, the full initial sync happens: upload local data → remap IDs → download server data → switch to online
- The sync dialog should be non-dismissible (user must wait for sync to complete)
- Error handling: if domain validation fails, show error message. If sync fails mid-way, the user remains in offline mode.
- This screen should also handle authentication against the server — the user needs to log in to the server after connecting their domain (similar to existing login flow but with the new domain)

## Tools / Skills
- Flutter UI, GetX navigation, InitialSyncService, AppModeService

## Implementation
<!-- Write you've done in here -->
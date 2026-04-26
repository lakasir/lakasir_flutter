# Implement SyncService & InitialSyncService

## Context
- files: @lib/offline/services/sync_service.dart (new), @lib/offline/services/initial_sync_service.dart (new)
- Sync is needed in two scenarios: (1) ongoing delta sync when the app is online (fetch server changes, push local changes), and (2) initial sync when an offline user first connects to a server. The `SyncService` handles periodic data synchronization, and `InitialSyncService` handles the one-time data upload when transitioning from offline-only to online mode.

## Goals
- Create `SyncService` as a GetxController (permanent):
  - `fullSync()` → downloads all data (products, categories, members, payment methods) from server and caches to Isar
  - `deltaSync(String entity)` → uses `SyncMetadata.lastSyncAt` to fetch only records updated since last sync
  - `saveLastSyncTime(String entity, DateTime time)` → updates `SyncMetadata` for the entity
  - `getNextSyncTime(String entity)` → returns `SyncMetadata.lastSyncAt` for the entity
  - After sync, updates `SyncMetadata` records with counts and status
- Create `InitialSyncService`:
  - `performInitialSync()` → uploads all local data to server in order:
    1. Upload categories (`isLocal=true`) → remap local IDs to server IDs
    2. Upload products (`isLocal=true`) → remap IDs and update `categoryId` references
    3. Upload members (`isLocal=true`) → remap IDs
    4. Upload pending transactions → let `TransactionQueueService` handle this
    5. Download all server data (full sync)
    6. Switch to online mode via `AppModeService`
  - For each upload: delete old local record, save with server-assigned ID and `isLocal=false`
  - Update foreign key references (e.g., `categoryId` on products) after category ID remapping

## Notes
- ID remapping is the tricky part: when a category with local ID -1 is uploaded, the server assigns ID 42. We must delete the old record and save the new one with ID 42, then update all products referencing category -1 to use category 42.
- `InitialSyncService.performInitialSync()` should be called from the "Connect to Server" settings flow
- `SyncService.fullSync()` is called after initial sync, and also on app start when online
- Delta sync uses `updated_after` query parameter with the server API — if the API doesn't support this, fall back to full sync for that entity
- `SyncService` should be registered as a permanent GetX service and initialized after `AppModeService` and `ConnectivityService`

## Tools / Skills
- Isar CRUD, API data fetching, ID remapping, GetxController

## Implementation
<!-- Write you've done in here -->
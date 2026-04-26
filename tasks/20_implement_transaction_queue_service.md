# Implement TransactionQueueService

## Context
- files: @lib/offline/services/transaction_queue_service.dart (new), @lib/offline/services/offline_receipt_service.dart (new)
- When the app is offline or the API is unreachable, transactions must be stored locally and queued for later sync. The `TransactionQueueService` manages pending transactions in Isar, attempts sync when online, handles retries, and tracks the pending count for UI display.

## Goals
- Create `OfflineReceiptService` with `static Future<String> generateReceiptNumber()` — generates `OFF-YYYYMMDD-XXXX` format receipt numbers using the count of today's transactions in Isar
- Create `TransactionQueueService` as a GetxController (permanent):
  - `queueTransaction(PaymentRequest request)` → creates `OfflinePendingTransaction`, generates receipt number, saves to Isar, updates `pendingCount`
  - `attemptSync()` → queries all unsynced transactions with `retryCount < 3`, tries to send each to API via `PaymentSerivce`, marks as synced on success or increments retry count on failure
  - `getFailedTransactions()` → returns transactions with `retryCount >= 3` for UI display
  - `clearSyncedTransactions()` → deletes synced transactions from Isar
  - `pendingCount` observable for UI badge
  - Automatically calls `attemptSync()` after queueing if connectivity is available
- Register in GetX as permanent service

## Notes
- `TransactionQueueService` depends on `ConnectivityService` to check if API calls are possible
- `attemptSync()` should be called by `ConnectivityService` when network returns, and by `BackgroundSyncService` (task 22)
- Max retry count is 3 — after 3 failures, the transaction is marked as permanently failed and shown in the UI for manual retry
- `itemsJson` is deserialized into `List<PaymentRequestItem>` before sending to API
- The `serverTransactionId` field stores the actual server ID once synced, for reference
- `TransactionQueueService.pendingCount` drives the sync status bar UI (task 23)

## Tools / Skills
- Isar CRUD, GetxController, connectivity_plus, PaymentRequest serialization

## Implementation
<!-- Write you've done in here -->
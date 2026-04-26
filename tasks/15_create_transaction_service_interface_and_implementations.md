# Create Transaction Service Interface & Implementations

## Context
- files: @lib/offline/services/transaction_service_interface.dart (new), @lib/offline/services/offline_transaction_service.dart (new), @lib/offline/services/online_transaction_service.dart (new), @lib/offline/repositories/transaction_repository.dart (new), @lib/services/payment_service.dart, @lib/controllers/transactions/payment_controller.dart
- Transactions are the most critical part of the POS. Currently `PaymentController.store()` calls `PaymentSerivce.store()` directly to send a `PaymentRequest` to the API. In offline mode, transactions must be stored locally as `OfflinePendingTransaction` with a generated receipt number, and queued for sync.

## Goals
- Create `TransactionServiceInterface` with methods: `store(PaymentRequest request)`, `getHistory()`, `getById(int id)`
- Create `OfflineTransactionService implements TransactionServiceInterface`:
  - `store()` → converts `PaymentRequest` to `OfflinePendingTransaction`, generates offline receipt number (`OFF-YYYYMMDD-XXXX`), saves to Isar, returns a mock response
  - `getHistory()` → returns all transactions from Isar (both synced and pending)
  - `getById()` → returns single transaction from Isar
- Create `OnlineTransactionService implements TransactionServiceInterface`:
  - `store()` → tries API call, on success also saves to Isar as synced; on failure or offline, queues as pending transaction
  - `getHistory()` → fetches from API, caches to Isar, returns from cache
  - `getById()` → returns from Isar cache
- Create `TransactionRepository` that delegates based on mode

## Notes
- The `OfflineTransactionService.store()` method generates a receipt number using `OfflineReceiptService.generateReceiptNumber()` (pattern: `OFF-YYYYMMDD-XXXX`)
- The `PaymentRequest` items need to be serialized to `itemsJson` (JSON string) because `OfflinePendingTransaction` stores items as a flat string
- The return type of `store()` should be something the UI can use — either `TransactionHistoryResponse` (online) or a local equivalent (offline). Since `PaymentController` navigates after payment, we need a success indicator.
- In offline mode, there's no server receipt number — use the `offlineReceiptNumber` instead
- The offline `getHistory()` method needs to return both synced transactions (from server, cached locally) and pending (unsynced) transactions

## Tools / Skills
- Isar CRUD, JSON serialization, receipt number generation

## Implementation
- Created `lib/offline/services/transaction_service_interface.dart`
  - Abstract class with: `store(PaymentRequest request)`, `getHistory()`, `getById(int id)`
  - `store` returns `Future<OfflinePendingTransaction>`, `getHistory` returns `Future<List<OfflinePendingTransaction>>`
- Created `lib/offline/services/offline_receipt_service.dart`
  - Static `generateReceiptNumber()` method: counts today's pending transactions, generates `OFF-YYYYMMDD-XXXX` pattern
  - Uses `.where().filter().createdAtGreaterThan(startOfDay).count()` to count today's transactions
- Created `lib/offline/services/offline_transaction_service.dart`
  - `store()`: generates receipt number, serializes PaymentRequest.products to `itemsJson` via `jsonEncode`, creates `OfflinePendingTransaction` with `isSynced=false`
  - `getHistory()`: returns all pending transactions from Isar
  - `getById()`: returns single transaction from Isar
- Created `lib/offline/services/online_transaction_service.dart`
  - Wraps existing `PaymentSerivce` imported `as api` (preserving class name typo)
  - `store()`: tries API call via `_apiService.store(request)`. On success: `isSynced=true`, `serverTransactionId=response.id.toString()`. On failure: `isSynced=false`, generates receipt number.
  - Always persists to Isar regardless of API outcome
- Created `lib/offline/repositories/transaction_repository.dart`
  - Delegates based on `Get.find<AppModeService>().isOnline`
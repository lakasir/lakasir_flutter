# Create Stock Service Interface & Implementations

## Context
- files: @lib/offline/services/stock_service_interface.dart (new), @lib/offline/services/offline_stock_service.dart (new), @lib/offline/services/online_stock_service.dart (new), @lib/offline/repositories/stock_repository.dart (new), @lib/services/product_stock_service.dart
- Stock records are tied to products and managed via `ProductStockService` in the current codebase. In the offline model, `OfflineStock` is a separate Isar collection linked to `OfflineProduct` via `IsarLink`. The stock service needs to handle creating stock entries and updating stock quantities both offline and online.

## Goals
- Create `StockServiceInterface` with methods: `getStocksByProduct(int productId)`, `createStock(OfflineStock stock)`, `updateStock(OfflineStock stock)`
- Create `OfflineStockService implements StockServiceInterface`:
  - Uses Isar to CRUD stocks, linked to products
  - New stocks get `isLocal=true`
- Create `OnlineStockService implements StockServiceInterface`:
  - Wraps `ProductStockService` API, caches to Isar
- Create `StockRepository` that delegates based on mode

## Notes
- `OfflineStock` has an `IsarLink<OfflineProduct>` to its parent product — make sure the link is loaded before accessing with `.loadSync()` or `await .load()`
- Stock updates after a transaction should reduce available quantity — this is handled in the transaction flow, not here
- Stock is created when a product is created or when stock is added manually (stock-in)

## Tools / Skills
- Isar CRUD, IsarLink relationships

## Implementation
<!-- Write you've done in here -->
# Create Product Service Interface, Offline & Online Implementations

## Context
- files: @lib/offline/services/product_service_interface.dart (new), @lib/offline/services/offline_product_service.dart (new), @lib/offline/services/online_product_service.dart (new), @lib/offline/repositories/product_repository.dart (new), @lib/services/product_service.dart, @lib/controllers/products/product_controller.dart
- Currently `ProductController` calls `ProductService` (API) directly. The dual-mode architecture requires a `ProductServiceInterface`, an `OfflineProductService` (Isar CRUD), an `OnlineProductService` (API + Isar cache), and a `ProductRepository` that switches between them based on `AppModeService`.

## Goals
- Create `ProductServiceInterface` abstract class with methods: `getProducts({ProductRequest? request})`, `getProductById(int id)`, `createProduct(OfflineProduct product)`, `updateProduct(OfflineProduct product)`, `deleteProduct(int id)` — all return types use `OfflineProduct` model
- Create `OfflineProductService implements ProductServiceInterface`:
  - `getProducts` → query Isar with filter support (name contains, categoryId equals)
  - `getProductById` → `isar.offlineProducts.get(id)`
  - `createProduct` → assign negative ID (-(count+1)), set `isLocal=true`, write to Isar
  - `updateProduct` → set `isLocal=true`, write to Isar
  - `deleteProduct` → delete from Isar
- Create `OnlineProductService implements ProductServiceInterface`:
  - `getProducts` → fetch from API, cache to Isar, return from Isar cache (fallback to cache on API failure)
  - `getProductById` → return from Isar cache
  - `createProduct` → try API create, on success use server ID and `isLocal=false`; on failure set `isLocal=true` and save locally
  - `updateProduct` → try API update, on success `isLocal=false`; on failure `isLocal=true`
  - `deleteProduct` → try API delete; always delete from Isar locally
- Create `ProductRepository implements ProductServiceInterface`:
  - Delegates to `_offlineService` or `_onlineService` based on `AppModeService.to.isOnline`
  - Exposes the same interface so controllers can swap `ProductService` for `ProductRepository` seamlessly

## Notes
- The `OnlineProductService.getProducts()` must always cache API results to Isar and return from Isar — this ensures offline fallback works
- The `_cacheProducts()` helper method in `OnlineProductService` converts `ProductResponse` → `OfflineProduct` objects
- `ProductRepository` is a simple delegate — no business logic, just mode-based routing
- `OfflineProductService.createProduct` uses negative IDs to mark locally-created items. This convention is important for the initial sync to remap IDs.
- The existing `ProductService` API class is still used by `OnlineProductService` internally — we're NOT deleting it, just wrapping it.

## Tools / Skills
- Isar CRUD, API service wrapping, Repository pattern, GetX AppModeService

## Implementation
<!-- Write you've done in here -->
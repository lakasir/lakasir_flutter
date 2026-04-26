# Create Offline Category & Product Models

## Context
- files: @lib/offline/models/category_model.dart (new), @lib/offline/models/product_model.dart (new), @lib/offline/models/stock_model.dart (new)
- Currently product and category data comes exclusively from the API (`ProductService`, `CategoryService`) and is held in memory via GetX observables. There is no local persistence of product or category data. These models are needed for offline CRUD and caching.

## Goals
- Create `OfflineCategory` Isar collection with fields: `id` (int, server ID or local auto-increment), `name`, `createdAt`, `updatedAt`, `cachedAt`, `isLocal` (bool, marks offline-created items needing sync)
- Create `OfflineProduct` Isar collection with fields: `id` (int), `name`, `type`, `unit`, `image` (nullable), `initialPrice`, `sellingPrice`, `discount`, `discountPrice`, `stock` (nullable int), `categoryId` (nullable int), `sku`, `barcode` (nullable), `isNonStock`, `createdAt`, `updatedAt`, `cachedAt`, `isLocal` (bool)
- Create `OfflineStock` Isar collection with fields: `id` (int), `stock` (nullable int), `initStock` (nullable int), `type` (string, default 'in'), `initialPrice`, `sellingPrice`, `date`, `isLocal` (bool), and an `IsarLink<OfflineProduct>` link
- OfflineProduct should have `@Backlink(to: 'product') final stocks = IsarLinks<OfflineStock>()`
- All models must have `part '*.g.dart'` and run `build_runner`

## Notes
- The `id` field for offline-created items will use negative integers (e.g., -(count+1)) to distinguish from server-assigned positive IDs. This is a convention, not enforced at the model level.
- The `isLocal` field is critical — it marks records created offline that need to be synced when connectivity returns.
- `cachedAt` timestamps are for delta-sync — they tell us when we last fetched this record from the server.
- The `OfflineProduct` model mirrors `ProductResponse` fields but is a flat Isar model (no nested objects like `CategoryResponse` or `StockResponse` — those are separate linked collections).
- The `OfflineStock` model mirrors `StockResponse` and links back to `OfflineProduct` via `IsarLink`.

## Tools / Skills
- Dart Isar model creation, IsarLinks/IsarLink relationships

## Implementation

- Created `lib/offline/models/offline_models.dart` containing all three Isar collections in a single file (required due to isar_generator 3.1.0 crash on cross-file IsarLink/IsarLinks references).
- `OfflineCategory`: `id` (Id/autoIncrement), `name`, `createdAt`, `updatedAt`, `cachedAt` (all DateTime?), `isLocal` (bool).
- `OfflineProduct`: `id` (Id/autoIncrement), `name`, `type`, `unit`, `image` (String?), `initialPrice`, `sellingPrice`, `discount`, `discountPrice` (all double?), `stock` (int?), `categoryId` (int?), `sku` (String), `barcode` (String?), `isNonStock` (bool), `createdAt`, `updatedAt`, `cachedAt` (DateTime?), `isLocal` (bool), `stocks` (IsarLinks<OfflineStock> with @Backlink).
- `OfflineStock`: `id` (Id/autoIncrement), `stock` (int?), `initStock` (int?), `type` (String, default 'in'), `initialPrice`, `sellingPrice` (double?), `date` (String), `isLocal` (bool), `product` (IsarLink<OfflineProduct>).
- Registered `OfflineCategorySchema`, `OfflineProductSchema`, `OfflineStockSchema` in `lib/models/lakasir_database.dart` Isar.open() call.
- Ran `dart run build_runner build --delete-conflicting-outputs` — generated `offline_models.g.dart` successfully.
- `flutter analyze` passes with no issues.

Note: Separate files (category_model.dart, product_model.dart, stock_model.dart) caused isar_generator null-check crash due to analyzer version incompatibility with Dart SDK 3.11.0. Combined into single file as workaround.
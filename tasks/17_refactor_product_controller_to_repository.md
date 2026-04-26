# Refactor ProductController to Use ProductRepository

## Context
- files: @lib/controllers/products/product_controller.dart, @lib/controllers/products/product_add_controller.dart, @lib/controllers/products/product_detail_controller.dart
- Currently `ProductController` directly instantiates and calls `ProductService` (the API service). It stores products as `RxList<ProductResponse>`. The controller needs to be refactored to use `ProductRepository` instead, and work with `OfflineProduct` model in both offline and online modes.

## Goals
- Replace `ProductService _productService = ProductService()` with `ProductRepository _productRepository = ProductRepository()` in `ProductController`
- Change `RxList<ProductResponse> products` to `RxList<OfflineProduct> products`
- Update `getProducts()` to call `_productRepository.getProducts()` — this will automatically use offline or online service based on mode
- Update `searchProduct()` to pass `ProductRequest` filters to the repository
- Update all references to `ProductResponse` fields (they have similar field names, but verify field compatibility)
- Similarly refactor `ProductAddController` and `ProductDetailController` if they directly use `ProductService`
- Ensure the product screens still render correctly — the UI expects `products` to have `id`, `name`, `sellingPrice`, `stock`, `image`, `type`, `isNonStock`, `unit`, `categoryId`, `barcode`, `sku` fields, all of which exist on `OfflineProduct`

## Notes
- This is the HIGH RISK step from the migration guide — every controller that uses `ProductService` changes
- `ProductResponse` has `CategoryResponse? category` and `List<StockResponse>? stocks` as nested objects. `OfflineProduct` has `categoryId` and `IsarLinks<OfflineStock> stocks` instead. The UI may need adjustment if it accesses nested objects directly.
- Screen files that reference `ProductResponse` will need to be updated to reference `OfflineProduct` — this includes `product_screen.dart`, `add_screen.dart`, `edit_screen.dart`, `detail_screen.dart`
- Keep the old `ProductService` API class — it's still used by `OnlineProductService` internally
- The `ProductController.searchProduct()` method currently builds a `ProductRequest` with filter params — the offline service will translate these to Isar queries

## Tools / Skills
- GetX controller refactoring, OfflineProduct model, ProductRepository

## Implementation
<!-- Write you've done in here -->
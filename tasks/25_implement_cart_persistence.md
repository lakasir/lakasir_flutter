# Implement Cart Persistence & Receipt Generation

## Context
- files: @lib/controllers/transactions/cart_controller.dart, @lib/offline/services/cart_persistence_service.dart (new)
- Currently `CartController` holds cart data in-memory via `CartSession` and `CartItem`. If the app is killed or restarted, the cart is lost. For a POS application, this is unacceptable — cashiers need their cart to survive restarts, especially since they may be working offline where they can't quickly re-fetch product data.

## Goals
- Create `CartPersistenceService` that:
  - `saveCart(CartSession cartSession)` → serializes the cart session to Isar `OfflineCart` records (one per cart item)
  - `loadCart()` → reconstructs `CartSession` from Isar, loading product data from `OfflineProduct` cache
  - `clearCart()` → deletes all `OfflineCart` records
  - Automatically called on cart changes (observable or explicit saves)
- Integrate `CartPersistenceService` into `CartController`:
  - Call `saveCart()` after `addToCart()`, `removeQty()`, `addQty()`, `calculateDiscountPrice()`
  - Call `loadCart()` on `onInit()` to restore previous session
  - Call `clearCart()` after successful payment
- Handle the `OfflineProduct? product` transient field — it's loaded from Isar but not persisted

## Notes
- `CartSession` contains: `cartItems` (list of `CartItem`), `totalPrice`, `discountPrice`, `payedMoney`, `member`, `tax`, `paymentMethod`, `note`, `friendPrice`, `customerNumber`
- `OfflineCart` stores: `productId`, `quantity`, `price`, `discountPrice`, `addedAt`
- When loading, use `productId` to look up the product from `OfflineProduct` in Isar and reconstruct `CartItem`
- If a product ID in the cart no longer exists in the local cache (e.g., deleted during offline), skip that item and log a warning
- The `CartSession` has `member` and `paymentMethod` fields — these also need to be persisted (store memberId and paymentMethodId, then look them up on load)
- Consider using a "draft order" table instead of multiple Isar records for better atomicity — but for simplicity, start with `OfflineCart` records

## Tools / Skills
- Isar CRUD, GetX controller lifecycle, cart data serialization

## Implementation
<!-- Write you've done in here -->
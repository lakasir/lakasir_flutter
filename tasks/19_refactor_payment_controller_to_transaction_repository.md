# Refactor PaymentController to Use TransactionRepository

## Context
- files: @lib/controllers/transactions/payment_controller.dart, @lib/controllers/transactions/cart_controller.dart
- Currently `PaymentController.store()` directly calls `PaymentSerivce.store()` with a `PaymentRequest` and navigates to the success screen. In offline mode, transactions must go through `TransactionRepository` which either queues them locally or sends them to the API.

## Goals
- Replace `PaymentSerivce _paymentService = PaymentSerivce()` with `TransactionRepository _transactionRepository = TransactionRepository()`
- Update `PaymentController.store()` to call `_transactionRepository.store(paymentRequest)`
- The return type may differ between offline (local receipt number) and online (server response) — adjust the success flow accordingly
- Update `CartController` to use `ProductRepository` for product lookups if it references `ProductResponse` directly
- Ensure the payment success screen works for both modes — in offline mode, show the offline receipt number; in online mode, show the server receipt

## Notes
- The `PaymentController.procceedThePayment()` method is the critical path — it processes a payment and navigates. This must work in both modes.
- In offline mode, the payment goes to Isar immediately and the user sees a success screen with `OFF-YYYYMMDD-XXXX` receipt number
- In online mode, the payment goes to the API and then Isar (or just API with cache)
- The `CartController` holds `CartSession` with `List<CartItem>` containing `ProductResponse` — this type needs to change to work with `OfflineProduct`
- The cart items reference product data by `product.id` and `product.sellingPrice` — ensure these fields exist on `OfflineProduct`

## Tools / Skills
- GetX controller refactoring, TransactionRepository, CartSession model changes

## Implementation
<!-- Write you've done in here -->
# Refactor CategoryController, MemberController, PaymentMethodController to Use Repositories

## Context
- files: @lib/controllers/category_controller.dart, @lib/controllers/members/member_controller.dart, @lib/controllers/payment_method_controller.dart
- These controllers currently call their respective API services directly. They need to be refactored to use the repository pattern, just like `ProductController` (task 17).

## Goals
- Refactor `CategoryController`:
  - Replace `CategoryService()` with `CategoryRepository()`
  - Change `RxList<CategoryResponse>` to `RxList<OfflineCategory>`
  - Update method calls to go through repository
- Refactor `MemberController` and `MemberAddController`/`MemberUpdateController`:
  - Replace `MemberService()` with `MemberRepository()`
  - Change `RxList<MemberResponse>` to `RxList<OfflineMember>`
  - Update all member CRUD operations
- Refactor `PaymentMethodController`:
  - Replace `PaymentMethodService()` with `PaymentMethodRepository()`
  - Change `RxList<PaymentMethodRespone>` to `RxList<OfflinePaymentMethod>`
  - Update getter to use repository

## Notes
- `CategoryController` currently uses `Get.put(CategoryController())` — ensure the repository is initialized before the controller uses it
- `MemberController` has `memberAddController` and `memberUpdateController` — both need updating
- `PaymentMethodController` is mainly read-only and is used in the payment/cashier flow
- All category, member, and payment method screens need their model references updated from API response types to `Offline*` model types
- The `OfflineCategory` has fields `id`, `name`, `isLocal`, `cachedAt` — the `CategoryResponse` has `id`, `name`, `createdAt`, `updatedAt`. Ensure UI uses compatible fields.
- The `OfflinePaymentMethod` has `isCash`, `isDebit`, `isCredit`, `isWallet` flags — the existing `PaymentMethodRespone` likely has similar fields. Verify compatibility.

## Tools / Skills
- GetX controller refactoring, Repository pattern

## Implementation
<!-- Write you've done in here -->
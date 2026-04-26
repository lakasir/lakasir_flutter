# Create Category, Member, PaymentMethod Service Interfaces & Implementations

## Context
- files: @lib/offline/services/category_service_interface.dart (new), @lib/offline/services/offline_category_service.dart (new), @lib/offline/services/online_category_service.dart (new), @lib/offline/repositories/category_repository.dart (new), same pattern for member and payment_method, @lib/services/category_service.dart, @lib/services/member_service.dart, @lib/services/payment_method_service.dart
- Following the same pattern as the product service (task 13), we need dual-mode services for Category, Member, and PaymentMethod. These are simpler entities than Product — they have basic CRUD operations and no complex relationships.

## Goals
- Create Category service interface → `OfflineCategoryService` + `OnlineCategoryService` + `CategoryRepository`
- Create Member service interface → `OfflineMemberService` + `OnlineMemberService` + `MemberRepository`
- Create PaymentMethod service interface → `OfflinePaymentMethodService` + `OnlinePaymentMethodService` + `PaymentMethodRepository`
- Each interface follows the same pattern as `ProductServiceInterface`:
  - `getAll()` / `getById()` / `create()` / `update()` / `delete()`
  - Offline implementations use Isar CRUD with `isLocal=true` for creates
  - Online implementations try API first, cache to Isar, fall back to cache
  - Repositories delegate based on `AppModeService.to.isOnline`

## Notes
- `CategoryService` currently returns `RxList<CategoryResponse>` — the offline interface should return `List<OfflineCategory>` instead
- `MemberService` supports query params via `MemberRequest` — the offline implementation should filter by `name` and `code` using Isar filters
- `PaymentMethodService` is read-only in the current codebase (only `get()`) — the offline implementation only needs `getAll()` for now, but we add `create`/`update`/`delete` stubs for completeness
- Payment methods are seeded with defaults for offline users (Cash, Debit, Credit, E-Wallet) — this is handled by `RegisterOfflineUserScreen`, not the service
- The existing API service classes (`CategoryService`, `MemberService`, `PaymentMethodService`) remain and are used by the online implementations

## Tools / Skills
- Isar CRUD, API wrapping, Repository pattern

## Implementation
- Created `lib/offline/services/category_service_interface.dart`
  - Abstract class with: `getCategories()`, `getCategoryById(int id)`, `createCategory(OfflineCategory)`, `updateCategory(OfflineCategory)`, `deleteCategory(int id)`
  - All return types use `OfflineCategory` model
- Created `lib/offline/services/offline_category_service.dart`
  - `getCategories()`: `_isar.offlineCategorys.where().findAll()` (note: Isar generates `offlineCategorys` not `offlineCategories`)
  - `createCategory`: assigns negative ID, `isLocal=true`, `cachedAt=DateTime.now()`
  - `updateCategory`: `isLocal=true`, `cachedAt=DateTime.now()`
- Created `lib/offline/services/online_category_service.dart`
  - Wraps existing `CategoryService` imported `as api`
  - `getCategories()`: tries API fetch, caches via `_cacheCategories()`, falls back to Isar cache
  - `_cacheCategories()`: maps `CategoryResponse` → `OfflineCategory` (skips createdAt/updatedAt type mismatch: String vs DateTime?)
  - `createCategory`/`updateCategory`: try API call, `isLocal=false` on success, `isLocal=true` on failure
- Created `lib/offline/repositories/category_repository.dart`
  - Delegates based on `Get.find<AppModeService>().isOnline`

- Created `lib/offline/services/member_service_interface.dart`
  - Abstract class with: `getMembers({MemberRequest? request})`, `getMemberById(int id)`, `createMember(OfflineMember)`, `updateMember(OfflineMember)`, `deleteMember(int id)`
- Created `lib/offline/services/offline_member_service.dart`
  - `getMembers()`: supports name and code filtering via `.filter()`
  - `createMember`: negative ID, `isLocal=true`, `cachedAt=DateTime.now()`
- Created `lib/offline/services/online_member_service.dart`
  - Wraps existing `MemberService` imported `as api`
  - `_cacheMembers()`: maps `MemberResponse.id` → `OfflineMember.remoteId` (not the Isar autoIncrement ID)
  - Uses `List<MemberResponse>` instead of `RxList` in _cacheMembers to avoid unnecessary GetX dependency
- Created `lib/offline/repositories/member_repository.dart`
  - Delegates based on `Get.find<AppModeService>().isOnline`

- Created `lib/offline/services/payment_method_service_interface.dart`
  - Abstract class with: `getPaymentMethods()`, `getPaymentMethodById(int id)`, `createPaymentMethod(OfflinePaymentMethod)`, `updatePaymentMethod(OfflinePaymentMethod)`, `deletePaymentMethod(int id)`
- Created `lib/offline/services/offline_payment_method_service.dart`
  - Simple CRUD on Isar, same negative ID pattern
- Created `lib/offline/services/online_payment_method_service.dart`
  - Wraps existing `PaymentMethodService` imported `as api`
  - `createPaymentMethod`/`updatePaymentMethod`/`deletePaymentMethod`: no API endpoints exist — just saves to Isar with `isLocal=true`
  - `_cachePaymentMethods()`: maps `PaymentMethodRespone.id` → `OfflinePaymentMethod.remoteId` (preserving the class name typo from codebase)
- Created `lib/offline/repositories/payment_method_repository.dart`
  - Delegates based on `Get.find<AppModeService>().isOnline`